package com.app.service.project.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.NoticeDAO;
import com.app.dto.project.Notice;
import com.app.service.project.NoticeService;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	NoticeDAO noticeDAO;

	@Override
	public List<Notice> listByProjectId(Long projectId) {
		return noticeDAO.listByProjectId(projectId);
	}

	@Override
	public Long insert(Notice notice) {
		return noticeDAO.insert(notice);
	}

	@Override
	public int update(Notice notice) {
		return noticeDAO.update(notice);
	}

	@Override
	public int delete(Long id) {
		return noticeDAO.delete(id);
	}

	@Override
	public Notice getById(Long id) {
		return noticeDAO.getById(id);
	}
	
	
}
