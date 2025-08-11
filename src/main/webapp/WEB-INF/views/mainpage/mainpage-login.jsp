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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
				
			<div class='mainpage-contents-box'>
			  <div class="fab-item" data-popup="프로젝트 관련">
			    <div class="fab-popup fab-project-popup">
			      <div class="fab-popup-project-list">
			        <ul id="mainpage-project-list">
			          <!-- JS에서 li 항목들 생성 -->
			        </ul>
			      </div>
			      
			      <div class="popup-divider"></div>
			      <div class="create-project-wrapper">
			        <button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
			      </div>
			    </div>
			  </div>
			</div>
		</div>
	</div>
<script>

document.addEventListener('DOMContentLoaded', function () {
	  
	  $.ajax({
	    url: '/project/listByUserId',
	    method: 'GET',
	    dataType: 'json', // JSON 형식으로 받기
	    success: function (projects) {
	    	const $popupList = document.querySelector('#mainpage-project-list');

	      if (!projects || projects.length === 0) {
	        $popupList.innerHTML = '<li>참여중인 프로젝트가 없습니다</li>';
	        return;
	      }

	      $popupList.innerHTML = '';
	   
	      projects.forEach(function (myProject) {
	        const li = document.createElement('li');
	        li.textContent = myProject.title;
	        li.dataset.id = myProject.id;
	        console.log(myProject);

	        li.addEventListener('click', () => {
	        	  console.log('클릭됨:', myProject);
	        	  $.ajax({
	        	    url: '/project/setSession',
	        	    method: 'POST',
	        	    data: JSON.stringify(myProject),
	        	    contentType: 'application/json',
	        	    success: function () {
	        	        location.href = `/project/main/`+myProject.id;
	        	    },
	        	    error: function () {
	        	      alert('프로젝트 세션 저장에 실패했습니다.');
	        	    }
	        	  });
	        	});

	        $popupList.appendChild(li);
	      });
	    },
	    error: function () {
	      alert("프로젝트 목록을 불러오는 데 실패했습니다.");
	    }
	  });

	});
</script>
</body>
</html>