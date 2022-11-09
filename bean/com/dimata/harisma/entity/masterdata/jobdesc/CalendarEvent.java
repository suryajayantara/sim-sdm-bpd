/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata.jobdesc;

/**
 *
 * @author Gunadi
 */
import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class CalendarEvent extends Entity {

    private long employeeId = 0;
    private String eventId = "";
    private Date eventDate = null;

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }
}
