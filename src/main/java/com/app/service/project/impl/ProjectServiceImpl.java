package com.app.service.project.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.ProjectDAO;
import com.app.dto.project.Project;
import com.app.service.project.ProjectService;

@Service
public class ProjectServiceImpl implements ProjectService {

	@Autowired
	ProjectDAO projectDAO;

	@Override
	public int createProject(Project project) {
		
		int result = projectDAO.createProject(project);
		
		return result;
	}

	@Override
	public List<Project> findAllProjects() {
		
		List<Project> allProjects = projectDAO.findAllProjects();
		
		return allProjects;
	}

	@Override
	public Project findProjectById(Long projectId) {
		
		Project project = projectDAO.findProjectById(projectId);
		
		return project;
	}
	
}
