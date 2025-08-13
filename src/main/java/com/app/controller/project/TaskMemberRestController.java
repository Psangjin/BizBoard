package com.app.controller.project;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.dto.project.TaskMember;
import com.app.dto.user.User;
import com.app.service.project.InformService;
import com.app.service.project.TaskMemberService;

@RestController
@RequestMapping("/task-member")
public class TaskMemberRestController {

    @Autowired
    TaskMemberService taskMemberService;

    @Autowired
    InformService informService;

    // ✅ Java 8/11 호환용 POJO (record 대신)
    private static class DiffResult {
        private final List<String> added;
        private final List<String> removed;
        DiffResult(List<String> added, List<String> removed) {
            this.added = added; this.removed = removed;
        }
        public List<String> getAdded()   { return added; }
        public List<String> getRemoved() { return removed; }
    }

    @GetMapping("/task/{scheduleId}/members")
    public List<String> getTaskMemberIds(@PathVariable Long scheduleId) {
        return taskMemberService.findUserIdsByTaskId(scheduleId);
    }

    @GetMapping("/list")
    public ResponseEntity<List<TaskMember>> list(@RequestParam Long scheduleId) {
        List<TaskMember> list = taskMemberService.findByScheduleId(scheduleId);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    // ✅ 멤버 치환 + 알림 발행
    @PostMapping("/project/schedule/members/replace")
    public ResponseEntity<List<TaskMember>> replaceMembers(
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        Long scheduleId = Long.valueOf(String.valueOf(body.get("scheduleId")));
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> raw = (List<Map<String, Object>>) body.get("members");

        // 0) 변경 전 멤버
        List<TaskMember> before = taskMemberService.findByScheduleId(scheduleId);

        // 1) 실제 치환
        List<TaskMember> want = new ArrayList<>();
        if (raw != null) {
            for (Map<String, Object> m : raw) {
                TaskMember tm = new TaskMember();
                tm.setScheduleId(scheduleId);
                tm.setUserId(String.valueOf(m.get("userId")));
                tm.setName(Objects.toString(m.get("name"), null));
                want.add(tm);
            }
        }
        List<TaskMember> saved = taskMemberService.replaceMembers(scheduleId, want);

        // 2) diff 계산
        DiffResult diff = diffMembers(before, saved);

     // 3) 알림 발행 (담당자들에게)
        try {
          String actorUserId = ((User) session.getAttribute("loginUser")).getId();

          // ⬇️ 프로젝트/작업 타이틀 조회
          var brief = informService.getTaskBrief(scheduleId); // projectTitle, taskTitle

          // diff 문장
          String changeMsg = buildMemberDiffMemo("담당자", diff);

          // ⬇️ 메모를 "[프로젝트명] 작업: 작업명 — 담당자 변경: ..." 형식으로
          String memo = String.format("[%s] 작업: %s — %s",
              orBlank(brief != null ? brief.getProjectTitle() : null),
              orBlank(brief != null ? brief.getTaskTitle()   : null),
              changeMsg
          );

          boolean includeActor = false;
          informService.publishTaskEvent(scheduleId, actorUserId, memo, includeActor);
        } catch (Exception e) {
          e.printStackTrace();
        }


        return ResponseEntity.ok(saved);
    }
    private String orBlank(String s) { return (s == null || s.isBlank()) ? "" : s; }


    /** 추가/삭제 diff 계산 */
    private DiffResult diffMembers(List<TaskMember> before, List<TaskMember> after) {
        Map<String,String> b = new LinkedHashMap<>();
        Map<String,String> a = new LinkedHashMap<>();
        if (before != null) {
            for (TaskMember tm : before) {
                b.put(tm.getUserId(), coalesce(tm.getName(), tm.getUserId()));
            }
        }
        if (after != null) {
            for (TaskMember tm : after) {
                a.put(tm.getUserId(), coalesce(tm.getName(), tm.getUserId()));
            }
        }

        List<String> added = a.keySet().stream()
                .filter(k -> !b.containsKey(k))
                .map(a::get)
                .collect(Collectors.toList());

        List<String> removed = b.keySet().stream()
                .filter(k -> !a.containsKey(k))
                .map(b::get)
                .collect(Collectors.toList());

        return new DiffResult(added, removed);
    }

    private String buildMemberDiffMemo(String label, DiffResult d) {
        StringBuilder sb = new StringBuilder(label).append(" 변경: ");
        boolean has = false;
        if (d.getAdded() != null && !d.getAdded().isEmpty()) {
            sb.append("추가 ").append(String.join(", ", d.getAdded()));
            has = true;
        }
        if (d.getRemoved() != null && !d.getRemoved().isEmpty()) {
            if (has) sb.append(" / ");
            sb.append("삭제 ").append(String.join(", ", d.getRemoved()));
            has = true;
        }
        if (!has) sb.append("변경 없음");
        return sb.toString();
    }

    private String coalesce(String a, String b) {
        return (a != null && !a.isBlank()) ? a : b;
    }
}
