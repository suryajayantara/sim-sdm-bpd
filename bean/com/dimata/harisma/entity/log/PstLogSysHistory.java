/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.log;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.leave.I_Leave;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstMappingPosition;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

public class PstLogSysHistory extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_LOG_SYS_HISTORY = "doc_log_history";
    public static final int FLD_LOG_ID = 0;
    public static final int FLD_LOG_DOCUMENT_ID = 1;
    public static final int FLD_LOG_USER_ID = 2;
    public static final int FLD_LOG_LOGIN_NAME = 3;
    public static final int FLD_LOG_DOCUMENT_NUMBER = 4;
    public static final int FLD_LOG_DOCUMENT_TYPE = 5;
    public static final int FLD_LOG_USER_ACTION = 6;
    public static final int FLD_LOG_OPEN_URL = 7;
    public static final int FLD_LOG_UPDATE_DATE = 8;
    public static final int FLD_LOG_APPLICATION = 9;
    public static final int FLD_LOG_DETAIL = 10;
    public static final int FLD_LOG_STATUS = 11;
    public static final int FLD_APPROVER_ID = 12;
    public static final int FLD_APPROVE_DATE = 13;
    public static final int FLD_APPROVER_NOTE = 14;
    public static final int FLD_LOG_PREV = 15;
    public static final int FLD_LOG_CURR = 16;
    public static final int FLD_LOG_MODULE = 17;
    public static final int FLD_LOG_EDITED_EMPLOYEE_ID = 18;
    /* Update by Hendra Putu | 2016-05-17 */
    public static final int FLD_COMPANY_ID = 19;
    public static final int FLD_DIVISION_ID = 20;
    public static final int FLD_DEPARTMENT_ID = 21;
    public static final int FLD_SECTION_ID = 22;
    public static final int FLD_APPROVER_1 = 23;
    public static final int FLD_APPROVER_2 = 24;
    public static final int FLD_APPROVER_3 = 25;
    public static final int FLD_APPROVER_4 = 26;
    public static final int FLD_APPROVER_5 = 27;
    public static final int FLD_APPROVER_6 = 28;
    public static final int FLD_APPROVER_1_DATE = 29;
    public static final int FLD_APPROVER_2_DATE = 30;
    public static final int FLD_APPROVER_3_DATE = 31;
    public static final int FLD_APPROVER_4_DATE = 32;
    public static final int FLD_APPROVER_5_DATE = 33;
    public static final int FLD_APPROVER_6_DATE = 34;
    public static final int FLD_QUERY = 35;
    
    public static String[] fieldNames = {
        "LOG_ID",
        "LOG_DOCUMENT_ID",
        "LOG_USER_ID",
        "LOG_LOGIN_NAME",
        "LOG_DOCUMENT_NUMBER",
        "LOG_DOCUMENT_TYPE",
        "LOG_USER_ACTION",
        "LOG_OPEN_URL",
        "LOG_UPDATE_DATE",
        "LOG_APPLICATION",
        "LOG_DETAIL",
        "LOG_STATUS",
        "APPROVER_ID",
        "APPROVE_DATE",
        "APPROVER_NOTE",
        "LOG_PREV",
        "LOG_CURR",
        "LOG_MODULE",
        "LOG_EDITED_EMPLOYEE_ID",
        "COMPANY_ID",
        "DIVISION_ID",
        "DEPARTMENT_ID",
        "SECTION_ID",
        "APPROVER_1",
        "APPROVER_2",
        "APPROVER_3",
        "APPROVER_4",
        "APPROVER_5",
        "APPROVER_6",
        "APPROVER_1_DATE",
        "APPROVER_2_DATE",
        "APPROVER_3_DATE",
        "APPROVER_4_DATE",
        "APPROVER_5_DATE",
        "APPROVER_6_DATE",
        "QUERY"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING
    };

    public static final int DOCUMENT_STATUS_TO_BE_APPROVED  = 0;
    public static final int DOCUMENT_STATUS_APPROVED         = 1;
    public static final int DOCUMENT_STATUS_DECLINED         = 6;
    
    /**
    * declaration of identifier to explain document status above
    */
    public static final String[] fieldDocumentStatus = {
        "To Be Approved",
        "Approved",
        "",
        "",
        "",
        "",
        "Declined"
    };
    
    public PstLogSysHistory() {
    }

    public PstLogSysHistory(int i) throws DBException {
        super(new PstLogSysHistory());
    }

    public PstLogSysHistory(String sOid) throws DBException {
        super(new PstLogSysHistory(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstLogSysHistory(long lOid) throws DBException {
        super(new PstLogSysHistory(0));
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
        return TBL_LOG_SYS_HISTORY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstLogSysHistory().getClass().getName();
    }

    public static LogSysHistory fetchExc(long oid) throws DBException {
        try {
            LogSysHistory entLogSysHistory = new LogSysHistory();
            PstLogSysHistory pstLogSysHistory = new PstLogSysHistory(oid);
            entLogSysHistory.setOID(oid);
            entLogSysHistory.setLogDocumentId(pstLogSysHistory.getLong(FLD_LOG_DOCUMENT_ID));
            entLogSysHistory.setLogUserId(pstLogSysHistory.getLong(FLD_LOG_USER_ID));
            entLogSysHistory.setLogLoginName(pstLogSysHistory.getString(FLD_LOG_LOGIN_NAME));
            entLogSysHistory.setLogDocumentNumber(pstLogSysHistory.getString(FLD_LOG_DOCUMENT_NUMBER));
            entLogSysHistory.setLogDocumentType(pstLogSysHistory.getString(FLD_LOG_DOCUMENT_TYPE));
            entLogSysHistory.setLogUserAction(pstLogSysHistory.getString(FLD_LOG_USER_ACTION));
            entLogSysHistory.setLogOpenUrl(pstLogSysHistory.getString(FLD_LOG_OPEN_URL));
            entLogSysHistory.setLogUpdateDate(pstLogSysHistory.getDate(FLD_LOG_UPDATE_DATE));
            entLogSysHistory.setLogApplication(pstLogSysHistory.getString(FLD_LOG_APPLICATION));
            entLogSysHistory.setLogDetail(pstLogSysHistory.getString(FLD_LOG_DETAIL));
            entLogSysHistory.setLogStatus(pstLogSysHistory.getInt(FLD_LOG_STATUS));
            entLogSysHistory.setApproverId(pstLogSysHistory.getLong(FLD_APPROVER_ID));
            entLogSysHistory.setApproveDate(pstLogSysHistory.getDate(FLD_APPROVE_DATE));
            entLogSysHistory.setApproverNote(pstLogSysHistory.getString(FLD_APPROVER_NOTE));
            entLogSysHistory.setLogPrev(pstLogSysHistory.getString(FLD_LOG_PREV));
            entLogSysHistory.setLogCurr(pstLogSysHistory.getString(FLD_LOG_CURR));
            entLogSysHistory.setLogModule(pstLogSysHistory.getString(FLD_LOG_MODULE));
            entLogSysHistory.setLogEditedUserId(pstLogSysHistory.getLong(FLD_LOG_EDITED_EMPLOYEE_ID));
            entLogSysHistory.setCompanyId(pstLogSysHistory.getLong(FLD_COMPANY_ID));
            entLogSysHistory.setDivisionId(pstLogSysHistory.getLong(FLD_DIVISION_ID));
            entLogSysHistory.setDepartmentId(pstLogSysHistory.getLong(FLD_DEPARTMENT_ID));
            entLogSysHistory.setSectionId(pstLogSysHistory.getLong(FLD_SECTION_ID));
            entLogSysHistory.setApprover1(pstLogSysHistory.getLong(FLD_APPROVER_1));
            entLogSysHistory.setApprover2(pstLogSysHistory.getLong(FLD_APPROVER_2));
            entLogSysHistory.setApprover3(pstLogSysHistory.getLong(FLD_APPROVER_3));
            entLogSysHistory.setApprover4(pstLogSysHistory.getLong(FLD_APPROVER_4));
            entLogSysHistory.setApprover5(pstLogSysHistory.getLong(FLD_APPROVER_5));
            entLogSysHistory.setApprover6(pstLogSysHistory.getLong(FLD_APPROVER_6));
            entLogSysHistory.setApprove1Date(pstLogSysHistory.getDate(FLD_APPROVER_1_DATE));
            entLogSysHistory.setApprove2Date(pstLogSysHistory.getDate(FLD_APPROVER_2_DATE));
            entLogSysHistory.setApprove3Date(pstLogSysHistory.getDate(FLD_APPROVER_3_DATE));
            entLogSysHistory.setApprove4Date(pstLogSysHistory.getDate(FLD_APPROVER_4_DATE));
            entLogSysHistory.setApprove5Date(pstLogSysHistory.getDate(FLD_APPROVER_5_DATE));
            entLogSysHistory.setApprove6Date(pstLogSysHistory.getDate(FLD_APPROVER_6_DATE));
            entLogSysHistory.setQuery(pstLogSysHistory.getString(FLD_QUERY));
            
            return entLogSysHistory;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLogSysHistory(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        LogSysHistory entLogSysHistory = fetchExc(entity.getOID());
        entity = (Entity) entLogSysHistory;
        return entLogSysHistory.getOID();
    }

    public static synchronized long updateExc(LogSysHistory entLogSysHistory) throws DBException {
        try {
            if (entLogSysHistory.getOID() != 0) {
                PstLogSysHistory pstLogSysHistory = new PstLogSysHistory(entLogSysHistory.getOID());
                pstLogSysHistory.setLong(FLD_LOG_DOCUMENT_ID, entLogSysHistory.getLogDocumentId());
                pstLogSysHistory.setLong(FLD_LOG_USER_ID, entLogSysHistory.getLogUserId());
                pstLogSysHistory.setString(FLD_LOG_LOGIN_NAME, entLogSysHistory.getLogLoginName());
                pstLogSysHistory.setString(FLD_LOG_DOCUMENT_NUMBER, entLogSysHistory.getLogDocumentNumber());
                pstLogSysHistory.setString(FLD_LOG_DOCUMENT_TYPE, entLogSysHistory.getLogDocumentType());
                pstLogSysHistory.setString(FLD_LOG_USER_ACTION, entLogSysHistory.getLogUserAction());
                pstLogSysHistory.setString(FLD_LOG_OPEN_URL, entLogSysHistory.getLogOpenUrl());
                pstLogSysHistory.setDate(FLD_LOG_UPDATE_DATE, entLogSysHistory.getLogUpdateDate());
                pstLogSysHistory.setString(FLD_LOG_APPLICATION, entLogSysHistory.getLogApplication());
                pstLogSysHistory.setString(FLD_LOG_DETAIL, entLogSysHistory.getLogDetail());
                pstLogSysHistory.setInt(FLD_LOG_STATUS, entLogSysHistory.getLogStatus());
                pstLogSysHistory.setLong(FLD_APPROVER_ID, entLogSysHistory.getApproverId());
                pstLogSysHistory.setDate(FLD_APPROVE_DATE, entLogSysHistory.getApproveDate());
                pstLogSysHistory.setString(FLD_APPROVER_NOTE, entLogSysHistory.getApproverNote());
                pstLogSysHistory.setString(FLD_LOG_PREV, entLogSysHistory.getLogPrev());
                pstLogSysHistory.setString(FLD_LOG_CURR, entLogSysHistory.getLogCurr());
                pstLogSysHistory.setString(FLD_LOG_MODULE, entLogSysHistory.getLogModule());
                pstLogSysHistory.setLong(FLD_LOG_EDITED_EMPLOYEE_ID, entLogSysHistory.getLogEditedUserId());
                pstLogSysHistory.setLong(FLD_COMPANY_ID, entLogSysHistory.getCompanyId());
                pstLogSysHistory.setLong(FLD_DIVISION_ID, entLogSysHistory.getDivisionId());
                pstLogSysHistory.setLong(FLD_DEPARTMENT_ID, entLogSysHistory.getDepartmentId());
                pstLogSysHistory.setLong(FLD_SECTION_ID, entLogSysHistory.getSectionId());
                pstLogSysHistory.setLong(FLD_APPROVER_1, entLogSysHistory.getApprover1());
                pstLogSysHistory.setLong(FLD_APPROVER_2, entLogSysHistory.getApprover2());
                pstLogSysHistory.setLong(FLD_APPROVER_3, entLogSysHistory.getApprover3());
                pstLogSysHistory.setLong(FLD_APPROVER_4, entLogSysHistory.getApprover4());
                pstLogSysHistory.setLong(FLD_APPROVER_5, entLogSysHistory.getApprover5());
                pstLogSysHistory.setLong(FLD_APPROVER_6, entLogSysHistory.getApprover6());
                pstLogSysHistory.setDate(FLD_APPROVER_1_DATE, entLogSysHistory.getApprove1Date());
                pstLogSysHistory.setDate(FLD_APPROVER_2_DATE, entLogSysHistory.getApprove2Date());
                pstLogSysHistory.setDate(FLD_APPROVER_3_DATE, entLogSysHistory.getApprove3Date());
                pstLogSysHistory.setDate(FLD_APPROVER_4_DATE, entLogSysHistory.getApprove4Date());
                pstLogSysHistory.setDate(FLD_APPROVER_5_DATE, entLogSysHistory.getApprove5Date());
                pstLogSysHistory.setDate(FLD_APPROVER_6_DATE, entLogSysHistory.getApprove6Date());
                pstLogSysHistory.setString(FLD_QUERY, entLogSysHistory.getQuery());
                pstLogSysHistory.update();
                return entLogSysHistory.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLogSysHistory(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((LogSysHistory) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstLogSysHistory pstLogSysHistory = new PstLogSysHistory(oid);
            pstLogSysHistory.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLogSysHistory(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(LogSysHistory entLogSysHistory) throws DBException {
        try {
            PstLogSysHistory pstLogSysHistory = new PstLogSysHistory(0);
            pstLogSysHistory.setLong(FLD_LOG_DOCUMENT_ID, entLogSysHistory.getLogDocumentId());
            pstLogSysHistory.setLong(FLD_LOG_USER_ID, entLogSysHistory.getLogUserId());
            pstLogSysHistory.setString(FLD_LOG_LOGIN_NAME, entLogSysHistory.getLogLoginName());
            pstLogSysHistory.setString(FLD_LOG_DOCUMENT_NUMBER, entLogSysHistory.getLogDocumentNumber());
            pstLogSysHistory.setString(FLD_LOG_DOCUMENT_TYPE, entLogSysHistory.getLogDocumentType());
            pstLogSysHistory.setString(FLD_LOG_USER_ACTION, entLogSysHistory.getLogUserAction());
            pstLogSysHistory.setString(FLD_LOG_OPEN_URL, entLogSysHistory.getLogOpenUrl());
            pstLogSysHistory.setDate(FLD_LOG_UPDATE_DATE, entLogSysHistory.getLogUpdateDate());
            pstLogSysHistory.setString(FLD_LOG_APPLICATION, entLogSysHistory.getLogApplication());
            pstLogSysHistory.setString(FLD_LOG_DETAIL, entLogSysHistory.getLogDetail());
            pstLogSysHistory.setInt(FLD_LOG_STATUS, entLogSysHistory.getLogStatus());
            pstLogSysHistory.setLong(FLD_APPROVER_ID, entLogSysHistory.getApproverId());
            pstLogSysHistory.setDate(FLD_APPROVE_DATE, entLogSysHistory.getApproveDate());
            pstLogSysHistory.setString(FLD_APPROVER_NOTE, entLogSysHistory.getApproverNote());
            pstLogSysHistory.setString(FLD_LOG_PREV, entLogSysHistory.getLogPrev());
            pstLogSysHistory.setString(FLD_LOG_CURR, entLogSysHistory.getLogCurr());
            pstLogSysHistory.setString(FLD_LOG_MODULE, entLogSysHistory.getLogModule());
            pstLogSysHistory.setLong(FLD_LOG_EDITED_EMPLOYEE_ID, entLogSysHistory.getLogEditedUserId());
            pstLogSysHistory.setLong(FLD_COMPANY_ID, entLogSysHistory.getCompanyId());
            pstLogSysHistory.setLong(FLD_DIVISION_ID, entLogSysHistory.getDivisionId());
            pstLogSysHistory.setLong(FLD_DEPARTMENT_ID, entLogSysHistory.getDepartmentId());
            pstLogSysHistory.setLong(FLD_SECTION_ID, entLogSysHistory.getSectionId());
            pstLogSysHistory.setLong(FLD_APPROVER_1, entLogSysHistory.getApprover1());
            pstLogSysHistory.setLong(FLD_APPROVER_2, entLogSysHistory.getApprover2());
            pstLogSysHistory.setLong(FLD_APPROVER_3, entLogSysHistory.getApprover3());
            pstLogSysHistory.setLong(FLD_APPROVER_4, entLogSysHistory.getApprover4());
            pstLogSysHistory.setLong(FLD_APPROVER_5, entLogSysHistory.getApprover5());
            pstLogSysHistory.setLong(FLD_APPROVER_6, entLogSysHistory.getApprover6());
            pstLogSysHistory.setDate(FLD_APPROVER_1_DATE, entLogSysHistory.getApprove1Date());
            pstLogSysHistory.setDate(FLD_APPROVER_2_DATE, entLogSysHistory.getApprove2Date());
            pstLogSysHistory.setDate(FLD_APPROVER_3_DATE, entLogSysHistory.getApprove3Date());
            pstLogSysHistory.setDate(FLD_APPROVER_4_DATE, entLogSysHistory.getApprove4Date());
            pstLogSysHistory.setDate(FLD_APPROVER_5_DATE, entLogSysHistory.getApprove5Date());
            pstLogSysHistory.setDate(FLD_APPROVER_6_DATE, entLogSysHistory.getApprove6Date());
            pstLogSysHistory.setString(FLD_QUERY, entLogSysHistory.getQuery());
            pstLogSysHistory.insert();
            entLogSysHistory.setOID(pstLogSysHistory.getLong(FLD_LOG_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLogSysHistory(0), DBException.UNKNOWN);
        }
        return entLogSysHistory.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((LogSysHistory) entity);
    }

    public static void resultToObject(ResultSet rs, LogSysHistory entLogSysHistory) {
        try {
            entLogSysHistory.setOID(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID]));
            entLogSysHistory.setLogDocumentId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_ID]));
            entLogSysHistory.setLogUserId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ID]));
            entLogSysHistory.setLogLoginName(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME]));
            entLogSysHistory.setLogDocumentNumber(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_NUMBER]));
            entLogSysHistory.setLogDocumentType(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_TYPE]));
            entLogSysHistory.setLogUserAction(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ACTION]));
            entLogSysHistory.setLogOpenUrl(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_OPEN_URL]));
            entLogSysHistory.setLogUpdateDate(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE]));
            entLogSysHistory.setLogApplication(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_APPLICATION]));
            entLogSysHistory.setLogDetail(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DETAIL]));
            entLogSysHistory.setLogStatus(rs.getInt(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]));
            entLogSysHistory.setApproverId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_ID]));
            entLogSysHistory.setApproveDate(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVE_DATE]));
            entLogSysHistory.setApproverNote(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_NOTE]));
            entLogSysHistory.setLogPrev(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_PREV]));
            entLogSysHistory.setLogCurr(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_CURR]));
            entLogSysHistory.setLogModule(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_MODULE]));
            entLogSysHistory.setLogEditedUserId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_EDITED_EMPLOYEE_ID]));
            entLogSysHistory.setCompanyId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_COMPANY_ID]));
            entLogSysHistory.setDivisionId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_DIVISION_ID]));
            entLogSysHistory.setDepartmentId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_DEPARTMENT_ID]));
            entLogSysHistory.setSectionId(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_SECTION_ID]));
            entLogSysHistory.setApprover1(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_1]));
            entLogSysHistory.setApprover2(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_2]));
            entLogSysHistory.setApprover3(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_3]));
            entLogSysHistory.setApprover4(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_4]));
            entLogSysHistory.setApprover5(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_5]));
            entLogSysHistory.setApprover6(rs.getLong(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_6]));
            entLogSysHistory.setApprove1Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_1_DATE]));
            entLogSysHistory.setApprove2Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_2_DATE]));
            entLogSysHistory.setApprove3Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_3_DATE]));
            entLogSysHistory.setApprove4Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_4_DATE]));
            entLogSysHistory.setApprove5Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_5_DATE]));
            entLogSysHistory.setApprove6Date(rs.getDate(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_6_DATE]));
            entLogSysHistory.setQuery(rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]));
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
            String sql = "SELECT * FROM " + TBL_LOG_SYS_HISTORY;
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
                LogSysHistory entLogSysHistory = new LogSysHistory();
                resultToObject(rs, entLogSysHistory);
                lists.add(entLogSysHistory);
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

    public static Vector listModule(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT LOG_MODULE FROM " + TBL_LOG_SYS_HISTORY;
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
                lists.add(rs.getString(1));
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
    
    public static boolean checkOID(long entLogSysHistoryId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_LOG_SYS_HISTORY + " WHERE "
                    + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID] + " = " + entLogSysHistoryId;
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
            String sql = "SELECT COUNT(" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID] + ") FROM " + TBL_LOG_SYS_HISTORY;
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
                    LogSysHistory entLogSysHistory = (LogSysHistory) list.get(ls);
                    if (oid == entLogSysHistory.getOID()) {
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
    
    public static String parsingData(String data){
        String str = "";
        str = data.replaceAll(";", "<br>");
        return str;
    }
    
    public static Vector<String> parsingDataVersi2(String data){
        Vector<String> vdata = new Vector();
        for (String retval : data.split(";")) {
            vdata.add(retval);
        }
        return vdata;
    }
    
    /* 
     * Approve Function Log Sys History 
     * Just Update Status, Approve id, Approve Date, Approve Note
     * Status = Final (Approved)
     */
    public static int approveLog(long approveId, String approveDate, String approveNote, long oid){
        int statusUpdate = 0;
        try {
            String query = "";
            query  = " UPDATE "+TBL_LOG_SYS_HISTORY;
            query += " SET "+fieldNames[FLD_LOG_STATUS]+"="+I_DocStatus.DOCUMENT_STATUS_FINAL+", ";
            query += " "+fieldNames[FLD_APPROVER_ID]+"="+approveId+", ";
            query += " "+fieldNames[FLD_APPROVE_DATE]+"='"+approveDate+"', ";
            query += " "+fieldNames[FLD_APPROVER_NOTE]+"='"+approveNote+"' ";
            query += " WHERE "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID]+"="+oid;
            statusUpdate = DBHandler.updateParsial(query);
        } catch(Exception e){
            System.out.println("update status di logSysHistory=>"+e.toString());
        }
        return statusUpdate;
    }
    
    /* 
     * Not Approve Function Log Sys History 
     * Just Update Status, Approve id, Approve Date, Approve Note
     * Status = Final (Approved)
     */
    public static int notApproveLog(long approveId, String approveDate, String approveNote, long oid){
        int statusUpdate = 0;
        try {
            String query = "";
            query  = " UPDATE "+TBL_LOG_SYS_HISTORY;
            query += " SET "+fieldNames[FLD_LOG_STATUS]+"="+I_DocStatus.DOCUMENT_STATUS_CANCELLED+", ";
            query += " "+fieldNames[FLD_APPROVER_ID]+"="+approveId+", ";
            query += " "+fieldNames[FLD_APPROVE_DATE]+"='"+approveDate+"', ";
            query += " "+fieldNames[FLD_APPROVER_NOTE]+"='"+approveNote+"' ";
            query += " WHERE "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID]+"="+oid;
            statusUpdate = DBHandler.updateParsial(query);
            
            /* Rolling back data */
            /* ambil data detail log, dimana memuat field, value, dan entity */
            LogSysHistory data = PstLogSysHistory.fetchExc(oid);
            String field = data.getLogDetail();
            String prev = data.getLogPrev();
            Vector vField = parsingDataVersi2(field);
            Vector vPrev = parsingDataVersi2(prev);
            String fieldKey = "";
            String valKey = "";
            /* ADD condition, jika kondisi ADD maka jika not approve, maka lakukan DELETE Data */
            if (data.getLogUserAction().equals("ADD")){
                fieldKey = (String)vField.get(0);
                valKey = (String)vPrev.get(0);
                query  = " DELETE FROM "+data.getLogDocumentType();
                query += " WHERE "+ fieldKey +"="+valKey;
                DBHandler.updateParsial(query);
            }
            /* EDIT condition */
            if (data.getLogUserAction().equals("EDIT")){
                query = "UPDATE "+data.getLogDocumentType()+" SET ";
                if (vField != null && vField.size()>0){
                    for(int i=1; i<vField.size(); i++){
                        String dataField = (String)vField.get(i);
                        String dataPrev = (String)vPrev.get(i);
                        query += " "+dataField+"="+dataPrev+"";
                        if (i <(vField.size()-1)){
                            query += ", ";
                        }
                    }
                     fieldKey = (String)vField.get(0);
                     valKey = (String)vPrev.get(0);
                }
                query += " WHERE "+ fieldKey +"="+valKey;
                DBHandler.updateParsial(query);
            }
            /* DELETE condition, jika dilakukan not approve maka lakukan ADD data */
            if (data.getLogUserAction().equals("DELETE")){
                query = "INSERT INTO "+data.getLogDocumentType()+" (";
                if (vField != null && vField.size()>0){
                    for(int i=0; i<vField.size(); i++){
                        String dataField = (String)vField.get(i);
                        query += " "+dataField;
                        if (i <(vField.size()-1)){
                            query += ", ";
                        }
                    }
                    query += ") VALUES (";
                    for(int i=0; i<vField.size(); i++){
                        String dataPrev = (String)vPrev.get(i);
                        query += " "+dataPrev;
                        if (i <(vField.size()-1)){
                            query += ", ";
                        }
                    }
                    query += ")";
                }
                DBHandler.updateParsial(query);
            }
            
        } catch(Exception e){
            System.out.println("update status di logSysHistory=>"+e.toString());
        }
        return statusUpdate;
    }
    
    public static Vector getListDataChangeNotification(long userLogin, long divisionId){
        Vector listData = new Vector();
        Employee emp = new Employee();
        String whereNotif = fieldNames[FLD_LOG_STATUS] +" = "+DOCUMENT_STATUS_TO_BE_APPROVED+" AND "
                + fieldNames[FLD_QUERY]+" IS NOT NULL AND "+fieldNames[FLD_QUERY]+" != ''";
        Vector listLogHistory = PstLogSysHistory.list(0, 0, whereNotif, "");
        int maxApproval = 0;
        boolean needHrApproval = true;
        if (listLogHistory.size()>0){
            for (int x=0; x < listLogHistory.size(); x++){
                LogSysHistory logSysHistory = (LogSysHistory) listLogHistory.get(x);
                try {
                    AppUser appUser = PstAppUser.fetch(logSysHistory.getLogUserId());
                    emp = PstEmployee.fetchExc(appUser.getEmployeeId());
                } catch (Exception exc){}
                
                Position pos = new Position();
                Level level = new Level();
                Level maxLevelObj = new Level();
                //Level level = new Level();
                
                try {
                    pos = PstPosition.fetchExc(emp.getPositionId());            
                } catch (Exception exc){

                }
                
                 try {
                     level = PstLevel.fetchExc(pos.getLevelId());
                 } catch (Exception e) {
                 }


                 try {
                     maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                 } catch (Exception e) {
                 }

                 maxApproval = maxLevelObj.getLevelPoint();
                
                 long oidEmp = 0;
                 if (logSysHistory.getApprover1() == 0){
                     oidEmp = emp.getOID();
                 } else if (logSysHistory.getApprover2() == 0){
                     oidEmp = logSysHistory.getApprover1();
                 } else if (logSysHistory.getApprover3() == 0){
                     oidEmp = logSysHistory.getApprover2();
                 } else if (logSysHistory.getApprover4() == 0){
                     oidEmp = logSysHistory.getApprover3();
                 } else if (logSysHistory.getApprover5() == 0){
                     oidEmp = logSysHistory.getApprover4();
                 } else if (logSysHistory.getApprover6() == 0){
                     oidEmp = logSysHistory.getApprover5();
                 }
                 int approval = getApproval(oidEmp, userLogin, divisionId, maxApproval, emp.getDivisionId());
                 if (approval > 0){
                     listData.add(logSysHistory);
                 }
            }
        }
        
        return listData;
    }
    
    public static int getDataChangeNotification(long userLogin, long divisionId){
        int count = 0;
        Employee emp = new Employee();
        String whereNotif = fieldNames[FLD_LOG_STATUS] +" = "+DOCUMENT_STATUS_TO_BE_APPROVED+" AND "
                + fieldNames[FLD_QUERY]+" IS NOT NULL AND "+fieldNames[FLD_QUERY]+" != ''";
        Vector listLogHistory = PstLogSysHistory.list(0, 0, whereNotif, "");
        int maxApproval = 0;
        boolean needHrApproval = true;
        if (listLogHistory.size()>0){
            for (int x=0; x < listLogHistory.size(); x++){
                LogSysHistory logSysHistory = (LogSysHistory) listLogHistory.get(x);
                try {
                    AppUser appUser = PstAppUser.fetch(logSysHistory.getLogUserId());
                    emp = PstEmployee.fetchExc(appUser.getEmployeeId());
                } catch (Exception exc){}
                
                Position pos = new Position();
                Level level = new Level();
                Level maxLevelObj = new Level();
                //Level level = new Level();
                
                try {
                    pos = PstPosition.fetchExc(emp.getPositionId());            
                } catch (Exception exc){

                }
                
                 try {
                     level = PstLevel.fetchExc(pos.getLevelId());
                 } catch (Exception e) {
                 }


                 try {
                     maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                 } catch (Exception e) {
                 }

                 maxApproval = maxLevelObj.getLevelPoint();
                
                 long oidEmp = 0;
                 if (logSysHistory.getApprover1() == 0){
                     oidEmp = emp.getOID();
                 } else if (logSysHistory.getApprover2() == 0){
                     oidEmp = logSysHistory.getApprover1();
                 } else if (logSysHistory.getApprover3() == 0){
                     oidEmp = logSysHistory.getApprover2();
                 } else if (logSysHistory.getApprover4() == 0){
                     oidEmp = logSysHistory.getApprover3();
                 } else if (logSysHistory.getApprover5() == 0){
                     oidEmp = logSysHistory.getApprover4();
                 } else if (logSysHistory.getApprover6() == 0){
                     oidEmp = logSysHistory.getApprover5();
                 }
                 count = count + getApproval(oidEmp, userLogin, divisionId, maxApproval, emp.getDivisionId());
            }
        }
        
        return count;
    }
    
    public static int getApproval(long empId, long userLoggin, long divisionId, int maxApproval, long empDivisionId){
        int nilai = 0;
        Vector listEmployeeDivisionTopLink = new Vector();
        long oidDireksi = 0;
        long oidKomisaris = 0;
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));      
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));

        } catch (Exception exc){
                oidKomisaris = 0;
        }
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(com.dimata.system.entity.system.PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
        
        if (empId != 0){
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = PstLeaveApplication.getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
            
                String posId = PstLeaveApplication.getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId,empDivisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(posId, empDivisionId);
                long employeeId = PstLeaveApplication.getEmpIdByPositionId(upPosId, employee.getDivisionId());
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                     }
                }
                else if (!(upPosId.equals(""))){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);                
                     }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i=0; i < listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                        if (empApprovalStatus == 1){
                            int lvlEmpUp = PstLeaveApplication.getLevelPoint(emp.getPositionId());
                            Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3,empDivisionId);
                            if (listEmpReplacement.size() > 0){
                                for (int x=0; x < listEmpReplacement.size(); x ++){
                                    emp = (Employee) listEmpReplacement.get(x);
                                    if (emp.getOID() == userLoggin){
                                        break;
                                    }
                                    
                                }
                            } else if (listEmployeeDivisionTopLink.size() == 1){
                                nilai = getApproval(emp.getOID(), userLoggin, divisionId, maxApproval, empDivisionId);
                                break;
                            }
                        }
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            nilai = 0;
                        } else{
                            /* Jika employeeId == useLoggin */
                            nilai = 1;
                            break;
                        }
                    }

                } else {
                    /* jika up position ada (top link) dan employee == 0*/
                    String upPosIdReplacement = PstLeaveApplication.getUpPositionIdReplacement(upPosId,empDivisionId);
                    if (upPosIdReplacement.equals("")){
                        upPosId = getUpPositionId(upPosId,empDivisionId);
                        upPosByDivisionId = getUpPositionByDivisionId(upPosId, empDivisionId);
                        if (!upPosId.equals("")){
                            if (!upPosByDivisionId.equals("")){
                                listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0); 
                            } else {
                                listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0); 
                            }
                        }
                    } else {
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosIdReplacement+")" , "", 0,0, 0);     
                    }
                    employeeId = PstLeaveApplication.getEmpIdByPositionId(upPosId, divisionId);
                    if (listEmployeeDivisionTopLink.size() > 0){
                        for (int i=0; i < listEmployeeDivisionTopLink.size(); i++){
                            Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                            int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                            if (empApprovalStatus == 1){
                                int lvlEmpUp = PstLeaveApplication.getLevelPoint(emp.getPositionId());
                                Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3,empDivisionId);
                                if (listEmpReplacement.size() > 0){
                                    for (int x=0; x < listEmpReplacement.size(); x ++){
                                        emp = (Employee) listEmpReplacement.get(x);
                                        if (emp.getOID() == userLoggin){
                                            break;
                                        }

                                    }
                                } else if (listEmployeeDivisionTopLink.size() == 1){
                                    nilai = getApproval(emp.getOID(), userLoggin, divisionId, maxApproval, empDivisionId);
                                    break;
                                }
                            }
                            if (emp.getOID() != userLoggin){
                                //getApproval(employeeId, loop, leaveAppId, userLoggin);
                                nilai = 0;
                            } else{
                                /* Jika employeeId == useLoggin */
                                nilai = 1;
                                break;
                            }
                        }

                    } else if (hr_department != employee.getDepartmentId()){
                        Vector listHRMan = leaveConfig.listSDMApproval(empId);
                        if (listHRMan != null && listHRMan.size() > 0) {
                            for (int i = 0; i < listHRMan.size(); i++) {
                                Employee objEmp = (Employee) listHRMan.get(i);
                                if (objEmp.getOID() == userLoggin){
                                    nilai = 1;
                                    break;
                                }
                            }
                        }
                    }
                }
            } else if (hr_department != employee.getDepartmentId()){
                Vector listHRMan = leaveConfig.listSDMApproval(empId);
                if (listHRMan != null && listHRMan.size() > 0) {
                    for (int i = 0; i < listHRMan.size(); i++) {
                        Employee objEmp = (Employee) listHRMan.get(i);
                        if (objEmp.getOID() == userLoggin){
                            nilai = 1;
                            break;
                        }
                    }
                }
            }
        }
        
        return nilai;
    }
    
    public static String getUpPositionId(String positionId, long divisionId) {
        String upPositionId = "";
        if (positionId.length()==0){
            return "";
        }
        DBResultSet dbrs = null;
        Date dtNow = new Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=14 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
 +                 " BETWEEN START_DATE AND END_DATE "
                    + " AND (DIVISION_ID =0 OR DIVISION_ID="+divisionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
    
    public static String getUpPositionByDivisionId(String positionId, long divisionId) {
        String upPositionId = "";
        if (positionId.length()==0){
            return "";
        }
        DBResultSet dbrs = null;
        Date dtNow = new Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=14 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
                    + " BETWEEN START_DATE AND END_DATE "
                    + " AND DIVISION_ID="+divisionId+"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
    
}

    