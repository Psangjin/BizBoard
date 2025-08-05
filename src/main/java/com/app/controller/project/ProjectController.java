package com.app.controller.project;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProjectController {

	
	@GetMapping("/project/main")
	public String projectMain() {
		return "project/projectMain";
	}
	
	
	@GetMapping("/project/schedule")
	public String projectSchedule() {
		return "project/schedule";
	}
}
