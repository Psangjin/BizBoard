package com.app.controller.project;

import java.util.*;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.dto.project.TaskMember;
import com.app.service.project.TaskMemberService;

@RestController
@RequestMapping("/task-member") // ✅ 공통 prefix
public class TaskMemberRestController {

    @Autowired
    TaskMemberService taskMemberService;
    
    @GetMapping("/task/{scheduleId}/members")
    @ResponseBody
    public List<String> getTaskMemberIds(@PathVariable Long scheduleId) {
        return taskMemberService.findUserIdsByTaskId(scheduleId); // 내부적으로 scheduleId 사용
    }

    // ✅ 멤버 목록 (프론트: GET /task-member/list?scheduleId=...)
    @GetMapping("/list")
    public ResponseEntity<List<TaskMember>> list(@RequestParam Long scheduleId) {
        List<TaskMember> list = taskMemberService.findByScheduleId(scheduleId);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    // ✅ 멤버 치환 (프론트: POST /task-member/project/schedule/members/replace)
    @PostMapping("/project/schedule/members/replace")
    public ResponseEntity<List<TaskMember>> replaceMembers(@RequestBody Map<String, Object> body) {
        Long scheduleId = Long.valueOf(String.valueOf(body.get("scheduleId")));
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> raw = (List<Map<String, Object>>) body.get("members");

        List<TaskMember> members = new ArrayList<>();
        if (raw != null) {
            for (Map<String, Object> m : raw) {
                TaskMember tm = new TaskMember();
                tm.setScheduleId(scheduleId);
                tm.setUserId(String.valueOf(m.get("userId"))); // DTO가 String
                tm.setName(Objects.toString(m.get("name"), null));
                members.add(tm);
            }
        }

        List<TaskMember> saved = taskMemberService.replaceMembers(scheduleId, members); // ✅ 배치 사용
        return ResponseEntity.ok(saved);
    }
    

}
