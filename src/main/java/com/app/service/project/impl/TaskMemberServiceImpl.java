package com.app.service.project.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

//✅ 이걸로 통일
import org.springframework.transaction.annotation.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.TaskMemberDAO;
import com.app.dto.project.TaskMember;
import com.app.service.project.TaskMemberService;

//Service impl (네가 보낸 그대로 + findByScheduleId)
@Service
public class TaskMemberServiceImpl implements TaskMemberService {
	@Autowired TaskMemberDAO taskMemberDAO;

	@Transactional(rollbackFor = Exception.class)
	@Override
	public List<TaskMember> replaceMembers(Long scheduleId, List<TaskMember> members) {
	    taskMemberDAO.deleteByScheduleId(scheduleId);
	    if (members != null && !members.isEmpty()) {
	        Set<String> seen = new HashSet<>();
	        List<TaskMember> cleaned = new ArrayList<>();
	        for (TaskMember m : members) {
	            if (m == null || m.getUserId() == null) continue;
	            String uid = m.getUserId().trim();
	            if (uid.isEmpty()) continue;
	            if (seen.add(uid)) {
	                m.setId(null);
	                m.setScheduleId(scheduleId);
	                cleaned.add(m);
	            }
	        }
	        if (!cleaned.isEmpty()) {
	            // 배치 대신 단일 insert 반복 호출 예시
	            for (TaskMember tm : cleaned) {
	                taskMemberDAO.insertSingle(scheduleId, tm.getUserId(), tm.getName());
	            }
	        }
	    }
	    return taskMemberDAO.findByScheduleId(scheduleId);
	}
	
	@Override
	public List<TaskMember> findByScheduleId(Long scheduleId) {
	   return taskMemberDAO.findByScheduleId(scheduleId);
	}

	@Override
	public List<String> findUserIdsByTaskId(Long scheduleId) {
		return taskMemberDAO.findUserIdsByTaskId(scheduleId);
	}
}



