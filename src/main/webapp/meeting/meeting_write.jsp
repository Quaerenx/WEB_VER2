<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="회의록 작성" scope="request" />
<%@ include file="/includes/header.jsp" %>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-pen"></i> 새 회의록 작성</h2>
        <p>회의 내용을 정리하여 등록해주세요.</p>
    </div>
    
    <!-- 오류 메시지 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>
    
    <!-- 작성 폼 -->
    <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/meeting" id="meetingForm">
            <input type="hidden" name="action" value="write">
            
            <!-- 기본 정보 -->
            <div class="section-title">회의 기본 정보</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="title">회의 제목 <span class="required">*</span></label>
                    <input type="text" id="title" name="title" required maxlength="200" 
                           placeholder="회의 제목을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="meeting_type">회의 유형 <span class="required">*</span></label>
                    <select id="meeting_type" name="meeting_type" required>
                        <option value="">회의 유형을 선택하세요</option>
                        <option value="daily">일일 회의</option>
                        <option value="weekly">주간 회의</option>
                        <option value="monthly">월간 회의</option>
                        <option value="project">프로젝트 회의</option>
                        <option value="emergency">긴급 회의</option>
                        <option value="other">기타</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="meeting_datetime">회의 일시 <span class="required">*</span></label>
                    <input type="datetime-local" id="meeting_datetime" name="meeting_datetime" required>
                </div>
                <div class="form-group">
                    <!-- 공간 확보용 -->
                </div>
            </div>
            
            <!-- 회의 내용 -->
            <div class="section-title">회의 내용</div>
            
            <div class="form-row">
                <div class="form-group full-width">
                    <label for="content">회의록 내용 <span class="required">*</span></label>
                    <textarea id="content" name="content" rows="15" required 
                              placeholder="회의 내용을 상세히 작성해주세요.&#10;&#10;• 참석자:&#10;• 주요 논의사항:&#10;• 결정사항:&#10;• 액션 아이템:&#10;• 다음 회의 일정:"></textarea>
                </div>
            </div>
            
            <!-- 버튼 -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/meeting?view=list" class="btn btn-cancel">취소</a>
                <button type="button" class="btn btn-preview" onclick="previewContent()">미리보기</button>
                <button type="submit" class="btn btn-primary">등록하기</button>
            </div>
        </form>
    </div>
</div>

<!-- 미리보기 모달 -->
<div id="previewModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-eye"></i> 미리보기</h3>
            <button type="button" class="modal-close" onclick="closePreview()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="preview-content">
                <div class="preview-meta">
                    <h2 id="preview-title"></h2>
                    <div class="preview-info">
                        <span class="preview-type"></span>
                        <span class="preview-datetime"></span>
                        <span class="preview-author">작성자: ${user.userName}</span>
                    </div>
                </div>
                <div class="preview-text" id="preview-content"></div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closePreview()">닫기</button>
        </div>
    </div>
</div>

<style>
/* 기본 레이아웃 */
.container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
    text-align: center;
}

.page-header h2 {
    color: #333;
    margin-bottom: 10px;
}

.page-header p {
    color: #666;
    margin: 0;
}

/* 폼 컨테이너 */
.form-container {
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* 섹션 제목 */
.section-title {
    font-size: 16px;
    font-weight: bold;
    color: #333;
    margin: 25px 0 15px 0;
    padding-bottom: 8px;
    border-bottom: 2px solid #007bff;
}

.section-title:first-child {
    margin-top: 0;
}

/* 폼 행 */
.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

.form-group {
    flex: 1;
}

.form-group.full-width {
    flex: 1 1 100%;
}

/* 라벨 */
.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
    color: #333;
    font-size: 14px;
}

.required {
    color: #dc3545;
}

/* 입력 필드 */
.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    background: white;
    transition: border-color 0.2s;
    box-sizing: border-box;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
}

.form-group textarea {
    resize: vertical;
    min-height: 300px;
    line-height: 1.6;
    font-family: inherit;
}

/* 버튼 그룹 */
.button-group {
    text-align: center;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #eee;
}

