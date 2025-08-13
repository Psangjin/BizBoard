package com.app.controller.project;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.app.dto.project.TaskComment;
import com.app.dto.user.User;
import com.app.service.project.TaskCommentService;

@RestController
@RequestMapping("/task-comment")
public class TaskCommentRestController {

	@Autowired
	TaskCommentService taskCommentService;
	
	@GetMapping("/list")
    public List<TaskComment> list(@RequestParam Long scheduleId) {
        return taskCommentService.list(scheduleId);
    }
	
	//로그인에서 세션 넣어주기
	@PostMapping("/add")
	public String add(@RequestBody TaskComment taskComment, HttpSession session) {
	    User login = (User) session.getAttribute("loginUser");
	    if (login != null) {
	        taskComment.setUserId(login.getId());
	    } else {
	        // 필요하면 여기서 401 처리 등
	        // return "LOGIN_REQUIRED";
	    }
	    taskCommentService.add(taskComment);
	    return "OK";
	}

	@PostMapping("/update")
    public String update(@RequestBody TaskComment c) {
        taskCommentService.edit(c);
        return "OK";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long id) {
        taskCommentService.remove(id);
        return "OK";
    }
}
