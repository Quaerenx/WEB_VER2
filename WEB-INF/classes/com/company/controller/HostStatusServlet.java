package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.company.model.HostStatusDAO;
import com.company.model.HostStatusDTO;
import com.company.model.UserDTO;

@WebServlet("/hostStatus")
public class HostStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = request.getParameter("action");
        if ("getStatus".equals(action)) {
            handleGetStatus(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = request.getParameter("action");
        if ("toggle".equals(action)) {
            handleToggle(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    // 모든 호스트 상태 조회 (AJAX)
    private void handleGetStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            HostStatusDAO hostDAO = new HostStatusDAO();
            List<HostStatusDTO> hostList = hostDAO.getAllHostStatus();
            
            // JSON 수동 생성
            StringBuilder json = new StringBuilder();
            json.append("{\"hosts\":[");
            
            boolean first = true;
            for (HostStatusDTO host : hostList) {
                if (!first) json.append(",");
                
                json.append("{");
                json.append("\"hostName\":").append(jsonString(host.getHostName())).append(",");
                json.append("\"isInUse\":").append(host.isInUse()).append(",");
                json.append("\"userName\":").append(jsonString(host.getUserName())).append(",");
                json.append("\"startTime\":").append(jsonString(formatDateTime(host.getStartTime()))).append(",");
                json.append("\"lastUpdated\":").append(jsonString(formatDateTime(host.getLastUpdated())));
                json.append("}");
                
                first = false;
            }
            
            json.append("]}");
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"상태 조회 중 오류가 발생했습니다.\"}");
        }
        
        out.flush();
    }
    
    // 호스트 상태 토글 (AJAX)
    private void handleToggle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("user");
            
            String hostName = request.getParameter("hostName");
            if (hostName == null || hostName.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"호스트명이 필요합니다.\"}");
                return;
            }
            
            HostStatusDAO hostDAO = new HostStatusDAO();
            
            // 현재 상태 확인
            HostStatusDTO currentStatus = hostDAO.getHostStatus(hostName);
            if (currentStatus == null) {
                out.print("{\"success\":false,\"message\":\"존재하지 않는 호스트입니다.\"}");
                return;
            }
            
            // 다른 사용자가 사용 중인지 확인
            if (currentStatus.isInUse() && 
                currentStatus.getUserName() != null && 
                !currentStatus.getUserName().equals(user.getUserName())) {
                out.print("{\"success\":false,\"message\":\"다른 사용자(" + currentStatus.getUserName() + ")가 사용 중입니다.\"}");
                return;
            }
            
            boolean success = hostDAO.toggleHostStatus(hostName, user.getUserName());
            
            if (success) {
                // 변경 후 새로운 상태 조회
                HostStatusDTO newStatus = hostDAO.getHostStatus(hostName);
                
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"success\":true,");
                json.append("\"hostName\":").append(jsonString(newStatus.getHostName())).append(",");
                json.append("\"isInUse\":").append(newStatus.isInUse()).append(",");
                json.append("\"userName\":").append(jsonString(newStatus.getUserName())).append(",");
                json.append("\"startTime\":").append(jsonString(formatDateTime(newStatus.getStartTime()))).append(",");
                json.append("\"lastUpdated\":").append(jsonString(formatDateTime(newStatus.getLastUpdated()))).append(",");
                
                if (newStatus.isInUse()) {
                    json.append("\"message\":\"").append(hostName).append(" 사용을 시작했습니다.\"");
                } else {
                    json.append("\"message\":\"").append(hostName).append(" 사용을 완료했습니다.\"");
                }
                
                json.append("}");
                out.print(json.toString());
            } else {
                out.print("{\"success\":false,\"message\":\"상태 변경에 실패했습니다.\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"오류가 발생했습니다: " + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    // JSON 문자열 생성 도우미 메소드
    private String jsonString(String value) {
        if (value == null) {
            return "null";
        }
        // JSON 특수문자 이스케이프
        String escaped = value.replace("\\", "\\\\")
                              .replace("\"", "\\\"")
                              .replace("\n", "\\n")
                              .replace("\r", "\\r")
                              .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }
    
    // 날짜/시간 포맷팅
    private String formatDateTime(java.util.Date date) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }
}