.btn {
    display: inline-block;
    padding: 12px 24px;
    margin: 0 5px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-primary {
    background: #007bff;
    color: white;
}

.btn-primary:hover {
    background: #0056b3;
}

.btn-preview {
    background: #17a2b8;
    color: white;
}

.btn-preview:hover {
    background: #138496;
}

.btn-cancel {
    background: #6c757d;
    color: white;
}

.btn-cancel:hover {
    background: #545b62;
    text-decoration: none;
}

.btn-secondary {
    background: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background: #545b62;
}

/* 알림 메시지 */
.alert {
    padding: 12px 16px;
    margin-bottom: 20px;
    border-radius: 4px;
    border: 1px solid transparent;
}

.alert-danger {
    color: #721c24;
    background-color: #f8d7da;
    border-color: #f5c6cb;
}

/* 모달 스타일 */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.modal-content {
    background-color: white;
    margin: 5% auto;
    border-radius: 8px;
    width: 80%;
    max-width: 800px;
    max-height: 80vh;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.modal-header {
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #dee2e6;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f8f9fa;
}

.modal-header h3 {
    margin: 0;
    color: #333;
}

.modal-close {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    color: #6c757d;
    padding: 0;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-close:hover {
    color: #000;
}

.modal-body {
    padding: 1.5rem;
    max-height: 60vh;
    overflow-y: auto;
}

.modal-footer {
    padding: 1rem 1.5rem;
    border-top: 1px solid #dee2e6;
    text-align: right;
    background: #f8f9fa;
}

/* 미리보기 내용 스타일 */
.preview-content {
    font-family: inherit;
}

.preview-meta {
    margin-bottom: 2rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #e9ecef;
}

.preview-meta h2 {
    margin: 0 0 1rem 0;
    color: #333;
    font-size: 1.5rem;
}

.preview-info {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    font-size: 0.9rem;
    color: #6c757d;
}

.preview-info span {
    background: #f8f9fa;
    padding: 0.25rem 0.75rem;
    border-radius: 4px;
    border: 1px solid #e9ecef;
}

.preview-text {
    line-height: 1.8;
    color: #333;
    white-space: pre-wrap;
    font-size: 0.95rem;
}

/* 반응형 */
@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    
    .form-container {
        padding: 20px;
    }
    
    .form-row {
        flex-direction: column;
        gap: 10px;
    }
    
    .form-group {
        flex: none;
    }
    
    .button-group {
        text-align: stretch;
    }
    
    .btn {
        display: block;
        width: 100%;
        margin: 5px 0;
    }
    
    .modal-content {
        width: 95%;
        margin: 2% auto;
    }
    
    .preview-info {
        flex-direction: column;
        gap: 0.5rem;
    }
}
</style>

<script>
// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', function() {
    // 현재 날짜시간을 기본값으로 설정
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    
    const currentDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById('meeting_datetime').value = currentDateTime;
});

// 미리보기 기능
function previewContent() {
    const title = document.getElementById('title').value.trim();
    const meetingType = document.getElementById('meeting_type').value;
    const meetingDateTime = document.getElementById('meeting_datetime').value;
    const content = document.getElementById('content').value.trim();
    
    if (!title) {
        alert('회의 제목을 입력해주세요.');
        document.getElementById('title').focus();
        return;
    }
    
    if (!meetingType) {
        alert('회의 유형을 선택해주세요.');
        document.getElementById('meeting_type').focus();
        return;
    }
    
    if (!meetingDateTime) {
        alert('회의 일시를 선택해주세요.');
        document.getElementById('meeting_datetime').focus();
        return;
    }
    
    if (!content) {
        alert('회의 내용을 입력해주세요.');
        document.getElementById('content').focus();
        return;
    }
    
    // 미리보기 데이터 설정
    document.getElementById('preview-title').textContent = title;
    document.querySelector('.preview-type').textContent = getTypeLabel(meetingType);
    document.querySelector('.preview-datetime').textContent = formatDateTime(meetingDateTime);
    document.getElementById('preview-content').textContent = content;
    
    // 모달 표시
    document.getElementById('previewModal').style.display = 'block';
}

// 미리보기 닫기
function closePreview() {
    document.getElementById('previewModal').style.display = 'none';
}

// 회의 유형 라벨 변환
function getTypeLabel(type) {
    const typeLabels = {
        'daily': '일일 회의',
        'weekly': '주간 회의',
        'monthly': '월간 회의',
        'project': '프로젝트 회의',
        'emergency': '긴급 회의',
        'other': '기타'
    };
    return typeLabels[type] || type;
}

// 날짜시간 포맷팅
function formatDateTime(dateTimeString) {
    const date = new Date(dateTimeString);
    return date.toLocaleString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// 모달 외부 클릭 시 닫기
window.onclick = function(event) {
    const modal = document.getElementById('previewModal');
    if (event.target === modal) {
        closePreview();
    }
}

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closePreview();
    }
});

// 폼 유효성 검사
document.getElementById('meetingForm').addEventListener('submit', function(e) {
    const title = document.getElementById('title').value.trim();
    const meetingType = document.getElementById('meeting_type').value;
    const meetingDateTime = document.getElementById('meeting_datetime').value;
    const content = document.getElementById('content').value.trim();
    
    if (!title) {
        e.preventDefault();
        alert('회의 제목을 입력해주세요.');
        document.getElementById('title').focus();
        return false;
    }
    
    if (!meetingType) {
        e.preventDefault();
        alert('회의 유형을 선택해주세요.');
        document.getElementById('meeting_type').focus();
        return false;
    }
    
    if (!meetingDateTime) {
        e.preventDefault();
        alert('회의 일시를 선택해주세요.');
        document.getElementById('meeting_datetime').focus();
        return false;
    }
    
    if (!content) {
        e.preventDefault();
        alert('회의 내용을 입력해주세요.');
        document.getElementById('content').focus();
        return false;
    }
    
    // 제출 확인
    return confirm('회의록을 등록하시겠습니까?');
});

// 페이지 이탈 시 경고 (내용이 있는 경우)
window.addEventListener('beforeunload', function(e) {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    
    if (title || content) {
        e.preventDefault();
        e.returnValue = '';
        return '';
    }
});
</script>

<%@ include file="/includes/footer.jsp" %>