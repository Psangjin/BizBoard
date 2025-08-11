package com.app.dto.project;



import java.sql.Timestamp;

import lombok.Data;

@Data
public class Notice {
	private Long id;
    private Long projectId;
    private String userId;
    private String title;
    private String description;
    private Timestamp writeTime;
}
