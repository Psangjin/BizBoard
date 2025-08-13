<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link rel="stylesheet" href="/css/mainpage.css">
<style>
.form-container{width:360px;margin:60px auto;padding:28px;background:#fff;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.1);}
.h2{font-size:20px;margin:0 0 12px;}
.input{width:100%;padding:11px;margin:8px 0;border:1px solid #ccc;border-radius:6px;font-size:14px;}
.btn{width:100%;padding:11px;margin-top:10px;font-weight:bold;border:none;border-radius:6px;color:#fff;background:#6c63ff;cursor:pointer;}
.btn:hover{background:#574bff;}
.msg{margin-top:10px;}
</style>
</head>
<body>
  <div class="form-container">
    <div class="h2">비밀번호 찾기</div>

    <form action="${ctx}/account/forgot" method="post">
      <input type="text"     name="id"         placeholder="아이디"         class="input" required>
      <input type="email"    name="email"      placeholder="가입한 이메일"  class="input" required>
      <input type="password" name="newPw"      placeholder="새 비밀번호"    class="input" required>
      <input type="password" name="newPwCheck" placeholder="새 비밀번호 확인" class="input" required>
      <button type="submit" class="btn">비밀번호 변경</button>
    </form>

    <div class="msg">
      <c:if test="${not empty forgotMsg}">
        <span style="color:${forgotOk ? 'green':'red'}">${forgotMsg}</span>
      </c:if>
    </div>

    <div class="msg" style="text-align:center;margin-top:12px;">
      <a href="${ctx}/account/login">로그인 페이지로</a>
    </div>
  </div>
</body>
</html>
