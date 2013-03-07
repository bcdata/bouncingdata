package com.bouncingdata.plfdemo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class FileUploadController {
@RequestMapping(value="/upload",method=RequestMethod.GET)
public String uploadFile(ModelMap model){
	return "upload";
}
}
