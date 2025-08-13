package com.app.controller;




import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.app.dto.project.Project;
import com.app.dto.user.User;
import com.app.service.UserService;
import com.app.service.project.ProjectService;


@Controller
@RequestMapping("/account") 
public class AccountController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	ProjectService projectService;
	
	
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
			return "redirect:/";
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
		return "redirect:/";
	}
	
	@PostMapping("/logout")
	public String logoutAction(HttpSession session, Model model) {
		session.invalidate();
		model.addAttribute("message", "로그아웃되었습니다.");
		model.addAttribute("redirecter", "/");
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
	        request.setAttribute("message", "     ❕ 회원가입 성공 ❕<br>▫▫ 로그인 해주세요 ▫▫");
	        request.setAttribute("redirecter", "/account/login");
	        return "common/message";
	        
	    } catch (RuntimeException e) {
	        if ("duplicate_id_or_email".equals(e.getMessage())) {
	            model.addAttribute("error", "❌ 이미 사용 중인 아이디 또는 이메일입니다.");
	        } else {
	            model.addAttribute("error", "❌ 회원가입 중 오류가 발생했습니다.");
	        }
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
			
			String userId = loginUser.getId();

			
			model.addAttribute("id", loginUser.getId()); //id
			model.addAttribute("name", loginUser.getName()); //name
			model.addAttribute("email", loginUser.getEmail()); //email
			model.addAttribute("loginUser", loginUser); // 비밀번호 수정용
			
			return "account/mypage";
			}
		}
	
	
	// 비밀번호 수정
	@PostMapping("/mypage/change-password")
    public String changePassword(@RequestParam String currentPw,
                                 @RequestParam String newPw,
                                 @RequestParam String newPwCheck,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/account/login";

        User dbUser = userService.getUser(loginUser.getId());
        if (dbUser == null) return "redirect:/account/login";

        // 평문 비교
        if (!currentPw.equals(dbUser.getPw())) {
            ra.addFlashAttribute("pwMsg", "현재 비밀번호가 일치하지 않습니다.");
            ra.addFlashAttribute("pwOk", false);
            return "redirect:/account/mypage";
        }
        if (!newPw.equals(newPwCheck)) {
            ra.addFlashAttribute("pwMsg", "새 비밀번호가 서로 일치하지 않습니다.");
            ra.addFlashAttribute("pwOk", false);
            return "redirect:/account/mypage";
        }
        if (newPw.length() < 1) { // 
            ra.addFlashAttribute("pwMsg", "새 비밀번호를 입력해주세요.");
            ra.addFlashAttribute("pwOk", false);
            return "redirect:/account/mypage";
        }

        userService.updateUserPassword(loginUser.getId(), newPw);

	    // 세션 최신화
	    User updated = userService.getUser(loginUser.getId());
	    session.setAttribute("loginUser", updated);

	    ra.addFlashAttribute("pwMsg", "비밀번호가 성공적으로 변경되었습니다.");
	    ra.addFlashAttribute("pwOk", true);
	    return "redirect:/account/mypage";
	}
		
	
	
	@PostMapping("/mypage/update")
	public String updateProfile(@RequestParam String id,
	                            @RequestParam String name,
	                            @RequestParam String email,
	                            HttpSession session,
	                            RedirectAttributes ra) {

	    User user = new User();
	    user.setId(id);
	    user.setName(name);
	    user.setEmail(email);

	    if (!userService.updateUserProfile(user)) {
	        ra.addFlashAttribute("profileMsg", "이미 사용 중인 이메일입니다.");
	        ra.addFlashAttribute("profileOk", false);
	    } else {
	        // 세션 최신화
	        User updatedUser = userService.getUser(id);
	        session.setAttribute("loginUser", updatedUser);

	        ra.addFlashAttribute("profileMsg", "프로필이 성공적으로 수정되었습니다.");
	        ra.addFlashAttribute("profileOk", true);
	    }

	    return "redirect:/account/mypage";
	}
	
	

	//delete
	 @PostMapping("/delete")
	    public String deleteAccount(@RequestParam String currentPw,
	                                HttpSession session,
	                                HttpServletRequest request,
	                                RedirectAttributes ra) {
	        User loginUser = (User) session.getAttribute("loginUser");
	        if (loginUser == null) return "redirect:/account/login";

	        User dbUser = userService.getUser(loginUser.getId());
	        if (dbUser == null) return "redirect:/account/login";

	        // 평문 비교
	        if (!currentPw.equals(dbUser.getPw())) {
	            ra.addFlashAttribute("deleteMsg", "현재 비밀번호가 일치하지 않습니다.");
	            ra.addFlashAttribute("deleteOk", false);
	            return "redirect:/";
	        }

	        userService.deleteUser(dbUser.getId());
	        session.invalidate();
	        
	        request.setAttribute("message", "회원 탈퇴가 완료되었습니다.");
	        request.setAttribute("redirecter", "/");  // 홈으로 이동
	        return "common/message";
	    }
	 
	 
	 
	 

	 
	 
//	 비밀번호 찾기 즉시변경
	 

	 @GetMapping("/forgot")
	 public String forgotPasswordForm() {
	     return "account/forgot";
	 }

	 @PostMapping("/forgot")
	 public String forgotPasswordChange(
	         @RequestParam String id,
	         @RequestParam String email,
	         @RequestParam String newPw,
	         @RequestParam String newPwCheck,
	         RedirectAttributes ra,
	         HttpServletRequest request) {

	     // 앞뒤 공백 제거
	     id = id.trim();
	     email = email.trim();

	     // 1) 아이디+이메일 확인
	     User user = userService.findByIdAndEmail(id, email);
	     if (user == null) {
	         ra.addFlashAttribute("forgotMsg", "아이디와 이메일이 일치하는 계정이 없습니다.");
	         ra.addFlashAttribute("forgotOk", false);
	         return "redirect:/account/forgot";
	     }

	     // 2) 비밀번호 검증
	     if (newPw == null || newPw.isEmpty()) {
	         ra.addFlashAttribute("forgotMsg", "새 비밀번호를 입력해 주세요.");
	         ra.addFlashAttribute("forgotOk", false);
	         return "redirect:/account/forgot";
	     }
	     if (!newPw.equals(newPwCheck)) {
	         ra.addFlashAttribute("forgotMsg", "새 비밀번호가 서로 일치하지 않습니다.");
	         ra.addFlashAttribute("forgotOk", false);
	         return "redirect:/account/forgot";
	     }
			/*
			 * // 길이/규칙 간단 검증 if (newPw.length() < 4) { // 필요시 숫자/특수문자 규칙 추가
			 * ra.addFlashAttribute("forgotMsg", "비밀번호는 4자 이상으로 설정해 주세요.");
			 * ra.addFlashAttribute("forgotOk", false); return "redirect:/account/forgot"; }
			 */

	     // 3) 비밀번호 변경 
	     userService.updateUserPassword(id, newPw);

	     // 4) 완료 안내
	     request.setAttribute("message", "비밀번호가 변경되었습니다.<br>새 비밀번호로 로그인해 주세요.");
	     request.setAttribute("redirecter", "/account/login");
	     return "common/message";
	 }
	 
	 
	 
	}



	

	
	
	

	

	
	
	
	

