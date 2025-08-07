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
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			<p onClick="location.href='/service'">서비스 소개</p>
			<p onClick="location.href='/support'">고객지원</p>
			<button type="button" class="mainpage-start-btn" onClick="location.href='/login'">
				<span class="mainpage-btn-text">시작하기</span> 
				<span class="mainpage-btn-text"><i class="fa-solid fa-arrow-right"></i></span>
			</button>
		</div>
	</div>

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
	
	<div class="mainpage-func-introduce">
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
	
	<div class="seperate-line"></div>
	
	<div class="mainpage-footer">
		<div class="mp-footer-left">
			<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-footer-logo"><br>
			<span id="mp-mid-text"> 주식회사 비즈보드 </span><br>
			<span> <strong>대표</strong> 김동욱 </span><br>
			
		</div>
		
		<div class="mp-footer-mid">
			<span> <strong>Tel)</strong>070-231-6083 </span><br>
			<span> <strong>E-mail</strong> contact@bizboard.com </span><br>
			<span> <strong>주소</strong> 충청남도 천안시 동남구 대흥동 134 </span>
			
		</div>
		
		<div class="mp-footer-right">
			<span> <strong>사업자등록번호</strong> 250-86-01023 </span><br>
			<span> <strong>통신판매업 신고번호</strong> 2025-충남천안-10972 </span>
		</div>
		
		<div class="mp-footer-sns">
			<span> <a href="/support" style="text-decoration: none; color:rgb(92, 92, 92);">고객지원 문의하기</a></span><br>
			<i class="fa-brands fa-facebook"></i>
			<i class="fa-brands fa-instagram"></i>
			<i class="fa-brands fa-youtube"></i>
		</div>
		
	</div>
</body>
</html>