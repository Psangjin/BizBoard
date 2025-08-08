package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Project;

public interface ProjectDAO {

	int createProject(Project project);
	
	List<Project> findAllProjects();
	
	
	List<Project> findMyProjects(String userId);		// 내가 작성한 프로젝트 목록 조회
	
    List<Project> findParticipatedProjects(String userId);		// 참여중인 프로젝트 목록 조회
}
