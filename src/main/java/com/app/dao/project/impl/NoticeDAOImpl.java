package com.app.dao.project.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.NoticeDAO;
import com.app.dto.project.Notice;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Notice> listByProjectId(Long projectId) {
		return sqlSessionTemplate.selectList("notice_mapper.listByProjectId",projectId);
	}

	@Override
	public Long insert(Notice notice) {
	    int rows = sqlSessionTemplate.insert("notice_mapper.insert", notice); // rows == 1
	    return notice.getId(); // selectKey가 채워준 PK 반환
	}

	@Override
	public int update(Notice notice) {
		return sqlSessionTemplate.update("notice_mapper.update",notice);
	}

	@Override
	public int delete(Long id) {
		return sqlSessionTemplate.delete("notice_mapper.delete",id);
	}

	@Override
	public Notice getById(Long id) {
		return sqlSessionTemplate.selectOne("notice_mapper.getById",id);
	}
	
}
