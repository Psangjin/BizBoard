package com.app.controller.project;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Project;
import com.app.dto.user.User;
import com.app.service.project.ProjectMemberService;

@RestController
public class ProjectRestController {
	
	@Autowired
	ProjectMemberService projectMemberService;

	@PostMapping("/project/setSession")
	public String setProjectSession(@RequestBody Project project, HttpSession session) {
	    session.setAttribute("project", project);
	    System.out.println(session.getAttribute("project"));
	    User user = (User)session.getAttribute("loginUser");
	    String loginUserRole = projectMemberService.findRoleByProjectAndUser(project.getId(), user.getId());
	    session.setAttribute("loginUserRole", loginUserRole);
	    return "success";
	}
}
