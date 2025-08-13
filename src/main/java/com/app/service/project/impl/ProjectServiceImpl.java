package com.app.service.project.impl;


import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.TimeZone;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


import org.springframework.transaction.annotation.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.project.InformDAO;
import com.app.dao.project.ProjectDAO;
import com.app.dto.project.Project;
import com.app.service.project.ProjectService;

@Service
public class ProjectServiceImpl implements ProjectService {
	
	@Autowired
	InformDAO informDAO;

	@Autowired
	ProjectDAO projectDAO;
	
	private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	@Override
	public int createProject(Project project) {
		
		int result = projectDAO.createProject(project);
		
		return result;
	}

	@Override
	public List<Project> findAllProjects() {
		
		List<Project> allProjects = projectDAO.findAllProjects();
		
		return allProjects;
	}

	@Override
	public Project findProjectById(Long projectId) {
		
		Project project = projectDAO.findProjectById(projectId);
		
		return project;
	}

	@Override
	public List<Project> findProjectsByUserId(String userId) {
		
		List<Project> projectList = projectDAO.findProjectsByUserId(userId);
		
		return projectList;
	}

	@Override
	public int countNumberofScheduleByProjectId(Long projectId, String type) {
		
		int cnt = projectDAO.countNumberofScheduleByProjectId(projectId, type);
		
		return cnt;
	}
	@Transactional
	public void updateProject(Project req, String actorUserId) {
	  if (req.getId() == null) throw new IllegalArgumentException("id is required");

	  Project curr = projectDAO.findProjectById(req.getId());
	  if (curr == null) throw new IllegalArgumentException("project not found");

	  // 1) 변경 전/후 스냅샷 (모두 Timestamp)
	  String     beforeManager = curr.getManager();
	  String     beforeTitle   = curr.getTitle();
	  String     beforeContent = curr.getContent();
	  Timestamp  beforeEnd     = curr.getEndDt();

	  String     afterManager  = (req.getManager() != null) ? req.getManager() : beforeManager;
	  String     afterTitle    = (req.getTitle()   != null) ? req.getTitle()   : beforeTitle;
	  String     afterContent  = (req.getContent() != null) ? req.getContent() : beforeContent;
	  Timestamp  afterEnd      = (req.getEndDt()   != null) ? req.getEndDt()   : beforeEnd;

	  // 2) 변경 항목 diff
	  List<String> parts = new ArrayList<>();
	  if (changedStr(beforeManager, afterManager)) {
	    parts.add("관리자: '" + nv(beforeManager) + "' → '" + nv(afterManager) + "'");
	  }
	  if (changedStr(beforeTitle, afterTitle)) {
	    parts.add("제목: '" + nv(beforeTitle) + "' → '" + nv(afterTitle) + "'");
	  }
	  if (changedStr(beforeContent, afterContent)) {
	    parts.add("내용: '" + preview(beforeContent) + "' → '" + preview(afterContent) + "'");
	  }
	  // 마감일 비교 (분 단위로 비교하고 싶으면 sameMinute 사용)
	  if (!Objects.equals(beforeEnd, afterEnd)) {
	    parts.add("마감일: " + fmt(beforeEnd) + " → " + fmt(afterEnd));
	  }

	  // 3) 부분 업데이트
	  if (req.getManager() != null) curr.setManager(req.getManager());
	  if (req.getTitle()   != null) curr.setTitle(req.getTitle());
	  if (req.getContent() != null) curr.setContent(req.getContent());
	  if (req.getEndDt()   != null) curr.setEndDt(req.getEndDt());

	  projectDAO.updateProject(curr);

	  // 4) 변경이 있을 때만 알림
	  if (!parts.isEmpty()) {
	    String memo = "[프로젝트 수정] " + nv(afterTitle) + " | " + String.join(", ", parts) + " | by " + actorUserId;

	    Long informId = informDAO.insertInform("PROJECT_EVENT", memo);

	    List<String> userIds = informDAO.selectProjectMemberIds(curr.getId())
	        .stream()
	        .filter(Objects::nonNull)
	        .filter(u -> !Objects.equals(u, actorUserId))
	        .distinct()
	        .collect(java.util.stream.Collectors.toList());

	    informDAO.insertInformReceivers(informId, userIds);
	  }
	}

	/* ===== 유틸 ===== */
	private static String nv(String s) {
	  String t = (s == null) ? "" : s.trim();
	  return t.isEmpty() ? "(없음)" : t;
	}
	private static boolean changedStr(String a, String b) {
	  String aa = (a == null) ? "" : a.trim();
	  String bb = (b == null) ? "" : b.trim();
	  return !Objects.equals(aa, bb);
	}
	private static String preview(String s) {
	  if (s == null) return "(없음)";
	  String t = s.trim().replaceAll("\\s+", " ");
	  return t.isEmpty() ? "(없음)" : (t.length() > 60 ? t.substring(0, 60) + "…" : t);
	}

	/* Timestamp 포맷: UTC 기준. 시스템 로컬로 보이게 하려면 TimeZone.getDefault()로 바꿔도 됨 */
	private static final ThreadLocal<DateFormat> DF = ThreadLocal.withInitial(() -> {
	  SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	  f.setTimeZone(TimeZone.getTimeZone("UTC"));
	  return f;
	});
	private static String fmt(Timestamp ts) {
	  return (ts == null) ? "(없음)" : DF.get().format(ts);
	}

	/* (선택) 분 단위 동일성만 비교하고 싶을 때 사용 */
	// private static boolean sameMinute(Timestamp a, Timestamp b) {
	//   if (a == b) return true;
	//   if (a == null || b == null) return false;
	//   return a.getTime() / 60000L == b.getTime() / 60000L;
	// }
	
	@Override
	public int deleteProject(Long id) {
		return projectDAO.deleteProject(id);
	}
	
	@Override
	public int countNumberofScheduleDoneByProjectId(Long projectId, String type) {
		
		int cnt = projectDAO.countNumberofScheduleDoneByProjectId(projectId, type);
		
		return cnt;
	}
}
