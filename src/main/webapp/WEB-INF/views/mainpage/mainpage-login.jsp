<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
				<div class='mainpage-contents-box'></div>
			</div>
			<div class='mainpage-contents'>
				<div class="contents-text">오늘 할 일</div>
				<div class='mainpage-contents-box'></div>
			</div>
		</div>

		<div class='mainpage-right'>
			<div class="contents-text">참여중인 프로젝트</div>
			<div class='mainpage-contents-box'>
			 <button id="toggle-edit-mode" class="btn btn-outline-primary btn-sm">
			    <i class="bi bi-pencil-square me-1"></i> 편집
			  </button>
			  <!-- <span id="edit-pill" class="badge bg-danger ms-2 d-none">편집 모드</span>  -->
			  
			  <div class="fab-item" data-popup="프로젝트 관련">
			    <div class="fab-popup fab-project-popup">
			      <div class="fab-popup-project-list">
			        <ul id="mainpage-project-list">
			          <!-- JS에서 li 항목들 생성 -->
			        </ul>
			      </div>
			      
			      <div class="popup-divider"></div>
			      <div class="create-project-wrapper">
			        <button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
			      </div>
			    </div>
			  </div>
			</div>
		</div>
		
		<!-- (추가) 프로젝트 수정 모달 -->
	<div id="project-edit-modal" class="modal-backdrop" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.35); z-index:9999;">
	  <div class="modal-card" style="width:520px; max-width:90vw; background:#fff; border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,.2); margin:8vh auto; padding:18px 20px;">
	    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
	      <h3 style="margin:0; font-size:18px;">프로젝트 수정</h3>
	      <button type="button" id="modal-close" style="border:none; background:transparent; font-size:20px;">×</button>
	    </div>
	
	    <form id="project-edit-form">
	      <input type="hidden" id="edit-id">
	
	      <div class="mb-2">
	        <label for="edit-manager" style="display:block; font-weight:600; margin-bottom:6px;">매니저(ID)</label>
	        <input id="edit-manager" type="text" class="form-control" style="width:100%; padding:8px 10px; border:1px solid #d0d7de; border-radius:8px;">
	      </div>
	
	      <div class="mb-2">
	        <label for="edit-title" style="display:block; font-weight:600; margin-bottom:6px;">제목</label>
	        <input id="edit-title" type="text" class="form-control" style="width:100%; padding:8px 10px; border:1px solid #d0d7de; border-radius:8px;">
	      </div>
	
	      <div class="mb-2">
	        <label for="edit-content" style="display:block; font-weight:600; margin-bottom:6px;">내용</label>
	        <textarea id="edit-content" rows="5" class="form-control" style="width:100%; padding:8px 10px; border:1px solid #d0d7de; border-radius:8px;"></textarea>
	      </div>
	
	      <div class="mb-3">
	        <label for="edit-enddt" style="display:block; font-weight:600; margin-bottom:6px;">마감 시간</label>
	        <input id="edit-enddt" type="datetime-local" class="form-control" style="width:100%; padding:8px 10px; border:1px solid #d0d7de; border-radius:8px;">
	      </div>
	
	      <div style="display:flex; gap:8px; justify-content:flex-end;">
	        <button type="button" id="modal-cancel" style="padding:8px 12px; border:1px solid #ccc; background:#fff; border-radius:8px;">취소</button>
	        <button type="submit" style="padding:8px 12px; border:1px solid #2b8a3e; background:#2ecc71; color:#fff; border-radius:8px;">저장</button>
	      </div>
	    </form>
	  </div>
	</div>

	</div>
<script>

document.addEventListener('DOMContentLoaded', function () {
	  
	  $.ajax({
	    url: '/project/listByUserId',
	    method: 'GET',
	    dataType: 'json', // JSON 형식으로 받기
	    success: function (projects) {
	    	const $popupList = document.querySelector('#mainpage-project-list');

	      if (!projects || projects.length === 0) {
	        $popupList.innerHTML = '<li>참여중인 프로젝트가 없습니다</li>';
	        return;
	      }

	      $popupList.innerHTML = '';
	   
	      projects.forEach(function (myProject) {
	        const li = document.createElement('li');
	        li.textContent = myProject.title;
	        li.dataset.id = myProject.id;
	        console.log(myProject);

	        li.addEventListener('click', () => {
	        	  console.log('클릭됨:', myProject);
	        	  $.ajax({
	        	    url: '/project/setSession',
	        	    method: 'POST',
	        	    data: JSON.stringify(myProject),
	        	    contentType: 'application/json',
	        	    success: function () {
	        	        location.href = `/project/main/`+myProject.id;
	        	    },
	        	    error: function () {
	        	      alert('프로젝트 세션 저장에 실패했습니다.');
	        	    }
	        	  });
	        	});

	        $popupList.appendChild(li);
	      });
	    },
	    error: function () {
	      alert("프로젝트 목록을 불러오는 데 실패했습니다.");
	    }
	  });
	  
	  
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

	  

	});
</script>
</body>
</html>