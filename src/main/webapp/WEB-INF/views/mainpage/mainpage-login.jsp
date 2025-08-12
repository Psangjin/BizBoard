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
			<div class="contents-text">
			<div>참여중인 프로젝트</div>
			<div class="create-project-wrapper" style="display:inline;">
		        <button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
		      </div>
			</div>
			
			<div class='mainpage-contents-box'>
			  <div class="fab-item" data-popup="프로젝트 관련">
			    <div class="fab-popup fab-project-popup">
			      <div class="fab-popup-project-list">
			        <ul id="mainpage-project-list">
			          <!-- JS에서 li 항목들 생성 -->
			        </ul>
			      </div>
			      
			    </div>
			  </div>
			</div>
		</div>
	</div>
	
<%@ include file="../include/createProjectModal.jsp"%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    // 프로젝트 목록을 가져오는 단일 함수
    function fetchProjectsAndRender() {
        $.ajax({
            url: '/project/listByUserId',
            method: 'GET',
            dataType: 'json',
            success: function (projects) {
                // 프로젝트 목록을 렌더링하는 함수 호출
                renderProjectList(projects, '#mainpage-project-list');
                renderProjectList(projects, '.fab-item[data-popup="프로젝트 관련"] .fab-popup ul');
            },
            error: function () {
                alert("프로젝트 목록을 불러오는 데 실패했습니다.");
            }
        });
    }

    // 프로젝트 목록을 특정 ul에 렌더링하는 함수
    function renderProjectList(projects, selector) {
        const $popupList = document.querySelector(selector);
        
        if (!projects || projects.length === 0) {
            if ($popupList) {
                $popupList.innerHTML = '<li>참여중인 프로젝트가 없습니다</li>';
            }
            return;
        }

        if ($popupList) {
            $popupList.innerHTML = '';
            projects.forEach(function (project) {
                const li = document.createElement('li');
                li.textContent = project.title;
                li.dataset.id = project.id;

                li.addEventListener('click', () => {
                    $.ajax({
                        url: '/project/setSession',
                        method: 'POST',
                        data: JSON.stringify(project),
                        contentType: 'application/json',
                        success: function () {
                            location.href = `/project/main/` + project.id;
                        },
                        error: function () {
                            alert('프로젝트 세션 저장에 실패했습니다.');
                        }
                    });
                });
                $popupList.appendChild(li);
            });
        }
    }
    
    // 페이지 로드 시 프로젝트 목록 가져오기
    fetchProjectsAndRender();
});
</script>
</body>
</html>