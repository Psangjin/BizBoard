package com.app.controller.project;

import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.dto.project.Project;   // ✅ 추가
import com.app.dto.user.User;
import com.app.service.project.ProjectMemberService;
import com.app.service.project.InformService;

@RestController
public class ProjectMemberRestController {

  @Autowired ProjectMemberService projectMemberService;
  @Autowired InformService informService;

  /** 로그인 사용자 ID (없으면 401) */
  private String requireLogin(HttpSession session) {
    User u = (User) session.getAttribute("loginUser");
    if (u == null) {
      throw new org.springframework.web.server.ResponseStatusException(
          org.springframework.http.HttpStatus.UNAUTHORIZED, "LOGIN_REQUIRED");
    }
    return u.getId();
  }

  /** 세션에서 프로젝트 제목 얻기: 없으면 #ID로 대체 */
  private String resolveProjectTitle(HttpSession session, Long projectId) {
    Project p = (Project) session.getAttribute("project");
    if (p != null && p.getId() != null && p.getId().equals(projectId) && p.getTitle() != null) {
      return p.getTitle();
    }
    return "프로젝트 #" + projectId; // fallback
  }

  @PostMapping("/project/member/invite")
  public ResponseEntity<?> invite(@RequestBody Map<String, Object> body, HttpSession session) {
    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();
    String role    = body.get("role").toString();

    String actorUserId = requireLogin(session);

    projectMemberService.invite(projectId, email, role);

    try {
      String title = resolveProjectTitle(session, projectId);
      String memo  = String.format("[%s] 프로젝트 참여자 초대: %s (%s)", title, email, role);
      boolean includeActor = false;
      informService.publishProjectEvent(projectId, actorUserId, memo, includeActor);
    } catch (Exception e) {
      e.printStackTrace();
    }

    return ResponseEntity.ok(Map.of("ok", true));
  }

  @PostMapping("/project/member/role")
  public ResponseEntity<?> changeRole(@RequestBody Map<String, Object> body, HttpSession session) {
    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();
    String role    = body.get("role").toString();

    String actorUserId = requireLogin(session);

    projectMemberService.changeRole(projectId, email, role);

    try {
      String title = resolveProjectTitle(session, projectId);
      String memo  = String.format("[%s] 프로젝트 역할 변경: %s → %s", title, email, role);
      boolean includeActor = false;
      informService.publishProjectEvent(projectId, actorUserId, memo, includeActor);
    } catch (Exception e) {
      e.printStackTrace();
    }

    return ResponseEntity.ok(Map.of("ok", true));
  }

  @PostMapping("/project/member/remove")
  public ResponseEntity<?> remove(@RequestBody Map<String, Object> body, HttpSession session) {
    Long projectId = Long.valueOf(body.get("projectId").toString());
    String email   = body.get("email").toString();

    String actorUserId = requireLogin(session);

    projectMemberService.remove(projectId, email);

    try {
      String title = resolveProjectTitle(session, projectId);
      String memo  = String.format("[%s] 프로젝트 참여자 제거: %s", title, email);
      boolean includeActor = false;
      informService.publishProjectEvent(projectId, actorUserId, memo, includeActor);
    } catch (Exception e) {
      e.printStackTrace();
    }

    return ResponseEntity.ok(Map.of("ok", true));
  }
}
