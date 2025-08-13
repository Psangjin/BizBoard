<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Calendar Page</title>
<!-- 간트 시작 -->
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
<!-- 간트 끝 -->
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.18/index.global.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
	
<link rel="stylesheet" href="/css/schedule.css">

</head>
<body>
	 <%@ include file="../include/layout.jsp" %>	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->
	
		<input type="hidden" id="project-id" value="${projectId}" />
		<input type="hidden" id="login-user" value="${loginUser}" />
		
	
			<!-- 바디 페이지 -->
			<div class="body-container">
				<!-- 캘린더 요소 클릭시 뜨는 박스 -->

				<div class="body-left">
					<!-- 외부 이벤트 등록용 DIV -->
					<button id="toggle-edit-mode" class="btn btn-outline-danger mb-2">편집 모드 켜기</button>
					
					<div id="fc-external-events">
						<p>
							<strong>달력에 드래그하여 추가</strong>
						</p>
						<div class="fc-event" data-title="기본일정1" data-color="#888888"
							style="background-color: #888888;">일정 추가</div>
						

					</div>
					<div id= "fc-trash-area">
						<strong>이곳에 드래그하여 삭제</strong>
						<div id="fc-event-trash">🗑️ 삭제</div>
					</div>
					
					<div id="task-edit-panel" class="hidden-section" >
					  <h3 id="task-edit-title"></h3>
					  <button id="open-modify-task" class="btn btn-warning">작업변경</button>
					  <button class="btn btn-danger">작업삭제</button>
					  <button id="close-task-edit-panel-btn" class="btn btn-secondary">닫기</button>
					</div>

					<!-- 일정 상세 보기 박스 -->
					<div id="fc-event-details">
						<div class="fc-details-header">
						  <h3>일정 상세</h3>
						  <button id="fc-details-close" class="fc-close-btn" aria-label="닫기">×</button>
						</div>
						  <div class="fc-details-content">
						    <p><strong>제목:</strong> <span id="fc-event-title"></span></p>
						    <p><strong>설명:</strong><br> <span id="fc-event-description"></span></p>
						  </div>
					</div>
					
					<!-- 상세정보 보여줄 div 추가 -->
					<div id="task-detail-panel" class="hidden-section">
					  <h3 id="detail-title"></h3>
					  <p><strong>설명:</strong> <span id="detail-description"></span></p>
					  <p><strong>팀원:</strong> <span id="detail-member"></span></p>
					  <p><strong>시작일:</strong> <span id="detail-start"></span></p>
					  <p><strong>종료일:</strong> <span id="detail-end"></span></p>
					  <p><strong>진행률:</strong> <span id="detail-progress"></span>%</p>
					  <button id="open-ganttDetail" class="btn btn-primary">작업보기</button>
					  <button id="close-task-detail-panel-btn" class="btn btn-secondary">닫기</button>
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
				<div id="fc-eventModal">
					<h3>일정 추가</h3>
					<input type="hidden" id="fc-modal-id" /> <!-- id전달 위한 hidden -->
					<div id="fc-eventModal-inputDate">
						<!-- 시작 일시 -->
						<div class="fc-eventModal-inputDate-area">
							<label>시작 일시</label> <input type="datetime-local" id="fc-event-start"
								class="fc-custom-datetime"><br>
						</div>
						<!-- 종료 일시 -->
						<div class="fc-eventModal-inputDate-area">
							<label>종료 일시</label> <input type="datetime-local" id="fc-event-end"
								class="fc-custom-datetime"><br>
						</div>
					</div>
					<label> <input type="checkbox" id="fc-event-allday" name="type"
						value="PW"> 프로젝트 작업 일정
					</label><br> <label>제목: <input type="text" id="fc-modal-title" /></label><br>

					<br> <label>설명: <textarea id="fc-modal-description"></textarea></label>
					<div style="margin-top: 10px; display:flex; gap:60px;">

						<label><strong>색상 선택:</strong></label>
						<div id="fc-color-options"
							style="margin: 5px; display: flex; gap: 10px;">
							<div class="fc-color-circle" data-color="#007bff"
								style="background-color: #007bff;"></div>
							<div class="fc-color-circle" data-color="#28a745"
								style="background-color: #28a745;"></div>
							<div class="fc-color-circle" data-color="#ffc107"
								style="background-color: #ffc107;"></div>
							<div class="fc-color-circle" data-color="#dc3545"
								style="background-color: #dc3545;"></div>
							<div class="fc-color-circle" data-color="#6f42c1"
								style="background-color: #6f42c1;"></div>
						</div>
						<input type="hidden" id="fc-modal-color" value="#007bff" />
						
						<select
						id="state-select-modify-cal">
							<option value="null">진행</option>
							<option value="Done">완료</option>
				  	</select>
					</div>
					<br> <br>
					<button id="fc-save-event">저장</button>
					<button id="fc-cancel-event">취소</button>
				</div>
				
				<!-- 모달 간트 작업 추가 -->
				<!-- 작업 추가 모달 -->
				<div id="ganttTaskModal">
				  <h2>작업 추가</h2>
				
				  <label>작업명: <input type="text" id="task-name" /></label><br><br>
				  <label>설명: <textarea id="task-description" /></textarea></label><br><br>
				  <label for="form-select">멤버:</label>
				<select id="form-select" multiple aria-label="멤버 선택">
				  <c:forEach var="member" items="${projectMemberList}">
				    <!-- value는 userId, selected는 서버에서 주지 않음 -->
				    <option value="${member.userId}">${member.name}</option>
				  </c:forEach>
				</select>
				<br><br><input type="hidden" id="task-isCompleted">
				  <label>시작일: <input type="date" id="task-start" /></label><br><br>
				  <label>종료일: <input type="date" id="task-end" /></label><br><br>
				  
				  <button id="save-task" class="btn btn-primary">저장</button>
				  <button id="cancel-task" class="btn btn-secondary">취소</button>
				</div>
				
				<!-- 작업 변경 모달 -->
				<div id="ganttTaskModalModify">
				  <h2>작업 변경</h2>
				
				  <label>작업명: <input type="text" id="task-name-modify" /></label><br><br>
				  <label>설명: <textarea id="task-description-modify" /></textarea></label><br><br>
				  <label for="state-select-modify">상태:</label>
				  <select
						id="state-select-modify">
						<option value="null">진행</option>
						<option value="Done">완료</option>
				  </select><br><br> 
				  <input type="hidden" id="task-color">
				  <label for="form-select-modify">멤버:</label>
				 <select id="form-select-modify" multiple>
				  <c:forEach var="member" items="${projectMemberList}">
				    <!-- value는 userId, text는 name -->
				    <option value="${member.userId}">${member.name}</option>
				  </c:forEach>
				 </select>

			<label>시작일: <input type="date" id="task-start-modify" /></label><br><br>
				  <label>종료일: <input type="date" id="task-end-modify" /></label><br><br>
				  
				  <button id="save-task-modify" class="btn btn-primary">저장</button>
				  <button id="cancel-task-modify" class="btn btn-secondary">취소</button>
				</div>
				
				<!-- 커멘트 추가 -->
				<div id="task-comment-add-modal">
					<h2>커멘트 등록</h2>
					<label>커멘트 날짜일시: <input type="datetime-local"
						id="task-comment-time-add" /></label><br> <br> <label>커멘트
						작성자: <input type="text" id="task-comment-writter-add"  value="${sessionScope.loginUser.id}" readonly />
					</label><br> <br> <label>커멘트 제목: <input type="text"
						id="task-comment-title-add" /></label><br> <br> <label>커멘트
						설명: <input type="text" id="task-comment-description-add" />
					</label><br> <br> <label>커멘트 파일: <input type="file"
						id="task-comment-file-add" /></label><br> <br>
					<div id="comment-add-btn-area">
						<button id="task-comment-add-btn"class="btn btn-primary">등록하기</button>
						<button id="task-comment-add-cancel-btn"class="btn btn-secondary">취소하기</button>
					</div>
				</div>
				
				<!-- 작업 상세 모달 -->
		<div id="ganttDetail">
			<h2>작업 상세</h2>
			<div id="ganttDetailContainer">
				<div id="ganttDetailLeft">
					<label>작업명: <input type="text" id="task-name-detail" /></label><br>
					<label>설명: <textarea
							id="task-description-detail" /></textarea></label><br>
					<label>상태</label>
					<p id="task-user-check"></p>
					<label>시작일:
						<input type="date" id="task-start-detail" />
					</label><br>
					<label>종료일: <input type="date"
						id="task-end-detail" /></label><br>
						<label for="form-select-detail">멤버:</label>
						<select id="form-select-detail" class="form-select" multiple size="8">
						  <c:forEach var="m" items="${projectMemberList}">
						    <option value="${m.userId}" data-name="${m.name}">${m.name}</option>
						  </c:forEach>
						</select>
				</div>
				<div id="ganttDetailRight">
					<select id="comment-orderby">
						<option selected>최신순</option>
						<option>등록순</option>
					</select><br>
					<div id="task-comment">
					</div>
					<div id="open-add-comment-btn-area">
						<button id="open-add-comment-btn" class="btn btn-primary">등록하러가기</button>
					</div>
				</div>
			</div>
			<div id="ganttDetailCloseArea">
				<button id="cancel-detail-btn" class="btn btn-secondary">닫기</button>
			</div>
		</div>


		<!-- 모달 배경 -->
				<div id="fc-modalBackdrop"
					style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;"></div>
				<!-- 간트 모달 -->
				<!-- 배경 -->
				<div id="ganttTaskBackdrop"></div>
				

</div>
</div>
</div>
<script>
/*  window.projectId =
	  document.getElementById('project-id')?.value
	  || (location.pathname.match(/\/project\/(?:schedule|main)\/(\d+)/)?.[1] ?? ''); */
	//console.log('projectId:', projectId);

//console.log('project-id 엘리먼트:', document.getElementById('project-id'));
//console.log('projectId 값:', projectId);


	const commentList = [
	    <c:forEach var="comment" items="${commentList}" varStatus="status">
	      {
	        time: "${comment.time}",
	        writter: "${comment.writter}",
	        title: "${comment.title}",
	        description: "${comment.description}",
	        file: "${comment.file}"
	      }<c:if test="${!status.last}">,</c:if>
	    </c:forEach>
	];
	const isAdmin = ${isAdmin};
	if (!isAdmin) {
		  document.getElementById("open-add-task").classList.add("invisible"); 
		  document.getElementById("toggle-edit-mode").classList.add("invisible");
		}
	</script>
<script src="/js/schedule.js"></script>
</body>
</html>
