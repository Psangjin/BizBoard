<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Error</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/error404page.css">
</head>
<body>
    <div class="container">
        <div class="inner-container">
      
            <div class="shape yellow-rect-1"></div>
            <div class="shape pink-rect-1"></div>
            <div class="shape blue-rect-1"></div>
            <div class="shape yellow-rect-2"></div>
            <div class="shape pink-rect-2"></div>
            <div class="shape yellow-rect-3"></div>
            <div class="shape blue-rect-2"></div>
            <div class="shape yellow-rect-4"></div>

            <!-- 404 숫자 -->
            <div class="error-number">404</div>

            <!-- 메시지 -->
            <div class="message-box">
                <div class="message-text">"404. This board does not exist".</div>
                <div class="sub-message">"Please check the board again or go to the main page."</div>
            </div>

            <!-- BizBoard 로고 -->
            <a href="/" class="bizboard-logo">
               
               
               <img src="${pageContext.request.contextPath}/resources/image/BizBoard_Logo.png" alt="BizBoard" class="logo-image">
            </a>
        </div>
    </div>
</body>
</html>