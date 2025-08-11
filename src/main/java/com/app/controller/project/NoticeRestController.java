package com.app.controller.project;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.app.dto.project.Notice;
import com.app.dto.user.User;
import com.app.service.project.NoticeService;
import com.app.service.project.InformService;

@RestController
public class NoticeRestController {

    @Autowired NoticeService noticeService;
    @Autowired InformService informService;

    // ===== 내부 유틸 =====
    private static String safe(String s) {
        return (s == null || s.isBlank()) ? "(제목 없음)" : s;
    }
    private static String orBlank(String s) { return (s == null) ? "" : s; }

    /** [프로젝트명] 공지 <액션>: <제목> 형태로 메모 구성 */
    private String buildNoticeMemo(Long projectId, String action, String title) {
        String projectTitle = orBlank(informService.getProjectTitle(projectId));
        return String.format("[%s] 공지 %s: %s", projectTitle, action, safe(title));
    }

    // 목록
    @GetMapping("/notice/list")
    public List<Notice> list(@RequestParam Long projectId) {
        return noticeService.listByProjectId(projectId);
    }

    // 등록
    @PostMapping("/notice/create")
    public Notice create(@RequestBody Notice req, HttpSession session) {
        User u = (User) session.getAttribute("loginUser");
        String actorUserId = (u != null ? u.getId() : "anonymous");
        req.setUserId(actorUserId);

        Long id = noticeService.insert(req);
        req.setId(id);

        try {
            Long projectId = req.getProjectId();
            String memo = buildNoticeMemo(projectId, "등록", req.getTitle());
            informService.publishNoticeEvent(projectId, actorUserId, memo, true);
        } catch (Exception e) { e.printStackTrace(); }

        return req;
    }

    // 수정
    @PostMapping("/notice/update")
    public void update(@RequestBody Notice req, HttpSession session) {
        noticeService.update(req);

        try {
            User u = (User) session.getAttribute("loginUser");
            String actorUserId = (u != null ? u.getId() : "anonymous");

            Long projectId = (req.getProjectId() != null)
                    ? req.getProjectId()
                    : noticeService.getById(req.getId()).getProjectId();

            String memo = buildNoticeMemo(projectId, "수정", req.getTitle());
            informService.publishNoticeEvent(projectId, actorUserId, memo, true);
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 삭제
    @PostMapping("/notice/delete")
    public void delete(@RequestBody Notice req, HttpSession session) {
        Notice before = noticeService.getById(req.getId());
        noticeService.delete(req.getId());

        try {
            User u = (User) session.getAttribute("loginUser");
            String actorUserId = (u != null ? u.getId() : "anonymous");

            Long projectId = before.getProjectId();
            String memo = buildNoticeMemo(projectId, "삭제", before.getTitle());
            informService.publishNoticeEvent(projectId, actorUserId, memo, true);
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 단건 조회
    @GetMapping("/notice/get")
    public Notice get(@RequestParam Long id) {
        return noticeService.getById(id);
    }
}

