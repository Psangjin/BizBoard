<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Calendar Page</title>
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

.body-container {
	width: 90vw;
	height: 100%;
	flex: 1;
	display: flex;
	padding: 5px;
}

.body-left {
  height: 100%;
  flex:1;
  position: relative;
  min-width: 220px;
}

#external-events {
	position: relative;
	top:10px;
	width: 90%;
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


.fc-day-today {
	background-color: #ffecb3 !important;
	border: 2px solid #ffa000;
	font-weight: bold;
}

#calendar {
	flex:4;
}

#event-details {
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translate(-50%, 0%);
  width: 200px;
  height: 300px;         /* ✅ 일정한 높이로 고정 */
  overflow-x: hidden;
  overflow-y: scroll;      /* 내용 넘칠 경우 숨김 */
  
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

#eventModal input[type="text"]:focus,
#eventModal textarea:focus {
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

.color-circle {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  cursor: pointer;
  border: 2px solid transparent;
  transition: transform 0.2s, border 0.2s;
  display: inline-block;
}

.color-circle:hover {
  transform: scale(1.2);
}

.color-circle.selected {
  border: 2px solid #333;
}


</style>
</head>
<body>
	
	 <%@ include file="../include/layout.jsp" %>	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->
	
			<!-- 바디 페이지 -->
			<div class="body-container">
				<!-- 캘린더 요소 클릭시 뜨는 박스 -->
				
				<div class="body-left">
					<!-- 외부 이벤트 등록용 DIV -->
					<div id="external-events">
						<p>
							<strong>달력에 드래그하여 추가</strong>
						</p>
						<div class="fc-event" data-title="기본일정1"
							data-color="#888888" style="background-color: #888888;">일정 추가</div>
						
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
				</div>
				<!-- 캘린더 DIV -->
				<div id="calendar"></div>

				<!-- 기존 요소들 사이에 모달창 추가 -->
				<div id="eventModal">
					<h3>일정 추가</h3>
					<label>제목: <input type="text" id="modal-title" /></label><br>
					<br> <label>설명: <textarea id="modal-description"></textarea></label>
					<div style="margin-top: 10px;">
					  <label><strong>색상 선택:</strong></label>
					  <div id="color-options" style="margin-top: 5px; display: flex; gap: 10px;">
					    <div class="color-circle" data-color="#007bff" style="background-color: #007bff;"></div>
					    <div class="color-circle" data-color="#28a745" style="background-color: #28a745;"></div>
					    <div class="color-circle" data-color="#ffc107" style="background-color: #ffc107;"></div>
					    <div class="color-circle" data-color="#dc3545" style="background-color: #dc3545;"></div>
					    <div class="color-circle" data-color="#6f42c1" style="background-color: #6f42c1;"></div>
					  </div>
					  <input type="hidden" id="modal-color" value="#007bff" />
					</div>
					<br> <br>
					<button id="save-event">저장</button>
					<button id="cancel-event">취소</button>
				</div>

				<!-- 모달 배경 -->
				<div id="modalBackdrop"
					style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;"></div>
			</div>
		</div>
	</div>
</div>
	<script>
  document.addEventListener('DOMContentLoaded', function() {
    let draggedEventInfo = null;
	//캘린더에 일정 드래그시 가져올 정보
    new FullCalendar.Draggable(document.getElementById('external-events'), {
      itemSelector: '.fc-event',
      eventData: function(eventEl) {
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

    const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,timeGridDay'
      },
      droppable: true,
      editable: true, // 편집 가능 여부
      events: [], //초기 설정 일정
	  //캘린더에 일정 드래그앤 드롭시
      eventReceive: function(info) {
        draggedEventInfo = info;
        document.getElementById('modal-title').value = '';
        document.getElementById('modal-description').value = '';
        document.getElementById('modal-color').value = '#007bff';

        document.querySelectorAll('.color-circle').forEach(c => c.classList.remove('selected'));
        document.querySelector('.color-circle[data-color="#007bff"]').classList.add('selected');

        document.getElementById('eventModal').style.display = 'block';
        document.getElementById('modalBackdrop').style.display = 'block';
      },
	  //캘린더의 일정 클릭시
      eventClick: function(info) {
        const event = info.event;
        const title = event.title || '제목 없음';
        const description = event.extendedProps.description || '설명 없음';
        document.getElementById('event-title').textContent = title;
        document.getElementById('event-description').textContent = description;
        document.getElementById('event-details').style.display = 'block';
      }
    });

    //일정 추가 완료
    document.getElementById('save-event').addEventListener('click', function() {
      const title = document.getElementById('modal-title').value.trim();
      const desc = document.getElementById('modal-description').value.trim();
      const color = document.getElementById('modal-color').value;

      if (!title) {
        alert('제목을 입력해주세요.');
        return;
      }

      if (draggedEventInfo) {
        draggedEventInfo.event.setProp('title', title);
        draggedEventInfo.event.setExtendedProp('description', desc);
        if (color) {
          draggedEventInfo.event.setProp('backgroundColor', color);
          draggedEventInfo.event.setProp('borderColor', color);
          draggedEventInfo.event.setExtendedProp('typecolor', color);
        }
      }

      closeModal();
    });

    //일정 생성 취소
    document.getElementById('cancel-event').addEventListener('click', function() {
      if (draggedEventInfo) {
        draggedEventInfo.event.remove();
      }
      closeModal();
    });

    //모든 모달 닫기
    function closeModal() {
      document.getElementById('eventModal').style.display = 'none';
      document.getElementById('modalBackdrop').style.display = 'none';
      draggedEventInfo = null;
    }

    calendar.render();
	
    //레이아웃 사이드바 기능
    document.getElementById('toggleSidebar').addEventListener('click', function () {
      const sidebar = document.querySelector('.body-side-menubar');
      sidebar.classList.toggle('hidden');
    });

    document.getElementById('fa-project-icon').addEventListener('click', function() {
      location.href = "/project/main";
    });

    document.getElementById('fa-calendar-icon').addEventListener('click', function() {
      location.href = "/project/schedule";
    });

    //일정 추가시 색상 저장
    document.querySelectorAll('.color-circle').forEach(circle => {
      circle.addEventListener('click', function () {
        document.querySelectorAll('.color-circle').forEach(c => c.classList.remove('selected'));
        this.classList.add('selected');
        document.getElementById('modal-color').value = this.dataset.color;
      });
    });
  });
</script>
</body>
</html>
