/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata.jobdesc;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.utility.service.message.GoogleService;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import java.util.*;

/**
 *
 * @author Gunadi
 */

public class PstCalendarEvent extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CALENDAR_EVENT = "hr_calendar_event";
    public static final int FLD_CALENDAR_EVENT_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_EVENT_ID = 2;
    public static final int FLD_EVENT_DATE = 3;
    public static String[] fieldNames = {
        "CALENDAR_EVENT_ID",
        "EMPLOYEE_ID",
        "EVENT_ID",
        "EVENT_DATE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE
    };

    public PstCalendarEvent() {
    }

    public PstCalendarEvent(int i) throws DBException {
        super(new PstCalendarEvent());
    }

    public PstCalendarEvent(String sOid) throws DBException {
        super(new PstCalendarEvent(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCalendarEvent(long lOid) throws DBException {
        super(new PstCalendarEvent(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_CALENDAR_EVENT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCalendarEvent().getClass().getName();
    }

    public static CalendarEvent fetchExc(long oid) throws DBException {
        try {
            CalendarEvent entCalendarEvent = new CalendarEvent();
            PstCalendarEvent pstCalendarEvent = new PstCalendarEvent(oid);
            entCalendarEvent.setOID(oid);
            entCalendarEvent.setEmployeeId(pstCalendarEvent.getLong(FLD_EMPLOYEE_ID));
            entCalendarEvent.setEventId(pstCalendarEvent.getString(FLD_EVENT_ID));
            entCalendarEvent.setEventDate(pstCalendarEvent.getDate(FLD_EVENT_DATE));
            return entCalendarEvent;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCalendarEvent(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CalendarEvent entCalendarEvent = fetchExc(entity.getOID());
        entity = (Entity) entCalendarEvent;
        return entCalendarEvent.getOID();
    }

    public static synchronized long updateExc(CalendarEvent entCalendarEvent) throws DBException {
        try {
            if (entCalendarEvent.getOID() != 0) {
                PstCalendarEvent pstCalendarEvent = new PstCalendarEvent(entCalendarEvent.getOID());
                pstCalendarEvent.setLong(FLD_EMPLOYEE_ID, entCalendarEvent.getEmployeeId());
                pstCalendarEvent.setString(FLD_EVENT_ID, entCalendarEvent.getEventId());
                pstCalendarEvent.setDate(FLD_EVENT_DATE, entCalendarEvent.getEventDate());
                pstCalendarEvent.update();
                return entCalendarEvent.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCalendarEvent(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CalendarEvent) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCalendarEvent pstCalendarEvent = new PstCalendarEvent(oid);
            pstCalendarEvent.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCalendarEvent(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CalendarEvent entCalendarEvent) throws DBException {
        try {
            PstCalendarEvent pstCalendarEvent = new PstCalendarEvent(0);
            pstCalendarEvent.setLong(FLD_EMPLOYEE_ID, entCalendarEvent.getEmployeeId());
            pstCalendarEvent.setString(FLD_EVENT_ID, entCalendarEvent.getEventId());
            pstCalendarEvent.setDate(FLD_EVENT_DATE, entCalendarEvent.getEventDate());
            pstCalendarEvent.insert();
            entCalendarEvent.setOID(pstCalendarEvent.getLong(FLD_CALENDAR_EVENT_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCalendarEvent(0), DBException.UNKNOWN);
        }
        return entCalendarEvent.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CalendarEvent) entity);
    }

    public static void resultToObject(ResultSet rs, CalendarEvent entCalendarEvent) {
        try {
            entCalendarEvent.setOID(rs.getLong(PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_CALENDAR_EVENT_ID]));
            entCalendarEvent.setEmployeeId(rs.getLong(PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_EMPLOYEE_ID]));
            entCalendarEvent.setEventId(rs.getString(PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_EVENT_ID]));
            entCalendarEvent.setEventDate(rs.getDate(PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_EVENT_DATE]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CALENDAR_EVENT;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                CalendarEvent entCalendarEvent = new CalendarEvent();
                resultToObject(rs, entCalendarEvent);
                lists.add(entCalendarEvent);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static boolean checkOID(long entCalendarEventId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CALENDAR_EVENT + " WHERE "
                    + PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_CALENDAR_EVENT_ID] + " = " + entCalendarEventId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstCalendarEvent.fieldNames[PstCalendarEvent.FLD_CALENDAR_EVENT_ID] + ") FROM " + TBL_CALENDAR_EVENT;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    CalendarEvent entCalendarEvent = (CalendarEvent) list.get(ls);
                    if (oid == entCalendarEvent.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }
        return start;
    }

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
    
    
    public static void addToGoogleCalendar(long jobDescId){
        
        if (jobDescId != 0){
            JobDesc jobDesc = new JobDesc();
            try {
                jobDesc = PstJobDesc.fetchExc(jobDescId);
            } catch (Exception exc){
               System.out.println(exc.toString()); 
            }
            
            try {
                
                int incr = 0;
                if (jobDesc.getRepeatType() == 1){
                    incr = 1;
                } else if (jobDesc.getRepeatType() == 2){
                    incr = 7;
                }
                
                ArrayList<EventAttendee> attendees = new ArrayList<EventAttendee>();
                Event event = new Event();
                com.google.api.services.calendar.Calendar service =null;

                event.setSummary(jobDesc.getJobTitle());
                event.setDescription(jobDesc.getJobDesc());
                
                String whereEmp = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" = "
                        + jobDesc.getPositionId();
                Vector vEmployee = PstEmployee.list(0, 0, whereEmp, "");
                if (vEmployee.size() > 0){
                    for (int i =0; i < vEmployee.size(); i++){
                        Employee employee = (Employee) vEmployee.get(i);
                        if (getEmailDomain(employee.getEmailAddress()).equals("gmail.com")){
                            EventAttendee evAttende = new EventAttendee();
                            evAttende.setId(""+employee.getOID());
                            evAttende.setEmail(employee.getEmailAddress());
                            attendees.add(evAttende);
                        }
                    }
                }
                event.setAttendees(attendees);
                
                if (attendees.size() > 0){
                    do{
                        DateTime start = new DateTime(jobDesc.getStartDatetime().getTime());
                        event.setStart(new EventDateTime().setDateTime(start));
                        DateTime end = new DateTime(jobDesc.getEndDatetime().getTime());
                        event.setEnd(new EventDateTime().setDateTime(end));

                        service = new GoogleService().configure();
                        Event createdEvent = service.events().insert("primary", event).execute();

                        if (!createdEvent.getId().equals("")){
                            CalendarEvent calendarEvent = new CalendarEvent();
                            for (EventAttendee att : attendees){
                                try {
                                    calendarEvent.setEmployeeId(Long.valueOf(att.getId()));
                                    calendarEvent.setEventId(createdEvent.getId());
                                    calendarEvent.setEventDate(jobDesc.getStartDatetime());
                                    long oid = PstCalendarEvent.insertExc(calendarEvent);
                                } catch (Exception exc){
                                    System.out.println(exc.toString());
                                }
                            }
                        }

                        if (jobDesc.getRepeatType() == 1 || jobDesc.getRepeatType() == 2){
                            jobDesc.setStartDatetime(addDate(jobDesc.getStartDatetime(), incr));
                            jobDesc.setEndDatetime(addDate(jobDesc.getEndDatetime(), incr));
                        } else if (jobDesc.getRepeatType() == 3){
                            jobDesc.setStartDatetime(addMonth(jobDesc.getStartDatetime(), 1));
                            jobDesc.setEndDatetime(addMonth(jobDesc.getEndDatetime(), 1));
                        } else if (jobDesc.getRepeatType() == 4){
                            jobDesc.setStartDatetime(addYear(jobDesc.getStartDatetime(), 1));
                            jobDesc.setEndDatetime(addYear(jobDesc.getEndDatetime(), 1));
                        }
                    } while(jobDesc.getRepeatUntilDate().compareTo(jobDesc.getStartDatetime()) >= 0);
                }
                
                
            } catch (Exception exc){
                
            }
            
            
        }
        
    }
    
    public static String getEmailDomain(String someEmail){
        return  someEmail.substring(someEmail.indexOf("@") + 1);
    }
    
    public static java.util.Date addDate(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.DATE, increment);
        dt = c.getTime();
        return dt;
    }
    
    public static java.util.Date addMonth(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.MONTH, increment);
        dt = c.getTime();
        return dt;
    }
    
    public static java.util.Date addYear(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.YEAR, increment);
        dt = c.getTime();
        return dt;
    }
    
}
