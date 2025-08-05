<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Calendar Page</title>
<!-- ✅ Bootstrap 5.3 CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />

<!-- ✅ Bootstrap 5.3 JS (팝업/기능 사용 시 필요) -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet"
	href="https://unpkg.com/frappe-gantt/dist/frappe-gantt.css" />
<script src="https://unpkg.com/frappe-gantt/dist/frappe-gantt.umd.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.18/index.global.min.js"></script>
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
	justify-content: center;
	align-items: center;
	min-height: 100vh;
}

/* 전체 감싸는 컨테이너 */
.calendar-wrapper {
	width: 98vw;
	height: 90vh;
	/* max-width : 1200px; */
	background-color: #fff;
	border-radius: 20px;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
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
	background-color: #3c85da;
}

.header-menu-and-logo {
	display: flex;
	align-items: center;
}

.body {
	display: flex;
	background-color: white;
	height: 80vh;
}

.body-side-menubar {
	width: 8vw;
	background-color: #3c85da;
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

.body-container {
	width: 90vw;
	flex: 1;
	display: flex;
	padding: 5px;
}

.body-left {
	height: 100%;
	flex: 1;
	min-width: 230px;
	position: relative;
}

#external-events {
	position: relative;
	top: 10px;
	width: 80%;
	border: 1px solid #ccc;
	padding: 10px;
	margin: 10px auto;
	border-radius: 10px;
	background-color: #f0f0f0;
}

.fc-event {
	background-color: #007bff;
	color: white;
	padding: 4px;
	margin: 4px 0;
	border-radius: 4px;
	cursor: move;
}

.cal-red-bg {
	background-color: red;
}

.cal-blue-bg {
	background-color: blue;
}

.fc-day-today {
	background-color: #ffecb3 !important;
	border: 2px solid #ffa000;
	font-weight: bold;
}

#calendar {
	flex-grow: 4;
}

#event-details {
	position: absolute;
	bottom: 10px;
	left: 50%;
	transform: translate(-50%, 0%);
	width: 200px;
	height: 300px; /* ✅ 일정한 높이로 고정 */
	overflow-x: hidden;
	overflow-y: scroll; /* 내용 넘칠 경우 숨김 */
	background-color: #f9f9f9;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	font-size: 14px;
	display: none;
	border: 1px solid #ccc;
	padding: 10px;
	margin: 10px auto;
	border-radius: 10px;
}

#event-details h3 {
	margin-bottom: 8px;
	color: #333;
}

#event-details p {
	margin: 5px 0;
}

#eventModal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 500px;
	max-width: 90%;
	padding: 30px 25px;
	background: #ffffff;
	border-radius: 16px;
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
	border: none;
	z-index: 1000;
	font-family: 'Segoe UI', sans-serif;
	color: #333;
}

#eventModal h2 {
	margin-top: 0;
	font-size: 22px;
	margin-bottom: 20px;
	color: #2c3e50;
}

#eventModal input[type="text"] {
	width: 100%;
	height: 42px;
	padding: 8px 12px;
	margin-bottom: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 15px;
	transition: border-color 0.3s ease;
}

#eventModal textarea {
	width: 100%;
	height: 120px;
	padding: 10px 12px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 15px;
	resize: vertical;
	transition: border-color 0.3s ease;
	font-family: inherit;
}

#eventModal input[type="text"]:focus, #eventModal textarea:focus {
	border-color: #446dff;
	outline: none;
}

#eventModal button {
	background-color: #446dff;
	color: white;
	padding: 10px 18px;
	border: none;
	border-radius: 8px;
	font-size: 15px;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

#eventModal button:hover {
	background-color: #3344dd;
}
/***********************************************/
.hidden-view-section {
  visibility: hidden;
  pointer-events: none;
}

.hidden-section {
	display: none !important;
}
/***/
.body-right {
	height: 100%;
	flex: 4;
	min-width: 0; /* ← 필수 */
	overflow: hidden !important; /* or auto */
}

#gantt {
	width: 100%;
	height: 100%;
	display: flex;
	flex-direction: column;
	z-index: 1;
}

#gantt-up-area {
	height: 6%;
	display: flex;
	align-items: center;
	padding: 0 20px;
}

#gantt-header-toolbar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
}

#work-manage-btn {
	padding: 6px 12px;
	background-color: #ffffff;
	color: #3c85da;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-weight: bold;
	cursor: pointer;
}

#gantt-target {
	height: 94%;
	width: 100%;
	z-index: 1;
}

/* 캘린더 글자색 */
.fc a {
	color: black !important;
	text-decoration: none;
}

