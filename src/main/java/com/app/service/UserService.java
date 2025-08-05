package com.app.service;

import com.app.dto.User;

public interface UserService {
	 public int signup(User user);
	 public User login(User user);
	 public User getUser(String id);
}
