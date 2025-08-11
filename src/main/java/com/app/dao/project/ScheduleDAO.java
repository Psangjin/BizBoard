package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Schedule;

public interface ScheduleDAO {
	
	int saveSchedule(Schedule schedule);
	
	List<Schedule> findSchedulesByProjectId(Long projectId);
	
	int deleteScheduleById(Long id);
	
	int modifySchedule(Schedule schedule);
	
	int  findMaxScheduleId();
	
	List<Schedule> selectSchedulesByUserAndProject(String userId, Long projectId);
}
