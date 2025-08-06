<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="회의록 관리" scope="request" />
<%@ include file="/includes/header.jsp" %>

<style>
    .meeting-management {
	    width: 100%;
	    max-width: 1000px;
	    margin: 0 auto;
	    padding: var(--space-32) var(--space-16);
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	}
    
    .page-header {
        background: #ffffff;
        color: #2c3e50;
        padding: 2rem;
        border-radius: 12px;
        margin-bottom: 1.5rem;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        border: 1px solid #e8ecef;
    }
    
    .page-header h1 {
        margin: 0 0 0.5rem 0;
        font-size: 2rem;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .page-header .lead {
        margin: 0;
        color: #6c757d;
        font-size: 1.1rem;
    }
    
    .header-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }
    
    .write-button {
        background: linear-gradient(135deg, #4f46e5, #7c3aed);
        color: white;
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
    }
    
    .write-button:hover {
        background: linear-gradient(135deg, #4338ca, #6d28d9);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        color: white;
        text-decoration: none;
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
    
    /* 회의록 목록 테이블 */
    .meeting-container {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        border: 1px solid #e5e7eb;
        overflow: hidden;
    }
    
    .meeting-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    
    .meeting-table thead {
        background: linear-gradient(135deg, #f8fafc, #e2e8f0);
    }
    
    .meeting-table th {
        color: #374151;
        font-weight: 600;
        padding: 1rem 0.75rem;
        text-align: center;
        border-bottom: 2px solid #e5e7eb;
        white-space: nowrap;
    }
    
    .meeting-table tbody tr {
        transition: all 0.2s ease;
        border-bottom: 1px solid #f3f4f6;
    }
    
    .meeting-table tbody tr:nth-child(even) {
        background-color: #fafbfc;
    }
    
    .meeting-table tbody tr:hover {
        background-color: #f0f9ff;
        transform: scale(1.01);
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.1);
    }
    
    .meeting-table td {
        padding: 1rem 0.75rem;
        border-right: 1px solid #f3f4f6;
        vertical-align: middle;
        color: #374151;
    }
    
    .meeting-table td:last-child {
        border-right: none;
    }
    
    /* 컬럼별 스타일 */
    .col-title {
        width: 35%;
        text-align: left;
    }
    
    .col-type {
        width: 10%;
        text-align: center;
    }
    
    .col-datetime {
        width: 15%;
        text-align: center;
    }
    
    .col-author {
        width: 10%;
        text-align: center;
    }
    
    .col-stats {
        width: 10%;
        text-align: center;
    }
    
    .col-date {
        width: 12%;
        text-align: center;
    }
    
    .col-actions {
        width: 8%;
        text-align: center;
    }
    
    /* 제목 링크 */
    .title-link {
        color: #1f2937;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.2s ease;
        display: block;
        padding: 0.25rem 0;
    }
    
    .title-link:hover {
        color: #3b82f6;
        text-decoration: none;
    }
    
    /* 배지 스타일 */
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
    
    .stats-info {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        font-size: 0.8rem;
        color: #6b7280;
    }
    
    .view-count {
        display: flex;
        align-items: center;
        gap: 0.25rem;
    }
    
    .comment-count {
        display: flex;
        align-items: center;
        gap: 0.25rem;
        color: #059669;
    }
    
    /* 액션 버튼 */
    .action-button {
        background: #f1f5f9;
        color: #475569;
        padding: 0.375rem 0.75rem;
        border-radius: 6px;
        text-decoration: none;
        font-size: 0.75rem;
        font-weight: 500;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
    }
    
    .action-button:hover {
        background: #e2e8f0;
        color: #334155;
        text-decoration: none;
    }
    
    /* 페이징 */
    .pagination-container {
        padding: 2rem;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 1rem;
        background: #f8fafc;
        border-top: 1px solid #e5e7eb;
    }
    
    .pagination {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .page-link {
        padding: 0.5rem 0.75rem;
        border: 1px solid #d1d5db;
        background: white;
        color: #374151;
        text-decoration: none;
        border-radius: 6px;
        font-size: 0.875rem;
        transition: all 0.2s ease;
    }
    
    .page-link:hover {
        background: #f3f4f6;
        color: #1f2937;
        text-decoration: none;
    }
    
    .page-link.active {
        background: #3b82f6;
        color: white;
        border-color: #3b82f6;
    }
    
    .page-link.disabled {
        background: #f9fafb;
        color: #9ca3af;
        cursor: not-allowed;
    }
    
    .page-info {
        font-size: 0.875rem;
        color: #6b7280;
        margin: 0 1rem;
    }
    
    /* 빈 상태 */
    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        color: #9ca3af;
    }
    
    .empty-state i {
        font-size: 4rem;
        margin-bottom: 1rem;
        opacity: 0.5;
        color: #d1d5db;
    }
    
    .empty-state h3 {
        font-size: 1.25rem;
        font-weight: 600;
        color: #6b7280;
        margin-bottom: 0.5rem;
    }
    
    .empty-state p {
        margin-bottom: 1.5rem;
    }
    
    /* 반응형 디자인 */
    @media (max-width: 768px) {
        .meeting-management {
        max-width: 100%;
        padding: var(--space-24) var(--space-16);
        }
        
        .page-header {
            padding: 1.5rem;
        }
        
        .page-header h1 {
            font-size: 1.5rem;
        }
        
        .header-actions {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .meeting-table {
            font-size: 12px;
        }
        
        .meeting-table th,
        .meeting-table td {
            padding: 0.75rem 0.5rem;
        }
        
        .col-datetime,
        .col-stats {
            display: none;
        }
        
        .pagination {
            flex-wrap: wrap;
        }
        
        .page-info {
            order: -1;
            width: 100%;
            text-align: center;
            margin-bottom: 1rem;
        }
    }
</style>

<div class="meeting-management">
    <div class="page-header">
        <div class="header-actions">
            <div>
                <h1><i class="fas fa-clipboard-list"></i> 회의록 관리</h1>
                <p class="lead">총 ${totalCount}개의 회의록이 등록되어 있습니다</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/meeting?view=write" class="write-button">
                    <i class="fas fa-pen"></i>
                    새 회의록 작성
                </a>
            </div>
        </div>
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
    
    <!-- 회의록 목록 -->
    <div class="meeting-container">
        <c:choose>
            <c:when test="${not empty meetingList}">
                <table class="meeting-table">
                    <thead>
                        <tr>
                            <th class="col-title">제목</th>
                            <th class="col-type">회의 유형</th>
                            <th class="col-datetime">회의 일시</th>
                            <th class="col-author">작성자</th>
                            <th class="col-stats">조회/댓글</th>
                            <th class="col-date">등록일</th>
                            <th class="col-actions">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="meeting" items="${meetingList}">
                            <tr>
                                <td class="col-title">
                                    <a href="${pageContext.request.contextPath}/meeting?view=view&id=${meeting.meetingId}" 
                                       class="title-link" title="${meeting.title}">
                                        ${meeting.title}
                                    </a>
                                </td>
                                <td class="col-type">
                                    <span class="type-badge type-${meeting.meetingType.toLowerCase()}">${meeting.meetingType}</span>
                                </td>
                                <td class="col-datetime">
                                    <fmt:formatDate value="${meeting.meetingDatetime}" pattern="MM/dd HH:mm"/>
                                </td>
                                <td class="col-author">${meeting.authorName}</td>
                                <td class="col-stats">
                                    <div class="stats-info">
                                        <span class="view-count">
                                            <i class="fas fa-eye"></i> ${meeting.viewCount}
                                        </span>
                                        <span class="comment-count">
                                            <i class="fas fa-comment"></i> ${meeting.commentCount}
                                        </span>
                                    </div>
                                </td>
                                <td class="col-date">
                                    <fmt:formatDate value="${meeting.createdAt}" pattern="MM/dd"/>
                                </td>
                                <td class="col-actions">
                                    <c:if test="${meeting.authorId == user.userId}">
                                        <a href="${pageContext.request.contextPath}/meeting?view=edit&id=${meeting.meetingId}" 
                                           class="action-button" title="수정">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <!-- 페이징 -->
                <div class="pagination-container">
                    <div class="page-info">
                        ${currentPage} / ${totalPages} 페이지 (총 ${totalCount}건)
                    </div>
                    
                    <div class="pagination">
                        <!-- 이전 페이지 -->
                        <c:if test="${currentPage > 1}">
                            <a href="?view=list&page=1" class="page-link">
                                <i class="fas fa-angle-double-left"></i>
                            </a>
                            <a href="?view=list&page=${currentPage - 1}" class="page-link">
                                <i class="fas fa-angle-left"></i>
                            </a>
                        </c:if>
                        
                        <!-- 페이지 번호 -->
                        <c:set var="startPage" value="${currentPage - 2}" />
                        <c:set var="endPage" value="${currentPage + 2}" />
                        
                        <c:if test="${startPage < 1}">
                            <c:set var="startPage" value="1" />
                        </c:if>
                        <c:if test="${endPage > totalPages}">
                            <c:set var="endPage" value="${totalPages}" />
                        </c:if>
                        
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-link active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?view=list&page=${i}" class="page-link">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- 다음 페이지 -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="?view=list&page=${currentPage + 1}" class="page-link">
                                <i class="fas fa-angle-right"></i>
                            </a>
                            <a href="?view=list&page=${totalPages}" class="page-link">
                                <i class="fas fa-angle-double-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-clipboard"></i>
                    <h3>등록된 회의록이 없습니다</h3>
                    <p>첫 번째 회의록을 작성해보세요.</p>
                    <a href="${pageContext.request.contextPath}/meeting?view=write" class="write-button">
                        <i class="fas fa-pen"></i>
                        회의록 작성하기
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 테이블 행 클릭 시 상세 페이지로 이동
    const tableRows = document.querySelectorAll('.meeting-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('click', function(e) {
            // 액션 버튼 클릭 시에는 이벤트 무시
            if (e.target.closest('.action-button')) {
                return;
            }
            
            const titleLink = this.querySelector('.title-link');
            if (titleLink) {
                window.location.href = titleLink.href;
            }
        });
        
        // 마우스 오버 시 포인터 커서
        row.style.cursor = 'pointer';
    });
});
</script>

<%@ include file="/includes/footer.jsp" %>