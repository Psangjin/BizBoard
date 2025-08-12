package com.app.controller.mainpage;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.app.dto.project.ScheduleWithProject;
import com.app.dto.user.User;
import com.app.service.project.ScheduleService;

@Controller
public class MainpageController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@RequestMapping("/")
	public String mainPage(HttpSession session, HttpServletRequest request) {
		
		User loginUser = (User)session.getAttribute("loginUser");
		if (loginUser == null) {
			return "mainpage/mainpage-logout";
		} else {
		request.setAttribute("afterLogin", true);
		return "forward:/mainpage";
		}
		
	}
	
	@RequestMapping("/mainpage")
	public String mainPage_login(HttpServletRequest request) {
		Boolean afterLogin = (Boolean) request.getAttribute("afterLogin");
	    if (afterLogin == null || !afterLogin) {
	        return "redirect:/error"; // 직접 접근 차단
	    }
		return "mainpage/mainpage-login";
	}

	@RequestMapping("/service")
	public String service() {
		return "service/service";
	}
	@RequestMapping("/inquiryFAQ")
	public String inquiryFAQ() {
		return "inquiry/inquiryFAQ";

	}
	@RequestMapping("/inquiryOne")
	public String inquiryOne() {
		return "inquiry/inquiryOne";

	}
	
	@RequestMapping("/error")
	public String error() {
		return "errorScreen";
	}
/*	@RequestMapping("/project/{projectId}")
	public String showProjectDetail(@PathVariable int projectId, HttpSession session) {
	    Project project = projectService.getProject(projectId);
	    if (project == null || !project.isMember(session.getAttribute("loggedInUser"))) {
	        return "error/errorScreen"; 
	    }
	    return "project/projectDetail";
	}  */
	
	@ResponseBody
	@GetMapping("/main/data")
    public ResponseEntity<Map<String, List<ScheduleWithProject>>> getMainPageData(HttpSession session) {
        User user = (User) session.getAttribute("loginUser");

        // 로그인하지 않은 사용자라면 401 Unauthorized 응답
        if (user == null) {
            return ResponseEntity.status(401).body(null);
        }

        // 서비스 계층에서 데이터를 가져옴
        Map<String, List<ScheduleWithProject>> schedulesMap = scheduleService.getUserSchedulesAndTasks(user.getId());
        // 데이터를 JSON 형태로 성공적으로 반환
        return ResponseEntity.ok(schedulesMap);
    }
	
}
