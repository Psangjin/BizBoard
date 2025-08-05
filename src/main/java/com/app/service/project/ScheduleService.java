package com.app.service.project;

import java.util.List;

import com.app.dto.project.Schedule;

public interface ScheduleService {

	int saveSchedule(Schedule schedule);
	
	List<Schedule> findAllSchedules();
	
	int deleteScheduleById(Long id);
	
	int modifySchedule(Schedule schedule);
}
