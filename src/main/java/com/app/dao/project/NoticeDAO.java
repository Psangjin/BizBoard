package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Notice;

public interface NoticeDAO {
	List<Notice> listByProjectId(Long projectId);
	Long insert(Notice notice);
	int update(Notice notice);
	int delete(Long id);
	Notice getById(Long id);
}
