<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 참가자 관리</title>

<!-- ✅ Bootstrap 5.3 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!-- ✅ Bootstrap 5.3 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
  * { box-sizing: border-box; }
  #invite-body-container { width: 93vw; height: 88vh; overflow:auto; }
</style>
</head>
<body>
  <!-- 레이아웃에서 사용할 히든 값 -->
  <input type="hidden" id="memo-project-id" value="${projectId}">
  <input type="hidden" id="memo-login-user" value="${loginUser}">

  <%@ include file="../include/layout.jsp"%>
  <!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div 3개 닫기) -->

  <!-- 바디 페이지 -->
  <div id="invite-body-container" class="p-4">

    <!-- 초대 폼 -->
    <div class="card mb-4">
      <div class="card-header bg-light">
        <strong>프로젝트 참가자 초대</strong>
      </div>
      <div class="card-body">
        <form id="inviteForm" class="row g-3">
          <div class="col-md-6">
            <label class="form-label">아이디 또는 이메일</label>
            <input type="text" name="userId" class="form-control" placeholder="예: hansj 또는 hansj@company.com">
          </div>
          <div class="col-md-3">
            <label class="form-label">권한</label>
            <select name="role" class="form-select">
              <option value="OWNER">소유자</option>
              <option value="ADMIN">관리자</option>
              <option value="MEMBER" selected>일반</option>
              <option value="VIEWER">읽기전용</option>
            </select>
          </div>
          <div class="col-md-3 d-flex align-items-end">
            <button type="button" class="btn btn-primary w-100" id="btnInvite">초대 보내기</button>
          </div>
        </form>
        <div class="form-text mt-2">링크 초대가 필요하면 서버에서 토큰 생성 후 메일/메신저로 발송하세요.</div>
      </div>
    </div>

    <!-- 탭 -->
    <ul class="nav nav-tabs" id="memberTabs">
      <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#tab-members">참가자</a></li>
      <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tab-invites">대기중 초대</a></li>
      <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tab-logs">활동 로그</a></li>
    </ul>

    <div class="tab-content mt-3">

      <!-- 참가자 -->
      <div class="tab-pane fade show active" id="tab-members">
        <table class="table table-bordered align-middle mb-0">
          <thead class="table-light">
            <tr>
              <th>이름</th>
              <th>아이디</th>
              <th>권한</th>
              <th>참가일</th>
              <th style="width:110px;">조치</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="m" items="${projectMemberList}">
              <tr>
                <td>${m.name}</td>
                <td>${m.userId}</td>
                <td style="min-width:160px;">
                  <select class="form-select form-select-sm" onchange="changeRole('${m.userId}', this.value)">
                    <option value="OWNER" ${m.role=='OWNER'?'selected':''}>소유자</option>
                    <option value="ADMIN" ${m.role=='ADMIN'?'selected':''}>관리자</option>
                    <option value="MEMBER" ${m.role=='MEMBER'?'selected':''}>일반</option>
                    <option value="VIEWER" ${m.role=='VIEWER'?'selected':''}>읽기전용</option>
                  </select>
                </td>
                <td>${m.joinedAt}</td>
                <td>
                  <button class="btn btn-sm btn-outline-danger" onclick="removeMember('${m.userId}')">강퇴</button>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty projectMemberList}">
              <tr><td colspan="5" class="text-center text-muted">참가자가 없습니다.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- 대기중 초대 -->
      <div class="tab-pane fade" id="tab-invites">
        <table class="table table-bordered align-middle mb-0">
          <thead class="table-light">
            <tr>
              <th>초대한 사람</th>
              <th>대상 아이디</th>
              <th>만료일</th>
              <th>상태</th>
              <th style="width:120px;">조치</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="inv" items="${inviteList}">
              <tr>
                <td>${inv.invitedBy}</td>
                <td>${inv.userId}</td>
                <td>${inv.expiresAt}</td>
                <td>${inv.status}</td>
                <td>
                  <button class="btn btn-sm btn-outline-secondary" onclick="cancelInvite('${inv.token}')">초대 취소</button>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty inviteList}">
              <tr><td colspan="5" class="text-center text-muted">대기중인 초대가 없습니다.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- 활동 로그 -->
      <div class="tab-pane fade" id="tab-logs">
        <table class="table table-bordered align-middle mb-0">
          <thead class="table-light">
            <tr>
              <th>시간</th>
              <th>행동</th>
              <th>수행자</th>
              <th>대상</th>
              <th>메모</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="log" items="${logList}">
              <tr>
                <td>${log.ts}</td>
                <td>${log.action}</td>
                <td>${log.by}</td>
                <td>${log.target}</td>
                <td>${log.note}</td>
              </tr>
            </c:forEach>
            <c:if test="${empty logList}">
              <tr><td colspan="5" class="text-center text-muted">로그가 없습니다.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>

    </div>
  </div> <!-- /invite-body-container -->

  </div>
  </div>
  </div>

  <script>
    const projectId = document.getElementById('memo-project-id')?.value || '';
    const loginUser = document.getElementById('memo-login-user')?.value || '';

    // 초대 보내기
    document.getElementById('btnInvite').addEventListener('click', function(){
      const fd = new FormData(document.getElementById('inviteForm'));
      const data = Object.fromEntries(fd);
      if(!data.userId) { alert('아이디를 입력하세요.'); return; }

      fetch('/project/member/invite', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ projectId, userId: data.userId, role: data.role })
      }).then(r => {
        if(!r.ok) throw new Error('초대 실패');
        location.reload();
      }).catch(e => alert(e.message));
    });

    // 권한 변경
    function changeRole(userId, role){
      if(!confirm(`${userId}님의 권한을 ${role}로 변경하시겠습니까?`)) return;
      fetch('/project/member/role', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ projectId, userId, role })
      }).then(r => {
        if(!r.ok) throw new Error('권한 변경 실패');
        // 즉시 반영이면 reload 생략 가능
      }).catch(e => alert(e.message));
    }

    // 강퇴
    function removeMember(userId){
      if(!confirm(`${userId} 님을 강퇴하시겠습니까?`)) return;
      fetch('/project/member/remove', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ projectId, userId })
      }).then(r => {
        if(!r.ok) throw new Error('강퇴 실패');
        location.reload();
      }).catch(e => alert(e.message));
    }

    // 초대 취소
    function cancelInvite(token){
      fetch('/project/member/invite/' + token, { method: 'DELETE' })
        .then(r => {
          if(!r.ok) throw new Error('초대 취소 실패');
          location.reload();
        }).catch(e => alert(e.message));
    }
  </script>
</body>
</html>
