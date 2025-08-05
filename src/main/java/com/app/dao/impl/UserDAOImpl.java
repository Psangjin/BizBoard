package com.app.dao.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.UserDAO;
import com.app.dto.User;

@Repository
public class UserDAOImpl implements UserDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	public int insertUser(User user) {
		int result = sqlSession.insert("user_mapper.insertUser", user);
		return result;
	}
	
	
	public User loginUser(User user) {
		User loginUser = sqlSession.selectOne("user_mapper.loginUser", user);
		return loginUser;
	}
	
	
	public User getUserById(String id) {
		User user = sqlSession.selectOne("user_mapper.getUserById", id);
		return user;
	}
}
