/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import static com.dimata.qdep.db.I_DBType.TYPE_ID;
import static com.dimata.qdep.db.I_DBType.TYPE_INT;
import static com.dimata.qdep.db.I_DBType.TYPE_LONG;
import static com.dimata.qdep.db.I_DBType.TYPE_PK;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;
/**
 *
 * @author keys
 */
public class PstTrainingCompetencyMappingDetail extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language{
    public static final String TBL_TRAINING_COMPETENCY_MAPPING_DETAIL = "hr_training_competency_mapping_detail";
    public static final int FLD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID = 0;
    public static final int FLD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FLD_COMPETENCY_ID = 2;
    public static final int FLD_SCORE = 3;
    public static final int FLD_EMPLOYEE_ID = 4;
    public static final int FLD_TRAINING_ATTENDANCE_ID = 5;
    public static final int FLD_TRAINING_COMPETENCY_MAPPING_ID = 6;
    public static final int FLD_TRAINING_HISTORY_ID = 7;
    
    public static String[] fieldNames = {
        "TRAINING_COMPETENCY_MAPPING_DETAIL_ID",
        "TRAINING_ACTIVITY_ACTUAL_ID",
        "COMPETENCY_ID",
        "SCORE",
        "EMPLOYEE_ID",
        "TRAINING_ATTENDANCE_ID",
        "TRAINING_COMPETENCY_MAPPING_ID",
        "TRAINING_HISTORY_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstTrainingCompetencyMappingDetail() {
    }

    public PstTrainingCompetencyMappingDetail(int i) throws DBException {
        super(new PstTrainingCompetencyMappingDetail());
    }

