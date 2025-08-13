package com.app.dao.impl;


import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.UserDAO;
import com.app.dto.user.User;

@Repository
public class UserDAOImpl implements UserDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
    public User loginUser(User user) {
        return sqlSession.selectOne("user_mapper.loginUser", user);
    }

    @Override
    public User findByProvider(User user) {
        return sqlSession.selectOne("user_mapper.findByProvider", user);
    }

    @Override
    public int insertUser(User user) {
        return sqlSession.insert("user_mapper.insertUser", user);
    }

    @Override
    public User getUserById(String id) {
        return sqlSession.selectOne("user_mapper.getUserById", id);
    }
    
    @Override
    public User findByEmail(String email) {
        return sqlSession.selectOne("user_mapper.findByEmail", email);
    }
    
    @Override
    public int updateUserPassword(User user) {
        return sqlSession.update("user_mapper.updateUserPassword", user);
    }
    
    @Override
    public int deleteUser(String id) {
        return sqlSession.delete("user_mapper.deleteUser", id);
    }

    @Override
    public int checkEmailDuplicate(User user) {
        return sqlSession.selectOne("user_mapper.checkEmailDuplicate", user);
    }

    @Override
    public int updateUserProfile(User user) {
        return sqlSession.update("user_mapper.updateUserProfile", user);
    }
    
    
 // 비번찾기
    @Override
    public User findByIdAndEmail(String id, String email) {
        Map<String, Object> param = new HashMap<>();
        param.put("id", id);
        param.put("email", email);
        return sqlSession.selectOne("user_mapper.findByIdAndEmail", param);
    }


}
