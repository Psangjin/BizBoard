document.addEventListener('DOMContentLoaded', function () {
	renderComments();  // ⬅ 이걸 꼭 추가
  let draggedEventInfo = null;
  let selectedTask = null;
  let tasks = [
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
  ];
  let ganttInstance = null;
  let showingCalendar = true;

  // 외부 이벤트 드래그 설정
  new FullCalendar.Draggable(document.getElementById('external-events'), {
    itemSelector: '.fc-event',
    eventData: function (eventEl) {
      const color = eventEl.dataset.color;
      return {
        title: eventEl.dataset.title,
        backgroundColor: color,
        borderColor: color,
        extendedProps: {
          typecolor: color,
          description: eventEl.dataset.description || ''
        }
      };
    }
  });

  // FullCalendar 초기화
  const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
    initialView: 'dayGridMonth',
    headerToolbar: {
      left: 'prevYear,prev,next,nextYear today',
      center: 'title',
      right: 'dayGridMonth,dayGridWeek,timeGridDay'
    },
    droppable: true,
    editable: true,
    events: [],
    eventReceive: function (info) {
      draggedEventInfo = info;
      document.getElementById('modal-title').value = '';
      document.getElementById('modal-description').value = '';
      document.getElementById('eventModal').style.display = 'block';
      document.getElementById('modalBackdrop').style.display = 'block';
    },
    eventClick: function (info) {
      const event = info.event;
      document.getElementById('event-title').textContent = event.title || '제목 없음';
      document.getElementById('event-description').textContent = event.extendedProps.description || '설명 없음';
      document.getElementById('event-details').style.display = 'block';
    }
  });

  calendar.render();

  // 일정 저장
  document.getElementById('save-event').addEventListener('click', function () {
    const title = document.getElementById('modal-title').value.trim();
    const desc = document.getElementById('modal-description').value.trim();
    if (!title) {
      alert('제목을 입력해주세요.');
      return;
    }
    if (draggedEventInfo) {
      draggedEventInfo.event.setProp('title', title);
      draggedEventInfo.event.setExtendedProp('description', desc);
      const color = draggedEventInfo.event.extendedProps.typecolor;
      if (color) {
        draggedEventInfo.event.setProp('backgroundColor', color);
        draggedEventInfo.event.setProp('borderColor', color);
      }
    }
    closeModal();
  });

  document.getElementById('cancel-event').addEventListener('click', function () {
    if (draggedEventInfo) {
      draggedEventInfo.event.remove();
    }
    closeModal();
  });

  function closeModal() {
    document.getElementById('eventModal').style.display = 'none';
    document.getElementById('modalBackdrop').style.display = 'none';
    draggedEventInfo = null;
  }

  // 사이드바 토글
  document.getElementById('toggleSidebar').addEventListener('click', function () {
    const sidebar = document.querySelector('.body-side-menubar');
    sidebar.classList.toggle('hidden');
  });
