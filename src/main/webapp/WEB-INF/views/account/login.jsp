<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<style>
/* 전체 박스 */
.form-container {
    width: 350px;
    margin: 60px auto;
    padding: 30px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    text-align: center;
}

/* 제목 */
.form-container h2 {
    font-size: 24px;
    margin-bottom: 20px;
}

/* 입력창 */
.input-box {
    width: 100%;
    padding: 12px;
    margin-bottom: 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
}

/* 버튼 */
.btn {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    font-weight: bold;
    border: none;
    border-radius: 6px;
    color: white;
    background-color: #6c63ff;
    cursor: pointer;
    margin-bottom: 10px;
}

.btn:hover {
    background-color: #574bff;
}

/* 보조 버튼 (로그인 페이지로, 회원가입 페이지로) */
.btn-secondary {
    background-color: #8b85ff;
}

.btn-secondary:hover {
    background-color: #766df5;
}

</style>
</head>
<body>

<div class="form-container">
    <h2>로그인</h2>
    <form action="${ctx}/account/login" method="post">
        <input type="text" name="id" placeholder="아이디 입력" class="input-box">
        <input type="password" name="password" placeholder="비밀번호 입력" class="input-box">
        <button type="submit" class="btn">로그인</button>
    </form>
    
    <a href="${ctx}/account/signup" class="btn btn-secondary">회원가입</a>
</div>


</body>
</html>
