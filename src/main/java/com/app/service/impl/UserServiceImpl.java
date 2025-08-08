package com.app.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.UserDAO;
import com.app.dto.user.User;
import com.app.service.UserService;




@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDAO userDAO;
	
	 @Override
	    public User login(User user) {
	        System.out.println("로그인 시도: id=" + user.getId() + ", pw=" + user.getPw());
	        return userDAO.loginUser(user);
	    }

	 @Override
	    public User findByProvider(User user) {
	        return userDAO.findByProvider(user);	        
	    }
	 
	 
	 @Override
	 public void signup(User user) {
	     System.out.println("회원가입 시도: " + user);

	     try {
	         userDAO.insertUser(user); // 실제 DB insert
	     } catch (Exception e) {
	         String msg = e.getMessage().toLowerCase();

	         if ((msg.contains("unique") || msg.contains("duplicate")) && msg.contains("id")) {
	             throw new RuntimeException("duplicate_id");
	         } else {
	             throw new RuntimeException("signup_failed");
	         }
	     }
	 }
	  
  
	  @Override
	    public User getUser(String id) {
	        return userDAO.getUserById(id);
	    }

	    	   
	  @Override
	    public User findByEmail(String email) {
	        return userDAO.findByEmail(email);
	    }
	    
	  
	  @Override
	  public int updateUserPassword(User user) {
	      return userDAO.updateUserPassword(user);
	  }

	  
	    
	}
