package com.bouncingdata.plfdemo.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.service.DatastoreService;

@Controller
@RequestMapping(value = "/tag")
public class TagController {

  private Logger           logger = LoggerFactory.getLogger(AnalysisController.class);

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
    return "tag";
  }

}
