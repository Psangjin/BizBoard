package com.app.controller.project;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Notice;
import com.app.dto.user.User;
import com.app.service.project.NoticeService;

@RestController
public class NoticeRestController {
	@Autowired NoticeService noticeService;

    // 목록
    @GetMapping("/notice/list")
    public List<Notice> list(@RequestParam Long projectId) {
        return noticeService.listByProjectId(projectId);
    }

    // 등록
    @PostMapping("/notice/create")
    public Notice create(@RequestBody Notice req, HttpSession session) {
        // 세션에서 로그인 사용자 사용 (userId 채움)
        User u = (User) session.getAttribute("loginUser");
        req.setUserId(u != null ? u.getId() : "anonymous");
        Long id = noticeService.insert(req);
        req.setId(id);
        return req;
    }

    // 수정
    @PostMapping("/notice/update")
    public void update(@RequestBody Notice req) {
        noticeService.update(req);
    }

    // 삭제
    @PostMapping("/notice/delete")
    public void delete(@RequestBody Notice req) {
        noticeService.delete(req.getId());
    }
    
 // Controller
    @GetMapping("/notice/get")
    public Notice get(@RequestParam Long id) {
      return noticeService.getById(id);
    }

}
