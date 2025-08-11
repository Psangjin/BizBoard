package com.app.dao.project.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.ScheduleDAO;
import com.app.dto.project.Schedule;

@Repository
public class ScheduleDAOImpl implements ScheduleDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int saveSchedule(Schedule schedule) {
		
		int result = sqlSessionTemplate.insert("schedule_mapper.saveSchedule", schedule);
		
		return result;
	}

	@Override
	public List<Schedule> findSchedulesByProjectId(Long projectId) {
		
		List<Schedule> allSchedules = sqlSessionTemplate.selectList("schedule_mapper.findSchedulesByProjectId",projectId);
		
		return allSchedules;
	}

	@Override
	public int deleteScheduleById(Long id) {
		
		int result = sqlSessionTemplate.delete("schedule_mapper.deleteScheduleById", id);
		
		return result;
	}

	@Override
	public int modifySchedule(Schedule schedule) {
		
		int result = sqlSessionTemplate.update("schedule_mapper.modifySchedule", schedule);
		
		return result;
	}

	@Override
	public int findMaxScheduleId() {
		 int result = sqlSessionTemplate.selectOne("schedule_mapper.findMaxScheduleId");
		return result;
	}

	@Override
	public Schedule selectById(Long id) {
		return sqlSessionTemplate.selectOne("schedule_mapper.selectById",id);
	}

}
