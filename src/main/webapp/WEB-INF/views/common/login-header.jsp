<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">

<body>

	<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"
			id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			<p onClick="location.href='/service'">서비스 소개</p>
			<p onClick="location.href='${pageContext.request.contextPath}/inquiryFAQ'">고객지원</p>

			<div class="user-dropdown">
				<i class="fa-solid fa-user-check mainpage-header-icon"
					id="mainpage-header-icon"></i>
				<ul class="dropdown-menu">
					<li onClick="location.href='/account/mypage'">개인정보 수정</li>
					<li id="btnOpenDeleteModal">회원탈퇴</li>
				</ul>
													
				<!-- 기존 로그아웃 -->	
				<!-- <i class="fa-solid fa-arrow-right-from-bracket"
					id="mainpage-header-icon" onClick="location.href='/account/logout'"></i> -->
					
				<!-- 로그아웃 수정 후 -->
				<i class="fa-solid fa-arrow-right-from-bracket"
					id="mainpage-header-icon" ></i>		
					
			</div>
		</div>
	</div>
	
	
	<!-- SweetAlert2 사용한 로그아웃 폼. 꾸미기 좋음. -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<!-- 숨김 로그아웃 폼: POST -->
	<form id="logoutForm" action="${pageContext.request.contextPath}/account/logout" method="post" style="display:none;">
	  <c:if test="${not empty _csrf}">
	    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	  </c:if>
	</form>
	
	<style>	 
	  .swal-compact .swal2-title{font-size:18px}
	  .swal-compact .swal2-actions .swal2-styled{padding:6px 10px;font-size:12px}
	  .swal2-container.swal2-top-end>.swal2-popup{margin-top:11px}
	</style>
	
	<script>
	  document.addEventListener('DOMContentLoaded', function () {
	    // 아이콘 스타일/클래스/ID 유지. 
	    const logoutIcon = document.querySelector('.user-dropdown .fa-arrow-right-from-bracket');
	    if (!logoutIcon) return;
	    

	    logoutIcon.addEventListener('click', function (e) {
	      e.preventDefault();
	      Swal.fire({
	    	  title: '로그아웃 하시겠습니까?',
	    	  icon: 'warning',
	    	  position: 'top',   // 화면 상단
	    	  width: 400,            // 크기
	    	  padding: '',     // 여백 
	    	  backdrop: false,       // 뒷배경 어둡게 안함
	    	  
	    	  showCancelButton: true,
	    	  confirmButtonText: '로그아웃',
	    	  cancelButtonText: '취소',
	    	  customClass: { popup: 'swal-compact' }
	      }).then((r) => {
	        if (r.isConfirmed) {
	          document.getElementById('logoutForm').submit(); // POST 로그아웃
	          // GET 로그아웃을 쓰고 싶다면 위 한 줄 대신:
	          // location.href = '${pageContext.request.contextPath}/account/logout';
	        }
	      });
	    });
	  });
	</script>
	 
	
</body>
</html>