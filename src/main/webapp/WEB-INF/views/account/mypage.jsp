<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


<style>

  body {
        font-family: Arial, sans-serif;
        margin: 30px;
    }

	 h1 {
        text-align: center;
        margin-bottom: 40px;
    }
	
	.flex-body {
        display: flex;
        justify-content: center;
        gap: 30px;
        flex-wrap: wrap;
        max-width: 1200px;
        margin: 0 auto;
    }
	
	
    .content {
        flex: 1;
        min-width: 300px;
        max-width: 500px;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        font-weight: bold;
        display: block;
        margin-bottom: 5px;
    }

    .form-group input {
        width: 100%;
        padding: 8px;
        box-sizing: border-box;
    }

    .btn-submit,
    .logout-btn {
        color: white;
        background-color: #6c63ff;
        padding: 8px 16px;
        border-radius: 5px;
        font-weight: bold;
        border: none;
        cursor: pointer;
        margin-top: 10px;
    }

    .btn-submit:hover,
    .logout-btn:hover {
        background-color: #574bff;
    }

    .msg-success {
        color: green;
        font-weight: bold;
        margin-top: 10px;
    }

    .msg-error {
        color: red;
        font-weight: bold;
        margin-top: 10px;
    }
</style>
	


	<script>
	function confirmLogout() {
		return confirm("정말 로그아웃하시겠습니까?");
	}
	</script>
	
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">


</head>
<body>

<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			
			
		</div>
	</div>


<h1>${id} 님의 마이페이지</h1>
	<div class="flex-body"> 
		 <div class="content">
		        <h2>내 프로필</h2>
		
		        <form action="/account/mypage/update" method="post">
		            <div class="form-group">
		                <label>아이디</label>
		                <input type="text" name="id" value="${id}" readonly />
		            </div>
		
		            <div class="form-group">
		                <label>이름</label>
		                <input type="text" name="name" value="${name}" readonly />
		            </div>
		
		            <div class="form-group">
		                <label>이메일</label>
		                <input type="text" name="email" value="${email}" readonly />
		            </div>
		
		            <div class="form-group">
		                <label>새 비밀번호</label>
		                <input type="password" name="pw" required />
		            </div>
		
		            <div class="form-group">
		                <label>비밀번호 확인</label>
		                <input type="password" name="pwCheck" required />
		            </div>
		
		            <button type="submit" class="btn-submit">비밀번호 변경</button>
		        
		        
					<!-- 비밀번호변경 유효성 검사 -->        
		        	<c:if test="${msg eq '비밀번호가 성공적으로 변경되었습니다.'}"> 
					    <p style="color: green;">${msg}</p>
					</c:if>
					<c:if test="${msg eq '비밀번호가 일치하지 않습니다.'}">
					    <p style="color: red;">${msg}</p>
					</c:if>
		
		        		
		        
		        </form>
		        
		    </div>
		
		
			 <!-- 활동 내역 및 로그아웃 영역 -->
			 
		    <div class="content">
		        <h2>활동 내역</h2>
		        <h4>📝 내가 작성한 프로젝트</h4>
				  <ul>
				    <c:forEach var="p" items="${myProjects}">
				      <li>${p.title} (${p.start_dt} ~ ${p.end_dt})</li>
				    </c:forEach>
				  </ul>
				
				  <h4>🤝 참여 중인 프로젝트</h4>
				  <ul>
				    <c:forEach var="p" items="${participatedProjects}">
					    <li>${p.title} (${p.start_dt} ~ ${p.end_dt})</li>
					  </c:forEach>
				  </ul>
			
		        <form action="${ctx}/account/logout" method="post" onsubmit="return confirmLogout()">
		            <button type="submit" class="logout-btn">로그아웃</button>
		        </form>
		    </div>
	</div>
</body>
</html>