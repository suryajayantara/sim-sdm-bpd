/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata.jobdesc;

import com.dimata.harisma.entity.masterdata.jobdesc.CalendarEvent;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Gunadi
 */
public class FrmCalendarEvent extends FRMHandler implements I_FRMInterface, I_FRMType {

    private CalendarEvent entCalendarEvent;
    public static final String FRM_NAME_CALENDAR_EVENT = "FRM_NAME_CALENDAR_EVENT";
    public static final int FRM_FIELD_CALENDAR_EVENT_ID = 0;
    public static final int FRM_FIELD_EMPLOYEE_ID = 1;
    public static final int FRM_FIELD_EVENT_ID = 2;
    public static final int FRM_FIELD_EVENT_DATE = 3;
    public static String[] fieldNames = {
        "FRM_FIELD_CALENDAR_EVENT_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_EVENT_ID",
        "FRM_FIELD_EVENT_DATE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE
    };

    public FrmCalendarEvent() {
    }

    public FrmCalendarEvent(CalendarEvent entCalendarEvent) {
        this.entCalendarEvent = entCalendarEvent;
    }

    public FrmCalendarEvent(HttpServletRequest request, CalendarEvent entCalendarEvent) {
        super(new FrmCalendarEvent(entCalendarEvent), request);
        this.entCalendarEvent = entCalendarEvent;
    }

    public String getFormName() {
        return FRM_NAME_CALENDAR_EVENT;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public CalendarEvent getEntityObject() {
        return entCalendarEvent;
    }

    public void requestEntityObject(CalendarEvent entCalendarEvent) {
        try {
            this.requestParam();
            entCalendarEvent.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entCalendarEvent.setEventId(getString(FRM_FIELD_EVENT_ID));
            entCalendarEvent.setEventDate(getDate(FRM_FIELD_EVENT_DATE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
