<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- ✅ Bootstrap 5.3 CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />

<!-- ✅ Bootstrap 5.3 JS (팝업/기능 사용 시 필요) -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
*{
	box-sizing: border-box;
}
#memo-body-container{
	width: 93vw;
	height: 88vh;
}
#title-area{
	width: 100%;
	height: 10vh;
	display: flex;
	justify-content: center;
	align-items: center;
}
#memo-btn-area{
	width: 97%;
	height: 5vh;
	display: flex;
	justify-content: space-between;
	margin-left: 2%;
	margin-right: 1%;
}
#memo-area{
	width: 100%;
	height: 73vh;
	background-color: beige;
	overflow: auto;
}
.memo-row{
	width: 100%;
	/* height: 25vh; */				/*유동적으로*/
	margin-bottom: 30px;
	display: flex;
	justify-content: flex-start;
	gap: 10%;
	padding-left: 10px;
}
.memo-element{
	width: 25%;
	/* height: 100%; */			
 	background-color: white;
	margin-left: 1%;
	margin-right: 1%;
}
.memo-content{
	width: 100%;
	height: 15vh;					/*고정*/
	background-color: yellow;
	overflow: hidden;
}
.memo-info{
	width: 100%;				/* 다 담기도록*/
}
.memo-info h6, .memo-info p{
	text-align: center;
}
#memoBackdrop{
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 999;
}
#memoModal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: none; /* ← 이것만 남김 */
  width: 80%;
  max-width: 800px;
  border: 1px solid #ccc;
  border-radius: 10px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  background-color: #fff;
  /* flex 관련은 JS에서 제어 */
  flex-direction: column;
  font-family: 'Arial', sans-serif;
  overflow: hidden;
  z-index: 1000;
}


/* 상단 바 */
#memo-up-bar {
  background-color: #f8f9fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  border-bottom: 1px solid #ddd;
}

#memo-up-bar label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  margin-left: auto;
  margin-right: auto;
}

#memo-up-bar input[name="memo-title"] {
  font-size: 16px;
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 300px;
}


#memo-up-bar button {
  margin: 0 5px;
}

/* 툴바 */
#memo-tool-bar {
  padding: 10px 20px;
  background-color: #f1f3f5;
  border-bottom: 1px solid #ddd;
  display: flex;
  align-items: center;
  gap: 10px;
}

#memo-tool-bar button {
  font-size: 18px;
  padding: 5px 10px;
  background: none;
  border: none;
  cursor: pointer;
}

#memo-tool-bar button:hover {
  background-color: #e0e0e0;
  border-radius: 4px;
}

#memo-tool-bar select {
  padding: 5px 10px;
}

/* 편집 영역 */
#memo-editor {
  min-height: 300px;
  padding: 20px;
  font-size: 16px;
  line-height: 1.6;
  outline: none;
  overflow-y: auto;
}

/* 저장 버튼 영역 */
#memo-save-btn-area {
  padding: 15px 20px;
  display: flex;
  justify-content: flex-end;
  background-color: #f8f9fa;
  border-top: 1px solid #ddd;
}

/* font style 강조 구분 */
#memo-tool-bar button.active {
  background-color: #ccc;
  border-radius: 4px;
  font-weight: bold;
}
/******************메모추가*************************/
#addMemoModal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: none; /* ← 이것만 남김 */
  width: 80%;
  max-width: 800px;
  border: 1px solid #ccc;
  border-radius: 10px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  background-color: #fff;
  /* flex 관련은 JS에서 제어 */
  flex-direction: column;
  font-family: 'Arial', sans-serif;
  overflow: hidden;
  z-index: 1000;
}


/* 상단 바 */
#add-memo-up-bar {
  background-color: #f8f9fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  border-bottom: 1px solid #ddd;
}

#add-memo-up-bar label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  margin-left: auto;
  margin-right: auto;
}

#add-memo-up-bar input[name="add-memo-title"] {
  font-size: 16px;
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 300px;
}


#add-memo-up-bar button {
  margin: 0 5px;
}

/* 툴바 */
#add-memo-tool-bar {
  padding: 10px 20px;
  background-color: #f1f3f5;
  border-bottom: 1px solid #ddd;
  display: flex;
  align-items: center;
  gap: 10px;
}

#add-memo-tool-bar button {
  font-size: 18px;
  padding: 5px 10px;
  background: none;
  border: none;
  cursor: pointer;
}

