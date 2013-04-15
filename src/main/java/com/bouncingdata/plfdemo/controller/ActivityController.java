package com.bouncingdata.plfdemo.controller;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

import com.bouncingdata.plfdemo.datastore.pojo.model.Activity;
import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.Dataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.datastore.pojo.model.UserActionLog;
import com.bouncingdata.plfdemo.service.DatastoreService;

@Controller
public class ActivityController {
  
  private Logger logger = LoggerFactory.getLogger(ActivityController.class);
  
  @Autowired
  private DatastoreService datastoreService;
  
  @RequestMapping(value={"/stream"}, method=RequestMethod.GET)
  public String getActivityStream(WebRequest request, ModelMap model, Principal principal) {
    try {    
      String filter = request.getParameter("filter");
      if (StringUtils.isEmpty(filter)) filter = "all";
      
      if (!Arrays.asList(new String[] {"all", "analysis", "dataset", "recent", "popular"}).contains(filter)) {
        return "error";
      }
      
      User user = (User) ((Authentication)principal).getPrincipal();
      
      try {
        ObjectMapper logmapper = new ObjectMapper();
        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
      } catch (Exception e) {
        logger.debug("Failed to log action", e);
      }
      
      List<Activity> activities = datastoreService.getRecentFeed(user.getId());
      model.addAttribute("activities", activities);
      
      List<Analysis> mostRecentAnalyses = datastoreService.getMostRecentAnalyses();
      model.addAttribute("recentAnalyses", mostRecentAnalyses);
      
      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
      model.addAttribute("topAnalyses", mostPopularAnalyses);
      
      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
      model.addAttribute("topDatasets", mostPopularDatasets);
    } catch (Exception e) {
      logger.debug("Failed to load activity stream", e);
      model.addAttribute("errorMsg", "Failed to load the activity stream");
    }
    return "stream";
  }
  
