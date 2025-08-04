package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Schedule;

public interface ScheduleDAO {
	
	int saveSchedule(Schedule schedule);
	
	List<Schedule> findAllSchedules();
	
	int deleteScheduleById(Long id);
	
	int modifySchedule(Schedule schedule);
}
