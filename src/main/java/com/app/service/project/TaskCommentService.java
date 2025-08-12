package com.app.service.project;

import java.util.List;

import com.app.dto.project.TaskComment;

public interface TaskCommentService {
	List<TaskComment> list(Long scheduleId);
	void add(TaskComment taskComment);
	void edit(TaskComment taskComment);
	void remove(Long id);
	void removeBySchedule(Long scheduleId);
}
