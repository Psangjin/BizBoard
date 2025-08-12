package com.app.controller.project;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Project;
import com.app.dto.project.Schedule;
import com.app.dto.user.User;
import com.app.service.project.ProjectMemberService;
import com.app.service.project.ProjectService;
import com.app.service.project.ScheduleService;

@RestController
public class ScheduleRestController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@GetMapping("/project/schedule/max-id")
	public ResponseEntity<Integer> findMaxScheduleId() {
	    Integer maxId = scheduleService.findMaxScheduleId();
	    return ResponseEntity.ok(maxId != null ? maxId : 0); // 아무 것도 없으면 0
	}


	@Autowired
    private ProjectService projectService;
	
	@Autowired
	private ProjectMemberService projectMemberService;
	
	@PostMapping("/project/create")
	public ResponseEntity<String> createProject(@RequestBody Project project, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
    	project.setManager(user.getId());
    	
		int result = projectService.createProject(project);
        
        if (result > 0) {
        	projectMemberService.insertProjectMemberAsAdmin(project.getId(), user.getId());
            String loginUserRole = projectMemberService.findRoleByProjectAndUser(project.getId(), user.getId());
            session.setAttribute("project", project);
            session.setAttribute("loginUserRole", loginUserRole);
            return ResponseEntity.ok("/project/main/"+project.getId());
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("프로젝트 생성 실패");
        }
    }
	
	@GetMapping("/project/list")
	public List<Project> getAllProjects() {
	    return projectService.findAllProjects();
	}
	
	
	@GetMapping("/project/listByUserId")
	public List<Project> getProjectsByUserId(HttpSession session) {
	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return Collections.emptyList(); // 로그인 안된 경우 빈 리스트 반환
	    }

	    String userId = loginUser.getId(); // User 객체에서 아이디 꺼내기
	    return projectService.findProjectsByUserId(userId);
	}
	
	
	
	
	
	
	
	
	
	
	@PostMapping("/project/schedule/save")
	public ResponseEntity<?> save(@RequestBody Schedule schedule) {

		scheduleService.saveSchedule(schedule);

		return ResponseEntity.ok().build();
	}
	@GetMapping("/project/schedule/gantt")
	public List<Map<String, Object>> getGanttData(@RequestParam("projectId") Long projectId) {
	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);

	    return list.stream()
	        // ✅ 타입이 PW인 것만
	        .filter(s -> "PW".equalsIgnoreCase(s.getType()))
	        .map(s -> {
	            Map<String, Object> map = new HashMap<>();
	            map.put("id", s.getId());
	            map.put("name", s.getTitle());

	            String start = s.getStartDt() != null
	                ? s.getStartDt().toLocalDateTime().toLocalDate().toString()
	                : null;

	            String end = s.getEndDt() != null
	                ? s.getEndDt().toLocalDateTime().toLocalDate().toString()
	                : start; // end 없으면 start로

	            if (start != null) {
	                map.put("start", start);
	                map.put("end", end);
	            }

	            map.put("progress", 0);
	            map.put("dependencies", "");
	            map.put("description", s.getContent());
	            return map;
	        })
	        .filter(m -> m.containsKey("start"))
	        .collect(Collectors.toList());
	}



	@GetMapping("/project/schedule/events")
	public ResponseEntity<List<Map<String, Object>>> getEvents(@RequestParam("projectId") Long projectId) {
	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);

	    // ✅ 일정이 없는 프로젝트일 때 바로 빈 배열 반환
	    if (list == null || list.isEmpty()) {
	        return ResponseEntity.ok(Collections.emptyList());
	    }

	    List<Map<String, Object>> events = list.stream().map(s -> {
	        Map<String, Object> map = new HashMap<>();
	        map.put("id", s.getId());
	        map.put("title", s.getTitle());

	        boolean allDay = "PW".equalsIgnoreCase(s.getType());
	        map.put("allDay", allDay);

	        // ✅ null 안전 처리
	        Timestamp sdt = s.getStartDt();
	        Timestamp edt = s.getEndDt();

	        if (allDay) {
	            if (sdt != null) {
	                map.put("start", sdt.toLocalDateTime().toLocalDate().toString());
	            }
	            if (edt != null) {
	                map.put("end", edt.toLocalDateTime().toLocalDate().toString());
	            }
	        } else {
	            if (sdt != null) {
	                map.put("start", sdt.toLocalDateTime().toString()); // 2025-08-11T09:00:00
	            }
	            if (edt != null) {
	                map.put("end", edt.toLocalDateTime().toString());
	            }
	        }

	        map.put("backgroundColor", s.getColor());
	        map.put("borderColor", s.getColor());

	        Map<String, Object> ext = new HashMap<>();
	        ext.put("description", s.getContent());
	        ext.put("type", s.getType());
	        ext.put("completed", s.getCompleted());
	        map.put("extendedProps", ext);

	        return map;
	    }).collect(Collectors.toList());

	    return ResponseEntity.ok(events);
	}
	@GetMapping("/project/schedule/today")
	public ResponseEntity<List<Map<String, Object>>> getTodayEvents(@RequestParam("projectId") Long projectId) {
	    LocalDate today = LocalDate.now();
	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);

	    if (list == null || list.isEmpty()) {
	        return ResponseEntity.ok(Collections.emptyList());
	    }

	    List<Map<String, Object>> todayList = list.stream()
	        .filter(s -> s.getStartDt() != null) // ✅ null 방어
	        .filter(s -> {
	            LocalDate start = s.getStartDt().toLocalDateTime().toLocalDate();
	            LocalDate end = (s.getEndDt() != null)
	                    ? s.getEndDt().toLocalDateTime().toLocalDate()
	                    : start;
	            return !today.isBefore(start) && !today.isAfter(end);
	        })
	        .map(s -> {
	            Map<String, Object> map = new HashMap<>();
	            map.put("id", s.getId());
	            map.put("title", s.getTitle());
	            return map;
	        })
	        .collect(Collectors.toList());

	    return ResponseEntity.ok(todayList);
	}
//	@GetMapping("/project/schedule/today")
//	public List<Map<String, Object>> getTodayEvents(@RequestParam("projectId") Long projectId) {
//	    LocalDate today = LocalDate.now();
//
//	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);
//
//	    return list.stream()
//	            .filter(s -> {
//	                LocalDate start = s.getStartDt().toLocalDateTime().toLocalDate();
//	                LocalDate end = (s.getEndDt() != null) 
//	                        ? s.getEndDt().toLocalDateTime().toLocalDate()
//	                        : start; // end가 없으면 시작일과 동일
//	                // 오늘이 start~end 범위 안에 있으면 포함
//	                return !today.isBefore(start) && !today.isAfter(end);
//	            })
//	            .map(s -> {
//	                Map<String, Object> map = new HashMap<>();
//	                map.put("id", s.getId());
//	                map.put("title", s.getTitle());
//	                return map;
//	            })
//	            .collect(Collectors.toList());
//	}


	@PostMapping("/project/schedule/delete")
	public ResponseEntity<?> deleteSchedule(@RequestBody Map<String, Object> payload) {
		long id = Long.parseLong(payload.get("id").toString());
		scheduleService.deleteScheduleById(id);
		return ResponseEntity.ok().build();
	}

	@PostMapping("/project/schedule/update")
	public ResponseEntity<?> updateSchedule(@RequestBody Schedule schedule) {
		try {
			scheduleService.modifySchedule(schedule);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("일정 업데이트 실패: " + e.getMessage());
		}
	}

}
