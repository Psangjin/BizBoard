package com.app.dao.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.ProjectDAO;
import com.app.dto.project.Project;

@Repository
public class ProjectDAOImpl implements ProjectDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int createProject(Project project) {
		
		return  sqlSessionTemplate.insert("project_mapper.createProject", project);
	}

	@Override
	public List<Project> findAllProjects() {
		
		List<Project> allProjects = sqlSessionTemplate.selectList("project_mapper.findAllProjects");
		
		return allProjects;
	}

	@Override
	public Project findProjectById(Long projectId) {
		
		Project project = sqlSessionTemplate.selectOne("project_mapper.findProjectById", projectId);
		
		return project;
	}

	@Override
	public List<Project> findProjectsByUserId(String userId) {
		
		List<Project> projectList = sqlSessionTemplate.selectList("project_mapper.findProjectsByUserId", userId);
		return projectList;
	}

	@Override
	public int countNumberofScheduleByProjectId(Long projectId, String type) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("projectId", projectId);
		paramMap.put("type", type);
		int cnt = sqlSessionTemplate.selectOne("project_mapper.countNumberofScheduleByProjectId", paramMap);
		
		return cnt;
	}
	
	@Override
	public int countNumberofScheduleDoneByProjectId(Long projectId, String type) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("projectId", projectId);
		paramMap.put("type", type);
		int cnt = sqlSessionTemplate.selectOne("project_mapper.countNumberofScheduleDoneByProjectId", paramMap);
		
		return cnt;
	}
	public int updateProject(Project project) {
		return sqlSessionTemplate.update("project_mapper.updateProject",project);
	}

	@Override
	public int deleteProject(Long id) {
		return sqlSessionTemplate.delete("project_mapper.deleteProject",id);
	}

	@Override
	public boolean isAdmin(Long projectId, String userId) {
		 Map<String, Object> param = new HashMap<>();
		    param.put("projectId", projectId);
		    param.put("userId", userId);

		    Integer n = sqlSessionTemplate.selectOne("ProjectMapper.isAdmin", param); // ← 네임스페이스.id
		    return n != null && n == 1;
	}

}
