package com.app.service;

import com.app.dto.user.User;

public interface UserService {
	public User login(User user);						// 일반 로그인
	public User findByProvider(User user);				// SNS 회원 조회
	public void signup(User user);						// 일반 회원가입					
	public User getUser(String id); 					// ID로 사용자 조회
	public User findByEmail(String email);  			// 이메일로 사용자 조회
	
	public String findEmailByUser(User user);			//이메일 추출
	public int updateUserPassword(User user);			// 마이페이지 비밀번호 변경
	public void deleteUser(String id);
	public void updateUserPassword(String id, String encoded);
	
	boolean updateUserProfile(User user);

	// 아이디 이메일 확인 비번 변경
	User findByIdAndEmail(String id, String email);

}

