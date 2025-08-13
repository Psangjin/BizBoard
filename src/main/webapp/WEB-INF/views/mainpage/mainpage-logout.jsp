<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BizBoard</title>
</head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">
<body>

	<%@ include file="/WEB-INF/views/common/logout-header.jsp" %>

	<div class="mainpage-logout-container">
		<img src="/image/main.jpg" alt="mainpage_img" id="mainpage-image">
		<div class="mainpage-slogan">
			<div class="mainpage-slogan-text1">
				<span>당신의 팀을 위한 스마트 스케줄 보드,</span><br> <span>BizBoard</span>
			</div>
			<div class="mainpage-slogan-text2">
				<span>캘린더, 할 일, 협업 기능을 한 곳에 담았습니다.</span><br> 
				<span>더 나은	소통과 정돈된 팀워크를 경험해보세요.</span>
			</div>
		</div>
		<button type="button" class="mainpage-start-btn mainpage-start-btn2" onClick="location.href='/account/login'">
			<span class="mainpage-btn-text">시작하기</span> 
			<span class="mainpage-btn-text"><i class="fa-solid fa-arrow-right"></i></span>
		</button>
	</div>
	
	<%@ include file="/WEB-INF/views/service/features.jsp" %>
	
	<%@ include file="/WEB-INF/views/pricing/pricing.jsp" %>
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
	
</body>
</html>