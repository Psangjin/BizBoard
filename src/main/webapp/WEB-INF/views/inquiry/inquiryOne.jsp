<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>1:1 문의</title>
<link rel="stylesheet" href="/css/inquiryOne.css">
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<a href="/"> <img class="logo-image" src="/image/logo2.png"	alt="BizBoard 로고" />
			</a>
			<h2>문의하기</h2>
			<div class="sidebar-menu">
				<hr />
				<a href="${pageContext.request.contextPath}/inquiryFAQ">자주 묻는 질문</a>
				<hr />
				<a href="#" class="current-page">1 : 1 문의</a>
			</div>
		</div>
		<div class="content">
			<h1 class="inquiry-title">1:1 문의하기</h1>

			<!-- 전송 성공 메시지 표시 영역 -->
			<div id="successMessage" class="success-message"
				style="display: none;">
				<p>✓ 문의가 성공적으로 전송되었습니다. 빠른 시일 내에 답변드리겠습니다.</p>
			</div>

			<form id="inquiryForm"
				action="${pageContext.request.contextPath}/inquirySubmit"
				method="post">
				<div class="form-group">
					<label for="inquirySubject">제목</label> <input type="text"
						id="inquirySubject" name="subject" placeholder="문의 제목을 입력해주세요"
						required>
				</div>
				<div class="form-group-inline">
					<div class="form-group">
						<label for="userName">이름</label> <input type="text" id="userName"
							name="name" required>
					</div>
					<div class="form-group">
						<label for="userEmail">Email</label> <input type="email"
							id="userEmail" name="email" required>
					</div>
				</div>
				<div class="form-group">
					<label for="inquiryContent">문의 내용</label>
					<textarea id="inquiryContent" name="content"
						placeholder="1:1 문의는 최대한 빠르게 답변드리고 있으나 늦어질 수 있는점(영업일 기준 3~5일) 양해 부탁드립니다."
						required></textarea>
				</div>
				<div class="consent-box">
					<p>개인정보 수집 및 이용 안내 동의</p>
					<p class="consent-text">
						- 수집목적: 고객센터 1:1 문의 상담을 위한 정보 수집 및 이용<br> - 수집항목: 이름, 이메일,
						연락처<br> - 보유 및 이용기간: 3년 보관 후 파기<br> - 기타: 동의를 거부할 수 있지만
						거부시 1:1 고객문의를 하실 수 없습니다.
					</p>
					<label class="consent-checkbox"> <input type="checkbox"
						id="consent" required> <span>위 내용에 동의합니다.</span>
					</label>
				</div>
				<button type="submit" class="submit-button">전송</button>
			</form>
		</div>
	</div>

	<script>
		// 폼 제출 처리
		document
				.getElementById('inquiryForm')
				.addEventListener(
						'submit',
						function(e) {
							e.preventDefault();

							// 폼 유효성 검사
							const subject = document
									.getElementById('inquirySubject').value
									.trim();
							const name = document.getElementById('userName').value
									.trim();
							const email = document.getElementById('userEmail').value
									.trim();
							const content = document
									.getElementById('inquiryContent').value
									.trim();
							const consent = document.getElementById('consent').checked;

							if (!subject || !name || !email || !content) {
								alert('모든 필수 항목을 입력해주세요.');
								return;
							}

							if (!consent) {
								alert('개인정보 수집 및 이용에 동의해주세요.');
								return;
							}

							// 이메일 유효성 검사
							const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
							if (!emailPattern.test(email)) {
								alert('올바른 이메일 주소를 입력해주세요.');
								return;
							}

							// 실제로는 서버로 데이터 전송
							// 여기서는 시뮬레이션
							simulateFormSubmission();
						});

		// 폼 전송 시뮬레이션 함수
		function simulateFormSubmission() {
			// 버튼 비활성화
			const submitButton = document.querySelector('.submit-button');
			const originalText = submitButton.textContent;
			submitButton.disabled = true;
			submitButton.textContent = '전송 중...';

			// 2초 후 성공 처리
			setTimeout(function() {
				// 성공 메시지 표시
				showSuccessMessage();

				// 폼 초기화
				resetForm();

				// 버튼 원상복구
				submitButton.disabled = false;
				submitButton.textContent = originalText;

				// 페이지 상단으로 스크롤
				window.scrollTo(0, 0);

			}, 2000);
		}

		// 성공 메시지 표시
		function showSuccessMessage() {
			const successMessage = document.getElementById('successMessage');
			successMessage.style.display = 'block';
			successMessage.style.animation = 'fadeInOut 5s ease-in-out';

			// 5초 후 메시지 숨기기
			setTimeout(function() {
				successMessage.style.display = 'none';
			}, 5000);
		}

		// 폼 초기화
		function resetForm() {
			document.getElementById('inquiryForm').reset();
		}

		// 페이지 로드시 URL 파라미터 확인
		window.onload = function() {
			const urlParams = new URLSearchParams(window.location.search);
			const success = urlParams.get('success');

			if (success === 'true') {
				showSuccessMessage();

				// URL에서 파라미터 제거
				if (history.pushState) {
					const newUrl = window.location.protocol + "//"
							+ window.location.host + window.location.pathname;
					window.history.pushState({
						path : newUrl
					}, '', newUrl);
				}
			}
		};
	</script>

	<style>
/* 성공 메시지 스타일 */
.success-message {
	background-color: #d4edda;
	border: 1px solid #c3e6cb;
	color: #155724;
	padding: 15px;
	border-radius: 5px;
	margin-bottom: 20px;
	text-align: center;
}

.success-message p {
	margin: 0;
	font-weight: 500;
}

@
keyframes fadeInOut { 0% {
	opacity: 0;
	transform: translateY(-10px);
}

15


%
{
opacity


:


1
;


transform


:


translateY
(


0


)
;


}
85


%
{
opacity


:


1
;


transform


:


translateY
(


0


)
;


}
100


%
{
opacity


:


0
;


transform


:


translateY
(


-10px


)
;


}
}

/* 전송 중 버튼 스타일 */
.submit-button:disabled {
	background-color: #6c757d;
	cursor: not-allowed;
}
</style>

	<script
		src="${pageContext.request.contextPath}/resources/js/inquiryOne.js"></script>
</body>
</html>