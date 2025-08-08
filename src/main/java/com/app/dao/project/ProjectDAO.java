package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Project;

public interface ProjectDAO {

	int createProject(Project project);
	
	List<Project> findAllProjects();
	
	Project findProjectById(Long projectId);
}
