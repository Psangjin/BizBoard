package com.app.controller.project;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.app.dto.project.Inform;
import com.app.dto.user.User;
import com.app.service.project.InformService;

@RestController
@RequestMapping("/inform/api")
public class InformRestController {
	
	@Autowired
	InformService informService;
	
		@GetMapping("/list")
	    public List<Inform> list(@RequestParam(defaultValue = "unread") String scope,
	                                HttpSession session) {
	        User login = (User) session.getAttribute("loginUser");
	        String userId = login.getId();
	        boolean onlyUnread = !"all".equalsIgnoreCase(scope);
	        return informService.findForUser(userId, onlyUnread);
	    }
	
	    @PostMapping("/read")
	    public Map<String,Object> read(@RequestBody Map<String,Long> body,
	                                   HttpSession session) {
	        User login = (User) session.getAttribute("loginUser");
	        String userId = login.getId();
	        Long informId = body.get("informId");
	        boolean ok = informService.markAsRead(userId, informId);
	        return Map.of("ok", ok);
	    }
}
