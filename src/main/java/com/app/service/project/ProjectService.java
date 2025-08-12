package com.app.service.project;

import java.util.List;

import com.app.dto.project.Project;

public interface ProjectService {

	int createProject(Project project);
	
	List<Project> findAllProjects();
	
	Project findProjectById(Long projectId);
	
	List<Project> findProjectsByUserId(String userId);
	
	void updateProject(Project updated, String actorUserId);
	
	int deleteProject(Long id);
}
