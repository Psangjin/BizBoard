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
	.logout-btn {	
	color: white; /* 글자색 */
	background-color: #6c63ff; /* 버튼 배경 */
	padding: 6px 12px;
	border-radius: 5px;
	display: inline-block;
	font-weight: bold;
	border: none;
	}

	.logout-btn:hover {
	background-color: #574bff; /* hover 시 진한 색 */
	}
	</style>


	<script>
	function confirmLogout() {
		return confirm("정말 로그아웃하시겠습니까?");
	}
	</script>



</head>
<body>


 <div class="content">
        <h2>내 프로필</h2>

        <form action="/account/mypage/update" method="post">
            <div class="form-group">
                <label>아이디</label>
                <input type="text" name="id" value="${loginUser.id}" readonly />
            </div>

            <div class="form-group">
                <label>이름</label>
                <input type="text" name="name" value="${loginUser.name}" readonly />
            </div>

            <div class="form-group">
                <label>이메일</label>
                <input type="text" name="email" value="${loginUser.email}" readonly />
            </div>

            <div class="form-group">
                <label>새 비밀번호</label>
                <input type="password" name="pw" required />
            </div>

            <div class="form-group">
                <label>비밀번호 확인</label>
                <input type="password" name="pwCheck" required />
            </div>

            <button type="submit" class="btn-submit">수정하기</button>
        </form>
    </div>
</div>


	<h1>${id}님의 마이페이지</h1>
	<br> 이메일: ${email}
	<br> 회원 정보 / 활동 내역 표시
	<br>
	<br>
	
	<form action="${ctx}/account/logout" method="post" onsubmit="return confirmLogout()">
		 <button type="submit" class="logout-btn">로그아웃</button>
	</form>

	

</body>
</html>