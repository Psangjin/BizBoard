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

	<%@ include file="/WEB-INF/views/common/login-header.jsp" %>

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
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>