<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Insert title here</title>
			<style>
				.user-dropdown {
					position: relative;
					display: inline-block;
				}

				.dropdown-menu {
					display: none;
					/* 기본 숨김 */
					position: absolute;
					top: 28px;
					/* 아이콘 아래로 */
					right: 0;
					background-color: white;
					border: 1px solid #ddd;
					border-radius: 6px;
					list-style: none;
					padding: 8px 0;
					margin: 0;
					min-width: 140px;
					box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
					z-index: 10;
				}

				.dropdown-menu li {
					padding: 8px 12px;
					cursor: pointer;
					font-size: 14px;
					color: #333;
				}

				.dropdown-menu li:hover {
					background-color: #f0f0f0;
				}

				/* 마우스 올렸을 때 드롭다운 표시 */
				.user-dropdown:hover .dropdown-menu {
					display: block;
				}

				/* 아이콘 스타일 */
				.mainpage-header-icon {
					font-size: 22px;
					color: #0d5ea3;
					cursor: pointer;
				}

				/* ===== Modal ===== */
				.modal {
					position: fixed;
					inset: 0;
					background: rgba(0, 0, 0, .35);
					z-index: 1000;
				}

				.modal-content {
					width: 360px;
					max-width: calc(100% - 32px);
					background: #fff;
					margin: 120px auto;
					padding: 20px;
					border-radius: 10px;
					box-shadow: 0 6px 20px rgba(0, 0, 0, .2);
				}

				.modal-content h3 {
					margin: 0 0 8px;
				}

				.modal-content p {
					margin: 0 0 12px;
					color: #333;
				}

				.modal-content input[type="password"] {
					width: 100%;
					padding: 10px;
					margin-bottom: 12px;
					border: 1px solid #ddd;
					border-radius: 6px;
					box-sizing: border-box;
				}

				.modal-actions {
					display: flex;
					justify-content: flex-end;
					gap: 8px;
				}

				.btn-secondary {
					background: #e0e0e0;
					border: none;
					padding: 8px 14px;
					border-radius: 6px;
					cursor: pointer;
				}

				.btn-danger {
					background: #e74c3c;
					color: #fff;
					border: none;
					padding: 8px 14px;
					border-radius: 6px;
					cursor: pointer;
				}

				.btn-danger:hover {
					opacity: .9;
				}

				.msg-error {
					color: #e74c3c;
					font-weight: 600;
					margin-top: 6px;
				}

				.msg-success {
					color: green;
					font-weight: 600;
					margin-top: 6px;
				}
			</style>

		</head>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
			crossorigin="anonymous" referrerpolicy="no-referrer" />
		<link rel="stylesheet" href="/css/mainpage.css">
		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

		<body>

			<div class="mainpage-header">
				<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo" id="mainpage-header-logo"
					onClick="location.href='/mainpage'">
				<div class="mainpage-header-menu">
					<p onClick="location.href='/service'">서비스 소개</p>
					<p onClick="location.href='/support'">고객지원</p>

					<div class="user-dropdown">
						<i class="fa-solid fa-user-check mainpage-header-icon" id="mainpage-header-icon"></i>
						<ul class="dropdown-menu">
							<li onClick="location.href='/account/mypage'">개인정보 수정</li>
							<li id="btnOpenDeleteModal">회원탈퇴</li>
						</ul>
					</div>
					<i class="fa-solid fa-arrow-right-from-bracket" id="mainpage-header-icon"
						onClick="location.href='/'"></i>
				</div>
			</div>

			<div class='mainpage-container'>
				<div class='mainpage-left'>
					<div class='mainpage-contents'>
						<div class="contents-text">데일리 스케줄</div>
						<div class='mainpage-contents-box'></div>
					</div>
					<div class='mainpage-contents'>
						<div class="contents-text">오늘 할 일</div>
						<div class='mainpage-contents-box'></div>
					</div>
				</div>

				<div class='mainpage-right'>
					<div class="contents-text">참여중인 프로젝트</div>

					<div class='mainpage-contents-box'>
						<div class="fab-item" data-popup="프로젝트 관련">
							<div class="fab-popup fab-project-popup">
								<div class="fab-popup-project-list">
									<ul id="mainpage-project-list">
										<!-- JS에서 li 항목들 생성 -->
									</ul>
								</div>

								<div class="popup-divider"></div>
								<div class="create-project-wrapper">
									<button class="create-project-btn open-new-project-modal-btn">＋ 새 프로젝트</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<script>



	<!-- 회원탈퇴 모달 -->
			<div id="deleteModal" class="modal" role="dialog" aria-modal="true" aria-labelledby="deleteTitle"
				style="display:none;">
				<div class="modal-content">
					<h3 id="deleteTitle">회원 탈퇴</h3>
					<p>정말 탈퇴하시겠습니까? 현재 비밀번호를 입력해 주세요.</p>

					<form action="/account/delete" method="post" id="deleteForm">
						<input type="password" name="currentPw" placeholder="현재 비밀번호" required />

						<!-- 스프링 시큐리티 CSRF 사용 시 -->
						<c:if test="${_csrf != null}">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						</c:if>

						<div class="modal-actions">
							<button type="button" id="btnCloseDeleteModal" class="btn-secondary">취소</button>
							<button type="button" id="btnConfirmDelete" class="btn-danger">탈퇴하기</button>
						</div>

						<!-- 서버에서 flash로 내려온 메시지 표기용(선택) -->
						<c:if test="${not empty deleteMsg}">
							<p class="${deleteOk ? 'msg-success':'msg-error'}">${deleteMsg}</p>
						</c:if>
					</form>
				</div>
			</div>


			<!--SweetAlert2 CDN(먼저 로드)-- >
					<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

			<!-- 공통 UI: 전부 상단, 깔끔하게 -->
			<script>
					window.ui = {
						alert(msg, icon = 'info') {
		      return Swal.fire({text: msg, icon, position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
					success(msg) {
		      return Swal.fire({text: msg, icon: 'success', position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
					error(msg) {
		      return Swal.fire({text: msg, icon: 'error', position: 'top', toast: true, timer: 3000, showConfirmButton: false });
		    },
					// 확정 필요할 때만: 상단에 뜨는 팝업(토스트 X) + 버튼
					confirm(msg) {
		      return Swal.fire({
						text: msg,
					icon: 'warning',
					position: 'top',
					showCancelButton: true,
					confirmButtonText: '확인',
					cancelButtonText: '취소'
		      });
		    }
		  };
			</script>


			<script>
					const modal = document.getElementById('deleteModal');
					const openBtn = document.getElementById('btnOpenDeleteModal');
					const closeBtn = document.getElementById('btnCloseDeleteModal');
					const confirmBtn = document.getElementById('btnConfirmDelete');
					const form = document.getElementById('deleteForm');
					const pwInput = form.querySelector('input[name="currentPw"]');

					// 서버 메시지 있으면 모달 오픈
					<c:if test="${not empty deleteMsg}">modal.style.display = 'block';</c:if>
		
		  
		  
		  // 열기/닫기
		  openBtn?.addEventListener('click', () => {modal.style.display = 'block'; pwInput.focus(); });
		  const closeModal = () => modal.style.display = 'none';
					closeBtn?.addEventListener('click', closeModal);
		  window.addEventListener('click', e => { if (e.target === modal) closeModal(); });
		  window.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

		  // 최종 확인 후 제출(중복제출 방지)
		   confirmBtn?.addEventListener('click', async () => {
		    const pw = pwInput.value.trim();
					if (!pw) {
						await ui.error("비밀번호를 입력해주세요.");
					pwInput.focus();
					return;
		    }
					const {isConfirmed} = await ui.confirm("정말로 탈퇴하시겠습니까?\n탈퇴 후 복구할 수 없습니다.");
					if (isConfirmed) {
						confirmBtn.disabled = true;
					form.submit();
		    }
		  });
			</script>


			<c:if test="${not empty globalMsg}">
				<script> ui.success("<c:out value='${globalMsg}' />"); </script>
			</c:if>

			<c:if test="${not empty deleteMsg}">
				<script>
					// 모달 열고, 비밀번호 입력칸 초기화 + 포커스
					(function(){
		      const modal   = document.getElementById('deleteModal');
					const form    = document.getElementById('deleteForm');
					const pwInput = form ? form.querySelector('input[name="currentPw"]') : null;

					if (modal) modal.style.display = 'block';
					if (pwInput) {pwInput.value = ''; pwInput.focus(); }

					// 상단 토스트로 에러 출력
					if (window.ui && ui.error) {
						ui.error("<c:out value='${deleteMsg}'/>");
		      }
		    })();
				</script>
			</c:if>




			document.addEventListener('DOMContentLoaded', function () {

			$.ajax({
			url: '/project/listByUserId',
			method: 'GET',
			dataType: 'json', // JSON 형식으로 받기
			success: function (projects) {
			const $popupList = document.querySelector('#mainpage-project-list');

			if (!projects || projects.length === 0) {
			$popupList.innerHTML = '<li>참여중인 프로젝트가 없습니다</li>';
			return;
			}

			$popupList.innerHTML = '';

			projects.forEach(function (myProject) {
			const li = document.createElement('li');
			li.textContent = myProject.title;
			li.dataset.id = myProject.id;
			console.log(myProject);

			li.addEventListener('click', () => {
			console.log('클릭됨:', myProject);
			$.ajax({
			url: '/project/setSession',
			method: 'POST',
			data: JSON.stringify(myProject),
			contentType: 'application/json',
			success: function () {
			location.href = `/project/main/`+myProject.id;
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
			</script>
		</body>

		</html>