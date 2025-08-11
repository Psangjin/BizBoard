package com.app.dao.project;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.app.dto.project.Inform;
import com.app.dto.project.TaskBrief;

public interface InformDAO {
    List<Inform> selectForUser(String userId, boolean onlyUnread);
    int updateRead(String userId, Long informId);

    // 변경: PK를 돌려받도록 Long 반환
    Long insertInform(String type, String memo);

    // RETURNING 쓰므로 더 이상 필요 없음 (지우는 걸 추천)
    // Long selectLastInsertId();

    int insertInformReceivers(Long informId, List<String> userIds);
    List<String> selectProjectMemberIds(Long projectId);
    List<String> selectTaskMemberIds(Long scheduleId);
    
    TaskBrief selectTaskBrief(Long scheduleId);
    
    String selectProjectTitle(Long projectId);
}

