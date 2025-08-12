package com.app.service.project;

import java.util.List;
import java.util.Map;

import com.app.dto.project.Schedule;
import com.app.dto.project.ScheduleWithProject;

public interface ScheduleService {

	int saveSchedule(Schedule schedule);
	
	List<Schedule> findSchedulesByProjectId(Long projectId);
	
	int deleteScheduleById(Long id);
	
	int modifySchedule(Schedule schedule);

	int  findMaxScheduleId();
	
	List<Schedule> selectSchedulesByUserAndProject(String userId, Long projectId);
	
	 Map<String, List<ScheduleWithProject>> getUserSchedulesAndTasks(String userId);
}
