package com.app.dto;

import java.util.Date;

import lombok.Data;

@Data
public class User {

	String id;
	String pw;
	String email;
	String name;
	Date sign_date;
}
