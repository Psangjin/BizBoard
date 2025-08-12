package com.app.dto.project;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ScheduleWithProject {
    private Long id;
    private String title;
    private String type;
    private Timestamp startDt;
    private Timestamp endDt;
    private String completed;
    private String color;

    // Project details
    private Long projectId;
    private String projectTitle;
}
