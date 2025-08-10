package com.app.dao.project;

import java.util.List;

import com.app.dto.project.TaskMember;

public interface TaskMemberDAO {
	  int deleteByScheduleId(Long scheduleId);
	  int insertTaskMemberBatch(Long scheduleId,List<TaskMember> list);
	  List<TaskMember> findByScheduleId(Long scheduleId);
	  List<String> findUserIdsByTaskId(Long scheduleId);
}
