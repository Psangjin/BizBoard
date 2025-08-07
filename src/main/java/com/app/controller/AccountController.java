package com.app.controller;




import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.app.dto.user.User;

import com.app.service.UserService;

@Controller
@RequestMapping("/account")
public class AccountController {
	
	@Autowired
	UserService userService;
	
	//login
	@GetMapping("/login")
	public String login(Model model) {	    
	    return "account/login";
	}

	
	@PostMapping("/login")
	public String loginAction(User user, HttpSession session, Model model) {
		
		User loginUser = userService.login(user);
		
		if(loginUser != null) {
			session.setAttribute("loginUser", loginUser);
			return "redirect:/account/mypage";
		} else {
			 System.out.println("[로그인 실패] ID: " + user.getId()); // 디버깅용
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
	public String signupAction(User user, HttpServletRequest request, Model model) {
		model.addAttribute("user", user);
		
	    // 필수 입력값 검증
		 if (user.getId() == null || user.getId().isEmpty()) {
		        model.addAttribute("error", "아이디를 입력해주세요.");
		        return "account/signup";
		    }
		    if (user.getPw() == null || user.getPw().isEmpty()) {
		        model.addAttribute("error", "비밀번호를 입력해주세요.");
		        return "account/signup";
		    }
		    if (user.getName() == null || user.getName().isEmpty()) {
		        model.addAttribute("error", "이름을 입력해주세요.");
		        return "account/signup";
		    }
		    if (user.getEmail() == null || user.getEmail().isEmpty()) {
		        model.addAttribute("error", "이메일을 입력해주세요.");
		        return "account/signup";
		    }

	    
	    // 약관 동의 여부 검증
	    String terms = request.getParameter("terms");
	    String privacy = request.getParameter("privacy");
	    String age = request.getParameter("age");

	    if (terms == null || privacy == null || age == null) {
	        model.addAttribute("error", "필수 약관에 모두 동의해야 가입이 가능합니다.");	        
	        return "account/signup";
	    }
	    
	    
	    //회원가입 처리
	    
	    
	    
	    try {
	        userService.signup(user);	   
	        request.setAttribute("message", "회원가입 성공!");
	        request.setAttribute("redirectUrl", "/account/login");
	        return "redirect:/account/login";
	        
	    } catch (Exception e) {
	        model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");	       
	        return "account/signup";
	    }
	}
//		//회원가입 처리
//		userService.signup(user);
//		session.setAttribute("loginUser", user);
//		return "redirect:/account/login";		
////		return "redirect:/account/mypage"; //회원가입 후 자동로그인 기능
		
	
	
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
