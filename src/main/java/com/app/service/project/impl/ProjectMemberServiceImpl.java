package com.app.service.project.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.ProjectMemberDAO;
import com.app.dto.project.ProjectMember;
import com.app.service.project.ProjectMemberService;

@Service
public class ProjectMemberServiceImpl implements ProjectMemberService {

	@Autowired
	ProjectMemberDAO projectMemberDAO;
	
	 public List<ProjectMember> getMembers(Long projectId) {
	        return projectMemberDAO.findMembers(projectId);
	    }

	 public void invite(Long projectId, String email, String role) {
		    if (!projectMemberDAO.existsUserByEmail(email)) {
		      throw new IllegalArgumentException("존재하지 않는 사용자 이메일입니다.");
		    }
		    if (projectMemberDAO.existsActiveMember(projectId, email)) {
		      throw new IllegalStateException("이미 참가중인 사용자입니다.");
		    }
		    if (projectMemberDAO.insertMember(projectId, email, role) != 1) {
		      throw new IllegalStateException("초대(추가) 실패");
		    }
		  }

		  public void changeRole(Long projectId, String email, String role) {
		    if (projectMemberDAO.updateRole(projectId, email, role) != 1) {
		      throw new IllegalStateException("권한 변경 실패");
		    }
		  }

		  public void remove(Long projectId, String email) {
		    if (projectMemberDAO.softRemove(projectId, email) != 1) {
		      throw new IllegalStateException("강퇴 실패(소유자/미가입/이미 제거)");
		    }
		  }

		  @Override
		  public String findRoleByProjectAndUser(Long projectId, String userId) {
			String result = projectMemberDAO.findRoleByProjectAndUser(projectId, userId);
			return result;
		  }

		  @Override
		  public void insertProjectMemberAsAdmin(Long projectId, String userId) {
			projectMemberDAO.insertProjectMemberAsAdmin(projectId, userId);
			
		  }

}
