package com.app.dto.project;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Inform {
 private Long informId;
    private String type;       // PROJECT_EVENT | TASK_EVENT | NOTICE_EVENT
    private String title;      // 표시용 제목
    private String message;    // 요약 메시지
    private Timestamp occurredAt;
    private boolean read;
}
