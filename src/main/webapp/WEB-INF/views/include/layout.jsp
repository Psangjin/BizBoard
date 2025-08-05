<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BizBoard 디자인2</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<!-- 공통 CSS -->
  <link rel="stylesheet" href="/css/common.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="/js/common.js"></script>
</head>
<body>
<div class="layout-wrapper">
	<!-- 헤더 부분 -->
	<div class="header">
		<div class="header-menu-and-logo">
			<i class="fa-solid fa-bars fa-2xl" id="toggleSidebar"
				style="padding-right: 15px; cursor: pointer;"></i>
			<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo" id="header-logo"/>
		</div>
		<h2>로그인</h2>
	</div>
	<!-- 바디 부분 -->
	<div class="body">
		<!-- 사이드 메뉴 바  -->
		<div class="body-side-menubar">
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-house fa-xl" id="fa-project-icon" style="cursor: pointer;"></i>
			</div>
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-calendar fa-xl" id="fa-calendar-icon" style="cursor: pointer;"></i>
			</div>
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-note-sticky fa-xl"></i>
			</div>
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-arrow-right-arrow-left fa-xl"></i>
			</div>
		</div>
		<div>
		<!--             본문 내용                 -->
<!-- 		</div>
 	</div>
</div> -->
		<div class="fab-wrapper">
			<button class="fab-main">＋</button>
		  <div class="fab-menu">
		  	<button class="fab-item">📁</button>
		    <button class="fab-item">💬</button>
		    <button class="fab-item">🔔</button>
		    
		  </div>
		</div>

</body>
</html>