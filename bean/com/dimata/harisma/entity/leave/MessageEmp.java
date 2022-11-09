/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.leave;

/**
 *
 * @author mchen
 */
import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class MessageEmp extends Entity {

    private String message = "";
    private Date messageDate = null;
    private long employeeId = 0;
    private long leaveId = 0;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getMessageDate() {
        return messageDate;
    }

    public void setMessageDate(Date messageDate) {
        this.messageDate = messageDate;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the leaveId
     */
    public long getLeaveId() {
        return leaveId;
    }

    /**
     * @param leaveId the leaveId to set
     */
    public void setLeaveId(long leaveId) {
        this.leaveId = leaveId;
    }

}
