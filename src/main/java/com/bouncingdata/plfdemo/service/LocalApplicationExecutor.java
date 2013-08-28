package com.bouncingdata.plfdemo.service;


import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.ServletContextAware;

import com.bouncingdata.plfdemo.datastore.pojo.dto.DatasetDetail;
import com.bouncingdata.plfdemo.datastore.pojo.dto.ExecutionResult;
import com.bouncingdata.plfdemo.datastore.pojo.dto.VisualizationDetail;
import com.bouncingdata.plfdemo.datastore.pojo.dto.VisualizationType;
import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.AnalysisDataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.BcDataScript;
import com.bouncingdata.plfdemo.datastore.pojo.model.Dataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.Scraper;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.datastore.pojo.model.Visualization;
import com.bouncingdata.plfdemo.util.Utils;

public class LocalApplicationExecutor implements ApplicationExecutor,
		ServletContextAware {

	private Logger logger = LoggerFactory
			.getLogger(LocalApplicationExecutor.class);

	private String logDir;
	private String storePath;
	private String scaledImageWidth;
	private String scaledImageHeight;
	
	

	

	@Autowired
	private DatastoreService datastoreService;

	@Autowired
	private ApplicationStoreService appStoreService;

	private ServletContext servletContext;

	public void setLogDir(String ld) {
		this.logDir = ld;
	}

	public void setStorePath(String sp) {
		this.storePath = sp;
	}

	@Override
	public void setServletContext(ServletContext sc) {
		this.servletContext = sc;
	}

	@Override
	public ExecutionResult executePython(BcDataScript app, String code,
			User user) throws Exception {
		// get execution ticket
		final String ticket = Utils.getExecutionId();

		String mode = "persistent";
		if (app == null || app instanceof Analysis) {
			mode = "not-persistent";
		}

		String[] args = new String[] { ticket, user.getUsername(), mode };
		ProcessBuilder pb = new ProcessBuilder("python", "-c", code, args[0],
				args[1], args[2]);
		pb.redirectErrorStream(true);

		String output = null;
		int exitCode = 0;
		try {
			logger.info(
					"Starting the execution {}, requested user {}, appId: {}",
					new Object[] { ticket, user.getUsername(),
							app == null ? "-1" : app.getId() });
			final Process p = pb.start();
			Timer t = new Timer();
			t.schedule(new TimerTask() {
				@Override
				public void run() {
					try {
						p.exitValue();
					} catch (IllegalThreadStateException e) {
						logger.info(
								"Killed the execution {}. Reason: process too long.",
								ticket);
						p.destroy();
					}
					this.cancel();
				}
			}, 1000 * 60 * 2);

			InputStream appOutputStream = new BufferedInputStream(
					p.getInputStream());
			int c;
			StringBuilder outputBuilder = new StringBuilder();
			byte[] b = new byte[1024];
			try {
				while ((c = appOutputStream.read(b)) != -1) {
					String chunk = new String(b, 0, c);
					outputBuilder.append(chunk);
				}
			} catch (IOException e) {
				// the stream maybe closed due to timeout or unknown error
				logger.debug(
						"Exception occurs when reading output stream from execution {}. Maybe the process has been terminated.",
						ticket);
				return new ExecutionResult(ticket, "Execution terminated.", 0,
						0, 1, "error");
			}
			output = outputBuilder.toString();
			try {
				exitCode = p.exitValue();
			} catch (IllegalThreadStateException e) {
				p.destroy();
				t.cancel();
				exitCode = 1;
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		int datasetCount = dataPostScraperProcess(ticket, app, user, output);
		int visCount = 0;
		if (app instanceof Analysis) {
			// copy visuals from log dir to visualizations dir
			try {
				visCount = processVisualizations(ticket, (Analysis) app);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return new ExecutionResult(ticket, output, visCount, datasetCount, 0,
				"OK");

	}

	@Override
	public ExecutionResult executeR(BcDataScript app, String code, User user)
			throws Exception {
		final String ticket = Utils.getExecutionId();
		String tempFile = logDir + Utils.FILE_SEPARATOR + ticket
				+ Utils.FILE_SEPARATOR + ticket + ".R";
		File temp = new File(tempFile);
		try {
			if (!temp.getParentFile().isDirectory()) {
				temp.getParentFile().mkdirs();
			}

			BufferedWriter writer = new BufferedWriter(new FileWriter(temp));
			writer.write(code);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		String mode = "persistent";
		if (app == null || app instanceof Analysis) {
			mode = "not-persistent";
		}

		String[] args = new String[] { ticket, user.getUsername(), mode };
		ProcessBuilder pb = new ProcessBuilder("Rscript", tempFile, args[0],
				args[1], args[2]);
		if (!pb.environment().containsKey("R_DEFAULT_DEVICE")) {
			pb.environment().put("R_DEFAULT_DEVICE", "png");
		}
		pb.redirectErrorStream(true);
		pb.directory(temp.getParentFile());

		String output = null;
		int exitCode = 0;
		try {
			logger.info(
					"Starting the execution {}, requested user {}, appId: {}",
					new Object[] { ticket, user.getUsername(),
							app == null ? "-1" : app.getId() });
			final Process p = pb.start();
			Timer t = new Timer();
			t.schedule(new TimerTask() {
				@Override
				public void run() {
					try {
						p.exitValue();
					} catch (IllegalThreadStateException e) {
						logger.info(
								"Killed the execution {}. Reason: process too long.",
								ticket);
						p.destroy();
					}
					this.cancel();
				}
			}, 1000 * 60 * 2);

			InputStream appOutputStream = new BufferedInputStream(
					p.getInputStream());
			int c;
			StringBuilder outputBuilder = new StringBuilder();
			byte[] b = new byte[1024];
			try {
				while ((c = appOutputStream.read(b)) != -1) {
					String chunk = new String(b, 0, c);
					outputBuilder.append(chunk);
				}
			} catch (IOException e) {
				// the stream maybe closed due to timeout or unknown error
				logger.debug(
						"Exception occurs when reading output stream from execution {}. Maybe the process has been terminated.",
						ticket);
				return new ExecutionResult(ticket, "Execution terminated.", 0,
						0, 1, "error");
			}
			output = outputBuilder.toString();
			try {
				exitCode = p.exitValue();
			} catch (IllegalThreadStateException e) {
				p.destroy();
				t.cancel();
				exitCode = 1;
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		int datasetCount = dataPostProcess(ticket, app, user);
		int visualCount = 0;
		//
		if (app instanceof Analysis) {
			// copy visuals from log dir to visualizations dir
			try {
				visualCount = processVisualizations(ticket, (Analysis) app);
			} catch (Exception e) {
				logger.debug(
						"Error occurs when process visualization for analysis {}",
						app.getName());
				logger.debug("Exception detail", e);
			}
		}

		if (app == null) {
			// Map<String, VisualizationDetail> visuals =
			// getVisualizations(ticket);
			return new ExecutionResult(ticket, output, visualCount,
					datasetCount, 0, "OK");
		} else {
			return new ExecutionResult(ticket, output, visualCount,
					datasetCount, 0, "OK");
		}

	}

	/**
	 * Post-process phase for generated datasets from script execution
	 * 
	 * @param executionId
	 * @param script
	 * @param user
	 * @return the number of processed dataset
	 * @throws Exception
	 */
	private int dataPostProcess(String executionId, BcDataScript script,
			User user) throws Exception {
		String execLogPath = logDir + Utils.FILE_SEPARATOR + executionId;
		File execLogDir = new File(execLogPath);
		Map<String, DatasetDetail> datasets = null;
		ObjectMapper mapper = new ObjectMapper();

		if (script instanceof Analysis) {
			Analysis analysis = (Analysis) script;
			datasets = new HashMap<String, DatasetDetail>();
			List<AnalysisDataset> relations = new ArrayList<AnalysisDataset>();
			File scriptLocation = new File(storePath + Utils.FILE_SEPARATOR
					+ script.getGuid());

			try {
				File datasetOut = new File(execLogDir.getAbsolutePath()
						+ Utils.FILE_SEPARATOR + "dataset.out");
				if (datasetOut.isFile()) {
					String s = FileUtils.readFileToString(datasetOut);
					JsonNode dsLogNode = mapper.readTree(s);
					for (int i = 0; i < dsLogNode.size(); i++) {
						JsonNode dsNode = dsLogNode.get(i);
						String identifier = dsNode.get("name").getTextValue();
						Dataset dataset = datastoreService
								.getDatasetByName(identifier);
						if (dataset != null) {
							String dsGuid = dataset.getGuid();
							// create & persist new AnalysisDataset
							AnalysisDataset anlsDts = new AnalysisDataset(
									analysis, dataset, true);
							relations.add(anlsDts);
							datasets.put(dsGuid, new DatasetDetail(dsGuid,
									identifier, dataset.getRowCount(), null,
									null));
						}
					}
				}
			} catch (IOException e) {
				logger.debug("Failed to process dataset log.", e);
			}

			File[] attachmentFiles = execLogDir.listFiles(new FileFilter() {

				@Override
				public boolean accept(File pathname) {
					return pathname.getName().endsWith(".att");
				}
			});

			if (attachmentFiles != null) {
				for (File f : attachmentFiles) {
					try {
						String s = FileUtils.readFileToString(f);
						JsonNode rootNode = mapper.readTree(s);
						String identifier = rootNode.get("name").getTextValue();
						JsonNode data = rootNode.get("data");
						datasets.put(identifier, new DatasetDetail(identifier,
								identifier, data.size(), null, data.toString()));
						try {
							FileUtils.copyFile(
									f,
									new File(scriptLocation.getAbsoluteFile()
											+ Utils.FILE_SEPARATOR
											+ f.getName()));
						} catch (IOException e) {
							logger.debug("Failed to copy attachment file "
									+ f.getAbsolutePath() + " to "
									+ scriptLocation.getAbsolutePath());
						}
					} catch (Exception e) {
						logger.debug("Failed to process attachment log.", e);
					}
				}
			}

			datastoreService.invalidateDatasets(analysis);
			datastoreService.createAnalysisDatasets(relations);

		} else if (script instanceof Scraper) {
			Scraper scraper = (Scraper) script;
			datasets = new HashMap<String, DatasetDetail>();
			List<Dataset> dsList = new ArrayList<Dataset>();
			File dsLogFile = new File(execLogDir.getAbsolutePath()
					+ Utils.FILE_SEPARATOR + "dataset.inp");
			File scriptLocation = new File(storePath + Utils.FILE_SEPARATOR
					+ script.getGuid());
			if (dsLogFile.isFile()) {
				try {
					String s = FileUtils.readFileToString(dsLogFile);
					JsonNode dsLogNode = mapper.readTree(s);
					for (int i = 0; i < dsLogNode.size(); i++) {
						JsonNode dsNode = dsLogNode.get(i);
						String identifier = dsNode.get("name").getTextValue();
						Dataset ds = new Dataset();
						ds.setName(identifier);
						ds.setDescription(dsNode.get("description")
								.getTextValue());
						String guid = Utils.generateGuid();
						ds.setGuid(guid);
						ds.setSchema(dsNode.get("schema").getTextValue());
						ds.setUser(user);
						ds.setCreateAt(new Date());
						ds.setLastUpdate(new Date());
						ds.setScraper(scraper);
						ds.setRowCount(dsNode.get("size").getIntValue());
						ds.setActive(true);
						dsList.add(ds);
						datasets.put(guid, new DatasetDetail(guid,
								ds.getName(), ds.getRowCount(), null, null));
					}
				} catch (IOException e) {
					logger.debug("Failed to process dataset log.", e);
				}

				File[] attachmentFiles = execLogDir.listFiles(new FileFilter() {

					@Override
					public boolean accept(File pathname) {
						return pathname.getName().endsWith(".att");
					}
				});

				if (attachmentFiles != null) {
					for (File f : attachmentFiles) {
						try {
							String s = FileUtils.readFileToString(f);
							JsonNode rootNode = mapper.readTree(s);
							String identifier = rootNode.get("name")
									.getTextValue();
							JsonNode data = rootNode.get("data");
							datasets.put(identifier, new DatasetDetail(
									identifier, identifier, data.size(), null,
									data.toString()));
							try {
								FileUtils.copyFile(
										f,
										new File(scriptLocation
												.getAbsoluteFile()
												+ Utils.FILE_SEPARATOR
												+ f.getName()));
							} catch (IOException e) {
								logger.debug("Failed to copy attachment file "
										+ f.getAbsolutePath() + " to "
										+ scriptLocation.getAbsolutePath());
							}
						} catch (Exception e) {
							logger.debug("Failed to process attachment log.", e);
						}
					}
				}

				// invalidate old datasets?
				datastoreService.invalidateDataset(scraper);
				datastoreService.createDatasets(dsList);

			}

		} else if (script == null) {
			// temporarily ignore the anonymous script
			return 0;
		}

		return datasets.size();
	}

	/**
	 * Post-process phase for generated datasets from script execution
	 * 
	 * @param executionId
	 * @param script
	 * @param user
	 * @return the number of processed dataset
	 * @throws Exception
	 */
	private int dataPostScraperProcess(String executionId, BcDataScript script,
			User user, String dataScraper) throws Exception {
		String execLogPath = logDir + Utils.FILE_SEPARATOR + executionId;
		File execLogDir = new File(execLogPath);
		Map<String, DatasetDetail> datasets = null;
		ObjectMapper mapper = new ObjectMapper();
		dataScraper = "{u'date': u'08-01-2013', u'milliseconds_since_epoch': 1375343650484L, u'time': u'07:54:10 AM'}";
		if (script instanceof Scraper) {
			Scraper scraper = (Scraper) script;
			datasets = new HashMap<String, DatasetDetail>();
			List<Dataset> dsList = new ArrayList<Dataset>();
			File scriptLocation = new File(storePath + Utils.FILE_SEPARATOR
					+ script.getGuid());

			try {
				JsonNode dsLogNode = mapper.readTree(dataScraper);
				for (int i = 0; i < dsLogNode.size(); i++) {
					JsonNode dsNode = dsLogNode.get(i);
					String identifier = dsNode.get("name").getTextValue();
					Dataset ds = new Dataset();
					ds.setName(identifier);
					ds.setDescription(dsNode.get("description").getTextValue());
					String guid = Utils.generateGuid();
					ds.setGuid(guid);
					ds.setSchema(dsNode.get("schema").getTextValue());
					ds.setUser(user);
					ds.setCreateAt(new Date());
					ds.setLastUpdate(new Date());
					ds.setScraper(scraper);
					ds.setRowCount(dsNode.get("size").getIntValue());
					ds.setActive(true);
					dsList.add(ds);
					datasets.put(
							guid,
							new DatasetDetail(guid, ds.getName(), ds
									.getRowCount(), null, null));
				}
			} catch (IOException e) {
				logger.debug("Failed to process dataset log.", e);
			}

			File[] attachmentFiles = execLogDir.listFiles(new FileFilter() {

				@Override
				public boolean accept(File pathname) {
					return pathname.getName().endsWith(".att");
				}
			});

			if (attachmentFiles != null) {
				for (File f : attachmentFiles) {
					try {
						String s = FileUtils.readFileToString(f);
						JsonNode rootNode = mapper.readTree(s);
						String identifier = rootNode.get("name").getTextValue();
						JsonNode data = rootNode.get("data");
						datasets.put(identifier, new DatasetDetail(identifier,
								identifier, data.size(), null, data.toString()));
						try {
							FileUtils.copyFile(
									f,
									new File(scriptLocation.getAbsoluteFile()
											+ Utils.FILE_SEPARATOR
											+ f.getName()));
						} catch (IOException e) {
							logger.debug("Failed to copy attachment file "
									+ f.getAbsolutePath() + " to "
									+ scriptLocation.getAbsolutePath());
						}
					} catch (Exception e) {
						logger.debug("Failed to process attachment log.", e);
					}
				}
			}

			// invalidate old datasets?
			datastoreService.invalidateDataset(scraper);
			datastoreService.createDatasets(dsList);

		} else if (script == null) {
			// temporarily ignore the anonymous script
			return 0;
		}

		return datasets.size();
	}

	/**
	 * Post-process phase of visualizations
	 * 
	 * @param executionId
	 * @param anls
	 * @return the number of processed visualizations
	 * @throws Exception
	 */
	private int processVisualizations(String executionId, Analysis anls)
			throws Exception {
		datastoreService.invalidateViz(anls);

		String execLogPath = logDir + Utils.FILE_SEPARATOR + executionId;
		File execLogDir = new File(execLogPath);
		File[] vsFiles = execLogDir.listFiles(new FileFilter() {

			@Override
			public boolean accept(File pathname) {
				if (pathname.isFile()
						&& (pathname.getName().endsWith(".png") || pathname
								.getName().endsWith(".html"))) {
					return true;
				} else
					return false;
			}
		});

		// for the new "canvas", we get only the lastest visualization file

		long lastModified = Long.MIN_VALUE;
		File last = null;
		for (File f : vsFiles) {
			if (f.lastModified() > lastModified) {
				lastModified = f.lastModified();
				last = f;
			}
		}

		if (last != null)
			vsFiles = new File[] { last };

		File vDir = new File(storePath + Utils.FILE_SEPARATOR + anls.getGuid()
				+ Utils.FILE_SEPARATOR + "v");
		if (vDir.isDirectory()) {
			vDir.delete();
		}

		vDir.mkdirs();

		boolean makeThumb = false;
		int count = 0;
		if (vsFiles != null) {
			for (File f : vsFiles) {
				String filename = f.getName();
				Visualization v = new Visualization();

				String name = filename.substring(0, filename.lastIndexOf("."));
				String extension = filename
						.substring(filename.lastIndexOf(".") + 1);
				VisualizationType type = null;
				File snapshot = null;
				if ("png".equals(extension)) {
					type = VisualizationType.PNG;
					snapshot = new File(f.getParent() + Utils.FILE_SEPARATOR
							+ name + ".snapshot");
				} else if ("html".equals(extension))
					type = VisualizationType.HTML;

				v.setAnalysis(anls);
				v.setUser(anls.getUser());
				v.setName(name);
				v.setType(type.getType());
				String guid = Utils.generateGuid();
				v.setGuid(guid);
				v.setActive(true);
				datastoreService.createVisualization(v);
/*
 * No need to make thumbnail
				if (!makeThumb && type == VisualizationType.PNG) {
					// create thumbnail
					BufferedImage img = ImageIO.read(f);
					int thumbnailsWidth = Integer.parseInt(this.scaledImageWidth);
					int thumbnailsHeight = Integer.parseInt(this.scaledImageHeight);
					
					BufferedImage thumbnail = Scalr.resize(img,Scalr.Method.QUALITY, Scalr.Mode.FIT_EXACT, thumbnailsWidth, thumbnailsHeight,
							  Scalr.OP_ANTIALIAS); 					
					
					ImageIO.write(img, "png", new File(servletContext.getRealPath("/thumbnails") + Utils.FILE_SEPARATOR + anls.getGuid() + ".jpg"));
					makeThumb = true;
					anls.setThumbnail(anls.getGuid());
					datastoreService.updateAnalysis(anls);
				}
*/
				anls.setThumbnail(anls.getGuid());
				datastoreService.updateAnalysis(anls);
				
				
				try {
					FileUtils.copyFile(
							f,
							new File(vDir.getAbsoluteFile()
									+ Utils.FILE_SEPARATOR + guid + "."
									+ type.getType()));
					if (type == VisualizationType.PNG && snapshot.isFile()) {
						FileUtils.copyFile(snapshot,
								new File(vDir.getAbsoluteFile()
										+ Utils.FILE_SEPARATOR + guid
										+ ".snapshot"));

						BufferedImage img = ImageIO.read(f);
						double ratio = img.getWidth() / img.getHeight();

						// replay snapshot
						appStoreService.resizeRPlot(anls.getGuid(), guid, 600,
								(int) (600 / ratio));
					}
					count++;
				} catch (IOException e) {
					logger.debug("Failed to copy visual file "
							+ f.getAbsolutePath() + " to "
							+ vDir.getAbsolutePath());
				}

			}

			if (!makeThumb) {
				//
			}
		}
		return count;
	}

	private Map<String, VisualizationDetail> getVisualizations(
			String executionId) {
		String execLogPath = logDir + Utils.FILE_SEPARATOR + executionId;
		File execLogDir = new File(execLogPath);
		File[] vsFiles = execLogDir.listFiles(new FileFilter() {

			@Override
			public boolean accept(File pathname) {
				if (pathname.isFile()
						&& (pathname.getName().endsWith(".png") || pathname
								.getName().endsWith(".html"))) {
					return true;
				} else
					return false;
			}
		});

		Map<String, VisualizationDetail> visuals = null;
		if (vsFiles != null) {
			visuals = new HashMap<String, VisualizationDetail>();
			for (File f : vsFiles) {
				String filename = f.getName();
				String name = filename.substring(0, filename.lastIndexOf("."));
				String extension = filename
						.substring(filename.lastIndexOf(".") + 1);
				VisualizationType type = null;
				if ("png".equals(extension))
					type = VisualizationType.PNG;
				else if ("html".equals(extension)) {
					type = VisualizationType.HTML;
					visuals.put(name, new VisualizationDetail(null,
							"visualize/temp/" + executionId + "/" + name
									+ "/html", type));
					continue;
				}

				int length = (int) f.length();
				byte[] bytes = new byte[length];
				try {
					bytes = FileUtils.readFileToByteArray(f);
					visuals.put(name, new VisualizationDetail(null, new String(
							Base64.encodeBase64(bytes)), type));
				} catch (IOException e) {
					logger.debug("Failed to read visualization at {}",
							f.getAbsoluteFile());
				}

			}
		}
		return visuals;
	}

	public static void main(String[] jargs) {
		File file = new File("/home/khiem/r/testArgs.R");
		String[] args = new String[] { "111", "khiem", "non-persistent" };
		ProcessBuilder pb = new ProcessBuilder("Rscript",
				file.getAbsolutePath(), args[0], args[1], args[2]);
		if (!pb.environment().containsKey("R_DEFAULT_DEVICE")) {
			pb.environment().put("R_DEFAULT_DEVICE", "png");
		}
		pb.redirectErrorStream(true);
		pb.directory(file.getParentFile());

		String output = null;
		/* read the console output */
		try {
			Process p = pb.start();
			InputStream appOutputStream = new BufferedInputStream(
					p.getInputStream());
			int c;
			StringBuilder out = new StringBuilder();
			byte[] b = new byte[1024];
			while ((c = appOutputStream.read(b)) != -1) {
				String chunk = new String(b, 0, c);
				out.append(chunk);
			}
			output = out.toString();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println(output);
	}

	public String getScaledImageWidth() {
		return scaledImageWidth;
	}

	public void setScaledImageWidth(String scaledImageWidth) {
		this.scaledImageWidth = scaledImageWidth;
	}
	public String getScaledImageHeight() {
		return scaledImageHeight;
	}

	public void setScaledImageHeight(String scaledImageHeight) {
		this.scaledImageHeight = scaledImageHeight;
	}
}
