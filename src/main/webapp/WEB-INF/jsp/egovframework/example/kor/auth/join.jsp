<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
    body { font-family: sans-serif; background: #f3f3f3; padding: 50px; }
    .join-box { width: 500px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    .join-box h2 { margin-bottom: 20px; }
    .join-box label { display: block; margin-top: 10px; }
    .join-box input[type=text], .join-box input[type=password], .join-box input[type=email] {
        width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px;
    }
    .join-box input[type=button] {
        margin-top: 20px; width: 100%; padding: 10px; background: #28a745; border: none;
        color: #fff; font-weight: bold; border-radius: 4px; cursor: pointer;
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
            <input type="text" id="post_code" name="post_code" readonly required />
            <input type="button" onclick="execDaumPostcode()" value="주소 검색" style="margin-top:5px;" />

            <label for="address">주소</label>
            <input type="text" id="address" name="address" readonly required />

            <label for="address_detail">상세 주소</label>
            <input type="text" id="address_detail" name="address_detail" required />

            <input type="button" value="회원가입 완료" onclick="submitJoinForm()" />
        </div>
    </div>
</body>
</html>
