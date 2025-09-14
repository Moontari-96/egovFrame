<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${pageTitle}</title>
  <link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
</head>
<body>
<div class="page">
  <div class="card">
    <h2 style="margin:0 0 12px 0;">${pageTitle}</h2>
    <div class="grid">
      <!-- Left: Tree -->
      <div class="tree">
        <div class="tree-header">
		  <div class="toolbar">
		    <button class="btn btn-primary" id="btnAdd">추가</button>
		    <button class="btn btn-danger" id="btnDelete">삭제</button>
		    <button class="btn" id="btnCollapseAll">전체 접기</button>
			<button class="btn" id="btnExpandAll">전체 펼치기</button>
		  </div>
		</div>
        <div class="tree-body">
          <ul class="tree-ul" id="treeRoot"></ul>
        </div>
      </div>

      <!-- Right: Detail -->
      <div class="panel">
        <div class="panel-header">
          <div>
            <strong id="detailTitle">상세</strong>
            <span class="muted" id="detailPath"></span>
          </div>
          <div class="toolbar">
            <button class="btn" id="btnReset">되돌리기</button>
            <button class="btn btn-primary" id="btnSave">저장</button>
          </div>
        </div>
        <div class="panel-body">
          <div class="field"><label>상위 ID (parentId)</label><input id="f_parentId" type="number" readonly></div>
          <div class="field"><label>깊이 (menuDepth)</label><input id="f_depth" type="number" readonly></div>
          <div class="field"><label>게시판 ID (boardId)</label><input id="f_board" type="number" min="0" value=""></div>
          <div class="field"><label>정렬순서 (sortOrder)</label><input id="f_sort" type="number" value="0" min="0" step="1" inputmode="numeric" pattern="\d*"></div>
          <div class="field" style="grid-column:1/3"><label>메뉴명</label><input id="f_name" type="text"></div>
          <div class="field" style="grid-column:1/3"><label>URL</label><input id="f_url" type="text" placeholder="/path"></div>
          <div class="field"><label>사용여부</label>
            <label class="switch"><input id="f_active" type="checkbox"><span class="slider"></span></label>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- (선택) 컨트롤러에서 내려준 JSON이 있다면 여기에 싣기 -->
<script type="application/json" id="menu-data">
  <c:out value="${menuJson}" />
</script>

<script>
// ============================== 설정/유틸 ==============================
const MAX_DEPTH = 3; // 최대 3뎁스

const csrfParam = '${_csrf != null ? _csrf.parameterName : ''}';
const csrfToken = '${_csrf != null ? _csrf.token : ''}';

const byId = id => document.getElementById(id);
const collapsedState = new Map();

let MENU = [];
let tempSeq = -1;
let selectedId = null;
const originalMap = new Map();

function toNum(v, d = 0){ const n = Number(v); return Number.isFinite(n) ? n : d; }

// 자손 수집
function collectDescendants(id) {
  const out = [];
  (function dfs(x){
    MENU.filter(n => n.parentId === x).forEach(n => { out.push(n.menuId); dfs(n.menuId); });
  })(id);
  return out;
}

// 서브트리 depth 보정
function setDepthRecursive(rootId, newDepth){
  const root = MENU.find(m => m.menuId === rootId);
  if (!root) return;
  const delta = newDepth - (root.menuDepth || 1);
  const ids = [rootId, ...collectDescendants(rootId)];
  for (const id of ids){
    const n = MENU.find(m => m.menuId === id);
    n.menuDepth = Math.max(1, Math.min(MAX_DEPTH, (n.menuDepth||1) + delta));
  }
}

// 형제 sortOrder 0..N 재부여
function reindexSortOrder(parentId){
  const sibs = MENU.filter(n => (n.parentId||0) === (parentId||0))
                   .sort((a,b)=>(a.sortOrder??0)-(b.sortOrder??0) || a.menuId-b.menuId);
  sibs.forEach((n, i) => n.sortOrder = i);
}

