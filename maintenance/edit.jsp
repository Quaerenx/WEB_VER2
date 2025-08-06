<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="정기점검 이력 수정" scope="request" />
<%@ include file="/includes/header.jsp" %>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-edit"></i> 정기점검 이력 수정</h2>
        <p>정기점검 이력 정보를 수정해주세요.</p>
    </div>
    
    <!-- 오류 메시지 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>
    
    <!-- 수정 폼 -->
    <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/maintenance">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="maintenance_id" value="${record.maintenanceId}">
            
            <!-- 기본 정보 -->
            <div class="section-title">기본 정보</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="customer_name">고객사명 <span class="required">*</span></label>
                    <select id="customer_name" name="customer_name" required>
                        <option value="">고객사를 선택하세요</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="inspector_name">점검자 <span class="required">*</span></label>
                    <select id="inspector_name" name="inspector_name" required>
                        <option value="">점검자를 선택하세요</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="inspection_date">점검일자 <span class="required">*</span></label>
                    <input type="date" id="inspection_date" name="inspection_date" 
                           value="<fmt:formatDate value='${record.inspectionDate}' pattern='yyyy-MM-dd'/>" required>
                </div>
                <div class="form-group">
                    <label for="vertica_version">Vertica 버전</label>
                    <input type="text" id="vertica_version" name="vertica_version" 
                           value="${record.verticaVersion}" placeholder="예: 12.0.4">
                </div>
            </div>
            
            <!-- 점검 내용 -->
            <div class="section-title">점검 내용</div>
            
            <div class="form-row">
                <div class="form-group full-width">
                    <label for="note">비고 및 점검 내용</label>
                    <textarea id="note" name="note" rows="8" 
                              placeholder="점검 내용, 발견된 이슈, 조치사항 등을 입력해주세요.">${record.note}</textarea>
                </div>
            </div>
            
            <!-- 이력 정보 -->
            <div class="section-title">이력 정보</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>등록일시</label>
                    <input type="text" value="<fmt:formatDate value='${record.createdAt}' pattern='yyyy-MM-dd HH:mm:ss'/>" 
                           readonly class="readonly-field">
                </div>
                <div class="form-group">
                    <label>수정일시</label>
                    <input type="text" value="<fmt:formatDate value='${record.updatedAt}' pattern='yyyy-MM-dd HH:mm:ss'/>" 
                           readonly class="readonly-field">
                </div>
            </div>
            
            <!-- 버튼 -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/maintenance?view=history&customerName=${record.customerName}" class="btn btn-cancel">취소</a>
                <button type="submit" class="btn btn-primary">수정하기</button>
                <button type="button" class="btn btn-danger" onclick="confirmDelete()">삭제하기</button>
            </div>
        </form>
        
        <!-- 삭제 폼 (숨김) -->
        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/maintenance" style="display: none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="maintenance_id" value="${record.maintenanceId}">
            <input type="hidden" name="customer_name" value="${record.customerName}">
        </form>
    </div>
</div>

<style>
/* 기본 레이아웃 */
.container {
    width: 100%;
    max-width: 1000px;
    margin: 0 auto;
    padding: var(--space-32) var(--space-16);
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
    min-height: 100px;
}

/* 읽기 전용 필드 */
.readonly-field {
    background-color: #f8f9fa !important;
    color: #6c757d !important;
    cursor: not-allowed !important;
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

.btn-cancel {
    background: #6c757d;
    color: white;
}

.btn-cancel:hover {
    background: #545b62;
    text-decoration: none;
}

.btn-danger {
    background: #dc3545;
    color: white;
}

.btn-danger:hover {
    background: #c82333;
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


/* 반응형 */
@media (max-width: 768px) {
    .container {
        max-width: 100%;
        padding: var(--space-24) var(--space-16);
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
}
</style>

<script>
// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', function() {
    // 고객사 및 담당자 목록 로드
    loadCustomersAndInspectors();
});

// 고객사 및 담당자 목록 로드
function loadCustomersAndInspectors() {
    // 기존 customers 테이블에서 고객사 및 담당자 정보 가져오기
    fetch('${pageContext.request.contextPath}/customers?action=getCustomersForMaintenance')
        .then(response => response.json())
        .then(data => {
            populateCustomers(data.customers);
            populateInspectors(data.inspectors);
            
            // 기존 값 설정
            setCurrentValues();
        })
        .catch(error => {
            console.error('Error:', error);
            // 에러 시 기본 옵션들 수동으로 추가
            addDefaultOptions();
            setCurrentValues();
        });
}

// 고객사 선택박스 채우기
function populateCustomers(customers) {
    const customerSelect = document.getElementById('customer_name');
    customers.forEach(customer => {
        const option = document.createElement('option');
        option.value = customer;
        option.textContent = customer;
        customerSelect.appendChild(option);
    });
}

// 점검자 선택박스 채우기
function populateInspectors(inspectors) {
    const inspectorSelect = document.getElementById('inspector_name');
    inspectors.forEach(inspector => {
        const option = document.createElement('option');
        option.value = inspector;
        option.textContent = inspector;
        inspectorSelect.appendChild(option);
    });
}

// 기본 옵션들 추가 (API 실패 시)
function addDefaultOptions() {
    const customerSelect = document.getElementById('customer_name');
    const inspectorSelect = document.getElementById('inspector_name');
    
    // 현재 값들을 기본 옵션으로 추가
    const currentCustomer = '${record.customerName}';
    const currentInspector = '${record.inspectorName}';
    
    if (currentCustomer) {
        const option = document.createElement('option');
        option.value = currentCustomer;
        option.textContent = currentCustomer;
        customerSelect.appendChild(option);
    }
    
    if (currentInspector) {
        const option = document.createElement('option');
        option.value = currentInspector;
        option.textContent = currentInspector;
        inspectorSelect.appendChild(option);
    }
}

// 현재 값들 설정
function setCurrentValues() {
    const currentCustomer = '${record.customerName}';
    const currentInspector = '${record.inspectorName}';
    
    if (currentCustomer) {
        document.getElementById('customer_name').value = currentCustomer;
    }
    
    if (currentInspector) {
        document.getElementById('inspector_name').value = currentInspector;
    }
}

// 삭제 확인
function confirmDelete() {
    if (confirm('정말로 이 정기점검 이력을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.')) {
        document.getElementById('deleteForm').submit();
    }
}

// 폼 유효성 검사
document.querySelector('form').addEventListener('submit', function(e) {
    if (e.target.id === 'deleteForm') return; // 삭제 폼은 검사하지 않음
    
    const customerName = document.getElementById('customer_name').value.trim();
    const inspectorName = document.getElementById('inspector_name').value.trim();
    const inspectionDate = document.getElementById('inspection_date').value;
    
    if (!customerName) {
        e.preventDefault();
        alert('고객사명을 선택해주세요.');
        document.getElementById('customer_name').focus();
        return false;
    }
    
    if (!inspectorName) {
        e.preventDefault();
        alert('점검자를 선택해주세요.');
        document.getElementById('inspector_name').focus();
        return false;
    }
    
    if (!inspectionDate) {
        e.preventDefault();
        alert('점검일자를 입력해주세요.');
        document.getElementById('inspection_date').focus();
        return false;
    }
});
</script>

<%@ include file="/includes/footer.jsp" %>