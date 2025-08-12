package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Project;
import com.app.dto.user.User;

public interface ProjectDAO {

	int createProject(Project project);
	
	List<Project> findAllProjects();
	
	Project findProjectById(Long projectId);
	
	List<Project> findProjectsByUserId(String userId);
	
	int updateProject(Project project);
	
	int deleteProject(Long id);
	
	boolean isAdmin(Long projectId,String userId);
}
