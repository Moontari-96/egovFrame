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
<link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script
  src="https://code.jquery.com/jquery-3.7.1.min.js"
  integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
  crossorigin="anonymous"></script>
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
			  <label>썸네일</label>
			  	<input type="file" id="thumb" name="thumb" accept="image/*">
			 	<div id="thumbPreview">
			 		<c:forEach var="file" items="${files}">
					    <c:if test="${file.fileRole eq 'THUMBNAIL'}">
					        <div class="thumbnail-container">
					        
					            <img src="<c:url value='/files/${file.fileSysname}'/>" class="thumbnail-img" alt="${file.fileOriname}">
					        </div>
					    </c:if>
					</c:forEach>
			 	</div>
			</div>
			<div class="form-group">
            	<div class="field"><label>공지 여부</label>
	              <label class="switch">
					  <input id="f_active" type="checkbox" <c:if test="${isEdit and post.notice}">checked</c:if> >
					  <span class="slider"></span>
					</label>
	            </div>
	        </div>
	        <div class="form-group">
	            <label for="title">제목</label>
	            <input id="title" name="title" type="text" value="${isEdit ? post.title : ''}" required>
	        </div>
	
	        <div class="form-group">
	            <label for="editor">내용</label>
	            <textarea id="editor" name="content"><c:out value="${isEdit ? post.content : ''}"/></textarea>
	        </div>
	        
	  		<div class="form-group">
			  <label for="attachments">첨부파일</label>
			  <div class="attachments-container">
			    <div id="attachmentsPreview" class="attachments-list-container"></div>
			    
			    <input type="file" name="attachments" id="attachments" multiple style="display: none;">
			    <button type="button" id="addFileBtn" class="add-file-btn">
			      <span class="icon">&#43; 파일 추가</span> 
			    </button>
			  </div>
			</div>
			<input type="hidden" name="deletedFileIds" id="deletedFileIds" value="">
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
	        ck = editor
	        /* ck.setData(initialContent); */

	    })
	    .catch(error => {
	        console.error(error);
    });
    
    
   	// 썸네일 
	document.getElementById('thumb').addEventListener('change', function(event) {
	    const file = event.target.files[0];
	    const preview = document.getElementById('thumbPreview');
	
	    // #thumbPreview 내부의 모든 자식 요소를 제거
	    preview.innerHTML = '';
	    
	    if (file) {
	        const reader = new FileReader();
	        reader.onload = function(e) {
	            const img = document.createElement('img');
	            img.src = e.target.result;
	            img.alt = file.name;
	            img.classList.add('thumbnail-img');
	
	            preview.style.display = 'block';
	            preview.appendChild(img);
	        };
	        reader.readAsDataURL(file);
	    } else {
	        // 파일 선택 취소 시 기존 미리보기 div의 내용을 유지하지 않고 숨김
	        preview.style.display = 'none';
	    }
	});

    // 첨부파일
	// 삭제할 파일 ID를 저장할 전역 배열
	document.addEventListener('DOMContentLoaded', function() {
	    const attachmentsInput = document.getElementById('attachments');
	    const addFileBtn = document.getElementById('addFileBtn');
	    const previewContainer = document.getElementById('attachmentsPreview');
	    const deletedFilesField = document.getElementById('deletedFileIds');
	    const deletedFileIds = [];
	
	    // '파일 추가' 버튼 클릭 시, 숨겨진 파일 입력 필드 클릭
	    addFileBtn.addEventListener('click', () => {
	        attachmentsInput.click();
	    });
	
	    // 파일 입력 필드 변경 이벤트 (새 파일 추가)
	    attachmentsInput.addEventListener('change', function() {
	        const files = this.files;
	        console.log(attachmentsInput.files)
	        console.log(files)
	        for (let i = 0; i < files.length; i++) {
	            const file = files[i];
	            
	            // 새로운 파일 항목 생성
	            const fileItem = document.createElement('div');
	            fileItem.classList.add('attachment-item', 'new-file'); // 새로운 파일임을 표시하는 클래스
	            fileItem.innerHTML = '<span class="file-name">' + file.name + '</span>' +
                '<span class="delete-btn" data-type="new">&times;</span>';
	            previewContainer.appendChild(fileItem);
	        }
	    });

   		// 미리보기 컨테이너에 이벤트 위임 (삭제 버튼 클릭 처리)
   		previewContainer.addEventListener('click', function(event) {
	        const deleteBtn = event.target.closest('.delete-btn');
	        if (!deleteBtn) return;
	
	        const fileItem = deleteBtn.closest('.attachment-item');
	        const fileId = fileItem.dataset.fileId;
	        const fileType = deleteBtn.dataset.type;
	
	        // 기존 파일 삭제
	        if (fileType === 'existing') {
	            if (confirm('이 파일을 삭제하시겠습니까?')) {
	                // 삭제할 파일 ID를 숨겨진 필드에 추가
	                if (fileId) {
	                    deletedFileIds.push(fileId);
	                    deletedFilesField.value = deletedFileIds.join(',');
	                }
	                fileItem.remove(); // UI에서 제거
	            }
	        // 새로운 파일 삭제
	        } else if (fileType === 'new') {
	            fileItem.remove(); // UI에서 제거
	            // 실제 input 필드에서 파일을 제거하는 로직은 복잡하여 생략.
	            // 대신, 서버에서 `attachmentsInput.files`를 처리할 때 UI에 없는 파일은 무시하도록 해야 함.
	        }
	    });
	});
    (function(){
        const btn = document.getElementById('createBtn');
        if(!btn) return;
        btn.addEventListener('click', async () => {
          if (!ck) { alert('에디터 초기화 중입니다.'); return; }
          /* const payload = {
            boardId: "<c:out value='${boardId}'/>",
            title: document.getElementById('title').value.trim(),
            content: ck.getData()
            //thumbnailId: document.getElementById('thumb').value,           // 썸네일
      		//attachmentIds: attachmentIds        // 첨부파일
          }; */
          const title = document.getElementById('title').value.trim();
          const thumbInput = document.getElementById('thumb');
          const attachmentsInput = document.getElementById('attachments');
          const file = thumbInput.files[0]; // file 변수 선언
          const files = attachmentsInput.files; // file 변수 선언
          const notice = document.getElementById('f_active').checked;
          const formData = new FormData();
          formData.append('boardId', '<c:out value="${boardId}"/>');
          formData.append('title', title);
          formData.append('content', ck.getData());
          formData.append('notice', notice);
          
          if (file) { // 파일이 있을 때만 추가
              formData.append('thumbnail', file);
            }
            
          if (files) {
        	  for (let i = 0; i < files.length; i ++) {
	              formData.append('attachments', files[i]);
        	  }
          }
          // FormData 내용 콘솔에 출력
			for (const [key, value] of formData.entries()) {
			  console.log(key + ': ', value);     // 안전
			}
          
          if (!title) { 
            alert('제목을 입력하세요.'); 
            return; 
          }
          
          try {
            const res = await fetch("<c:url value='/admin/board/createPost.do'/>", {
              method: 'POST',
              body: formData // FormData 객체 직접 전달
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