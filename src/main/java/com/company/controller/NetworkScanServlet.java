package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.company.model.UserDTO;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// @WebServlet("/networkScan") - web.xml에서 매핑하므로 주석 처리
public class NetworkScanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String BASE_IP = "192.168.40.";
    private static final int TIMEOUT_MS = 3000;
    private static final int THREAD_POOL_SIZE = 25;

    private static final Map<String, ScanSession> scanSessions = new ConcurrentHashMap<>();

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // AJAX 요청인지 확인
        String action = request.getParameter("action");
        boolean isAjaxRequest = "startScan".equals(action) || "getProgress".equals(action);

        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            if (isAjaxRequest) {
                // AJAX 요청인 경우 JSON으로 오류 응답
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

                PrintWriter out = response.getWriter();
                Map<String, Object> errorResult = new HashMap<>();
                errorResult.put("success", false);
                errorResult.put("message", "세션이 만료되었습니다. 다시 로그인해주세요.");
                errorResult.put("sessionExpired", true);

                Gson gson = new Gson();
                out.print(gson.toJson(errorResult));
                out.flush();
                return;
            } else {
                // 일반 요청인 경우 로그인 페이지로 리다이렉트
                response.sendRedirect("login");
                return;
            }
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        request.setAttribute("user", user);

        // AJAX 요청 처리
        if ("startScan".equals(action)) {
            handleStartScan(request, response, session.getId());
            return;
        } else if ("getProgress".equals(action)) {
            handleGetProgress(request, response, session.getId());
            return;
        }

        // 기본 페이지 표시
        request.getRequestDispatcher("/networkScan.jsp").forward(request, response);
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * 스캔 시작 처리
     */
    private void handleStartScan(HttpServletRequest request, HttpServletResponse response, String sessionId)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();

            // 기존 스캔이 진행 중이면 중지
            ScanSession existingSession = scanSessions.get(sessionId);
            if (existingSession != null && existingSession.isRunning()) {
                existingSession.stop();
            }

            // 새 스캔 세션 생성
            ScanSession scanSession = new ScanSession();
            scanSessions.put(sessionId, scanSession);

            // 비동기로 스캔 시작
            CompletableFuture.runAsync(() -> performNetworkScan(scanSession));

            // 시작 응답
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "스캔이 시작되었습니다.");

            out.print(gson.toJson(result));
            out.flush();

        } catch (Exception e) {
            // 예외 발생 시에도 JSON 응답 보장
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "스캔 시작 중 오류가 발생했습니다: " + e.getMessage());

            Gson gson = new Gson();
            out.print(gson.toJson(errorResult));
            out.flush();
        }
    }

    /**
     * 진행상황 조회 처리
     */
    private void handleGetProgress(HttpServletRequest request, HttpServletResponse response, String sessionId)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            ScanSession scanSession = scanSessions.get(sessionId);

            Map<String, Object> result = new HashMap<>();

            if (scanSession != null) {
                result.put("success", true);
                result.put("running", scanSession.isRunning());
                result.put("completed", scanSession.getCompletedCount());
                result.put("total", 254);
                result.put("activeCount", scanSession.getActiveCount());
                result.put("inactiveCount", scanSession.getCompletedCount() - scanSession.getActiveCount());
                result.put("percentage", Math.round((scanSession.getCompletedCount() * 100.0) / 254));
                result.put("hosts", scanSession.getResults());

                // 새로운 결과만 반환하고 마크
                List<HostResult> newResults = scanSession.getNewResults();
                result.put("newHosts", newResults);

                if (!scanSession.isRunning() && scanSession.getCompletedCount() >= 254) {
                    result.put("finished", true);
                    // 완료된 세션 정리
                    scanSessions.remove(sessionId);
                }
            } else {
                result.put("success", false);
                result.put("message", "스캔 세션을 찾을 수 없습니다.");
            }

            out.write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "진행상황 조회 중 오류가 발생했습니다: " + e.getMessage());

            out.write(gson.toJson(errorResult));
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    /**
     * 네트워크 스캔 수행
     */
    private void performNetworkScan(ScanSession scanSession) {
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);
        List<CompletableFuture<Void>> futures = new ArrayList<>();

        scanSession.start();

        // 1부터 254까지 모든 IP 스캔
        for (int i = 1; i <= 254; i++) {
            final int hostNumber = i;

            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                if (!scanSession.isRunning()) {
					return; // 중지된 경우 스킵
				}

                HostResult result = scanSingleHost(hostNumber);
                scanSession.addResult(result);
            }, executor);

            futures.add(future);
        }

        // 모든 스캔 완료 대기
        try {
            CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();
        } catch (Exception e) {
            System.err.println("스캔 완료 대기 중 오류: " + e.getMessage());
        }

        scanSession.complete();
        executor.shutdown();
    }

    /**
     * 단일 호스트 스캔
     */
    private HostResult scanSingleHost(int hostNumber) {
        String ipAddress = BASE_IP + hostNumber;
        HostResult result = new HostResult();
        result.setIpAddress(ipAddress);

        try {
            long startTime = System.currentTimeMillis();
            InetAddress inet = InetAddress.getByName(ipAddress);

            boolean isReachable = inet.isReachable(TIMEOUT_MS);
            long responseTime = System.currentTimeMillis() - startTime;

            result.setActive(isReachable);
            result.setResponseTime(isReachable ? (int)responseTime : -1);
            result.setStatus(isReachable ? "활성" : "비활성");

            if (isReachable) {
                // 호스트명 조회 시도
                try {
                    String hostName = inet.getHostName();
                    if (!hostName.equals(ipAddress)) {
                        result.setHostName(hostName);
                    } else {
                        result.setHostName("-");
                    }
                } catch (Exception e) {
                    result.setHostName("-");
                }
            } else {
                result.setHostName("-");
            }

        } catch (Exception e) {
            result.setActive(false);
            result.setResponseTime(-1);
            result.setStatus("네트워크 오류");
            result.setHostName("-");
        }

        return result;
    }

    /**
     * 스캔 세션 클래스
     */
    private static class ScanSession {
        private volatile boolean running = false;
        private volatile boolean completed = false;
        private final List<HostResult> results = new ArrayList<>();
        private final List<HostResult> newResults = new ArrayList<>(); // 새로운 결과 임시 저장
        private volatile int completedCount = 0;
        private volatile int activeCount = 0;

        public synchronized void start() {
            this.running = true;
            this.completed = false;
            this.results.clear();
            this.newResults.clear();
            this.completedCount = 0;
            this.activeCount = 0;
        }

        public synchronized void stop() {
            this.running = false;
        }

        public synchronized void complete() {
            this.running = false;
            this.completed = true;
        }

        public synchronized void addResult(HostResult result) {
            results.add(result);
            newResults.add(result); // 새로운 결과로 추가
            completedCount++;
            if (result.isActive()) {
                activeCount++;
            }
        }

        public synchronized List<HostResult> getNewResults() {
            List<HostResult> temp = new ArrayList<>(newResults);
            newResults.clear(); // 반환 후 클리어
            return temp;
        }

        public boolean isRunning() { return running; }
        public boolean isCompleted() { return completed; }
        public List<HostResult> getResults() { return new ArrayList<>(results); }
        public int getCompletedCount() { return completedCount; }
        public int getActiveCount() { return activeCount; }
    }

    /**
     * 호스트 스캔 결과를 담는 클래스
     */
    public static class HostResult {
        private String ipAddress;
        private String hostName;
        private boolean isActive;
        private int responseTime;
        private String status;

        // Getter와 Setter
        public String getIpAddress() { return ipAddress; }
        public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

        public String getHostName() { return hostName; }
        public void setHostName(String hostName) { this.hostName = hostName; }

        public boolean isActive() { return isActive; }
        public void setActive(boolean active) { isActive = active; }

        public int getResponseTime() { return responseTime; }
        public void setResponseTime(int responseTime) { this.responseTime = responseTime; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getResponseTimeString() {
            if (responseTime < 0) {
                return "타임아웃";
            } else {
                return responseTime + "ms";
            }
        }
    }
}