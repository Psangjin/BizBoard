<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


<style>

  /* 전체 배경 톤 */    
  body {
        font-family: Arial, sans-serif;
        margin: 30px;
      background: #f7f9fc;
    }
    
  /* 헤더 타이틀 강조 */	
	 h1 {
        text-align: center;
        margin-bottom: 40px;
      font-weight: 800;
      letter-spacing: -0.3px;
    }
/* 레이아웃 */	
	.flex-body {
        display: flex;
        justify-content: center;
        gap: 30px;
        flex-wrap: wrap;
        max-width: 1200px;
        margin: 0 auto;
    }
	
	
	/* 카드 */
	
    .content {
        flex: 1;
        min-width: 300px;
        max-width: 500px;
        padding: 20px;        
      background: #fff;
	  border: 1px solid #e9eef5;
	  border-radius: 16px;
	  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
    }
	.card-header {
		display:flex;
		align-items:center;
		gap:10px;
		margin-bottom:16px;
	}
	.section-title{
		 font-size:18px;
		 font-weight:700;
    }
	
	
	/* 이니셜 */
	.avatar {
		width:44px; height:44px; border-radius:50%;
		color:#fff; display:flex; align-items:center;
		justify-content:center;
	    font-weight:800; letter-spacing:.5px;
	    box-shadow:0 6px 14px rgba(108,99,255,.35);
  }
			
	
	/* 폼 */		
    .form-group {
        margin-bottom: 16px;
    }
	    
    
    .form-group label {
        font-weight: 700;
        display: block;
        margin-bottom: 5px;
    }

    .form-group input {
        width: 100%;
        padding: 8px;
        box-sizing: border-box;
      border: 1px solid #d7deea;
	  border-radius: 10px;
	  background: #fff;
	  transition: .2s;
    }
    
    
    .form-group input:focus {
	  outline: none;
	  border-color: #6c63ff;
	  box-shadow: 0 0 0 4px rgba(108, 99, 255, .15);
	}
	
	.from-group input[readonly] {
		background:#f3f4fa;
		color:#6b7280
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
	


	
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mainpage.css">


</head>
<body>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
  // 공통 UI: 전부 상단 토스트(3초) + confirm은 버튼 있는 모달
  window.ui = {
    success: (msg) => Swal.fire({ text: msg, icon: 'success', position: 'top', toast: true, timer: 3000, showConfirmButton: false }),
    error:   (msg) => Swal.fire({ text: msg, icon: 'error',   position: 'top', toast: true, timer: 3000, showConfirmButton: false }),
    alert:   (msg) => Swal.fire({ text: msg, icon: 'info',    position: 'top', toast: true, timer: 3000, showConfirmButton: false }),
    confirm: (msg) => Swal.fire({ text: msg, icon: 'warning', position: 'top',
                                  showCancelButton: true, confirmButtonText: '확인', cancelButtonText: '취소' })
  };
  
  function confirmLogout(e) {
	    e.preventDefault();
	    ui.confirm("정말 로그아웃하시겠습니까?").then(res => {
	      if (res.isConfirmed) e.target.submit();
	    });
	    return false;
	  }
	</script>



<div class="mainpage-header">
		<img src="/image/BizBoard_Logo.png" alt="BizBoard_Logo"	id="mainpage-header-logo" onClick="location.href='/'">
		<div class="mainpage-header-menu">
			
			
		</div>
	</div>


<h1>${id} 님의 개인정보수정</h1>
	<div class="flex-body"> 
	 <!-- 내 프로필 -->
		 <div class="content">
	        <div class="card-header">
		      <div class="avatar">${fn:length(name) > 0 ? fn:substring(name,0,1) : fn:substring(id,0,1)}</div>
		      <div class="section-title">내 프로필</div>
  			</div>
		
		        <form action="/account/mypage/update" method="post">
		            <div class="form-group">
		                <label>아이디</label>
		                <input type="text" name="id" value="${id}" readonly />
		            </div>
		
		            <div class="form-group">
		                <label>이름</label>
		                <input type="text" name="name" value="${name}"  />
		            </div>
		
		            <div class="form-group">
		                <label>이메일</label>
		                <input type="text" name="email" value="${email}" readonly />
		            </div>
					
										
					<button type="submit" class="btn-submit"><i class="fa-solid fa-floppy-disk"></i>프로필 저장</button>
					
					
					
					<!-- 텍스트 에러 표시 -->
				      <c:if test="${not empty profileMsg}">
				        <p class="${profileOk ? 'msg-success':'msg-error'}">${profileMsg}</p>
				      </c:if>
				      
				    <!-- 상단 에러 표시 -->  
				      <c:if test="${not empty profileMsg}">
						  <script>
						    ui.${profileOk ? 'success' : 'error'}("<c:out value='${profileMsg}'/>");
						  </script>
						</c:if>

				    </form>
				  </div>
		
		<div class="content">
			<!-- 비밀번호 변경 -->
			  <div class="content">
			    <div class="card-header">
			      <div class="avatar"><i class="fa-solid fa-key"></i></div>
			      <div class="section-title">비밀번호 변경</div>
		    </div>
			 
			
				  <form action="${ctx}/account/mypage/change-password" method="post" style="margin-bottom:16px;">
			        <div class="form-group">
			          <label>현재 비밀번호</label>
					    <input type="password" name="currentPw" required autocomplete="current-password" />
					  </div>
			        
		            <div class="form-group">
		                <label>새 비밀번호</label>
		                <input type="password" name="newPw" required autocomplete="new-password" />
 					 </div>
		
		            <div class="form-group">
		                <label>비밀번호 확인</label>
		                <input type="password" name="newPwCheck" required autocomplete="new-password" />
 					 </div>
		
		            <button type="submit" class="btn-submit">비밀번호 변경</button>
		       
		       		 <!-- 비밀번호변경 유효성 검사 -->        
		        	<c:if test="${msg eq '비밀번호가 성공적으로 변경되었습니다.'}"> 
					    <p style="color: green;">${msg}</p>
					</c:if>
					<c:if test="${msg eq '비밀번호가 일치하지 않습니다.'}">
					    <p style="color: red;">${msg}</p>
					</c:if>
		
		        
		        <!-- 텍스트 에러 표시 -->
		        	<c:if test="${not empty pwMsg}">
			          <p class="${pwOk ? 'msg-success':'msg-error'}">${pwMsg}</p>
			        </c:if>
			        
			    <!-- 상단 에러 표시 -->				        		
			    	<c:if test="${not empty pwMsg}">
					  <script>
					    ui.${pwOk ? 'success' : 'error'}("<c:out value='${pwMsg}'/>");
					  </script>
					</c:if>
			    				        		
			    				     
			    	<c:if test="${not empty globalMsg}">
					  <script> ui.success("<c:out value='${globalMsg}'/>"); </script>
					</c:if>
									    				     
			    				        		
		        
		        </form>
		        
		        
		        	<!-- 로그아웃 -->
			
		        	<form action="${ctx}/account/logout" method="post" onsubmit="return confirmLogout(event)">
		        	  <button type="submit" class="logout-btn">로그아웃</button>
		        	</form>
		    </div>
	</div>
		   
	
			
			 
		   
</body>
</html>