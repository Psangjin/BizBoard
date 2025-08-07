package com.app.dto.user;

import lombok.Data;

@Data
public class User {
    private String id;          // 일반회원 ID 또는 provider_id
    private String pw;          // 비밀번호 (SNS는 null 가능)
    private String email;       // 이메일
    private String name;        // 이름    
    private String signDate;    // 가입일 (String으로 받으면 편함)
}
