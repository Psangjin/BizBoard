package com.app.dao.project.impl;

import java.util.List;

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
		
		int result = sqlSessionTemplate.insert("project_mapper.createProject", project);
		
		return result;
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

}
