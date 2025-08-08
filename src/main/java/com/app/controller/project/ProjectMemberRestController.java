package com.app.controller.project;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.service.project.ProjectMemberService;

@RestController
public class ProjectMemberRestController {

  @Autowired
  ProjectMemberService projectMemberService;

  @PostMapping("/project/member/invite")
  public ResponseEntity<?> invite(@RequestBody Map<String, Object> body) {
	  System.out.println("projectId param: " + body.get("projectId") 
	    + " / type: " + (body.get("projectId") == null ? "null" : body.get("projectId").getClass().getName()));

    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();
    String role    = body.get("role").toString();
    
    System.out.println("invite() projectId=" + projectId + ", email=" + email + ", role=" + role);

    projectMemberService.invite(projectId, email, role);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/project/member/role")
  public ResponseEntity<?> changeRole(@RequestBody Map<String, Object> body) {
    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();
    String role    = body.get("role").toString();
    
    
    System.out.println("[ROLE] projectId=" + projectId + ", email=" + email + ", role=" + role);
    
    projectMemberService.changeRole(projectId, email, role);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/project/member/remove")
  public ResponseEntity<?> remove(@RequestBody Map<String, Object> body) {
    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();
    
    System.out.println("[REMOVE] projectId=" + projectId + ", email=" + email);
    projectMemberService.remove(projectId, email);
    return ResponseEntity.ok().build();
  }
}
