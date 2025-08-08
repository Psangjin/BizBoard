package com.app.controller.project;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.app.service.project.ProjectMemberService;

@Controller
public class ProjectController {
	
	@Autowired
	ProjectMemberService projectMemberService;
	
	@GetMapping("/project/main")
	public String projectMain(@RequestParam(defaultValue = "0") Long projectId, Model model) {
		 model.addAttribute("projectId", projectId);
	     model.addAttribute("projectMemberList", projectMemberService.getMembers(projectId));
		return "project/projectMain";
	}
	
	
	@GetMapping("/project/schedule")
	public String projectSchedule(Model model) {
		  model.addAttribute("projectId", 1);  // ✅ 이게 핵심
		return "project/schedule";
	}
	
	@GetMapping("/project/gantt")
	public String projectGantt() {
		return "project/gantt";
	}
	
	@GetMapping("/project/memo")
	public String  projectMemo(Model model) {
		 model.addAttribute("projectId", 0);  // ✅ 이게 핵심
		 model.addAttribute("loginUser", "id1");  // ✅ 이게 핵심
		return "project/memo";
	}
	
	@GetMapping("/project/user")
	public String projectUser() {
		return "project/user";
	}
	
	@GetMapping("/project/newProject")
	public String  newProject() {
		return "project/newProject";
	}
}
