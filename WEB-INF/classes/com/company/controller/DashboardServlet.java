package com.company.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.company.model.HostStatusDAO;
import com.company.model.HostStatusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.company.model.UserDTO;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // 로그인되지 않은 사용자는 로그인 페이지로 리다이렉트
            response.sendRedirect("login");
            return;
        }
        
        // 사용자 정보 가져오기
        UserDTO user = (UserDTO) session.getAttribute("user");
        request.setAttribute("user", user);
        
        // 호스트 상태 정보 가져오기
        HostStatusDAO hostDAO = new HostStatusDAO();
        List<HostStatusDTO> hostStatusList = hostDAO.getAllHostStatus();
        request.setAttribute("hostStatusList", hostStatusList);
        
        // 대시보드 메뉴 구성 정보 설정 (카테고리별)
        Map<String, List<MenuItem>> dashboardMenus = new HashMap<>();
        
        // 자료관리 메뉴
        List<MenuItem> archiveMenus = new ArrayList<>();
        archiveMenus.add(new MenuItem("회의록", "meeting?view=list", "fas fa-users"));
        archiveMenus.add(new MenuItem("자료실", "downlist.jsp", "fas fa-file-alt"));
        archiveMenus.add(new MenuItem("트러블슈팅", "troubleshooting?view=list", "fas fa-tools"));
        dashboardMenus.put("자료관리", archiveMenus);
        
        // 고객관리 메뉴
        List<MenuItem> customerMenus = new ArrayList<>();
        customerMenus.add(new MenuItem("고객사 정보", "customers?view=list", "fas fa-address-card"));
        customerMenus.add(new MenuItem("정기점검 이력", "maintenance", "fas fa-clipboard-check"));
        dashboardMenus.put("고객관리", customerMenus);
        
        // 유틸리티 메뉴 추가
        List<MenuItem> utilityMenus = new ArrayList<>();
        utilityMenus.add(new MenuItem("호스트 스캔", "networkScan.jsp", "fas fa-network-wired"));
        dashboardMenus.put("유틸리티", utilityMenus);
        
        // 대시보드 메뉴 구성 정보를 request에 설정
        request.setAttribute("dashboardMenus", dashboardMenus);
        
        // 대시보드 페이지로 포워드
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
    
    // 메뉴 아이템 클래스 (내부 클래스)
    public static class MenuItem {
        private String title;
        private String url;
        private String icon;
        
        public MenuItem(String title, String url, String icon) {
            this.title = title;
            this.url = url;
            this.icon = icon;
        }
        
        public String getTitle() {
            return title;
        }
        
        public String getUrl() {
            return url;
        }
        
        public String getIcon() {
            return icon;
        }
    }
}