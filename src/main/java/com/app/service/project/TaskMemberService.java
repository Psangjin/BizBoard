package com.app.service.project;

import java.util.List;

import com.app.dto.project.TaskMember;

public interface TaskMemberService {
	List<TaskMember> replaceMembers(Long scheduleId, List<TaskMember> members);
	List<TaskMember> findByScheduleId(Long scheduleId);
	 List<String> findUserIdsByTaskId(Long scheduleId);
}
