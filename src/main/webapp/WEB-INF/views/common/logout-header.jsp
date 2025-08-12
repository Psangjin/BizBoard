<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="mainpage-logout-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			<p onClick="scrollToIntroduce()">서비스 소개</a>
<<<<<<< HEAD:src/main/webapp/WEB-INF/views/common/header.jsp
			<p onClick="location.href='/support'">고객지원</p>
=======
			<p onClick="location.href='${pageContext.request.contextPath}/inquiryFAQ'">고객지원</p>
>>>>>>> e859ebf9e0f909a36a1619f1a1c97b50741297f4:src/main/webapp/WEB-INF/views/common/logout-header.jsp
			<button type="button" class="mainpage-start-btn" onClick="location.href='/account/login'">
				<span class="mainpage-btn-text">시작하기</span> 
				<span class="mainpage-btn-text"><i class="fa-solid fa-arrow-right"></i></span>
			</button>
		</div>
	</div>
	
	<script>
		function scrollToIntroduce(){
			const section = document.getElementById('service-introduce');
			if(section){
				section.scrollIntoView({behavior: 'smooth'});
			}
		}
	</script>
</body>
</html>