<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
<script>
    window.onload = function() {
        alert("${message}");
        location.href = "${pageContext.request.contextPath}${redirecter}";

    }
</script>
</head>
<body>
</body>
</html>
