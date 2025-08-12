<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BizBoard</title>

<!-- ✅ Bootstrap 5.3 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!-- ✅ Bootstrap 5.3 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/css/projectMain.css">
</head>

<body>

<input type="hidden" id="projectMain-project-id" value="${projectId}">
<input type="hidden" id="projectMain-projectMemberList" value="${projectMemberList}">
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
						<circle class="bg" r="60" cx="80" cy="80" />
						<circle class="progress" id="progress-circle" r="60" cx="80" cy="80"
							stroke-dasharray="377" stroke-dashoffset="377" />
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
  	<!-- 공지사항 -->
	<div class="project-main-notice project-main-innerbox" id="noticeBox">
	  <div class="d-flex justify-content-between align-items-center">
	    <h3 class="mb-0">공지사항</h3>
	    <div class="d-flex gap-2">
	      <button type="button" class="btn btn-sm btn-outline-secondary" id="btnNoticeEditToggle">편집</button>
	      <button type="button" class="btn btn-sm btn-primary" id="btnNoticeAdd">
	        <i class="fa fa-plus"></i>
	      </button>
	    </div>
	  </div>
	
	  <div class="project-main-innerbox-scroll mt-2">
	    <table class="table table-sm align-middle mb-0">
	      <thead class="table-light">
	        <tr>
	          <th style="width:20%;">제목</th>
	          <th style="width:66%;">내용</th>
	          <th class="th-actions" style="width:14%;">조치</th> <!-- 편집 토글 시에만 보임 -->
	        </tr>
	      </thead>
	      <tbody id="noticeListBody">
	        <tr><td colspan="3" class="text-center text-muted">불러오는 중…</td></tr>
	      </tbody>
	    </table>
	  </div>
	</div>


  <!-- 팀원 목록 (기존 그대로) -->
  <div class="project-main-member project-main-innerbox">
    <h3>팀원 목록</h3>
    <c:forEach var="m" items="${projectMemberList}">
      <p>${m.name}</p>
    </c:forEach>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#memberManageModal">팀원초대</button>
  </div>
</div>
<!-- 공지 상세 모달 (읽기 전용) -->
<div class="modal fade" id="noticeViewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">공지 상세</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <h4 id="view-title" class="mb-2"></h4>
        <div class="text-muted small mb-3">
          <span>작성자: <span id="view-user"></span></span>
          <span class="mx-2">•</span>
          <span>작성일: <span id="view-time"></span></span>
        </div>
        <div id="view-desc" style="white-space: pre-wrap;"></div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" id="view-edit">편집</button>
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- 공지 모달 (등록/수정 겸용) -->
<div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="noticeModalTitle">공지 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <input type="hidden" id="notice-id">
        <div class="mb-3">
          <label class="form-label">제목</label>
          <input type="text" id="notice-title" class="form-control" maxlength="200" placeholder="제목을 입력하세요">
        </div>
        <div class="mb-3">
          <label class="form-label">내용</label>
          <textarea id="notice-desc" class="form-control" rows="8" placeholder="내용을 입력하세요"></textarea>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="btnNoticeSave">저장</button>
      </div>
    </div>
  </div>
</div>

</div>
</div>
</div>
</div>
<!-- 팀원 관리 모달 -->
<div class="modal fade" id="memberManageModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">프로젝트 참가자 관리</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>

			<div class="modal-body">
				<!-- 초대 폼 -->
				<form id="inviteForm" class="row g-3 mb-3">
					<div class="col-md-7">
						<label class="form-label">이메일</label>
						<input type="text" name="email" class="form-control" placeholder="예: hansj@company.com">
					</div>
					<div class="col-md-3">
						<label class="form-label">권한</label>
						<select name="role" class="form-select">
							<option value="ADMIN">관리자</option>
							<option value="MEMBER" selected>일반</option>
						</select>
					</div>
					<div class="col-md-2 d-flex align-items-end">
						<button type="button" class="btn btn-primary w-100" id="btnInvite">초대</button>
					</div>
				</form>

				<!-- 참가자 목록 -->
				<table class="table table-bordered align-middle mb-0">
					<thead class="table-light">
						<tr>
							<th>이름</th>
							<th>이메일</th>
							<th>권한</th>
							<th>참가일</th>
							<th style="width:110px;">조치</th>
						</tr>
					</thead>
					<tbody id="memberListBody">
						<c:forEach var="m" items="${projectMemberList}">
							<tr>
								<td>${m.name}</td>
								<td>${m.email}</td>
								<td>
									<select class="form-select form-select-sm"
									        onchange="changeRole('${m.email}', this.value)">
										<option value="ADMIN" ${m.role=='ADMIN'?'selected':''}>관리자</option>
										<option value="MEMBER" ${m.role=='MEMBER'?'selected':''}>일반</option>
									</select>
								</td>
								<td>${m.joinedAt}</td>
								<td>
									<button class="btn btn-sm btn-outline-danger"
									        onclick="removeMember('${m.email}')"
									        <c:if test="${m.role=='OWNER'}">disabled</c:if>>
										강퇴
									</button>
								</td>
							</tr>
						</c:forEach>
						<c:if test="${empty projectMemberList}">
							<tr><td colspan="5" class="text-center text-muted">참가자가 없습니다.</td></tr>
						</c:if>
					</tbody>
				</table>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<script src="/js/projectMain.js"></script>
<script>
	// 서버에서 내려주는 값 사용
	const projectId = '${projectId}';

	// 초대
	document.getElementById('btnInvite').addEventListener('click', function(){
		const fd = new FormData(document.getElementById('inviteForm'));
		const data = Object.fromEntries(fd);
		if(!data.email){ alert('이메일을 입력하세요.'); return; }

		fetch('/project/member/invite', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ projectId, email: data.email, role: data.role })
		}).then(r => {
			if(!r.ok) throw new Error('초대 실패');
			location.reload();
		}).catch(e => alert(e.message));
	});

	// 권한 변경
	function changeRole(email, role){
		if(!confirm(`${email}님의 권한을 ${role}로 변경하시겠습니까?`)) return;
		fetch('/project/member/role', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ projectId, email, role })
		}).then(r => {
			if(!r.ok) throw new Error('권한 변경 실패');
		}).catch(e => alert(e.message));
	}

	// 강퇴
	function removeMember(email){
		if(!confirm(`${email} 님을 강퇴하시겠습니까?`)) return;
		fetch('/project/member/remove', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ projectId, email })
		}).then(r => {
			if(!r.ok) throw new Error('강퇴 실패');
			location.reload();
		}).catch(e => alert(e.message));
	}
</script>
</body>
</html>
