package com.app.controller.project;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Project;
import com.app.dto.user.User;
import com.app.service.project.ProjectMemberService;
import com.app.service.project.ProjectService;

@RestController
public class ProjectRestController {
	
	@Autowired
	ProjectMemberService projectMemberService;

	@Autowired
	ProjectService projectService;

	@PostMapping("/project/setSession")
	public String setProjectSession(@RequestBody Project project, HttpSession session) {
	    session.setAttribute("project", project);
	    System.out.println(session.getAttribute("project"));
	    User user = (User)session.getAttribute("loginUser");
	    String loginUserRole = projectMemberService.findRoleByProjectAndUser(project.getId(), user.getId());
	    session.setAttribute("loginUserRole", loginUserRole);
	    return "success";
	}
	
	private String currentUserId(HttpSession session) {
	    User loginUser = (User) session.getAttribute("loginUser"); // 타입 캐스팅
	    if (loginUser == null) throw new RuntimeException("not logged in");
	    return loginUser.getId();                                  // ✅ 아이디만 반환
	}


	  @PostMapping("/project/update")
	  public ResponseEntity<Void> update(@RequestBody Project project, HttpSession session) {
	    String actor = currentUserId(session);
	    projectService.updateProject(project, actor);   // ← 여기서 inform & inform_receiver 생성
	    return ResponseEntity.ok().build();
	  }
	  
	// ProjectRestController.java

	  @PostMapping("/project/delete/{id}")
	  public ResponseEntity<?> deleteProject(@PathVariable Long id, HttpSession session) {
	      // 1) 로그인 확인
	      User loginUser = (User) session.getAttribute("loginUser");
	      if (loginUser == null) {
	          return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("LOGIN_REQUIRED");
	      }

	      // 2) 존재 여부 확인
	      Project p = projectService.findProjectById(id);
	      if (p == null) {
	          return ResponseEntity.status(HttpStatus.NOT_FOUND).body("NOT_FOUND");
	      }

	      // 3) 권한 확인(프로젝트 매니저만 삭제 허용; 필요하면 Admin 로직 추가)
	      if (!loginUser.getId().equals(p.getManager())) {
	          return ResponseEntity.status(HttpStatus.FORBIDDEN).body("NO_PERMISSION");
	      }

	      // 4) 삭제
	      int rows = projectService.deleteProject(id);
	      if (rows == 1) return ResponseEntity.ok().build();
	      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("DELETE_FAILED");
	  }

}