#add-memo-tool-bar button:hover {
  background-color: #e0e0e0;
  border-radius: 4px;
}

#add-memo-tool-bar select {
  padding: 5px 10px;
}

/* 편집 영역 */
#add-memo-editor {
  min-height: 300px;
  padding: 20px;
  font-size: 16px;
  line-height: 1.6;
  outline: none;
  overflow-y: auto;
}

/* 저장 버튼 영역 */
#add-memo-save-btn-area {
  padding: 15px 20px;
  display: flex;
  justify-content: flex-end;
  background-color: #f8f9fa;
  border-top: 1px solid #ddd;
}

/* font style 강조 구분 */
#add-memo-tool-bar button.active {
  background-color: #ccc;
  border-radius: 4px;
  font-weight: bold;
}

.editable:empty:before {
  content: attr(data-placeholder);
  color: #aaa;
  pointer-events: none;
  display: block;
}


</style>
</head>
<body>
	<input type="hidden" id="memo-project-id" value="${projectId}">
	<input type="hidden" id="memo-login-user" value="${loginUser}">
	
	 <%@ include file="../include/layout.jsp" %>	<!-- layout.jsp에서 형식 그대로 가져오기(마지막에 div3개 닫기) -->
			<!-- 바디 페이지 -->
			<div id="memo-body-container">
				<div id="title-area">
					<!--  선택한 프로젝트 이름 -->
					<h1>${selectProject.name}</h1>
				</div>
				<div id="memo-btn-area">
					<button id="add-memo-btn" class="btn btn-primary">새 메모</button>
					<select id="memo-orderby" aria-label="메모 선택">
						<option selected>수정날짜순</option>
						<option>등록날짜순</option>
					</select>
				</div>
				<div id="memo-area">
				     <c:forEach var="shareMemo" items="${shareMemoList}" varStatus="status">
					 	    <c:if test="${status.index % 3 == 0}">
							  <div class="memo-row">
						    </c:if>
								<div class="memo-element">
									<div class="memo-content">
										${shareMemo.content}
									</div>
									<div class="memo-info">
										<h6>${shareMemo.title}</h6>
										<p>${shareMemo.modifytime}</p>
										<p>${shareMemo.writter}</p>
									</div>
								</div>
							<c:if test="${status.index % 3 == 2 || status.last}">
							  </div>
							</c:if>
					</c:forEach>
				 </div>
				 <!-- 작업 추가 모달 -->
				<div id="memoModal">
				  <div id="memo-up-bar">
					  <button id="close-memo-btn" class="btn btn-secondary">돌아가기</button>
					  <label>제목:<input type="text" name="memo-title" disabled></label>
					  <button id="edit-memo-btn" class="btn btn-warning">편집</button>
					  <button id="delete-memo-btn" class="btn btn-danger">삭제</button>
				  </div>
				<div id="memo-tool-bar">
				 <!-- #memo-tool-bar 색상 버튼 확장 -->
				<button class="color-btn" onmousedown="setColor('black'); toggleActiveColor(this)">⚫</button>
				<button class="color-btn" onmousedown="setColor('blue'); toggleActiveColor(this)">🔵</button>
				<button class="color-btn" onmousedown="setColor('red'); toggleActiveColor(this)">🔴</button>
				<button class="color-btn" onmousedown="setColor('green'); toggleActiveColor(this)">🟢</button>
				<button class="color-btn" onmousedown="setColor('orange'); toggleActiveColor(this)">🟠</button>
				<button class="color-btn" onmousedown="setColor('purple'); toggleActiveColor(this)">🟣</button>

					
					<!-- Bold 버튼은 따로 -->
					<button onmousedown="setBold(this)">B</button>

				  <select onchange="setFont(this.value)">
				    <option value="Arial">Arial</option>
				    <option value="Georgia">Georgia</option>
				    <option value="Courier New">Courier</option>
				  </select>
				  
				  <!-- memoModal의 #memo-tool-bar 내부에 추가 -->
					<select onchange="setFontSize(this.value)">
					  <option value="1">매우 작게(10)</option>
					  <option value="2">작게(13)</option>
					  <option value="3" selected>기본(16)</option>
					  <option value="4">크게(18)</option>
					  <option value="5">더 크게(24)</option>
					  <option value="6">매우 크게(32)</option>
					  <option value="7">최대(48)</option>
					</select>
				</div>
				 <div id="memo-editor" contenteditable="false" class="editable" data-placeholder="여기에 메모를 입력하세요..."></div>
				  <div id="memo-save-btn-area">
				  	<button id="save-memo-btn" class="btn btn-primary">저장</button>
				  </div>
				</div>
				
				<div id="addMemoModal">
				  <div id="add-memo-up-bar">
					  <button id="close-add-memo-btn" class="btn btn-secondary">돌아가기</button>
					  <label>제목:<input type="text" id="add-memo-title" name="add-memo-title"></label>
				  </div>
				<div id="add-memo-tool-bar">
				 <!-- #add-memo-tool-bar 색상 버튼 확장 -->
				<button class="color-btn" onmousedown="addSetColor('black'); addToggleActiveColor(this)">⚫</button>
				<button class="color-btn" onmousedown="addSetColor('blue'); addToggleActiveColor(this)">🔵</button>
				<button class="color-btn" onmousedown="addSetColor('red'); addToggleActiveColor(this)">🔴</button>
				<button class="color-btn" onmousedown="addSetColor('green'); addToggleActiveColor(this)">🟢</button>
				<button class="color-btn" onmousedown="addSetColor('orange'); addToggleActiveColor(this)">🟠</button>
				<button class="color-btn" onmousedown="addSetColor('purple'); addToggleActiveColor(this)">🟣</button>

					
					<!-- Bold 버튼은 따로 -->
					<button onmousedown="addSetBold(this)">B</button>

				  <select onchange="addSetFont(this.value)">
				    <option value="Arial">Arial</option>
				    <option value="Georgia">Georgia</option>
				    <option value="Courier New">Courier</option>
				  </select>
				  
				  <!-- addMemoModal의 #add-memo-tool-bar 내부에 추가 -->
					<select onchange="addSetFontSize(this.value)">
					  <option value="1">매우 작게(10)</option>
					  <option value="2">작게(13)</option>
					  <option value="3" selected>기본(16)</option>
					  <option value="4">크게(18)</option>
					  <option value="5">더 크게(24)</option>
					  <option value="6">매우 크게(32)</option>
					  <option value="7">최대(48)</option>
					</select>
				</div>
				 <div id="add-memo-editor" contenteditable="true"  class="editable" data-placeholder="여기에 메모를 입력하세요..."></div>
				  <div id="add-memo-save-btn-area">
				  	<button id="save-add-memo-btn" class="btn btn-primary">저장</button>
				  </div>
				</div>
				 <!-- 배경 -->
				<div id="memoBackdrop"></div>
			</div>
		</div>
	</div>
	<script>
	 const loginUser = "${loginUser}";
	 //const loginUser = "아이디";
	let currentMemoIndex = null;
	
	let memoList=[];
	document.addEventListener("DOMContentLoaded", function () {
		  const projectId = document.getElementById("memo-project-id")?.value;
		  if (projectId) {
		    fetchMemos(projectId);  // ✅ 메모 불러오기
		  }
		});

	
	 /*  const memoList = [
	    <c:forEach var="shareMemo" items="${shareMemoList}" varStatus="status">
	      {
	        title: "${shareMemo.title}",
	        content: `${fn:escapeXml(shareMemo.content)}`,
	        modifytime: "${shareMemo.modifytime}",
	        writter: "${shareMemo.writter}"
	      }<c:if test="${!status.last}">,</c:if>
	    </c:forEach>
	  ]; */
	</script>
	<script>
	function renderMemos() {
		  console.log("renderMemos 실행됨, memoList.length:", memoList.length);

		  const memoArea = document.getElementById("memo-area");
		  memoArea.innerHTML = ""; // 💡 기존 요소 지우기

		  let row = null;

		  memoList.forEach((memo, index) => {
		    console.log("렌더링할 메모:", memo);

		    // 3개씩 묶기
		    if (index % 3 === 0) {
		      row = document.createElement("div");
		      row.className = "memo-row";
		      memoArea.appendChild(row);
		    }

		    // 메모 전체 박스
		    const element = document.createElement("div");
		    element.className = "memo-element";

		    // 1. 내용 div (노란 박스)
		    const contentDiv = document.createElement("div");
		    contentDiv.className = "memo-content";
		    contentDiv.innerHTML = memo.content; // ✅ 내용은 HTML이라 innerHTML 사용

		    // 2. 정보 div (제목/날짜)
		    const infoDiv = document.createElement("div");
		    infoDiv.className = "memo-info";

		    const titleEl = document.createElement("h6");
		    titleEl.textContent = memo.title || "(제목 없음)"; // ✅ title 비었을 경우 대비

		    const dateEl = document.createElement("p");
		    dateEl.textContent = memo.modifytime;
		    
		    const writterEl = document.createElement("p");
		    writterEl.textContent = memo.writter;

		    infoDiv.appendChild(titleEl);
		    infoDiv.appendChild(dateEl);
		    infoDiv.appendChild(writterEl);

		    // 합치기
		    element.appendChild(contentDiv);
		    element.appendChild(infoDiv);

		    // 클릭 이벤트 연결
		    element.addEventListener("click", function () {
		      openMemoModal(memo);
		    });

		    row.appendChild(element);
		  });
		}


	function openMemoModal(memo) {
		  const index = memoList.findIndex(m => 
		    m.title === memo.title && 
		    m.content === memo.content && 
		    m.modifytime === memo.modifytime
		  );
		  currentMemoIndex = index;

		  document.querySelector('input[name="memo-title"]').value = memo.title?.trim() || "(제목 없음)";
		  const editor = document.getElementById("memo-editor");
		  editor.innerHTML = memo.content || "<p>(내용 없음)</p>";

		  isEditing = false;
		  editor.setAttribute("contenteditable", false);
		  document.getElementById("edit-memo-btn").textContent = "편집";

		  document.getElementById("memoModal").style.display = "flex";
		  document.getElementById("memoBackdrop").style.display = "block";
		}

	</script>
	<script>
	  renderMemos();  // 페이지 로드시 초기 렌더링
	</script>

	<script>
	  document.getElementById("add-memo-btn").addEventListener("click", function () {
		  resetAddMemoModal();  // ← 초기화 호출
		    document.getElementById("addMemoModal").style.display = "flex";
		    document.getElementById("memoBackdrop").style.display = "block";
		  });
	  document.getElementById("close-add-memo-btn").addEventListener("click", function () {
		    document.getElementById("addMemoModal").style.display = "none";
		    document.getElementById("memoBackdrop").style.display = "none";
		  });
	  document.getElementById("close-memo-btn").addEventListener("click", function () {
		    document.getElementById("memoModal").style.display = "none";
		    document.getElementById("memoBackdrop").style.display = "none";
		  });
	 
	  ////메모보기
	  let isEditing = false;

	  document.getElementById("edit-memo-btn").addEventListener("click", function () {
	    isEditing = !isEditing;

	    const editor = document.getElementById("memo-editor");
	    editor.setAttribute("contenteditable", isEditing);
	    
	    const titleInput = document.querySelector('input[name="memo-title"]');
	    titleInput.disabled = !isEditing; // ✅ 제목 활성/비활성 전환

	    this.textContent = isEditing ? "편집완료" : "편집";
	  });

	  function setColor(color) {
		  if (isEditing) {
		    document.execCommand('foreColor', false, color);
		  }
		}

	  function setBold(btn) {
		  if (isEditing) {
		    document.execCommand('bold', false, null);
		    toggleActiveBold(btn);
		  }
		}


		function setFont(fontName) {
		  if (isEditing) {
		    document.execCommand('fontName', false, fontName);
		  }
		}
	
		function toggleActiveColor(btn) {
			  // 색상 버튼들만 active 제어
			  const colorButtons = document.querySelectorAll('#memo-tool-bar button.color-btn');
			  colorButtons.forEach(b => b.classList.remove('active'));
			  btn.classList.add('active');
		}

		function toggleActiveBold(btn) {
		  // Bold 버튼은 토글
		  btn.classList.toggle('active');
		}
		
		////메모추가
		 function addSetColor(color) {
			    document.execCommand('foreColor', false, color);
			}

		  function addSetBold(btn) {
			    document.execCommand('bold', false, null);
			    toggleActiveBold(btn);
			}


			function addSetFont(fontName) {
			    document.execCommand('fontName', false, fontName);
			}

		
		function addToggleActiveColor(btn) {
			  // 색상 버튼들만 active 제어
			  const colorButtons = document.querySelectorAll('#add-memo-tool-bar button.color-btn');
			  colorButtons.forEach(b => b.classList.remove('active'));
			  btn.classList.add('active');
		}
		
		function resetAddMemoModal() {
			  document.getElementById("add-memo-title").value = "";
			  document.getElementById("add-memo-editor").innerHTML = "";
			  document.querySelectorAll("#add-memo-tool-bar button").forEach(btn => btn.classList.remove("active"));
			}
		
		////글자크기
		function setFontSize(size) {
		  if (isEditing) {
		    document.execCommand('fontSize', false, size);
		  }
		}
		
		function addSetFontSize(size) {
		  document.execCommand('fontSize', false, size);
		}

		
		/////////////////메모CRUD
		function fetchMemos(projectId) {
		  fetch(`/memo/list?projectId=${projectId}`)
		    .then(res => res.json())
		    .then(data => {
		      memoList.length = 0;
		      memoList.push(...data);
		      renderMemos();
		    });
		}


		/////////////////////////////////메모 저장
		document.getElementById("save-add-memo-btn").addEventListener("click", function () {
  const title = document.getElementById("add-memo-title").value.trim();
  const content = document.getElementById("add-memo-editor").innerHTML.trim();

  if (!title || !content) {
    alert("제목과 내용을 입력해주세요.");
    return;
  }

  const projectId = document.getElementById("memo-project-id").value;
  const newMemo = {
    projectId: projectId,
    title: title,
    content: content,
    writter: loginUser
  };

  console.log("📤 저장 요청 보냄:", newMemo);  // ✅ 전송 전 로그

  fetch("/memo/create", {
    method: "POST",
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(newMemo)
  })
    .then(res => {
      console.log("📥 서버 응답 상태:", res.status);  // ✅ 응답 상태 확인 (200, 500 등)
      if (!res.ok) {
        throw new Error("메모 저장 실패");
      }
      return res.text();  // 응답 body를 문자열로 받음
    })
    .then(text => {
      console.log("📥 응답 본문:", text); // ✅ 응답 메시지 로그
      fetchMemos(projectId); // 메모 다시 불러오기
      resetAddMemoModal();
      document.getElementById("addMemoModal").style.display = "none";
      document.getElementById("memoBackdrop").style.display = "none";
    })
    .catch(err => {
      console.error("❌ 저장 중 에러 발생:", err);  // ✅ 실패 시 에러 로그
      alert("메모 저장에 실패했습니다.");
    });
});



	////////////////변경 (서버에 저장하려면 AJAX 필요)
	document.getElementById("save-memo-btn").addEventListener("click", function () {
  const memo = memoList[currentMemoIndex];
  const newTitle = document.querySelector('input[name="memo-title"]').value.trim();
  const newContent = document.getElementById("memo-editor").innerHTML.trim();

  if (!newTitle || !newContent) {
    alert("제목과 내용을 입력해주세요.");
    return;
  }

  const updatedMemo = {
    id: memo.id,
    title: newTitle,
    content: newContent
  };

  fetch("/memo/update", {
    method: "POST",
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(updatedMemo)
  }).then(() => {
    fetchMemos(memo.projectId); // 최신화
    document.getElementById("memoModal").style.display = "none";
    document.getElementById("memoBackdrop").style.display = "none";
    currentMemoIndex = null;
  });
});

	//삭제
document.getElementById("delete-memo-btn").addEventListener("click", function () {
  const memo = memoList[currentMemoIndex];

  if (!memo || !memo.id) {
    alert("삭제할 메모를 찾을 수 없습니다.");
    return;
  }

  if (!confirm("정말 삭제하시겠습니까?")) return;

  fetch("/memo/delete", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ id: memo.id })  // ✅ POST로 ID 전송
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`❌ 삭제 실패: HTTP ${response.status}`);
      }
      return response.text();
    })
    .then(data => {
      console.log("✅ 삭제 응답:", data);
      alert("삭제되었습니다.");
      fetchMemos(memo.projectId);  // 목록 다시 불러오기
      document.getElementById("memoModal").style.display = "none";
      document.getElementById("memoBackdrop").style.display = "none";
      currentMemoIndex = null;
    })
    .catch(error => {
      console.error("❌ 삭제 중 오류:", error);
      alert("메모 삭제에 실패했습니다.");
    });
});


		

	
	



	</script>
</body>
</html>