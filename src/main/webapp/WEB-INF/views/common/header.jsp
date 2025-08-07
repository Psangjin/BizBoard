<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			<p onClick="scrollToIntroduce()">서비스 소개</a>
			<p onClick="location.href='/support'">고객지원</p>
			<button type="button" class="mainpage-start-btn" onClick="location.href='/login'">
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