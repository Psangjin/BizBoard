package com.app.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.app.dao.UserDAO;
import com.app.dto.user.User;
import com.app.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private PasswordEncoder passwordEncoder; // ★ 반드시 Bean 등록되어 있어야 함

 // UserServiceImpl.login(...) 안
    
    @Override
    public User login(User user) {
    	 User db = userDAO.getUserById(user.getId());
    	    if (db == null || user.getPw() == null) return null;
    	    
    	    return user.getPw().equals(db.getPw()) ? db : null;

    }


    @Override
    public User findByProvider(User user) {
        return userDAO.findByProvider(user);
    }

    @Override
    public void signup(User user) {
        
        try {
            int r = userDAO.insertUser(user);
            if (r != 1) throw new RuntimeException("signup_failed");
        } catch (Exception e) {
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if ((msg.contains("unique") || msg.contains("duplicate")) && msg.contains("id")) {
                throw new RuntimeException("duplicate_id_or_email");
            }
            throw new RuntimeException("signup_failed");
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

    // 
    @Override
    public void updateUserPassword(String id, String pwRaw) {
        User u = new User();
        u.setId(id);
        u.setPw(pwRaw); // 그대로 저장
        int r = userDAO.updateUserPassword(u);
        if (r != 1) throw new RuntimeException("update_password_failed");
    }

    @Override
    public int updateUserPassword(User user) {
        if (user.getPw() == null || user.getPw().isEmpty()) return 0;
        // 그대로 저장
        return userDAO.updateUserPassword(user);
    }

    @Override
    public void deleteUser(String id) {
        int r = userDAO.deleteUser(id); //
        if (r != 1) throw new RuntimeException("delete_user_failed");
    }
    
    
    public boolean updateUserProfile(User user) {
        // 이메일 중복 체크
        if (userDAO.checkEmailDuplicate(user) > 0) {
            return false; // 중복 있음
        }
        // 업데이트 실행
        return userDAO.updateUserProfile(user) > 0;
    }

   
   
}
