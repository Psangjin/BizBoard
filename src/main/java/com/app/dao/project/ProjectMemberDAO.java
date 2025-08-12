package com.app.dao.project;

import java.util.List;
import com.app.dto.project.ProjectMember;

public interface ProjectMemberDAO {
	 List<ProjectMember> findMembers(Long projectId);
	  boolean existsUserByEmail(String email);
	  boolean existsActiveMember(Long projectId, String email);
	  int insertMember(Long projectId, String email, String role);
	  int updateRole(Long projectId, String email, String role);
	  int softRemove(Long projectId, String email);
}
