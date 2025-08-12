<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 및 FAQ</title>
    <link rel="stylesheet" href="/css/inquiryFAQ.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <a href="${pageContext.request.contextPath}/">
                <img class="logo-image" src="/image/logo2.png" alt="BizBoard 로고" />
            </a>
            <h2>문의하기</h2>
            <div class="sidebar-menu">
                <hr />
                <a href="#" class="current-page">자주 묻는 질문</a>
                <hr />
                <a href="/inquiryOne">1 : 1 문의</a>
            </div>
        </div>
        <div class="content">
            <h1 class="faq-title">자주묻는 질문</h1>

            <div class="faq-item">
                <div class="faq-question">Q1. 비밀번호를 잊어버렸습니다.</div>
                <div class="faq-answer">
                    A1. 비밀번호찾기에서 찾을수 있습니다. 
                    <br>가입시 적은 아이디와 Email로 인증 후 새로운 비밀번호를 전송합니다.</br>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">Q2. 무료 플랜과 유료 플랜의 차이점을 알고 싶습니다.</div>
                <div class="faq-answer">
                    A2.
                    <table class="plan-table">
                        <thead>
                            <tr>
                                <th>플랜명</th>
                                <th>가격 예시</th>
                                <th>주요 기능</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Free Plan</td>
                                <td>무료</td>
                                <td>
                                    프로젝트 1개만 생성 가능<br />
                                    팀원수 제한(최대5인)<br />
                                    광고 노출
                                </td>
                            </tr>
                            <tr>
                                <td>Basic Plan</td>
                                <td> ₩ 1,800/ 인당</td>
                                <td>
                                    프로젝트 무제한<br />
                                    팀장 권한 관리<br />
                                    알림 기능 전체 사용
                                </td>
                            </tr>
                            <tr>
                                <td>Standard Plan</td>
                                <td> ₩ 2,300/ 인당(최대 20인)</td>
                                <td>
                                    Pro 팀 플랜 기능 포함<br />
                                    팀 통계 대시보드 백업/복구<br />
                                    역할세분화, SLA 지원
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>