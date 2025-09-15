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
<%-- 엔드포인트 URL들 (프로젝트 경로에 맞게 조정하세요) --%>
<c:url var="LIST_URL"    value="/admin/user/adminList.do"/>
<c:url var="CHECK_ID_URL" value="/admin/user/checkId.do"/>
<c:url var="CREATE_URL"   value="/admin/user/adminCreate.do"/>
<c:url var="UPDATE_URL"   value="/admin/user/adminuUdate.do"/>
<c:url var="DELETE_URL"   value="/admin/user/adminDelete.do"/>

<div class="card">
  <div class="post-content">

    <div class="form-group">
	  <label for="f_userId">ID</label>
	  <div class="id_check_box">
	    <input id="f_userId"
	           name="userId"
	           type="text"
	           placeholder="아이디 입력"
	           value="${isEdit ? admin.user_id : ''}"
	           ${isEdit ? 'readonly' : ''}
	           required
	           autocomplete="off" />
	    <c:if test="${not isEdit}">
	      <button id="btnCheckId" type="button" class="btn btn-outline btn-sm">아이디 중복확인</button>
	      <small id="idHint" class="hint"></small>
	    </c:if>
	  </div>
	</div>

    <div class="form-group">
      <label for="f_password">PW</label>
      <input id="f_password" name="password" type="password"
             value="" placeholder="비밀번호 입력(수정 시 미입력 가능)">
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
    <a href="<c:url value='/admin/user/adminList.do'/>" class="btn btn-list">목록</a>
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
  // CSRF (있으면 자동 포함)
  var csrfParam = '${_csrf != null ? _csrf.parameterName : ''}';
  var csrfToken = '${_csrf != null ? _csrf.token : ''}';

  var IS_EDIT = ${isEdit ? 'true' : 'false'};
  var CHECK_ID_URL = '${CHECK_ID_URL}';
  var CREATE_URL   = '${CREATE_URL}';
  var UPDATE_URL   = '${UPDATE_URL}';
  var LIST_URL     = '${LIST_URL}';
  var DELETE_URL     = '${DELETE_URL}';

  var elUserId = document.getElementById('f_userId');
  var elPw     = document.getElementById('f_password');
  var elName   = document.getElementById('f_userName');
  var elEmail  = document.getElementById('f_userEmail');
  var elStatus = document.getElementById('f_userStatus');
  var elRole   = document.getElementById('f_roleName');
  var idHint   = document.getElementById('idHint');

  var idChecked = false;
  var lastCheckedId = '';

  function qs(url, obj){
    var p = new URLSearchParams(obj||{});
    return url + (url.indexOf('?')>=0?'&':'?') + p.toString();
  }

  // 아이디 형식/이메일/비밀번호/이름 검증
  function validateCommon(isCreate){
    var id = elUserId.value.trim();
    var email = elEmail.value.trim();
    var pw = elPw.value;
    var name = elName.value.trim();

    if (!/^[a-zA-Z0-9_]{5,20}$/.test(id)) { alert('아이디는 5~20자의 영문/숫자/언더스코어만 가능합니다.'); elUserId.focus(); return false; }
    if (!/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/.test(email)) { alert('올바른 이메일 형식이 아닙니다.'); elEmail.focus(); return false; }
    if (isCreate) {
      if (pw.length < 6) { alert('비밀번호는 최소 6자리 이상이어야 합니다.'); elPw.focus(); return false; }
    } else {
      if (pw && pw.length < 6) { alert('비밀번호는 최소 6자리 이상이어야 합니다.'); elPw.focus(); return false; }
    }
    if (name.length === 0) { alert('이름을 입력해주세요.'); elName.focus(); return false; }

    if (!IS_EDIT) {
      if (!idChecked || lastCheckedId !== id) {
        alert('아이디 중복확인을 진행해주세요.');
        return false;
      }
    }
    return true;
  }

  // 아이디 변경 시 중복확인 초기화
  if (elUserId) {
    elUserId.addEventListener('input', function(){
      if (!IS_EDIT) { idChecked = false; lastCheckedId = ''; idHint.textContent = ''; }
    });
  }

  // 아이디 중복확인
  var btnCheck = document.getElementById('btnCheckId');
  if (btnCheck) {
    btnCheck.addEventListener('click', async function(){
      if (IS_EDIT) return;
      var id = elUserId.value.trim();
      if (!/^[a-zA-Z0-9_]{5,20}$/.test(id)) { alert('아이디 형식이 올바르지 않습니다.'); elUserId.focus(); return; }

      var url = qs(CHECK_ID_URL, { userId: id });
      if (csrfParam && csrfToken) url = qs(url, (function(o){ o[csrfParam]=csrfToken; return o;})({}));

      try {
        var res = await fetch(url, { method:'GET', headers:{'Accept':'application/json, text/plain,*/*'} });
        var ct = (res.headers.get('content-type')||'').toLowerCase();
        var ok = res.status>=200 && res.status<300;
        var available = false;

        if (ct.indexOf('application/json')>=0) {
          var j = await res.json();
          available = !!(j.available === true || j.exists === false);
        } else {
          var t = (await res.text()).trim().toLowerCase();
          available = ok && (t==='ok' || t==='available' || t==='true');
        }

        if (ok && available) {
          idChecked = true; lastCheckedId = id;
          idHint.textContent = '사용 가능한 아이디입니다.';
          alert('사용 가능한 아이디입니다.');
        } else {
          idChecked = false; lastCheckedId = '';
          idHint.textContent = '이미 사용 중인 아이디입니다.';
          alert('이미 사용 중인 아이디입니다.');
        }
      } catch (e) {
        alert('중복확인 중 오류가 발생했습니다.');
        console.error(e);
      }
    });
  }

  // 등록
  var btnCreate = document.getElementById('createBtn');
  if (btnCreate) {
    btnCreate.addEventListener('click', async function(){
      if (!validateCommon(true)) return;

      var payload = {
        userId: elUserId.value.trim(),
        userPw: elPw.value,
        userName: elName.value.trim(),
        userEmail: elEmail.value.trim(),
        userStatus: elStatus.value,
        roleId: elRole.value
      };

      var url = CREATE_URL;
      if (csrfParam && csrfToken) url = qs(url, (function(o){ o[csrfParam]=csrfToken; return o;})({}));

      try {
        var res = await fetch(url, {
          method:'POST',
          headers:{ 'Content-Type':'application/json', 'Accept':'application/json' },
          body: JSON.stringify(payload)
        });
        if (!(res.status>=200 && res.status<300)) { throw new Error('HTTP '+res.status); }
        alert('등록되었습니다.');
        location.href = LIST_URL;
      } catch(e) {
        console.error(e);
        alert('등록 실패: ' + (e.message||''));
      }
    });
  }

  // 수정
  var btnUpdate = document.getElementById('updateBtn');
  if (btnUpdate) {
    btnUpdate.addEventListener('click', async function(){
      if (!validateCommon(false)) return;

      var payload = {
        id: '${isEdit ? admin.id : ""}',
        userId: elUserId.value.trim(),  // readonly
        password: elPw.value,           // 비었으면 서버에서 변경 안 함
        userName: elName.value.trim(),
        userEmail: elEmail.value.trim(),
        userStatus: elStatus.value,
        roleId: elRole.value
      };

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
  }
  // 수정
  var btnDelete = document.getElementById('deleteBtn');
  if (btnDelete) {
	  btnDelete.addEventListener('click', async function(){
	  if (!confirm('정말 삭제하시겠습니까?')) return;
	
	  var userId = btnDelete.dataset.userId;
      if (!userId) { alert('삭제 대상이 없습니다.'); return; }

      try {
   	  	const res = await fetch(DELETE_URL + "?id=" + encodeURIComponent(userId), {
	         method: 'POST',
	         headers: { 'Accept': 'text/plain' }
	       });
       	console.log(res)
       	if (res.status !== 200 && !res.ok) {
	        alert('삭제 중 오류가 발생했습니다.');
       	} else {
	       	 alert('삭제되었습니다.');
	         location.href = LIST_URL;
       	}
      } catch (e) {
        console.error(e);
        alert('삭제 중 오류가 발생했습니다.');
      }
    });
  }
</script>
</body>
</html>
