/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.log;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.entity.Entity;

public class MessageLog extends Entity {

    private String entityName = "";
    private long entityId = 0;
    private long userId = 0;
    private long logId = 0;
    private int statusLog = 0;

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public long getEntityId() {
        return entityId;
    }

    public void setEntityId(long entityId) {
        this.entityId = entityId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    public long getLogId() {
        return logId;
    }

    public void setLogId(long logId) {
        this.logId = logId;
    }

    public int getStatusLog() {
        return statusLog;
    }

    public void setStatusLog(int statusLog) {
        this.statusLog = statusLog;
    }
}
