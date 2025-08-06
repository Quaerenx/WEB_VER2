<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="고객사 상세정보" scope="request" />
<%@ include file="/includes/header.jsp" %>


<style>
    .customer-detail {
        max-width: 1000px;
        margin: 0 auto;
        padding: 20px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    .page-header {
        background: #ffffff;
        color: #2c3e50;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        border: 1px solid #e8ecef;
    }
    
    .page-header h1 {
        margin: 0 0 0.5rem 0;
        font-size: 1.75rem;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .page-header .lead {
        margin: 0;
        color: #6c757d;
        font-size: 1rem;
    }
    
    .header-actions {
        display: flex;
        gap: 1rem;
        align-items: center;
    }
    
    .btn {
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
        font-size: 0.9rem;
    }
    
    .btn-primary {
        background: #4f46e5;
        color: white;
    }
    
    .btn-primary:hover {
        background: #4338ca;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
        color: white;
        text-decoration: none;
    }
    
    .btn-secondary {
        background: #6b7280;
        color: white;
    }
    
    .btn-secondary:hover {
        background: #4b5563;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(107, 114, 128, 0.25);
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
    
    .detail-container {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        border: 1px solid #e5e7eb;
    }
    
    .detail-section {
        margin-bottom: 0;
        padding: 20px;
        border-bottom: 1px solid #f3f4f6;
    }
    
    .detail-section:last-child {
        margin-bottom: 0;
        border-bottom: none;
    }
    
    .detail-section-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #1f2937;
        margin-bottom: 15px;
        padding-bottom: 8px;
        border-bottom: 2px solid #e5e7eb;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .detail-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 1rem;
    }
    
    .detail-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 0;
        border-bottom: 1px solid #f3f4f6;
    }
    
    .detail-item:last-child {
        border-bottom: none;
    }
    
    .detail-label {
        font-weight: 600;
        color: #6b7280;
        font-size: 14px;
        min-width: 110px;
    }
    
    .detail-value {
        font-weight: 500;
        color: #1f2937;
        text-align: right;
        word-break: break-word;
        flex: 1;
        margin-left: 1rem;
        font-size: 14px;
    }
    
    .detail-item.full-width {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .detail-item.full-width .detail-label {
        margin-bottom: 8px;
    }
    
    .detail-item.full-width .detail-value {
        text-align: left;
        width: 100%;
        margin-left: 0;
    }
    
    .note-content {
        background: #f9fafb;
        padding: 12px;
        border-radius: 6px;
        border: 1px solid #e5e7eb;
        min-height: 60px;
        width: 100%;
        font-size: 14px;
        line-height: 1.4;
    }
    
    .empty-value {
        color: #9ca3af;
        font-style: italic;
    }
    
    /* 반응형 디자인 */
    @media (max-width: 768px) {
        .customer-detail {
            max-width: 100%;
            padding: 15px;
        }
        
        .page-header {
            padding: 15px;
        }
        
        .page-header h1 {
            font-size: 1.5rem;
        }
        
        .header-actions {
            flex-direction: column;
            align-items: stretch;
        }
        
        .detail-grid {
            grid-template-columns: 1fr;
        }
        
        .detail-section {
            padding: 15px;
        }
        
        .detail-section-title {
            font-size: 1rem;
        }
        
        .detail-item {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }
        
        .detail-label {
            min-width: auto;
        }
        
        .detail-value {
            text-align: left;
            margin-left: 0;
        }
    }
</style>

<div class="customer-detail">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="fas fa-building"></i> 
                    <c:choose>
                        <c:when test="${not empty customerDetail.customerName}">
                            ${customerDetail.customerName}
                        </c:when>
                        <c:when test="${not empty customer.customerName}">
                            ${customer.customerName}
                        </c:when>
                        <c:otherwise>
                            고객사
                        </c:otherwise>
                    </c:choose>
                    상세정보
                </h1>
                <p class="lead">고객사 정보 및 시스템 세부사항</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/customers?view=list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    목록으로
                </a>
                <a href="${pageContext.request.contextPath}/customers?view=editDetail&customerName=<c:choose><c:when test='${not empty customerDetail.customerName}'>${customerDetail.customerName}</c:when><c:otherwise>${customer.customerName}</c:otherwise></c:choose>" class="btn btn-primary">
                    <i class="fas fa-edit"></i>
                    수정하기
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
    
    <!-- 고객사 상세정보가 있는 경우 -->
    <c:if test="${not empty customerDetail}">
        <div class="detail-container">
            <!-- 메타정보 섹션 -->
            <div class="detail-section">
                <div class="detail-section-title">
                    <i class="fas fa-info-circle"></i>
                    메타정보
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">고객사</span>
                        <span class="detail-value">${not empty customerDetail.customerName ? customerDetail.customerName : '-'}</span>
                    </div>
                    <div class="detail-item">
					    <span class="detail-label">시스템명</span>
					    <span class="detail-value">${not empty customerDetail.systemName ? customerDetail.systemName : '-'}</span>
					</div>
                    <div class="detail-item">
                        <span class="detail-label">고객사 담당자</span>
                        <span class="detail-value">${not empty customerDetail.customerManager ? customerDetail.customerManager : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">담당 SI</span>
                        <span class="detail-value">${not empty customerDetail.siCompany ? customerDetail.siCompany : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">SI 담당자</span>
                        <span class="detail-value">${not empty customerDetail.siManager ? customerDetail.siManager : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">작성자</span>
                        <span class="detail-value">${not empty customerDetail.creator ? customerDetail.creator : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">작성일자</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty customerDetail.createDate}">
                                    <fmt:formatDate value="${customerDetail.createDate}" pattern="yyyy-MM-dd" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">담당자 정</span>
                        <span class="detail-value">${not empty customerDetail.mainManager ? customerDetail.mainManager : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">담당자 부</span>
                        <span class="detail-value">${not empty customerDetail.subManager ? customerDetail.subManager : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">설치일자</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty customerDetail.installDate}">
                                    <fmt:formatDate value="${customerDetail.installDate}" pattern="yyyy-MM-dd" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">도입년도</span>
                        <span class="detail-value">${not empty customerDetail.introductionYear ? customerDetail.introductionYear : '-'}</span>
                    </div>
                </div>
            </div>
            
            <!-- Vertica 정보 섹션 -->
            <div class="detail-section">
                <div class="detail-section-title">
                    <i class="fas fa-database"></i>
                    Vertica 정보
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">DB명</span>
                        <span class="detail-value">${not empty customerDetail.dbName ? customerDetail.dbName : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">DB mode</span>
                        <span class="detail-value">${not empty customerDetail.dbMode ? customerDetail.dbMode : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Version</span>
                        <span class="detail-value">${not empty customerDetail.verticaVersion ? customerDetail.verticaVersion : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">라이센스</span>
                        <span class="detail-value">${not empty customerDetail.licenseInfo ? customerDetail.licenseInfo : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">SAID</span>
                        <span class="detail-value">${not empty customerDetail.said ? customerDetail.said : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">노드 수</span>
                        <span class="detail-value">${not empty customerDetail.nodeCount ? customerDetail.nodeCount : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Vertica admin</span>
                        <span class="detail-value">${not empty customerDetail.verticaAdmin ? customerDetail.verticaAdmin : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Subcluster 유무</span>
                        <span class="detail-value">${not empty customerDetail.subclusterYn ? customerDetail.subclusterYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">MC 여부</span>
                        <span class="detail-value">${not empty customerDetail.mcYn ? customerDetail.mcYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">MC host</span>
                        <span class="detail-value">${not empty customerDetail.mcHost ? customerDetail.mcHost : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">MC version</span>
                        <span class="detail-value">${not empty customerDetail.mcVersion ? customerDetail.mcVersion : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">MC admin</span>
                        <span class="detail-value">${not empty customerDetail.mcAdmin ? customerDetail.mcAdmin : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">백업 여부</span>
                        <span class="detail-value">${not empty customerDetail.backupYn ? customerDetail.backupYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">사용자 정의 리소스풀 여부</span>
                        <span class="detail-value">${not empty customerDetail.customResourcePoolYn ? customerDetail.customResourcePoolYn : '-'}</span>
                    </div>
                </div>
                <div class="detail-item full-width" style="margin-top: 1rem;">
                    <span class="detail-label">백업비고</span>
                    <div class="detail-value note-content">${not empty customerDetail.backupNote ? customerDetail.backupNote : '-'}</div>
                </div>
            </div>
            
            <!-- 환경 정보 섹션 -->
            <div class="detail-section">
                <div class="detail-section-title">
                    <i class="fas fa-server"></i>
                    환경 정보
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">OS</span>
                        <span class="detail-value">${not empty customerDetail.osInfo ? customerDetail.osInfo : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">메모리</span>
                        <span class="detail-value">${not empty customerDetail.memoryInfo ? customerDetail.memoryInfo : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">인프라 구분</span>
                        <span class="detail-value">${not empty customerDetail.infraType ? customerDetail.infraType : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">CPU 소켓</span>
                        <span class="detail-value">${not empty customerDetail.cpuSocket ? customerDetail.cpuSocket : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">HyperThreading</span>
                        <span class="detail-value">${not empty customerDetail.hyperThreading ? customerDetail.hyperThreading : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">CPU 코어</span>
                        <span class="detail-value">${not empty customerDetail.cpuCore ? customerDetail.cpuCore : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">/data 영역</span>
                        <span class="detail-value">${not empty customerDetail.dataArea ? customerDetail.dataArea : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Depot 영역</span>
                        <span class="detail-value">${not empty customerDetail.depotArea ? customerDetail.depotArea : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">/catalog 영역</span>
                        <span class="detail-value">${not empty customerDetail.catalogArea ? customerDetail.catalogArea : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">object 영역</span>
                        <span class="detail-value">${not empty customerDetail.objectArea ? customerDetail.objectArea : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Public 여부</span>
                        <span class="detail-value">${not empty customerDetail.publicYn ? customerDetail.publicYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Public 대역</span>
                        <span class="detail-value">${not empty customerDetail.publicNetwork ? customerDetail.publicNetwork : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Private 여부</span>
                        <span class="detail-value">${not empty customerDetail.privateYn ? customerDetail.privateYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Private 대역</span>
                        <span class="detail-value">${not empty customerDetail.privateNetwork ? customerDetail.privateNetwork : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">storage 여부</span>
                        <span class="detail-value">${not empty customerDetail.storageYn ? customerDetail.storageYn : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Storage 대역</span>
                        <span class="detail-value">${not empty customerDetail.storageNetwork ? customerDetail.storageNetwork : '-'}</span>
                    </div>
                </div>
            </div>
            
            <!-- 외부 솔루션 섹션 -->
            <div class="detail-section">
                <div class="detail-section-title">
                    <i class="fas fa-puzzle-piece"></i>
                    외부 솔루션
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">ETL</span>
                        <span class="detail-value">${not empty customerDetail.etlTool ? customerDetail.etlTool : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">BI</span>
                        <span class="detail-value">${not empty customerDetail.biTool ? customerDetail.biTool : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">DB암호화</span>
                        <span class="detail-value">${not empty customerDetail.dbEncryption ? customerDetail.dbEncryption : '-'}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">CDC</span>
                        <span class="detail-value">${not empty customerDetail.cdcTool ? customerDetail.cdcTool : '-'}</span>
                    </div>
                </div>
            </div>
            
            <!-- 기타 정보 섹션 -->
            <div class="detail-section">
                <div class="detail-section-title">
                    <i class="fas fa-sticky-note"></i>
                    기타 정보
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">EOS 일자</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty customerDetail.eosDate}">
                                    <fmt:formatDate value="${customerDetail.eosDate}" pattern="yyyy-MM-dd" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">고객 유형</span>
                        <span class="detail-value">${not empty customerDetail.customerType ? customerDetail.customerType : '-'}</span>
                    </div>
                </div>
                <div class="detail-item full-width" style="margin-top: 1rem;">
                    <span class="detail-label">비고</span>
                    <div class="detail-value note-content">${not empty customerDetail.note ? customerDetail.note : '-'}</div>
                </div>
            </div>
        </div>
    </c:if>
    
    <!-- 상세정보가 없지만 기본 정보가 있는 경우 -->
    <c:if test="${empty customerDetail and not empty customer}">
        <div class="detail-container">
            <div class="detail-section" style="text-align: center; padding: 4rem;">
                <i class="fas fa-info-circle" style="font-size: 3rem; color: #f59e0b; margin-bottom: 1rem;"></i>
                <h3 style="color: #374151; margin-bottom: 1rem;">상세정보가 등록되지 않았습니다</h3>
                <p style="color: #6b7280; margin-bottom: 2rem;">
                    ${customer.customerName}의 기본 정보는 있지만 상세정보가 등록되지 않았습니다.<br>
                    상세정보를 등록하려면 수정 페이지에서 추가해 주세요.
                </p>
                <div style="display: flex; gap: 1rem; justify-content: center;">
                    <a href="${pageContext.request.contextPath}/customers?view=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        목록으로 돌아가기
                    </a>
				<a href="${pageContext.request.contextPath}/customers?view=editDetail&customerName=${customer.customerName}" class="btn btn-primary">
				    <i class="fas fa-edit"></i>
				    정보 수정하기
				</a>
                </div>
            </div>
        </div>
    </c:if>
    
    <!-- 고객사 정보가 전혀 없는 경우 -->
    <c:if test="${empty customer and empty customerDetail}">
        <div class="detail-container">
            <div class="detail-section" style="text-align: center; padding: 4rem;">
                <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #ef4444; margin-bottom: 1rem;"></i>
                <h3 style="color: #374151; margin-bottom: 1rem;">고객사 정보를 찾을 수 없습니다</h3>
                <p style="color: #6b7280; margin-bottom: 2rem;">요청하신 고객사 정보가 존재하지 않거나 삭제되었을 수 있습니다.</p>
                <a href="${pageContext.request.contextPath}/customers?view=list" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i>
                    목록으로 돌아가기
                </a>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="/includes/footer.jsp" %>
