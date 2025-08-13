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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>

	<%@ include file="/WEB-INF/views/common/login-header.jsp" %>

	<div class='mainpage-container'>
		<div class='mainpage-left'>
			<div class='mainpage-contents'>
				<div class="contents-text">데일리 스케줄</div>
				<div class='mainpage-contents-box'>
				<ul id="daily-schedule-list">
                </ul>
                </div>
			</div>
			<div class='mainpage-contents'>
				<div class="contents-text">오늘 할 일</div>
				<div class='mainpage-contents-box'>
				<ul id="today-tasks-list">
                </ul>
				</div>
			</div>
		</div>

		<div class='mainpage-right'>
			<div class="contents-text">
			<div>참여중인 프로젝트</div>
			<div class="create-project-wrapper" style="display:inline;">
		        <button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
		      </div>
			</div>
			
			<div class='mainpage-contents-box mainpage-scroll-long'>
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

	$.ajax({
        url: '/main/data',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            const dailySchedules = data.dailySchedules;
            const todayTasks = data.todayTasks;
            
            // 데일리 스케줄 리스트 렌더링
            const dailyScheduleList = document.getElementById('daily-schedule-list');
            const dailyScheduleFragment = document.createDocumentFragment();

            if (dailySchedules.length === 0) {
                dailyScheduleList.innerHTML = '<li class="no-data">데일리 스케줄이 없습니다.</li>';
            } else {
                dailySchedules.forEach(schedule => {
                    const li = document.createElement('li');
                    
                    const containerDiv = document.createElement('div');
                    containerDiv.classList.add('schedule-item-container');

                    const titleSpan = document.createElement('span');
                    titleSpan.classList.add('schedule-item-title');
                    titleSpan.textContent = schedule.title;
                    
                    const projectTitleSpan = document.createElement('span');
                    projectTitleSpan.classList.add('schedule-item-project-title');
                    projectTitleSpan.textContent = schedule.projectTitle;
                    
                    containerDiv.appendChild(titleSpan);
                    containerDiv.appendChild(projectTitleSpan);
                    
                    li.appendChild(containerDiv);
                    dailyScheduleFragment.appendChild(li);
                });
                dailyScheduleList.appendChild(dailyScheduleFragment);
            }

            // 오늘 할 일 리스트 렌더링
            const todayTasksList = document.getElementById('today-tasks-list');
            const todayTasksFragment = document.createDocumentFragment();

            if (todayTasks.length === 0) {
                todayTasksList.innerHTML = '<li class="no-data">오늘 할 일이 없습니다.</li>';
            } else {
                todayTasks.forEach(task => {
                    const li = document.createElement('li');

                    const containerDiv = document.createElement('div');
                    containerDiv.classList.add('task-item-container');

                    const titleSpan = document.createElement('span');
                    titleSpan.classList.add('task-item-title');
                    titleSpan.textContent = task.title;

                    const projectTitleSpan = document.createElement('span');
                    projectTitleSpan.classList.add('task-item-project-title');
                    projectTitleSpan.textContent = task.projectTitle;

                    containerDiv.appendChild(titleSpan);
                    containerDiv.appendChild(projectTitleSpan);

                    li.appendChild(containerDiv);
                    todayTasksFragment.appendChild(li);
                });
                todayTasksList.appendChild(todayTasksFragment);
            }
        },
        error: function(xhr) {
            console.error("데이터를 불러오는 데 실패했습니다: " + xhr.statusText);
        }
    });
	
    // Function to fetch and render the project list
    function fetchProjectsAndRender() {
        $.ajax({
            url: '/project/listByUserId',
            method: 'GET',
            dataType: 'json',
            success: function (projects) {
                renderProjectList(projects, '#mainpage-project-list');
            },
            error: function () {
                alert("프로젝트 목록을 불러오는 데 실패했습니다.");
            }
        });
    }

    // Function to render projects to a specific list
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
    
    // Call the function to fetch and render projects
    fetchProjectsAndRender();
});
</script>
</script>
</body>
</html>