package com.app.dao.project.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.project.InformDAO;
import com.app.dto.project.Inform;
import com.app.dto.project.TaskBrief;

@Repository
public class InformDAOImpl implements InformDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<Inform> selectForUser(String userId, boolean onlyUnread) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("onlyUnread", onlyUnread);
        return sqlSessionTemplate.selectList("inform_mapper.selectForUser", params);
    }

    @Override
    public int updateRead(String userId, Long informId) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("informId", informId);
        return sqlSessionTemplate.update("inform_mapper.updateRead", params);
    }

    // ✅ RETURNING INFORM_ID INTO #{informId} 결과를 Map에서 꺼내 반환
    @Override
    public Long insertInform(String type, String memo) {
        Map<String, Object> params = new HashMap<>();
        params.put("type", type);
        params.put("memo", memo);
        sqlSessionTemplate.insert("inform_mapper.insertInform", params); // RETURNING 수행
        Object key = params.get("informId");
        if (key == null) {
            throw new IllegalStateException("informId was not returned from INSERT ... RETURNING");
        }
        return ((Number) key).longValue();
    }

    // ❌ RETURNING을 쓰면 더 이상 필요 없음 (지워도 됨)
    // @Override
    // public Long selectLastInsertId() { ... }

    @Override
    public int insertInformReceivers(Long informId, List<String> userIds) {
    	if (userIds == null || userIds.isEmpty()) return -1;  // ★ 가드
        Map<String, Object> params = new HashMap<>();
        params.put("informId", informId);
        params.put("userIds", userIds);
        return sqlSessionTemplate.insert("inform_mapper.insertInformReceivers", params);
    }

    @Override
    public List<String> selectProjectMemberIds(Long projectId) {
        return sqlSessionTemplate.selectList("inform_mapper.selectProjectMemberIds", projectId);
    }

    @Override
    public List<String> selectTaskMemberIds(Long scheduleId) {
        Map<String,Object> p = new HashMap<>();
        p.put("scheduleId", scheduleId);
        return sqlSessionTemplate.selectList("inform_mapper.selectTaskMemberIds", p);
    }
    
    @Override
    public TaskBrief selectTaskBrief(Long scheduleId) {
      return sqlSessionTemplate.selectOne("inform_mapper.selectTaskBrief", scheduleId);
    }

	@Override
	public String selectProjectTitle(Long projectId) {
		return sqlSessionTemplate.selectOne("inform_mapper.selectProjectTitle",projectId);
	}
}

