package com.app.dao.project;

import java.util.List;

import com.app.dto.project.Memo;

public interface MemoDAO {
	int insertMemo(Memo memo);
	int updateMemo(Memo memo);
	int deleteMemo(Long id);
	List<Memo> getMemosByProjectId(Long projectId);
}
