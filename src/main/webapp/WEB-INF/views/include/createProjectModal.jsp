<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 모달 오버레이 */
.new-project-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.4);
  display: none; /* 기본은 숨김 */
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

/* 모달 본체 */
.new-project-modal {
  background-color: #fff;
  padding: 24px;
  border-radius: 10px;
  width: 400px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.3);
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.new-project-modal h2 {
  margin-bottom: 10px;
  text-align: center;
}

/* 입력 필드 스타일 */
.new-project-modal label {
  display: flex;
  flex-direction: column;
  font-size: 14px;
}

.new-project-modal input[type="text"],
.new-project-modal input[type="date"],
.new-project-modal textarea {
  padding: 8px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}

.new-project-modal textarea {
  resize: vertical;
  min-height: 80px;
}

/* 버튼 영역 */
.new-project-modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

</style>
</head>
<body>
<div id="new-project-modal-overlay" class="new-project-modal-overlay">
  <!-- 모달 창 -->
  <div class="new-project-modal">
    <h2>새 프로젝트 생성</h2>
    
    <label>
      프로젝트 제목:
      <input type="text" id="new-project-title" placeholder="프로젝트 이름을 입력하세요" />
    </label>

    <label>
      생성자:
      <input type="text" id="new-project-owner" placeholder="생성자 이름" />
    </label>

    <label>
      프로젝트 기간:
      <input type="date" id="new-project-start-date" /> ~ <input type="date" id="new-project-end-date" />
    </label>

    <label>
      설명:
      <textarea id="new-project-desc" placeholder="프로젝트 설명을 입력하세요"></textarea>
    </label>

    <div class="new-project-modal-actions">
      <button id="create-new-project-btn">생성</button>
      <button id="close-modal-btn">취소</button>
    </div>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
	  const openBtns = document.querySelectorAll('.open-new-project-modal-btn');
	  const closeBtn = document.getElementById('close-modal-btn');
	  const createBtn = document.getElementById('create-new-project-btn');
	  const modalOverlay = document.getElementById('new-project-modal-overlay');

	  if (!modalOverlay || !closeBtn || !createBtn) {
	    console.warn('모달 관련 요소가 누락되었습니다.');
	    return;
	  }

	  openBtns.forEach(btn => {
	    btn.addEventListener('click', () => {
	      modalOverlay.style.display = 'flex';
	    });
	  });

	  closeBtn.addEventListener('click', () => {
	    modalOverlay.style.display = 'none';
	  });

	  createBtn.addEventListener('click', () => {
	    const title = document.getElementById('new-project-title').value.trim();
	    const startDate = document.getElementById('new-project-start-date').value;
	    const endDate = document.getElementById('new-project-end-date').value;
	    const description = document.getElementById('new-project-desc').value.trim();

	    if (!title || !startDate || !endDate) {
	      alert('모든 필드를 입력해주세요.');
	      return;
	    }

	    const projectData = {
	      title,
	      content: description,
	      startDt: startDate,
	      endDt: endDate
	    };

	    $.ajax({
	        url: '/project/create',
	        method: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(projectData),
	        success: function (response) {
	            alert('프로젝트가 생성되었습니다!');
	            // 서버 응답(response)으로 받은 URL로 페이지 이동
	            if (response) {
	                window.location.href = response;
	            } else {
	                // 응답이 없거나 예기치 않은 경우, 기본 페이지로 리로드
	                location.reload();
	            }
	        },
	        error: function (xhr) {
	            alert('생성 실패: ' + xhr.responseText);
	        }
	    });
	  });
	});

</script>

</body>
</html>