#ganttTaskModal{
  display: none;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 500px;
  max-width: 90%;
  padding: 30px 25px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
  border: none;
  z-index: 1000;
  font-family: 'Segoe UI', sans-serif;
  color: #333;
}
#ganttTaskBackdrop{
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 999;
}
#task-detail-panel {
	position: absolute;
	bottom: 10px;
	left: 50%;
	transform: translate(-50%, 0%);
	width: 200px;
	height: 300px; /* ✅ 일정한 높이로 고정 */
	overflow-x: hidden;
	overflow-y: scroll; /* 내용 넘칠 경우 숨김 */
	background-color: #f9f9f9;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	font-size: 14px;
	display: none;
	border: 1px solid #ccc;
	padding: 10px;
	margin: 10px auto;
	border-radius: 10px;
}

#task-detail-panel h3 {
	margin-bottom: 8px;
	color: #333;
}

#task-detail-panel p {
	margin: 5px 0;
}
#detail-member {
  white-space: nowrap;       /* 줄바꿈 금지 */
  overflow: auto;          /* 넘치는 부분 숨김 */
  display: block;            /* span이 기본 inline이므로 block으로 설정 */
}

#work-edit-modal button{
	width: 100%;
	display: block;
	margin: 1%;
}
#task-detail-panel button{
	display: block;
	margin: 1%;
}
#gantt-target{
	height: 60vh;
}
.gantt-container{
	width:100% !important;
	height: 60vh !important;
}
#gantt{
	width:100% !important;
	height: 100%;
	overflow: hidden !important;
}
.bar {
  height: 38px !important;
}

.bar-wrapper, .bar-group {
  height: 50px !important;
}

.grid-row {
  height: 50px !important;
}
.bar-progress{
	height: 38px !important;
}

