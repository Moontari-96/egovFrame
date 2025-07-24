<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 로그인</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #f9f9f9;
            padding: 50px;
        }
        .login-box {
            width: 400px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        .login-box input[type=text],
        .login-box input[type=password] {
            width: 100%;
            padding: 10px;
            margin: 8px 0 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .login-box input[type=submit] {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: #fff;
            border: none;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
        }
        .error {
            color: red;
            font-size: 13px;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<script>
	const contextPath = "${pageContext.request.contextPath}";
	function submitLogin() {
		try {
            const user_id = document.getElementById("user_id").value.trim();
            const user_pw = document.getElementById("user_pw").value.trim();
            const formData = new URLSearchParams();
            formData.append("user_id", user_id);
            formData.append("user_pw", user_pw);
            
            fetch(contextPath + "/auth/loginProc.do", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: formData.toString()
            })
            .then(response => response.text())
			.then(raw => {
			    try {
			        const data = JSON.parse(raw);
			        console.log(data)
			        if (!data.token) {
			            alert(data.message || "로그인 실패");
			        } else {
			            alert(data.message);
			            localStorage.setItem("jwt", data.token);
			            location.href = contextPath + "/home.do";
			        }
			    } catch (e) {
			        console.error("HTML 응답으로 오류 발생\n", raw);
			        alert("서버에서 유효하지 않은 응답을 보냈습니다.");
			    }
			})
		} catch (e) {
			// TODO: handle exception
		}
	}
</script>
<body>
    <div class="login-box">
        <h2>사용자 로그인</h2>
            <label for="user_id">아이디</label>
            <input type="text" id="user_id" name="user_id" required />

            <label for="user_pw">비밀번호</label>
            <input type="password" id="user_pw" name="user_pw" required />

            <c:if test="${not empty errorMsg}">
                <div class="error">${errorMsg}</div>
            </c:if>
            <input type="button" value="로그인" onclick="submitLogin()"/>
    </div>
</body>
</html>
