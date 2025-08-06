<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="고객사 정보 수정" scope="request" />
<%@ include file="/includes/header.jsp" %>

<!-- 전체를 customer-edit-page 클래스로 감싸기 -->
<div class="customer-edit-page">
    <div class="container">
        <div class="page-header">
            <h2><i class="fas fa-edit"></i> 고객사 정보 수정</h2>
            <p>"<strong>${customer.customerName}</strong>" 고객사의 정보를 수정합니다.</p>
        </div>
        
        <!-- 오류 메시지 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <!-- 수정 폼 -->
        <div class="form-container">
            <form method="post" action="${pageContext.request.contextPath}/customers">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="customer_name" value="${customer.customerName}">
                
                <!-- 기본 정보 -->
                <div class="section-title">기본 정보</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="customer_name_display">고객사명</label>
                        <input type="text" id="customer_name_display" value="${customer.customerName}" readonly 
                               style="background-color: #f8f9fa; color: #6c757d;">
                        <small class="form-text">고객사명은 수정할 수 없습니다.</small>
                    </div>
                    <div class="form-group">
                        <label for="first_introduction_year">도입년도</label>
                        <input type="number" id="first_introduction_year" name="first_introduction_year" 
                               value="${customer.firstIntroductionYear}" min="2000" max="2030">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="db_name">DB명</label>
                        <input type="text" id="db_name" name="db_name" value="${customer.dbName}">
                    </div>
                    <div class="form-group">
                        <label for="vertica_version">Vertica 버전</label>
                        <input type="text" id="vertica_version" name="vertica_version" value="${customer.verticaVersion}">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="vertica_eos">EOS 일자</label>
                        <input type="date" id="vertica_eos" name="vertica_eos" value="${customer.verticaEos}">
                    </div>
                    <div class="form-group">
                        <label for="mode">모드</label>
                        <select id="mode" name="mode">
                            <option value="">선택하세요</option>
                            <option value="ENT" ${customer.mode == 'ENT' ? 'selected' : ''}>ENT</option>
                            <option value="EON" ${customer.mode == 'EON' ? 'selected' : ''}>EON</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="os">운영체제</label>
                        <input type="text" id="os" name="os" value="${customer.os}">
                    </div>
                    <div class="form-group">
                        <label for="nodes">노드 수</label>
                        <input type="number" id="nodes" name="nodes" value="${customer.nodes}" min="1">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="license_size">라이선스 크기</label>
                        <input type="text" id="license_size" name="license_size" value="${customer.licenseSize}">
                    </div>
                    <div class="form-group">
                        <label for="said">SAID</label>
                        <input type="text" id="said" name="said" value="${customer.said}">
                    </div>
                </div>
                
                <!-- 담당자 정보 -->
                <div class="section-title">담당자 정보</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="manager_name">담당자</label>
                        <input type="text" id="manager_name" name="manager_name" value="${customer.managerName}">
                    </div>
                    <div class="form-group">
                        <label for="sub_manager_name">부담당자</label>
                        <input type="text" id="sub_manager_name" name="sub_manager_name" value="${customer.subManagerName}">
                    </div>
                </div>
                
                <!-- 시스템 구성 -->
                <div class="section-title">시스템 구성</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="os_storage_config">스토리지 구성</label>
                        <textarea id="os_storage_config" name="os_storage_config" rows="3">${customer.osStorageConfig}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="backup_config">백업 구성</label>
                        <textarea id="backup_config" name="backup_config" rows="3">${customer.backupConfig}</textarea>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="customer_type">고객 유형</label>
                        <select class="form-control" id="customer_type" name="customer_type">
                            <option value="">선택하세요</option>
                            <option value="정기점검 계약 고객사" ${customer.customerType == '정기점검 계약 고객사' ? 'selected' : ''}>정기점검 계약 고객사</option>
                            <option value="납품 계약 고객사" ${customer.customerType == '납품 계약 고객사' ? 'selected' : ''}>납품 계약 고객사</option>
                            <option value="유지보수 종료 고객사" ${customer.customerType == '유지보수 종료 고객사' ? 'selected' : ''}>유지보수 종료 고객사</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <!-- 빈 칸으로 두어 균형 맞춤 -->
                    </div>
                </div>
                
                <!-- 외부 솔루션 -->
                <div class="section-title">외부 솔루션</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="etl_tool">ETL Tool</label>
                        <input type="text" id="etl_tool" name="etl_tool" value="${customer.etlTool}">
                    </div>
                    <div class="form-group">
                        <label for="bi_tool">BI Tool</label>
                        <input type="text" id="bi_tool" name="bi_tool" value="${customer.biTool}">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="db_encryption">DB 암호화</label>
                        <input type="text" id="db_encryption" name="db_encryption" value="${customer.dbEncryption}">
                    </div>
                    <div class="form-group">
                        <label for="cdc_tool">CDC Tool</label>
                        <input type="text" id="cdc_tool" name="cdc_tool" value="${customer.cdcTool}">
                    </div>
                </div>
                
                <!-- 비고 -->
                <div class="form-row">
                    <div class="form-group full-width">
                        <label for="note">비고</label>
                        <textarea id="note" name="note" rows="3">${customer.note}</textarea>
                    </div>
                </div>
                
                <!-- 버튼 -->
                <div class="button-group">
                    <a href="${pageContext.request.contextPath}/customers?view=list" class="btn btn-cancel">취소</a>
                    <a href="${pageContext.request.contextPath}/customers?view=detail&customerName=${customer.customerName}" class="btn btn-secondary">상세보기</a>
                    <button type="submit" class="btn btn-primary">수정 완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
