document.addEventListener('DOMContentLoaded', () => {
   
    const homeLink = document.getElementById('home-link');

  
    if (homeLink) {
        homeLink.addEventListener('click', () => {
            // 프로젝트의 메인 페이지로 이동합니다.
            window.location.href = '/'; 
        });
    }

    // 추가적인 JavaScript 로직을 여기에 작성할 수 있습니다.
});
