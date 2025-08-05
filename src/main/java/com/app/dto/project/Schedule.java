package com.app.dto.project;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Schedule {
	private Long id;
	private String title;
	private String content;
	private String type; //'IP':개인일정, 'PP':공유일정, 'PW':프로젝트 작업
	private Timestamp startDt;
	private Timestamp endDt;
	private String completed; // 'Y' 또는 'N'
	private String color;
	
}
