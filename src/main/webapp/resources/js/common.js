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
		      url: '/project/list',
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

});