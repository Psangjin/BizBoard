function postJson(url, payload) {
  return fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
}
/////////////커멘트는 자기만 편집하도록 하기 위해 렌더커멘츠 수정(전역으로)/////
function toggleAddCommentButton(members) {
  const isMember = (members || []).some(m => String(m.userId).trim() === String(LOGIN_ID).trim());
  document.getElementById('open-add-comment-btn')
    ?.classList.toggle('hidden-section', !isMember);
}

// 로그인 아이디
 const LOGIN_ID =
   document.getElementById('login-user')?.value ||
   document.querySelector('meta[name="current-user"]')?.content || '';

/////자기거만 편집
 function renderComments(list) {
   const box = document.getElementById('task-comment');
   if (!list?.length) { box.innerHTML = '<div class="text-muted">등록된 코멘트가 없습니다.</div>'; return; }

   box.innerHTML = list.map(c => {
     const ts = c.writeTime ? new Date(c.writeTime) : null;
     const tsText = ts ? ts.toLocaleString() : '';
     const writerText = c.writterName || c.userName || `User#${c.userId ?? ''}`;

     const isMine = String(c.userId ?? c.writerId ?? c.writterId)
                      .trim() === String(LOGIN_ID).trim();

     return `
       <div class="card mb-2" data-comment-id="${c.id}" data-user-id="${c.userId}">
         <div class="card-body p-2">
           <div class="d-flex justify-content-between">
             <div>
               <div class="view-area">
                 <div class="fw-bold comment-title-text">${c.title ?? ''}</div>
                 <div class="small text-secondary">${writerText} · ${tsText}</div>
                 <div class="mt-2 comment-desc-text">${c.description ?? ''}</div>
                 ${c.filePath ? `<div class="mt-1"><i class="fa-regular fa-file"></i> ${c.filePath}</div>` : ''}
               </div>

               <div class="edit-area hidden-section">
                 <input class="form-control form-control-sm mb-2" name="title" value="${c.title ?? ''}">
                 <textarea class="form-control form-control-sm mb-2" rows="3" name="desc">${c.description ?? ''}</textarea>
                 <input type="file" class="form-control form-control-sm" name="file">
                 <div class="small text-muted mt-1">현재 파일: ${c.filePath ?? '없음'}</div>
               </div>
             </div>

             <div class="text-nowrap ms-2">
               <button class="btn btn-sm btn-outline-primary ${isMine ? '' : 'hidden-section'}" data-action="edit">편집</button>
               <button class="btn btn-sm btn-outline-success hidden-section" data-action="save">저장</button>
               <button class="btn btn-sm btn-outline-secondary hidden-section" data-action="cancel">취소</button>
               <button class="btn btn-sm btn-outline-danger ${isMine ? '' : 'hidden-section'}" data-action="delete">삭제</button>
             </div>
           </div>
         </div>
       </div>
     `;
   }).join('');
 }
 ////////////커멘트 수정 
