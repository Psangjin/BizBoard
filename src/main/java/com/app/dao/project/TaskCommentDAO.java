package com.app.dao.project;

import java.util.List;

import com.app.dto.project.TaskComment;

public interface TaskCommentDAO {
	List<TaskComment> listByScheduleId(Long scheduleId);
	TaskComment get(Long id);
	int insert(TaskComment taskComment);
	int update(TaskComment taskComment);
	int delete(Long id);
	int deleteByScheduleId(Long scheduleId);
}
