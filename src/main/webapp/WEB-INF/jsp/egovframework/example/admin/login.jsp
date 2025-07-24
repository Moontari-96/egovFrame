<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인</title>
<style>
        body { font-family: sans-serif; background: #f3f3f3; padding: 50px; }
        .login-box { width: 400px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .login-box h2 { margin-bottom: 20px; }
        .login-box input[type=text],
        .login-box input[type=password] {
            width: 100%; padding: 10px; margin: 5px 0 15px; border: 1px solid #ccc; border-radius: 4px;
        }
        .login-box input[type=submit] {
            width: 100%; padding: 10px; background: #007bff; border: none; color: #fff; font-weight: bold;
            cursor: pointer; border-radius: 4px;
        }
        .error { color: red; font-size: 12px; margin-top: -10px; margin-bottom: 10px; }
    </style>
</head>
<body>
	<div class="login-box">
        <h2>관리자 로그인</h2>
        <form action="<c:url value='/admin/user/login.do'/>" method="post">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" required />

            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" required />

            <c:if test="${not empty errorMsg}">
                <div class="error">${errorMsg}</div>
            </c:if>

            <input type="submit" value="로그인" />
    		<input type="button" value="회원가입" onclick="location.href='<c:url value='/admin/user/join.do'/>'" />
        </form>
    </div>
</body>
</html>