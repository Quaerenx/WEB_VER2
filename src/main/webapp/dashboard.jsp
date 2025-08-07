<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="대시보드" scope="request" />
<%@ include file="/includes/header.jsp" %>

<!-- 대시보드 전용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/dashboard.css">

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