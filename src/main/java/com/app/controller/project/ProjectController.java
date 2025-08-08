package com.app.controller.project;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.app.dto.user.User;

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
	
	@GetMapping("/project/gantt")
	public String projectGantt() {
		return "project/gantt";
	}
	
	@GetMapping("/project/memo")
	public String  projectMemo() {
		return "project/memo";
	}
	
	@GetMapping("/project/newProject")
	public String  newProject() {
		return "project/newProject";
	}
}