  @RequestMapping(value="/a/more/{lastId}", method=RequestMethod.GET)
  public @ResponseBody List<Analysis> getMoreActivities(@PathVariable int lastId, ModelMap model, Principal principal) {
    try {
      User user = (User) ((Authentication)principal).getPrincipal();
      try{
	      ObjectMapper logmapper = new ObjectMapper();
	      String data = logmapper.writeValueAsString(new String[] {"1",Integer.toString(lastId)});		   	 
	      datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_MORE_ACTIVITY,data);
      }catch (Exception e) {
          logger.debug("Failed to log action", e);
        }
      List<Analysis> analyses = datastoreService.getMoreRecentAnalyses(lastId);
      return analyses;
    } catch (Exception e) {
      logger.debug("Failed to load more activity", e);
      return null;
    }
  }

  /*
   * Vinhpq: Adding function for top and left menu
   */
  @RequestMapping(value={"/tags"}, method=RequestMethod.GET)
  public String get10TopTags(WebRequest request, ModelMap model, Principal principal) {
	  
	  try {
		  User user = (User) ((Authentication)principal).getPrincipal();
	      
	      try {
	        ObjectMapper logmapper = new ObjectMapper();
	        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
	        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
	      } catch (Exception e) {
	        logger.debug("Failed to log action", e);
	      }
		  
	      List<Tag> top10Tags = datastoreService.get10Tags();
	      model.addAttribute("_tags", top10Tags);
	      
	      //---
	      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
	      model.addAttribute("topAnalyses", mostPopularAnalyses);
	      
	      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
	      model.addAttribute("topDatasets", mostPopularDatasets);
	      
	  } catch (Exception e) {
	      logger.debug("Failed to load activity stream", e);
	      model.addAttribute("errorMsg", "Failed to load the activity stream");
      
	  }
	  return "tags";
  }
  
  @RequestMapping(value={"/streambyself"}, method=RequestMethod.GET)
  public String getActivityStreamBySelf(WebRequest request, ModelMap model, Principal principal) {
    try {    
      String filter = request.getParameter("filter");
      if (StringUtils.isEmpty(filter)) filter = "all";
      
      if (!Arrays.asList(new String[] {"all", "analysis", "dataset", "recent", "popular"}).contains(filter)) {
        return "error";
      }
      
      User user = (User) ((Authentication)principal).getPrincipal();
      
      try {
        ObjectMapper logmapper = new ObjectMapper();
        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
      } catch (Exception e) {
        logger.debug("Failed to log action", e);
      }
      
      List<Analysis> allAnalysesBySelf = datastoreService.getAllAnalysesBySelf(user.getId());
      model.addAttribute("recentAnalyses", allAnalysesBySelf);

//      List<Dataset> allDatasetsBySelf = datastoreService.getAllDatasetsBySelf(user.getId());
//      model.addAttribute("topDatasets", allDatasetsBySelf);
      
      //---
      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
      model.addAttribute("topAnalyses", mostPopularAnalyses);
      
      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
      model.addAttribute("topDatasets", mostPopularDatasets);
      
    } catch (Exception e) {
      logger.debug("Failed to load activity stream", e);
      model.addAttribute("errorMsg", "Failed to load the activity stream");
    }
    return "stream";
  }
  
  @RequestMapping(value={"/streamall"}, method=RequestMethod.GET)
  public String getActivitystreamall(WebRequest request, ModelMap model, Principal principal) {
    try {    
      String filter = request.getParameter("filter");
      if (StringUtils.isEmpty(filter)) filter = "all";
      
      if (!Arrays.asList(new String[] {"all", "analysis", "dataset", "recent", "popular"}).contains(filter)) {
        return "error";
      }
      
      User user = (User) ((Authentication)principal).getPrincipal();
      
      try {
        ObjectMapper logmapper = new ObjectMapper();
        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
      } catch (Exception e) {
        logger.debug("Failed to log action", e);
      }
      
      List<Analysis> allAnalyses = datastoreService.getAllAnalysesPublished();
      model.addAttribute("recentAnalyses", allAnalyses);

//      List<Dataset> allDatasets = datastoreService.getAllDatasetsPublished();
//      model.addAttribute("topDatasets", allDatasets);
      
      //---
      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
      model.addAttribute("topAnalyses", mostPopularAnalyses);
      
      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
      model.addAttribute("topDatasets", mostPopularDatasets);
      
    } catch (Exception e) {
      logger.debug("Failed to load activity stream", e);
      model.addAttribute("errorMsg", "Failed to load the activity stream");
    }
    return "stream";
  }
  
  @RequestMapping(value={"/staffpicks"}, method=RequestMethod.GET)
  public String getstaffpicks(WebRequest request, ModelMap model, Principal principal) {
    try {    
      String filter = request.getParameter("filter");
      if (StringUtils.isEmpty(filter)) filter = "all";
      
      if (!Arrays.asList(new String[] {"all", "analysis", "dataset", "recent", "popular"}).contains(filter)) {
        return "error";
      }
      
      User user = (User) ((Authentication)principal).getPrincipal();
      
      try {
        ObjectMapper logmapper = new ObjectMapper();
        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
      } catch (Exception e) {
        logger.debug("Failed to log action", e);
      }
      
      List<Analysis> allAnalyses = datastoreService.getAnalysesStaffPick();
      model.addAttribute("recentAnalyses", allAnalyses);

//      List<Dataset> allDatasets = datastoreService.getAllDatasetsPublished();
//      model.addAttribute("topDatasets", allDatasets);
      
      //---
      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
      model.addAttribute("topAnalyses", mostPopularAnalyses);
      
      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
      model.addAttribute("topDatasets", mostPopularDatasets);
      
    } catch (Exception e) {
      logger.debug("Failed to load activity stream", e);
      model.addAttribute("errorMsg", "Failed to load the activity stream");
    }
    return "stream";
  }
  
  @RequestMapping(value={"/popularAuthors"}, method=RequestMethod.GET)
  public String getPopularAuthors(WebRequest request, ModelMap model, Principal principal) {
    
	  try {    
	      String filter = request.getParameter("filter");
	      if (StringUtils.isEmpty(filter)) filter = "all";
	      
	      if (!Arrays.asList(new String[] {"all", "analysis", "dataset", "recent", "popular"}).contains(filter)) {
	        return "error";
	      }
	      
	      User user = (User) ((Authentication)principal).getPrincipal();
	      
	      try {
	        ObjectMapper logmapper = new ObjectMapper();
	        String data = logmapper.writeValueAsString(new String[] {"0"});		   	 
	        datastoreService.logUserAction(user.getId(),UserActionLog.ActionCode.GET_ACTIVITY_STREAM,data);
	      } catch (Exception e) {
	        logger.debug("Failed to log action", e);
	      }
	     
	      List<Analysis> mostPopularAnalyses = datastoreService.getMostPopularAnalyses();
	      model.addAttribute("topAnalyses", mostPopularAnalyses);
	      
	      List<Dataset> mostPopularDatasets = datastoreService.getMostPopularDatasets();
	      model.addAttribute("topDatasets", mostPopularDatasets);
	      
	    } catch (Exception e) {
	      logger.debug("Failed to load activity stream", e);
	      model.addAttribute("errorMsg", "Failed to load the activity stream");
	    }
	  
    return "author";
  }
  
}
