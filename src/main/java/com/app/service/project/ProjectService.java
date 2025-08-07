package com.app.service.project;

import java.util.List;

import com.app.dto.project.Project;

public interface ProjectService {

	int createProject(Project project);
	
	List<Project> findAllProjects();
}
