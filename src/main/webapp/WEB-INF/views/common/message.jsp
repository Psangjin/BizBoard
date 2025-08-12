<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    // 1) 백틱 + escapeXml=false (HTML 허용)
    var msg = `<c:out value='${message}' escapeXml='false'/>`;
    var target = "${pageContext.request.contextPath}${redirecter}";

    if (window.Swal) {
      Swal.fire({
        // 2) text → html 로 변경 (줄바꿈/굵게/링크 등 HTML 지원)
        html: msg,
        icon: 'success',
        position: 'top',
        toast: true,
        timer: 2000,
        showConfirmButton: false
      }).then(function () {
        location.href = target;
      });
    } else {
      // 폴백: <br> → \n
      alert(msg.replace(/<br\s*\/?>/gi, '\n'));
      location.href = target;
    }
  });
</script>
</head>
<body></body>
</html>
