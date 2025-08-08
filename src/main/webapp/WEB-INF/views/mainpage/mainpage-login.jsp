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
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo" id="mainpage-header-logo" onClick="location.href='/mainpage'">
		<div class="mainpage-header-menu">
			<p onClick="location.href='/service'">서비스 소개</p>
			<p onClick="location.href='/support'">고객지원</p>
			<p onClick="location.href='/account/mypage'">마이페이지</p>
		</div>
		<i class="fa-solid fa-arrow-right-from-bracket" id="mainpage-header-icon" onClick="location.href='/'"></i>
	</div>

	<div class='mainpage-container'>
		<div class='mainpage-left'>
			<div class='mainpage-contents'>
				<div class="contents-text">데일리 스케줄</div>
				<div class='mainpage-contents-box'></div>
			</div>
			<div class='mainpage-contents'>
				<div class="contents-text">오늘 할 일</div>
				<div class='mainpage-contents-box'></div>
			</div>
		</div>

		<div class='mainpage-right'>
			<div class="contents-text">참여중인 프로젝트</div>
			<div class='mainpage-contents-box'></div>
		</div>
	</div>

</body>
</html>