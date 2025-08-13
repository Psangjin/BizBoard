package com.app.dao;

import com.app.dto.user.User;


public interface UserDAO {
	 // 로그인
     User loginUser(User user);

    // SNS 회원 조회
     User findByProvider(User user);

    // 회원가입
     int insertUser(User user);  // insert니까 반환값 int로

    // 사용자 정보 조회
     User getUserById(String id);
     
    // 이메일 중복 체크
     User findByEmail(String email);

     //이메일추출
     String findEmailByUser(User user);
}
