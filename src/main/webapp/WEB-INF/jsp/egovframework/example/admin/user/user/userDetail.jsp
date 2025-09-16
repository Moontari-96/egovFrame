<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사용자 상세</title>
  <link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
</head>
<body>

<%-- 서버에서 user(상세), roles(권한목록)을 모델로 내려준다 가정 --%>
<c:url var="LIST_URL"   value="/admin/user/userList.do"/>
<c:url var="UPDATE_URL" value="/admin/user/userUpdate.do"/>
<c:url var="DELETE_URL" value="/admin/user/userDelete.do"/>

<div class="card">
  <h2>사용자 상세</h2>

  <div class="post-content">

    <input type="hidden" id="f_id" value="${user.id}"/>

    <div class="form-group">
      <label for="f_userId">ID</label>
      <input id="f_userId" name="userId" type="text"
             value="${user.user_id}" placeholder="아이디" required readonly autocomplete="off"/>
    </div>

    <div class="form-group">
      <label for="f_password">PW (수정 시에만 입력)</label>
      <input id="f_password" name="password" type="password" value="" placeholder="미입력 시 비밀번호 변경 없음"/>
    </div>

    <div class="form-group">
      <label for="f_userName">이름</label>
      <input id="f_userName" name="userName" type="text"
             value="${user.user_name}" placeholder="이름 입력" required/>
    </div>

    <div class="form-group">
      <label for="f_userEmail">이메일</label>
      <input id="f_userEmail" name="userEmail" type="email"
             value="${user.user_email}" placeholder="example@domain.com" required/>
    </div>

    <div class="form-group">
      <label for="f_userStatus">상태</label>
      <select id="f_userStatus" name="userStatus" class="select-field" required>
        <option value="active"  ${user.user_status == 'active'  ? 'selected' : ''}>active</option>
        <option value="dormant" ${user.user_status == 'dormant' ? 'selected' : ''}>dormant</option>
        <option value="black"   ${user.user_status == 'black'   ? 'selected' : ''}>black</option>
      </select>
    </div>
  </div>

  <div class="post-actions">
    <a href="${LIST_URL}" class="btn btn-list">목록</a>
    <button id="updateBtn" type="button" class="btn btn-edit">수정</button>
    <button id="deleteBtn" type="button" class="btn btn-delete" data-user-id="${user.id}">삭제</button>
  </div>
</div>

<script>
  // CSRF (있으면 자동 포함)
  var csrfParam = '${_csrf != null ? _csrf.parameterName : ''}';
  var csrfToken = '${_csrf != null ? _csrf.token : ''}';

  var LIST_URL   = '${LIST_URL}';
  var UPDATE_URL = '${UPDATE_URL}';
  var DELETE_URL = '${DELETE_URL}';

  var elId     = document.getElementById('f_id');
  var elUserId = document.getElementById('f_userId');
  var elPw     = document.getElementById('f_password');
  var elName   = document.getElementById('f_userName');
  var elEmail  = document.getElementById('f_userEmail');
  var elStatus = document.getElementById('f_userStatus');

  function qs(url, obj){
    var p = new URLSearchParams(obj||{});
    return url + (url.indexOf('?')>=0?'&':'?') + p.toString();
  }

  function validateForUpdate() {
    var idVal = (elId.value || '').trim();
    if (!idVal) { alert('대상 사용자 ID가 없습니다.'); return false; }

    var email = elEmail.value.trim();
    var pw    = elPw.value;
    var name  = elName.value.trim();

    if (!/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/.test(email)) { alert('올바른 이메일 형식이 아닙니다.'); elEmail.focus(); return false; }
    if (pw && pw.length < 6) { alert('비밀번호는 최소 6자리 이상이어야 합니다.'); elPw.focus(); return false; }
    if (!name) { alert('이름을 입력해주세요.'); elName.focus(); return false; }
    return true;
  }

  // 수정
  (function(){
    var btn = document.getElementById('updateBtn');
    if(!btn) return;
    btn.addEventListener('click', async function(){
      if (!validateForUpdate()) return;

      var payload = {
        id: elId.value,
        userName: elName.value.trim(),
        userEmail: elEmail.value.trim(),
        userStatus: elStatus.value,
      };
      // 비밀번호가 비어있지 않을 때만 포함 (서버에서 동적 UPDATE)
      if (elPw.value) payload.userPw = elPw.value;

      var url = UPDATE_URL;
      if (csrfParam && csrfToken) url = qs(url, (function(o){ o[csrfParam]=csrfToken; return o;})({}));

      try {
        var res = await fetch(url, {
          method:'POST',
          headers:{ 'Content-Type':'application/json', 'Accept':'application/json' },
          body: JSON.stringify(payload)
        });
        if (!(res.status>=200 && res.status<300)) { throw new Error('HTTP '+res.status); }
        alert('저장되었습니다.');
        location.href = LIST_URL;
      } catch(e) {
        console.error(e);
        alert('저장 실패: ' + (e.message||''));
      }
    });
  })();

  // 삭제
  (function(){
    var btn = document.getElementById('deleteBtn');
    if(!btn) return;
    btn.addEventListener('click', async function(){
      if (!confirm('정말 삭제하시겠습니까?')) return;

      var userId = btn.dataset.userId;
      if (!userId) { alert('삭제 대상이 없습니다.'); return; }

      // 쿼리스트링로 id 전달 (POST 권장)
      var url = qs(DELETE_URL, { id: userId });
      if (csrfParam && csrfToken) url = qs(url, (function(o){ o[csrfParam]=csrfToken; return o;})({}));

      try {
        var res = await fetch(url, { method: 'POST', headers: { 'Accept': 'text/plain' } });
        var txt = await res.text();
        if (!(res.status>=200 && res.status<300)) { throw new Error(txt||'삭제 실패'); }
        alert('삭제되었습니다.');
        location.href = LIST_URL;
      } catch (e) {
        console.error(e);
        alert('삭제 중 오류가 발생했습니다.');
      }
    });
  })();
</script>
</body>
</html>
