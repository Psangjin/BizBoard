package com.app.service.project.impl;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.InformDAO;
import com.app.dto.project.Inform;
import com.app.dto.project.TaskBrief;
import com.app.service.project.InformService;

@Service
public class InformServiceImpl implements InformService {
	
	@Autowired
	InformDAO informDAO;
	
	@Override
	public String getProjectTitle(Long projectId) {
	    return informDAO.selectProjectTitle(projectId); // 없으면 null 반환
	}

	@Override
    public List<Inform> findForUser(String userId, boolean onlyUnread) {
        return informDAO.selectForUser(userId, onlyUnread);
    }

    @Override
    public boolean markAsRead(String userId, Long informId) {
        return informDAO.updateRead(userId, informId) > 0;
    }

    @Override
    public Long publishProjectEvent(Long projectId, String actorUserId, String memo, boolean includeActor) {
        Long informId = insertInform("PROJECT_EVENT", safeMemo(memo));
        List<String> targets = pickProjectMembers(projectId, actorUserId, includeActor);
        saveReceivers(informId, targets);
        return informId;
    }

    @Override
    public Long publishTaskEvent(Long scheduleId, String actorUserId, String memo, boolean includeActor) {
        Long informId = insertInform("TASK_EVENT", safeMemo(memo));
        List<String> targets = pickTaskMembers(scheduleId, actorUserId, includeActor);
        saveReceivers(informId, targets);
        return informId;
    }

    @Override
    public Long publishNoticeEvent(Long projectId, String actorUserId, String memo, boolean includeActor) {
        Long informId = insertInform("NOTICE_EVENT", safeMemo(memo));
        List<String> targets = pickProjectMembers(projectId, actorUserId, includeActor);
        saveReceivers(informId, targets);
        return informId;
    }
    
    @Override
    public TaskBrief getTaskBrief(Long scheduleId) {
      return informDAO.selectTaskBrief(scheduleId);
    }

    // ===== 내부 유틸 =====
 // 변경 ✅
    private Long insertInform(String type, String memo) {
        return informDAO.insertInform(type, memo); // DAO가 PK 반환
    }
    private List<String> pickProjectMembers(Long projectId, String actor, boolean includeActor) {
        List<String> ids = informDAO.selectProjectMemberIds(projectId);
        return filterTargets(ids, actor, includeActor);
    }

    private List<String> pickTaskMembers(Long scheduleId, String actor, boolean includeActor) {
        List<String> ids = informDAO.selectTaskMemberIds(scheduleId);
        return filterTargets(ids, actor, includeActor);
    }

    private void saveReceivers(Long informId, List<String> userIds) {
        if (!userIds.isEmpty()) {
            informDAO.insertInformReceivers(informId, userIds);
        }
    }

    private static List<String> filterTargets(List<String> candidates, String actor, boolean includeActor) {
        if (candidates == null || candidates.isEmpty()) return List.of();
        if (includeActor) return new ArrayList<>(new LinkedHashSet<>(candidates));
        return candidates.stream()
                .filter(id -> id != null && !id.equals(actor))
                .distinct()
                .collect(Collectors.toList());
    }

    private static String safeMemo(String memo) {
        return memo == null ? "" : memo;
    }

}
