package com.bouncingdata.plfdemo.controller;

import java.io.IOException;
import java.util.Date;
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
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.service.ApplicationExecutor;
import com.bouncingdata.plfdemo.service.ApplicationStoreService;
import com.bouncingdata.plfdemo.service.DatastoreService;
import com.bouncingdata.plfdemo.util.Utils;

@Controller
@RequestMapping("/public/ide")
public class IDEController {

	@Autowired
	private ApplicationStoreService appStoreService;

	@Autowired
	private DatastoreService datastoreService;

	@Autowired
	private ApplicationExecutor appExecutor;

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
				
		String uploadFailed = "Upload failed";
		String executeFailed = "Execution failed";

		String ret = uploadFailed;

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
				ret = uploadFailed;
		}

		catch (Exception e) {
			logger.warn("Analysis publishing exception", e);
			ret = executeFailed;
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
}