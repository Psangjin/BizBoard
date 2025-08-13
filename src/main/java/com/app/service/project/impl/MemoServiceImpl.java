package com.app.service.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.MemoDAO;
import com.app.dto.project.Memo;
import com.app.service.project.MemoService;

@Service
public class MemoServiceImpl implements MemoService {
	
	@Autowired
	MemoDAO memoDAO;
	
	@Override
	public int insertMemo(Memo memo) {
		int result = memoDAO.insertMemo(memo);
		return result;
	}

	@Override
	public int updateMemo(Memo memo) {
		int result = memoDAO.updateMemo(memo);
		return result;
	}

	@Override
	public int deleteMemo(Long id) {
		 System.out.println("🧨 Service 계층 도달: " + id);
		int result = memoDAO.deleteMemo(id);
		return result;
	}

	public List<Memo> getMemosByProjectId(Long projectId, String order) {
	    return memoDAO.selectByProjectId(projectId, order);
	}



}
