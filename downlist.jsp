<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%
    // 세션 확인
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login");
        return;
    }
%>

<%
    String baseDir = "/files";
    String relativePath = request.getParameter("path");
    if (relativePath == null) relativePath = "";

    // 보안 검증
    if (relativePath.contains("..") || relativePath.contains("\\")) {
        out.println("<h3>잘못된 경로입니다.</h3>");
        return;
    }
    
    String realPath = application.getRealPath(baseDir + "/" + relativePath);
    File currentDir = new File(realPath);
    if (!currentDir.exists() || !currentDir.isDirectory()) {
        out.println("<h3>잘못된 경로입니다.</h3>");
        return;
    }

    File[] files = currentDir.listFiles();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    // 정렬: 폴더 먼저, 그 다음 파일
    if (files != null) {
        Arrays.sort(files, new Comparator<File>() {
            public int compare(File f1, File f2) {
                if (f1.isDirectory() && !f2.isDirectory()) return -1;
                if (!f1.isDirectory() && f2.isDirectory()) return 1;
                return f1.getName().compareToIgnoreCase(f2.getName());
            }
        });
    }
%>

<% 
    // 페이지 타이틀 설정
    pageContext.setAttribute("pageTitle", "업무자료 파일서버 - " + (relativePath.isEmpty() ? "/" : ("/" + relativePath)));
%>

<!-- Header Include -->
<%@ include file="includes/header.jsp" %>

