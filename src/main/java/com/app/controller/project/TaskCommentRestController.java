package com.app.controller.project;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.app.dto.project.TaskComment;
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
    public String add(@RequestBody TaskComment taskComment,
                      @SessionAttribute(value="loginUserId", required=false) String  loginUserId) {
        if (loginUserId != null) taskComment.setUserId(loginUserId); // 세션 유저를 작성자로
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
