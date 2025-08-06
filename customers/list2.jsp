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
        background: #f8fafc;
        color: #374151;
        font-weight: 600;
        padding: 1rem 0.5rem;
        text-align: center;
        border-bottom: 1px solid #e5e7eb;
        position: sticky;
        top: 0;
        z-index: 10;
        white-space: nowrap;
        font-size: 13px;
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
        transition: all 0.2s ease;
        border-bottom: 1px solid #f3f4f6;
        cursor: pointer;
    }
    
    .customer-table tbody tr:nth-child(even) {
        background-color: #fafbfc;
    }
    
    .customer-table tbody tr:hover {
        background-color: #f0f9ff;
        box-shadow: 0 2px 8px rgba(79, 70, 229, 0.08);
    }
    
    .customer-table td {
        padding: 0.75rem 0.5rem;
        border-right: 1px solid #f3f4f6;
        vertical-align: middle;
        overflow: hidden;
        text-overflow: ellipsis;
        color: #374151;
        font-size: 13px;
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
                <h1><i class="fas fa-building"></i> 고객사 정보 </h1>
                <p class="lead">등록된 고객사: <strong>${customerList.size()}</strong>개</p>
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
    
    <div class="table-container">
        <div class="table-wrapper">
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=customer_name&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                고객사
                                <i class="fas fa-sort sort-icon ${sortField == 'customer_name' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=vertica_version&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                버전
                                <i class="fas fa-sort sort-icon ${sortField == 'vertica_version' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=mode&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                모드
                                <i class="fas fa-sort sort-icon ${sortField == 'mode' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=os&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                OS
                                <i class="fas fa-sort sort-icon ${sortField == 'os' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=nodes&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                노드수
                                <i class="fas fa-sort sort-icon ${sortField == 'nodes' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=license_size&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                라이선스
                                <i class="fas fa-sort sort-icon ${sortField == 'license_size' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=said&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                SAID
                                <i class="fas fa-sort sort-icon ${sortField == 'said' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>
                            <a href="${pageContext.request.contextPath}/customers?view=list&sortField=manager_name&sortDirection=${sortDirection == 'ASC' ? 'DESC' : 'ASC'}">
                                담당자
                                <i class="fas fa-sort sort-icon ${sortField == 'manager_name' ? 'active' : ''}"></i>
                            </a>
                        </th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${customerList}">
                        <tr>
                            <td title="${customer.customerName}">${customer.customerName}</td>
                            <td>${customer.verticaVersion}</td>
                            <td>${customer.mode}</td>
                            <td>${customer.os}</td>
                            <td>${customer.nodes}</td>
                            <td>${customer.licenseSize}</td>
                            <td>${customer.said}</td>
                            <td title="${customer.managerName}">${customer.managerName}</td>
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
                        <tr>
                            <td colspan="9" class="empty-state">
                                <i class="fas fa-inbox"></i>
                                <div>등록된 고객사 정보가 없습니다.</div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // jQuery 준비 완료 시 실행
    $(document).ready(function() {
        var sortField = "${sortField}";
        var sortDirection = "${sortDirection}";
        
        if (sortField && sortDirection) {
            var icon = $("a[href*='sortField=" + sortField + "']").find(".sort-icon");
            icon.removeClass("fa-sort").addClass(sortDirection === "ASC" ? "fa-sort-up" : "fa-sort-down");
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
    });
    
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