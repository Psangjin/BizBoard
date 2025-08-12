package com.app.service.project.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.TaskCommentDAO;
import com.app.dto.project.TaskComment;
import com.app.service.project.TaskCommentService;

@Service
public class TaskCommentServiceImpl implements TaskCommentService {
	
	@Autowired
	TaskCommentDAO taskCommentDAO;

	@Override
	public List<TaskComment> list(Long scheduleId) {
		return taskCommentDAO.listByScheduleId(scheduleId);
	}

	@Override
	public void add(TaskComment taskComment) {
		taskCommentDAO.insert(taskComment);
	}

	@Override
	public void edit(TaskComment taskComment) {
		taskCommentDAO.update(taskComment);
	}

	@Override
	public void remove(Long id) {
		taskCommentDAO.delete(id);
	}

	@Override
	public void removeBySchedule(Long scheduleId) {
		taskCommentDAO.deleteByScheduleId(scheduleId);
	}

}