// =========================== 데이터 로드/정규화 ===========================
function sanitizeMenu(list) {
  return (list || []).map(m => {
    // 다양한 키 별칭 대응
    const id        = m.menuId ?? m.id ?? m.menu_id;
    const board        = m.boardId ?? m.board_id ?? m.board;
    const pid       = m.parentId ?? m.parent_id ?? m.pid ?? m.parent;
    const name      = m.menuName ?? m.name ?? m.menu_name ?? m.title;
    const url       = m.menuUrl ?? m.url ?? m.path;
    const depth     = m.menuDepth ?? m.depth ?? m.menu_depth;
    const sort      = m.sortOrder ?? m.sort ?? m.sort_order ?? m.ord;
    const active    = (m.isActive ?? m.active ?? m.useYn ?? m.enabled);

    return {
      menuId   : toNum(id),
      parentId : toNum(pid, 0),
      boardId  : toNum(board, 0),
      menuName : (name ?? '').toString(),
      menuUrl  : (url  ?? '').toString(),
      menuDepth: toNum(depth, 1),
      sortOrder: toNum(sort, 0),
      isActive : !!(String(active) === 'true' || String(active) === 'Y' || active === true)
    };
  });
}

async function loadMenu() {
  const el = document.getElementById('menu-data');
  if (el && el.textContent.trim()) {
    try { return sanitizeMenu(JSON.parse(el.textContent)); } catch {}
  }
  const res = await fetch('<c:url value="/admin/menu/menu.do"/>');
  const data = await res.json();
  return sanitizeMenu(data);
}

function snapshot(){
  originalMap.clear();
  MENU.forEach(m => originalMap.set(m.menuId, JSON.parse(JSON.stringify(m))));
}

// =============================== 트리 렌더 ===============================
function buildTree(list){
  const map = new Map();
  list.forEach(n => { n.children = []; map.set(n.menuId, n); });
  const roots = [];
  list.forEach(n => {
    const pid = n.parentId || 0;
    if (pid === 0 || !map.has(pid)) roots.push(n);
    else map.get(pid).children.push(n);
  });
  const sortRec = (arr)=>{ arr.sort((a,b)=>(a.sortOrder??0)-(b.sortOrder??0) || a.menuId-b.menuId); arr.forEach(ch=>sortRec(ch.children)); };
  sortRec(roots);
  return roots;
}

function renderTree(){
  const root = byId('treeRoot');
  root.innerHTML = '';
  const roots = buildTree(MENU);
  roots.forEach(n => root.appendChild(renderNode(n)));
}

