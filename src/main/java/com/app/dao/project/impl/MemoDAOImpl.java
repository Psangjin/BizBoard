package com.app.dao.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.MemoDAO;
import com.app.dto.project.Memo;

@Repository
public class MemoDAOImpl implements MemoDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int insertMemo(Memo memo) {
		int result = sqlSessionTemplate.insert("memo_mapper.insertMemo",memo);
		return result;
	}

	@Override
	public int updateMemo(Memo memo) {
		int result = sqlSessionTemplate.update("memo_mapper.updateMemo",memo);
		return result;
	}

	@Override
	public int deleteMemo(Long id) {
		int result = sqlSessionTemplate.delete("memo_mapper.deleteMemo",id);
		return result;
	}

	@Override
	public List<Memo> selectByProjectId(Long projectId, String order) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("projectId", projectId);
	    params.put("order", order); // "asc" 또는 "desc"
	    return sqlSessionTemplate.selectList("memo_mapper.selectByProjectId", params);
	}


}
