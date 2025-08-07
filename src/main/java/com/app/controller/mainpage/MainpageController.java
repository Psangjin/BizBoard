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
}
