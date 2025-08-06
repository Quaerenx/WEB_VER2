package com.company.model;

import java.util.Date;

public class HostStatusDTO {
    private String hostName;
    private boolean isInUse;
    private String userName;
    private Date startTime;
    private Date lastUpdated;
    
    // 기본 생성자
    public HostStatusDTO() {}
    
    // 매개변수 생성자
    public HostStatusDTO(String hostName, boolean isInUse, String userName, Date startTime, Date lastUpdated) {
        this.hostName = hostName;
        this.isInUse = isInUse;
        this.userName = userName;
        this.startTime = startTime;
        this.lastUpdated = lastUpdated;
    }
    
    // Getter/Setter 메소드들
    public String getHostName() {
        return hostName;
    }
    
    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
    
    public boolean isInUse() {
        return isInUse;
    }
    
    public void setInUse(boolean inUse) {
        isInUse = inUse;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public Date getStartTime() {
        return startTime;
    }
    
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }
    
    public Date getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}