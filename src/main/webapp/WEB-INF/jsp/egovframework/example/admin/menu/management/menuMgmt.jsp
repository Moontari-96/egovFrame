<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${pageTitle}</title>
  <style>
    :root { --bg:#fff; --line:#e5e8eb; --muted:#667085; --primary:#4dabf7; --danger:#ff6b6b; }
    body { margin:0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Noto Sans KR, Arial, sans-serif; color:#1f2937; }
    .page { padding:20px; }
    .card { background:#fff; padding:16px; border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,.08); }
    .grid { display:grid; grid-template-columns: 340px 1fr; gap:16px; }

    /* Left: Tree */
    .tree { border:1px solid var(--line); border-radius:10px; overflow:hidden; }
    .tree-header { display:flex; align-items:center; gap:8px; padding:10px 12px; border-bottom:1px solid var(--line); background:#f8fafc; }
    .tree-body { max-height: 70vh; overflow:auto; padding:8px 10px; }
    .node { display:flex; align-items:center; gap:6px; padding:4px 6px; border-radius:6px; cursor:pointer; }
    .node:hover { background:#f3f6fb; }
    .node.active { background:#e9f2ff; outline:1px solid #cfe3ff; }
    .twist { width:16px; height:16px; display:inline-flex; align-items:center; justify-content:center; border:1px solid var(--line); border-radius:4px; font-size:12px; }
    .twist.empty { opacity:.2; }
    .twist.hidden { visibility: hidden; }
    /* 보기 좋게 살짝 들여쓰기(선택) */
	.node.d2 { padding-left: 12px; }
	.node.d3 { padding-left: 24px; }
    .label { flex:1; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    ul.tree-ul { list-style:none; margin:0; padding-left:16px; }
    ul.tree-ul > li { margin:2px 0; }

    .toolbar { display:flex; gap:8px; }
	/* 버튼 리뉴얼 */
	.btn {
	  padding: 10px 14px;
	  border: 1px solid #e5e8eb;
	  border-radius: 10px;
	  background: #fff;
	  cursor: pointer;
	  font-weight: 600;
	  transition: all .15s ease;
	  box-shadow: 0 1px 1px rgba(0,0,0,.02);
	}
	.btn:hover { transform: translateY(-1px); box-shadow: 0 3px 10px rgba(0,0,0,.06); }
	.btn:active { transform: translateY(0); box-shadow: 0 1px 2px rgba(0,0,0,.04); }
	
	.btn-primary {
	  background: linear-gradient(180deg, #5bb6ff, #4dabf7);
	  color: #fff;
	  border-color: #4dabf7;
	}
	.btn-primary:hover { filter: brightness(.97); }
	
	.btn-danger {
	  background: linear-gradient(180deg, #ff7d7d, #ff6b6b);
	  color: #fff;
	  border-color: #ff6b6b;
	}

    /* Right: Detail */
    .panel { border:1px solid var(--line); border-radius:10px; overflow:hidden; }
    .panel-header { padding:10px 12px; border-bottom:1px solid var(--line); background:#f8fafc; display:flex; align-items:center; justify-content:space-between; gap:8px; }
    .panel-body { padding:14px; display:grid; grid-template-columns: 1fr 1fr; gap:12px; }
    .field { display:flex; flex-direction:column; gap:6px; }
    .field label { font-size:12px; color:#475569; }
    .field input[type="text"], .field input[type="number"] { padding:10px 12px; border:1px solid var(--line); border-radius:8px; font-size:14px; }
    .switch { position:relative; width:44px; height:24px; }
    .switch input { opacity:0; width:0; height:0; }
    .slider { position:absolute; inset:0; background:#dbe2ea; border-radius:999px; transition:.2s; }
    .slider:before { content:""; position:absolute; width:18px; height:18px; left:3px; top:3px; background:#fff; border-radius:50%; box-shadow:0 1px 2px rgba(0,0,0,.2); transition:.2s; }
    .switch input:checked + .slider { background:#4dabf7; }
    .switch input:checked + .slider:before { transform:translateX(20px); }

    .muted { color: var(--muted); font-size:12px; }
  </style>
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
          <div class="field"><label>정렬순서 (sortOrder)</label><input id="f_sort" type="number" value="0"></div>
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
    const pid       = m.parentId ?? m.parent_id ?? m.pid ?? m.parent;
    const name      = m.menuName ?? m.name ?? m.menu_name ?? m.title;
    const url       = m.menuUrl ?? m.url ?? m.path;
    const depth     = m.menuDepth ?? m.depth ?? m.menu_depth;
    const sort      = m.sortOrder ?? m.sort ?? m.sort_order ?? m.ord;
    const active    = (m.isActive ?? m.active ?? m.useYn ?? m.enabled);

    return {
      menuId   : toNum(id),
      parentId : toNum(pid, 0),
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

	  byId('f_parentId').value = m.parentId || 0;
	  byId('f_depth').value    = m.menuDepth || 1;
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
    menuId:   tempSeq--,
    parentId: canBeChild ? parent.menuId : 0,      // 선택 없거나 최대뎁스면 루트
    menuName: '새 메뉴',
    menuUrl:  '',
    sortOrder: 9999,
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
function removeSelected(){
  if(selectedId == null){ alert('삭제할 메뉴를 선택하세요.'); return; }
  const ids = collectWithChildren(selectedId);
  if(!confirm(`하위 포함 ${ids.length}개 항목을 삭제하시겠습니까?`)) return;

  for(const id of ids){ const idx = MENU.findIndex(m=>m.menuId===id); if(idx>=0) MENU.splice(idx,1); }
  selectedId = null; renderTree(); clearDetail();

  const form = new URLSearchParams();
  form.append('ids', JSON.stringify(ids));
  if(csrfParam) form.append(csrfParam, csrfToken);
  fetch('<c:url value="/admin/menu/delete.do"/>', {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: form
  }).then(r=>r.json()).then(j=>{ if(!j.success) alert(j.message||'삭제 실패'); })
    .catch(()=> alert('삭제 중 오류'));
}

function saveCurrent(){
  if(selectedId == null){ alert('저장할 메뉴를 선택하세요.'); return; }
  const m = MENU.find(x=>x.menuId===selectedId);
  m.menuName = byId('f_name').value.trim();
  m.menuUrl  = byId('f_url').value.trim();
  m.sortOrder = Number(byId('f_sort').value||0);
  m.isActive = byId('f_active').checked;

  const row = JSON.parse(JSON.stringify(m));
  if(row.menuId < 0) row.clientTempId = row.menuId;

  let url = '<c:url value="/admin/menu/batch-save.do"/>';
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
    if (d <= 2) collapsedState.set(m.menuId, !!flag); // 1·2뎁스만 대상
  });
  renderTree();
}

//depth=1 -> 루트 접기(2·3 안 보임)
//depth=2 -> 1뎁스는 펼치고 2뎁스부터 접기(=3만 숨김)
function collapseAtDepth(depth){
MENU.forEach(n => {
 const d = n.menuDepth || 1;
 if (d < depth) collapsedState.set(n.menuId, false);      // 상위는 펼침
 else if (d === depth) collapsedState.set(n.menuId, true); // 해당 뎁스 접기
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
  const btnColAll = byId('btnCollapseAll'); if (btnColAll) btnColAll.onclick = ()=> setAllCollapsed(true);
  const btnExpAll = byId('btnExpandAll');  if (btnExpAll) btnExpAll.onclick  = ()=> setAllCollapsed(false);
  
  MENU = await loadMenu();
  console.log('RAW MENU:', MENU); // ← 여기에 실제 키 확인 가능
  snapshot();
  renderTree();
  if (MENU.length) selectNode(MENU[0].menuId);
});
</script>



</body>
</html>
