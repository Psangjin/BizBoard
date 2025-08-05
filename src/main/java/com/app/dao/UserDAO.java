package com.app.dao;

import com.app.dto.User;

public interface UserDAO {

	public int insertUser(User user);
	
	public User loginUser(User user);
	
	public User getUserById(String id);
}
