<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>BizBoard</title>
  <link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	crossorigin="anonymous" referrerpolicy="no-referrer" />
  <style>
 

.body-container {
	width: 90vw;
	flex: 1;
	display: flex;
	padding: 5px;
}
    .progress-container {
      width: 200px;
      margin: 50px auto;
      text-align: center;
      font-family: Arial, sans-serif;
    }

    svg {
      display: block;
      margin: 0 auto;
    }

    circle {
      fill: none;
      stroke-width: 20;
    }

    .bg {
      stroke: #eee;
    }

    .progress {
      stroke: #00aaff;
      stroke-linecap: round;
      transform: rotate(-90deg);
      transform-origin: center;
      transition: stroke-dashoffset 0.35s;
    }

    .center-text {
      font-size: 24px;
      font-weight: bold;
      fill: #333;
      dominant-baseline: middle;
      text-anchor: middle;
    }

    .buttons {
      margin-top: 20px;
    }

    .buttons button {
      padding: 8px 14px;
      margin: 0 5px;
      font-size: 16px;
      border: none;
      border-radius: 6px;
      background-color: #007bff;
      color: white;
      cursor: pointer;
    }

    .buttons button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

 <%@ include file="../include/layout.jsp" %>	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->
			
			<!-- 바디 페이지(컨텐츠) -->
			<div class="body-container">
				<div class="progress-container">
			    <svg width="120" height="120">
			      <!-- 배경 원 -->
			      <circle class="bg" r="50" cx="60" cy="60" />
			      <!-- 진행 원 -->
			      <circle class="progress" id="progress-circle" r="50" cx="60" cy="60" 
			        stroke-dasharray="314" stroke-dashoffset="314" />
			      <!-- 중앙 텍스트 -->
			      <text id="percentText" class="center-text" x="60" y="60">0%</text>
			    </svg>
			
			    <div class="buttons">
			      <button onclick="changeProgress(-10)">-10%</button>
			      <button onclick="changeProgress(10)">+10%</button>
			    </div>
			  </div>
			</div>
		</div>
	</div>
</div>
  <script>
  
  const circle = document.getElementById('progress-circle');
  let text = document.getElementById('percentText');
  const radius = circle.r.baseVal.value;
  const circumference = 2 * Math.PI * radius;
  let currentPercent = 0;

  function setProgress(percent) {
    const offset = circumference - (percent / 100) * circumference;
    circle.style.strokeDashoffset = offset;
    text.textContent = percent + '%';
  }

  function changeProgress(change) {
    currentPercent = Math.min(100, Math.max(0, currentPercent + change));
    setProgress(currentPercent);
  }

  setProgress(currentPercent);
    
  </script>

</body>
</html>