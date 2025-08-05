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

<link rel="stylesheet" href="/css/schedule.css">
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

<script src="/js/schedule.js"></script>
</body>
</html>