function renderNode(node){
	  const li  = document.createElement('li');
	  const row = document.createElement('div');
	  const depth = node.menuDepth || 1;
	  row.className = 'node d' + depth + (node.menuId === selectedId ? ' active' : '');

	  // --- 접기/펼치기(1,2뎁스 + 자식 있을 때만) ---
	  const hasChildren = Array.isArray(node.children) && node.children.length > 0;
	  const twist = document.createElement('span');
	  const toggleable = hasChildren && depth <= 2;
	  const isCollapsed = node._collapsed === true;
	  if (toggleable) {
	    twist.textContent = isCollapsed ? '+' : '−';
	    twist.className = 'twist';
	    twist.onclick = (e) => {
	      e.stopPropagation();
	      node._collapsed = !isCollapsed;
	      renderTree();
	    };
	  } else {
	    twist.className = 'twist hidden';
	    twist.textContent = '';
	  }
	  // 드래그 시작시 +/-를 잡으면 끊기지 않게
	  twist.draggable = false;

	  // 라벨
	  const label = document.createElement('span');
	  label.className = 'label';
	  label.textContent = node.menuName || '(무제)';

	  row.append(twist, label);
	  row.onclick = ()=> selectNode(node.menuId);
	  li.appendChild(row);

	  // -------- DnD: 노드 바(bar)를 드래그 가능하게 --------
	  row.draggable = true;
	  row.dataset.id = String(node.menuId);

	  // dragstart: 드래그 출발 ID 기록
	  row.ondragstart = (e) => {
	    e.dataTransfer.setData('text/plain', String(node.menuId));
	    e.dataTransfer.effectAllowed = 'move';
	    // 드래그 시작하면 임시로 펼쳐 보이도록
	    node._collapsed = false;
	  };

	  // dragover: 드롭 허용
	  row.ondragover = (e) => {
	    e.preventDefault();
	    e.dataTransfer.dropEffect = 'move';
	  };

	  // drop: 형제 재정렬 or 자식 넣기
	  row.ondrop = (e) => {
	    e.preventDefault();
	    const dragId = Number(e.dataTransfer.getData('text/plain'));
	    const dropId = node.menuId;
	    if (!Number.isFinite(dragId) || dragId === dropId) return;

	    const drag = MENU.find(m => m.menuId === dragId);
	    const drop = MENU.find(m => m.menuId === dropId);
	    if (!drag || !drop) return;

	    // 자기 자손에게 드롭 금지
	    const descendants = (function collect(x, acc=[]){
	      MENU.filter(n=>n.parentId===x).forEach(n=>{ acc.push(n.menuId); collect(n.menuId, acc); });
	      return acc;
	    })(dragId, []);
	    if (descendants.includes(dropId)) {
	      alert('하위 메뉴로는 이동할 수 없습니다.');
	      return;
	    }

	    const wantChild = e.shiftKey || e.altKey; // Shift/Alt: 자식으로
	    if (wantChild) {
	      const newDepth = (drop.menuDepth || 1) + 1;
	      if (newDepth > MAX_DEPTH) { alert(`최대 ${MAX_DEPTH}뎁스까지 가능합니다.`); return; }
	      drag.parentId = drop.menuId;
	      // 서브트리 depth 맞춰줌
	      (function setDepthRecursive(rootId, newDepth){
	        const root = MENU.find(m => m.menuId === rootId);
	        if (!root) return;
	        const delta = newDepth - (root.menuDepth || 1);
	        const ids = [rootId];
	        (function dfs(x){
	          MENU.filter(n=>n.parentId===x).forEach(n=>{ ids.push(n.menuId); dfs(n.menuId); });
	        })(rootId);
	        ids.forEach(id=>{
	          const n = MENU.find(m=>m.menuId===id);
	          n.menuDepth = Math.max(1, Math.min(MAX_DEPTH, (n.menuDepth||1) + delta));
	        });
	      })(drag.menuId, newDepth);

	      drag.sortOrder = 9999;
	      reindexSortOrder(drag.parentId);
	      renderTree(); selectNode(drag.menuId);
	      return;
	    }

	    // 형제로 재정렬 (같은 부모)
	    const sameParentId = drop.parentId || 0;
	    drag.parentId = sameParentId;

	    // before/after 결정: 마우스 Y 위치 기준
	    const rect = row.getBoundingClientRect();
	    const before = (e.clientY - rect.top) < rect.height / 2;

	    const sibs = MENU
	      .filter(n => (n.parentId||0) === sameParentId && n.menuId !== drag.menuId)
	      .sort((a,b)=>(a.sortOrder??0)-(b.sortOrder??0) || a.menuId-b.menuId);

	    const idx = sibs.findIndex(n => n.menuId === drop.menuId);
	    const insertAt = Math.max(0, before ? idx : idx + 1);
	    sibs.splice(insertAt, 0, drag);
	    sibs.forEach((n, i) => n.sortOrder = i);

	    // 형제로 옮기면 depth는 drop과 동일하게 맞춤(서브트리 포함)
	    (function setDepthRecursive(rootId, newDepth){
	      const root = MENU.find(m => m.menuId === rootId);
	      if (!root) return;
	      const delta = newDepth - (root.menuDepth || 1);
	      const ids = [rootId];
	      (function dfs(x){
	        MENU.filter(n=>n.parentId===x).forEach(n=>{ ids.push(n.menuId); dfs(n.menuId); });
	      })(rootId);
	      ids.forEach(id=>{
	        const n = MENU.find(m=>m.menuId===id);
	        n.menuDepth = Math.max(1, Math.min(MAX_DEPTH, (n.menuDepth||1) + delta));
	      });
	    })(drag.menuId, drop.menuDepth || 1);

	    renderTree(); selectNode(drag.menuId);
	  };

	  // --- 자식 렌더 (접힘 상태면 숨김) ---
	  if (hasChildren && !isCollapsed) {
	    const ul = document.createElement('ul');
	    ul.className = 'tree-ul';
	    node.children.forEach(ch => ul.appendChild(renderNode(ch)));
	    li.appendChild(ul);
	  }
	  return li;
	}


function makePath(id){
  const seq = []; const map = new Map(MENU.map(m=>[m.menuId,m]));
  let cur = map.get(id);
  while(cur){ seq.unshift(cur.menuName||'(무제)'); cur = map.get(cur.parentId); }
  return seq;
}

