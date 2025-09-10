<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 상세</title>
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<style>
    body {

    }

    .post-header {
        border-bottom: 2px solid #e9ecef;
        padding-bottom: 20px;
        margin-bottom: 20px;
    }

    .post-header h1 {
        font-size: 28px;
        color: #333;
        margin: 0;
        word-break: break-word; /* 긴 제목 처리 */
    }

    .post-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 10px;
        font-size: 14px;
        color: #6c757d;
    }

    .post-meta .author, .post-meta .date-views {
        display: flex;
        align-items: center;
    }

    .post-meta .date-views span {
        margin-left: 15px;
    }

    .post-content {
        line-height: 1.8;
        font-size: 16px;
        color: #495057;
        word-break: break-word;
        white-space: pre-wrap; /* 줄바꿈, 공백 유지 */
        margin-bottom: 30px;
        display: flex;
    	flex-direction: column;
    }

	.form-group {
	    display: flex;
	    flex-direction: column;
	}

	label {
	    font-weight: bold;
	    margin-bottom: 5px;
	}

	input[type="text"], textarea {
	    padding: 8px;
	    font-size: 14px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	}

	textarea {
	    min-height: 200px;
	}
	
    .post-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        border-top: 1px solid #e9ecef;
        padding-top: 20px;
    }
    
    .btn {
        padding: 10px 20px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        transition: background-color 0.3s, transform 0.2s;
        font-size: 15px;
        cursor: pointer;
        border: none;
    }

    .btn-list {
        background-color: #6c757d;
        color: #fff;
    }
    
    .btn-list:hover {
        background-color: #5a6268;
        transform: translateY(-2px);
    }
    
    .btn-edit {
        background-color: #007bff;
        color: #fff;
    }

    .btn-edit:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
    }

    .btn-delete {
        background-color: #dc3545;
        color: #fff;
    }

    .btn-delete:hover {
        background-color: #c82333;
        transform: translateY(-2px);
    }
    .ck-editor__editable {
	    min-height: 300px;  /* 최소 높이 */
	    max-height: 600px;  /* 최대 높이 */
	    border: 2px solid #e9ecef;
	}

</style>
</head>
<body>
	<c:set var="isEdit" value="${not empty post and not empty post.postId}" />
	<c:set var="boardId" value="${not empty param.boardId ? param.boardId : post.boardId}" />
    <div class="card">
	    <div class="post-header">
	        <c:if test="${isEdit}">
	            <div class="post-meta">
	                <span class="author">작성자: ${post.createdById}</span>
	                <div class="date-views">
	                    <span class="date-cell" data-date="${post.createdAt}"></span>
	                    <span>조회수: ${post.views}</span>
	                </div>
	            </div>
	        </c:if>
	    </div>
	
	    <div class="post-content">
	        <div class="form-group">
	            <label for="title">제목</label>
	            <input id="title" name="title" type="text" value="${isEdit ? post.title : ''}" required>
	        </div>
	
	        <div class="form-group">
	            <label for="editor">내용</label>
	            <textarea id="editor" name="content"><c:out value="${isEdit ? post.content : ''}"/></textarea>
	        </div>
	    </div>
	
	    <div class="post-actions">
	        <a href="<c:url value='/admin/board/${boardId}.do'/>" class="btn btn-list">목록</a>
	
	        <c:if test="${isEdit}">
	            <button id="updateBtn" type="button" class="btn btn-edit">수정</button>
	            <button id="deleteBtn" type="button" class="btn btn-delete" data-post-id="${post.postId}">삭제</button>
	        </c:if>
	
	        <c:if test="${not isEdit}">
	            <button id="createBtn" type="button" class="btn btn-edit">등록</button>
	        </c:if>
	    </div>
	</div>

	<script>
    // 삭제 버튼 클릭 시 동작하는 JavaScript 함수
    function deletePost(postId) {
        if (confirm('정말 이 게시물을 삭제하시겠습니까?')) {
            // 삭제 로직 (AJAX 호출 또는 폼 제출)을 여기에 추가
            alert(postId + '번 게시물이 삭제되었습니다. (실제 기능은 구현 필요)');
            // 예시: location.href = '/board/delete.do?id=' + postId;
        }
    }
    // 날짜를 원하는 형식으로 변환하는 JavaScript 함수
    function formatDateTime(isoString) {
        if (!isoString) {
            return '';
        }
        
        // T를 공백으로 대체하고, 초 부분을 제거
        return isoString.replace('T', ' ').slice(0, -3);
    }

 	// 날짜 변환 함수 적용
    document.addEventListener('DOMContentLoaded', function() {
        // 모든 .date-cell 요소를 선택
        const dateCells = document.querySelectorAll('.date-cell');
        
        // 각 요소를 순회하며 함수를 적용
        dateCells.forEach(cell => {
            // data-date 속성에서 원래 ISO 문자열을 가져옴
            const isoString = cell.getAttribute('data-date');
            
            // 함수를 호출하여 변환된 문자열을 가져옴
            const formattedDate = formatDateTime(isoString);
            
            // "등록일: " 문구를 추가하여 셀의 내용으로 설정
            cell.textContent = "등록일: " + formattedDate;
        });
    });
 	
    let ck;

    ClassicEditor
	    .create(document.querySelector('#editor'))
	    .then(editor => {
	        console.log('Editor was initialized', editor);
	        ck = editor
	        /* ck.setData(initialContent); */

	    })
	    .catch(error => {
	        console.error(error);
    });
    (function(){
        const btn = document.getElementById('createBtn');
        if(!btn) return;
        btn.addEventListener('click', async () => {
          if (!ck) { alert('에디터 초기화 중입니다.'); return; }
          const payload = {
            boardId: "<c:out value='${boardId}'/>",
            title: document.getElementById('title').value.trim(),
            content: ck.getData()
          };
          if (!payload.title) { alert('제목을 입력하세요.'); return; }

          try {
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
          }
        });
      })();

      // 수정 (update)
      (function(){
        const btn = document.getElementById('updateBtn');
        if(!btn) return;
        btn.addEventListener('click', async () => {
          if (!ck) { alert('에디터 초기화 중입니다.'); return; }
          const payload = {
            postId: ${isEdit ? post.postId : 0},
            title: document.getElementById('title').value.trim(),
            content: ck.getData()
          };
          try {
            const res = await fetch("<c:url value='/admin/board/updatePost.do'/>", {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(payload)
            });
            const text = await res.text();
            if (!res.ok) throw new Error(text || '수정 실패');
            alert('저장 완료!');
            window.location.href = "<c:url value='/admin/board/${boardId}.do'/>";
          } catch (err) {
            console.error(err);
            alert('저장에 실패했습니다. ' + err.message);
          }
        });
      })();

      // 삭제 (delete)
      (function(){
        const btn = document.getElementById('deleteBtn');
        if(!btn) return;
        btn.addEventListener('click', async (e) => {
          const postId = e.currentTarget.dataset.postId;
          if (!confirm('정말 삭제할까요?')) return;
          try {
            const res = await fetch("<c:url value='/admin/board/deletePost.do'/>" + "?postId=" + encodeURIComponent(postId), {
              method: 'POST',
              headers: { 'Accept': 'text/plain' }
            });
            const msg = await res.text();
            if (!res.ok) throw new Error(msg || '삭제 실패');
            alert('삭제되었습니다.');
            window.location.href = "<c:url value='/admin/board/${boardId}.do'/>";
          } catch (err) {
            console.error(err);
            alert('삭제 중 오류가 발생했습니다. ' + err.message);
          }
        });
      })();
</script>

</body>
</html>