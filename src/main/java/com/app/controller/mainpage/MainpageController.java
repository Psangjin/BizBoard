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
	
	@RequestMapping("/service")
	public String service() {
		return "service/service";
	}
}
