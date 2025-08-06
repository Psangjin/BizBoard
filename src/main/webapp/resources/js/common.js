/**
 * 
 */
document.addEventListener('DOMContentLoaded', function() {
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
      location.href = "/project/main";
    });
  }

  const calendarIcon = document.getElementById('fa-calendar-icon');
  if (calendarIcon) {
    calendarIcon.addEventListener('click', function() {
      location.href = "/project/schedule";
    });
  }
  
  const noteIcon = document.getElementById('fa-note-icon')
  if (noteIcon) {
	noteIcon.addEventListener('click', function () {
	  location.href = "/project/memo";
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
      }, 400);
    });

    // 메뉴에 다시 들어오면 타이머 제거
    fabMenu.addEventListener('mouseenter', () => {
      clearTimeout(hideTimeout);
    });
	
	const fabItems = document.querySelectorAll(".fab-item");

	    fabItems.forEach(item => {
	      const popup = item.querySelector(".fab-popup");

	      item.addEventListener("mouseenter", () => {
	        popup.style.opacity = "1";
	        popup.style.transform = "translateX(-10px)";
	        popup.style.pointerEvents = "auto";
	      });

	      item.addEventListener("mouseleave", () => {
	        popup.style.opacity = "0";
	        popup.style.transform = "translateX(0)";
	        popup.style.pointerEvents = "none";
	      });
	    });

});