function selectNode(id){
	  selectedId = id;
	  renderTree();

	  const m = MENU.find(x => x.menuId === id);
	  if(!m) return;

	  byId('f_parentId').value = m.parentId || null;
	  byId('f_depth').value    = m.menuDepth || 1;
	  byId('f_board').value     = m.boardId || null;
	  byId('f_sort').value     = m.sortOrder || 0;
	  byId('f_name').value     = m.menuName  || '';
	  byId('f_url').value      = m.menuUrl   || '';
	  byId('f_active').checked = !!m.isActive;

	  byId('detailTitle').textContent = '상세 · ' + m.menuName;
	  byId('detailPath').textContent  = makePath(m.menuId).join(' / ');
	}

// ================================ CRUD ================================
function addAuto(){
  const parent = MENU.find(m=>m.menuId===selectedId);
  const canBeChild = !!parent && (parent.menuDepth||1) < MAX_DEPTH;

  const node = {
    menuId: tempSeq--,
    parentId: canBeChild ? parent.menuId : null,      // 선택 없거나 최대뎁스면 루트
    boardId: 0,      // 선택 없거나 최대뎁스면 루트
    menuName: '새 메뉴',
    menuUrl:  '',
    sortOrder: '',
    menuDepth: canBeChild ? (parent.menuDepth||1)+1 : 1,
    isActive: true
  };
  MENU.push(node);
  reindexSortOrder(node.parentId);
  renderTree();
  selectNode(node.menuId);

  if (!canBeChild && parent) alert('최대 ' + MAX_DEPTH + '뎁스까지 가능합니다. 같은 뎁스로 추가했습니다.');
}

function collectWithChildren(id){
  const out=[]; (function dfs(x){ out.push(x); MENU.filter(n=>n.parentId===x).forEach(n=>dfs(n.menuId)); })(id);
  return out;
}

function clearDetail(){
	  ['f_parentId','f_depth','f_sort','f_name','f_url'].forEach(id=> byId(id).value='');
	  byId('f_active').checked=false;
	  byId('detailTitle').textContent='상세';
	  byId('detailPath').textContent='';
}

async function removeSelected() {
  if (selectedId == null) { alert('삭제할 메뉴를 선택하세요.'); return; }

  const target = MENU.find(m => m.menuId === selectedId);
  if (!target) { alert('대상 메뉴를 찾을 수 없습니다.'); return; }

  // self + children
  const ids = collectWithChildren(selectedId);
  const childCount = Math.max(0, ids.length - 1);
  const menuName = ((target.menuName || '').trim() || '(무제)');

  const msg = childCount > 0
    ? "'" + menuName + "'을(를) 삭제하면 하위 " + childCount + "개 항목도 함께 삭제됩니다. 계속할까요?"
    : "'" + menuName + "'을(를) 삭제할까요?";
  if (!confirm(msg)) return;

  // 다음 선택 대상 계산: 다음 형제 -> 이전 형제 -> 부모
  const pid = target.parentId || 0;
  const sibs = MENU
    .filter(n => (n.parentId || 0) === pid)
    .sort((a,b) => (a.sortOrder||0)-(b.sortOrder||0) || a.menuId-b.menuId);
  const idx = sibs.findIndex(n => n.menuId === target.menuId);
  const nextSel = (sibs[idx+1] && sibs[idx+1].menuId)
               || (sibs[idx-1] && sibs[idx-1].menuId)
               || (pid || null);

  // ---- 낙관적 UI 업데이트 ----
  const prevMENU = JSON.parse(JSON.stringify(MENU));
  MENU = MENU.filter(m => !ids.includes(m.menuId));
  reindexSortOrder(pid);
  selectedId = nextSel || null;
  renderTree();
  if (selectedId) selectNode(selectedId); else clearDetail();

  // ---- 서버 호출 ----
  try {
	  if (target.menuId > 0) {
	    let url = "<c:url value='/admin/menu/deleteMenu.do'/>";
	    const qs = new URLSearchParams({ menuId: String(target.menuId) });
	    if (csrfParam && csrfToken) qs.append(csrfParam, csrfToken);
	    url += "?" + qs.toString();
	
	    const res = await fetch(url, {
	      method: 'POST',                // @PostMapping과 일치
	      headers: { 'Accept': '*/*' },  // 어떤 응답이든 받기
	      credentials: 'same-origin'
	    });
	
	    // ✅ 2xx면 성공으로 간주 (본문 검사 X)
	    if (!(res.status >= 200 && res.status < 300)) {
	      const text = await res.text().catch(()=> '');
	      throw new Error('HTTP ' + res.status + (text ? ' ' + text : ''));
	    }
	  }
	
	  snapshot(); // 커밋
	  alert('삭제되었습니다.');
	
	} catch (err) {
	  console.error(err);
	  // 롤백
	  MENU = prevMENU;
	  renderTree();
	  selectNode(target.menuId);
	  alert('삭제 중 오류가 발생했습니다. ' + (err?.message || ''));
	}
}

