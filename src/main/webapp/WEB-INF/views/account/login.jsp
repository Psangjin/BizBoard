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
	width: 90%;
	padding: 12px;
	margin-bottom: 12px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
}

/* 버튼 */
.btn {
	width: 95%;
	padding: 10px;
	font-size: 16px;
	font-weight: bold;
	border: none;
	border-radius: 6px;
	color: white;
	background-color: #6c63ff;
	cursor: pointer;
	margin-bottom: 20px;
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

/* 소셜 로그인 버튼 */
.btn-social {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 90%;
	padding: 10px;
	margin-top: 10px;
	border-radius: 6px;
	font-size: 14px;
	font-weight: bold;
	text-decoration: none;
	margin-left: 5px;
	color: #333;
}

.btn-google {
	margin-top: 20px;
	background-color: #fff;
	border: 1px solid #ccc;
}

.btn-kakao {
	background-color: #FEE500;
	color: #3C1E1E;
}

.btn-naver {
	background-color: #03C75A;
	color: white;
}

.btn-social img {
	width: 20px;
	height: 20px;
	margin-right: 8px;
}
</style>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">
</head>
<body>

	<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"
			id="mainpage-header-logo" onClick="location.href='/mainpage'">
		<div class="mainpage-header-menu">
			<p onClick="location.href='/service'">서비스 소개</p>
			<p onClick="location.href='${pageContext.request.contextPath}/inquiryFAQ'">고객지원</p>

		</div>
	</div>


	<div class="form-container">
		<h2>로그인</h2>
		<form action="${ctx}/account/login" method="post">
			<input type="text" name="id" placeholder="아이디 입력" class="input-box">
			<input type="password" name="pw" placeholder="비밀번호 입력"
				class="input-box">
			<button type="submit" class="btn">로그인</button>
		</form>

		아직 계정이 없으신가요? <a href="${ctx}/account/signup"
			class="btn btn-secondary">회원가입</a> <br>
		<c:if test="${not empty error}">
			<div style="color: red; margin-top: 15px;">${error}</div>
		</c:if>



		<!-- 소셜 로그인 버튼 -->
		<a href="${ctx}/oauth2/authorization/google"
			class="btn-social btn-google"> <img src="/image/google_icon.png"
			alt="Google"> Google로 로그인
		</a> <a href="${ctx}/oauth2/authorization/kakao"
			class="btn-social btn-kakao"> <img src="/image/kakao_icon.png"
			alt="Kakao"> Kakao로 로그인
		</a> <a href="${naverLoginUrl}" class="btn-social btn-naver"> <img
			src="/image/naver_icon.png" alt="Naver"> Naver로 로그인
		</a>


		<!-- 비밀번호 찾기 -->
		<div style="margin-top:10px; font-size: 11px;">
		  비밀번호를 잃어버리셨나요? 
		  <a href="${ctx}/account/forgot"> 비밀번호 찾기</a>
		</div>

	</div>


</body>
</html>
