<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">
<body>
	<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"
			id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			<p onClick="location.href='/service'">서비스 소개</p>
			<p onClick="location.href='${pageContext.request.contextPath}/inquiryFAQ'">고객지원</p>

			<div class="user-dropdown">
				<i class="fa-solid fa-user-check mainpage-header-icon"
					id="mainpage-header-icon"></i>
				<ul class="dropdown-menu">
					<li onClick="location.href='/account/mypage'">개인정보 수정</li>
					<li id="btnOpenDeleteModal">회원탈퇴</li>
				</ul>

				<i class="fa-solid fa-arrow-right-from-bracket"
					id="mainpage-header-icon" onClick="location.href='/account/logout'"></i>
			</div>
		</div>
	</div>
	
</body>
</html>