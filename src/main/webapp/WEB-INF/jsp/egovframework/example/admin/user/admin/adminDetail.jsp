<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상세</title>
  <link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
</head>
<body>

 <c:set var="isEdit" value="${not empty admin and not empty admin.id}" />

<div class="card">
  <div class="post-content">

    <div class="form-group">
      <label for="f_userId">ID</label>
      <input id="f_userId" name="userId" type="text"
             value="${isEdit ? admin.user_id : ''}"
             placeholder="아이디 입력"
             <c:if test='${isEdit}'>readonly</c:if> required>
    </div>

    <div class="form-group">
      <label for="f_password">PW</label>
      <input id="f_password" name="password" type="password"
             value="" placeholder="비밀번호 입력(수정 시 미입력 유지 가능)">
    </div>

    <div class="form-group">
      <label for="f_userName">이름</label>
      <input id="f_userName" name="userName" type="text"
             value="${isEdit ? admin.user_name : ''}"
             placeholder="이름 입력" required>
    </div>

    <div class="form-group">
      <label for="f_userEmail">이메일</label>
      <input id="f_userEmail" name="userEmail" type="email"
             value="${isEdit ? admin.user_email : ''}"
             placeholder="example@domain.com" required>
    </div>

  	<div class="form-group">
	  <label for="f_userStatus">상태</label>
	  <select id="f_userStatus" name="userStatus" class="select-field" required>
	    <option value="active" ${isEdit ? (admin.user_status == 'active' ? 'selected' : '') : ''}>active</option>
	    <option value="dormant" ${isEdit ? (admin.user_status == 'dormant' ? 'selected' : '') : ''}>dormant</option>
	    <option value="black" ${isEdit ? (admin.user_status == 'black' ? 'selected' : '') : ''}>black</option>
	  </select>
	</div>
	
    <div class="form-group">
	  <label for="f_roleName">권한</label>
	  <select id="f_roleName" name="roleName" class="select-field" required>
	    <c:forEach var="role" items="${roles}">
	      <option value="${role.id}" ${isEdit && role.roleName == admin.role_name ? 'selected' : ''}>
	        ${role.roleName}
	      </option>
	    </c:forEach>
	  </select>
	</div>
  </div>

  <div class="post-actions">
    <a href="<c:url value='/admin/menu/adminList.do'/>" class="btn btn-list">목록</a>
    <c:if test="${isEdit}">
      <button id="updateBtn" type="button" class="btn btn-edit">수정</button>
      <button id="deleteBtn" type="button" class="btn btn-delete"
              data-user-id="${admin.id}">삭제</button>
    </c:if>

    <c:if test="${not isEdit}">
      <button id="createBtn" type="button" class="btn btn-edit">등록</button>
    </c:if>
  </div>
</div>
<script>
(function(){
    const btn = document.getElementById('createBtn');
    if(!btn) return;
    btn.addEventListener('click', async () => {
      if (!ck) { alert('에디터 초기화 중입니다.'); return; }
      const payload = {
  		userId: "<c:out value='${userId}'/>",
        pw: document.getElementById('title').value.trim(),
        content: ck.getData()
      };
      if (!payload.title) { alert('제목을 입력하세요.'); return; }
	  console.log(payload)
      /* try {
        const res = await fetch("<c:url value='/admin/board/createPost.do'/>", {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        const text = await res.text();
        if (!res.ok) throw new Error(text || '등록 실패');
        alert('등록 완료!');
        // 서버가 {postId: N}을 내려주는 경우 상세/편집으로 이동
        let newId = null; try { newId = JSON.parse(text).postId; } catch(e){}
        
        if (newId) {
          location.href = "<c:url value='/admin/board/form.do'/>" + "?postId=" + encodeURIComponent(newId);
        } else {
          location.href = "<c:url value='/admin/board/${boardId}.do'/>";
        }
      } catch (err) {
        console.error(err);
        alert('등록에 실패했습니다: ' + err.message);
      } */
    });
  })();

</script>
</body>
</html>
