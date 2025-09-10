<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 이동</title>
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        background-color: #f4f4f4;
    }

    .button-container {
        display: flex;
        flex-direction: column;
        gap: 20px;
        padding: 40px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    button {
        width: 300px;
        padding: 15px;
        font-size: 16px;
        font-weight: bold;
        color: #fff;
        background-color: #007bff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    button:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
    }

    button:active {
        background-color: #004085;
        transform: translateY(0);
    }

    .form-button {
        background-color: #28a745;
    }

    .form-button:hover {
        background-color: #218838;
    }
</style>
</head>
<body>

<div class="button-container">
    <button onclick="location.href='${pageContext.request.contextPath}/admin/home.do'">
        관리자 홈으로 이동     
    </button>
    <button onclick="location.href='<c:url value='/join.do'/>'">
        회원가입
    </button>
    <button onclick="location.href='<c:url value='/login.do'/>'">
        로그인
    </button>
</div>

</body>
</html>