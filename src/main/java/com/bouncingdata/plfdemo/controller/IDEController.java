package com.bouncingdata.plfdemo.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.bouncingdata.plfdemo.datastore.pojo.dto.ExecutionResult;
import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.BcDataScript;
import com.bouncingdata.plfdemo.datastore.pojo.model.Dataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.service.ApplicationExecutor;
import com.bouncingdata.plfdemo.service.ApplicationStoreService;
import com.bouncingdata.plfdemo.service.BcDatastoreService;
import com.bouncingdata.plfdemo.service.DatastoreService;
import com.bouncingdata.plfdemo.util.Utils;
import com.bouncingdata.plfdemo.util.dataparsing.DataParser;
import com.bouncingdata.plfdemo.util.dataparsing.DataParserFactory;
import com.bouncingdata.plfdemo.util.dataparsing.DatasetColumn;
import com.bouncingdata.plfdemo.util.dataparsing.DataParserFactory.FileType;

@Controller
@RequestMapping("/public/ide")
public class IDEController {

	@Autowired
	private ApplicationStoreService appStoreService;

	@Autowired
	private DatastoreService datastoreService;

	@Autowired
	private ApplicationExecutor appExecutor;

	@Autowired
	private BcDatastoreService  userDataService;

	private static final int ERR_NONE = 0;
	private static final int ERR_UPLOAD_FAILED = 1;
	private static final int ERR_PARSING_FAILED = 2;
	private static final int ERR_INSERT_TO_DB_FAILED = 3;
	private static final int ERR_EXECUTE_FAILED = 4;

	private Logger  logger = LoggerFactory.getLogger(IDEController.class);

