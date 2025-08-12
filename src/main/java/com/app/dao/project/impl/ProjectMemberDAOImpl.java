package com.app.dao.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.ProjectMemberDAO;
import com.app.dto.project.ProjectMember;

@Repository
public class ProjectMemberDAOImpl implements ProjectMemberDAO {

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<ProjectMember> findMembers(Long projectId) {
      return sqlSessionTemplate.selectList("projectMember_mapper.findMembersByProjectId", projectId);
    }

    @Override
    public boolean existsUserByEmail(String email) {
      Integer c = sqlSessionTemplate.selectOne("projectMember_mapper.existsUserByEmail", email);
      return c != null && c > 0;
    }

    @Override
    public boolean existsActiveMember(Long projectId, String email) {
      Map<String, Object> p = new HashMap<>();
      p.put("projectId", projectId);
      p.put("email", email);
      Integer c = sqlSessionTemplate.selectOne("projectMember_mapper.existsActiveMember", p);
      return c != null && c > 0;
    }

    @Override
    public int insertMember(Long projectId, String email, String role) {
      Map<String, Object> p = new HashMap<>();
      p.put("projectId", projectId);
      p.put("email", email);
      p.put("role", role);
      return sqlSessionTemplate.insert("projectMember_mapper.insertMemberByEmail", p);
    }

    @Override
    public int updateRole(Long projectId, String email, String role) {
      Map<String, Object> p = new HashMap<>();
      p.put("projectId", projectId);
      p.put("email", email);
      p.put("role", role);
      return sqlSessionTemplate.update("projectMember_mapper.updateRole", p);
    }

    @Override
    public int softRemove(Long projectId, String email) {
      Map<String, Object> p = new HashMap<>();
      p.put("projectId", projectId);
      p.put("email", email);
      return sqlSessionTemplate.update("projectMember_mapper.removeMember", p);
    }

	@Override
	public String findRoleByProjectAndUser(Long projectId, String userId) {
		
		Map<String, Object> params = new HashMap<>();
        params.put("projectId", projectId);
        params.put("userId", userId);
        String result = sqlSessionTemplate.selectOne("projectMember_mapper.findRoleByProjectAndUser", params);
		
		return result;
	}

	@Override
	public void insertProjectMemberAsAdmin(Long projectId, String userId) {
		Map<String, Object> params = new HashMap<>();
        params.put("projectId", projectId);
        params.put("userId", userId);
        sqlSessionTemplate.insert("projectMember_mapper.insertProjectMemberAsAdmin", params);
		
	}

}
