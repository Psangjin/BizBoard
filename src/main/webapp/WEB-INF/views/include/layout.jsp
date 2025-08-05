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
  <style>
  * {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: sans-serif;
	background-color: #296aa2;
	display: flex;
	height: 100vh;
	width:100vw;
}

/* 전체 감싸는 컨테이너 */
.calendar-wrapper {
	width: 99vw;
	height: 98vh;
	/* max-width : 1200px; */
	background-color: #fff;
	border-radius: 20px 0 0 0;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
	position: absolute;
	bottom:0;
	right:0;
	overflow: hidden;
	display: flex;
	flex-direction: column;
}

.header {
	height: 10vh;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 30px;
	background-color: #95afc0;
}

.header-menu-and-logo {
	display: flex;
	align-items: center;
}

#header-logo {
	height:8vh;
	cursor: pointer;
}
.body {
	display: flex;
	background-color: white;
	height: 88vh;
}

.body-side-menubar {
	width: 6vw;
	background-color: #95afc0;
	display: flex;
	flex-direction: column;
	align-items: center;
	padding-top: 20px;
	transition: all 0.3s ease;
}

.body-side-menubar.hidden {
	transform: translateX(-100%);
}

.body-side-menubar.background-invisible {
	background-color: #296aa2;
}

.body-side-menubar-items {
	margin: 20px 0;
}

.body-side-menubar-items i {
  transition: color 0.3s ease, background-color 0.3s ease, transform 0.3s ease;
  padding: 5px;
  border-radius: 8px;
}

.body-side-menubar-items i:hover {
  color: #ffffff;
  background-color: rgba(255, 204, 0, 0.1);
  transform: scale(1.4);
  cursor: pointer;
}
/*에디트추가*/
.fa-user-pen-edit{
	transform: scale(1.4);
	color:red;
}


/* 오른쪽 아래 고정 */
.fab-wrapper {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 1000;
  display: flex;
  flex-direction: column-reverse;
  align-items: flex-end;
  font-family: 'Segoe UI', sans-serif;
}

/* + 버튼 스타일 */
.fab-main {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: #4DAEFF;
  color: white;
  font-size: 36px;
  border: none;
  cursor: pointer;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
  margin: 10px auto;
  transition: background-color 0.3s, transform 0.2s;
}

.fab-main:hover {
  background-color: #3498db;
  transform: scale(1.05);
}

/* 메뉴 컨테이너 초기 상태(숨김) */
.fab-menu {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 10px;
  border-radius: 10px;
  margin-bottom: 12px;
  background-color: lightblue;

  opacity: 0;
  transform: translateY(10px);
  pointer-events: none; /* 클릭 불가 */
  transition: all 0.3s ease;
}

/* JS에서 .fab-menu의 opacity, pointer-events, transform 조절 */

/* 메뉴 버튼 */
.fab-item {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  color: #333;
  font-size: 16px;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  transition: background-color 0.2s;
  display: flex;
  justify-content: center;
  align-items: center;
}

.fab-item:hover {
  background-color: #f9f9f9;
}
</style>
</head>
<body>
<div class="calendar-wrapper">
	<!-- 헤더 부분 -->
	<div class="header">
		<div class="header-menu-and-logo">
			<i class="fa-solid fa-bars fa-2xl" id="toggleSidebar"
				style="padding-right: 15px; cursor: pointer;"></i>
			<img src="http://localhost:8080/image/BizBoard_Logo.png" alt="BizBoard_Logo" id="header-logo"/>
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
				<i class="fa-solid fa-note-sticky fa-xl" id="fa-note-icon" style="cursor: pointer;"></i>
			</div>
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-arrow-right-arrow-left fa-xl"></i>
			</div>
			<div class="body-side-menubar-items">
				<i class="fa-solid fa-user-pen fa-xl"></i>
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