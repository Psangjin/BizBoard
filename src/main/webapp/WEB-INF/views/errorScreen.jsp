<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - 허가되지 않음</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/errorScreen.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            </div>

        <div class="main-content">
            <header class="header">
                 <img class="logo-image" src="${pageContext.request.contextPath}/resources/images/logo2.png" alt="BizBoard 로고" />
            </header>

            <div class="error-container">
                <h1 class="error-code">Error</h1>
                
                <div class="warning-box">
                    <h2 class="warning-title">경고</h2>
                    	
                    <div class="warning-message">
                           <img class="error-image" src="${pageContext.request.contextPath}/resources/images/subtract.png" alt="경고로고" />
                        <p>허가되지 않는 프로젝트입니다.<br>프로젝트를 보기 위해선<br>프로젝트 관계자의 허가가 필요합니다.</p>
                    </div>
                </div>

                <button class="confirm-button">확인</button>
            </div>
        </div>
    </div>
</body>
</html>