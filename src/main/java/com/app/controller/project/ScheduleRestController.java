package com.app.controller.project;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Project;
import com.app.dto.project.Schedule;
import com.app.service.project.ProjectService;
import com.app.service.project.ScheduleService;

@RestController
public class ScheduleRestController {
	
	@Autowired
	private ScheduleService scheduleService;

	@Autowired
    private ProjectService projectService;
	
	
	@PostMapping("/project/create")
	public ResponseEntity<String> createProject(@RequestBody Project project) {
        int result = projectService.createProject(project);
        System.out.println("백");
        System.out.println(project);
        if (result > 0) {
            return ResponseEntity.ok("프로젝트 생성 성공");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("프로젝트 생성 실패");
        }
    }
	
	@GetMapping("/project/list")
	public List<Project> getAllProjects() {
	    return projectService.findAllProjects();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	@PostMapping("/project/schedule/save")
	public ResponseEntity<?> save(@RequestBody Schedule schedule) {

		scheduleService.saveSchedule(schedule);

		return ResponseEntity.ok().build();
	}

	@GetMapping("/project/schedule/events")
	public List<Map<String, Object>> getEvents() {
		List<Schedule> list = scheduleService.findAllSchedules();
		return list.stream().map(s -> {
			Map<String, Object> map = new HashMap<>();
			map.put("id", s.getId());
			map.put("title", s.getTitle());

			// allDay 체크
			boolean allDay = "PW".equals(s.getType()); // project work(작업) 이면 all day

			if (allDay) {
				// 시간 제거한 날짜만 전달
				map.put("start", s.getStartDt().toLocalDateTime().toLocalDate().toString());

				if (s.getEndDt() != null) {
					map.put("end", s.getEndDt().toLocalDateTime().toLocalDate().toString());
				}
			} else {
				map.put("start", s.getStartDt());
				map.put("end", s.getEndDt());
			}

			map.put("backgroundColor", s.getColor());
			map.put("borderColor", s.getColor());

			Map<String, Object> ext = new HashMap<>();
			ext.put("description", s.getContent());
			ext.put("type", s.getType());
			ext.put("completed", s.getCompleted());
			map.put("extendedProps", ext);

			map.put("allDay", allDay);

			return map;
		}).collect(Collectors.toList());
	}

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
