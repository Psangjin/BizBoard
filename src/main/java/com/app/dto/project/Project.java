package com.app.dto.project;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Project {
	private Long id;
	private String manager;
	private String title;
	private String content;
	private Timestamp startDt;
	private Timestamp endDt;
}