</style>
</head>
<body>
	<!-- 메인 화면이 창처럼 떠있게 -->
	<div class="calendar-wrapper">
		<!-- 헤더 부분 -->
		<div class="header">
			<div class="header-menu-and-logo">
				<i class="fa-solid fa-bars fa-2xl" id="toggleSidebar"
					style="padding-right: 15px; cursor: pointer;"></i>
				<h1 id="header-logo" style="cursor: pointer;">Logo</h1>
			</div>
			<h2>로그인</h2>
		</div>
		<!-- 바디 부분 -->
		<div class="body">
			<!-- 사이드 메뉴 바  -->
			<div class="body-side-menubar">
				<div class="body-side-menubar-items">
					<i class="fa-solid fa-house fa-xl"></i>
				</div>
				<div class="body-side-menubar-items">
					<i class="fa-solid fa-calendar fa-xl"></i>
				</div>
				<div class="body-side-menubar-items">
					<i class="fa-solid fa-note-sticky fa-xl"></i>
				</div>
				<div class="body-side-menubar-items">
					<i class="fa-solid fa-arrow-right-arrow-left fa-xl"></i>
				</div>
			</div>
			<!-- 바디 페이지 -->
			<div class="body-container">
				<!-- 캘린더 요소 클릭시 뜨는 박스 -->

				<div class="body-left">
					<!-- 외부 이벤트 등록용 DIV -->
					<div id="external-events">
						<p>
							<strong>달력에 드래그하여 추가</strong>
						</p>
						<div class="fc-event cal-red-bg" data-title="기본일정1"
							data-color="red">일정1</div>
						<div class="fc-event cal-blue-bg" data-title="기본일정2"
							data-color="blue">일정2</div>
					</div>

					<!-- 일정 상세 보기 박스 -->
					<div id="event-details">
						<h3>일정 상세</h3>
						<p>
							<strong>제목:</strong> <span id="event-title"></span>
						</p>
						<p>
							<strong>설명:</strong> <span id="event-description"></span>
						</p>
					</div>
					
					<!-- 상세정보 보여줄 div 추가 -->
					<div id="task-detail-panel">
					  <h3 id="detail-title"></h3>
					  <p><strong>설명:</strong> <span id="detail-description"></span></p>
					  <p><strong>팀원:</strong> <span id="detail-member"></span></p>
					  <p><strong>시작일:</strong> <span id="detail-start"></span></p>
					  <p><strong>종료일:</strong> <span id="detail-end"></span></p>
					  <p><strong>진행률:</strong> <span id="detail-progress"></span>%</p>
					  <button id="open-modify-task" class="btn btn-warning">작업변경</button>
					  <button class="btn btn-danger">작업삭제</button>
					  <button onclick="closeTaskDetail()" class="btn btn-secondary">닫기</button>
					</div>
					
				</div>
				<div class="body-right">
					<!-- 캘린더 DIV -->
					<div id="calendar"></div>

					<div id="gantt" class="hidden-section">
						<div id="gantt-up-area">
							<div id="gantt-header-toolbar">
								<div class="btn-group" role="group" id="gantt-view-area"
									aria-label="Gantt View Mode">
									<input type="radio" class="btn-check" name="btnradio"
										id="gantt-view-month" autocomplete="off"> <label
										class="btn btn-outline-dark" for="gantt-view-month">월</label>
									<input type="radio" class="btn-check" name="btnradio"
										id="gantt-view-week" autocomplete="off" checked> <label
										class="btn btn-outline-dark" for="gantt-view-week">주</label> <input
										type="radio" class="btn-check" name="btnradio"
										id="gantt-view-day" autocomplete="off"> <label
										class="btn btn-outline-dark" for="gantt-view-day">일</label>
								</div>
								<button id="open-add-task" class="btn btn-primary">새 작업</button>
							</div>
						</div>
						<div id="gantt-target"></div>
					</div>
				</div>
				<!-- 기존 요소들 사이에 모달창 추가 -->
				<div id="eventModal">
					<h3>일정 추가</h3>
					<label>제목: <input type="text" id="modal-title" /></label><br>
					<br> <label>설명: <textarea id="modal-description" /></textarea></label> <br>
					<br>
					<button id="save-event">저장</button>
					<button id="cancel-event">취소</button>
				</div>
				
				<!-- 모달 간트 작업 추가 -->
				<!-- 작업 추가 모달 -->
				<div id="ganttTaskModal">
				  <h2>작업 추가</h2>
				
				  <label>작업명: <input type="text" id="task-name" /></label><br><br>
				  <label>설명: <textarea id="task-description" /></textarea></label><br><br>
				  <label for="form-select">멤버:</label>
				<select id="form-select" multiple aria-label="멤버 선택">
					<option selected>김동욱</option>
					<option>한승준</option>
					<option>이하은</option>
					<option>석준형</option>
					<option>박상진</option>
				</select><br><br>
				  <label>시작일: <input type="date" id="task-start" /></label><br><br>
				  <label>종료일: <input type="date" id="task-end" /></label><br><br>
				  
				  <button id="save-task" class="btn btn-primary">저장</button>
				  <button id="cancel-task" class="btn btn-secondary">취소</button>
				</div>
				
				<!-- 작업 상세 모달 -->
				<div id="ganttTaskModal">
				  <h2>작업 상세</h2>
				
				  <label>작업명: <input type="text" id="task-name" /></label><br><br>
				  <label for="state-select">멤버:</label>
				  <select id="state-select" multiple aria-label="상태 선택">
					<option selected>진행</option>
					<option>완료</option>
				  </select><br><br>
				  <label>설명: <textarea id="task-description" /></textarea></label><br><br>
				  <label>시작일: <input type="date" id="task-start" /></label><br><br>
				  <label>종료일: <input type="date" id="task-end" /></label><br><br>
				  <label for="form-select">멤버:</label>
				<select id="form-select" multiple aria-label="멤버 선택">
					<option selected>김동욱</option>
					<option>한승준</option>
					<option>이하은</option>
					<option>석준형</option>
					<option>박상진</option>
				</select><br><br>
				<div id="task-comment">
					<div id="task-comment-up">
						 <label>커멘트 날짜일시: <input type="text" id="task-comment-time" /></label><br><br>
						 <button class="btn btn-secondary">편집</button>
					 </div>
					 <label>커멘트 작성자: <input type="text" id="task-comment-writter" /></label><br><br>
					 <label>커멘트 제목: <input type="text" id="task-comment-title" /></label><br><br>
					 <label>커멘트 설명: <input type="text" id="task-comment-description" /></label><br><br>
					 <label>커멘트 파일: <input type="text" id="task-comment-title" /></label><br><br>
					 <button class="btn btn-primary">수정하기</button>
				</div>
				
				<div id="task-comment-add">
					 <label>커멘트 날짜일시: <input type="text" id="task-comment-time-add" /></label><br><br>
					 <label>커멘트 작성자: <input type="text" id="task-comment-writter" /></label><br><br>
					 <label>커멘트 제목: <input type="text" id="task-comment-title" /></label><br><br>
					 <label>커멘트 설명: <input type="text" id="task-comment-description" /></label><br><br>
					 <label>커멘트 파일: <input type="text" id="task-comment-title" /></label><br><br>
					 <button class="btn btn-primary">수정하기</button>
				</div>
				 
				  
				  <button id="save-task" class="btn btn-primary">저장</button>
				  <button id="cancel-task" class="btn btn-secondary">취소</button>
				</div>
				

				<!-- 모달 배경 -->
				<div id="modalBackdrop"
					style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;"></div>

				<!-- 간트 모달 -->
				<!-- 모달 배경 -->
				
				
				
				<!-- 배경 -->
				<div id="ganttTaskBackdrop"></div>
				
			</div>
		</div>
	</div>
	<script>
	let selectedTask = null; // 전역 변수로 선언
	let tasks = []; // 🔁 전역으로 먼저 선언
	let ganttInstance = null; // ← 추가
  document.addEventListener('DOMContentLoaded', function () {
    let draggedEventInfo = null;

    // 외부 이벤트 드래그 설정
    new FullCalendar.Draggable(document.getElementById('external-events'), {
      itemSelector: '.fc-event',
      eventData: function (eventEl) {
        const color = eventEl.dataset.color;
        return {
          title: eventEl.dataset.title,
          backgroundColor: color,
          borderColor: color,
          extendedProps: {
            typecolor: color,
            description: eventEl.dataset.description || ''
          }
        };
      }
    });

    // 캘린더 초기화
    const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,timeGridDay'
      },
      droppable: true,
      editable: true,
      events: [],
      eventReceive: function (info) {
        draggedEventInfo = info;
        document.getElementById('modal-title').value = '';
        document.getElementById('modal-description').value = '';
        document.getElementById('eventModal').style.display = 'block';
        document.getElementById('modalBackdrop').style.display = 'block';
      },
      eventClick: function (info) {
        const event = info.event;
        const title = event.title || '제목 없음';
        const description = event.extendedProps.description || '설명 없음';
        document.getElementById('event-title').textContent = title;
        document.getElementById('event-description').textContent = description;
        document.getElementById('event-details').style.display = 'block';
      }
    });

    // 일정 저장 버튼
    document.getElementById('save-event').addEventListener('click', function () {
      const title = document.getElementById('modal-title').value.trim();
      const desc = document.getElementById('modal-description').value.trim();

      if (!title) {
        alert('제목을 입력해주세요.');
        return;
      }

      if (draggedEventInfo) {
        draggedEventInfo.event.setProp('title', title);
        draggedEventInfo.event.setExtendedProp('description', desc);
        const color = draggedEventInfo.event.extendedProps.typecolor;
        if (color) {
          draggedEventInfo.event.setProp('backgroundColor', color);
          draggedEventInfo.event.setProp('borderColor', color);
        }
      }

      closeModal();
    });

    // 일정 취소 버튼
    document.getElementById('cancel-event').addEventListener('click', function () {
      if (draggedEventInfo) {
        draggedEventInfo.event.remove();
      }
      closeModal();
    });

    function closeModal() {
      document.getElementById('eventModal').style.display = 'none';
      document.getElementById('modalBackdrop').style.display = 'none';
      draggedEventInfo = null;
    }

    calendar.render();

    // 사이드바 토글
    document.getElementById('toggleSidebar').addEventListener('click', function () {
      const sidebar = document.querySelector('.body-side-menubar');
      sidebar.classList.toggle('hidden');
    });
    ///////월주일
    function setActiveGanttButton(mode) {
	  document.querySelectorAll('#gantt-view-area .fc-button')
	    .forEach(btn => btn.classList.remove('active'));
	  const activeBtn = document.getElementById(`gantt-view-${mode.toLowerCase()}`);
	  if (activeBtn) activeBtn.classList.add('active');
	}
    

    	document.getElementById("gantt-view-day").addEventListener("click", () => {
    	  ganttInstance.change_view_mode("Day");
    	  setActiveGanttButton("day");
    	});

    	document.getElementById("gantt-view-week").addEventListener("click", () => {
    	  ganttInstance.change_view_mode("Week");
    	  setActiveGanttButton("week");
    	});

    	document.getElementById("gantt-view-month").addEventListener("click", () => {
    	  ganttInstance.change_view_mode("Month");
    	  setActiveGanttButton("month");
    	});



    // 🟦 간트 차트 관련 코드
    	const dragevent = document.getElementById('external-events');
    const switchIcon = document.querySelector('.fa-arrow-right-arrow-left');
    const calendarEl = document.getElementById('calendar');
    const ganttWrapper = document.getElementById('gantt');  // 전체 gantt div (up + target 포함)
    let showingCalendar = true;

     tasks = [
      {
    	description: '설명',
        member: ['김동욱'],
        id: 'Task 1',
        name: '요구사항 정리',
        start: '2025-08-01',
        end: '2025-08-04',
        progress: 40,
        dependencies: ''
      },
      {
    	description: '설명',
        member: ['김동욱'],
        id: 'Task 2',
        name: '설계',
        start: '2025-08-05',
        end: '2025-08-10',
        progress: 20,
        dependencies: 'Task 1'
      }
    ];


    switchIcon.addEventListener('click', function () {
      if (showingCalendar) {
    	  dragevent.classList.add('hidden-view-section');
        calendarEl.classList.add('hidden-section');
        ganttWrapper.classList.remove('hidden-section');

        if (!ganttInstance) {
          ganttInstance = new Gantt("#gantt-target", tasks, {
            view_mode: 'Week',
            on_click: showGanttTaskDetail
          });

          document.getElementById("gantt-view-day").addEventListener("click", () => {
            ganttInstance.change_view_mode("Day");
          });
          document.getElementById("gantt-view-week").addEventListener("click", () => {
            ganttInstance.change_view_mode("Week");
          });
          document.getElementById("gantt-view-month").addEventListener("click", () => {
            ganttInstance.change_view_mode("Month");
          });
        }

      } else {
    	  dragevent.classList.remove('hidden-view-section');
        calendarEl.classList.remove('hidden-section');
        ganttWrapper.classList.add('hidden-section');
      }

      showingCalendar = !showingCalendar;

    });
  });
	
  //작업 변경 버튼 클릭 시 모달 열기
  document.getElementById("open-modify-task").addEventListener("click", function () {
	  if(!selectedTask)return;
    document.getElementById("ganttTaskModal").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
 // ✅ 초기화 추가
    document.getElementById("task-name").value = selectedTask.name;
    document.getElementById("task-description").value = selectedTask.description;
    document.getElementById("task-start").value = selectedTask.start;
    document.getElementById("task-end").value = selectedTask.end;
    // 멤버 선택 바인딩
    const mem = document.getElementById("form-select");
    for (const option of mem.options) {
      option.selected = selectedTask.member.includes(option.value);
    }
  });
  
  // 작업 추가 버튼 클릭 시 모달 열기
  document.getElementById("open-add-task").addEventListener("click", function () {
    document.getElementById("ganttTaskModal").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
 // ✅ 초기화 추가
    document.getElementById("task-name").value = "";
    document.getElementById("task-description").value = "";
    document.getElementById("task-start").value = "";
    document.getElementById("task-end").value = "";
    document.getElementById("form-select").selectedIndex = -1; // 선택 해제
  });

  // 저장 버튼 클릭 시 작업 저장
  document.getElementById("save-task").addEventListener("click", function () {
    const name = document.getElementById("task-name").value.trim();
    const start = document.getElementById("task-start").value;
    const end = document.getElementById("task-end").value;
    //const progress = parseInt(document.getElementById("task-progress").value) || 0;

    if (!name || !start || !end) {
      alert("모든 필드를 입력해주세요.");
      return;
    }
	
    const select = document.getElementById("form-select");
    const selected = Array.from(select.selectedOptions).map(option => option.value);
    
    const task_description = document.getElementById("task-description").value;

    const newTask = {
      description: task_description,
      member: selected,
      id: 'Task ' + (tasks.length+1),
      name: name,
      start: start,
      end: end,
      progress: 0,
      dependencies: ""
    };
    
    tasks.push(newTask);

    if (ganttInstance) {
    	ganttInstance.refresh(tasks); // 전체 태스크 새로고침
    }

    closeGanttModal();
  });

  // 취소 버튼 클릭 시 모달 닫기
  document.getElementById("cancel-task").addEventListener("click", function () {
    closeGanttModal();
  });

  function showGanttTaskDetail(task) {
	  selectedTask = task; // 선택된 작업 저장
	  document.getElementById("detail-title").textContent = task.name;
	  document.getElementById("detail-description").textContent = task.description;
	  document.getElementById("detail-member").textContent = task.member?.join(', ') || '';
	  document.getElementById("detail-start").textContent = task.start;
	  document.getElementById("detail-end").textContent = task.end;
	  document.getElementById("detail-progress").textContent = task.progress;
	  document.getElementById("task-detail-panel").style.display = "block";
	}
  function closeTaskDetail(){
	  document.getElementById("task-detail-panel").style.display = "none";
  }

  // 모달 닫는 함수
  function closeGanttModal() {
    document.getElementById("ganttTaskModal").style.display = "none";
    document.getElementById("ganttTaskBackdrop").style.display = "none";
    document.getElementById("task-name").value = "";
    document.getElementById("task-start").value = "";
    document.getElementById("task-end").value = "";
  }
</script>


</body>
</html>