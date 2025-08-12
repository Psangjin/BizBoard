package com.app.dto.project;

import lombok.Data;

@Data
public class TaskMember {
	private Long id;
	private Long scheduleId;
	private String userId;
	
	private String name;
}
