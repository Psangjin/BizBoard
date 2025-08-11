document.addEventListener('DOMContentLoaded', () => {
    const inquiryForm = document.getElementById('inquiryForm');
    const consentCheckbox = document.getElementById('consent');

    if (inquiryForm) {
        inquiryForm.addEventListener('submit', (event) => {
            if (!consentCheckbox.checked) {
                alert('개인정보 수집 및 이용에 동의해야 합니다.');
                event.preventDefault(); // 폼 제출을 막습니다.
            } else {
               
                alert('문의가 성공적으로 전송되었습니다.');
				
				// 폼의 모든 입력 필드를 초기화합니다.
				inquiryForm.reset();
            }
        });
    }

    // 현재 페이지 링크 비활성화 (CSS와 연동)
    const inquiryLink = document.querySelector('.sidebar-menu a.current-page');
    if (inquiryLink) {
        inquiryLink.addEventListener('click', (event) => {
            event.preventDefault();
        });
    }
});
