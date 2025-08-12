package com.app.dto.project;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class ProjectMember {
	 private Long id;
	  private Long projectId;
	  private String userId;      // ← String 으로 변경
	  private String role;
	  private String status;
	  private Timestamp joinedAt;
	  private Timestamp leftAt;

	  // 표시용
	  private String name;
	  private String email;
}
