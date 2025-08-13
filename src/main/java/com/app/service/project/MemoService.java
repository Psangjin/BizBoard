package com.app.service.project;

import java.util.List;

import com.app.dto.project.Memo;

public interface MemoService {
	int insertMemo(Memo memo);
	int updateMemo(Memo memo);
	int deleteMemo(Long id);
	List<Memo> getMemosByProjectId(Long projectId,String order);
}
