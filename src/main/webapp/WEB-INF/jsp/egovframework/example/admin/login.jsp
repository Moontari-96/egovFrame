<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인</title>
<style>
		/* 기본 리셋 */
		* {
		    box-sizing: border-box;
		    margin: 0;
		    padding: 0;
		}
        body { font-family: sans-serif; background: #f3f3f3; padding: 50px; }
        .login-box { width: 400px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .login-box h2 { margin-bottom: 20px; }
        .login-box input[type=text],
        .login-box input[type=password] {
            width: 100%; padding: 10px; margin: 5px 0 15px; border: 1px solid #ccc; border-radius: 4px;
        }
        .login-box input[type=button] {
            width: 100%; padding: 10px; background: #007bff; border: none; color: #fff; font-weight: bold;
            cursor: pointer; border-radius: 4px;
        }
        .error { color: red; font-size: 12px; margin-top: -10px; margin-bottom: 10px; }
    </style>
</head>
<body>
	<div class="login-box">
	    <h2>관리자 로그인</h2>
	    <form id="loginForm">
	        <label for="username">아이디</label>
	        <input type="text" id="username" name="username" required />
	
	        <label for="password">비밀번호</label>
	        <input type="password" id="password" name="password" required />
	
	        <div class="error" id="errorMsg" style="color:red;"></div>
	
	        <input type="button" value="로그인" onclick="submitLogin()" />
	    </form>
	</div>
</body>
<script>
	function submitLogin() {
	    const form = document.getElementById('loginForm');
	    const data = new URLSearchParams(new FormData(form));
	
	    fetch('<c:url value="/admin/user/login.do"/>', {
	        method: 'POST',
	        body: data
	    })
	    .then(res => res.json())
	    .then(resp => {
	        if(resp.success) {
	            // JWT 저장 (예: localStorage)
	            localStorage.setItem('jwt', resp.token);
	
	            // 로그인 성공 시 홈으로 이동
	            window.location.href = '<c:url value="/admin/home.do"/>';
	        } else {
	            document.getElementById('errorMsg').innerText = resp.msg;
	        }
	    })
	    .catch(err => {
	        console.error(err);
	        document.getElementById('errorMsg').innerText = '로그인 중 오류가 발생했습니다.';
	    });
	}
</script>
</html>