/* 모든 스타일을 .customer-edit-page 클래스 하위로 제한 */
.customer-edit-page > .container {
    max-width: 1000px !important;
    margin: 0 auto !important;
    padding: 20px !important;
}

.customer-edit-page > .container > .page-header {
    margin-bottom: 30px !important;
    text-align: center !important;
}

.customer-edit-page > .container > .page-header h2 {
    color: #333 !important;
    margin-bottom: 10px !important;
}

.customer-edit-page > .container > .page-header p {
    color: #666 !important;
    margin: 0 !important;
}

/* 폼 컨테이너 */
.customer-edit-page > .container > .form-container {
    background: white !important;
    border: 1px solid #ddd !important;
    border-radius: 8px !important;
    padding: 30px !important;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1) !important;
}

/* 섹션 제목 */
.customer-edit-page .form-container .section-title {
    font-size: 16px !important;
    font-weight: bold !important;
    color: #333 !important;
    margin: 25px 0 15px 0 !important;
    padding-bottom: 8px !important;
    border-bottom: 2px solid #007bff !important;
}

.customer-edit-page .form-container .section-title:first-child {
    margin-top: 0 !important;
}

/* 폼 행 */
.customer-edit-page .form-container .form-row {
    display: flex !important;
    gap: 20px !important;
    margin-bottom: 15px !important;
}

.customer-edit-page .form-container .form-group {
    flex: 1 !important;
}

.customer-edit-page .form-container .form-group.full-width {
    flex: 1 1 100% !important;
}

/* 라벨 */
.customer-edit-page .form-container .form-group label {
    display: block !important;
    margin-bottom: 5px !important;
    font-weight: 500 !important;
    color: #333 !important;
    font-size: 14px !important;
}

.customer-edit-page .form-container .form-text {
    font-size: 12px !important;
    color: #6c757d !important;
    margin-top: 2px !important;
}

/* 입력 필드 */
.customer-edit-page .form-container .form-group input,
.customer-edit-page .form-container .form-group select,
.customer-edit-page .form-container .form-group textarea {
    width: 100% !important;
    padding: 10px 12px !important;
    border: 1px solid #ddd !important;
    border-radius: 4px !important;
    font-size: 14px !important;
    background: white !important;
    transition: border-color 0.2s !important;
    box-sizing: border-box !important;
}

.customer-edit-page .form-container .form-group input:focus,
.customer-edit-page .form-container .form-group select:focus,
.customer-edit-page .form-container .form-group textarea:focus {
    outline: none !important;
    border-color: #007bff !important;
    box-shadow: 0 0 0 2px rgba(0,123,255,0.25) !important;
}

.customer-edit-page .form-container .form-group textarea {
    resize: vertical !important;
    min-height: 80px !important;
}

/* 버튼 그룹 */
.customer-edit-page .form-container .button-group {
    text-align: center !important;
    margin-top: 30px !important;
    padding-top: 20px !important;
    border-top: 1px solid #eee !important;
}

.customer-edit-page .form-container .btn {
    display: inline-block !important;
    padding: 12px 24px !important;
    margin: 0 5px !important;
    border: none !important;
    border-radius: 4px !important;
    font-size: 14px !important;
    font-weight: 500 !important;
    text-decoration: none !important;
    cursor: pointer !important;
    transition: all 0.2s !important;
}

.customer-edit-page .form-container .btn-primary {
    background: #007bff !important;
    color: white !important;
}

.customer-edit-page .form-container .btn-primary:hover {
    background: #0056b3 !important;
}

.customer-edit-page .form-container .btn-secondary {
    background: #6c757d !important;
    color: white !important;
}

.customer-edit-page .form-container .btn-secondary:hover {
    background: #545b62 !important;
    text-decoration: none !important;
}

.customer-edit-page .form-container .btn-cancel {
    background: #6c757d !important;
    color: white !important;
}

.customer-edit-page .form-container .btn-cancel:hover {
    background: #545b62 !important;
    text-decoration: none !important;
}

/* 알림 메시지 */
.customer-edit-page > .container > .alert {
    padding: 12px 16px !important;
    margin-bottom: 20px !important;
    border-radius: 4px !important;
    border: 1px solid transparent !important;
}

.customer-edit-page > .container > .alert-danger {
    color: #721c24 !important;
    background-color: #f8d7da !important;
    border-color: #f5c6cb !important;
}

/* 반응형 */
@media (max-width: 768px) {
    .customer-edit-page > .container {
        padding: 15px !important;
    }
    
    .customer-edit-page > .container > .form-container {
        padding: 20px !important;
    }
    
    .customer-edit-page .form-container .form-row {
        flex-direction: column !important;
        gap: 10px !important;
    }
    
    .customer-edit-page .form-container .form-group {
        flex: none !important;
    }
    
    .customer-edit-page .form-container .button-group {
        text-align: stretch !important;
    }
    
    .customer-edit-page .form-container .btn {
        display: block !important;
        width: 100% !important;
        margin: 5px 0 !important;
    }
}
</style>

<script>
// 폼 유효성 검사 및 확인
document.querySelector('form').addEventListener('submit', function(e) {
    if (!confirm('고객사 정보를 수정하시겠습니까?')) {
        e.preventDefault();
        return false;
    }
});

// 페이지 로드 시 포커스
document.addEventListener('DOMContentLoaded', function() {
    // 첫 번째 편집 가능한 필드에 포커스
    const firstInput = document.querySelector('#first_introduction_year');
    if (firstInput) {
        firstInput.focus();
    }
});
</script>

<%@ include file="/includes/footer.jsp" %>
