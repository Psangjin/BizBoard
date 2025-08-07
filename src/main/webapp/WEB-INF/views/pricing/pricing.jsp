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
		<p id="pricing-usage-fee">| 이용요금 |</p>
		<span>효율적인 협업의 시작,<br> BizBoard로 팀워크를 설계하세요</span>
		<p id="pricing-free-use">사용자 수에 따라 합리적으로 — 기능은 모두 제공합니다.</p>
	</div>
	
	<div class="pricing-info">
		<div class="pricing-free pricing-border">
			<span class="pricing-tier">무료</span><br>
			<span class="pricing-price">₩0</span>
			<span class="pricing-note"> / 평생</span><br>
			<span class="pricing-max-users">최대 5인까지</span>
			<div class="pricing-seperate-line"></div>
		</div>
		
		<div class="pricing-basic pricing-border">
			<span class="pricing-tier">베이직</span><br>
			<span class="pricing-price">₩1,800</span>
			<span class="pricing-note"> / 월, 1인당</span><br>
			<span class="pricing-max-users">최대 10인까지</span><br>
			<div class="pricing-seperate-line"></div>
		</div>
		
		<div class="pricing-standard pricing-border">
			<span class="pricing-tier">스탠다드</span><br>
			<span class="pricing-price">₩2,300</span>
			<span class="pricing-note"> / 월, 1인당</span><br>
			<span class="pricing-max-users">10인 이상</span><br>
			<div class="pricing-seperate-line"></div>
		</div>
	</div>
	
	<!-- * 위 금액은 1인 기준 월간 사용 요금이며, VAT(부가세)가 별도 부과됩니다. -->
	
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>