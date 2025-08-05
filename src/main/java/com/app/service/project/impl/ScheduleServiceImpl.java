package com.app.service.project.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.ScheduleDAO;
import com.app.dto.project.Schedule;
import com.app.service.project.ScheduleService;

@Service
public class ScheduleServiceImpl implements ScheduleService{

	@Autowired
	ScheduleDAO scheduleDAO;
	
	@Override
	public int saveSchedule(Schedule schedule) {
		
		int result = scheduleDAO.saveSchedule(schedule);
		
		return result;
	}

	@Override
	public List<Schedule> findAllSchedules() {
		
		List<Schedule> allSchedule = scheduleDAO.findAllSchedules();
		
		return allSchedule;
	}

	@Override
	public int deleteScheduleById(Long id) {
		
		int result = scheduleDAO.deleteScheduleById(id);
		
		return result;
	}

	@Override
	public int modifySchedule(Schedule schedule) {
		
		int result = scheduleDAO.modifySchedule(schedule);
		
		return result;
	}

}
