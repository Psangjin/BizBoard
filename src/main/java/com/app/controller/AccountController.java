package com.app.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.app.dto.User;
import com.app.service.UserService;

@Controller
@RequestMapping("/account")
public class AccountController {
	
	@Autowired
	UserService userService;
	
	//login
	@GetMapping("/login")
	public String login() {
		return "account/login";
	}
	
	@PostMapping("/login")
	public String loginAction(User user, HttpSession session, Model model) {
		
		User loginUser = userService.login(user);
		
		if(loginUser != null) {
			session.setAttribute("loginUser", loginUser);
			return "redirect:/account/mypage";
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
			return "account/login";
		}
	}
	
	
	// logout

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/account/login";
	}
	
	@PostMapping("/logout")
	public String logoutAction(HttpSession session, Model model) {
		session.invalidate();
		model.addAttribute("message", "로그아웃되었습니다.");
		model.addAttribute("redirecter", "/account/login");
		return "common/message";
	}

	
	//signup
	@GetMapping("/signup")
	public String signup() {
		return "account/signup";
	}
	
	@PostMapping("/signup")
	public String signupAction(User user, HttpSession session) {
		userService.signup(user);
		session.setAttribute("loginUser", user);
		return "redirect:/account/login";		
//		return "redirect:/account/mypage"; //회원가입 후 자동로그인 기능
		}
	
	
	//mypage
	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		User loginUser = (User)session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/account/login";
		} else {
		model.addAttribute("id", loginUser.getName());
		model.addAttribute("email",loginUser.getEmail());
		return "account/mypage";
		}
	}
	
	
}
