package com.app.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.UserDAO;
import com.app.dto.User;
import com.app.service.UserService;




@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDAO userDAO;
	
	@Override
	public int signup(User user) {
		int result = userDAO.insertUser(user);
		return result;
	}
	
	@Override
	public User login(User user) {
		System.out.println("로그인시도: " +"id: "+ user.getId()+ ", pw: " +user.getPw());
		return userDAO.loginUser(user);
	}
	
	@Override
	public User getUser(String id) {
		return userDAO.getUserById(id);
	}
	
	
}
