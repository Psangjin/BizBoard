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

  // +메뉴(fab) 호버 효과
  const fabMain = document.querySelector('.fab-main');
  const fabMenu = document.querySelector('.fab-menu');
  if (fabMain && fabMenu) {
    fabMain.addEventListener('mouseenter', () => {
      fabMenu.style.opacity = '1';
      fabMenu.style.pointerEvents = 'auto';
      fabMenu.style.transform = 'translateY(0)';
    });

    fabMain.addEventListener('mouseleave', () => {
      setTimeout(() => {
        if (!fabMenu.matches(':hover')) {
          fabMenu.style.opacity = '0';
          fabMenu.style.pointerEvents = 'none';
          fabMenu.style.transform = 'translateY(10px)';
        }
      }, 200);
    });

    fabMenu.addEventListener('mouseleave', () => {
      fabMenu.style.opacity = '0';
      fabMenu.style.pointerEvents = 'none';
      fabMenu.style.transform = 'translateY(10px)';
    });
  }

});