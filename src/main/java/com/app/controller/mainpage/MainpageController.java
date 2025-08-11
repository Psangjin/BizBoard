package com.app.controller.mainpage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainpageController {
	
	@RequestMapping("/")
	public String mainPage() {
		return "mainpage/mainpage-logout";
	}
	
	@RequestMapping("/mainpage")
	public String mainPage_login() {
		return "mainpage/mainpage-login";
	}

	@RequestMapping("/admin")
	public String admin() {
		return "admin/admin";
	}
	
	@RequestMapping("/pricing")
	public String pricing() {
		return "pricing/pricing";
	}
	@RequestMapping("/inquiryFAQ")
	public String inquiryFAQ() {
		return "inquiry/inquiryFAQ";

	}
	@RequestMapping("/inquiryOne")
	public String inquiryOne() {
		return "inquiry/inquiryOne";

	}
/*	@RequestMapping("/project/{projectId}")
	public String showProjectDetail(@PathVariable int projectId, HttpSession session) {
	    Project project = projectService.getProject(projectId);
	    if (project == null || !project.isMember(session.getAttribute("loggedInUser"))) {
	        return "error/errorScreen"; 
	    }
	    return "project/projectDetail";
	}  */
}
