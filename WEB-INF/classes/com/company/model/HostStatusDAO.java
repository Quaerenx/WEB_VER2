package com.company.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.company.util.DBConnection;

public class HostStatusDAO {
    
    // 모든 호스트 상태 조회
    public List<HostStatusDTO> getAllHostStatus() {
        List<HostStatusDTO> hostList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT host_name, is_in_use, user_name, start_time, last_updated FROM host_status ORDER BY host_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                HostStatusDTO host = new HostStatusDTO();
                host.setHostName(rs.getString("host_name"));
                host.setInUse(rs.getBoolean("is_in_use"));
                host.setUserName(rs.getString("user_name"));
                
                Timestamp startTs = rs.getTimestamp("start_time");
                if (startTs != null) {
                    host.setStartTime(new Date(startTs.getTime()));
                }
                
                Timestamp lastTs = rs.getTimestamp("last_updated");
                if (lastTs != null) {
                    host.setLastUpdated(new Date(lastTs.getTime()));
                }
                
                hostList.add(host);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return hostList;
    }
    
    // 특정 호스트 상태 조회
    public HostStatusDTO getHostStatus(String hostName) {
        HostStatusDTO host = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT host_name, is_in_use, user_name, start_time, last_updated FROM host_status WHERE host_name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, hostName);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                host = new HostStatusDTO();
                host.setHostName(rs.getString("host_name"));
                host.setInUse(rs.getBoolean("is_in_use"));
                host.setUserName(rs.getString("user_name"));
                
                Timestamp startTs = rs.getTimestamp("start_time");
                if (startTs != null) {
                    host.setStartTime(new Date(startTs.getTime()));
                }
                
                Timestamp lastTs = rs.getTimestamp("last_updated");
                if (lastTs != null) {
                    host.setLastUpdated(new Date(lastTs.getTime()));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return host;
    }
    
    // 호스트 상태 토글 (사용 중 <-> 사용 안함)
    public boolean toggleHostStatus(String hostName, String userName) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // 현재 상태 확인
            HostStatusDTO currentStatus = getHostStatus(hostName);
            if (currentStatus == null) {
                return false;
            }
            
            String sql;
            if (currentStatus.isInUse()) {
                // 현재 사용 중이면 해제
                if (currentStatus.getUserName() != null && currentStatus.getUserName().equals(userName)) {
                    // 같은 사용자가 해제하는 경우
                    sql = "UPDATE host_status SET is_in_use = FALSE, user_name = NULL, start_time = NULL, last_updated = NOW() WHERE host_name = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, hostName);
                } else {
                    // 다른 사용자가 사용 중인 경우 - 변경 불가
                    return false;
                }
            } else {
                // 현재 사용 안함이면 사용 시작
                sql = "UPDATE host_status SET is_in_use = TRUE, user_name = ?, start_time = NOW(), last_updated = NOW() WHERE host_name = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userName);
                pstmt.setString(2, hostName);
            }
            
            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(pstmt, conn);
        }
        
        return success;
    }
    
    // 사용자별 사용 중인 호스트 목록 조회
    public List<HostStatusDTO> getHostsByUser(String userName) {
        List<HostStatusDTO> hostList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT host_name, is_in_use, user_name, start_time, last_updated FROM host_status WHERE user_name = ? AND is_in_use = TRUE";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userName);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                HostStatusDTO host = new HostStatusDTO();
                host.setHostName(rs.getString("host_name"));
                host.setInUse(rs.getBoolean("is_in_use"));
                host.setUserName(rs.getString("user_name"));
                
                Timestamp startTs = rs.getTimestamp("start_time");
                if (startTs != null) {
                    host.setStartTime(new Date(startTs.getTime()));
                }
                
                Timestamp lastTs = rs.getTimestamp("last_updated");
                if (lastTs != null) {
                    host.setLastUpdated(new Date(lastTs.getTime()));
                }
                
                hostList.add(host);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return hostList;
    }
}