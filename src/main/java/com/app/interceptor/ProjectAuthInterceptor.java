package com.app.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;

import com.app.dto.project.Project;

public class ProjectAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        // 1. 세션에 사용자 ID가 없는 경우 (로그인X)
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect("/account/login"); // 로그인 페이지로 리다이렉트
            return false; 
        }

        // 2. 세션에 저장된 프로젝트 ID가 없는 경우
        if (session.getAttribute("project") == null) {
            response.sendRedirect("/error"); 
            return false;
        }
        Project project = (Project) session.getAttribute("project");
        Long sessionProjectId = project.getId();
        

        // 3. URL에서 projectId를 추출하여 세션의 프로젝트 ID와 비교
        String pathInfo = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        Long urlProjectId = null;


        // URL의 projectId와 세션의 projectId가 일치하는지 확인
        if (urlProjectId != null && !urlProjectId.equals(sessionProjectId)) {
            response.sendRedirect("/error"); // 불일치 시 에러 페이지로 이동
            return false; 
        }

        // 모든 검증 통과
        return true; 
    }
}