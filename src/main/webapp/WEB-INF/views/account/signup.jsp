<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SignUp</title>
<style>
/* 전체 박스 */
.form-container {
    width: 350px;
    margin: 60px auto;
    padding: 30px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    text-align: center;
}

/* 제목 */
.form-container h2 {
    font-size: 28px;
    margin-bottom: 20px;
}

/* 입력창 */
.input-box {
    width: 100%;
    padding: 12px;
    margin-bottom: 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
}

/* 버튼 */
.btn {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    font-weight: bold;
    border: none;
    border-radius: 6px;
    color: white;
    background-color: #6c63ff;
    cursor: pointer;
    margin-bottom: 20px;
}

.btn:hover {
    background-color: #574bff;
}

/* 보조 버튼 (로그인 페이지로, 회원가입 페이지로) */
.btn-secondary {
    background-color: #8b85ff;
}

.btn-secondary:hover {
    background-color: #766df5;
}

.terms-container {
	text-align: left;
	
	font-size: 13px; /* 약관 동의 폰트 */
	margin-top: 20px;	
}

.terms-container label {
	display: block;
	margin-bottom: 8px;
}

/* 에러 메시지 */
.error-text {
    color: red;
    font-size: 14px;
    margin-bottom: 10px;
}

</style>


</head>
<body>

<div class="form-container">
    <h2>회원가입</h2>
    
      <!-- 서버에서 전달된 에러 메시지 -->
   
		<c:if test="${not empty error}">
		  <p class="error-text">${error}</p>
		</c:if>
    
    <form action="${ctx}/account/signup" method="post">
        <input type="text" name="id" placeholder="아이디 입력"
               class="input-box" value="${user.id}">
        <input type="password" name="pw" placeholder="비밀번호 입력"
               class="input-box">
        <input type="text" name="name" placeholder="이름 입력"
               class="input-box" value="${user.name}">
        <input type="email" name="email" placeholder="이메일 입력"
               class="input-box" value="${user.email}">

    <!-- 약관 동의 -->
    <div class="terms-container">
        <label>
            <input type="checkbox" id="agreeAll"> 아래 내용에 모두 동의합니다.
        </label>
	
	   
        <label>
            <input type="checkbox" name="terms" class="terms-check"> [필수] 이용약관 동의
            <a href="#" style="float:right; font-size:12px;">전체보기 &gt;</a>
        </label>

        <label>
            <input type="checkbox" name="privacy" class="terms-check"> [필수] 개인정보 수집 및 이용 동의
            <a href="#" style="float:right; font-size:12px;">전체보기 &gt;</a>
        </label>

        <label>
            <input type="checkbox" name="age" class="terms-check"> [필수] 만 14세 이상입니다.<br> 
            <span style="font-size:12px; color:#888;">(만 14세 미만은 가입이 불가능합니다.)</span>
        </label>

        <label>
            <input type="checkbox" name="marketing"> [선택] 마케팅 정보 활용 및 광고성 정보 수신 동의
            <a href="#" style="float:right; font-size:12px;">전체보기 &gt;</a>
        </label>
    </div>

    <button type="submit" class="btn">가입하기</button>
	</form>
	
	<a href="${ctx}/account/login" class="btn btn-secondary">로그인 페이지로</a>


<script>
function validateForm(e) {
    const id = document.querySelector('input[name="id"]').value.trim();
    const pw = document.querySelector('input[name="pw"]').value.trim(); 
    const name = document.querySelector('input[name="name"]').value.trim();
    const email = document.querySelector('input[name="email"]').value.trim();
    const requiredChecks = document.querySelectorAll('.terms-check');

    if (!id) { alert("아이디를 입력해주세요."); e.preventDefault(); return false; }
    if (!pw) { alert("비밀번호를 입력해주세요."); e.preventDefault(); return false; }
    if (!name) { alert("이름을 입력해주세요."); e.preventDefault(); return false; }
    if (!email) { alert("이메일을 입력해주세요."); e.preventDefault(); return false; }

    for (let cb of requiredChecks) {
        if (!cb.checked) {
            alert("필수 약관에 모두 동의해야 가입이 가능합니다.");
            e.preventDefault();
            return false;
        }
    }
    return true;
}



<!-- 약관 전체선택 기능 -->
document.getElementById('agreeAll').addEventListener('change', function() {
    const isChecked = this.checked; // 수정됨
    document.querySelectorAll('.terms-check').forEach(cb => cb.checked = isChecked);
});
</script>


                      
       


</body>
</html>
