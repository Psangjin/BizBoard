package com.app.dao.project.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.TaskCommentDAO;
import com.app.dto.project.TaskComment;

@Repository
public class TaskCommentDAOImpl implements TaskCommentDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<TaskComment> listByScheduleId(Long scheduleId) {
		return sqlSessionTemplate.selectList("taskComment_mapper.listByScheduleId",scheduleId);
	}

	@Override
	public TaskComment get(Long id) {
		return sqlSessionTemplate.selectOne("taskComment_mapper.get",id);
	}

	@Override
	public int insert(TaskComment taskComment) {
		return sqlSessionTemplate.insert("taskComment_mapper.insert",taskComment);
	}

	@Override
	public int update(TaskComment taskComment) {
		return sqlSessionTemplate.update("taskComment_mapper.update",taskComment);
	}

	@Override
	public int delete(Long id) {
		return sqlSessionTemplate.delete("taskComment_mapper.delete",id);
	}

	@Override
	public int deleteByScheduleId(Long scheduleId) {
		return sqlSessionTemplate.delete("taskComment_mapper.deleteByScheduleId",scheduleId);
	}
	
}
