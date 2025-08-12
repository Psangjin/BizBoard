/**
 * 
 */

const circle = document.getElementById('progress-circle');
let text = document.getElementById('percentText');
const radius = circle.r.baseVal.value;
const circumference = 2 * Math.PI * radius;
let currentPercent = 0;

function setProgress(percent) {
	const offset = circumference - (percent / 100) * circumference;
	circle.style.strokeDashoffset = offset;
	text.textContent = percent + '%';
}

function changeProgress(change) {
	currentPercent = Math.min(100, Math.max(0, currentPercent + change));
	setProgress(currentPercent);
}

setProgress(currentPercent);

/////////////////
document.addEventListener('DOMContentLoaded', () => {
  // 상세 모달
  const noticeViewModalEl = document.getElementById('noticeViewModal');
  const noticeViewModal = new bootstrap.Modal(noticeViewModalEl);

  function openNoticeView(id) {
    fetch(`/notice/get?id=${id}`)
      .then(r => { if (!r.ok) throw new Error('공지 상세 조회 실패'); return r.json(); })
      .then(n => {
        $id('view-title').textContent = n.title || '';
        $id('view-user').textContent  = n.userId || '';
        $id('view-time').textContent  = n.writeTime ? new Date(n.writeTime).toLocaleString() : '';
        $id('view-desc').textContent  = n.description || '';
        $id('view-edit').onclick = () => {
          $id('noticeModalTitle').textContent = '공지 수정';
          $id('notice-id').value   = n.id;
          $id('notice-title').value= n.title || '';
          $id('notice-desc').value = n.description || '';
          $id('btnNoticeSave').dataset.mode = 'edit';
          noticeViewModal.hide();
          noticeModal.show();
        };
        noticeViewModal.show();
      })
      .catch(err => alert(err.message));
  }

  // ===== 공지 리스트 렌더링 준비 =====
  const noticeBox   = document.getElementById('noticeBox');
  const noticeTbody = document.getElementById('noticeListBody');
  const noticeModalEl = document.getElementById('noticeModal');
  const noticeModal = new bootstrap.Modal(noticeModalEl);
  const btnNoticeEditToggle = document.getElementById('btnNoticeEditToggle');
  const $id = (id) => document.getElementById(id);
  let isEditing = false;

  function postJson(url, payload) {
    return fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
  }

  async function loadNotices() {
    try {
      noticeTbody.innerHTML = `<tr><td colspan="3" class="text-center text-muted">불러오는 중…</td></tr>`;
      const r = await fetch(`/notice/list?projectId=${encodeURIComponent(projectId)}`);
      if (!r.ok) throw new Error('공지 목록 조회 실패');
      const list = await r.json();
      if (!list || list.length === 0) {
        noticeTbody.innerHTML = `<tr><td colspan="3" class="text-center text-muted">등록된 공지가 없습니다.</td></tr>`;
        return;
      }
      noticeTbody.innerHTML = list.map(n => {
        const safeTitle = escapeHtml(n.title || '');
        const safeDesc  = escapeHtml(n.description || '').replace(/\r?\n/g, '\n');
        return `
          <tr data-id="${n.id}">
            <td class="title text-truncate" title="${safeTitle}">${safeTitle}</td>
            <td class="desc"><div class="clamp-2" title="${safeDesc}">${safeDesc}</div></td>
            <td class="actions">
              <button class="btn btn-sm btn-outline-danger" data-action="del">삭제</button>
            </td>
          </tr>`;
      }).join('');
    } catch (e) {
      console.error(e);
      noticeTbody.innerHTML = `<tr><td colspan="3" class="text-danger text-center">${e.message}</td></tr>`;
    }
  }

  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, s => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[s]));
  }

  // + 버튼 (등록)
  const btnNoticeAdd = document.getElementById('btnNoticeAdd');
  btnNoticeAdd.addEventListener('click', () => {
    $id('noticeModalTitle').textContent = '공지 등록';
    $id('notice-id').value = '';
    $id('notice-title').value = '';
    $id('notice-desc').value = '';
    $id('btnNoticeSave').dataset.mode = 'create';
    noticeModal.show();
  });

  // 편집 토글
  btnNoticeEditToggle.addEventListener('click', () => {
    isEditing = !isEditing;
    noticeBox.classList.toggle('is-editing', isEditing);
    btnNoticeEditToggle.classList.toggle('active', isEditing);
    btnNoticeEditToggle.textContent = isEditing ? '편집 취소' : '편집';
  });

  // 테이블 클릭
  noticeTbody.addEventListener('click', (e) => {
    const row = e.target.closest('tr[data-id]');
    if (!row) return;
    const id = Number(row.dataset.id);

    // 삭제 버튼
    if (e.target.matches('[data-action="del"]')) {
      e.stopPropagation();
      if (!confirm('정말 삭제하시겠습니까?')) return;
      postJson('/notice/delete', { id })
        .then(r => { if (!r.ok) throw new Error('삭제 실패'); loadNotices(); })
        .catch(err => alert(err.message));
      return;
    }

    // 행 클릭 동작
    if (isEditing) {
      // 수정 모달
      fetch(`/notice/get?id=${id}`)
        .then(r => r.json())
        .then(n => {
          $id('noticeModalTitle').textContent = '공지 수정';
          $id('notice-id').value   = n.id;
          $id('notice-title').value= n.title || '';
          $id('notice-desc').value = n.description || '';
          $id('btnNoticeSave').dataset.mode = 'edit';
          noticeModal.show();
        });
    } else {
      // 보기 모달
      openNoticeView(id);
    }
  });

  // 저장 (등록/수정 공용)
  document.getElementById('btnNoticeSave').addEventListener('click', () => {
    const mode = $id('btnNoticeSave').dataset.mode;
    const title = $id('notice-title').value.trim();
    const description = $id('notice-desc').value.trim();
    if (!title) { alert('제목을 입력하세요.'); return; }
	alert('저장되었습니다!');

    if (mode === 'create') {
      postJson('/notice/create', { projectId: Number(projectId), title, description })
        .then(r => { if (!r.ok) throw new Error('등록 실패'); noticeModal.hide(); loadNotices(); })
        .catch(err => alert(err.message));
    } else {
      const id = Number($id('notice-id').value);
      postJson('/notice/update', { id, title, description })
        .then(r => { if (!r.ok) throw new Error('수정 실패'); noticeModal.hide(); loadNotices(); })
        .catch(err => alert(err.message));
    }
  });

  // 최초 로드
  loadNotices();
});