<!-- 파일 서버 전용 스타일 -->
<style>
    /* 파일 서버 전용 스타일 */
    .file-server-container {
        margin: 0;
        padding: 0;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
        background-color: #f8f9fa;
        min-height: 100vh;
    }
    
    .main-content {
        width: 100%;
        max-width: 1000px;
        margin: 0 auto;
        padding: var(--space-32) var(--space-16);
    }
    
    .file-main {
        width: 100%;
        padding: 20px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .breadcrumb {
        background: #f8f9fa;
        padding: 15px 20px;
        border-radius: 6px;
        margin-bottom: 20px;
        font-size: 14px;
    }
    
    .breadcrumb a {
        color: #495057;
        text-decoration: none;
    }
    
    .breadcrumb a:hover {
        color: #007bff;
        text-decoration: underline;
    }
    
    .file-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    
    .file-table th {
        background: #f8f9fa;
        padding: 12px 8px;
        text-align: left;
        border-bottom: 2px solid #dee2e6;
        font-weight: 600;
        color: #495057;
    }
    
    .file-table th a {
        color: #495057;
        text-decoration: none;
    }
    
    .file-table th a:hover {
        color: #007bff;
    }
    
    .file-table td {
        padding: 8px;
        border-bottom: 1px solid #f1f3f4;
        vertical-align: middle;
    }
    
    .file-table tr:hover {
        background-color: #f8f9fa;
    }
    
    .icon {
        width: 20px;
        height: 20px;
        margin-right: 8px;
        vertical-align: middle;
    }
    
    .file-name {
        display: flex;
        align-items: center;
    }
    
    .file-name a {
        color: #495057;
        text-decoration: none;
    }
    
    .file-name a:hover {
        color: #007bff;
        text-decoration: underline;
    }
    
    .directory a {
        color: #007bff;
        font-weight: 500;
    }
    
    .size {
        text-align: right;
        font-family: monospace;
        color: #6c757d;
    }
    
    .date {
        color: #6c757d;
        white-space: nowrap;
    }
    
    .parent-dir {
        background: #e3f2fd;
    }
    
    .parent-dir:hover {
        background: #bbdefb;
    }
    
    .stats {
        background: #f8f9fa;
        padding: 10px 20px;
        border-radius: 6px;
        margin-top: 20px;
        font-size: 12px;
        color: #6c757d;
    }
    
    .file-footer {
        text-align: center;
        padding: 20px;
        color: #6c757d;
        font-size: 12px;
        margin-top: 40px;
    }
    
    /* 업로드 버튼 스타일 */
    .upload-section {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .upload-info {
        display: flex;
        align-items: center;
    }
    
    .upload-info h5 {
        margin: 0;
        margin-right: 10px;
        font-weight: 600;
    }
    
    .upload-info small {
        opacity: 0.9;
    }
    
    .upload-btn {
        background: rgba(255,255,255,0.2);
        border: 2px solid rgba(255,255,255,0.3);
        color: white;
        padding: 8px 20px;
        border-radius: 25px;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .upload-btn:hover {
        background: rgba(255,255,255,0.3);
        border-color: rgba(255,255,255,0.5);
        color: white;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    
    .upload-btn:active {
        transform: translateY(0);
    }
    
    @media (max-width: 768px) {
        .main-content {
            max-width: 100%;
            padding: var(--space-24) var(--space-16);
        }
        
        .file-main {
            padding: 15px;
        }
        
        .upload-section {
            flex-direction: column;
            text-align: center;
            gap: 15px;
        }
        
        .upload-info {
            flex-direction: column;
            gap: 5px;
        }
    }
</style>

<main class="main-content">
    <div class="container">
        <div class="jumbotron">
            <% if ("success".equals(request.getParameter("upload"))) { %>
            <div class="alert alert-success alert-dismissible fade show">
                ✅ 파일이 성공적으로 업로드되었습니다!
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
            <% } %>
            <h1>업무자료 파일서버</h1>
            <p class="lead">업무에 필요한 파일을 안전하고 빠르게 공유할 수 있습니다.</p>
        </div>

        <div class="file-main">
            <!-- 업로드 섹션 -->
            <div class="upload-section">
                <div class="upload-info">
                    <h5>📤 파일 업로드</h5>
                    <small>이 폴더에 새 파일을 업로드할 수 있습니다</small>
                </div>
                <a href="upload.jsp?path=<%= relativePath %>" class="upload-btn">
                    <span>📁</span>
                    파일 업로드하기
                </a>
            </div>

            <div class="breadcrumb">
                <strong>📍 현재 위치:</strong> 
                <a href="downlist.jsp">/</a><%
                if (!relativePath.isEmpty()) {
                    String[] parts = relativePath.split("/");
                    String currentPath = "";
                    for (int i = 0; i < parts.length; i++) {
                        if (!parts[i].isEmpty()) {
                            currentPath += parts[i];
                            out.print("<a href=\"downlist.jsp?path=" + currentPath + "\">" + parts[i] + "</a>");
                            if (i < parts.length - 1) out.print("/");
                            currentPath += "/";
                        }
                    }
                }
                %>
            </div>

            <table class="file-table">
                <thead>
                    <tr>
                        <th width="20"></th>
                        <th><a href="?path=<%= relativePath %>&sort=name">📄 이름</a></th>
                        <th width="150"><a href="?path=<%= relativePath %>&sort=date">📅 수정일</a></th>
                        <th width="80"><a href="?path=<%= relativePath %>&sort=size">💾 크기</a></th>
                        <th width="200">📝 설명</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 상위 디렉토리 링크 --%>
                    <% if (!relativePath.isEmpty()) {
                        String[] parts = relativePath.split("/");
                        String parentPath = "";
                        for (int i = 0; i < parts.length - 1; i++) {
                            if (!parts[i].isEmpty()) {
                                parentPath += parts[i] + "/";
                            }
                        }
                        if (parentPath.endsWith("/")) {
                            parentPath = parentPath.substring(0, parentPath.length() - 1);
                        }
                    %>
                    <tr class="parent-dir">
                        <td><span class="icon">⬆️</span></td>
                        <td class="file-name">
                            <a href="downlist.jsp?path=<%= parentPath %>"><strong>상위 디렉토리</strong></a>
                        </td>
                        <td class="date">-</td>
                        <td class="size">-</td>
                        <td>상위 폴더로 이동</td>
                    </tr>
                    <% } %>

                    <%-- 파일 및 폴더 목록 --%>
                    <%
                        int fileCount = 0;
                        int dirCount = 0;
                        long totalSize = 0;
                        
                        if (files != null && files.length > 0) {
                            for (File file : files) {
                                String name = file.getName();
                                String encodedPath = relativePath.isEmpty() ? name : (relativePath + "/" + name);
                                Date lastModified = new Date(file.lastModified());
                                
                                if (file.isDirectory()) {
                                    dirCount++;
                    %>
                    <tr class="directory">
                        <td><span class="icon">📁</span></td>
                        <td class="file-name">
                            <a href="downlist.jsp?path=<%= encodedPath %>"><%= name %>/</a>
                        </td>
                        <td class="date"><%= dateFormat.format(lastModified) %></td>
                        <td class="size">-</td>
                        <td>폴더</td>
                    </tr>
                    <%
                                } else {
                                    fileCount++;
                                    totalSize += file.length();
                                    String fileExt = "";
                                    int lastDot = name.lastIndexOf('.');
                                    if (lastDot > 0) {
                                        fileExt = name.substring(lastDot + 1).toLowerCase();
                                    }
                                    
                                    String icon = "📄";
                                    String description = "파일";
                                    
                                    // 파일 타입별 아이콘 및 설명
                                    if (fileExt.matches("jpg|jpeg|png|gif|bmp|svg")) {
                                        icon = "🖼️";
                                        description = "이미지 파일";
                                    } else if (fileExt.matches("mp4|avi|mov|wmv|flv|mkv")) {
                                        icon = "🎬";
                                        description = "동영상 파일";
                                    } else if (fileExt.matches("mp3|wav|flac|aac|ogg")) {
                                        icon = "🎵";
                                        description = "음악 파일";
                                    } else if (fileExt.matches("pdf")) {
                                        icon = "📋";
                                        description = "PDF 문서";
                                    } else if (fileExt.matches("doc|docx")) {
                                        icon = "📝";
                                        description = "Word 문서";
                                    } else if (fileExt.matches("xls|xlsx")) {
                                        icon = "📊";
                                        description = "Excel 문서";
                                    } else if (fileExt.matches("zip|rar|7z|tar|gz")) {
                                        icon = "📦";
                                        description = "압축 파일";
                                    } else if (fileExt.matches("txt|log")) {
                                        icon = "📃";
                                        description = "텍스트 파일";
                                    }
                    %>
                    <tr>
                        <td><span class="icon"><%= icon %></span></td>
                        <td class="file-name">
                            <a href="download.jsp?path=<%= relativePath.isEmpty() ? "" : (relativePath + "/") %>&filename=<%= name %>">
                                <%= name %>
                            </a>
                        </td>
                        <td class="date"><%= dateFormat.format(lastModified) %></td>
                        <td class="size"><%
                            long fileLength = file.length();
                            String sizeStr = "";
                            if (fileLength == 0) {
                                sizeStr = "0";
                            } else {
                                String[] units = {"", "K", "M", "G", "T"};
                                int unitIndex = 0;
                                double fileSize = fileLength;
                                
                                while (fileSize >= 1024 && unitIndex < units.length - 1) {
                                    fileSize /= 1024;
                                    unitIndex++;
                                }
                                
                                if (unitIndex == 0) {
                                    sizeStr = String.valueOf((long)fileSize);
                                } else {
                                    sizeStr = String.format("%.1f%s", fileSize, units[unitIndex]);
                                }
                            }
                            out.print(sizeStr);
                        %></td>
                        <td><%= description %></td>
                    </tr>
                    <%
                                }
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 40px; color: #6c757d;">
                            📭 이 폴더는 비어 있습니다.
                            <br><br>
                            <a href="upload.jsp?path=<%= relativePath %>" style="color: #007bff; text-decoration: none;">
                                📤 첫 번째 파일을 업로드해보세요
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <div class="stats">
                📊 <strong>통계:</strong> 
                폴더 <%= dirCount %>개, 
                파일 <%= fileCount %>개
                <% if (totalSize > 0) { 
                    String totalSizeStr = "";
                    if (totalSize == 0) {
                        totalSizeStr = "0";
                    } else {
                        String[] units = {"", "K", "M", "G", "T"};
                        int unitIndex = 0;
                        double fileSize = totalSize;
                        
                        while (fileSize >= 1024 && unitIndex < units.length - 1) {
                            fileSize /= 1024;
                            unitIndex++;
                        }
                        
                        if (unitIndex == 0) {
                            totalSizeStr = String.valueOf((long)fileSize);
                        } else {
                            totalSizeStr = String.format("%.1f%s", fileSize, units[unitIndex]);
                        }
                    }
                %>
                    (총 용량: <%= totalSizeStr %>B)
                <% } %>
            </div>
        </div>

        <div class="file-footer">
            <p>🔒 보안 파일 서버 | 안전한 파일 공유를 위해 항상 최신 보안을 유지합니다.</p>
            <p>© 2025 File Server. 무단 접근을 금지합니다.</p>
        </div>
    </div>
</main>

<!-- Footer Include -->
<%@ include file="includes/footer.jsp" %>
