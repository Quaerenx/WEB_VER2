<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="대시보드" scope="request" />
<%@ include file="/includes/header.jsp" %>

<style>
/* 호스트 상태 패널 스타일 - 블랙앤화이트 버전 */
.host-status-panel {
    background: #ffffff;
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    color: #374151;
}

.main-content {
    /* 또는 고정 높이로 */
    min-height: 1000px;
}

.host-status-title {
    font-size: 1.4rem;
    font-weight: 700;
    margin-bottom: 20px;
    text-align: center;
    color: #1f2937;
    border-bottom: 2px solid #f3f4f6;
    padding-bottom: 15px;
}

.host-buttons-container {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
}

.host-button {
    position: relative;
    padding: 15px 25px;
    border: 2px solid #d1d5db;
    border-radius: 8px;
    background: #ffffff;
    color: #374151;
    font-weight: 600;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 120px;
    text-align: center;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.host-button:hover {
    background: #f9fafb;
    border-color: #9ca3af;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.host-button.in-use {
    background: #1f2937;
    border-color: #1f2937;
    color: #ffffff;
    animation: pulse-dark 2s infinite;
}

.host-button.my-use {
    background: #374151;
    border-color: #374151;
    color: #ffffff;
    animation: glow-dark 2s infinite alternate;
}

.host-button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
}

.host-status-info {
    font-size: 12px;
    margin-top: 5px;
    opacity: 0.8;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.host-button.in-use .host-status-info,
.host-button.my-use .host-status-info {
    opacity: 0.9;
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
        
        <!-- 호스트 상태 패널 -->
        <div class="host-status-panel">
            <div class="host-status-title">🖥️ 호스트 서버 상태</div>
            <div class="host-buttons-container">
                <c:forEach var="host" items="${hostStatusList}">
                    <button class="host-button ${host.inUse ? (host.userName == user.userName ? 'my-use' : 'in-use') : ''}" 
                            data-host="${host.hostName}"
                            ${host.inUse && host.userName != user.userName ? 'disabled' : ''}>
                        <div class="host-name">${host.hostName}</div>
                        <div class="host-status-info">
                            <c:choose>
                                <c:when test="${host.inUse}">
                                    <c:choose>
                                        <c:when test="${host.userName == user.userName}">
                                            사용 중 (나)
                                        </c:when>
                                        <c:otherwise>
                                            사용 중 (${host.userName})
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    사용 가능
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </button>
                </c:forEach>
            </div>
            
            <div class="loading-spinner" id="loadingSpinner"></div>
            
            <div class="alert alert-success" id="successAlert"></div>
            <div class="alert alert-error" id="errorAlert"></div>
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
<script>
$(document).ready(function() {
    // 페이지 로드 시 상태 갱신
    updateHostStatus();
    
    // 5초마다 상태 자동 갱신
    setInterval(updateHostStatus, 5000);
    
    // 호스트 버튼 클릭 이벤트
    $('.host-button').click(function() {
        if ($(this).prop('disabled')) {
            return;
        }
        
        const hostName = $(this).data('host');
        toggleHostStatus(hostName);
    });
});

// 호스트 상태 토글
function toggleHostStatus(hostName) {
    showLoading(true);
    hideAlerts();
    
    $.ajax({
        url: '${pageContext.request.contextPath}/hostStatus',
        type: 'POST',
        data: {
            action: 'toggle',
            hostName: hostName
        },
        success: function(response) {
            showLoading(false);
            
            if (response.success) {
                showAlert('success', response.message);
                updateHostStatus(); // 상태 즉시 갱신
            } else {
                showAlert('error', response.message || '상태 변경에 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            showLoading(false);
            console.error('AJAX Error:', error);
            showAlert('error', '서버 통신 중 오류가 발생했습니다.');
        }
    });
}

// 호스트 상태 갱신
function updateHostStatus() {
    $.ajax({
        url: '${pageContext.request.contextPath}/hostStatus',
        type: 'GET',
        data: {
            action: 'getStatus'
        },
        success: function(response) {
            if (response.hosts) {
                updateHostButtons(response.hosts);
            }
        },
        error: function(xhr, status, error) {
            console.error('상태 갱신 실패:', error);
        }
    });
}

// 호스트 버튼 상태 업데이트
function updateHostButtons(hosts) {
    const currentUser = '${user.userName}';
    
    hosts.forEach(function(host) {
        const button = $('[data-host="' + host.hostName + '"]');
        const statusInfo = button.find('.host-status-info');
        
        // 기존 클래스 제거
        button.removeClass('in-use my-use');
        button.prop('disabled', false);
        
        if (host.isInUse) {
            if (host.userName === currentUser) {
                button.addClass('my-use');
                statusInfo.text('사용 중 (나)');
            } else {
                button.addClass('in-use');
                button.prop('disabled', true);
                statusInfo.text('사용 중 (' + host.userName + ')');
            }
        } else {
            statusInfo.text('사용 가능');
        }
    });
}

// 로딩 스피너 표시/숨김
function showLoading(show) {
    if (show) {
        $('#loadingSpinner').show();
        $('.host-button').prop('disabled', true);
    } else {
        $('#loadingSpinner').hide();
        // 원래 상태로 복원은 updateHostButtons에서 처리
    }
}

// 알림 메시지 표시
function showAlert(type, message) {
    hideAlerts();
    
    const alertId = type === 'success' ? '#successAlert' : '#errorAlert';
    $(alertId).text(message).fadeIn();
    
    // 3초 후 자동 숨김
    setTimeout(function() {
        $(alertId).fadeOut();
    }, 3000);
}

// 모든 알림 숨김
function hideAlerts() {
    $('.alert').hide();
}
</script>

<%@ include file="/includes/footer.jsp" %>