document.addEventListener('DOMContentLoaded', function () {
	//renderComments();  // ⬅ 이걸 꼭 추가
	
	const projectId = document.getElementById("project-id")?.value;
	  if (projectId) {
	    fetchTasksAndRenderGantt();  // ✅ 초기 로딩 시 호출
	  }
	  console.log(projectId);
	  
  let selectedTask = null;
  let selectedSchedule = null;  // ✅ 전역 선언 추가

/*  let tasks = [
    {
      description: '설명',
      member: ['김동욱'],
      id: 'Task 1',
      name: '요구사항 정리',
      start: '2025-08-01',
      end: '2025-08-04',
      progress: 40,
      dependencies: ''
    },
    {
      description: '설명',
      member: ['김동욱'],
      id: 'Task 2',
      name: '설계',
      start: '2025-08-05',
      end: '2025-08-10',
      progress: 20,
      dependencies: 'Task 1'
    }
  ];*/
  let ganttInstance = null;
  let showingCalendar = true;
  let isEditMode = false; // 편집 모드 상태 저장

// 간트 스크립트 시작 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Gantt Toggle
document.querySelector('.fa-arrow-right-arrow-left').addEventListener('click', function () {
  const eventtrash = document.getElementById('fc-trash-area');
  const eventdetails = document.getElementById('fc-event-details');
  const calendarEl = document.getElementById('calendar');
  const ganttWrapper = document.getElementById('gantt');
  const dragevent = document.getElementById('fc-external-events');
  const taskdetailpanel = document.getElementById('task-detail-panel');
  const taskeditpanel = document.getElementById('task-edit-panel');
  document.getElementById('task-edit-title').textContent = "";
  document.getElementById('detail-title').textContent = "";

  if (showingCalendar) {
    // ✅ Gantt 화면으로 전환 중
	eventtrash.classList.add('hidden-section');
    if (eventdetails.style.display !== "none") eventdetails.style.display = "none";
    dragevent.classList.add('hidden-section');
    calendarEl.classList.add('hidden-section');
    ganttWrapper.classList.remove('hidden-section');
    taskdetailpanel.classList.remove('hidden-section');

    // ✅ 편집 모드가 활성화되어 있으면 편집 패널 보여주기
    if (document.querySelector("#toggle-edit-mode").classList.contains("btn-success")) {
      taskeditpanel.classList.remove('hidden-section');
    }

    // ✅ Gantt 인스턴스 없으면 생성
    if (!ganttInstance) {
      ganttInstance = new Gantt("#gantt-target", [], {
        bar_height: 80,
        padding: 20,
        view_mode: 'Week',
        on_click: function (task) {
			selectedSchedule = { id: getScheduleIdFromTask(task) }; // ✅ 통일
          showGanttTaskDetail(task);
          showGanttTaskEdit(task);
		  onTaskChange(task);//추가
		  // ✅ 여기 추가
		    setCurrentScheduleForComments(String(selectedSchedule.id).trim());
        }
      });
    }

    // ✅ 항상 새로 그리기
    fetchTasksAndRenderGantt();

  } else {
    // ✅ Calendar 화면으로 전환 중
    dragevent.classList.remove('hidden-section');
	eventtrash.classList.remove('hidden-section');
    calendarEl.classList.remove('hidden-section');
    ganttWrapper.classList.add('hidden-section');
    taskdetailpanel.style.display = "none";
    taskeditpanel.classList.add('hidden-section');
  }

  showingCalendar = !showingCalendar;
});


  // Gantt View Mode 버튼
  function setActiveGanttButton(mode) {
    document.querySelectorAll('#gantt-view-area .fc-button').forEach(btn => btn.classList.remove('active'));
    const activeBtn = document.getElementById(`gantt-view-${mode.toLowerCase()}`);
    if (activeBtn) activeBtn.classList.add('active');
  }

  document.getElementById("gantt-view-day").addEventListener("click", () => {
    ganttInstance?.change_view_mode("Day");
    setActiveGanttButton("day");
  });

  document.getElementById("gantt-view-week").addEventListener("click", () => {
    ganttInstance?.change_view_mode("Week");
    setActiveGanttButton("week");
  });

  document.getElementById("gantt-view-month").addEventListener("click", () => {
    ganttInstance?.change_view_mode("Month");
    setActiveGanttButton("month");
  });

  // Gantt 작업 추가/수정
  document.getElementById("open-add-task").addEventListener("click", function () {
    document.getElementById("ganttTaskModal").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
    document.getElementById("task-name").value = "";
    document.getElementById("task-description").value = "";
    document.getElementById("task-start").value = "";
    document.getElementById("task-end").value = "";
    document.getElementById("form-select").selectedIndex = -1;
  });

  document.getElementById("open-modify-task").addEventListener("click", async function () {
    if (!selectedTask) return;

    document.getElementById("ganttTaskModalModify").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
    document.getElementById("task-name-modify").value = selectedTask.name || '';
    document.getElementById("task-description-modify").value = selectedTask.description || '';
    document.getElementById("task-start-modify").value = selectedTask.start || '';
    document.getElementById("task-end-modify").value = selectedTask.end || '';

    const scheduleId = getScheduleIdFromTask(selectedTask);
    if (!scheduleId) return;

    const sel = document.getElementById("form-select-modify");
    await ensureProjectMemberOptions(sel, projectId,scheduleId);         // 옵션: value=userId(문자열)
    const members = await loadTaskMembers(scheduleId);        // [{userId, name}]
    applyMemberSelection(sel, members);
    renderDetailMemberNames(members, '#form-select-modify');
  });////


  
  document.getElementById("open-ganttDetail").addEventListener("click", async function () {
    if (!selectedTask) return;

    document.getElementById("ganttDetail").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
    document.getElementById("task-name-detail").value = selectedTask.name;
    document.getElementById("task-description-detail").value = selectedTask.description || '';
    document.getElementById("task-start-detail").value = selectedTask.start;
    document.getElementById("task-end-detail").value = selectedTask.end;

    const selDetail = document.getElementById("form-select-detail");
    await ensureProjectMemberOptions(selDetail, projectId);      // ✅ 프로젝트 멤버 옵션 채우기

    const members = await loadTaskMembers(
      (window.selectedSchedule && window.selectedSchedule.id) ??
      (selectedTask && selectedTask.scheduleId) ??
      selectedTask.id
    );                                                           // ✅ 스케줄 멤버 가져오기

    applyMemberSelection(selDetail, members);                    // ✅ 선택 반영
    selDetail.disabled = true;                                   // 읽기전용이면 disable

    // 이름 표시(오른쪽 텍스트 영역 등)
    renderDetailMemberNames(members, '#form-select-detail');     // ✅ 이름 매핑 기반 출력
  });

  
//모든 편집 버튼에 이벤트 연결
document.querySelectorAll('.comment-edit-btn').forEach(function (editBtn) {
    editBtn.addEventListener('click', function () {
      const container = editBtn.closest('#task-comment');

      // readonly 해제
      container.querySelectorAll('input').forEach(input => {
        input.removeAttribute('readonly');
        input.removeAttribute('disabled');
      });

      // 버튼 표시 토글
      container.querySelector('.comment-edit-btn')?.classList.add('hidden-section');
      container.querySelector('.comment-modify-btn')?.classList.remove('hidden-section');
      container.querySelector('.comment-modify-cancel-btn')?.classList.remove('hidden-section');
      container.querySelector('.comment-delete-btn')?.classList.remove('hidden-section');
    });
  }); 

  // 수정 완료 시 readonly 다시 설정
  document.querySelectorAll('.comment-modify-btn').forEach(function (modifyBtn) {
    modifyBtn.addEventListener('click', function () {
      const container = modifyBtn.closest('#task-comment');

      container.querySelectorAll('input').forEach(input => {
        input.setAttribute('readonly', 'readonly');
        input.removeAttribute('disabled');
      });

      // 버튼 토글
      container.querySelector('.comment-edit-btn')?.classList.remove('hidden-section');
      container.querySelector('.comment-modify-btn')?.classList.add('hidden-section');
      container.querySelector('.comment-modify-cancel-btn')?.classList.add('hidden-section');
      container.querySelector('.comment-delete-btn')?.classList.add('hidden-section');
    });
  });

  // 취소 버튼 동작
  document.querySelectorAll('.comment-modify-cancel-btn').forEach(function (cancelBtn) {
    cancelBtn.addEventListener('click', function () {
      const container = cancelBtn.closest('#task-comment');

      container.querySelectorAll('input').forEach(input => {
        input.setAttribute('readonly', 'readonly');
        input.removeAttribute('disabled');
      });

      container.querySelector('.comment-edit-btn')?.classList.remove('hidden-section');
      container.querySelector('.comment-modify-btn')?.classList.add('hidden-section');
      container.querySelector('.comment-modify-cancel-btn')?.classList.add('hidden-section');
      container.querySelector('.comment-delete-btn')?.classList.add('hidden-section');
    });
  });

  // 삭제 버튼 동작
  document.querySelectorAll('.comment-delete-btn').forEach(function (deleteBtn) {
    deleteBtn.addEventListener('click', function () {
      const container = deleteBtn.closest('#task-comment');
      container.style.display = 'none';
    });
  });

 
 document.getElementById("cancel-detail-btn").addEventListener("click", function () {
	 document.getElementById("ganttDetail").style.display = "none";
	 document.getElementById("ganttTaskBackdrop").style.display = "none";
});
 
 document.getElementById("close-task-detail-panel-btn").addEventListener("click", function () {
	 document.getElementById("task-detail-panel").style.display = "none";
});
 document.getElementById("open-add-comment-btn").addEventListener("click", function () {
	  const modal = document.getElementById("task-comment-add-modal");
	  modal.style.display = "block";

	  // 약간의 지연을 두고 초기화
	/* setTimeout(() => {
	    document.getElementById("task-comment-time-add").value = "";
	    //document.getElementById("task-comment-writter-add").value = ""; 지우기 금지
	    document.getElementById("task-comment-title-add").value = "";
	    document.getElementById("task-comment-description-add").value = "";
	    document.getElementById("task-comment-file-add").value = null;
	  }, 10);*/
});

document.getElementById("task-comment-add-btn").addEventListener("click", function () {
	  const newComment = {
	    time: document.getElementById("task-comment-time-add").value,
	    writter: document.getElementById("task-comment-writter-add").value,
	    title: document.getElementById("task-comment-title-add").value,
	    description: document.getElementById("task-comment-description-add").value,
	    file: document.getElementById("task-comment-file-add").value.split("\\").pop() || ""
	  };

	  commentList.push(newComment);
	  renderComments();
	  
	  document.getElementById("task-comment").style.display = "block";
	  document.getElementById("ganttDetail").style.display = "block";
	  document.getElementById("task-comment-add-modal").style.display = "none";
});
document.getElementById("task-comment-add-cancel-btn").addEventListener("click", function () {
	 document.getElementById("task-comment-add-modal").style.display = "none";
});////
 document.getElementById("close-task-edit-panel-btn").addEventListener("click", function () {
	 document.getElementById("task-edit-panel").classList.add('hidden-section');
});

 
// (A) Gantt 편집 패널의 "삭제" 버튼: 멤버 -> 스케줄 순서로 삭제
 // ===========================
 const ganttDeleteBtn = document.querySelector('#task-edit-panel .btn-danger');
 if (ganttDeleteBtn) {
   ganttDeleteBtn.addEventListener('click', async function () {
     if (!selectedSchedule) return;
     if (!confirm("정말로 삭제하시겠습니까?")) return;

     const scheduleId = selectedSchedule.id;

     try {
       // 1) 연관 TaskMember 전부 제거 (replace API로 비우기)
       const repRes = await postJson('/task-member/project/schedule/members/replace', {
         scheduleId: scheduleId,
         members: []      // 전부 비우기
       });
       if (!repRes.ok) throw new Error('멤버 삭제(치환) 실패');

       // 2) 스케줄 삭제
       const delRes = await postJson('/project/schedule/delete', { id: scheduleId });
       if (!delRes.ok) throw new Error('스케줄 삭제 실패');

       alert('스케줄 및 연관 멤버 삭제 완료');

       // UI 정리
       document.getElementById("task-edit-panel")?.classList.add('hidden-section');
       document.getElementById("task-detail-panel")?.style && (document.getElementById("task-detail-panel").style.display = "none");
       selectedTask = null;
       selectedSchedule = null;

       // 새로고침 또는 재렌더
       location.reload(); // 또는 fetchTasksAndRenderGantt();
     } catch (e) {
       console.error(e);
       alert('삭제 중 오류가 발생했습니다.');
     }
   });
 }

 document.getElementById("save-task").addEventListener("click", async function () {
   const name = document.getElementById("task-name").value.trim();
   const start = document.getElementById("task-start").value;
   const end = document.getElementById("task-end").value;
   const description = document.getElementById("task-description").value;

   if (!name || !start || !end) {
     alert("모든 필드를 입력해주세요.");
     return;
   }

   try {
     // 1) 새 scheduleId 만들기
     const maxId = await (await fetch("/project/schedule/max-id")).json();
     const newId = maxId + 1;

     // 2) 스케줄 저장
     const newSchedule = {
       id: newId,
       title: name,
       content: description,
       type: 'PW',
       startDt: start,
       endDt: end,
       color: '#3788d8',
       allDay: true,
       projectId: projectId
     };
     const saveRes = await fetch("/project/schedule/save", {
       method: "POST",
       headers: { "Content-Type": "application/json" },
       body: JSON.stringify(newSchedule)
     });
     if (!saveRes.ok) throw new Error("스케줄 저장 실패");

	 // 3) 선택 멤버를 members로 보내기 (B 방식)
	 const members = Array.from(document.getElementById("form-select").selectedOptions)
	   .map(o => ({
	     userId: o.value,                // 문자열 그대로
	     name: o.textContent.trim()
	   }));

	 const repRes = await fetch('/task-member/project/schedule/members/replace', {
	   method: 'POST',
	   headers: { 'Content-Type': 'application/json' },
	   body: JSON.stringify({ scheduleId: newId, members })
	 });
	 if (!repRes.ok) throw new Error('멤버 저장 실패');


     alert("작업 + 멤버 저장 완료");
     location.reload();
   } catch (err) {
     console.error(err);
     alert("서버 오류: " + err.message);
   } finally {
     closeGanttModal();
   }
 });


//수정-새로고침 안함
// 수정 - 새로고침 없이 반영
document.getElementById("save-task-modify")?.addEventListener("click", async function () {
  const scheduleId =
    (window.selectedSchedule && window.selectedSchedule.id) ??
    (selectedTask && (selectedTask.scheduleId ?? selectedTask.id));

  if (!scheduleId) { alert('스케줄을 먼저 선택하세요.'); return; }

  // 1) 폼값 수집
  const name = document.getElementById("task-name-modify").value.trim();
  const start = document.getElementById("task-start-modify").value;
  const end   = document.getElementById("task-end-modify").value;
  const description = document.getElementById("task-description-modify").value;
  if (!name || !start || !end) { alert("모든 필드를 입력해주세요."); return; }

  const updatedSchedule = {
    id: scheduleId,
    title: name,
    content: description,
    startDt: start,
    endDt: end,
    type: 'PW',
    color: '#3788d8',
    allDay: true,
    projectId: Number(projectId)
  };

  try {
    // 2) 일정 수정
    const res = await fetch("/project/schedule/update", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(updatedSchedule)
    });
    if (!res.ok) throw new Error("스케줄 수정 실패");

    // 3) 멤버 치환
    const updatedMembers = await replaceScheduleMembers(scheduleId, "form-select-modify");
    if (!updatedMembers) throw new Error("멤버 저장 실패");

    // === 여기서부터 UI 즉시 동기화 ===
    // 패널 텍스트
    document.getElementById("detail-title").textContent = name;
    document.getElementById("detail-description").textContent = description;
    document.getElementById("detail-start").textContent = start;
    document.getElementById("detail-end").textContent = end;

    // 상세 콤보 + 오른쪽 이름 텍스트
    const detailSelect = document.getElementById("form-select-detail"); // 모달이라면 id 맞춰 변경
    if (detailSelect) {
      fillSelectWithMembers(detailSelect, updatedMembers);
      renderDetailMemberNames(updatedMembers, '#form-select-detail');
    }

    // 선택 상태 갱신(다음 클릭/갱신에 대비)
    selectedTask = { id: scheduleId, scheduleId, name, description, start, end };
    window.selectedSchedule = { id: scheduleId };

    // Gantt/캘린더 리프레시
    fetchTasksAndRenderGantt();
    if (typeof calendar !== "undefined" && calendar) calendar.refetchEvents();

    // 리렌더 직후 패널 다시 그리기(보장용)
    setTimeout(() => {
      showGanttTaskDetail(selectedTask);
      onTaskChange(selectedTask); // 멤버 선택 재적용
    }, 200);

    // 모달 닫기
    document.getElementById("ganttTaskModalModify").style.display = "none";
    document.getElementById("ganttTaskBackdrop").style.display = "none";

    alert("스케줄 + 멤버 수정 완료");
  } catch (e) {
    console.error(e);
    alert("저장 실패: " + e.message);
  }
});






  document.getElementById("cancel-task").addEventListener("click", closeGanttModal);
  
  // 도우미(한 번만 추가)
  function fillSelectWithMembers(select, members) {
    if (!select) return;
    select.innerHTML = '';
    (members || []).forEach(m => {
      const userId = String(m.userId ?? m.id ?? m).trim();
      const name   = String(m.name   ?? m.userId ?? m).trim();
      select.add(new Option(name, userId, true, true)); // 모두 선택
    });
    select.multiple = true;
    select.size = Math.min(5, Math.max(1, select.options.length));
  }

  
  function getScheduleIdFromTask(task) {
    return (task && (task.scheduleId ?? task.id))
        ?? (window.selectedSchedule && window.selectedSchedule.id)
        ?? null;
  }


  
  let detailLoadToken = 0;

  // 👇 여기 둬
  function onTaskChange(task) {
    const scheduleId = getScheduleIdFromTask(task);
    if (!scheduleId) return;
    loadAndApplyTaskMembers(String(scheduleId).trim());
  }

  
  // 상세 select에 선택 반영(문자열 userId + trim)
  async function loadAndApplyTaskMembers(scheduleId) {
    const res = await fetch(`/task-member/list?scheduleId=${encodeURIComponent(scheduleId)}`, { cache: 'no-store' });
    if (!res.ok) return;
    const list = await res.json();                  // [{userId, name}, ...]
    const memberIds = list.map(m => String(m.userId).trim());

    const sel = document.getElementById('form-select-detail');
    if (!sel) return;
    for (const opt of sel.options) opt.selected = false;

    const want = new Set(memberIds);
    for (const opt of sel.options) {
      if (want.has(String(opt.value).trim())) opt.selected = true;
    }
  }



  
  // (A) 스케줄 멤버 조회
  async function loadTaskMembers(scheduleId) {
    const res = await fetch(`/task-member/list?scheduleId=${encodeURIComponent(scheduleId)}`, { cache: 'no-store' });
    if (!res.ok) throw new Error('loadTaskMembers failed');
    return res.json(); // [{userId, name}, ...]
  }

  function buildIdToNameMap(selectCss = '#form-select-modify') {
    const map = {};
    document.querySelectorAll(`${selectCss} option`).forEach(o => {
      map[String(o.value)] = o.textContent.trim();
    });
    return map;
  }

  // (B) 이름 매핑해서 상세 영역에 그려주는 보조 함수 (이름 변경!)
  function renderDetailMemberNames(members, selectCss = '#form-select-modify') {
    const idToName = {};
    document.querySelectorAll(`${selectCss} option`).forEach(o => {
      idToName[String(o.value)] = o.textContent.trim();
    });
    const names = members.map(m => idToName[String(m.userId)] || String(m.userId));
    document.getElementById('detail-member').textContent = names.join(', ');
  }


  // (C) 저장(치환) 호출 + 응답으로 다시 selected 동기화
  async function replaceScheduleMembers(scheduleId, selectId) {
    const select = document.getElementById(selectId);
    if (!select || !scheduleId) { alert('스케줄을 먼저 선택하세요.'); return; }

    // ✅ 선택된 option에서 [userId, name] 묶어서 보냄
    const members = Array.from(select.selectedOptions).map(opt => ({
      userId: String(opt.value),
      name: opt.textContent.trim()
    }));

    const res = await fetch('/task-member/project/schedule/members/replace', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ scheduleId, members })
    });
    if (!res.ok) { alert('저장 실패'); return; }

    const updated = await res.json(); // [{userId, name}, ...]
    applyMemberSelection(select, updated); // 응답 기준으로 다시 동기화
    return updated;
  }




  
  //보조유틸(작업참여자)
  async function ensureProjectMemberOptions(select, projectId, scheduleId) {
    if (!select) return;
    if (select.options.length > 0 && !select.dataset.needsReload) return;

    // 1) 프로젝트 멤버 시도
    let list = [];
    if (projectId) {
      const r = await fetch(`/project/members?projectId=${encodeURIComponent(projectId)}`, { cache:'no-store' });
      if (r.ok) {
        const text = await r.text();
        if (text) list = JSON.parse(text);
      }
    }

    // 2) 실패/빈 배열이면 스케줄 멤버로 폴백
    if (!Array.isArray(list) || list.length === 0) {
      if (!scheduleId) {
        select.innerHTML = '';
        select.add(new Option('멤버 목록을 불러오지 못했습니다', ''));
        return;
      }
      const r2 = await fetch(`/task-member/list?scheduleId=${encodeURIComponent(scheduleId)}`, { cache:'no-store' });
      list = r2.ok ? await r2.json() : [];
    }

    // 3) 옵션 채우기 (value=userId)
    select.innerHTML = '';
    list.forEach(pm => {
      const userId = String(pm.userId ?? pm.id ?? pm).trim();
      const name   = String(pm.name ?? pm.userId ?? pm).trim();
      select.add(new Option(name, userId));
    });
  }






  function applyMemberSelection(select, members) {
    const ids = new Set(members.map(m => String(m.userId ?? m.id ?? m.name).trim()));
    Array.from(select.options).forEach(o => {
      o.selected = ids.has(String(o.value).trim());
    });
  }

  
  ////////////////////////////////// 간트렌더링
  function fetchTasksAndRenderGantt() {
    //const projectId = document.getElementById("project-id")?.value;
	
	console.log('프로젝트아이디아이디:'+projectId);
    if (!projectId) return;

    fetch(`/project/schedule/gantt?projectId=${projectId}`)
      .then(res => res.json())
      .then(data => {
        const schedules = data
          .map(schedule => {
            const start = schedule.start?.substring(0, 10);
            const end = schedule.end?.substring(0, 10);

            if (!start || !end) return null;

            return {
              id: schedule.id,
              name: schedule.name,
              start: start,
              end: end,
              progress: schedule.progress || 0,
              dependencies: schedule.dependencies || '',
              description: schedule.description || ''
            };
          })
          .filter(item => item !== null);

        // ✅ 기존 인스턴스 제거 + 초기화
        if (ganttInstance) {
          document.querySelector("#gantt-target").innerHTML = '';
          ganttInstance = null;
        }

        // ✅ 새로운 Gantt 인스턴스 생성
        ganttInstance = new Gantt("#gantt-target", schedules, {
          view_mode: 'Week',
          date_format: 'YYYY-MM-DD',
          bar_height: 80,
          padding: 20,
          on_click: function (task) {
			selectedSchedule = { id: getScheduleIdFromTask(task) }; // ✅ 통일
            showGanttTaskDetail(task);
            showGanttTaskEdit(task);
			onTaskChange(task);//추가
			// ✅ 여기 추가
			  setCurrentScheduleForComments(String(selectedSchedule.id).trim());
          }
        });
      })
      .catch(error => {
        console.error("⛔ Gantt 데이터 로딩 실패:", error);
      });
  }




  function closeGanttModal() {
    document.getElementById("ganttTaskModal").style.display = "none";
    document.getElementById("ganttTaskBackdrop").style.display = "none";
    document.getElementById("task-name").value = "";
    document.getElementById("task-start").value = "";
    document.getElementById("task-end").value = "";
  }
  
  document.getElementById("cancel-task-modify").addEventListener("click", closeGanttModalModify);

  function closeGanttModalModify() {
    document.getElementById("ganttTaskModalModify").style.display = "none";
    document.getElementById("ganttTaskBackdrop").style.display = "none";
    document.getElementById("task-name-modify").value = "";
    document.getElementById("task-start-modify").value = "";
    document.getElementById("task-end-modify").value = "";
  }
  // 완전 리셋 유틸 (이전 선택/옵션/상태를 전부 제거)
  function resetSelect(el) {
    const clone = el.cloneNode(false);     // 옵션/값 없이 껍데기만 복제
    clone.id = el.id;
    clone.name = el.name;
    el.parentNode.replaceChild(clone, el); // DOM 교체
    return clone;
  }

  // 비동기라 붙이기 (상세 콤보에는 작업참가자만 표시)


  // ✅ 교체: 프로젝트 멤버 불러오던 줄(ensureProjectMemberOptions) 지우고, 아래처럼
  async function showGanttTaskDetail(task) {
    selectedTask = task;

    document.getElementById("task-edit-title").textContent = task.name || '';
    document.getElementById("detail-description").textContent = task.description || '';
    document.getElementById("detail-start").textContent = task.start || '';
    document.getElementById("detail-end").textContent = task.end || '';
    document.getElementById("task-detail-panel").style.display = "block";

    const scheduleId = (task && (task.scheduleId ?? task.id)) ?? (window.selectedSchedule && window.selectedSchedule.id);
    if (!scheduleId) return;

    let selDetail = document.getElementById("form-select-detail");
    if (!selDetail) return;
    selDetail = resetSelect(selDetail);

    // ⬇ 스케줄 멤버만으로 콤보/텍스트 채우기
    let members = [];
    try {
      const r = await fetch(`/task-member/list?scheduleId=${encodeURIComponent(scheduleId)}`, { cache: 'no-store' });
      if (r.ok) members = await r.json(); // [{userId,name}, ...]
    } catch (e) { console.error(e); }

    fillSelectWithMembers(selDetail, members);                // 콤보
    renderDetailMemberNames(members, '#form-select-detail');  // 오른쪽 텍스트
    selDetail.disabled = true;                                // 읽기전용
	
	// showGanttTaskDetail(...) 안에서 members를 구한 뒤
	toggleAddCommentButton(members);
  }






  function showGanttTaskEdit(task) {
	    selectedTask = task;
	    document.getElementById("detail-title").textContent = task.name;
	    if(document.querySelector(".fa-user-pen").classList.contains("fa-user-pen-edit")){
	    	document.getElementById("task-edit-panel").classList.remove("hidden-section");
	    } 
  }
 



	
	
    let draggedEventInfo = null;
	//캘린더에 일정 드래그시 가져올 정보
    new FullCalendar.Draggable(document.getElementById('fc-external-events'), {
      itemSelector: '.fc-event',
	  eventData: function (eventEl) {
	      const title = eventEl.dataset.title;
	      const color = eventEl.dataset.color;

	      return {
	        title: title,
	        backgroundColor: color,
	        borderColor: color,
	        
	      };
      }
    });
	
	// 모달 닫기 함수
	 function closeModal() {
	    const eventModal = document.getElementById('fc-eventModal');
	    const modalBackdrop = document.getElementById('fc-modalBackdrop');
	    if(eventModal) eventModal.style.display = 'none';
	    if(modalBackdrop) modalBackdrop.style.display = 'none';
	  }
	// date 객체 datetimelocal 로 변환
	function toDatetimeLocal(date) {
	  if (!(date instanceof Date)) return '';
	  
	  const year = date.getFullYear();
	  const month = String(date.getMonth() + 1).padStart(2, '0'); // 0~11
	  const day = String(date.getDate()).padStart(2, '0');
	  const hour = String(date.getHours()).padStart(2, '0');
	  const minute = String(date.getMinutes()).padStart(2, '0');

	  return `${year}-${month}-${day}T${hour}:${minute}`;
	}
	function toDatetimeUTC(date) {
	  if (!(date instanceof Date)) return '';
	  
	  const dtValue = toDatetimeLocal(date);
	  
	  return new Date(dtValue).toISOString().slice(0, 16);
	}
	//시작 날짜 자동 설정 함수
    function setInputDate(datetimeStr) {
   	  const input = document.getElementById('fc-event-start');

   	  // datetime-local 형식은 "YYYY-MM-DDTHH:MM" 이어야 함
   	  const date = new Date(datetimeStr);
   	  

   	  input.value = toDatetimeLocal(date);
   	}

    function handleTrashHover(e) {
   	  const trashEl = document.getElementById("fc-event-trash");
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
	//올데이버그추가
	function toDatetimeLocalString(d) {
	  const pad = n => String(n).padStart(2, '0');
	  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
	}
	
	
	/////모달에선 무조건 데이트인풋을 유티씨로 바꾸기!!!!!!!!!!
	function openEditModal(event) {
	  // 모달에 데이터 채우기
	  document.getElementById('fc-modal-title').value = event.title || '';
	  document.getElementById('fc-modal-description').value = event.extendedProps.description || '';
	  // 현재 선택된 색상 class 제거
	  document.querySelectorAll('.fc-color-circle').forEach(el => {
	    el.classList.remove('selected');
	  });

	  // 현재 event의 색상
	  const currentColor = event.backgroundColor;

	  // 해당 색상에 selected class 추가
	  const selectedColorEl = document.querySelector(`.fc-color-circle[data-color="${currentColor}"]`);
	  if (selectedColorEl) {
	    selectedColorEl.classList.add('selected');
	  }
	  
	  document.getElementById('fc-event-allday').checked = event.allDay;
	  
	  // 시작일 설정 (datetime-local 포맷)
	  ///document.getElementById('fc-event-start').value = toDatetimeLocal(event.start);
	  document.getElementById('fc-event-start').value = toDatetimeUTC(event.start);
	  
	  //// 종료일 설정 (있으면)
	  /////document.getElementById('fc-event-end').value = toDatetimeLocal(event.end);
	  document.getElementById('fc-event-end').value = toDatetimeUTC(event.end);
	  
	  // ✅ 로컬 문자열로 세팅 (UTC 변환 금지)
	    //document.getElementById('fc-event-start').value = toDatetimeLocalString(event.start);
	    //document.getElementById('fc-event-end').value   = event.end ? toDatetimeLocalString(event.end) : '';


	  // 모달 보이기
	  document.getElementById('fc-eventModal').style.display = 'block';
	  document.getElementById('fc-modalBackdrop').style.display = 'block';

	  // 편집 중인 이벤트 저장 (글로벌 변수 등)
	  window.currentEditEvent = event;
	}
    
	// 스케줄 수정 함수 - ✅ 이 블록 전체로 교체
	function updateScheduleEvent(info) {
	  const event = info.event;

	  const updatedData = {
	    id: event.id,
	    title: event.title,
	    content: event.extendedProps.description,
	    type: event.extendedProps.type,
	    startDt: event.start,   // 필요하면 toISOString() 등으로 변환
	    endDt: event.end,
	    color: event.backgroundColor,
	    allDay: event.allDay
	  };

	  $.ajax({
	    url: '/project/schedule/update',
	    type: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(updatedData),
	    success: function () {
	      console.log('업데이트 성공');
	    },
	    error: function () {
	      alert('일정 업데이트 실패');
	      info.revert();
	    }
	  });
	}

	// (B) 캘린더 이벤트를 휴지통으로 드래그해 삭제하는 경우: 멤버 -> 스케줄 순서
	  // ===========================
	  // 아래 핸들러는 기존 calendar 설정 안의 eventDragStop 를 교체하세요.
	  // (캘린더 객체 생성 직후에 붙었던 기존 eventDragStop 로직을 이 블록으로 교체)
	  function attachEventDragStopForTrash(calendar) {
	    calendar.setOption('eventDragStop', function (info) {
	      document.removeEventListener("mousemove", handleTrashHover);

	      const trashEl = document.getElementById("fc-event-trash");
	      if (!trashEl) return;

	      const trashRect = trashEl.getBoundingClientRect();
	      const x = info.jsEvent.clientX;
	      const y = info.jsEvent.clientY;

	      const inTrash =
	        x >= trashRect.left &&
	        x <= trashRect.right &&
	        y >= trashRect.top &&
	        y <= trashRect.bottom;

	      trashEl.classList.remove("hovered");

	      if (!inTrash) return;

	      if (!confirm("일정을 삭제하시겠습니까?")) {
	        info.revert();
	        return;
	      }

	      const scheduleId = info.event.id;

	      // 먼저 UI에서 제거 (낙관적), 실패 시 알림만
	      info.event.remove();

		  // 1) task-member 비우기 → 2) schedule 삭제
		  postJson('/task-member/project/schedule/members/replace', {
		    scheduleId,
		    members: []   // ✅ B방식: 비울 때도 members 키를 사용
		  })
		    .then(repRes => {
		      if (!repRes.ok) throw new Error('멤버 삭제(치환) 실패');
		      return postJson('/project/schedule/delete', { id: scheduleId });
		    })
		    .then(delRes => {
		      if (!delRes.ok) throw new Error('스케줄 삭제 실패');
		      // 필요하면 calendar.refetchEvents();
		    })
		    .catch(err => {
		      console.error(err);
		      alert('삭제 중 오류가 발생했습니다.');
		      // calendar.refetchEvents();
		    });

	    });
	  }

	  // ===========================
	  // (C) 기존 캘린더 생성 코드 이후에 위 로직 삽입
	  // ===========================
	  // 네가 만들었던 FullCalendar 인스턴스를 calendar 라고 했으므로, 생성 뒤에 아래를 호출
	  // calendar.render(); 앞/뒤 어느 쪽이든 setOption은 즉시 반영됨.
	 
    const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
	  timeZone: 'UTC',
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,timeGridDay'
      },
      // 편집 가능 여부
      droppable: false,
      editable: false, // 편집 가능 여부
	  selectable: false,
	  eventStartEditable: false,
      eventDurationEditable: false,
      events: `/project/schedule/events?projectId=${projectId}`, //초기 설정 일정
      eventDisplay: 'block',
	  
      
	  //캘린더에 일정 드래그앤 드롭시
      eventReceive: function(info) {
		  
        draggedEventInfo = info;
        // 드롭한 날짜 시작날짜로 설정
        const droppedDate = info.event.startStr;
        setInputDate(droppedDate);
		
		info.event.remove();
        
        //새로운 데이터 입력을 위한 다른 데이터 초기화
		document.getElementById('fc-modal-id').value = null;
		
        document.getElementById('fc-modal-title').value = '';
        document.getElementById('fc-modal-description').value = '';
        document.getElementById('fc-modal-color').value = '#007bff';
		document.getElementById('fc-event-end').value = null;

        document.querySelectorAll('.fc-color-circle').forEach(c => c.classList.remove('selected'));
        document.querySelector('.fc-color-circle[data-color="#007bff"]').classList.add('selected');

        document.getElementById('fc-eventModal').style.display = 'block';
        document.getElementById('fc-modalBackdrop').style.display = 'block';
      },
	  //캘린더의 일정 클릭시
      eventClick: function(info) {
		const id = info.event.id;
        const event = info.event;
        const title = event.title || '제목 없음';
        const description = event.extendedProps.description || '설명 없음';
        console.log(event);
        document.getElementById('fc-event-title').textContent = title;
        document.getElementById('fc-event-description').textContent = description;
        document.getElementById('fc-event-details').style.display = 'block';
		document.getElementById('fc-modal-id').value = id;
		
		// ✅ 이렇게
		 const scheduleId = String(id).trim();
		 onTaskChange({ id: scheduleId, scheduleId });
		 
		 // ✅ 댓글 등록용 스케줄 ID 세팅 (이 한 줄 추가)
		   setCurrentScheduleForComments(scheduleId);
		
		if(!isEditMode) return;
		
		openEditModal(event);
      },
      eventDragStart: function(info) {
    	  document.addEventListener("mousemove", handleTrashHover);
      },
	  // ❌ 기존 eventDragStop 는 완전히 제거 (여기 넣지 말기)
     /* eventDragStop: function(info) {
   	    document.removeEventListener("mousemove", handleTrashHover);
   	    const trashEl = document.getElementById("fc-event-trash");
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
	   	},*/
    	
    	eventDrop: function(info) {
   		  updateScheduleEvent(info);
   		},
   		
   		eventResize: function(info) {
		  updateScheduleEvent(info);
   		}
   		

  	  });
    
	//////밑에거 쓰기
    //일정 추가 완료
    /*document.getElementById('fc-save-event').addEventListener('click', function() {
   	  const title = document.getElementById('fc-modal-title').value.trim();
   	  const desc = document.getElementById('fc-modal-description').value.trim();
   	  const color = document.getElementById('fc-modal-color').value;
   	  //const start = document.getElementById('fc-event-start').value;
	  const start = new Date(document.getElementById('fc-event-start').value).toISOString().slice(0, 16) + 'Z'; 
   	  //const end = document.getElementById('fc-event-end').value;
	  //const end = new Date(document.getElementById('fc-event-end').value).toISOString().slice(0, 16) + 'Z';
	  let end = null; // 기본값 (없으면 null 전송)

	  const endEl = document.getElementById('fc-event-end');
	  if (endEl && endEl.value.trim() !== '') {
	    const d = new Date(endEl.value);              // 'YYYY-MM-DDTHH:MM' (로컬) → Date
	    if (!Number.isNaN(d.getTime())) {             // 유효성 체크
	      end = d.toISOString().slice(0, 16) + 'Z';   // → 'YYYY-MM-DDTHH:MMZ' (UTC)
	    }
	  }

   	  const alldayCheckbox = document.getElementById('fc-event-allday');
	  const id = document.getElementById('fc-modal-id').value;
   	  
	  const url = id ? '/project/schedule/update' : '/project/schedule/save';
	  
	  console.log(id);
	  
      if (!title) {
        alert('제목을 입력해주세요.');
        return;
      }
      const allDay = alldayCheckbox.checked;

	  console.log(start);
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
		id: id,
        title: title,
        content: desc,
        type: type,
        startDt: startDt,
        endDt: endDt,
        color: color,
        allDay: allDay,
		
		projectId: projectId
      };
      
      $.ajax({
    	    url: url,
    	    type: 'POST',
    	    contentType: 'application/json',
    	    data: JSON.stringify(scheduleData),
    	    success: function () {
    	      alert('저장 완료');
    	      calendar.refetchEvents();
    	    },
    	    error: function () {
    	      alert('저장 실패');
    	    }
    	  });

      closeModal();
    });*/
	
	///////////올데이는 문자로, 아닐때는 유티씨로 
	document.getElementById('fc-save-event').addEventListener('click', function () {
	  const title = document.getElementById('fc-modal-title').value.trim();
	  const desc  = document.getElementById('fc-modal-description').value.trim();
	  const color = document.getElementById('fc-modal-color').value;

	  const startInput = document.getElementById('fc-event-start').value; // 'YYYY-MM-DDTHH:MM'
	  const endInput   = document.getElementById('fc-event-end').value;   // (없을 수 있음)

	  const alldayCheckbox = document.getElementById('fc-event-allday');
	  const id   = document.getElementById('fc-modal-id').value;

	  if (!title) { alert('제목을 입력해주세요.'); return; }

	  let startDt, endDt;
	  if (alldayCheckbox.checked) {
	    // ✅ 올데이는 날짜만! (로컬 값을 그대로 사용)
	    startDt = startInput.slice(0, 10);                 // 'YYYY-MM-DD'
	    endDt   = endInput ? endInput.slice(0, 10) : null; // 'YYYY-MM-DD' | null
	  } else {
	    // ✅ 시간 있는 일정만 UTC(Z)로 보냄
	    startDt = new Date(startInput).toISOString().slice(0, 16) + 'Z';
	    endDt   = endInput ? new Date(endInput).toISOString().slice(0, 16) + 'Z' : null;
	  }

	  const scheduleData = {
	    id,
	    title,
	    content: desc,
	    type: alldayCheckbox.checked ? alldayCheckbox.value : '',
	    startDt,
	    endDt,
	    color,
	    allDay: alldayCheckbox.checked,
	    projectId
	  };

	  $.ajax({
	    url: id ? '/project/schedule/update' : '/project/schedule/save',
	    type: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(scheduleData),
	    success: function () { alert('저장 완료'); calendar.refetchEvents(); },
	    error: function () { alert('저장 실패'); }
	  });

	  closeModal();
	});


    //일정 생성 취소
    document.getElementById('fc-cancel-event').addEventListener('click', function() {
      if (draggedEventInfo) {
        draggedEventInfo.event.remove();
      }
      closeModal();
    });

	// 기존 옵션으로 calendar 생성한 "바로 다음 줄"에 추가
	attachEventDragStopForTrash(calendar);
	
    calendar.render();
	

    //일정 추가시 색상 저장
    document.querySelectorAll('.fc-color-circle').forEach(circle => {
      circle.addEventListener('click', function () {
        document.querySelectorAll('.fc-color-circle').forEach(c => c.classList.remove('selected'));
        this.classList.add('selected');
        document.getElementById('fc-modal-color').value = this.dataset.color;
      });
    });
	
	/*-----*/
	document.getElementById('fc-details-close').addEventListener('click', function () {
	  document.getElementById('fc-event-details').style.display = 'none';
	});

	document.getElementById('toggle-edit-mode').addEventListener('click', function () {
	    isEditMode = !isEditMode;

	    // 버튼 텍스트와 스타일 변경
	    this.textContent = isEditMode ? '편집 모드 끄기' : '편집 모드 켜기';
	    this.classList.toggle('btn-outline-danger', !isEditMode);
	    this.classList.toggle('btn-success', isEditMode);

	    // 캘린더 편집 가능 여부 설정
	    calendar.setOption('editable', isEditMode);       // 드래그, 리사이징
	    calendar.setOption('selectable', isEditMode);     // 날짜 선택 가능 여부
		calendar.setOption('droppable', isEditMode);
	    calendar.setOption('eventStartEditable', isEditMode);
	    calendar.setOption('eventDurationEditable', isEditMode);
	    
	    // 외부 이벤트 드래그 허용 여부
	    calendar.setOption('droppable', isEditMode);

	    // 삭제 div 표시 여부 (ex. 휴지통)
		// 외부 이벤트와 휴지통 표시 전환
		    document.getElementById('fc-external-events').style.display = isEditMode ? 'block' : 'none';
			document.getElementById('fc-trash-area').style.display = isEditMode ? 'block' : 'none';
			
			document.body.classList.toggle('fc-edit-mode', isEditMode);
			

			
			// 👉 Gantt가 보이는 상태라면 패널 표시/숨김
			const taskeditpanel = document.getElementById('task-edit-panel');
			const taskdetailpanel = document.getElementById('task-detail-panel');
			const isGanttVisible = !document.getElementById("gantt").classList.contains("hidden-section");

			if (this.classList.contains("btn-success")) {
			  if (isGanttVisible) {
			    taskeditpanel.classList.remove('hidden-section');
			    taskdetailpanel.classList.remove('hidden-section');
				
			  }
			} else {
			  taskeditpanel.classList.add('hidden-section');
			  
			}

	});

  });
  //////////////////////////////커멘트
  document.addEventListener('DOMContentLoaded', function () {
    // ====== 공통 유틸 ======
	/* function postJson(url, payload) {
      return fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: payload ? JSON.stringify(payload) : null
      });
    }*/
    function escapeHtml(s = '') {
      return String(s)
        .replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;')
        .replaceAll('"','&quot;').replaceAll("'", '&#39;');
    }

    // ====== 상태 ======
    let currentScheduleId = null;  // 현재 상세보기 중인 스케줄 ID
    let currentComments = [];      // 마지막으로 로드된 코멘트 목록

    window.setCurrentScheduleForComments = function(scheduleId) {
      currentScheduleId = scheduleId;
      loadAndRenderComments();
    };

    // ====== 로드 & 렌더 ======
    async function loadAndRenderComments(order = '최신순') {
      if (!currentScheduleId) return;
      try {
        const res = await fetch(`/task-comment/list?scheduleId=${currentScheduleId}`);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const list = await res.json();
        currentComments = Array.isArray(list) ? list : [];

        // 정렬
        currentComments.sort((a, b) => {
          const ta = new Date(a.writeTime).getTime();
          const tb = new Date(b.writeTime).getTime();
          return order === '등록순' ? (ta - tb) : (tb - ta);
        });

        renderComments(currentComments);
      } catch (e) {
        console.error('댓글 로드 실패:', e);
        document.getElementById('task-comment').innerHTML =
          `<div class="text-danger">댓글 로드 실패</div>`;
      }
    }

	


    // ====== 정렬 셀렉트 ======
    const orderSel = document.getElementById('comment-orderby');
    if (orderSel) {
      orderSel.addEventListener('change', () => {
        const selected = orderSel.value;
        if (currentComments.length) {
          currentComments.sort((a, b) => {
            const ta = new Date(a.writeTime).getTime();
            const tb = new Date(b.writeTime).getTime();
            return selected === '등록순' ? (ta - tb) : (tb - ta);
          });
          renderComments(currentComments);
        } else {
          loadAndRenderComments(selected);
        }
      });
    }

    // ====== 등록 모달 열기/닫기 ======
	function setTodayDateTime() {
	  const now = new Date();
	  const pad = n => String(n).padStart(2, '0');
	  const today = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}T${pad(now.getHours())}:${pad(now.getMinutes())}`;
	  document.getElementById('task-comment-time-add').value = today;
	}
	// 모달 "등록하러가기" 버튼 클릭 시 날짜 세팅
	document.getElementById('open-add-comment-btn').addEventListener('click', function () {
	  setTodayDateTime(); // 현재 시각 세팅
	  document.getElementById('task-comment-add-modal').style.display = 'block';
	});
    const openAddBtn = document.getElementById('open-add-comment-btn');
    const addModal   = document.getElementById('task-comment-add-modal');
    const addBackdrop= document.getElementById('fc-modalBackdrop');

	function openAddCommentModal() {
	  if (!currentScheduleId) { alert('스케줄을 먼저 선택하세요.'); return; }
	  setTodayDateTime();                        // ✅ 여기서만 세팅
	  const loginUser = document.getElementById('login-user')?.value || '';
	  document.getElementById('task-comment-writter-add').value = loginUser; // 서버 바인딩 유지
	  document.getElementById('task-comment-title-add').value = '';
	  document.getElementById('task-comment-description-add').value = '';
	  document.getElementById('task-comment-file-add').value = '';
	  addModal.style.display = 'block';
	  if (addBackdrop) addBackdrop.style.display = 'block';
	}

    function closeAddCommentModal() {
      addModal.style.display = 'none';
      if (addBackdrop) addBackdrop.style.display = 'none';
    }
    if (openAddBtn) openAddBtn.addEventListener('click', openAddCommentModal);

    const addCancelBtn = document.getElementById('task-comment-add-cancel-btn');
    if (addCancelBtn) addCancelBtn.addEventListener('click', closeAddCommentModal);

    // ====== 등록 요청 ======
	document.getElementById('task-comment-add-btn').addEventListener('click', async () => {
	  if (!currentScheduleId) { alert('스케줄을 먼저 선택하세요.'); return; }

	  const userId = document.getElementById('login-user')?.value || '';
	  if (!userId) { alert('로그인이 필요합니다.'); return; }

	  const title = document.getElementById('task-comment-title-add').value.trim();
	  const description = document.getElementById('task-comment-description-add').value.trim();
	  const fileInput = document.getElementById('task-comment-file-add');
	  const filePath = fileInput && fileInput.files[0] ? fileInput.files[0].name : '';

	  if (!title) { alert('제목을 입력하세요.'); return; }

	  try {
	    const res = await postJson('/task-comment/add', {
	      scheduleId: currentScheduleId,
	      userId,               // ✅ 이것 때문에 1400 에러가 사라짐
	      title,
	      description,
	      filePath
	    });
	    if (!res.ok) throw new Error(`HTTP ${res.status}`);
	    closeAddCommentModal();
	    const selected = document.getElementById('comment-orderby')?.value || '최신순';
	    await loadAndRenderComments(selected);
	  } catch (e) {
	    console.error('댓글 등록 실패:', e);
	    alert('등록에 실패했습니다.');
	  }
	});


    // ====== 삭제 ======
	const commentBox = document.getElementById('task-comment');

	commentBox.addEventListener('click', async (e) => {
	  const card = e.target.closest('[data-comment-id]');
	  if (!card) return;

	  const view = card.querySelector('.view-area');
	  const edit = card.querySelector('.edit-area');
	  const btnEdit   = card.querySelector('[data-action="edit"]');
	  const btnSave   = card.querySelector('[data-action="save"]');
	  const btnCancel = card.querySelector('[data-action="cancel"]');

	  // 편집
	  if (e.target.matches('[data-action="edit"]')) {
	    view.classList.add('d-none');
	    edit.classList.remove('d-none');
	    btnEdit.classList.add('d-none');
	    btnSave.classList.remove('d-none');
	    btnCancel.classList.remove('d-none');
	    return;
	  }

	  // 취소 (리셋: 다시 로드해서 원복)
	  if (e.target.matches('[data-action="cancel"]')) {
	    const order = document.getElementById('comment-orderby')?.value || '최신순';
	    await loadAndRenderComments(order);
	    return;
	  }

	  // 저장
	  if (e.target.matches('[data-action="save"]')) {
	    const id = card.dataset.commentId;
	    const title = edit.querySelector('input[name="title"]').value.trim();
	    const desc  = edit.querySelector('textarea[name="desc"]').value.trim();
	    const fileInput = edit.querySelector('input[name="file"]');
	    const filePath  = fileInput.files[0]?.name || undefined; // 파일 선택 안 하면 undefined로 보내서 유지

	    if (!title) { alert('제목을 입력하세요.'); return; }

	    // 서버로 업데이트
	    const payload = { id, title, description: desc };
	    if (filePath !== undefined) payload.filePath = filePath;

	    try {
	      const res = await postJson('/task-comment/update', payload);
	      if (!res.ok) throw new Error(`HTTP ${res.status}`);
	      // 성공 후 목록 새로고침
	      const order = document.getElementById('comment-orderby')?.value || '최신순';
	      await loadAndRenderComments(order);
	    } catch (err) {
	      console.error(err);
	      alert('수정에 실패했습니다.');
	    }
	    return;
	  }

	  // 삭제 (이미 구현되어 있으면 그대로 두세요)
	  if (e.target.matches('[data-action="delete"]')) {
		const id = card.dataset.commentId;
		 if (!id) return;

		 if (!confirm('정말 삭제하시겠습니까?')) return;

		 // 더블클릭 방지
		 e.target.disabled = true;

		 try {
		   // (A) 쿼리스트링으로 id 전달 (지금 너 코드 스타일)
		   const res = await postJson(`/task-comment/delete?id=${encodeURIComponent(id)}`, null);

		   // (B) 만약 서버가 body로 받게 되어 있으면 아래로 교체
		   // const res = await postJson('/task-comment/delete', { id });

		   if (!res.ok) throw new Error(`HTTP ${res.status}`);

		   // 성공 시 목록 새로고침 (정렬 유지)
		   const order = document.getElementById('comment-orderby')?.value || '최신순';
		   await loadAndRenderComments(order);
		 } catch (err) {
		   console.error('삭제 실패:', err);
		   alert('삭제에 실패했습니다.');
		   e.target.disabled = false; // 실패 시 원복
		 }
		 return;
	  }
	});

  });