function saveCurrent(){
  if(selectedId == null){ alert('저장할 메뉴를 선택하세요.'); return; }
  const m = MENU.find(x=>x.menuId===selectedId);
  m.menuName = byId('f_name').value.trim();
  m.menuUrl  = byId('f_url').value.trim();
  m.sortOrder = Number(byId('f_sort').value||0);
  m.isActive = byId('f_active').checked;
  const boardRaw = byId('f_board').value?.trim();
  m.boardId = boardRaw === '' ? null : Number(boardRaw);

  const row = JSON.parse(JSON.stringify(m));
  if(row.menuId < 0) row.clientTempId = row.menuId;

  let url = '<c:url value="/admin/menu/saveMenu.do"/>';
  if(csrfParam){ const qs = new URLSearchParams(); qs.append(csrfParam, csrfToken); url += '?' + qs.toString(); }

  fetch(url, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ rows:[row] }) })
    .then(r=>r.json()).then(j=>{
      if(j.success){
        if(Array.isArray(j.updated)){
          j.updated.forEach(u=>{
            const idx = MENU.findIndex(x=>x.menuId === (u.clientTempId ?? u.menuId));
            if(idx>=0){ MENU[idx].menuId = u.menuId; }
          });
        }
        snapshot(); renderTree();
        const newId = (row.menuId<0 && j.updated && j.updated[0] && j.updated[0].menuId) ? j.updated[0].menuId : selectedId;
        selectNode(newId);
        alert('저장되었습니다.');
      } else { alert(j.message||'저장 실패'); }
    })
    .catch(()=> alert('저장 중 오류'));
}

function resetCurrent(){
  if(selectedId==null) return;
  const org = originalMap.get(selectedId);
  if(org){ Object.assign(MENU.find(m=>m.menuId===selectedId), JSON.parse(JSON.stringify(org))); }
  selectNode(selectedId); renderTree();
}

function getRootId(id){
	  const map = new Map(MENU.map(m=>[m.menuId,m]));
	  let cur = map.get(id), parent;
	  while (cur && (parent = map.get(cur.parentId))) cur = parent;
	  return cur ? cur.menuId : 0;
}

function setAllCollapsed(flag){
	  MENU.forEach(m => {
	    const d = m.menuDepth || 1;
	    if (d <= 2) m._collapsed = !!flag;  // 렌더가 보는 건 _collapsed
	  });
	  renderTree();
	}

//depth=1 → 루트(1뎁스)만 접음 → 2·3 안 보임
//depth=2 → 1뎁스 펴고 2뎁스 접음 → 3은 자연히 숨겨짐
function collapseAtDepth(depth){
	MENU.forEach(n => {
	 const d = n.menuDepth || 1;
	 if (d < depth)       n._collapsed = false; // 상위는 펼침
	 else if (d === depth) n._collapsed = true;  // 해당 뎁스 접기
	 // d > depth 는 부모 접힘에 종속이라 굳이 안 건드려도 됨
	});
	renderTree();
}
// ============================== 초기화 ==============================
document.addEventListener('DOMContentLoaded', async () => {
  const btnAdd = byId('btnAdd') || byId('btnAddChild') || byId('btnAddSibling');
  if (btnAdd) btnAdd.onclick = addAuto;
  const btnDel  = byId('btnDelete'); if (btnDel)  btnDel.onclick  = removeSelected;
  const btnSave = byId('btnSave');   if (btnSave) btnSave.onclick = saveCurrent;
  const btnReset= byId('btnReset');  if (btnReset)btnReset.onclick= resetCurrent;
  const btnColAll = byId('btnCollapseAll'); if (btnColAll) btnCollapseAll.onclick = () => setAllCollapsed(true);
  const btnExpAll = byId('btnExpandAll');  if (btnExpAll) btnExpandAll.onclick   = () => setAllCollapsed(false);
  
  MENU = await loadMenu();
  console.log('RAW MENU:', MENU); // ← 여기에 실제 키 확인 가능
  snapshot();
  renderTree();
  if (MENU.length) selectNode(MENU[0].menuId);
});
</script>



</body>
</html>
