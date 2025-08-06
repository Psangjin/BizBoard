document.addEventListener('DOMContentLoaded', function () {
	renderComments();  // ⬅ 이걸 꼭 추가
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
  let isEditMode = false; // 편집 모드 상태 저장

// 간트 스크립트 시작 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Gantt Toggle
  document.querySelector('.fa-arrow-right-arrow-left').addEventListener('click', function () {
	const eventdetails = document.getElementById('fc-event-details');
    const calendarEl = document.getElementById('calendar');
    const ganttWrapper = document.getElementById('gantt');
    const dragevent = document.getElementById('fc-external-events');
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

    let draggedEventInfo = null;
	//캘린더에 일정 드래그시 가져올 정보
    new FullCalendar.Draggable(document.getElementById('fc-external-events'), {
      itemSelector: '.fc-event',
	  eventData: function (eventEl) {
	      // 편집 도구는 isEditTool을 true로 설정
	      const isEditTool = eventEl.dataset.edit === "true";
	      const title = eventEl.dataset.title;
	      const color = eventEl.dataset.color;

	      return {
	        title: title,
	        backgroundColor: color,
	        borderColor: color,
	        extendedProps: {
	          isEditTool: isEditTool
	        }
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
	
	function openEditModal(event) {
	  // 모달에 데이터 채우기
	  document.getElementById('fc-modal-title').value = event.title || '';
	  document.getElementById('fc-modal-description').value = event.extendedProps.description || '';
	  document.getElementById('fc-modal-color').value = event.backgroundColor || '#007bff';
	  document.getElementById('fc-event-allday').checked = event.allDay;
	  
	  // 시작일 설정 (datetime-local 포맷)
	  document.getElementById('fc-event-start').value = toDatetimeLocal(event.start);
	  
	  // 종료일 설정 (있으면)
	  document.getElementById('fc-event-end').value = toDatetimeLocal(event.end);

	  // 모달 보이기
	  document.getElementById('fc-eventModal').style.display = 'block';
	  document.getElementById('fc-modalBackdrop').style.display = 'block';

	  // 편집 중인 이벤트 저장 (글로벌 변수 등)
	  window.currentEditEvent = event;
	}
    
    //스케쥴 수정 함수
    function updateScheduleEvent(info) {
   	  const event = info.event;

		  const updatedData = {
		    id: event.id,
		    title: event.title,
		    content: event.extendedProps.description,
		    type: event.extendedProps.type,
		    startDt: event.start,
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
    
    const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,timeGridDay'
      },
      droppable: false,
      editable: false, // 편집 가능 여부
	  selectable: false,
	  eventStartEditable: false,
      eventDurationEditable: false,
      events: '/project/schedule/events', //초기 설정 일정
      eventDisplay: 'block',
      
	  //캘린더에 일정 드래그앤 드롭시
      eventReceive: function(info) {
		  
        draggedEventInfo = info;
        // 드롭한 날짜 시작날짜로 설정
        const droppedDate = info.event.startStr;
        setInputDate(droppedDate);
        
        //새로운 데이터 입력을 위한 다른 데이터 초기화
        document.getElementById('fc-modal-title').value = '';
        document.getElementById('fc-modal-description').value = '';
        document.getElementById('fc-modal-color').value = '#007bff';

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
		
		if(!isEditMode) return;
		
		openEditModal(event);
      },
      eventDragStart: function(info) {
    	  document.addEventListener("mousemove", handleTrashHover);
      },
      eventDragStop: function(info) {
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
	   	},
    	
    	eventDrop: function(info) {
   		  updateScheduleEvent(info);
   		},
   		
   		eventResize: function(info) {
		  updateScheduleEvent(info);
   		}
   		

  	  });
    

    //일정 추가 완료
    document.getElementById('fc-save-event').addEventListener('click', function() {
   	  const title = document.getElementById('fc-modal-title').value.trim();
   	  const desc = document.getElementById('fc-modal-description').value.trim();
   	  const color = document.getElementById('fc-modal-color').value;
   	  const start = document.getElementById('fc-event-start').value;
   	  const end = document.getElementById('fc-event-end').value;
   	  const alldayCheckbox = document.getElementById('fc-event-allday');
	  const id = document.getElementById('fc-modal-id').value;
   	  
	  const url = id ? '/project/schedule/update' : '/project/schedule/save';
	  
	  console.log(id);
	  
      if (!title) {
        alert('제목을 입력해주세요.');
        return;
      }
      const allDay = alldayCheckbox.checked;

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
        allDay: allDay
      };
      
      $.ajax({
    	    url: url,
    	    type: 'POST',
    	    contentType: 'application/json',
    	    data: JSON.stringify(scheduleData),
    	    success: function () {
    	      alert('저장 완료');
    	      location.reload();
    	    },
    	    error: function () {
    	      alert('저장 실패');
    	    }
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
	});

  });
