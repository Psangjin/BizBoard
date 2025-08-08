package com.app.controller.mainpage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.app.dto.user.User;

@Controller
public class MainpageController {
	
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

	@RequestMapping("/admin")
	public String admin() {
		return "admin/admin";
	}
	
	@RequestMapping("/pricing")
	public String pricing() {
		return "pricing/pricing";
	}
}
