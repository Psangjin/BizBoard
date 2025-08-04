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
	transition: color 0.3s ease, background-color 0.3s ease, transform 0.3s
		ease;
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
	flex: 1;
	position: relative;
	min-width: 220px;
}

#external-events {
	position: relative;
	top: 10px;
	width: 90%;
	border: 1px solid #ccc;
	padding: 10px;
	margin: 10px auto;
	border-radius: 10px;
	background-color: #f0f0f0;
}

#event-trash {
	width: 100px;
	height: 100px;
	border: 2px dashed red;
	text-align: center;
	line-height: 100px;
	transition: all 0.3s ease;
}

#event-trash.hovered {
	background-color: rgba(255, 0, 0, 0.1);
	border-color: darkred;
	transform: scale(1.1);
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
	flex: 4;
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

#eventModal-inputDate {
	display: flex;
}

.eventModal-inputDate-area {
	flex: 1;
}

#eventModal-inputDate .custom-datetime {
	padding: 10px 14px;
	height: 40px;
	margin: 2px 0;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 14px;
	font-family: 'Segoe UI', sans-serif;
	color: #333;
	background-color: #f9f9f9;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

#eventModal-inputDate .custom-datetime:focus {
	outline: none;
	border-color: #4a90e2;
	box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
	background-color: #fff;
}

