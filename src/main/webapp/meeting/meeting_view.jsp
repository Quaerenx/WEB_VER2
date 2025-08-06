<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${meeting.title}" scope="request" />
<%@ include file="/includes/header.jsp" %>

<style>
	.meeting-view {
	    width: 100%;
	    max-width: 1000px;
	    margin: 0 auto;
	    padding: var(--space-32) var(--space-16);
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	}
    .back-navigation {
        margin-bottom: 1rem;
    }
    
    .back-link {
        color: #6c757d;
        text-decoration: none;
        font-size: 0.9rem;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: color 0.2s ease;
    }
    
    .back-link:hover {
        color: #495057;
        text-decoration: none;
    }
    
    /* 회의록 헤더 */
    .meeting-header {
        background: white;
        padding: 2rem;
        border-radius: 12px;
        margin-bottom: 1.5rem;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        border: 1px solid #e8ecef;
    }
    
    .meeting-title {
        font-size: 2rem;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 1rem;
        line-height: 1.3;
    }
    
    .meeting-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
        font-size: 0.95rem;
        color: #6c757d;
    }
    
    .meta-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .meta-item i {
        color: #6c757d;
        width: 16px;
    }
    
    .type-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 500;
        text-align: center;
    }
    
    .type-daily { background: #dbeafe; color: #1e40af; }
    .type-weekly { background: #dcfce7; color: #166534; }
    .type-monthly { background: #fef3c7; color: #92400e; }
    .type-project { background: #ede9fe; color: #7c2d12; }
    .type-emergency { background: #fee2e2; color: #991b1b; }
    .type-default { background: #f3f4f6; color: #6b7280; }
    
    .meeting-actions {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }
    
    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        border: none;
        cursor: pointer;
        font-size: 0.875rem;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #4f46e5, #7c3aed);
        color: white;
    }
    
    .btn-primary:hover {
        background: linear-gradient(135deg, #4338ca, #6d28d9);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        color: white;
        text-decoration: none;
    }
    
    .btn-danger {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
    }
    
    .btn-danger:hover {
        background: linear-gradient(135deg, #dc2626, #b91c1c);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        color: white;
        text-decoration: none;
    }
    
    .btn-secondary {
        background: #f1f5f9;
        color: #475569;
        border: 1px solid #e2e8f0;
    }
    
    .btn-secondary:hover {
        background: #e2e8f0;
        color: #334155;
        text-decoration: none;
    }
    
    /* 회의록 내용 */
    .meeting-content {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        border: 1px solid #e5e7eb;
        overflow: hidden;
        margin-bottom: 2rem;
    }
    
    .content-header {
        background: linear-gradient(135deg, #f8fafc, #e2e8f0);
        padding: 1.5rem;
        border-bottom: 1px solid #e5e7eb;
    }
    
    .content-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #374151;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin: 0;
    }
    
    .content-body {
        padding: 2rem;
    }
    
    .meeting-text {
        line-height: 1.8;
        color: #374151;
        white-space: pre-wrap;
        font-size: 1rem;
    }
    
    /* 댓글 섹션 */
    .comments-section {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        border: 1px solid #e5e7eb;
        overflow: hidden;
    }
    
    .comments-header {
        background: linear-gradient(135deg, #f8fafc, #e2e8f0);
        padding: 1.5rem;
        border-bottom: 1px solid #e5e7eb;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .comments-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #374151;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin: 0;
    }
    
    .comment-count {
        background: #dbeafe;
        color: #1e40af;
        padding: 0.25rem 0.75rem;
        border-radius: 12px;
        font-size: 0.875rem;
        font-weight: 500;
    }
    
    /* 댓글 작성 폼 */
    .comment-form {
        padding: 1.5rem;
        border-bottom: 1px solid #f3f4f6;
        background: #fafbfc;
    }
    
    .comment-textarea {
        width: 100%;
        padding: 1rem;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        resize: vertical;
        min-height: 100px;
        font-family: inherit;
        font-size: 0.95rem;
        line-height: 1.6;
        box-sizing: border-box;
    }
    
    .comment-textarea:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.25);
    }
    
    .comment-form-actions {
        margin-top: 1rem;
        text-align: right;
    }
    
    .btn-comment {
        background: #10b981;
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s ease;
    }
    
    .btn-comment:hover {
        background: #059669;
        transform: translateY(-1px);
    }
    
    .btn-comment:disabled {
        background: #9ca3af;
        cursor: not-allowed;
        transform: none;
    }
    
    /* 댓글 목록 */
    .comments-list {
        padding: 1.5rem;
    }
    
    .comment-item {
        border-bottom: 1px solid #f3f4f6;
        padding: 1.5rem 0;
        position: relative;
    }
    
    .comment-item:last-child {
        border-bottom: none;
        padding-bottom: 0;
    }
    
    .comment-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 0.75rem;
    }
    
    .comment-author {
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.25rem;
    }
    
    .comment-date {
        font-size: 0.8rem;
        color: #9ca3af;
    }
    
    .comment-actions {
        display: flex;
        gap: 0.5rem;
    }
    
    .comment-btn {
        background: none;
        border: none;
        color: #6b7280;
        font-size: 0.75rem;
        cursor: pointer;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        transition: all 0.2s ease;
    }
    
    .comment-btn:hover {
        background: #f3f4f6;
        color: #374151;
    }
    
    .comment-btn.edit:hover {
        color: #f59e0b;
    }
    
    .comment-btn.delete:hover {
        color: #ef4444;
    }
    
    .comment-content {
        color: #374151;
        line-height: 1.6;
        white-space: pre-wrap;
        margin-bottom: 0.5rem;
    }
    
    .comment-edit-form {
        display: none;
        margin-top: 1rem;
    }
    
    .comment-edit-textarea {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        resize: vertical;
        min-height: 80px;
        font-family: inherit;
        font-size: 0.9rem;
        line-height: 1.6;
        box-sizing: border-box;
    }
    
    .comment-edit-actions {
        margin-top: 0.75rem;
        display: flex;
        gap: 0.5rem;
    }
    
    .btn-save {
        background: #10b981;
        color: white;
        padding: 0.375rem 0.75rem;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        font-size: 0.8rem;
        font-weight: 500;
    }
    
    .btn-save:hover {
        background: #059669;
    }
    
    .btn-cancel-edit {
        background: #6c757d;
        color: white;
        padding: 0.375rem 0.75rem;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        font-size: 0.8rem;
        font-weight: 500;
    }
    
    .btn-cancel-edit:hover {
        background: #545b62;
    }
    
    .empty-comments {
        text-align: center;
        padding: 3rem 2rem;
        color: #9ca3af;
    }
    
    .empty-comments i {
        font-size: 3rem;
        margin-bottom: 1rem;
        opacity: 0.5;
        color: #d1d5db;
    }
    
    .alert {
        padding: 1rem 1.25rem;
        margin-bottom: 1.5rem;
        border-radius: 8px;
        border: none;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }
    
    .alert-success {
        background: #f0fdf4;
        color: #166534;
        border-left: 4px solid #22c55e;
    }
    
    .alert-danger {
        background: #fef2f2;
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }
    
    /* 반응형 디자인 */
	@media (max-width: 768px) {
	    .meeting-view {
	        max-width: 100%;
	        padding: var(--space-24) var(--space-16);
	    }
        
        .meeting-header {
            padding: 1.5rem;
        }
        
        .meeting-title {
            font-size: 1.5rem;
        }
        
        .meeting-meta {
            flex-direction: column;
            gap: 0.75rem;
        }
        
        .meeting-actions {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
        
        .content-body {
            padding: 1.5rem;
        }
        
        .comment-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }
        
        .comment-actions {
            order: -1;
        }
    }
</style>

<div class="meeting-view">
    <!-- 뒤로 가기 -->
    <div class="back-navigation">
        <a href="${pageContext.request.contextPath}/meeting?view=list" class="back-link">
            <i class="fas fa-arrow-left"></i>
            회의록 목록으로 돌아가기
        </a>
    </div>
    
    <!-- 성공/에러 메시지 표시 -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            ${sessionScope.message}
        </div>
        <c:remove var="message" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session" />
    </c:if>
    
    <!-- 회의록 헤더 -->
    <div class="meeting-header">
        <h1 class="meeting-title">${meeting.title}</h1>
        
        <div class="meeting-meta">
            <div class="meta-item">
                <i class="fas fa-tag"></i>
                <span class="type-badge type-${meeting.meetingType.toLowerCase()}">${meeting.meetingType}</span>
            </div>
            <div class="meta-item">
                <i class="fas fa-calendar"></i>
                <fmt:formatDate value="${meeting.meetingDatetime}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            <div class="meta-item">
                <i class="fas fa-user"></i>
                ${meeting.authorName}
            </div>
            <div class="meta-item">
                <i class="fas fa-eye"></i>
                조회 ${meeting.viewCount}
            </div>
            <div class="meta-item">
                <i class="fas fa-clock"></i>
                <fmt:formatDate value="${meeting.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>
        
        <c:if test="${meeting.authorId == user.userId}">
            <div class="meeting-actions">
                <a href="${pageContext.request.contextPath}/meeting?view=edit&id=${meeting.meetingId}" class="btn btn-primary">
                    <i class="fas fa-edit"></i>
                    수정하기
                </a>
                <button type="button" class="btn btn-danger" onclick="confirmDelete()">
                    <i class="fas fa-trash"></i>
                    삭제하기
                </button>
            </div>
        </c:if>
    </div>
    
    <!-- 회의록 내용 -->
    <div class="meeting-content">
        <div class="content-header">
            <h2 class="content-title">
                <i class="fas fa-file-alt"></i>
                회의 내용
            </h2>
        </div>
        <div class="content-body">
            <div class="meeting-text">${meeting.content}</div>
        </div>
    </div>
    
    <!-- 댓글 섹션 -->
    <div class="comments-section">
        <div class="comments-header">
            <h2 class="comments-title">
                <i class="fas fa-comments"></i>
                댓글
            </h2>
            <span class="comment-count">${comments.size()}개</span>
        </div>
        
        <!-- 댓글 작성 폼 -->
        <div class="comment-form">
            <form id="commentForm">
                <textarea id="commentContent" class="comment-textarea" 
                          placeholder="댓글을 작성해주세요..." required></textarea>
                <div class="comment-form-actions">
                    <button type="submit" class="btn-comment">
                        <i class="fas fa-paper-plane"></i>
                        댓글 등록
                    </button>
                </div>
            </form>
        </div>
        
        <!-- 댓글 목록 -->
        <div class="comments-list">
            <c:choose>
                <c:when test="${not empty comments}">
                    <c:forEach var="comment" items="${comments}">
                        <div class="comment-item" data-comment-id="${comment.commentId}">
                            <div class="comment-header">
                                <div>
                                    <div class="comment-author">${comment.authorName}</div>
                                    <div class="comment-date">
                                        <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        <c:if test="${comment.updatedAt != comment.createdAt}">
                                            (수정됨)
                                        </c:if>
                                    </div>
                                </div>
                                <c:if test="${comment.authorId == user.userId}">
                                    <div class="comment-actions">
                                        <button type="button" class="comment-btn edit" onclick="editComment(${comment.commentId})">
                                            <i class="fas fa-edit"></i> 수정
                                        </button>
                                        <button type="button" class="comment-btn delete" onclick="deleteComment(${comment.commentId})">
                                            <i class="fas fa-trash"></i> 삭제
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="comment-content" id="content-${comment.commentId}">${comment.content}</div>
                            
                            <div class="comment-edit-form" id="edit-form-${comment.commentId}">
                                <textarea class="comment-edit-textarea" id="edit-content-${comment.commentId}">${comment.content}</textarea>
                                <div class="comment-edit-actions">
                                    <button type="button" class="btn-save" onclick="saveComment(${comment.commentId})">저장</button>
                                    <button type="button" class="btn-cancel-edit" onclick="cancelEdit(${comment.commentId})">취소</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-comments">
                        <i class="fas fa-comment-slash"></i>
                        <p>등록된 댓글이 없습니다.</p>
                        <p>첫 번째 댓글을 작성해보세요!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 삭제 확인 폼 (숨김) -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/meeting" style="display: none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="meeting_id" value="${meeting.meetingId}">
</form>

<script>
// 회의록 삭제 확인
function confirmDelete() {
    if (confirm('정말로 이 회의록을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.')) {
        document.getElementById('deleteForm').submit();
    }
}

// 댓글 등록
document.getElementById('commentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const content = document.getElementById('commentContent').value.trim();
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    
    const submitButton = this.querySelector('.btn-comment');
    submitButton.disabled = true;
    submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 등록 중...';
    
    // AJAX 요청으로 댓글 등록
    fetch('${pageContext.request.contextPath}/comment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=add&meeting_id=${meeting.meetingId}&content=' + encodeURIComponent(content)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload(); // 페이지 새로고침으로 댓글 목록 갱신
        } else {
            alert(data.message || '댓글 등록 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('댓글 등록 중 오류가 발생했습니다.');
    })
    .finally(() => {
        submitButton.disabled = false;
        submitButton.innerHTML = '<i class="fas fa-paper-plane"></i> 댓글 등록';
    });
});

// 댓글 수정 모드 전환
function editComment(commentId) {
    const contentDiv = document.getElementById('content-' + commentId);
    const editForm = document.getElementById('edit-form-' + commentId);
    
    contentDiv.style.display = 'none';
    editForm.style.display = 'block';
    
    // 텍스트 영역에 포커스
    document.getElementById('edit-content-' + commentId).focus();
}

// 댓글 수정 취소
function cancelEdit(commentId) {
    const contentDiv = document.getElementById('content-' + commentId);
    const editForm = document.getElementById('edit-form-' + commentId);
    
    contentDiv.style.display = 'block';
    editForm.style.display = 'none';
}

// 댓글 수정 저장
function saveComment(commentId) {
    const newContent = document.getElementById('edit-content-' + commentId).value.trim();
    if (!newContent) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    
    // AJAX 요청으로 댓글 수정
    fetch('${pageContext.request.contextPath}/comment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=update&comment_id=' + commentId + '&content=' + encodeURIComponent(newContent)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload(); // 페이지 새로고침으로 댓글 목록 갱신
        } else {
            alert(data.message || '댓글 수정 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('댓글 수정 중 오류가 발생했습니다.');
    });
}

// 댓글 삭제
function deleteComment(commentId) {
    if (!confirm('정말로 이 댓글을 삭제하시겠습니까?')) {
        return;
    }
    
    // AJAX 요청으로 댓글 삭제
    fetch('${pageContext.request.contextPath}/comment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=delete&comment_id=' + commentId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload(); // 페이지 새로고침으로 댓글 목록 갱신
        } else {
            alert(data.message || '댓글 삭제 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('댓글 삭제 중 오류가 발생했습니다.');
    });
}
</script>

<%@ include file="/includes/footer.jsp" %>