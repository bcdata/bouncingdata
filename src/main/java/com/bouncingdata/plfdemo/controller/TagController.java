package com.bouncingdata.plfdemo.controller;

import java.security.Principal;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bouncingdata.plfdemo.datastore.pojo.dto.ActionResult;
import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.Dataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.Scraper;
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.service.DatastoreService;

@Controller
@RequestMapping(value = "/tag")
public class TagController {

  private Logger logger = LoggerFactory.getLogger(AnalysisController.class);

  @Autowired
  private DatastoreService datastoreService;

  @RequestMapping(value = "/{tag}", method = RequestMethod.GET)
  public String getTagPage(@PathVariable String tag, ModelMap model) {
    Tag t = datastoreService.getTag(tag);
    if (t == null) {
      model.addAttribute("errorMsg", "Tag \"" + tag + "\" does not exist.");
      return "error";
    }

    List<Analysis> analyses = datastoreService.getAnalysesByTag(tag);
    model.addAttribute("anlsList", analyses);
    model.addAttribute("tag", tag);
    model.addAttribute("menuId", tag);
    return "tag";
  }
  
  @RequestMapping(value = "/addtag", method = RequestMethod.POST)
  public @ResponseBody ActionResult addTag(@RequestParam(value="guid", required=true) String guid, 
      @RequestParam(value="tag", required = true) String tag, @RequestParam(value="type", required=true) String type,
      ModelMap model, Principal principal) throws Exception {
    
    User user = (User) ((Authentication) principal).getPrincipal();
    if (!"analysis".equals(type) && !"scraper".equals(type) && !"dataset".equals(type)) {
      return new ActionResult(-1, "Unknown type");
    }
    
    if ("analysis".equals(type)) {
      Analysis anls = datastoreService.getAnalysisByGuid(guid);
      if (anls == null) {
        return new ActionResult(-1, "Error: Analysis does not exist");
      }
      
      if (!user.getUsername().equals(anls.getUser().getUsername())) {
        return new ActionResult(-1, "Error: User does not have permission to add tag");
      }
      
      Tag tagObj = datastoreService.getTag(tag);
      if (tagObj == null) {
        logger.debug("Tag {} does not exist. Trying create new tag.", tag);
        try {
          datastoreService.createTag(tag);
          tagObj = datastoreService.getTag(tag);     
        } catch (Exception e) {
          logger.debug("Failed to create new tag {}", tag);
          logger.debug("", e);
          return new ActionResult(-1, "Failed to create new tag");
        }
      }
      
      datastoreService.addAnalysisTag(anls.getId(), tagObj.getId());
      return new ActionResult(0, "OK");
    }
    
    if ("dataset".equals(type)) {
      Dataset dataset = datastoreService.getDatasetByGuid(guid);
      if (dataset == null) return new ActionResult(-1, "Dataset does not exist");
      
      if (!user.getUsername().equals(dataset.getUser().getUsername())) {
        return new ActionResult(-1, "Error: User does not have permission to add tag");
      }
      
      Tag tagObj = datastoreService.getTag(tag);
      if (tagObj == null) {
        logger.debug("Tag {} does not exist. Trying create new tag.", tag);
        try {
          datastoreService.createTag(tag);
          tagObj = datastoreService.getTag(tag);     
        } catch (Exception e) {
          logger.debug("Failed to create new tag {}", tag);
          logger.debug("", e);
          return new ActionResult(-1, "Failed to create new tag");
        }
      }
      
      datastoreService.addDatasetTag(dataset.getId(), tagObj.getId());
      return new ActionResult(0, "OK");
      
    }
    
    if ("scraper".equals(type)) {
      /*Scraper scraper = datastoreService.getScraperByGuid(guid);
      if (scraper == null) return new ActionResult(-1, "Scraper does not exist");
      
      Tag tagObj = datastoreService.getTag(tag);
      if (tagObj == null) {
        logger.debug("Tag {} does not exist. Trying create new tag.", tag);
        try {
          datastoreService.createTag(tag);
          tagObj = datastoreService.getTag(tag);     
        } catch (Exception e) {
          logger.debug("Failed to create new tag {}", tag);
          logger.debug("", e);
          return new ActionResult(-1, "Failed to create new tag");
        }
      }*/
      
      
    }
    
    return new ActionResult(-1, "No support for scraper now");
  }

}
