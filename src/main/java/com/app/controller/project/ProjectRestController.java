package com.app.controller.project;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Project;

@RestController
public class ProjectRestController {

	@PostMapping("/project/setSession")
	public String setProjectSession(@RequestBody Project project, HttpSession session) {
	    session.setAttribute("project", project);
	    System.out.println(session.getAttribute("project"));
	    return "success";
	}
}
