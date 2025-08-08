<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BizBoard</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/css/projectMain.css">
</head>

<body>
	<%@ include file="../include/layout.jsp"%>

	<div class="body-container">

		<!-- 상단: 프로젝트 정보 + 진행도 -->
		<div class="project-main-top">
			<div class="project-info-container">
				<span class="project-dday">마감일까지 : D-${daysLeft}</span>
				<h1>${project.title}</h1>
				<h3>PM : ${project.manager}</h3>
				<h3>${project.content}</h3>

			</div>

			<div class="progress-container">
				<div class="progress-display">
					<svg width="160" height="160">
			<!-- 배경 원 -->
			<circle class="bg" r="60" cx="80" cy="80" />
			<!-- 진행 원 -->
			<circle class="progress" id="progress-circle" r="60" cx="80" cy="80"
							stroke-dasharray="377" stroke-dashoffset="377" />
			<!-- 중앙 텍스트 -->
			<text id="percentText" class="center-text" x="80" y="80">0%</text>
			</svg>
				</div>
				<div>
					<h1>4 / 21</h1>
					<h3>총 21가지 작업 중</h3>
					<h4>4가지 작업 완료</h4>
					<div class="buttons">
						<button onclick="changeProgress(-10)">-10%</button>
						<button onclick="changeProgress(10)">+10%</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 중간: 오늘 할 일 + 내가 할 일 -->
		<div class="project-main-mid">
			<div class="project-task-today project-main-innerbox">
				<h3>프로젝트에서 오늘 할 일 목록들</h3>
				<div class="project-main-innerbox-scroll">
				<ul>
			        <c:choose>
			            <c:when test="${not empty todaySchedules}">
			                <c:forEach var="s" items="${todaySchedules}">
			                    <li>${s.title}</li>
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                <li>오늘 할 일이 없습니다.</li>
			            </c:otherwise>
			        </c:choose>
			    </ul>
			    </div>
			</div>
			<div class="project-task-individual project-main-innerbox">
				<h3>프로젝트에서 내가 할 일 목록들</h3>
			</div>
		</div>

		<!-- 하단: 공지사항 + 팀원 목록 -->
		<div class="project-main-bot">
			<div class="project-main-notice project-main-innerbox">
				<h3>공지사항</h3>
			</div>
			<div class="project-main-member project-main-innerbox">
				<h3>팀원 목록</h3>
			</div>
		</div>

	</div>

	<script src="/js/projectMain.js"></script>

</body>
</html>