	//Testing controller
	@RequestMapping(value={"/test_publish"}, method = RequestMethod.POST)
	public @ResponseBody String yatc(@RequestParam("file1") MultipartFile file,  @RequestParam("user") String user) {
		String ret = "Ret";

		if(file.isEmpty()) {
			logger.warn("File data empty");
		}
		else {
			logger.warn("File name: " + file.getName());
			try {
				String fileContent = new String(file.getBytes());
				logger.warn("File content:" + fileContent);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return ret;
	}

	@RequestMapping(value={"/publish"}, method = RequestMethod.POST)
	public @ResponseBody String uploadAnalysis(@RequestParam("file1") MultipartFile file
			,  @RequestParam(value = "user", required= true) String userName
			,  @RequestParam(value = "title", required = false) String title
			,  @RequestParam(value = "description", required = false) String description) {

		String ret = errorCode2ErrorMessage(ERR_UPLOAD_FAILED);
		try {			
			// Parse the request to get file item.
			if(!file.isEmpty()) {
				title = (title != null) ? title : file.getOriginalFilename();
				description = (description != null) ? description : "";

				//TODO Verify this post is a new post or an update of an existed one
				boolean isNewScript = true;
				BcDataScript script = null;

				//Load or generate script
				String code = new String(file.getBytes());
				User user = datastoreService.findUserByUsername(userName);
				String language = "r";
				String guid;

				if(isNewScript) {
					boolean isPublic = false;
					Set<Tag> tagSet = null;
					script = genBcDataScript(title, description, language, code, isPublic, tagSet, user);

					//Because of historical reasons, we have to persist script into DB immediately. Any solution ?
					guid = datastoreService.createBcDataScript(script, script.getType());
					script = datastoreService.getAnalysisByGuid(guid);
				}
				else {
					//TODO
					guid = script.getGuid();
				}

				//Execute script
				ExecutionResult result = appExecutor.executeR(script, code, user);
				script.setLastOutput(result.getOutput());

				//If execution succeeds,  store analysis files and persist analysis into DB
				if( !isNewScript) {
					datastoreService.updateBcDataScript(script);
				}
				appStoreService.createApplicationFile(guid, language, code);
				ret = guid;
			}
			else 
				ret = errorCode2ErrorMessage(ERR_UPLOAD_FAILED);
		}
		catch (Exception e) {
			logger.warn("Analysis publishing exception", e);
			ret = errorCode2ErrorMessage(ERR_EXECUTE_FAILED);
		} 
		return ret;
	}

	private BcDataScript genBcDataScript( String scriptName, String description, String language, String code, boolean isPublic, Set<Tag> tagSet, User user) {
		BcDataScript script;
		script = new Analysis();
		script.setType("analysis");
		script.setName(scriptName);
		script.setDescription(description);
		script.setLanguage(language);
		script.setLineCount(Utils.countLines(code));
		script.setPublished(isPublic);
		script.setTags(tagSet);
		Date date = Utils.getCurrentDate();
		script.setCreateAt(date);
		script.setLastUpdate(date);
		script.setUser(user);
		script.setExecuted(false);
		script.setCreateSource("remote");
		return script;
	}

	@RequestMapping(value={"/publish_dataset"}, method = RequestMethod.POST)
	public @ResponseBody String uploadDataSet(@RequestParam("file1") MultipartFile file
			,	@RequestParam(value = "user", required= true) String userName
			,	@RequestParam(value = "firstRowAsHeader", required = false) String firstRowAsHeader
			,	@RequestParam(value = "delimiter", required = false) String delimiter
			,	@RequestParam(value = "title", required = true) String datasetName
			,	@RequestParam(value = "description", required = false) String datasetDescription
			,	@RequestParam(value = "tags", required = false) String tags) {

		//TODO Log user action ?

		int err = checkUploadFile(file);
		if(err != ERR_NONE) {
			return errorCode2ErrorMessage(err);
		}

		List<DatasetColumn> datasetColumns = new ArrayList<DatasetColumn>();
		List<String[]> dataRows = new ArrayList<String[]>();
		err = parseDatasetSchema(file, firstRowAsHeader, delimiter, dataRows, datasetColumns);
		if(err != ERR_NONE) {
			return errorCode2ErrorMessage(err);
		}

		StringBuffer datasetGuid = new StringBuffer();

		err = persistDatasetToDB(userName, datasetName, datasetDescription, tags
				, datasetColumns
				, dataRows
				, datasetGuid);
		if(err != ERR_NONE) {
			return errorCode2ErrorMessage(err);
		}

		return datasetGuid.toString();
	}

	private String errorCode2ErrorMessage(int err) {
		String ret = null;
		switch (err) {
		case ERR_NONE:
			ret = "NONE";
			break;
		case ERR_UPLOAD_FAILED:
			ret = "Upload failed";// , "Execution failed""
			break;
		case ERR_PARSING_FAILED:
			ret = "Parsing failed";
			break;
		case ERR_INSERT_TO_DB_FAILED:
			ret = "Insert to DB failed";
			break;
		case ERR_EXECUTE_FAILED:
			ret = "Execution failed";
			break;
		default:
			break;
		}
		return ret;
	}

	private int checkUploadFile(MultipartFile file) {
		return (file != null && file.getSize() > 0) ? ERR_NONE : ERR_UPLOAD_FAILED;
	}

	private int parseDatasetSchema(MultipartFile file
			,	String firstRowAsHeader
			,	String delimiter
			,	List<String[]> dataRows
			,	List<DatasetColumn> datasetColumns) {

		try {
			String filename = file.getOriginalFilename();
			int index = filename.lastIndexOf(".");
			String type = filename.substring(index + 1);
			filename = filename.substring(0, index);

			// parse the schema
			DataParser parser;
			if (type.equals("xls") || type.equals("xlsx")) {
				parser = DataParserFactory.getDataParser(FileType.EXCEL);
			} else if (type.equals("txt")) {
				parser = DataParserFactory.getDataParser(FileType.TEXT);
			} else if (type.equals("csv")) {
				parser = DataParserFactory.getDataParser(FileType.CSV);
			} else {
				return ERR_PARSING_FAILED;
			}

			//TODO Deal with firstRowAsHeader ?

			List<Object[]> objectArrays= parser.parse(file.getInputStream());

			//vinhpq : remove empty rows
			int lengthRow = (objectArrays.size() > 0 ? objectArrays.get(0).length : 0);

			for(Object[] row : objectArrays) {
				int emptyCell = 0;
				for (int i = 0; i < lengthRow; i++) {
					if(row[i].equals("")){
						emptyCell++;
					}
				}
				if(emptyCell < lengthRow) {
					String[] rowStr = (String[]) row;
					dataRows.add(rowStr);
				}
			}

			List<DatasetColumn> columns = parser.parseSchema(file.getInputStream());
			datasetColumns.addAll(columns);
		}
		catch(Exception e) {
			logger.warn("Exception occured in parsing data set schema", e);
			return ERR_PARSING_FAILED;
		}
		return ERR_NONE;		
	}

	private int persistDatasetToDB(String userName, String datasetName, String datasetDescription, String tags
			, List<DatasetColumn> columnsList
			, List<String[]> data
			, StringBuffer outputGUID) {

		User user = datastoreService.findUserByUsername(userName);
		String dsFName = user.getUsername() + "." + datasetName;
		String guid = Utils.generateGuid();

		try {
			DatasetColumn[] columnsArray = columnsList.toArray(new DatasetColumn[columnsList.size()]);

			String datasetSchema = userDataService.buildSchema(dsFName, columnsArray);		
			//Insert to DB bcdatastore
			userDataService.storeData(dsFName, columnsArray, data.subList(1, data.size()));

			//Insert to DB bouncingdata
			Dataset ds = genDataset(user, datasetDescription, dsFName, data, guid, datasetSchema);
			datastoreService.createDataset(ds);

			//add tag
			if(tags != null)
				for (String tagItem : tags.split("[,]+")) {
					if(tagItem.trim()== null || tagItem.trim()== "")
						break;

					Tag tagObj = datastoreService.getTag(tagItem);
					if (tagObj == null) {
						logger.debug(
								"Tag {} does not exist. Trying create new tag.",
								tagItem);
						try {
							datastoreService.createTag(tagItem);
							tagObj = datastoreService.getTag(tagItem);
						} catch (Exception e) {
							logger.debug("Failed to create new tag {}", tagItem);
							logger.debug("", e);					
						}
					}
					datastoreService.addDatasetTag(ds.getId(), tagObj.getId());
				}
		} catch (Exception e) {
			logger.warn("Failed to store datafile to datastore as ", e);
			return ERR_INSERT_TO_DB_FAILED;
		}
		outputGUID.setLength(0);
		outputGUID.append(guid);
		return ERR_NONE;		
	}

	private Dataset genDataset(User user, String datasetDescription, String dsFName
			,	List<String[]> data
			,	String guid
			,	String datasetSchema) {
		Dataset ds = new Dataset();
		ds.setUser(user);
		ds.setActive(true);
		Date timestamp = new Date();
		ds.setCreateAt(timestamp);
		ds.setLastUpdate(timestamp);
		ds.setDescription(datasetDescription);
		ds.setName(dsFName);
		ds.setScraper(null);
		ds.setRowCount(data.size() - 1);
		ds.setGuid(guid);
		ds.setSchema(datasetSchema);
		ds.setPublic(false);
		return ds;
	}
}
