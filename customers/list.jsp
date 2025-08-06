<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="고객사 정보" scope="request" />
<%@ include file="/includes/header.jsp" %>

<style>
    .customer-management {
        width: 100%;
        max-width: 1000px;
        margin: 0 auto;
        padding: var(--space-32) var(--space-16);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    /* 테이블 강제 스타일 적용 */
    .customer-table {
        width: 100% !important;
        max-width: 1000px !important;
        border-collapse: collapse !important;
        font-size: 14px !important;
        table-layout: fixed !important;
        display: table !important;
    }
    
    .customer-table thead {
        display: table-header-group !important;
    }
    
    .customer-table tbody {
        display: table-row-group !important;
    }
    
    .customer-table tr {
        display: table-row !important;
    }
    
    .customer-table th,
    .customer-table td {
        display: table-cell !important;
        vertical-align: middle !important;
        padding: 0.75rem 0.5rem !important;
        border-right: 1px solid #f3f4f6 !important;
        overflow: hidden !important;
        text-overflow: ellipsis !important;
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
    
    .add-button {
        background: #4f46e5;
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .add-button:hover {
        background: #4338ca;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
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
    
    /* 필터 토글 버튼 스타일 */
    .filter-section {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        border: 1px solid #e5e7eb;
        padding: 1.5rem;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 1rem;
    }
    
    .filter-toggle {
        display: flex;
        background: #f1f5f9;
        border-radius: 8px;
        padding: 0.25rem;
        border: 1px solid #e2e8f0;
    }
    
    .filter-btn {
        padding: 0.5rem 1rem;
        border: none;
        background: transparent;
        color: #64748b;
        font-weight: 500;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease;
        font-size: 14px;
        white-space: nowrap;
    }
    
    .filter-btn.active {
        background: #4f46e5;
        color: white;
        box-shadow: 0 2px 4px rgba(79, 70, 229, 0.2);
    }
    
    .filter-btn:hover:not(.active) {
        background: #e2e8f0;
        color: #475569;
    }
    
    .filter-info {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: #64748b;
        font-size: 14px;
    }
    
    .filter-count {
        background: #f8fafc;
        color: #374151;
        padding: 0.25rem 0.75rem;
        border-radius: 6px;
        font-weight: 600;
        border: 1px solid #e5e7eb;
    }
    
    /* 검색 섹션 스타일 */
    .search-section {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        border: 1px solid #e5e7eb;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }
    
    .search-container {
        display: flex;
        align-items: center;
        gap: 1rem;
    }
    
    .search-input-wrapper {
        position: relative;
        flex: 1;
        max-width: 400px;
    }
    
    .search-input {
        width: 100%;
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border: 2px solid #e5e7eb;
        border-radius: 8px;
        font-size: 14px;
        background: #fafbfc;
        transition: all 0.2s ease;
        box-sizing: border-box;
    }
    
    .search-input:focus {
        outline: none;
        border-color: #4f46e5;
        background: white;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }
    
    .search-icon {
        position: absolute;
        left: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: #9ca3af;
        font-size: 14px;
        pointer-events: none;
    }
    
    .clear-search {
        position: absolute;
        right: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: #9ca3af;
        cursor: pointer;
        padding: 0.25rem;
        border-radius: 4px;
        display: none;
        transition: all 0.2s ease;
    }
    
    .clear-search:hover {
        color: #ef4444;
        background: #fef2f2;
    }
    
    .search-stats {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: #6b7280;
        font-size: 14px;
        font-weight: 500;
    }
    
    .search-count {
        background: #f3f4f6;
        color: #374151;
        padding: 0.25rem 0.75rem;
        border-radius: 6px;
        font-weight: 600;
    }
    
    .search-highlight {
        background: #fef3c7;
        color: #92400e;
        padding: 0.1rem 0.2rem;
        border-radius: 3px;
        font-weight: 600;
    }
    
    .table-container {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        overflow: hidden;
        border: 1px solid #e5e7eb;
    }
    
    .table-wrapper {
        overflow-x: auto;
        max-width: 100%;
    }
    
    .customer-table {
        width: 100%;
        max-width: 1000px;
        border-collapse: collapse;
        font-size: 14px;
        table-layout: fixed; /* 고정 레이아웃으로 컬럼 너비 제어 */
    }
    
    .customer-table th {
        background: #f8fafc !important;
        color: #374151 !important;
        font-weight: 600 !important;
        padding: 1rem 0.5rem !important;
        text-align: center !important;
        border-bottom: 1px solid #e5e7eb !important;
        position: sticky !important;
        top: 0 !important;
        z-index: 10 !important;
        white-space: nowrap !important;
        font-size: 13px !important;
        display: table-cell !important;
    }
    
    /* 컬럼별 너비 지정 */
    .customer-table th:nth-child(1) { width: 20%; } /* 고객사 */
    .customer-table th:nth-child(2) { width: 10%; } /* 버전 */
    .customer-table th:nth-child(3) { width: 8%; }  /* 모드 */
    .customer-table th:nth-child(4) { width: 15%; } /* OS */
    .customer-table th:nth-child(5) { width: 8%; }  /* 노드수 */
    .customer-table th:nth-child(6) { width: 12%; } /* 라이선스 */
    .customer-table th:nth-child(7) { width: 12%; } /* SAID */
    .customer-table th:nth-child(8) { width: 12%; } /* 담당자 */
    .customer-table th:nth-child(9) { width: 13%; } /* 작업 */
    
    .customer-table th a {
        color: #374151;
        text-decoration: none;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.25rem;
        transition: color 0.2s ease;
    }
    
    .customer-table th a:hover {
        color: #4f46e5;
    }
    
    .customer-table th .sort-icon {
        font-size: 0.8rem;
        opacity: 0.4;
    }
    
    .customer-table th .sort-icon.active {
        opacity: 1;
        color: #4f46e5;
    }
    
    .customer-table tbody tr {
        transition: all 0.2s ease !important;
        border-bottom: 1px solid #f3f4f6 !important;
        cursor: pointer !important;
        display: table-row !important;
    }
    
    .customer-table tbody tr:nth-child(even) {
        background-color: #fafbfc !important;
    }
    
    .customer-table tbody tr:hover {
        background-color: #f0f9ff !important;
        box-shadow: 0 2px 8px rgba(79, 70, 229, 0.08) !important;
    }
    
    .customer-table tbody tr.hidden {
        display: none !important;
    }
    
    .customer-table td {
        padding: 0.75rem 0.5rem !important;
        border-right: 1px solid #f3f4f6 !important;
        vertical-align: middle !important;
        overflow: hidden !important;
        text-overflow: ellipsis !important;
        color: #374151 !important;
        font-size: 13px !important;
        display: table-cell !important;
    }
    
    .customer-table td:last-child {
        border-right: none;
        white-space: nowrap;
    }
    
    .action-buttons {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 0.25rem;
    }
    
    .action-btn {
        width: 24px;
        height: 24px;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
        text-decoration: none;
        font-size: 10px;
    }
    
    .detail-btn {
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
    }
    
    .detail-btn:hover {
        background: linear-gradient(135deg, #2563eb, #1e40af);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.4);
        color: white;
        text-decoration: none;
    }
    
    .edit-btn {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
    }
    
    .edit-btn:hover {
        background: linear-gradient(135deg, #059669, #047857);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(16, 185, 129, 0.4);
        color: white;
        text-decoration: none;
    }
    
    .delete-btn {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
    }
    
    .delete-btn:hover {
        background: linear-gradient(135deg, #dc2626, #b91c1c);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
        color: white;
        text-decoration: none;
    }
    
    .empty-state {
        text-align: center;
        padding: 3rem;
        color: #9ca3af;
        font-style: italic;
    }
    
    .empty-state i {
        font-size: 3rem;
        margin-bottom: 1rem;
        opacity: 0.5;
    }
    
    .no-results {
        text-align: center;
        padding: 3rem;
        color: #6b7280;
    }
    
    .no-results i {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: #d1d5db;
    }
    
    .no-results h3 {
        color: #374151;
        margin-bottom: 0.5rem;
    }
    
    .no-results p {
        color: #6b7280;
        margin: 0;
    }
    
    /* 반응형 디자인 */
    @media (max-width: 768px) {
        .customer-management {
            max-width: 100%;
            padding: var(--space-24) var(--space-16);
        }
        
        .page-header {
            padding: 1.5rem;
        }
        
        .page-header h1 {
            font-size: 1.5rem;
        }
        
        .filter-section {
            padding: 1rem;
            flex-direction: column;
            align-items: stretch;
        }
        
        .filter-toggle {
            justify-content: center;
        }
        
        .filter-info {
            justify-content: center;
        }
        
        .search-section {
            padding: 1rem;
        }
        
        .search-container {
            flex-direction: column;
            align-items: stretch;
            gap: 1rem;
        }
        
        .search-input-wrapper {
            max-width: none;
        }
        
        .search-stats {
            justify-content: center;
        }
        
        .customer-table {
            font-size: 12px;
        }
        
        .customer-table th,
        .customer-table td {
            padding: 0.5rem;
        }
        
        .action-buttons {
            justify-content: center;
        }
        
        .action-btn {
            width: 20px;
            height: 20px;
            font-size: 9px;
        }
    }
</style>

<div class="customer-management">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="fas fa-building"></i> 고객사 정보</h1>
                <p class="lead">
                    <c:choose>
                        <c:when test="${filter == 'maintenance'}">
                            정기점검 고객사: <strong>${currentCount}</strong>개 
                            <span style="color: #9ca3af;">(전체: ${totalCount}개)</span>
                        </c:when>
                        <c:otherwise>
                            전체 고객사: <strong>${currentCount}</strong>개 
                            <span style="color: #9ca3af;">(정기점검: ${maintenanceCount}개)</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/customers?view=add" class="add-button">
                    <i class="fas fa-plus"></i>
                    새 고객사 추가
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
    
    <!-- 필터 섹션 -->
    <div class="filter-section">
        <div class="filter-toggle">
            <button class="filter-btn ${filter == 'maintenance' ? 'active' : ''}" 
                    onclick="changeFilter('maintenance')">
                <i class="fas fa-clipboard-check"></i>
                정기점검만 보기
            </button>
            <button class="filter-btn ${filter == 'all' ? 'active' : ''}" 
                    onclick="changeFilter('all')">
                <i class="fas fa-list"></i>
                전체 보기
            </button>
        </div>
        <div class="filter-info">
            <i class="fas fa-info-circle"></i>
            <span class="filter-count">
                <c:choose>
                    <c:when test="${filter == 'maintenance'}">
                        정기점검 ${currentCount}개 표시 중
                    </c:when>
                    <c:otherwise>
                        전체 ${currentCount}개 표시 중
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>
    
    <!-- 검색 섹션 -->
    <div class="search-section">
        <div class="search-container">
            <div class="search-input-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input type="text" 
                       id="search-input" 
                       class="search-input" 
                       placeholder="고객사명, 버전, OS, 담당자 등으로 검색..."
                       autocomplete="off">
                <button type="button" id="clear-search" class="clear-search">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="search-stats">
                <i class="fas fa-filter"></i>
                <span id="search-count" class="search-count">전체</span>
                <span id="search-text">결과 표시 중</span>
            </div>
        </div>
    </div>
    
    <div class="table-container">
        <div class="table-wrapper">
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('customer_name')">
                                고객사
                                <i class="fas fa-sort sort-icon ${sortField == 'customer_name' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('vertica_version')">
                                버전
                                <i class="fas fa-sort sort-icon ${sortField == 'vertica_version' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('mode')">
                                모드
                                <i class="fas fa-sort sort-icon ${sortField == 'mode' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('os')">
                                OS
                                <i class="fas fa-sort sort-icon ${sortField == 'os' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('nodes')">
                                노드수
                                <i class="fas fa-sort sort-icon ${sortField == 'nodes' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('license_size')">
                                라이선스
                                <i class="fas fa-sort sort-icon ${sortField == 'license_size' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('said')">
                                SAID
                                <i class="fas fa-sort sort-icon ${sortField == 'said' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0)" onclick="sortTable('manager_name')">
                                담당자
                                <i class="fas fa-sort sort-icon ${sortField == 'manager_name' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody id="customer-table-body">
                    <c:forEach var="customer" items="${customerList}">
                        <tr class="customer-row" 
                            data-search-text="${customer.customerName} ${customer.verticaVersion} ${customer.mode} ${customer.os} ${customer.nodes} ${customer.licenseSize} ${customer.said} ${customer.managerName}">
                            <td title="${customer.customerName}" data-original="${not empty customer.customerName ? customer.customerName : ''}">${not empty customer.customerName ? customer.customerName : ''}</td>
                            <td data-original="${not empty customer.verticaVersion ? customer.verticaVersion : ''}">${not empty customer.verticaVersion ? customer.verticaVersion : ''}</td>
                            <td data-original="${not empty customer.mode ? customer.mode : ''}">${not empty customer.mode ? customer.mode : ''}</td>
                            <td data-original="${not empty customer.os ? customer.os : ''}">${not empty customer.os ? customer.os : ''}</td>
                            <td data-original="${not empty customer.nodes ? customer.nodes : ''}">${not empty customer.nodes ? customer.nodes : ''}</td>
                            <td data-original="${not empty customer.licenseSize ? customer.licenseSize : ''}">${not empty customer.licenseSize ? customer.licenseSize : ''}</td>
                            <td data-original="${not empty customer.said ? customer.said : ''}">${not empty customer.said ? customer.said : ''}</td>
                            <td title="${customer.managerName}" data-original="${not empty customer.managerName ? customer.managerName : ''}">${not empty customer.managerName ? customer.managerName : ''}</td>
							<td>
							    <div class="action-buttons">
							        <a href="javascript:void(0)" onclick="viewDetail('${customer.customerName}')" 
							           class="action-btn detail-btn" title="상세정보 보기">
							            <i class="fas fa-info-circle"></i>
							        </a>
							        <a href="javascript:void(0)" onclick="editCustomer('${customer.customerName}')" 
							           class="action-btn edit-btn" title="정보 수정">
							            <i class="fas fa-edit"></i>
							        </a>
							        <button class="action-btn delete-btn" onclick="deleteCustomer('${customer.customerName}')" title="고객사 삭제">
							            <i class="fas fa-trash"></i>
							        </button>
							    </div>
							</td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty customerList}">
                        <tr id="empty-state">
                            <td colspan="9" class="empty-state">
                                <i class="fas fa-inbox"></i>
                                <div>
                                    <c:choose>
                                        <c:when test="${filter == 'maintenance'}">
                                            등록된 정기점검 고객사가 없습니다.
                                        </c:when>
                                        <c:otherwise>
                                            등록된 고객사 정보가 없습니다.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
            
            <!-- 검색 결과 없음 메시지 -->
            <div id="no-results" class="no-results" style="display: none;">
                <i class="fas fa-search"></i>
                <h3>검색 결과가 없습니다</h3>
                <p>다른 검색어로 다시 시도해보세요.</p>
            </div>
        </div>
    </div>
</div>

<script>
    // 전역 변수
    var currentFilter = "${filter}";
    var currentSortField = "${sortField}";
    var currentSortDirection = "${sortDirection}";
    
    // jQuery 준비 완료 시 실행
    $(document).ready(function() {
        if (currentSortField && currentSortDirection) {
            var activeIcon = $('.sort-icon.active');
            activeIcon.removeClass("fa-sort").addClass(currentSortDirection === "ASC" ? "fa-sort-up" : "fa-sort-down");
        }
        
        // 테이블 로딩 애니메이션
        $('.customer-table tbody tr').each(function(index) {
            $(this).css('animation-delay', (index * 0.05) + 's');
        });
        
        // 툴팁 기능 (긴 텍스트에 대한 hover 툴팁)
        $('.customer-table td[title]').hover(
            function() {
                if (this.offsetWidth < this.scrollWidth) {
                    $(this).attr('data-toggle', 'tooltip');
                }
            }
        );
        
        // 검색 기능 초기화
        initializeSearch();
    });
    
    // 필터 변경 함수
    function changeFilter(filter) {
        var url = '${pageContext.request.contextPath}/customers?view=list&filter=' + filter;
        if (currentSortField) {
            url += '&sortField=' + currentSortField + '&sortDirection=' + currentSortDirection;
        }
        window.location.href = url;
    }
    
    // 정렬 함수
    function sortTable(field) {
        var direction = 'ASC';
        if (currentSortField === field && currentSortDirection === 'ASC') {
            direction = 'DESC';
        }
        
        var url = '${pageContext.request.contextPath}/customers?view=list&filter=' + currentFilter + 
                  '&sortField=' + field + '&sortDirection=' + direction;
        window.location.href = url;
    }
    
    // 검색 기능 초기화
    function initializeSearch() {
        const searchInput = document.getElementById('search-input');
        const clearButton = document.getElementById('clear-search');
        const searchCount = document.getElementById('search-count');
        const searchText = document.getElementById('search-text');
        const totalCount = ${currentCount};
        
        // 실시간 검색
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            performSearch(searchTerm);
            
            // Clear 버튼 표시/숨김
            if (searchTerm) {
                clearButton.style.display = 'block';
            } else {
                clearButton.style.display = 'none';
            }
        });
        
        // 검색 초기화
        clearButton.addEventListener('click', function() {
            searchInput.value = '';
            searchInput.focus();
            performSearch('');
            this.style.display = 'none';
        });
        
        // Enter 키 처리
        searchInput.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                clearButton.click();
            }
        });
        
        // 검색 수행 함수
        function performSearch(searchTerm) {
            const rows = document.querySelectorAll('.customer-row');
            const noResultsDiv = document.getElementById('no-results');
            const emptyState = document.getElementById('empty-state');
            let visibleCount = 0;
            
            // 모든 하이라이트 제거
            removeAllHighlights();
            
            rows.forEach(row => {
                if (!searchTerm) {
                    // 검색어가 없으면 모든 행 표시
                    row.classList.remove('hidden');
                    visibleCount++;
                } else {
                    // 검색어가 있으면 검색 수행
                    const searchText = row.getAttribute('data-search-text').toLowerCase();
                    
                    if (searchText.includes(searchTerm)) {
                        row.classList.remove('hidden');
                        highlightSearchTerm(row, searchTerm);
                        visibleCount++;
                    } else {
                        row.classList.add('hidden');
                    }
                }
            });
            
            // 검색 결과 통계 업데이트
            updateSearchStats(visibleCount, totalCount, searchTerm);
            
            // 검색 결과 없음 메시지 표시/숨김
            if (totalCount > 0) {
                if (visibleCount === 0 && searchTerm) {
                    noResultsDiv.style.display = 'block';
                    if (emptyState) emptyState.style.display = 'none';
                } else {
                    noResultsDiv.style.display = 'none';
                    if (emptyState && visibleCount > 0) emptyState.style.display = 'none';
                }
            }
        }
        
        // 검색어 하이라이트
        function highlightSearchTerm(row, searchTerm) {
            const cells = row.querySelectorAll('td[data-original]');
            
            cells.forEach(cell => {
                const originalText = cell.getAttribute('data-original') || '';
                const lowerText = originalText.toLowerCase();
                const lowerSearchTerm = searchTerm.toLowerCase();
                
                if (originalText && lowerText.includes(lowerSearchTerm)) {
                    const startIndex = lowerText.indexOf(lowerSearchTerm);
                    const endIndex = startIndex + lowerSearchTerm.length;
                    
                    const beforeMatch = originalText.substring(0, startIndex);
                    const match = originalText.substring(startIndex, endIndex);
                    const afterMatch = originalText.substring(endIndex);
                    
                    cell.innerHTML = beforeMatch + 
                        '<span class="search-highlight">' + match + '</span>' + 
                        afterMatch;
                } else if (originalText) {
                    cell.textContent = originalText;
                }
            });
        }
        
        // 모든 하이라이트 제거
        function removeAllHighlights() {
            const rows = document.querySelectorAll('.customer-row');
            rows.forEach(row => {
                const cells = row.querySelectorAll('td[data-original]');
                cells.forEach(cell => {
                    const originalText = cell.getAttribute('data-original') || '';
                    cell.textContent = originalText;
                });
            });
        }
        
        // 검색 통계 업데이트
        function updateSearchStats(visibleCount, totalCount, searchTerm) {
            if (!searchTerm) {
                searchCount.textContent = '전체';
                searchText.textContent = '결과 표시 중';
            } else {
                searchCount.textContent = visibleCount + '/' + totalCount;
                searchText.textContent = '검색 결과';
            }
        }
    }
    
    // 고객사 상세보기 페이지로 이동
    function viewDetail(customerName) {
        var encodedName = encodeURIComponent(customerName);
        window.location.href = '${pageContext.request.contextPath}/customers?view=detail&customerName=' + encodedName;
    }
    
    // 고객사 수정 페이지로 이동
    function editCustomer(customerName) {
        var encodedName = encodeURIComponent(customerName);
        window.location.href = '${pageContext.request.contextPath}/customers?view=edit&name=' + encodedName;
    }
    
    // 고객사 삭제 함수
    function deleteCustomer(customerName) {
        if (confirm('정말로 "' + customerName + '" 고객사를 삭제하시겠습니까?\n\n삭제된 데이터는 복구할 수 없습니다.')) {
            // 삭제 폼 생성 및 전송 (POST 방식이므로 인코딩 불필요)
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/customers';
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            
            var nameInput = document.createElement('input');
            nameInput.type = 'hidden';
            nameInput.name = 'customer_name';
            nameInput.value = customerName; // POST 방식이므로 인코딩하지 않음
            
            form.appendChild(actionInput);
            form.appendChild(nameInput);
            
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

<%@ include file="/includes/footer.jsp" %>