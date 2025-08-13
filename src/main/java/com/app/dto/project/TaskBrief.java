package com.app.dto.project;

import lombok.Data;

@Data
public class TaskBrief {
	 private Long projectId;
	  private String projectTitle;   // 프로젝트 제목
	  private Long scheduleId;
	  private String taskTitle;      // 작업(스케줄) 제목
}
