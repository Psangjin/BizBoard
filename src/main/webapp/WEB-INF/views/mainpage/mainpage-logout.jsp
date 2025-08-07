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

	<%@ include file="/WEB-INF/views/common/header.jsp" %>

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
		<button type="button" class="mainpage-start-btn mainpage-start-btn2" onClick="location.href='/mainpage'">
			<span class="mainpage-btn-text">시작하기</span> 
			<span class="mainpage-btn-text"><i class="fa-solid fa-arrow-right"></i></span>
		</button>
	</div>
	
	<div id="service-introduce" class="mainpage-func-introduce">
		<div class="mainpage-func-title">
			<p id="mainpage-func-ft">Features</p>
			<p id="mainpage-func-intro">비즈보드 기능 소개</p>
		</div>
		<div class="mainpage-func-detail">
			<div class="mainpage-func-division">
				<p class="mp-func-single mp-border">개인</p>
				<p class="mp-func-team1 mp-border">프로젝트</p>
			</div>
			
			<div class="mainpage-func-st">
				<div class="mainpage-func-items1 mp-func-custom">
					<div class="mp-func-single">
					<img src="/image/function-icons/1.png" alt="s-calendar" class="mp-func-icon">
						<p class="mp-func-text">개인 캘린더</p>
						<span>내 일정과 할 일을 <br>체계적으로 관리합니다.</span>
					</div>
					<div class="mp-func-single">
					<img src="/image/function-icons/2.png" alt="s-note" class="mp-func-icon">
						<p class="mp-func-text">개인 노트</p>
						<span>아이디어, 메모 등을 자유롭게 <br>작성하고 저장합니다.
						</span>
					</div>
					<div class="mp-func-single">
					<img src="/image/function-icons/3.png" alt="s-alert" class="mp-func-icon">
						<p class="mp-func-text">알림</p>
						<span>중요한 일정이나 메시지를 <br>실시간으로 받아볼 수 있습니다.
						</span>
					</div>
					<div class="mp-func-single">
					<img src="/image/function-icons/4.png" alt="s-message" class="mp-func-icon">
						<p class="mp-func-text">메시지</p>
						<span>팀원과의 소통이 가능한 <br>1:1 메시지를 제공합니다.
						</span>
					</div>
				</div>
				<div class="mainpage-func-items2 mp-func-custom">
					<div class="mp-func-team2">
					<img src="/image/function-icons/5.png" alt="t-calendar" class="mp-func-icon">
						<p class="mp-func-text">공유 캘린더</p>
						<span>팀의 프로젝트 일정을 <br>공유하고 함께 관리합니다.
						</span>
					</div>
					<div class="mp-func-team2">
					<img src="/image/function-icons/6.png" alt="t-note" class="mp-func-icon">
						<p class="mp-func-text">공유 노트</p>
						<span>회의록, 작업 가이드 등 <br>공유 정보를 기록합니다.
						</span>
					</div>
					<div class="mp-func-team2">
					<img src="/image/function-icons/7.png" alt="t-notice" class="mp-func-icon">
						<p class="mp-func-text">공지</p>
						<span>팀 전체에게 전달할 공지사항을 <br>작성하고 알립니다.
						</span>
					</div>
				</div>
				<div class="mainpage-func-items2 mp-func-custom">
					<div class="mp-func-team2">
					<img src="/image/function-icons/8.png" alt="t-progress" class="mp-func-icon">
						<p class="mp-func-text">진행도</p>
						<span>업무 진행도를 수치화하여 <br>한눈에 확인합니다.
						</span>
					</div>
					<div class="mp-func-team2">
					<img src="/image/function-icons/9.png" alt="t-chart" class="mp-func-icon">
						<p class="mp-func-text">간트차트</p>
						<span>작업 일정과 흐름을 차트로 <br>시각화하여 확인합니다.
						</span>
					</div>
					<div class="mp-func-team2">
					<img src="/image/function-icons/10.png" alt="t-comment" class="mp-func-icon">
						<p class="mp-func-text">파일 및 코멘트</p>
						<span>작업별 파일을 첨부하고 의견을 <br>남겨 협업을 강화합니다.
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
	
</body>
</html>