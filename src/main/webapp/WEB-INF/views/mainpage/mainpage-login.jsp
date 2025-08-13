<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BizBoard</title>
<style>

.user-dropdown {
 position: relative;
 display: inline-block;
 }
 
.dropdown-menu {
  display: none; /* 기본 숨김 */
  position: absolute;
  top: 28px; /* 아이콘 아래로 */
  right: 0;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 6px;
  list-style: none;
  padding: 8px 0;
  margin: 0;
  min-width: 140px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.15);
  z-index: 10;
}

.dropdown-menu li {
  padding: 8px 12px;
  cursor: pointer;
  font-size: 14px;
  color: #333;
}

.dropdown-menu li:hover {
  background-color: #f0f0f0;
}

/* 마우스 올렸을 때 드롭다운 표시 */
.user-dropdown:hover .dropdown-menu {
  display: block;
}

/* 아이콘 스타일 */
.mainpage-header-icon {
  font-size: 22px;
  color: #0d5ea3;
  cursor: pointer;
}
 
 /* ===== Modal ===== */
.modal { position:fixed; inset:0; background:rgba(0,0,0,.35); z-index:1000; }
.modal-content { width:360px; max-width:calc(100% - 32px); background:#fff; margin:120px auto; padding:20px; border-radius:10px; box-shadow:0 6px 20px rgba(0,0,0,.2); }
.modal-content h3 { margin:0 0 8px; }
.modal-content p { margin:0 0 12px; color:#333; }
.modal-content input[type="password"] { width:100%; padding:10px; margin-bottom:12px; border:1px solid #ddd; border-radius:6px; box-sizing:border-box; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; }
.btn-secondary { background:#e0e0e0; border:none; padding:8px 14px; border-radius:6px; cursor:pointer; }
.btn-danger { background:#e74c3c; color:#fff; border:none; padding:8px 14px; border-radius:6px; cursor:pointer; }
.btn-danger:hover { opacity:.9; }
.msg-error { color:#e74c3c; font-weight:600; margin-top:6px; }
.msg-success { color:green; font-weight:600; margin-top:6px; }
 </style>
 
</head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<style>
	.modal-backdrop{
    display:none; position:fixed; inset:0; background:rgba(0,0,0,.35); z-index:9999;
  }
  .modal-card{
    position:fixed;            /* ← 가운데 고정 */
    top:8vh; left:50%; transform:translateX(-50%);
    width:clamp(320px, 92vw, 560px);   /* ← 화면에 맞춰 최대/최소 폭 */
    max-height:calc(100vh - 16vh);
    overflow:auto;
    background:#fff; border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,.2);
    padding:18px 20px; box-sizing:border-box;  /* ← 패딩 포함 계산 */
  }
  /* 입력 요소도 박스사이징 통일 */
  .modal-card .form-control{ box-sizing:border-box; width:100%; }
  
   /* ...기존 스타일... */
  #project-box.edit-on{
    outline:2px dashed #dc3545;
    background: #fff1f2;
    transition: all .15s ease-in-out;
  }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>

	<c:if test="${not empty sessionScope.loginUser}">
	  <meta name="current-user" content="${sessionScope.loginUser.id}">
	</c:if>
	
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
	  
	  
	  ///프로젝트 편집//
	  
	  // 현재 로그인 아이디 읽기 (meta, body data, 전역 중 아무거나 있으면 사용)
const CURRENT_USER =
  document.querySelector('meta[name="current-user"]')?.content ||
  document.body?.dataset?.userid ||
  (window.CURRENT_USER || null);

	  
  let editMode = false;           // 편집모드 여부
  let projectsCache = [];         // 목록 캐시
  const $popupList = document.querySelector('#mainpage-project-list');
  
  const $toggleBtn = document.querySelector('#toggle-edit-mode');
  const $projectBox = document.querySelector('#project-box');
  const $editPill = document.querySelector('#edit-pill');

  // 권한 체크
  const isAdminOf = (p) => (p.isAdmin === true) || (p.role === 'ADMIN');

  function toInputDatetimeLocal(ts) {
	  if (!ts) return '';
	  const d = new Date(ts);
	  const pad = (n) => String(n).padStart(2, '0');
	  return d.getFullYear() + '-' +
	         pad(d.getMonth() + 1) + '-' +
	         pad(d.getDate()) + 'T' +
	         pad(d.getHours()) + ':' +
	         pad(d.getMinutes());
	}

  function fromInputDatetimeLocal(v) {
    return v ? new Date(v).toISOString() : null;
  }

  function renderList(projects) {
	  // 편집 모드 & 로그인 아이디를 알 때만 내가 매니저인 것만 필터
	  const list = (!editMode || !CURRENT_USER)
	    ? projects
	    : projects.filter(p => String(p.manager).trim() === String(CURRENT_USER).trim());

	  $popupList.innerHTML = '';

	  if (!list.length) {
	    $popupList.innerHTML = editMode
	      ? '<li>내가 관리자인 프로젝트가 없습니다</li>'
	      : '<li>참여중인 프로젝트가 없습니다</li>';
	    return;
	  }

	  list.forEach((p) => {
	    const li = document.createElement('li');
	    li.textContent = p.title;
	    li.dataset.id = p.id;

	    if (editMode) {
	      li.style.cursor = 'pointer';
	      li.addEventListener('click', () => openEditModal(p));

	      if (isAdminOf(p) || String(p.manager) === String(CURRENT_USER)) {
	        const del = document.createElement('button');
	        del.textContent = '삭제';
	        del.className = 'btn btn-outline-danger btn-sm ms-2';
	        del.addEventListener('click', (e) => {
	          e.stopPropagation();
	          onDeleteProject(p);
	        });
	        li.appendChild(del);
	      }
	    } else {
	      li.addEventListener('click', () => goProject(p));
	    }

	    $popupList.appendChild(li);
	  });
	}


  function goProject(p) {
    $.ajax({
      url: '/project/setSession',
      method: 'POST',
      data: JSON.stringify(p),
      contentType: 'application/json',
      success: function () {
        location.href = '/project/main/' + p.id;
      },
      error: function () { alert('프로젝트 세션 저장에 실패했습니다.'); }
    });
  }

  // 🔹 부트스트랩 스타일 토글
  $toggleBtn.addEventListener('click', () => {
  editMode = !editMode;

  if (editMode) {
    // 버튼을 '위험(편집중)' 느낌으로
    $toggleBtn.classList.remove('btn-outline-primary','btn-success');
    $toggleBtn.classList.add('btn-danger','active');
    $toggleBtn.innerHTML = '<i class="bi bi-x-circle me-1"></i> 편집 종료';

    // 배지와 박스 하이라이트 ON
    if ($editPill) $editPill.classList.remove('d-none');
    if ($projectBox) $projectBox.classList.add('edit-on');
  } else {
    // 평상시: 연필 아이콘 + 아웃라인 파랑
    $toggleBtn.classList.remove('btn-danger','active');
    $toggleBtn.classList.add('btn-outline-primary');
    $toggleBtn.innerHTML = '<i class="bi bi-pencil-square me-1"></i> 편집';

    // 배지와 박스 하이라이트 OFF
    if ($editPill) $editPill.classList.add('d-none');
    if ($projectBox) $projectBox.classList.remove('edit-on');
  }

  renderList(projectsCache);
});

  // 최초 목록 로딩
  $.ajax({
    url: '/project/listByUserId',
    method: 'GET',
    dataType: 'json',
    success: function (projects) {
      if (!projects || projects.length === 0) {
        $popupList.innerHTML = '<li>참여중인 프로젝트가 없습니다</li>';
        return;
      }
      projectsCache = projects;
      renderList(projectsCache);
    },
    error: function () { alert('프로젝트 목록을 불러오는 데 실패했습니다.'); }
  });

  // ===== 모달 관련 =====
  const $backdrop = document.getElementById('project-edit-modal');
  const $form = document.getElementById('project-edit-form');
  const $close = document.getElementById('modal-close');
  const $cancel = document.getElementById('modal-cancel');

  function openEditModal(p) {
    document.getElementById('edit-id').value = p.id;
    document.getElementById('edit-manager').value = p.manager || '';
    document.getElementById('edit-title').value = p.title || '';
    document.getElementById('edit-content').value = p.content || '';
    document.getElementById('edit-enddt').value = toInputDatetimeLocal(p.end_dt || p.endDt);
    $backdrop.style.display = 'block';
    document.body.style.overflow = 'hidden';
  }
  function closeEditModal() {
    $backdrop.style.display = 'none';
    document.body.style.overflow = '';
    $form.reset();
  }

  $close.addEventListener('click', closeEditModal);
  $cancel.addEventListener('click', closeEditModal);
  $backdrop.addEventListener('click', (e) => { if (e.target === $backdrop) closeEditModal(); });

  $form.addEventListener('submit', function (e) {
    e.preventDefault();
    const payload = {
      id: Number(document.getElementById('edit-id').value),
      manager: document.getElementById('edit-manager').value.trim(),
      title: document.getElementById('edit-title').value.trim(),
      content: document.getElementById('edit-content').value.trim(),
      end_dt: fromInputDatetimeLocal(document.getElementById('edit-enddt').value)
    };

    $.ajax({
      url: '/project/update',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: function () {
        closeEditModal();
        const idx = projectsCache.findIndex(pp => String(pp.id) === String(payload.id));
        if (idx > -1) {
          projectsCache[idx] = { ...projectsCache[idx], ...payload };
        }
        renderList(projectsCache);
        alert('수정되었습니다.');
      },
      error: function () { alert('수정에 실패했습니다.'); }
    });
  });

  function onDeleteProject(p) {
	  if (!confirm('정말로 "' + p.title + '" 프로젝트를 삭제하시겠습니까?')) return;
	  $.ajax({
	    url: '/project/delete/' + p.id,
	    method: 'POST',
	    success: function () {
	      projectsCache = projectsCache.filter(x => String(x.id) !== String(p.id));
	      renderList(projectsCache);
	      alert('삭제되었습니다.');
	    },
	    error: function () { alert('삭제에 실패했습니다.'); }
	  });
	}

	  

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

	<!-- 회원탈퇴 모달 -->
	<div id="deleteModal" class="modal" role="dialog" aria-modal="true" aria-labelledby="deleteTitle" style="display:none;">
	  <div class="modal-content">
	    <h3 id="deleteTitle">회원 탈퇴</h3>
	    <p>정말 탈퇴하시겠습니까? 현재 비밀번호를 입력해 주세요.</p>
	
	    <form action="/account/delete" method="post" id="deleteForm">
	      <input type="password" name="currentPw" placeholder="현재 비밀번호" required />
	
	      <!-- 스프링 시큐리티 CSRF 사용 시 -->
	      <c:if test="${_csrf != null}">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	      </c:if>
	
	      <div class="modal-actions">
	        <button type="button" id="btnCloseDeleteModal" class="btn-secondary">취소</button>
	        <button type="button" id="btnConfirmDelete" class="btn-danger">탈퇴하기</button>
      </div>
	
	      <!-- 서버에서 flash로 내려온 메시지 표기용(선택) -->
	      <c:if test="${not empty deleteMsg}">
	        <p class="${deleteOk ? 'msg-success':'msg-error'}">${deleteMsg}</p>
	      </c:if>
	    </form>
	  </div>
	</div>

		
	<!-- SweetAlert2 CDN (먼저 로드) -->
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<!-- 공통 UI: 전부 상단, 깔끔하게 -->
		<script>
		  window.ui = {
		    alert(msg, icon = 'info') {
		      return Swal.fire({ text: msg, icon, position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
		    success(msg) {
		      return Swal.fire({ text: msg, icon: 'success', position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
		    error(msg) {
		      return Swal.fire({ text: msg, icon: 'error', position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
		    // 확정 필요할 때만: 상단에 뜨는 팝업(토스트 X) + 버튼
		    confirm(msg) {
		      return Swal.fire({
		        text: msg,
		        icon: 'warning',
		        position: 'top',
		        showCancelButton: true,
		        confirmButtonText: '확인',
		        cancelButtonText: '취소'
		      });
		    }
		  };
		</script>
		
		
		<script>
		  const modal = document.getElementById('deleteModal');
		  const openBtn = document.getElementById('btnOpenDeleteModal');
		  const closeBtn = document.getElementById('btnCloseDeleteModal');
		  const confirmBtn = document.getElementById('btnConfirmDelete');
		  const form = document.getElementById('deleteForm');
		  const pwInput = form.querySelector('input[name="currentPw"]');
		
		  // 서버 메시지 있으면 모달 오픈
		  <c:if test="${not empty deleteMsg}">modal.style.display = 'block';</c:if>
		
		  
		  
		  // 열기/닫기
		  openBtn?.addEventListener('click', () => { modal.style.display = 'block'; pwInput.focus(); });
		  const closeModal = () => modal.style.display = 'none';
		  closeBtn?.addEventListener('click', closeModal);
		  window.addEventListener('click', e => { if (e.target === modal) closeModal(); });
		  window.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
		
		  // 최종 확인 후 제출(중복제출 방지)
		   confirmBtn?.addEventListener('click', async () => {
		    const pw = pwInput.value.trim();
		    if (!pw) {
		      await ui.error("비밀번호를 입력해주세요."); 
		      pwInput.focus();
		      return;
		    }
		    const { isConfirmed } = await ui.confirm("정말로 탈퇴하시겠습니까?\n탈퇴 후 복구할 수 없습니다.");
		    if (isConfirmed) {
		      confirmBtn.disabled = true;
		      form.submit();
		    }
		  });
		</script>
		
		
		<c:if test="${not empty globalMsg}">
		  <script> ui.success("<c:out value='${globalMsg}'/>"); </script>
		</c:if>
		
		<c:if test="${not empty deleteMsg}">
		  <script>
		    // 모달 열고, 비밀번호 입력칸 초기화 + 포커스
		    (function(){
		      const modal   = document.getElementById('deleteModal');
		      const form    = document.getElementById('deleteForm');
		      const pwInput = form ? form.querySelector('input[name="currentPw"]') : null;
		
		      if (modal) modal.style.display = 'block';
		      if (pwInput) { pwInput.value = ''; pwInput.focus(); }
		
		      // 상단 토스트로 에러 출력
		      if (window.ui && ui.error) {
		        ui.error("<c:out value='${deleteMsg}'/>");
		      }
		    })();
		  </script>
		</c:if>
</body>
</html>