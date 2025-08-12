package com.app.dto.project;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class TaskComment {
	  private Long id;
	    private Long scheduleId;
	    private String userId;
	    private String title;
	    private String description;
	    private String filePath;
	    private Timestamp writeTime;  // ✅ Timestamp로 변경
}
