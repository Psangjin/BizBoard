<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#memo-body-container{
	width: 93vw;
	height: 88vh;
}
#title-area{
	width: 100%;
	height: 10vh;
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: red;
}
#memo-btn-area{
	width: 98%;
	height: 5vh;
	display: flex;
	justify-content: space-between;
	margin-left: 10px;
	margin-right: 10px;
}
#memo-area{
	width: 100%;
	height: 73vh;
	background-color: beige;
}
.memo-row{
	width: 100%;
	height: 20vh;
	
}
</style>
</head>
<body>
	 <%@ include file="../include/layout.jsp" %>	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->
	
			<!-- 바디 페이지 -->
			<div id="memo-body-container">
				<div id="title-area">
					<h1>프로젝트1</h1>
				</div>
				<div id="memo-btn-area">
					<button id="add-memo" class="btn btn-primary">새 메모</button>
					<select id="memo-orderby" aria-label="메모 선택">
						<option selected>수정날짜순</option>
						<option>등록날짜순</option>
					</select>
				</div>
				<div id="memo-area">
					 <c:forEach var="shareMemo" items="${shareMemoList} varStatus="status">
					 	   	 <c:if test="${status.index % 3 == 0}">
								<div class="memo-row">
							 </c:if>
								<div class="memo-element">
									<div class="memo-content">
										<div class="delete-memo-btn-area">
											<button class="delete-memo-btn btn btn-secondary">편집</button>
										</div>
									</div>
									<div class="memo-info">
										<h2>${shareMemo.title}</h2>
										<p>${shareMemo.modifytime}</p>
									</div>
								</div>
							 <c:if test="${status.index % 3 == 2 || status.last}">
							 	</div>
							 </c:if>
					 </c:forEach>
				</div>
			</div>
		</div>
	</div>
</body>
</html>