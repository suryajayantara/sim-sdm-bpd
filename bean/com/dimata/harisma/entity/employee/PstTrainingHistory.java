
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...]
 * *****************************************************************
 */
package com.dimata.harisma.entity.employee;

/* package java */
import com.dimata.harisma.entity.masterdata.GradeLevel;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstGradeLevel;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstTrainType;
import com.dimata.harisma.entity.masterdata.PstTraining;
import com.dimata.harisma.entity.masterdata.TrainType;
import com.dimata.harisma.entity.masterdata.Training;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;

public class PstTrainingHistory extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_TRAINING_HISTORY = "hr_training_history";
    public static final int FLD_TRAINING_HISTORY_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_TRAINING_PROGRAM = 2;
    public static final int FLD_START_DATE = 3;
    public static final int FLD_END_DATE = 4;
    public static final int FLD_TRAINER = 5;
    public static final int FLD_REMARK = 6;
    public static final int FLD_TRAINING_ID = 7;
    public static final int FLD_DURATION = 8;
    public static final int FLD_PRESENCE = 9;
    public static final int FLD_START_TIME = 10;
    public static final int FLD_END_TIME = 11;
    public static final int FLD_TRAINING_ACTIVITY_PLAN_ID = 12;
    public static final int FLD_TRAINING_ACTIVITY_ACTUAL_ID = 13;
    public static final int FLD_POINT = 14;
    public static final int FLD_NOMOR_SK = 15;
    public static final int FLD_TANGGAL_SK = 16;
    public static final int FLD_EMP_DOC_ID = 17;
    public static final int FLD_TRAINING_TITLE = 18;
    public static final int FLD_PRE_TEST = 19;
    public static final int FLD_POST_TEST = 20;
    public static String[] fieldNames = {
        "TRAINING_HISTORY_ID",
        "EMPLOYEE_ID",
        "TRAINING_PROGRAM",
        "START_DATE",
        "END_DATE",
        "TRAINER",
        "REMARK",
        "TRAINING_ID",
        "DURATION",
        "PRESENCE",
        "START_TIME",
        "END_TIME",
        "TRAINING_ACTIVITY_PLAN_ID",
        "TRAINING_ACTIVITY_ACTUAL_ID",
        "POINT",
        "NOMOR_SK",
        "TANGGAL_SK",
        "EMP_DOC_ID",
        "TRAINING_TITLE",
        "PRE_TEST",
        "POST_TEST"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    //variable untuk query log history
    private static String query = "";
    
    public String getQuery(){
        return query;
    }
    
    public PstTrainingHistory() {
    }

    public PstTrainingHistory(int i) throws DBException {
        super(new PstTrainingHistory());
    }

    public PstTrainingHistory(String sOid) throws DBException {
        super(new PstTrainingHistory(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingHistory(long lOid) throws DBException {
        super(new PstTrainingHistory(0));
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
        return TBL_HR_TRAINING_HISTORY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingHistory().getClass().getName();
    }

    public static TrainingHistory fetchExc(long oid) throws DBException {
        try {
            TrainingHistory entTrainingHistory = new TrainingHistory();
            PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(oid);
            entTrainingHistory.setOID(oid);
            entTrainingHistory.setEmployeeId(pstTrainingHistory.getLong(FLD_EMPLOYEE_ID));
            entTrainingHistory.setTrainingProgram(pstTrainingHistory.getString(FLD_TRAINING_PROGRAM));
            entTrainingHistory.setStartDate(pstTrainingHistory.getDate(FLD_START_DATE));
            entTrainingHistory.setEndDate(pstTrainingHistory.getDate(FLD_END_DATE));
            entTrainingHistory.setTrainer(pstTrainingHistory.getString(FLD_TRAINER));
            entTrainingHistory.setRemark(pstTrainingHistory.getString(FLD_REMARK));
            entTrainingHistory.setTrainingId(pstTrainingHistory.getLong(FLD_TRAINING_ID));
            entTrainingHistory.setDuration(pstTrainingHistory.getInt(FLD_DURATION));
            entTrainingHistory.setPresence(pstTrainingHistory.getInt(FLD_PRESENCE));
            entTrainingHistory.setStartTime(pstTrainingHistory.getDate(FLD_START_TIME));
            entTrainingHistory.setEndTime(pstTrainingHistory.getDate(FLD_END_TIME));
            entTrainingHistory.setTrainingActivityPlanId(pstTrainingHistory.getLong(FLD_TRAINING_ACTIVITY_PLAN_ID));
            entTrainingHistory.setTrainingActivityActualId(pstTrainingHistory.getLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingHistory.setPoint(pstTrainingHistory.getdouble(FLD_POINT));
            entTrainingHistory.setNomorSk(pstTrainingHistory.getString(FLD_NOMOR_SK));
            entTrainingHistory.setTanggalSk(pstTrainingHistory.getDate(FLD_TANGGAL_SK));
            entTrainingHistory.setEmpDocId(pstTrainingHistory.getLong(FLD_EMP_DOC_ID));
            entTrainingHistory.setTrainingTitle(pstTrainingHistory.getString(FLD_TRAINING_TITLE));
            return entTrainingHistory;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingHistory entTrainingHistory = fetchExc(entity.getOID());
        entity = (Entity) entTrainingHistory;
        return entTrainingHistory.getOID();
    }

    public static synchronized long updateExc(TrainingHistory entTrainingHistory) throws DBException {
        try {
            if (entTrainingHistory.getOID() != 0) {
                PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(entTrainingHistory.getOID());
                pstTrainingHistory.setLong(FLD_EMPLOYEE_ID, entTrainingHistory.getEmployeeId());
                pstTrainingHistory.setString(FLD_TRAINING_PROGRAM, entTrainingHistory.getTrainingProgram());
                pstTrainingHistory.setDate(FLD_START_DATE, entTrainingHistory.getStartDate());
                pstTrainingHistory.setDate(FLD_END_DATE, entTrainingHistory.getEndDate());
                pstTrainingHistory.setString(FLD_TRAINER, entTrainingHistory.getTrainer());
                pstTrainingHistory.setString(FLD_REMARK, entTrainingHistory.getRemark());
                pstTrainingHistory.setLong(FLD_TRAINING_ID, entTrainingHistory.getTrainingId());
                pstTrainingHistory.setInt(FLD_DURATION, entTrainingHistory.getDuration());
                pstTrainingHistory.setInt(FLD_PRESENCE, entTrainingHistory.getPresence());
                pstTrainingHistory.setDate(FLD_START_TIME, entTrainingHistory.getStartTime());
                pstTrainingHistory.setDate(FLD_END_TIME, entTrainingHistory.getEndTime());
                pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingHistory.getTrainingActivityPlanId());
                pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingHistory.getTrainingActivityActualId());
                pstTrainingHistory.setDouble(FLD_POINT, entTrainingHistory.getPoint());
                pstTrainingHistory.setString(FLD_NOMOR_SK, entTrainingHistory.getNomorSk());
                pstTrainingHistory.setDate(FLD_TANGGAL_SK, entTrainingHistory.getTanggalSk());
                pstTrainingHistory.setLong(FLD_EMP_DOC_ID, entTrainingHistory.getEmpDocId());
                pstTrainingHistory.setString(FLD_TRAINING_TITLE, entTrainingHistory.getTrainingTitle());
                pstTrainingHistory.update();
                return entTrainingHistory.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static synchronized long updateExcPending(TrainingHistory entTrainingHistory) throws DBException {
        try {
            if (entTrainingHistory.getOID() != 0) {
                PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(entTrainingHistory.getOID());
                pstTrainingHistory.setLong(FLD_EMPLOYEE_ID, entTrainingHistory.getEmployeeId());
                pstTrainingHistory.setString(FLD_TRAINING_PROGRAM, entTrainingHistory.getTrainingProgram());
                pstTrainingHistory.setDate(FLD_START_DATE, entTrainingHistory.getStartDate());
                pstTrainingHistory.setDate(FLD_END_DATE, entTrainingHistory.getEndDate());
                pstTrainingHistory.setString(FLD_TRAINER, entTrainingHistory.getTrainer());
                pstTrainingHistory.setString(FLD_REMARK, entTrainingHistory.getRemark());
                pstTrainingHistory.setLong(FLD_TRAINING_ID, entTrainingHistory.getTrainingId());
                pstTrainingHistory.setInt(FLD_DURATION, entTrainingHistory.getDuration());
                pstTrainingHistory.setInt(FLD_PRESENCE, entTrainingHistory.getPresence());
                pstTrainingHistory.setDate(FLD_START_TIME, entTrainingHistory.getStartTime());
                pstTrainingHistory.setDate(FLD_END_TIME, entTrainingHistory.getEndTime());
                pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingHistory.getTrainingActivityPlanId());
                pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingHistory.getTrainingActivityActualId());
                pstTrainingHistory.setDouble(FLD_POINT, entTrainingHistory.getPoint());
                pstTrainingHistory.setString(FLD_NOMOR_SK, entTrainingHistory.getNomorSk());
                pstTrainingHistory.setDate(FLD_TANGGAL_SK, entTrainingHistory.getTanggalSk());
                pstTrainingHistory.setLong(FLD_EMP_DOC_ID, entTrainingHistory.getEmpDocId());
                pstTrainingHistory.setString(FLD_TRAINING_TITLE, entTrainingHistory.getTrainingTitle());
                query = pstTrainingHistory.getUpdateSQL();
                return entTrainingHistory.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingHistory) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(oid);
            pstTrainingHistory.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static synchronized long deleteExcPending(long oid) throws DBException {
        try {
            PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(oid);
            query = pstTrainingHistory.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingHistory entTrainingHistory) throws DBException {
        try {
            PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(0);
            pstTrainingHistory.setLong(FLD_EMPLOYEE_ID, entTrainingHistory.getEmployeeId());
            pstTrainingHistory.setString(FLD_TRAINING_PROGRAM, entTrainingHistory.getTrainingProgram());
            pstTrainingHistory.setDate(FLD_START_DATE, entTrainingHistory.getStartDate());
            pstTrainingHistory.setDate(FLD_END_DATE, entTrainingHistory.getEndDate());
            pstTrainingHistory.setString(FLD_TRAINER, entTrainingHistory.getTrainer());
            pstTrainingHistory.setString(FLD_REMARK, entTrainingHistory.getRemark());
            pstTrainingHistory.setLong(FLD_TRAINING_ID, entTrainingHistory.getTrainingId());
            pstTrainingHistory.setInt(FLD_DURATION, entTrainingHistory.getDuration());
            pstTrainingHistory.setInt(FLD_PRESENCE, entTrainingHistory.getPresence());
            pstTrainingHistory.setDate(FLD_START_TIME, entTrainingHistory.getStartTime());
            pstTrainingHistory.setDate(FLD_END_TIME, entTrainingHistory.getEndTime());
            pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingHistory.getTrainingActivityPlanId());
            pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingHistory.getTrainingActivityActualId());
            pstTrainingHistory.setDouble(FLD_POINT, entTrainingHistory.getPoint());
            pstTrainingHistory.setString(FLD_NOMOR_SK, entTrainingHistory.getNomorSk());
            pstTrainingHistory.setDate(FLD_TANGGAL_SK, entTrainingHistory.getTanggalSk());
            pstTrainingHistory.setLong(FLD_EMP_DOC_ID, entTrainingHistory.getEmpDocId());
            pstTrainingHistory.setString(FLD_TRAINING_TITLE, entTrainingHistory.getTrainingTitle());
            pstTrainingHistory.setDouble(FLD_PRE_TEST, entTrainingHistory.getPreTest());
            pstTrainingHistory.setDouble(FLD_POST_TEST, entTrainingHistory.getPostTest());
            pstTrainingHistory.insert();
            entTrainingHistory.setOID(pstTrainingHistory.getLong(FLD_TRAINING_HISTORY_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return entTrainingHistory.getOID();
    }

    
    public static synchronized long insertExcPending(TrainingHistory entTrainingHistory) throws DBException {
        try {
            PstTrainingHistory pstTrainingHistory = new PstTrainingHistory(0);
            pstTrainingHistory.setLong(FLD_EMPLOYEE_ID, entTrainingHistory.getEmployeeId());
            pstTrainingHistory.setString(FLD_TRAINING_PROGRAM, entTrainingHistory.getTrainingProgram());
            pstTrainingHistory.setDate(FLD_START_DATE, entTrainingHistory.getStartDate());
            pstTrainingHistory.setDate(FLD_END_DATE, entTrainingHistory.getEndDate());
            pstTrainingHistory.setString(FLD_TRAINER, entTrainingHistory.getTrainer());
            pstTrainingHistory.setString(FLD_REMARK, entTrainingHistory.getRemark());
            pstTrainingHistory.setLong(FLD_TRAINING_ID, entTrainingHistory.getTrainingId());
            pstTrainingHistory.setInt(FLD_DURATION, entTrainingHistory.getDuration());
            pstTrainingHistory.setInt(FLD_PRESENCE, entTrainingHistory.getPresence());
            pstTrainingHistory.setDate(FLD_START_TIME, entTrainingHistory.getStartTime());
            pstTrainingHistory.setDate(FLD_END_TIME, entTrainingHistory.getEndTime());
            pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingHistory.getTrainingActivityPlanId());
            pstTrainingHistory.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingHistory.getTrainingActivityActualId());
            pstTrainingHistory.setDouble(FLD_POINT, entTrainingHistory.getPoint());
            pstTrainingHistory.setString(FLD_NOMOR_SK, entTrainingHistory.getNomorSk());
            pstTrainingHistory.setDate(FLD_TANGGAL_SK, entTrainingHistory.getTanggalSk());
            pstTrainingHistory.setLong(FLD_EMP_DOC_ID, entTrainingHistory.getEmpDocId());
            pstTrainingHistory.setString(FLD_TRAINING_TITLE, entTrainingHistory.getTrainingTitle());
            query = pstTrainingHistory.getInsertQuery();
            entTrainingHistory.setOID(pstTrainingHistory.getLong(FLD_TRAINING_HISTORY_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingHistory(0), DBException.UNKNOWN);
        }
        return entTrainingHistory.getOID();
    }
    
    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingHistory) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingHistory entTrainingHistory) {
        try {
            entTrainingHistory.setOID(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_HISTORY_ID]));
            entTrainingHistory.setEmployeeId(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID]));
            entTrainingHistory.setTrainingProgram(rs.getString(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_PROGRAM]));
            entTrainingHistory.setStartDate(rs.getDate(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_START_DATE]));
            entTrainingHistory.setEndDate(rs.getDate(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_END_DATE]));
            entTrainingHistory.setTrainer(rs.getString(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINER]));
            entTrainingHistory.setRemark(rs.getString(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_REMARK]));
            entTrainingHistory.setTrainingId(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]));
            entTrainingHistory.setDuration(rs.getInt(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_DURATION]));
            entTrainingHistory.setPresence(rs.getInt(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_PRESENCE]));
            entTrainingHistory.setStartTime(rs.getDate(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_START_TIME]));
            entTrainingHistory.setEndTime(rs.getDate(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_END_TIME]));
            entTrainingHistory.setTrainingActivityPlanId(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ACTIVITY_PLAN_ID]));
            entTrainingHistory.setTrainingActivityActualId(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ACTIVITY_ACTUAL_ID]));
            entTrainingHistory.setPoint(rs.getDouble(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_POINT]));
            entTrainingHistory.setNomorSk(rs.getString(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_NOMOR_SK]));
            entTrainingHistory.setTanggalSk(rs.getDate(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TANGGAL_SK]));
            entTrainingHistory.setEmpDocId(rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMP_DOC_ID]));
            entTrainingHistory.setTrainingTitle(rs.getString(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_TITLE]));
            entTrainingHistory.setPreTest(rs.getDouble(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_PRE_TEST]));
            entTrainingHistory.setPostTest(rs.getDouble(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_POST_TEST]));
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
            String sql = "SELECT * FROM " + TBL_HR_TRAINING_HISTORY;
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
                TrainingHistory entTrainingHistory = new TrainingHistory();
                resultToObject(rs, entTrainingHistory);
                lists.add(entTrainingHistory);
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
    

    public static Vector listDistinct(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT "+fieldNames[FLD_EMPLOYEE_ID]+" FROM " + TBL_HR_TRAINING_HISTORY;
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
                long data = rs.getLong(PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID]);
                lists.add(data);
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

    public static Vector listEmployeeTraining(long oidTrainingPlan) {
        Vector lists = new Vector();
        System.out.println("oidTrainingPlan..." + oidTrainingPlan);
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_TRAINING_HISTORY + " as trh"
                    + " INNER JOIN " + PstEmployee.TBL_HR_EMPLOYEE + " as emp"
                    + " on trh." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] + "="
                    + " emp. " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " INNER JOIN " + PstDepartment.TBL_HR_DEPARTMENT + " as dept "
                    + " on emp." + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "="
                    + " dept. " + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]
                    + " AND trh." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ACTIVITY_PLAN_ID] + "="
                    + oidTrainingPlan;


            dbrs = DBHandler.execQueryResult(sql);
            System.out.println("SQLemploteeTraininf tam bah  " + sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TrainingHistory traininghistory = new TrainingHistory();
                resultToObject(rs, traininghistory);
                lists.add(traininghistory);
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

    // added by Bayu
    public static Vector listEmployeeTrainingByActivity(long oidTrainingActivityId) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        if(oidTrainingActivityId==0)
            return null;
        try {
            String sql = " SELECT trh.* FROM " + TBL_HR_TRAINING_HISTORY + " as trh"
                    + " INNER JOIN " + PstEmployee.TBL_HR_EMPLOYEE + " as emp"
                    + " on trh." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] + "="
                    + " emp. " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " INNER JOIN " + PstDepartment.TBL_HR_DEPARTMENT + " as dept "
                    + " on emp." + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "="
                    + " dept. " + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]
                    + " AND trh." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + "="
                    + oidTrainingActivityId + " ORDER BY emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM];

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                TrainingHistory traininghistory = new TrainingHistory();
                resultToObject(rs, traininghistory);
                lists.add(traininghistory);
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

    public static long getTrainingHistoryId(String whereClause) {
        DBResultSet dbrs = null;
        long id = 0;

        try {
            String sql = "SELECT " + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_HISTORY_ID] + " FROM " + TBL_HR_TRAINING_HISTORY;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                id = rs.getLong(1);
            }

            rs.close();
            return id;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    public static long insertTrainingHistory(String[] employeeIds, String[] trainHours,  long oidTraining, long oidTrainingPlan, long oidSchedule, long oidTrainingActual) {
      return insertTrainingHistory(employeeIds, trainHours, null, oidTraining, oidTrainingPlan, oidSchedule, oidTrainingActual);                       
    }
    
    public static long insertTrainingHistory(String[] employeeIds, String[] trainHours, String[] trainPoints, long oidTraining, long oidTrainingPlan, long oidSchedule, long oidTrainingActual) {
        Training training = new Training();
        TrainingSchedule schedule = new TrainingSchedule();
        TrainingActivityPlan plan = new TrainingActivityPlan();
        TrainingActivityActual actual = new TrainingActivityActual();
        TrainingHistory history = new TrainingHistory();
        long oid = 0;

        if (employeeIds != null && employeeIds.length > 0) {
            try {
                training = PstTraining.fetchExc(oidTraining);
            } catch (Exception e) {
                training = new Training();
            }

            try {
                plan = PstTrainingActivityPlan.fetchExc(oidTrainingPlan);
            } catch (Exception e) {
                plan = new TrainingActivityPlan();
            }

            try {
                actual = PstTrainingActivityActual.fetchExc(oidTrainingActual);
            } catch (Exception e) {
                actual = new TrainingActivityActual();
            }

            try {
                schedule = PstTrainingSchedule.fetchExc(oidSchedule);
            } catch (Exception e) {
                schedule = new TrainingSchedule();

                if (actual.getOID() != 0) {
                    schedule.setTrainDate(actual.getDate());
                    schedule.setTrainEndDate(actual.getTrainEndDate());
                    schedule.setStartTime(actual.getStartTime());
                    schedule.setEndTime(actual.getEndTime());
                }
            }

            for (int i = 0; i < employeeIds.length; i++) {
                Training train = new Training();
                String trainingName = "-";
                try {
                    train = PstTraining.fetchExc(oidTraining);
                    trainingName = train.getName();
                } catch(Exception e){
                    System.out.println(e.toString());
                }
                history.setTrainingProgram(trainingName);
                history.setEmployeeId(Long.parseLong(employeeIds[i]));
                history.setStartDate(schedule.getTrainDate());
                history.setEndDate(schedule.getTrainEndDate());
                history.setTrainer(plan.getTrainer());
                history.setRemark(actual.getRemark());
                history.setTrainingTitle(actual.getTrainingTitle());
                history.setTrainingId(oidTraining);
                //history.setDuration(plan.getTotHoursPlan());
                try{
                history.setDuration(Integer.parseInt(trainHours[i]));
                history.setPoint(Double.parseDouble(trainPoints[i]));
                } catch(Exception exc){
                    System.out.println(exc);
                }
                history.setPresence(0);
                //history.setStartTime(schedule.getStartTime());              
                history.setTrainingActivityPlanId(oidTrainingPlan);
                history.setTrainingActivityActualId(oidTrainingActual);

                Date start = new Date(history.getStartDate().getYear(), history.getStartDate().getMonth(),
                        history.getStartDate().getDate(), schedule.getStartTime().getHours(),
                        schedule.getStartTime().getMinutes());
                history.setStartTime(start);

                Date end = new Date(history.getEndDate().getYear(), history.getEndDate().getMonth(),
                        history.getEndDate().getDate(), schedule.getEndTime().getHours(),
                        schedule.getEndTime().getMinutes());
                history.setEndTime(end);
                
                try {
                    oid = PstTrainingHistory.insertExc(history);
                } catch (Exception e) {
                    System.out.println("Error Saving Attendances");
                }
            }
        }

        return oid;
    }
    
      public static long insertTrainingHistory(String[] employeeIds, String[] trainHours,String[] trainRemark, String[] trainPoints, long oidTraining, long oidTrainingPlan, long oidSchedule, long oidTrainingActual,String[] preTest,String[] postTest) {
        Training training = new Training();
        TrainingSchedule schedule = new TrainingSchedule();
        TrainingActivityPlan plan = new TrainingActivityPlan();
        TrainingActivityActual actual = new TrainingActivityActual();
        TrainingHistory history = new TrainingHistory();
        long oid = 0;

        Vector listTrainMap = PstTrainingActivityMapping.list(0, 0, PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_PLAN_ID]+"="+oidTrainingPlan, "");
        String trainingProgram = "";
        for (int x=0; x < listTrainMap.size(); x++){
            TrainingActivityMapping map = (TrainingActivityMapping) listTrainMap.get(x);
            if (trainingProgram.length()>0){
                trainingProgram += ", ";
            }
            try {
                Training tr = PstTraining.fetchExc(map.getTrainingId());
                trainingProgram += tr.getName();
            } catch (Exception exc){}
            
        }
        if (employeeIds != null && employeeIds.length > 0) {
            try {
                training = PstTraining.fetchExc(oidTraining);
            } catch (Exception e) {
                training = new Training();
            }

            try {
                plan = PstTrainingActivityPlan.fetchExc(oidTrainingPlan);
            } catch (Exception e) {
                plan = new TrainingActivityPlan();
            }

            try {
                actual = PstTrainingActivityActual.fetchExc(oidTrainingActual);
            } catch (Exception e) {
                actual = new TrainingActivityActual();
            }

            try {
                schedule = PstTrainingSchedule.fetchExc(oidSchedule);
            } catch (Exception e) {
                schedule = new TrainingSchedule();

                if (actual.getOID() != 0) {
                    schedule.setTrainDate(actual.getDate());
                    schedule.setTrainEndDate(actual.getTrainEndDate());
                    schedule.setStartTime(actual.getStartTime());
                    schedule.setEndTime(actual.getEndTime());
                }
            }

            for (int i = 0; i < employeeIds.length; i++) {
                Training train = new Training();
                String trainingName = "-";
                if (trainingProgram.length()>0){
                    trainingName = trainingProgram;
                }
//                try {
//                    train = PstTraining.fetchExc(oidTraining);
//                    trainingName = train.getName();
//                } catch(Exception e){
//                    System.out.println(e.toString());
//                }
                history.setTrainingProgram(trainingName);
                history.setEmployeeId(Long.parseLong(employeeIds[i]));
                history.setStartDate(schedule.getTrainDate());
                history.setEndDate(schedule.getTrainEndDate());
                history.setTrainer(plan.getTrainer());
                history.setRemark(actual.getRemark());
                history.setTrainingTitle(actual.getTrainingTitle());
                history.setTrainingId(oidTraining);
                //history.setDuration(plan.getTotHoursPlan());
                try{
                history.setDuration(Integer.parseInt(trainHours[i]));
                history.setPoint(Double.parseDouble(trainPoints[i]));
                history.setPreTest(Double.parseDouble(preTest[i]));
                history.setPostTest(Double.parseDouble(postTest[i]));
                history.setRemark(String.valueOf(trainRemark[i]));
                } catch(Exception exc){
                    System.out.println(exc);
                }
                history.setPresence(0);
                //history.setStartTime(schedule.getStartTime());              
                history.setTrainingActivityPlanId(oidTrainingPlan);
                history.setTrainingActivityActualId(oidTrainingActual);

                Date start = new Date(history.getStartDate().getYear(), history.getStartDate().getMonth(),
                        history.getStartDate().getDate(), schedule.getStartTime().getHours(),
                        schedule.getStartTime().getMinutes());
                history.setStartTime(start);

                Date end = new Date(history.getEndDate().getYear(), history.getEndDate().getMonth(),
                        history.getEndDate().getDate(), schedule.getEndTime().getHours(),
                        schedule.getEndTime().getMinutes());
                history.setEndTime(end);
                
                try {
                    oid = PstTrainingHistory.insertExc(history);
                } catch (Exception e) {
                    System.out.println("Error Saving Attendances");
                }
            }
        }

        return oid;
    }
      
      
    // start dedy - 20160201
    public static long insertTrainHistory(String[] employeeIds, String[] trainHours, long oidTraining, long oidTrainingPlan, long oidSchedule, long oidTrainingActual, int command) {
        Training training = new Training();
        TrainingSchedule schedule = new TrainingSchedule();
        TrainingActivityPlan plan = new TrainingActivityPlan();
        TrainingActivityActual actual = new TrainingActivityActual();
        TrainingHistory history = new TrainingHistory();
        long oid = 0;

        if (employeeIds != null && employeeIds.length > 0) {
            try {
                training = PstTraining.fetchExc(oidTraining);
            } catch (Exception e) {
                training = new Training();
            }

            try {
                plan = PstTrainingActivityPlan.fetchExc(oidTrainingPlan);
            } catch (Exception e) {
                plan = new TrainingActivityPlan();
            }

            try {
                actual = PstTrainingActivityActual.fetchExc(oidTrainingActual);
            } catch (Exception e) {
                actual = new TrainingActivityActual();
            }

            try {
                schedule = PstTrainingSchedule.fetchExc(oidSchedule);
            } catch (Exception e) {
                schedule = new TrainingSchedule();

                if (actual.getOID() != 0) {
                    schedule.setTrainDate(actual.getDate());
                    schedule.setTrainEndDate(actual.getTrainEndDate());
                    schedule.setStartTime(actual.getStartTime());
                    schedule.setEndTime(actual.getEndTime());
                }
            }

            for (int i = 0; i < employeeIds.length; i++) {
                Training train = new Training();
                String trainingName = "-";
                try {
                    train = PstTraining.fetchExc(oidTraining);
                    trainingName = train.getName();
                } catch(Exception e){
                    System.out.println(e.toString());
                }
                history.setTrainingProgram(trainingName);
                history.setEmployeeId(Long.parseLong(employeeIds[i]));
                history.setStartDate(schedule.getTrainDate());
                history.setEndDate(schedule.getTrainEndDate());
                history.setTrainer(plan.getTrainer());
                history.setRemark(actual.getRemark());
                history.setTrainingTitle(actual.getTrainingTitle());
                history.setTrainingId(oidTraining);
                //history.setDuration(plan.getTotHoursPlan());
                history.setDuration(Integer.parseInt(trainHours[i]));
                history.setPresence(0);
                //history.setStartTime(schedule.getStartTime());              
                history.setTrainingActivityPlanId(oidTrainingPlan);
                history.setTrainingActivityActualId(oidTrainingActual);

                Date start = new Date(history.getStartDate().getYear(), history.getStartDate().getMonth(),
                        history.getStartDate().getDate(), schedule.getStartTime().getHours(),
                        schedule.getStartTime().getMinutes());
                history.setStartTime(start);

                Date end = new Date(history.getEndDate().getYear(), history.getEndDate().getMonth(),
                        history.getEndDate().getDate(), schedule.getEndTime().getHours(),
                        schedule.getEndTime().getMinutes());
                history.setEndTime(end);
                
                try {
                    if(command == Command.SAVE){
                        oid = PstTrainingHistory.insertExc(history);
                    }
                } catch (Exception e) {
                    System.out.println("Error Saving Attendances");
                }
            }
        }

        return oid;
    }
    // end dedy - 20160201
    public static boolean checkOID(long entTrainingHistoryId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_TRAINING_HISTORY + " WHERE "
                    + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_HISTORY_ID] + " = " + entTrainingHistoryId;
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
            String sql = "SELECT COUNT(" + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_HISTORY_ID] + ") FROM " + TBL_HR_TRAINING_HISTORY;
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
                    TrainingHistory entTrainingHistory = (TrainingHistory) list.get(ls);
                    if (oid == entTrainingHistory.getOID()) {
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
    
    public static String drawTrainingProgram(long typeId){
        String output = "";
        String whereClause = PstTraining.fieldNames[PstTraining.FLD_TYPE]+"="+typeId;
        Vector listTraining = PstTraining.list(0, 0, whereClause, PstTraining.fieldNames[PstTraining.FLD_NAME]);
        if (listTraining != null && listTraining.size()>0){
            for (int i=0; i<listTraining.size(); i++){
                Training training = (Training)listTraining.get(i);
                output += "<option value=\""+training.getOID()+"\">"+training.getName()+"</option>";
            }
        }
        return output;
    }
    
    public static String drawTrainingType(){
        String output = "";
        Vector listTrainType = PstTrainType.list(0, 0, "", PstTrainType.fieldNames[PstTrainType.FLD_TRAIN_TYPE_NAME]);
        if (listTrainType != null && listTrainType.size()>0){
            for (int i=0; i< listTrainType.size(); i++){
                TrainType trainType = (TrainType)listTrainType.get(i);
                output += "<option value=\""+trainType.getOID()+"\">"+trainType.getTypeName()+"</option>";
            }
        }
        return output;
    }
    
    public static String drawPosition(){
        String output = "";
        Vector listPosition = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
        if (listPosition != null && listPosition.size()>0){
            for (int i=0; i< listPosition.size(); i++){
                Position position = (Position)listPosition.get(i);
                output += "<option value=\""+position.getOID()+"\">"+position.getPosition()+"</option>";
            }
        }
        return output;
    }
    
    public static String drawLevel(){
        String output = "";
        Vector listLevel = PstLevel.list(0, 0, "", PstLevel.fieldNames[PstLevel.FLD_LEVEL]);
        if (listLevel != null && listLevel.size()>0){
            for (int i=0; i< listLevel.size(); i++){
                Level level = (Level)listLevel.get(i);
                output += "<option value=\""+level.getOID()+"\">"+level.getLevel()+"</option>";
            }
        }
        return output;
    }
    
    /* Update by Hendra Putu | 2016-06-14 */
    public static Vector listJoinEmpTraining(String where) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "";
            
            sql  = " SELECT hr_training_history.`TRAINING_TITLE`, ";
            sql += " hr_employee.EMPLOYEE_NUM, hr_employee.FULL_NAME, ";
            sql += " hr_position.POSITION, hr_level.`LEVEL`, ";
            sql += " hr_training.`NAME` AS training, hr_training_type.`NAME` AS tipe, ";
            sql += " hr_employee.EMPLOYEE_ID ";
            sql += " FROM hr_training_history ";
            sql += " INNER JOIN hr_employee ON hr_training_history.EMPLOYEE_ID=hr_employee.EMPLOYEE_ID ";
            sql += " INNER JOIN hr_position ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " INNER JOIN hr_level ON hr_employee.LEVEL_ID=hr_level.LEVEL_ID ";
            sql += " INNER JOIN hr_training ON hr_training_history.TRAINING_ID=hr_training.TRAINING_ID ";
            sql += " INNER JOIN hr_training_type ON hr_training.TYPE=hr_training_type.TYPE_ID ";
            sql += " WHERE "+where;  

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String[] data = new String[8];
                data[0] = rs.getString("EMPLOYEE_NUM");
                data[1] = rs.getString("FULL_NAME");
                data[2] = rs.getString("POSITION");
                data[3] = rs.getString("LEVEL");
                data[4] = rs.getString("training");
                data[5] = rs.getString("tipe");
                data[6] = rs.getString("EMPLOYEE_ID");
                data[7] = rs.getString("TRAINING_TITLE");
                lists.add(data);
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
    
    /* Update by Hendra Putu | 2016-08-15 */
    public static Vector listJoinEmpTrainingVersi1(String where) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "";
    
            sql  = " SELECT hr_employee.`EMPLOYEE_NUM`, hr_employee.`FULL_NAME`, hr_employee.`DIVISION_ID`, ";
            sql += " hr_employee.`POSITION_ID`, hr_training_history.`TRAINING_TITLE`, ";
            sql += " hr_training_history.`TRAINING_PROGRAM`, hr_training_history.TRAINING_ACTIVITY_ACTUAL_ID, ";
            sql += " hr_training_history.`START_DATE`, hr_training_history.TRAINER ";
            sql += " FROM hr_training_history ";
            sql += " INNER JOIN hr_employee ON hr_training_history.`EMPLOYEE_ID`=hr_employee.`EMPLOYEE_ID` ";
            sql += " WHERE hr_employee.`EMPLOYEE_ID` IN("+where+") ORDER BY hr_training_history.`START_DATE` DESC";
    
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String[] data = new String[9];
                data[0] = rs.getString("EMPLOYEE_NUM");
                data[1] = rs.getString("FULL_NAME");
                data[2] = rs.getString("DIVISION_ID");
                data[3] = rs.getString("POSITION_ID");
                data[4] = rs.getString("TRAINING_TITLE");
                data[5] = rs.getString("TRAINING_PROGRAM");
                data[6] = rs.getString("TRAINING_ACTIVITY_ACTUAL_ID");
                data[7] = rs.getString("START_DATE");
                data[8] = rs.getString("TRAINER");
                lists.add(data);
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
    
    //add by Eri Yudi 20200923
    public static Vector listJoinEmpTrainingVersi2(String empIdIn, String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "";
    
            sql  = " SELECT hr_employee.`EMPLOYEE_NUM`, hr_employee.`FULL_NAME`, hr_employee.`DIVISION_ID`, ";
            sql += " hr_employee.`POSITION_ID`, hr_training_history.`TRAINING_TITLE`, ";
            sql += " hr_training_history.`TRAINING_PROGRAM`, hr_training_history.TRAINING_ACTIVITY_ACTUAL_ID, ";
            sql += " hr_training_activity_actual.`KODE_OJK`, ";
            sql += " hr_training_history.`START_DATE`, hr_training_history.`END_DATE`, " ;
            sql += " hr_training_history.`REMARK` " ;
            sql += " FROM hr_training_history ";
            sql += " INNER JOIN hr_employee ON hr_training_history.`EMPLOYEE_ID`=hr_employee.`EMPLOYEE_ID` ";
            sql += " inner JOIN `hr_training_activity_actual` on hr_training_activity_actual.`TRAINING_ACTIVITY_ACTUAL_ID` = hr_training_history.TRAINING_ACTIVITY_ACTUAL_ID ";
            sql += " WHERE hr_employee.`EMPLOYEE_ID` IN("+empIdIn+") ";
            sql += whereClause;
    
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String[] data = new String[11];
                data[0] = rs.getString("EMPLOYEE_NUM");
                data[1] = rs.getString("FULL_NAME");
                data[2] = rs.getString("DIVISION_ID");
                data[3] = rs.getString("POSITION_ID");
                data[4] = rs.getString("TRAINING_TITLE");
                data[5] = rs.getString("TRAINING_PROGRAM");
                data[6] = rs.getString("TRAINING_ACTIVITY_ACTUAL_ID");
                data[7] = rs.getString("KODE_OJK");
                data[8] = rs.getString("START_DATE");
                data[9] = rs.getString("END_DATE");
                data[10] = rs.getString("REMARK");
                lists.add(data);
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
    
    public static Vector listEmployeeHaveBeenTrained1(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT TRH.* FROM " + TBL_HR_TRAINING_HISTORY + " as TRH"
                    + " INNER JOIN " + PstEmployee.TBL_HR_EMPLOYEE + " as EMP"
                    + " on TRH." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] + "="
                    + " EMP. " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " LEFT JOIN " + PstTraining.TBL_HR_TRAINING + " as TR"
                    + " on TRH." + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID] + "="
                    + " TR." + PstTraining.fieldNames[PstTraining.FLD_TRAINING_ID]
                    + " LEFT JOIN `hr_training_activity_mapping` MAP "
                    + " ON MAP.`TRAINING_ACTIVITY_PLAN_ID` = TRH.`TRAINING_ACTIVITY_PLAN_ID` "
                    + " LEFT JOIN hr_training AS TR2 "
                    + " ON MAP.`TRAINING_ID` = TR2.`TRAINING_ID` ";
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
                TrainingHistory entTrainingHistory = new TrainingHistory();
                resultToObject(rs, entTrainingHistory);
                lists.add(entTrainingHistory);
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
    
    //add by Eri Yudi 2020-06-24 
    // function : get list training history will expired count by day leght
    public static Vector listNotifTrainingHistory(int notifDayBefore) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT th.* FROM "+TBL_HR_TRAINING_HISTORY+" th " +
                            " INNER JOIN `"+PstTraining.TBL_HR_TRAINING+"` tr " +
                            " ON th.`"+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]+"` = tr.`"+PstTraining.fieldNames[PstTraining.FLD_TRAINING_ID]+"`" +
                            " WHERE  DATE_ADD(DATE_FORMAT(th.`"+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_START_DATE]+"`, '%Y-%m-%e'), INTERVAL tr.`"+PstTraining.fieldNames[PstTraining.FLD_MASA_BERLAKU]+"` MONTH)  BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+notifDayBefore+" DAY);" +
                            " ";
           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TrainingHistory entTrainingHistory = new TrainingHistory();
                resultToObject(rs, entTrainingHistory);
                lists.add(entTrainingHistory);
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
}