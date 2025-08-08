package com.app.service.project;

import java.util.List;

import com.app.dto.project.Project;

public interface ProjectService {

	int createProject(Project project);
	
	List<Project> findAllProjects();
	
	
	List<Project> getMyProjects(String userId);		// 내가 작성한 프로젝트
	
    List<Project> getParticipatedProjects(String userId);		// 참여중인 프로젝트
}
