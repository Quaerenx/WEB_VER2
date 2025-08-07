<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="대시보드" scope="request" />
<%@ include file="/includes/header.jsp" %>

<style>


.main-content {
    /* 또는 고정 높이로 */
    min-height: 1000px;
}

@keyframes pulse-dark {
    0% { box-shadow: 0 0 0 0 rgba(31, 41, 55, 0.7); }
    70% { box-shadow: 0 0 0 10px rgba(31, 41, 55, 0); }
    100% { box-shadow: 0 0 0 0 rgba(31, 41, 55, 0); }
}

@keyframes glow-dark {
    from { 
        box-shadow: 0 0 5px rgba(55, 65, 81, 0.5), 0 0 10px rgba(55, 65, 81, 0.3);
        transform: translateY(-2px);
    }
    to { 
        box-shadow: 0 0 10px rgba(55, 65, 81, 0.8), 0 0 20px rgba(55, 65, 81, 0.4);
        transform: translateY(-3px);
    }
}

.loading-spinner {
    display: none;
    width: 20px;
    height: 20px;
    border: 2px solid #e5e7eb;
    border-top: 2px solid #374151;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 15px auto 0;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.alert {
    margin-top: 15px;
    padding: 12px 16px;
    border-radius: 8px;
    font-size: 14px;
    display: none;
    border: 1px solid;
}

.alert-success {
    background: #f3f4f6;
    border-color: #d1d5db;
    color: #374151;
}

.alert-error {
    background: #fef2f2;
    border-color: #fecaca;
    color: #dc2626;
}

/* 반응형 디자인 */
@media (max-width: 768px) {
    .host-buttons-container {
        flex-direction: column;
        align-items: center;
    }
    
    .host-button {
        min-width: 200px;
    }
    
    .host-status-panel {
        padding: 20px 15px;
    }
}
</style>

<div class="main-content">
    <div class="container">
        <div class="jumbotron">
            <h1>안녕하세요, ${user.userName}님!</h1>
            <p class="lead">업무 능률 증진을 위한 웹사이트입니다.</p>
        </div>
       
        
        <div class="row">
            <c:forEach var="entry" items="${dashboardMenus}">
                <div class="col-md-4">
                    <div class="card dashboard-card">
                        <div class="card-header">
                            <i class="fas fa-th-large"></i> ${entry.key}
                        </div>
                        <div class="card-body">
                            <ul class="dashboard-submenu">
                                <c:forEach var="menuItem" items="${entry.value}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/${menuItem.url}">
                                            <i class="${menuItem.icon} mr-2"></i>${menuItem.title}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<%@ include file="/includes/footer.jsp" %>