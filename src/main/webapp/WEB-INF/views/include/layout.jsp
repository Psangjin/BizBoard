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
<input type="hidden" id="project-id" value="${sessionScope.project.id}">
<%-- <input type="hidden" id="login-user" value="${loginUser}"> --%>

<div class="layout-wrapper">
	<!-- 헤더 부분 -->
	<div class="header">
		<div class="header-menu-and-logo">
			<i class="fa-solid fa-bars fa-2xl" id="toggleSidebar"
				style="padding-right: 15px; cursor: pointer;"></i>
			<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo" id="header-logo"/>
		</div>
		<h2>${sessionScope.loginUser.name != null ? sessionScope.loginUser.name : ''}</h2>
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
				<i class="fa-solid fa-user-pen fa-xl" id="fa-user-pen-icon"></i>
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
    <div class="fab-item" data-popup="프로젝트 관련">
      📁
      <div class="fab-popup fab-project-popup">
      		<h3 class="project-list-btn">프로젝트 목록</h3>
      	<div class="fab-popup-project-list">
      	  <ul>
	      </ul>
      	</div>
	      
	      <div class="popup-divider"></div>
	      <div class="create-project-wrapper">
		    <button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
		  </div>
      </div>
    </div>
    <div class="fab-item" data-popup="채팅 알림">
      💬
      <div class="fab-popup">
        <strong>채팅</strong>
        <ul>
          <li>메시지 보기</li>
          <li>새 메시지</li>
        </ul>
      </div>
    </div>
    <div class="fab-item" data-popup="알림 목록">
      🔔
      <div class="fab-popup">
        <strong>알림</strong>
        <ul>
          <li>읽지 않은 알림</li>
          <li>전체 알림</li>
        </ul>
      </div>
    </div>
  </div>
</div>
<%@ include file="../include/createProjectModal.jsp"%>
</body>
</html>