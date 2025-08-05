/**
 * 
 */

document.addEventListener('DOMContentLoaded', function() {
    let draggedEventInfo = null;
	//캘린더에 일정 드래그시 가져올 정보
    new FullCalendar.Draggable(document.getElementById('external-events'), {
      itemSelector: '.fc-event',
      eventData: function(eventEl) {
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
	
	//시작 날짜 자동 설정 함수
    function setInputDate(datetimeStr) {
   	  const input = document.getElementById('event-start');

   	  // datetime-local 형식은 "YYYY-MM-DDTHH:MM" 이어야 함
   	  const date = new Date(datetimeStr);
   	  const year = date.getFullYear();
   	  const month = String(date.getMonth() + 1).padStart(2, '0'); // 0~11
   	  const day = String(date.getDate()).padStart(2, '0');
   	  const hour = String(date.getHours()).padStart(2, '0');
   	  const minute = String(date.getMinutes()).padStart(2, '0');

   	  let formatted = year+'-'+month+'-'+day+'T'+hour+':'+minute;
   	  input.value = formatted;
   	}

    function handleTrashHover(e) {
   	  const trashEl = document.getElementById("event-trash");
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
		    url: '/project/schedule/updateDate',
		    type: 'POST',
		    contentType: 'application/json',
		    data: JSON.stringify(updatedData),
		    success: function () {
		      console.log('일정 이동 후 업데이트 성공');
		    },
		    error: function () {
		      alert('일정 날짜 업데이트 실패');
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
      droppable: true,
      editable: true, // 편집 가능 여부
      events: '/project/schedule/events', //초기 설정 일정
      eventDisplay: 'block',
      
	  //캘린더에 일정 드래그앤 드롭시
      eventReceive: function(info) {
        draggedEventInfo = info;
        // 드롭한 날짜 시작날짜로 설정
        const droppedDate = info.event.startStr;
        setInputDate(droppedDate);
        
        //새로운 데이터 입력을 위한 다른 데이터 초기화
        document.getElementById('modal-title').value = '';
        document.getElementById('modal-description').value = '';
        document.getElementById('modal-color').value = '#007bff';

        document.querySelectorAll('.color-circle').forEach(c => c.classList.remove('selected'));
        document.querySelector('.color-circle[data-color="#007bff"]').classList.add('selected');

        document.getElementById('eventModal').style.display = 'block';
        document.getElementById('modalBackdrop').style.display = 'block';
      },
	  //캘린더의 일정 클릭시
      eventClick: function(info) {
        const event = info.event;
        const title = event.title || '제목 없음';
        const description = event.extendedProps.description || '설명 없음';
        console.log(event);
        document.getElementById('event-title').textContent = title;
        document.getElementById('event-description').textContent = description;
        document.getElementById('event-details').style.display = 'block';
      },
      eventDragStart: function(info) {
    	  document.addEventListener("mousemove", handleTrashHover);
      },
      eventDragStop: function(info) {
   	    document.removeEventListener("mousemove", handleTrashHover);
   	    const trashEl = document.getElementById("event-trash");
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
			console.log(eventId);
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
    document.getElementById('save-event').addEventListener('click', function() {
   	  const title = document.getElementById('modal-title').value.trim();
   	  const desc = document.getElementById('modal-description').value.trim();
   	  const color = document.getElementById('modal-color').value;
   	  const start = document.getElementById('event-start').value;
   	  const end = document.getElementById('event-end').value;
   	  const alldayCheckbox = document.getElementById('event-allday');
   	  
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
        title: title,
        content: desc,
        type: type,
        startDt: startDt,
        endDt: endDt,
        color: color,
        allDay: allDay
      };
      
      $.ajax({
    	    url: '/project/schedule/save',
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
    document.getElementById('cancel-event').addEventListener('click', function() {
      if (draggedEventInfo) {
        draggedEventInfo.event.remove();
      }
      closeModal();
    });

    calendar.render();
	

    //일정 추가시 색상 저장
    document.querySelectorAll('.color-circle').forEach(circle => {
      circle.addEventListener('click', function () {
        document.querySelectorAll('.color-circle').forEach(c => c.classList.remove('selected'));
        this.classList.add('selected');
        document.getElementById('modal-color').value = this.dataset.color;
      });
    });
  });