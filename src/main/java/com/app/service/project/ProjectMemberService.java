package com.app.service.project;

import java.util.List;

import com.app.dto.project.ProjectMember;

public interface ProjectMemberService {
	  List<ProjectMember> getMembers(Long projectId);
	  void invite(Long projectId, String email, String role);
	  void changeRole(Long projectId, String email, String role);
	  void remove(Long projectId, String email);
}
