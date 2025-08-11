package com.app.service.project;

import java.util.List;

import com.app.dto.project.Inform;
import com.app.dto.project.TaskBrief;

public interface InformService {
	// 리스트/읽음
	List<Inform> findForUser(String userId,boolean onlyUnread);
	boolean markAsRead(String userId,Long informId);
	
	 // 알림 발행 (프로젝트/작업/공지)
    Long publishProjectEvent(Long projectId, String actorUserId, String memo, boolean includeActor);
    Long publishTaskEvent(Long scheduleId, String actorUserId, String memo, boolean includeActor);
    Long publishNoticeEvent(Long projectId, String actorUserId, String memo, boolean includeActor);
    
    TaskBrief getTaskBrief(Long scheduleId);
    
    String getProjectTitle(Long projectId);
}