#eventModal-inputDate .custom-datetime::-webkit-calendar-picker-indicator
	{
	filter: invert(0.4);
	cursor: pointer;
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

	<%@ include file="../include/layout.jsp"%>
	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->

	<!-- 바디 페이지 -->
	<div class="body-container">
		<!-- 캘린더 요소 클릭시 뜨는 박스 -->

		<div class="body-left">
			<!-- 외부 이벤트 등록용 DIV -->
			<div id="external-events">
				<p>
					<strong>달력에 드래그하여 추가</strong>
				</p>
				<div class="fc-event" data-title="기본일정1" data-color="#888888"
					style="background-color: #888888;">일정 추가</div>

			</div>
			<div id="event-trash">🗑️ 삭제</div>

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
			<div id="eventModal-inputDate">
				<!-- 시작 일시 -->
				<div class="eventModal-inputDate-area">
					<label>시작 일시</label> <input type="datetime-local" id="event-start"
						class="custom-datetime"><br>
				</div>
				<!-- 종료 일시 -->
				<div class="eventModal-inputDate-area">
					<label>종료 일시</label> <input type="datetime-local" id="event-end"
						class="custom-datetime"><br>
				</div>
			</div>
			<label> <input type="checkbox" id="event-allday" name="type"
				value="PW"> 프로젝트 작업 일정
			</label><br> <label>제목: <input type="text" id="modal-title" /></label><br>

			<br> <label>설명: <textarea id="modal-description"></textarea></label>
			<div style="margin-top: 10px;">

				<label><strong>색상 선택:</strong></label>
				<div id="color-options"
					style="margin-top: 5px; display: flex; gap: 10px;">
					<div class="color-circle" data-color="#007bff"
						style="background-color: #007bff;"></div>
					<div class="color-circle" data-color="#28a745"
						style="background-color: #28a745;"></div>
					<div class="color-circle" data-color="#ffc107"
						style="background-color: #ffc107;"></div>
					<div class="color-circle" data-color="#dc3545"
						style="background-color: #dc3545;"></div>
					<div class="color-circle" data-color="#6f42c1"
						style="background-color: #6f42c1;"></div>
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

<script
		src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
		integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
		crossorigin="anonymous" referrerpolicy="no-referrer"></script>

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
	
	//시작 날짜 자동 설정 함수
    function setInputDate(datetimeStr) {
   	  const input = document.getElementById('event-start');

   	  // datetime-local 형식은 "YYYY-MM-DDTHH:MM" 이어야 함
   	  const date = new Date(datetimeStr);
   	  const year = date.getFullYear();
   	  const month = String(date.getMonth() + 1).padStart(2, '0'); // 0~11
   	  const day = String(date.getDate()).padStart(2, '0');
   	  const hour = String(date.getHours()).padStart(2, '0');
   	  const minute = String(date.getMinutes()).padStart(2, '0');

   	  let formatted = year+'-'+month+'-'+day+'T'+hour+':'+minute;
   	  input.value = formatted;
   	}

    function handleTrashHover(e) {
   	  const trashEl = document.getElementById("event-trash");
   	  const trashRect = trashEl.getBoundingClientRect();
   	  const x = e.clientX;
   	  const y = e.clientY;

   	  const inTrash =
   	    x >= trashRect.left &&
   	    x <= trashRect.right &&
   	    y >= trashRect.top &&
   	    y <= trashRect.bottom;

   	  if (inTrash) {
   	    trashEl.classList.add("hovered");
   	  } else {
   	    trashEl.classList.remove("hovered");
   	  }
   	}
    
    //스케쥴 수정 함수
    function updateScheduleEvent(info) {
   	  const event = info.event;

		  const updatedData = {
		    id: event.id,
		    title: event.title,
		    content: event.extendedProps.description,
		    type: event.extendedProps.type,
		    startDt: event.start,
		    endDt: event.end,
		    color: event.backgroundColor,
		    allDay: event.allDay
		  };

		  $.ajax({
		    url: '/project/schedule/updateDate',
		    type: 'POST',
		    contentType: 'application/json',
		    data: JSON.stringify(updatedData),
		    success: function () {
		      console.log('일정 이동 후 업데이트 성공');
		    },
		    error: function () {
		      alert('일정 날짜 업데이트 실패');
		      info.revert();
		    }
		  });
   	}
    
    const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,timeGridDay'
      },
      droppable: true,
      editable: true, // 편집 가능 여부
      events: '/project/schedule/events', //초기 설정 일정
      eventDisplay: 'block',
      
	  //캘린더에 일정 드래그앤 드롭시
      eventReceive: function(info) {
        draggedEventInfo = info;
        // 드롭한 날짜 시작날짜로 설정
        const droppedDate = info.event.startStr;
        setInputDate(droppedDate);
        
        //새로운 데이터 입력을 위한 다른 데이터 초기화
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
        console.log(event);
        document.getElementById('event-title').textContent = title;
        document.getElementById('event-description').textContent = description;
        document.getElementById('event-details').style.display = 'block';
      },
      eventDragStart: function(info) {
    	  document.addEventListener("mousemove", handleTrashHover);
      },
      eventDragStop: function(info) {
   	    document.removeEventListener("mousemove", handleTrashHover);
   	    const trashEl = document.getElementById("event-trash");
   	    const trashRect = trashEl.getBoundingClientRect();
   	    const x = info.jsEvent.clientX;
   	    const y = info.jsEvent.clientY;

   	    const inTrash =
   	      x >= trashRect.left &&
   	      x <= trashRect.right &&
   	      y >= trashRect.top &&
   	      y <= trashRect.bottom;
   	      
   	      trashEl.classList.remove("hovered");

   	    if (inTrash) {
   	      if (confirm("일정을 삭제하시겠습니까?")) {
   	        const eventId = info.event.id;
			console.log(eventId);
   	        // 캘린더에서 삭제
   	        info.event.remove();

   	        // 서버에도 삭제 요청 (AJAX 예시)
   	        $.ajax({
   	            url: '/project/schedule/delete',
   	            type: 'POST',
   	            contentType: 'application/json',
   	            data: JSON.stringify({ id: eventId }),
   	            success: function(response) {
   	              console.log("삭제 성공", response);
   	            },
   	            error: function(xhr, status, error) {
   	              console.error("삭제 실패", error);
   	            }
   	          });
	   	    }
	   	  }
	   	},
    	
    	eventDrop: function(info) {
   		  updateScheduleEvent(info);
   		},
   		
   		eventResize: function(info) {
		  updateScheduleEvent(info);
   		}
   		

  	  });
    

    //일정 추가 완료
    document.getElementById('save-event').addEventListener('click', function() {
   	  const title = document.getElementById('modal-title').value.trim();
   	  const desc = document.getElementById('modal-description').value.trim();
   	  const color = document.getElementById('modal-color').value;
   	  const start = document.getElementById('event-start').value;
   	  const end = document.getElementById('event-end').value;
   	  const alldayCheckbox = document.getElementById('event-allday');
   	  
      if (!title) {
        alert('제목을 입력해주세요.');
        return;
      }
      const allDay = alldayCheckbox.checked;

      let startDt = '';
      let endDt = null;

      if (allDay) {
        startDt = start.split('T')[0]; // datetime-local => 날짜만
        endDt = end ? end.split('T')[0] : null;
      } else {
        startDt = start;
        endDt = end;
      }
     
      const type = alldayCheckbox.checked ? alldayCheckbox.value : '';

      const scheduleData = {
        title: title,
        content: desc,
        type: type,
        startDt: startDt,
        endDt: endDt,
        color: color,
        allDay: allDay
      };
      
      $.ajax({
    	    url: '/project/schedule/save',
    	    type: 'POST',
    	    contentType: 'application/json',
    	    data: JSON.stringify(scheduleData),
    	    success: function () {
    	      alert('저장 완료');
    	      location.reload();
    	    },
    	    error: function () {
    	      alert('저장 실패');
    	    }
    	  });

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
  
	//아래 코드는 +메뉴 호버 효과 나중에 모듈로 빼기
	const fabMain = document.querySelector('.fab-main');
	  const fabMenu = document.querySelector('.fab-menu');

	  fabMain.addEventListener('mouseenter', () => {
	    fabMenu.style.opacity = '1';
	    fabMenu.style.pointerEvents = 'auto';
	    fabMenu.style.transform = 'translateY(0)';
	  });

	  fabMain.addEventListener('mouseleave', () => {
	    setTimeout(() => {
	      if (!fabMenu.matches(':hover')) {
	        fabMenu.style.opacity = '0';
	        fabMenu.style.pointerEvents = 'none';
	        fabMenu.style.transform = 'translateY(10px)';
	      }
	    }, 200);
	  });

	  fabMenu.addEventListener('mouseleave', () => {
	    fabMenu.style.opacity = '0';
	    fabMenu.style.pointerEvents = 'none';
	    fabMenu.style.transform = 'translateY(10px)';
	  });
</script>
</body>
</html>
