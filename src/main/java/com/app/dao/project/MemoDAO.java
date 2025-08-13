package com.app.dao.project;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.app.dto.project.Memo;

public interface MemoDAO {
	int insertMemo(Memo memo);
	int updateMemo(Memo memo);
	int deleteMemo(Long id);
	List<Memo> selectByProjectId(@Param("projectId") Long projectId,
            @Param("order") String order);

}