// 간트 스크립트 시작 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Gantt Toggle
  document.querySelector('.fa-arrow-right-arrow-left').addEventListener('click', function () {
	const eventdetails = document.getElementById('event-details');
    const calendarEl = document.getElementById('calendar');
    const ganttWrapper = document.getElementById('gantt');
    const dragevent = document.getElementById('external-events');
    const taskdetailpanel = document.getElementById('task-detail-panel');
    const taskeditpanel = document.getElementById('task-edit-panel');
    document.getElementById('task-edit-title').textContent="";
    document.getElementById('detail-title').textContent="";

    if (showingCalendar) {
      if(eventdetails.style.display!=="none")eventdetails.style.display="none";
      dragevent.classList.add('hidden-section');
      calendarEl.classList.add('hidden-section');
      ganttWrapper.classList.remove('hidden-section');
      if(document.querySelector(".fa-user-pen").classList.contains("fa-user-pen-edit")){
	    	document.getElementById("task-edit-panel").classList.remove("hidden-section");
	    }
		taskdetailpanel.classList.remove('hidden-section');
      if (!ganttInstance) {
        ganttInstance = new Gantt("#gantt-target", tasks, {
          bar_height: 80,
          padding: 20,
          view_mode: 'Week',
          on_click: function(task){
        	  showGanttTaskDetail(task);
        	  showGanttTaskEdit(task);
          }
        });
      }
    } else {
      dragevent.classList.remove('hidden-section');
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

  document.getElementById("open-modify-task").addEventListener("click", function () {
    if (!selectedTask) return;
    document.getElementById("ganttTaskModalModify").style.display = "block";
    document.getElementById("ganttTaskBackdrop").style.display = "block";
    document.getElementById("task-name-modify").value = selectedTask.name;
    document.getElementById("task-description-modify").value = selectedTask.description;
    document.getElementById("task-start-modify").value = selectedTask.start;
    document.getElementById("task-end-modify").value = selectedTask.end;
    const mem = document.getElementById("form-select-modify");
    for (const option of mem.options) {
      option.selected = selectedTask.member.includes(option.value);
    }
  });/////////
  
  document.getElementById("open-ganttDetail").addEventListener("click", function () {
	    if (!selectedTask) return;
	    document.getElementById("ganttDetail").style.display = "block";
	    document.getElementById("ganttTaskBackdrop").style.display = "block";
	    document.getElementById("task-name-detail").value = selectedTask.name;
	    document.getElementById("task-description-detail").value = selectedTask.description;
	    document.getElementById("task-start-detail").value = selectedTask.start;
	    document.getElementById("task-end-detail").value = selectedTask.end;
	    const mem = document.getElementById("form-select-detail");
	    for (const option of mem.options) {
	      option.selected = selectedTask.member.includes(option.value);
	    }
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
	  setTimeout(() => {
	    document.getElementById("task-comment-time-add").value = "";
	    document.getElementById("task-comment-writter-add").value = "";
	    document.getElementById("task-comment-title-add").value = "";
	    document.getElementById("task-comment-description-add").value = "";
	    document.getElementById("task-comment-file-add").value = null;
	  }, 10);
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
 document.querySelector(".fa-user-pen").addEventListener("click", function () {
	 document.querySelector(".fa-user-pen").classList.toggle('fa-user-pen-edit');
	 if(document.querySelector(".fa-user-pen").classList.contains("fa-user-pen-edit")&&!showingCalendar){
	    	document.getElementById("task-edit-panel").classList.remove("hidden-section");
	  }
	 else{
		 document.getElementById("task-edit-panel").classList.add("hidden-section");
	 }
});
 
//작업 삭제 버튼 클릭 처리
 document.querySelector('#task-edit-panel .btn-danger').addEventListener('click', function () {
   if (!selectedTask) return;

   const confirmed = confirm("정말로 삭제하시겠습니까?");
   if (!confirmed) return;

   // tasks 배열에서 삭제
   tasks = tasks.filter(task => task.id !== selectedTask.id);

   // Gantt 다시 렌더링
   ganttInstance.refresh(tasks);

   // 패널 닫기
   document.getElementById("task-edit-panel").classList.add('hidden-section');
   document.getElementById("task-detail-panel").style.display = "none";

   // 선택된 작업 초기화
   selectedTask = null;
 });

 document.getElementById("save-task").addEventListener("click", function () {
    const name = document.getElementById("task-name").value.trim();
    const start = document.getElementById("task-start").value;
    const end = document.getElementById("task-end").value;
    const description = document.getElementById("task-description").value;
    const selected = Array.from(document.getElementById("form-select").selectedOptions).map(opt => opt.value);

    if (!name || !start || !end) {
      alert("모든 필드를 입력해주세요.");
      return;
    }

    const newTask = {
      description,
      member: selected,
      id: 'Task ' + (tasks.length + 1),
      name,
      start,
      end,
      progress: 0,
      dependencies: ""
    };

    tasks.push(newTask);
    ganttInstance?.refresh(tasks);
    closeGanttModal();
  });
 document.getElementById("save-task-modify").addEventListener("click", function () {
	  if (!selectedTask) return;

	  const name = document.getElementById("task-name-modify").value.trim();
	  const start = document.getElementById("task-start-modify").value;
	  const end = document.getElementById("task-end-modify").value;
	  const description = document.getElementById("task-description-modify").value;
	  const selected = Array.from(document.getElementById("form-select-modify").selectedOptions).map(opt => opt.value);

	  if (!name || !start || !end) {
	    alert("모든 필드를 입력해주세요.");
	    return;
	  }

	  selectedTask.name = name;
	  selectedTask.start = start;
	  selectedTask.end = end;
	  selectedTask.description = description;
	  selectedTask.member = selected;

	  // 간트차트 갱신
	  ganttInstance.refresh(tasks);
	  
	  
	  document.getElementById("task-edit-title").textContent = name;
	  

	  // 디테일 패널도 갱신
	  document.getElementById("detail-title").textContent = name;
	  document.getElementById("detail-description").textContent = description;
	  document.getElementById("detail-member").textContent = selected.join(', ');
	  document.getElementById("detail-start").textContent = start;
	  document.getElementById("detail-end").textContent = end;

	  closeGanttModalModify();
	});



  document.getElementById("cancel-task").addEventListener("click", closeGanttModal);

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

  function showGanttTaskDetail(task) {
    selectedTask = task;
    document.getElementById("task-edit-title").textContent = task.name;
    document.getElementById("detail-description").textContent = task.description;
    document.getElementById("detail-member").textContent = task.member?.join(', ') || '';
    document.getElementById("detail-start").textContent = task.start;
    document.getElementById("detail-end").textContent = task.end;
    document.getElementById("detail-progress").textContent = task.progress;
    document.getElementById("task-detail-panel").style.display = "block";
  }
  function showGanttTaskEdit(task) {
	    selectedTask = task;
	    document.getElementById("detail-title").textContent = task.name;
	    if(document.querySelector(".fa-user-pen").classList.contains("fa-user-pen-edit")){
	    	document.getElementById("task-edit-panel").classList.remove("hidden-section");
	    } 
  }
  function renderComments() {
	  const container = document.getElementById('task-comment');
	  container.innerHTML = ''; // 기존 댓글 초기화

	  commentList.forEach((comment, index) => {
	    const row = document.createElement('div');
	    row.className = 'comment-row';

	    // 편집 버튼
	    const editBtn = document.createElement('button');
	    editBtn.className = 'comment-edit-btn btn btn-secondary';
	    editBtn.textContent = '편집';

	    // 수정/취소/삭제 버튼 영역
	    const btnArea = document.createElement('div');
	    btnArea.className = 'comment-modify-btn-area';

	    const cancelBtn = document.createElement('button');
	    cancelBtn.className = 'comment-modify-cancel-btn btn btn-secondary hidden-section';
	    cancelBtn.textContent = '취소하기';

	    const deleteBtn = document.createElement('button');
	    deleteBtn.className = 'comment-delete-btn btn btn-danger hidden-section';
	    deleteBtn.textContent = '삭제하기';

	    const modifyBtn = document.createElement('button');
	    modifyBtn.className = 'comment-modify-btn btn btn-warning hidden-section';
	    modifyBtn.textContent = '수정하기';

	    btnArea.append(cancelBtn, deleteBtn, modifyBtn);

	    const fields = [
	      { label: '커멘트 날짜일시', class: 'task-comment-time', value: comment.time },
	      { label: '커멘트 작성자', class: 'task-comment-writter', value: comment.writter },
	      { label: '커멘트 제목', class: 'task-comment-title', value: comment.title },
	      { label: '커멘트 설명', class: 'task-comment-description', value: comment.description },
	      { label: '커멘트 파일', class: 'task-comment-file', value: comment.file }
	    ];

	    const inputArea = document.createElement('div');
	    inputArea.className = 'comment-input-area';

	    fields.forEach((f, fieldIndex) => {
	      const fieldDiv = document.createElement('div');
	      fieldDiv.className = 'comment-field';

	      const label = document.createElement('label');
	      label.textContent = f.label + ':';

	      if (f.class === 'task-comment-file') {
	        const fileWrapper = document.createElement('div');
	        fileWrapper.style.display = 'flex';
	        fileWrapper.style.alignItems = 'center';
	        fileWrapper.style.gap = '8px';

	        const inputId = `commentFile-${index}`;

	        const fileInput = document.createElement('input');
	        fileInput.type = 'file';
	        fileInput.className = 'task-comment-file-modify';
	        fileInput.style.display = 'none';
	        fileInput.id = inputId;
	        
	     // ✅ 선택 시 파일명 갱신 로직 추가
	        fileInput.addEventListener('change', function () {
	          const selectedFile = fileInput.files[0];
	          if (selectedFile) {
	            fileText.textContent = selectedFile.name;
	          } else {
	            fileText.textContent = '없음';
	          }
	        });

	        const fileLabel = document.createElement('label');
	        fileLabel.setAttribute('for', inputId);
	        fileLabel.style.cursor = 'pointer';
	        fileLabel.classList.add('file-disabled');  // ✅ 초기 비활성화

	        const icon = document.createElement('i');
	        icon.className = 'fas fa-paperclip';
	        icon.style.color = '#007bff';
	        icon.title = '파일 선택';

	        fileLabel.appendChild(icon);

	        const fileText = document.createElement('span');
	        fileText.textContent = f.value || '없음';

	        fileWrapper.appendChild(fileLabel);
	        fileWrapper.appendChild(fileText);

	        label.appendChild(fileWrapper);
	        fieldDiv.appendChild(label);
	        fieldDiv.appendChild(fileInput);

	      } else {
	        const input = document.createElement('input');
	        input.type = 'text';
	        input.className = f.class;
	        input.value = f.value || '';
	        input.readOnly = true;

	        label.appendChild(input);
	        fieldDiv.appendChild(label);
	      }

	      inputArea.appendChild(fieldDiv);
	    });

	    // 편집 버튼
	    editBtn.addEventListener('click', () => {
	      inputArea.querySelectorAll('input').forEach(input => {
	        input.removeAttribute('readonly');
	        input.removeAttribute('disabled');
	      });

	      inputArea.querySelectorAll('label[for^="commentFile-"]').forEach(label => {
	        label.classList.remove('file-disabled'); // ✅ 클릭 허용
	      });

	      editBtn.classList.add('hidden-section');
	      modifyBtn.classList.remove('hidden-section');
	      cancelBtn.classList.remove('hidden-section');
	      deleteBtn.classList.remove('hidden-section');
	    });

	    // 수정 완료 버튼
	    modifyBtn.addEventListener('click', () => {
	      inputArea.querySelectorAll('input[type="text"]').forEach(input => {
	        input.setAttribute('readonly', 'readonly');
	      });

	      inputArea.querySelectorAll('label[for^="commentFile-"]').forEach(label => {
	        label.classList.add('file-disabled'); // ✅ 다시 클릭 막기
	      });

	      editBtn.classList.remove('hidden-section');
	      modifyBtn.classList.add('hidden-section');
	      cancelBtn.classList.add('hidden-section');
	      deleteBtn.classList.add('hidden-section');
	    });

	    // 취소 버튼
	    cancelBtn.addEventListener('click', () => {
	      inputArea.querySelectorAll('input[type="text"]').forEach(input => {
	        input.setAttribute('readonly', 'readonly');
	      });

	      inputArea.querySelectorAll('label[for^="commentFile-"]').forEach(label => {
	        label.classList.add('file-disabled'); // ✅ 다시 클릭 막기
	      });

	      editBtn.classList.remove('hidden-section');
	      modifyBtn.classList.add('hidden-section');
	      cancelBtn.classList.add('hidden-section');
	      deleteBtn.classList.add('hidden-section');
	    });

	    // 삭제 버튼
	    deleteBtn.addEventListener('click', () => {
	      commentList.splice(index, 1);
	      row.remove();
	    });

	    row.appendChild(editBtn);
	    row.appendChild(inputArea);
	    row.appendChild(btnArea);
	    container.appendChild(row);
	  });
	}




  // 간트 끝!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  // 메뉴 아이콘 이동
  document.getElementById('fa-project-icon')?.addEventListener('click', function () {
    location.href = "/project/main";
  });

  document.getElementById('fa-calendar-icon')?.addEventListener('click', function () {
    location.href = "/project/schedule";
  });
  
  document.getElementById('fa-note-icon')?.addEventListener('click', function () {
	    location.href = "/project/memo";
  });
});

// + 메뉴 hover 효과
const fabMain = document.querySelector('.fab-main');
const fabMenu = document.querySelector('.fab-menu');

fabMain?.addEventListener('mouseenter', () => {
  fabMenu.style.opacity = '1';
  fabMenu.style.pointerEvents = 'auto';
  fabMenu.style.transform = 'translateY(0)';
});

fabMain?.addEventListener('mouseleave', () => {
  setTimeout(() => {
    if (!fabMenu.matches(':hover')) {
      fabMenu.style.opacity = '0';
      fabMenu.style.pointerEvents = 'none';
      fabMenu.style.transform = 'translateY(10px)';
    }
  }, 200);
});

fabMenu?.addEventListener('mouseleave', () => {
  fabMenu.style.opacity = '0';
  fabMenu.style.pointerEvents = 'none';
  fabMenu.style.transform = 'translateY(10px)';
});/**
 * 
 */