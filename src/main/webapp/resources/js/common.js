/**
 * 
 */
document.addEventListener('DOMContentLoaded', function() {
	let projectId = document.getElementById('project-id').value;
	
  // 레이아웃 사이드바 토글
  const toggleSidebarBtn = document.getElementById('toggleSidebar');
  if (toggleSidebarBtn) {
    toggleSidebarBtn.addEventListener('click', function () {
      const sidebar = document.querySelector('.body-side-menubar');
      sidebar.classList.toggle('hidden');
    });
  }

  // 사이드 메뉴 아이콘 페이지 이동
  const projectIcon = document.getElementById('fa-project-icon');
  if (projectIcon) {
    projectIcon.addEventListener('click', function() {
    location.href = `/project/main/${projectId}`;
    });
  }

  const calendarIcon = document.getElementById('fa-calendar-icon');
  if (calendarIcon) {
    calendarIcon.addEventListener('click', function() {
      location.href = `/project/schedule/${projectId}`;
    });
  }
  
  const noteIcon = document.getElementById('fa-note-icon')
  if (noteIcon) {
	noteIcon.addEventListener('click', function () {
	  location.href = `/project/memo/${projectId}`;
	});
  }
  
	  
  const userIcon = document.getElementById('fa-user-pen-icon')
  if (userIcon) {
  userIcon.addEventListener('click', function () {
    location.href = "/project/user";
  });
  }
  const fabMain = document.querySelector('.fab-main');
    const fabMenu = document.querySelector('.fab-menu');
	const mainLogo = document.querySelector('#header-logo');
	
	mainLogo.addEventListener('click', () => {
		location.href = `/`;
	})
    let hideTimeout;

    // + 버튼 클릭 시 메뉴 토글
    fabMain.addEventListener('click', () => {
      fabMenu.classList.toggle('show');
    });

    // 메뉴에서 마우스 떠나면 일정 시간 후 닫힘
    fabMenu.addEventListener('mouseleave', () => {
      hideTimeout = setTimeout(() => {
        fabMenu.classList.remove('show');
      }, 600);
    });

    // 메뉴에 다시 들어오면 타이머 제거
    fabMenu.addEventListener('mouseenter', () => {
      clearTimeout(hideTimeout);
    });
	
	const fabItems = document.querySelectorAll(".fab-item");

	    fabItems.forEach(item => {
	      const popup = item.querySelector(".fab-popup");
		  let popupHideTimeout;

	      item.addEventListener("mouseenter", () => {
			clearTimeout(popupHideTimeout);
	        popup.style.opacity = "1";
	        popup.style.transform = "translateX(-10px)";
	        popup.style.pointerEvents = "auto";
	      });

		  item.addEventListener("mouseleave", () => {
		        popupHideTimeout = setTimeout(() => {
		          popup.style.opacity = "0";
		          popup.style.transform = "translateX(0)";
		          popup.style.pointerEvents = "none";
		        }, 100); // <-- 약간의 딜레이를 줘서 popup 위로 이동할 시간을 확보
		      });
		  
		  popup.addEventListener('mouseenter', ()=>{
			clearTimeout(hideTimeout);
			clearTimeout(popupHideTimeout);
		  });
	    });
		
		$(document).ready(function () {
		    $.ajax({
		      url: '/project/listByUserId',
		      method: 'GET',
		      success: function (projects) {
		        const $popupList = document.querySelector('.fab-item[data-popup="프로젝트 관련"] .fab-popup ul');
		        

		        // 목록 추가
		        projects.forEach(function (project) {
		          const li = document.createElement('li');
		          li.textContent = project.title;
		          li.setAttribute('data-id', project.id);
				  // 클릭 시 해당 프로젝트 페이지로 이동
		  		    li.addEventListener('click', () => {
		  		      // 예: /project/detail/{projectId} 같은 URL로 이동
					  $.ajax({
					      url: '/project/setSession',
					      method: 'POST',
					      data: JSON.stringify(project),
						  contentType: 'application/json',
					      success: function () {
					        // 저장이 끝나면 페이지 이동
					        location.href = `/project/main/${project.id}`;
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
		  });
		  /////
		  // ===== 뱃지 DOM 생성 =====
		  const fabMainBtn = document.querySelector('.fab-main');
		  let fabMainBadge = document.querySelector('.fab-badge-dot');
		  if (!fabMainBadge && fabMainBtn) {
		    fabMainBadge = document.createElement('span');
		    fabMainBadge.className = 'fab-badge-dot';
		    fabMainBadge.textContent = '!'; // 느낌표
		    fabMainBtn.appendChild(fabMainBadge);
		  }

		  const bellItem = document.querySelector('.fab-item[data-popup="알림 목록"]');
		  let bellBadge = document.querySelector('.fab-badge-count');
		  if (!bellBadge && bellItem) {
		    bellBadge = document.createElement('span');
		    bellBadge.className = 'fab-badge-count';
		    bellBadge.textContent = '0';
		    bellItem.appendChild(bellBadge);
		  }

		  /** 뱃지 갱신 */
		  // ===== 뱃지 갱신 함수 =====
		  async function refreshInformBadges() {
		    try {
		      const res = await fetch('/inform/api/list?scope=unread', {
		        headers: { Accept: 'application/json' }
		      });

		      let count = 0;
		      if (res.status === 200) {
		        const arr = await res.json();
		        count = Array.isArray(arr) ? arr.length : 0;
		      } // 204면 count=0 유지

		      // + 버튼 배지
		      if (fabMainBadge) fabMainBadge.style.display = count > 0 ? 'inline-flex' : 'none';

		      // 🔔 숫자 배지
		      if (bellBadge) {
		        if (count > 0) {
		          bellBadge.textContent = count > 99 ? '99+' : String(count);
		          bellBadge.style.display = 'inline-block';
		        } else {
		          bellBadge.style.display = 'none';
		        }
		      }
		    } catch (e) {
		      console.warn('[INFORM] badge refresh error', e);
		      if (fabMainBadge) fabMainBadge.style.display = 'none';
		      if (bellBadge) bellBadge.style.display = 'none';
		    }
		  }

		  // ✅ 전역에서 호출 가능하도록
		  window.refreshInformBadges = refreshInformBadges;

		  // 최초 1회
		  refreshInformBadges();

 

});
// ============ 알림 모달 열기 트리거 연결 ============
// FAB의 "알림 목록" > "읽지 않은 알림", "전체 알림" 항목을 클릭했을 때 모달 오픈
document.addEventListener('DOMContentLoaded', () => {
  // 메뉴 항목이 li 텍스트로만 있다면 다음처럼 델리게이션
  document.querySelectorAll('.fab-item:has(> .fab-popup) .fab-popup li').forEach(li => {
    li.addEventListener('click', (e) => {
      const label = e.currentTarget.textContent.trim();
      if (label.includes('읽지 않은')) openInformModal('unread');
      if (label.includes('전체 알림')) openInformModal('all');
    });
  });

  // 탭 전환
  document.getElementById('tab-unread').addEventListener('click', () => switchTab('unread'));
  document.getElementById('tab-all').addEventListener('click', () => switchTab('all'));

  // 닫기
  document.getElementById('inform-modal-close').addEventListener('click', closeInformModal);
  document.getElementById('inform-modal-close-2').addEventListener('click', closeInformModal);
  document.getElementById('inform-modal-backdrop').addEventListener('click', closeInformModal);
});

function openInformModal(scope='unread'){
  document.getElementById('inform-modal-backdrop').style.display = 'block';
  document.getElementById('inform-modal').style.display = 'flex';
  setActiveTab(scope);
  loadAndRenderInforms(scope);
}
function closeInformModal(){
  document.getElementById('inform-modal-backdrop').style.display = 'none';
  document.getElementById('inform-modal').style.display = 'none';
}

function setActiveTab(scope){
  document.querySelectorAll('.bb-tab').forEach(btn => btn.classList.remove('active'));
  document.querySelector(`.bb-tab[data-scope="${scope}"]`)?.classList.add('active');
}
function switchTab(scope){
  setActiveTab(scope);
  loadAndRenderInforms(scope);
}

// ============ 데이터 로딩/렌더링 ============
// 서버 API 규약 (예시):
// GET  /inform/api/list?scope=unread|all   -> [{informId, type, title, message, occurredAt, read}]
// POST /inform/api/read  {informId}       -> {ok:true}
// === [추가] 알림용 공통 헬퍼들 ===
function typeLabel(t){
  switch (t) {
    case 'PROJECT_EVENT': return '프로젝트';
    case 'TASK_EVENT':    return '작업';
    case 'NOTICE_EVENT':  return '공지';
    default:              return '알림';
  }
}

async function loadAndRenderInforms(scope) {
  const listEl = document.getElementById('inform-list');
  const emptyEl = document.getElementById('inform-empty');
  listEl.innerHTML = '';
  emptyEl.style.display = 'none';
  emptyEl.textContent = '';

  try {
	console.log('[INFORM] fetch start', scope);
    const res = await fetch(`/inform/api/list?scope=${encodeURIComponent(scope)}`, {
      headers: { 'Accept': 'application/json' },
      // 다른 포트/도메인에서 호출하면 주석 해제:
      // credentials: 'include',
    });
	
	console.log('[INFORM] status', res.status);
	
    if (res.status === 401) {
		console.warn('[INFORM] 401 - 로그인 세션 없음');
      emptyEl.style.display = 'block';
      emptyEl.textContent = '로그인이 필요합니다. 다시 로그인해 주세요.';
      return;
    }
    if (res.status === 204) {
      emptyEl.style.display = 'block';
      emptyEl.textContent = '표시할 알림이 없습니다.';
      return;
    }
    if(!res.ok) throw new Error('목록 조회 실패 ' + res.status);

    const items = await res.json();
	console.log('[INFORM] items', items);
	
    if (!Array.isArray(items) || items.length === 0) {
      emptyEl.style.display = 'block';
      emptyEl.textContent = '표시할 알림이 없습니다.';
      return;
    }

    for (const it of items) {
      const li = document.createElement('li');
      li.className = 'inform-row';
      li.dataset.id = it.informId;

      const badgeClass =
        it.type === 'TASK_EVENT' ? 'task' :
        it.type === 'NOTICE_EVENT' ? 'notice' : '';

      li.innerHTML = `
        <div class="inform-main">
          <div>
            <span class="inform-type badge ${badgeClass}">
              ${typeLabel(it.type)}
            </span>
            <span class="inform-title">${escapeHtml(it.title || '(제목 없음)')}</span>
          </div>
          <div class="inform-meta">
            ${formatDate(it.occurredAt)} · ${escapeHtml(it.message || '')}
          </div>
        </div>
        <div class="inform-actions">
          ${it.read ? '' : '<button class="btn-read" data-action="read">읽음</button>'}
        </div>
      `;

	  li.addEventListener('click', async (e) => {
	    const btn = e.target.closest('[data-action="read"]');
	    if (!btn) return;
	    btn.disabled = true;

	    const ok = await markAsRead(it.informId);

	    if (ok) {
	      if (scope === 'unread') {
	        li.remove();
	        if (!listEl.children.length) {
	          emptyEl.textContent = '표시할 알림이 없습니다.';
	          emptyEl.style.display = 'block';
	        }
	      } else {
	        btn.remove();
	      }
	      refreshInformBadges(); // ✅ 읽음 후 카운트 갱신
	    } else {
	      btn.disabled = false;
	      alert('읽음 처리에 실패했습니다.');
	    }
	  });

      listEl.appendChild(li);
    }
  } catch (err) {
    console.error('[INFORM] error', err);
    emptyEl.style.display = 'block';
    emptyEl.textContent = '알림을 불러오는 중 오류가 발생했습니다.';
  }
}

function formatDate(v) {
  if (v == null) return '';
  if (typeof v === 'number') {
    if (v < 1e12) v *= 1000; // 초→ms 보정
    return new Date(v).toLocaleString();
  }
  const d = new Date(v);
  return isNaN(d) ? String(v) : d.toLocaleString();
}

async function markAsRead(informId) {
  try {
    const res = await fetch('/inform/api/read', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ informId }),
      // 다른 포트/도메인이라면:
      // credentials: 'include',
    });
    if (res.status === 401) { alert('로그인이 필요합니다.'); return false; }
    if (!res.ok) return false;
    const data = await res.json();
    return !!data.ok;
  } catch (e) {
    console.error(e);
    return false;
  }
}


// XSS 방지용
function escapeHtml(s){
  return String(s ?? '').replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
}