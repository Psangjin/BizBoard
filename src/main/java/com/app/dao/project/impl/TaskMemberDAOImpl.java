package com.app.dao.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.TaskMemberDAO;
import com.app.dto.project.TaskMember;

@Repository
public class TaskMemberDAOImpl implements TaskMemberDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int deleteByScheduleId(Long scheduleId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("scheduleId", scheduleId);
	    return sqlSessionTemplate.delete("taskMember_mapper.deleteByScheduleId", param);
	}

	@Override
	public int insertTaskMemberBatch(Long scheduleId, List<TaskMember> list) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("scheduleId", scheduleId);
	    param.put("list", list);
	    return sqlSessionTemplate.insert("taskMember_mapper.insertTaskMemberBatch", param);
	}

	@Override
	public List<TaskMember> findByScheduleId(Long scheduleId) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("scheduleId", scheduleId);
	    return sqlSessionTemplate.selectList("taskMember_mapper.findByScheduleId", param);
	}

	@Override
	public List<String> findUserIdsByTaskId(Long scheduleId) {
		return sqlSessionTemplate.selectList("taskMember_mapper.findUserIdsByTaskId",scheduleId);
	}

	@Override
	public int insertSingle(Long scheduleId, String userId, String name) {
		Map<String, Object> param = new HashMap<>();
	    param.put("scheduleId", scheduleId);
	    param.put("userId", userId);
	    param.put("name", name);
	    return sqlSessionTemplate.insert("taskMember_mapper.insertSingle", param);
	}


	
	
	

}