    public PstTrainingCompetencyMappingDetail(String sOid) throws DBException {
        super(new PstTrainingCompetencyMappingDetail(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingCompetencyMappingDetail(long lOid) throws DBException {
        super(new PstTrainingCompetencyMappingDetail(0));
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
        return TBL_TRAINING_COMPETENCY_MAPPING_DETAIL;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingCompetencyMappingDetail().getClass().getName();
    }

    public static TrainingCompetencyMappingDetail fetchExc(long oid) throws DBException {
        try {
            TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
            PstTrainingCompetencyMappingDetail pstTrainingCompetencyMappingDetail = new PstTrainingCompetencyMappingDetail(oid);
            entTrainingCompetencyMappingDetail.setOID(oid);
            entTrainingCompetencyMappingDetail.setTrainingActivityActualId(pstTrainingCompetencyMappingDetail.getlong(FLD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingCompetencyMappingDetail.setCompetencyId(pstTrainingCompetencyMappingDetail.getlong(FLD_COMPETENCY_ID));
            entTrainingCompetencyMappingDetail.setScore(pstTrainingCompetencyMappingDetail.getInt(FLD_SCORE));
            entTrainingCompetencyMappingDetail.setEmployeeId(pstTrainingCompetencyMappingDetail.getlong(FLD_EMPLOYEE_ID));
            entTrainingCompetencyMappingDetail.setTrainingAttId(pstTrainingCompetencyMappingDetail.getlong(FLD_TRAINING_ATTENDANCE_ID));
            entTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(pstTrainingCompetencyMappingDetail.getlong(FLD_TRAINING_COMPETENCY_MAPPING_ID));
            entTrainingCompetencyMappingDetail.setTrainingHistoryId(pstTrainingCompetencyMappingDetail.getlong(FLD_TRAINING_HISTORY_ID));
            return entTrainingCompetencyMappingDetail;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMappingDetail(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = fetchExc(entity.getOID());
        entity = (Entity) entTrainingCompetencyMappingDetail;
        return entTrainingCompetencyMappingDetail.getOID();
    }

    public static synchronized long updateExc(TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) throws DBException {
        try {
            if (entTrainingCompetencyMappingDetail.getOID() != 0) {
                PstTrainingCompetencyMappingDetail pstTrainingCompetencyMappingDetail = new PstTrainingCompetencyMappingDetail(entTrainingCompetencyMappingDetail.getOID());
                pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingCompetencyMappingDetail.getTrainingActivityActualId());
                pstTrainingCompetencyMappingDetail.setLong(FLD_COMPETENCY_ID, entTrainingCompetencyMappingDetail.getCompetencyId());
                pstTrainingCompetencyMappingDetail.setDouble(FLD_SCORE, entTrainingCompetencyMappingDetail.getScore());
                pstTrainingCompetencyMappingDetail.setLong(FLD_EMPLOYEE_ID, entTrainingCompetencyMappingDetail.getEmployeeId());
                pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_ATTENDANCE_ID, entTrainingCompetencyMappingDetail.getTrainingAttId());
                pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_COMPETENCY_MAPPING_ID, entTrainingCompetencyMappingDetail.getTrainingCompetencyMappingId());
                pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_HISTORY_ID, entTrainingCompetencyMappingDetail.getTrainingHistoryId());
                pstTrainingCompetencyMappingDetail.update();
                return entTrainingCompetencyMappingDetail.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMappingDetail(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingCompetencyMappingDetail) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingCompetencyMappingDetail pstTrainingCompetencyMappingDetail = new PstTrainingCompetencyMappingDetail(oid);
            pstTrainingCompetencyMappingDetail.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMappingDetail(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) throws DBException {
        try {
            PstTrainingCompetencyMappingDetail pstTrainingCompetencyMappingDetail = new PstTrainingCompetencyMappingDetail(0);
            pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingCompetencyMappingDetail.getTrainingActivityActualId());
            pstTrainingCompetencyMappingDetail.setLong(FLD_COMPETENCY_ID, entTrainingCompetencyMappingDetail.getCompetencyId());
            pstTrainingCompetencyMappingDetail.setDouble(FLD_SCORE, entTrainingCompetencyMappingDetail.getScore());
            pstTrainingCompetencyMappingDetail.setLong(FLD_EMPLOYEE_ID, entTrainingCompetencyMappingDetail.getEmployeeId());
            pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_ATTENDANCE_ID, entTrainingCompetencyMappingDetail.getTrainingAttId());
            pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_COMPETENCY_MAPPING_ID, entTrainingCompetencyMappingDetail.getTrainingCompetencyMappingId());
            pstTrainingCompetencyMappingDetail.setLong(FLD_TRAINING_HISTORY_ID, entTrainingCompetencyMappingDetail.getTrainingHistoryId());
            pstTrainingCompetencyMappingDetail.insert();
            entTrainingCompetencyMappingDetail.setOID(pstTrainingCompetencyMappingDetail.getlong(FLD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMappingDetail(0), DBException.UNKNOWN);
        }
        return entTrainingCompetencyMappingDetail.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingCompetencyMappingDetail) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) {
        try {
            entTrainingCompetencyMappingDetail.setOID(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID]));
            entTrainingCompetencyMappingDetail.setTrainingActivityActualId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID]));
            entTrainingCompetencyMappingDetail.setCompetencyId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_COMPETENCY_ID]));
            entTrainingCompetencyMappingDetail.setScore(rs.getInt(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_SCORE]));
            entTrainingCompetencyMappingDetail.setEmployeeId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_EMPLOYEE_ID]));
            entTrainingCompetencyMappingDetail.setTrainingAttId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ATTENDANCE_ID]));
            entTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_ID]));
            entTrainingCompetencyMappingDetail.setTrainingHistoryId(rs.getLong(PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_HISTORY_ID]));

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
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL;
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
                TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
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

    public static boolean checkOID(long entTrainingCompetencyMappingDetailId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID] + " = " + entTrainingCompetencyMappingDetailId;
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
    
     public static boolean checkGeneratedMapping(long entTrainingCompetencyMapping) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_ID] + " = " + entTrainingCompetencyMapping;
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
     
    public static Vector listByCompetencyMappingId(long oidTrainingCompetencyMapping) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_ID] + " = " + oidTrainingCompetencyMapping;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }
    
    public static boolean deleteCompetencyDetailMapByTrainingActualIandCompetencyId(long oidTrainingActual,long competencyId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "DELETE FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActual + " AND "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_COMPETENCY_ID] + " = " + competencyId;
            DBHandler.execUpdate(sql);
            result = true;
        } catch (Exception e) {
            result = false;
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
        
    public static boolean deleteCompetencyDetailMapByTrainingActualI(long oidTrainingActual) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "DELETE FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActual ;
            DBHandler.execUpdate(sql);
            result = true;
        } catch (Exception e) {
            result = false;
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
    
     public static Vector listByCompetencyMappingIdAndEmployeeId(long oidTrainingCompetencyMapping,long oidEmployee) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_COMPETENCY_MAPPING_ID] + " = " + oidTrainingCompetencyMapping +" AND "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_EMPLOYEE_ID] + " = " + oidEmployee ;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }
    
    public static Vector listByTrainingActivityActualId(long oidTrainingActualId) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActualId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }
    
     public static Vector listByTrainingActivityActualIdAndEmployeeId(long oidTrainingActualId, long employeeId) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActualId + " AND "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_EMPLOYEE_ID] + " = " + employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }
    
    
    
    
     public static Vector listByTrainingAttId(long oidTrainingAttId) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ATTENDANCE_ID] + " = " + oidTrainingAttId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }
     
     public static Vector listByEmployeeIdAndActualId( long actualId, long oidEmployee) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL + " WHERE "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_EMPLOYEE_ID] + " = " + oidEmployee + " AND "
                    + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + actualId ; 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                 TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
                resultToObject(rs, entTrainingCompetencyMappingDetail);
                lists.add(entTrainingCompetencyMappingDetail);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstTrainingCompetencyMappingDetail.fieldNames[PstTrainingCompetencyMappingDetail.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + ") FROM " + TBL_TRAINING_COMPETENCY_MAPPING_DETAIL;
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
                    TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail) list.get(ls);
                    if (oid == entTrainingCompetencyMappingDetail.getOID()) {
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
 
}
