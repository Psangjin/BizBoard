<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="/css/pricing.css">
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	
	<div class="pricing-intro">
		<p>| 이용요금 |</p>
		<h1>효율적인 협업의 시작,<br> BizBoard로 팀워크를 설계하세요</h1>
		<p>지금 바로 30일 무료 평가판으로 체험해보세요.</p>
	</div>
	
	<div class="pricing-info">
		<div class="pricing-free pricing-border">
			<p>무료</p>
			<span>0원</span><br>
			<span>최대 5인의 사용자</span>
		</div>
		
		<div class="pricing-basic pricing-border">
			<p>베이직</p>
			<span>1,800원</span><span>/월별, 1인당</span><br>
			<span>최대 10인의 사용자</span><br>
		</div>
		
		<div class="pricing-standard pricing-border">
			<p>스탠다드</p>
			<span>2,300원</span><span>/월별, 1인당</span><br>
			<span>10인 이상의 사용자</span><br>
		</div>
	</div>
	
	<!-- * 위 금액은 1인 기준 월간 사용 요금이며, VAT(부가세)가 별도 부과됩니다. -->
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>