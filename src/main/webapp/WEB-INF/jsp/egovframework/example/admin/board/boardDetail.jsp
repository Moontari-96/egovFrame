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
				
				<c:set var="thumbFile" value="${null}" />
				<c:forEach var="f" items="${files}">
				  <c:if test="${thumbFile == null and f.fileRole eq 'THUMBNAIL'}">
				    <c:set var="thumbFile" value="${f}" />
				  </c:if>
				</c:forEach>
				
				<div id="thumbPreview"
				     class="thumb fill ${thumbFile ne null ? 'haveThum' : ''}"
				     data-mode="${isEdit ? 'edit' : 'create'}"
				     data-existing-id="${thumbFile ne null ? thumbFile.fileId : ''}"
				     data-existing="<c:if test='${thumbFile ne null}'><c:url value='/files/${thumbFile.fileSysname}'/></c:if>"
				     style="${thumbFile ne null ? '' : 'display:none'}">
				  <c:if test="${thumbFile ne null}">
				    <img src="<c:url value='/files/${thumbFile.fileSysname}'/>"
				         class="thumbnail-img"
				         alt="${thumbFile.fileOriname}">
				  </c:if>
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
				  <div id="attachmentsPreview" class="attachments-list-container">
				    <c:forEach var="f" items="${files}">
				      <c:if test="${f.fileRole ne 'THUMBNAIL'}">
				        <div class="attachment-item" data-type="existing" data-file-id="${f.fileId}">
				          <a class="file-name" target="_blank" download="${f.fileOriname}"
				             href="<c:url value='/files/${f.fileSysname}'/>"><c:out value="${f.fileOriname}"/></a>
				          <button type="button" class="delete-btn" data-type="existing" title="삭제">&times;</button>
				        </div>
				      </c:if>
				    </c:forEach>
				  </div>
				  <input type="file" name="attachments" id="attachments" multiple style="display:none;">
				  <button type="button" id="addFileBtn" class="add-file-btn">
				    <span class="icon">+ 파일 추가</span>
				  </button>
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
	/** 공용 상태 **/
	var deletedFileIds = [];                  // 서버에 지울 기존 파일 ID 모음
	let attachStore = new DataTransfer();        // 새 첨부 누적 저장
	function tokenOf(f) { return f.name + '__' + f.size + '__' + f.lastModified; }
	const newFileTokens = new Set(); // 중복 방지용
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
    
    
   	// 파일관리 
	document.addEventListener('DOMContentLoaded', () => {
	  const thumbInput        = document.getElementById('thumb');
	  const thumbPreview      = document.getElementById('thumbPreview');
	  const attachmentsInput  = document.getElementById('attachments');
	  const addFileBtn        = document.getElementById('addFileBtn');
	  const previewContainer  = document.getElementById('attachmentsPreview');
	  const deletedField      = document.getElementById('deletedFileIds');
	  const MAX_FILE_COUNT = 5; // 최대 파일 개수 제한

	  /** 썸네일 미리보기 + 기존 썸네일 교체시 삭제 목록 추가 **/
	  thumbInput.addEventListener('change', (e) => {
	    const file = e.target.files && e.target.files[0];
	    thumbPreview.innerHTML = '';
	    if (file) {
	      // 기존 썸네일이 있으면 삭제 목록에 추가
	        var existingId = thumbPreview.getAttribute('data-existing-id');
	        if (existingId) {
	          if (deletedFileIds.indexOf(existingId) === -1) {
	            deletedFileIds.push(existingId);
	            deletedField.value = deletedFileIds.join(',');
	          }
	          thumbPreview.setAttribute('data-existing-id', '');
	        }
	        var url = URL.createObjectURL(file);
	        var img = new Image();
	        img.className = 'thumbnail-img';
	        img.src = url;
	        img.alt = file.name;
	        img.onload = function () { URL.revokeObjectURL(url); };
	        thumbPreview.style.display = 'block';
	        thumbPreview.appendChild(img);
	    } else {
	      // 선택 취소: edit 모드 + 기존 썸네일 있으면 다시 보여주고, 아니면 숨김
	      var existing = thumbPreview.getAttribute('data-existing');
	      if (existing) {
	        var img2 = new Image();
	        img2.className = 'thumbnail-img';
	        img2.src = existing;
	        img2.alt = 'thumbnail';
	        thumbPreview.style.display = 'block';
	        thumbPreview.appendChild(img2);
	      } else {
	        thumbPreview.style.display = 'none';
	      }
	    }
	  });
	
	  /** 첨부: 파일 추가 버튼 */
	  addFileBtn.addEventListener('click', function () {
	    attachmentsInput.click();
	  });	
	  /** 첨부: 파일 선택 시 누적 + 미리보기 추가 + 중복 방지 */
	  attachmentsInput.addEventListener('change', () => {
	    const files = attachmentsInput.files;
	    if (!files || files.length === 0) return;
	 	// 기존에 업로드된 파일의 개수
	    const existingFileCount = attachmentsPreview.querySelectorAll('.attachment-item').length;
	    // 새로 추가된 파일의 개수
	    const newFileCount = event.target.files.length;
	    // 총 파일 개수
	    const totalFileCount = existingFileCount + newFileCount;
	    if (totalFileCount > MAX_FILE_COUNT) {
	        alert('파일은 최대 ' + MAX_FILE_COUNT + '개까지만 첨부할 수 있습니다.');
	        // 파일 입력 초기화
	        fileInput.value = ''; 
	        return; // 함수 종료
	      }
	    
	    for (var i = 0; i < files.length; i++) {
	        var f  = files[i];
	        var tk = tokenOf(f);
	        if (newFileTokens.has(tk)) continue;       // 중복 방지
	
	        newFileTokens.add(tk);
	        attachStore.items.add(f);                   // 누적 저장
	
	        // DOM으로 안전하게 구성 (innerHTML 문자열 깨짐 방지)
	        var item = document.createElement('div');
	        item.className = 'attachment-item new-file';
	        item.setAttribute('data-type', 'new');
	        item.setAttribute('data-token', tk);
	
	        var nameSpan = document.createElement('span');
	        nameSpan.className = 'file-name';
	        nameSpan.appendChild(document.createTextNode(f.name));
	
	        var delBtn = document.createElement('button');
	        delBtn.type = 'button';
	        delBtn.className = 'delete-btn';
	        delBtn.setAttribute('data-type', 'new');
	        delBtn.title = '삭제';
	        delBtn.innerHTML = '&times;';
	
	        item.appendChild(nameSpan);
	        item.appendChild(delBtn);
	        previewContainer.appendChild(item);
	      }  
	    // input.files를 관리하는 값으로 교체
	    // attachmentsInput.files = attachStore.files;
	    // 같은 파일 또 선택 가능하게 초기화
	    attachmentsInput.value = '';
	  });
	
	  /** 첨부: 삭제(기존/신규) */
	  previewContainer.addEventListener('click', function (e) {
	    var btn = e.target.closest ? e.target.closest('.delete-btn') : null;
	    if (!btn) return;
	
	    var item = btn.closest ? btn.closest('.attachment-item') : null;
	    if (!item) return;
	
	    var type = item.getAttribute('data-type');
	    if (type === 'existing') {
	      var id = item.getAttribute('data-file-id');
	      if (!id) return;
	      if (!confirm('이 파일을 삭제하시겠습니까?')) return;
	      if (deletedFileIds.indexOf(id) === -1) {
	        deletedFileIds.push(id);
	        deletedField.value = deletedFileIds.join(',');
	      }
	      item.parentNode.removeChild(item);
	    } else if (type === 'new') {
	      var tk = item.getAttribute('data-token');
	      if (!tk) return;
	
	      // 해당 파일만 제외하고 store 재구성
	      var rebuilt = new DataTransfer();
	      for (var i = 0; i < attachStore.files.length; i++) {
	        var f = attachStore.files[i];
	        if (tokenOf(f) !== tk) rebuilt.items.add(f);
	      }
	      attachStore = rebuilt;
	      attachmentsInput.files = attachStore.files;
	      newFileTokens.delete(tk);
	
	      item.parentNode.removeChild(item);
	    }
	  });
	 });
    (function(){
        const btn = document.getElementById('createBtn');
        if(!btn) return;
        btn.addEventListener('click', async () => {
          if (!ck) { alert('에디터 초기화 중입니다.'); return; }
          var title = document.getElementById('title').value.trim();
          var thumbInp = document.getElementById('thumb');
          var attach = document.getElementById('attachments');
          var notice = document.getElementById('f_active').checked;
          if (!title) { 
            alert('제목을 입력하세요.'); 
            return; 
          }
          const formData = new FormData();
          formData.append('boardId', '<c:out value="${boardId}"/>');
          formData.append('title', title);
          formData.append('content', ck.getData());
          formData.append('notice', notice);
          
          if (thumbInp.files[0]) formData.append('thumbnail', thumbInp.files[0]);
          for (var i = 0; i < attachStore.files.length; i++) {
        	formData.append('attachments', attachStore.files[i]);
          }          // FormData 내용 콘솔에 출력
			for (const [key, value] of formData.entries()) {
			  console.log(key + ': ', value);     // 안전
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

          var title   = document.getElementById('title').value.trim();
          var notice  = document.getElementById('f_active').checked;
          var thumbInp   = document.getElementById('thumb');
          var deleted = document.getElementById('deletedFileIds').value || '';
          if (!title) { alert('제목을 입력하세요.'); return; }
		  
          var formData = new FormData();
          formData.append('postId', ${isEdit ? post.postId : 0});
          formData.append('title', title);
          formData.append('content', ck.getData());
          formData.append('notice', notice);
          var ids = deletedFileIds.filter(function (x) { return x != null && x !== ''; });
          for (var i = 0; i < ids.length; i++) {
        	  formData.append('deletedFileIds', ids[i]);   // deletedFileIds=15, deletedFileIds=13, ...
          }    
          if (thumbInp.files[0]) formData.append('thumbnail', thumbInp.files[0]);
          for (var i = 0; i < attachStore.files.length; i++) formData.append('attachments', attachStore.files[i]);
          for (const [key, value] of formData.entries()) {
			  console.log(key + ': ', value);     // 안전
			}
          try {
            const res = await fetch("<c:url value='/admin/board/updatePost.do'/>", {
              method: 'POST',
              body: formData // FormData 객체 직접 전달
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