<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 회원가입</title>
<style>
/* 모든 요소에 박스사이징 적용 */
* {
    box-sizing: border-box;
}

    body {
    font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
    background: #eef1f5;
    padding: 50px;
    margin: 0;
}

.join-box {
    width: 420px;
    margin: auto;
    background: #fff;
    padding: 40px 30px;
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.08);
    transition: box-shadow 0.2s ease-in-out;
}
.join-box:hover {
    box-shadow: 0 8px 28px rgba(0,0,0,0.12);
}

.join-box h2 {
    margin-bottom: 25px;
    font-size: 22px;
    font-weight: bold;
    text-align: center;
    color: #333;
}

.join-box label {
    display: block;
    margin-top: 15px;
    font-weight: 600;
    font-size: 14px;
    color: #444;
}

.join-box input[type=text],
.join-box input[type=password],
.join-box input[type=email] {
    width: 100%;
    padding: 12px;
    margin-top: 6px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.join-box input[type=text]:focus,
.join-box input[type=password]:focus,
.join-box input[type=email]:focus {
    border-color: #4dabf7;
    box-shadow: 0 0 5px rgba(77, 171, 247, 0.4);
    outline: none;
}

.join-box input[type=button] {
    margin-top: 22px;
    width: 100%;
    padding: 12px;
    background: #4dabf7;
    border: none;
    color: #fff;
    font-weight: bold;
    border-radius: 6px;
    cursor: pointer;
    font-size: 15px;
    transition: background 0.2s ease, transform 0.1s ease;
}
.join-box input[type=button]:hover {
    background: #339af0;
}
.join-box input[type=button]:active {
    transform: scale(0.98);
}

.postcode-box {
    display: flex;
    gap: 8px;
    margin-top: 6px;
}

.postcode-box input {
    flex: 1;
    height: 44px; /* ✅ 높이 고정 */
    padding: 0 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
}

.postcode-box button {
    height: 44px; /* ✅ input과 동일하게 */
    padding: 0 16px; /* 가로 padding만 */
    background: #4dabf7;
    border: none;
    border-radius: 6px;
    color: #fff;
    font-weight: bold;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s ease;
    margin-top: 6px;
    
}


.postcode-box button:hover {
    background: #339af0;
}
</style>

<!-- 카카오 주소 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('post_code').value = data.zonecode;
                document.getElementById('address').value = data.roadAddress;
                document.getElementById('address_detail').focus();
            }
        }).open();
    }

    function submitJoinForm() {
        try {
            const id = document.getElementById("id").value.trim();
            const email = document.getElementById("user_email").value.trim();
            const pw = document.getElementById("user_pw").value.trim();
            const name = document.getElementById("user_name").value.trim();
            const postCode = document.getElementById("post_code").value.trim();
            const address = document.getElementById("address").value.trim();
            const addressDetail = document.getElementById("address_detail").value.trim();

            if (!/^[a-zA-Z0-9_]{5,20}$/.test(id)) {
                alert("아이디는 5~20자의 영문/숫자/언더스코어만 가능합니다.");
                return;
            }

            if (!/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/.test(email)) {
                alert("올바른 이메일 형식이 아닙니다.");
                return;
            }

            if (pw.length < 6) {
                alert("비밀번호는 최소 6자리 이상이어야 합니다.");
                return;
            }

            if (name.length === 0) {
                alert("이름을 입력해주세요.");
                return;
            }

            const formData = new URLSearchParams();
            formData.append("user_id", id);
            formData.append("user_email", email);
            formData.append("user_pw", pw);
            formData.append("user_name", name);
            formData.append("post_code", postCode);
            formData.append("address", address);
            formData.append("address_detail", addressDetail);

            fetch(contextPath + "/auth/joinProc.do", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: formData.toString()
            })
            .then(response => {
                if (!response.ok) throw new Error("서버 오류");
                return response.text();
            })
            .then(data => {
                alert("회원가입이 완료되었습니다.");
                location.href = contextPath + "/admin/user/login.do";
            })
            .catch(error => {
                alert("회원가입 실패: " + error.message);
                console.error("fetch 에러:", error);
            });

        } catch (e) {
            alert("예상치 못한 오류 발생: " + e.message);
            console.error("예외 발생:", e);
        }
    }
</script>
</head>
<body>
    <div class="join-box">
        <h2>회원가입</h2>
        <!-- ✅ form 제거: 기본 제출 차단 -->
        <div>
            <label for="id">아이디</label>
            <input type="text" id="id" name="user_id" required />

            <label for="user_email">이메일</label>
            <input type="email" id="user_email" name="user_email" required />

            <label for="user_pw">비밀번호</label>
            <input type="password" id="user_pw" name="user_pw" required />

            <label for="user_name">이름</label>
            <input type="text" id="user_name" name="user_name" required />
			
            <label for="post_code">우편번호</label>
	        <div class="postcode-box">
	            <input type="text" id="post_code" name="post_code" readonly required />
	            <button type="button" onclick="execDaumPostcode()">주소 검색</button>
	        </div>
	        
            <label for="address">주소</label>
            <input type="text" id="address" name="address" readonly required />

            <label for="address_detail">상세 주소</label>
            <input type="text" id="address_detail" name="address_detail" required />

            <input type="button" value="회원가입 완료" onclick="submitJoinForm()" />
        </div>
    </div>
</body>
</html>
