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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Schedule;
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


	@PostMapping("/project/schedule/save")
	public ResponseEntity<?> save(@RequestBody Schedule schedule) {

		scheduleService.saveSchedule(schedule);

		return ResponseEntity.ok().build();
	}
	@GetMapping("/project/schedule/gantt")
	public List<Map<String, Object>> getGanttData(@RequestParam("projectId") Long projectId) {
	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);

	    return list.stream().map(s -> {
	        Map<String, Object> map = new HashMap<>();
	        map.put("id", s.getId());
	        map.put("name", s.getTitle());
	        
	        if (s.getStartDt() != null) {
	            map.put("start", s.getStartDt().toLocalDateTime().toLocalDate().toString());  // "YYYY-MM-DD"
	        }
	        if (s.getEndDt() != null) {
	            map.put("end", s.getEndDt().toLocalDateTime().toLocalDate().toString());
	        }

	        map.put("progress", 0);  // 필요시 DB에서 가져오기
	        map.put("dependencies", "");  // 필요시 설정
	        map.put("description", s.getContent());

	        return map;
	    }).filter(m -> m.containsKey("start") && m.containsKey("end"))
	      .collect(Collectors.toList());
	}

	@GetMapping("/project/schedule/events")
	public List<Map<String, Object>> getEvents(@RequestParam("projectId") Long projectId) {
	    List<Schedule> list = scheduleService.findSchedulesByProjectId(projectId);
	    System.out.println(list.get(0).getStartDt());
	    System.out.println(list.get(0).getEndDt());
	    return list.stream().map(s -> {
	        Map<String, Object> map = new HashMap<>();
	        map.put("id", s.getId());
	        map.put("title", s.getTitle());

	        boolean allDay = "PW".equals(s.getType());

	        if (allDay) {
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
