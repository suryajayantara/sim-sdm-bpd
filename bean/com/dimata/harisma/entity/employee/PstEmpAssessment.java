/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstEmpAssessment extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_ASSESSMENT = "hr_emp_assessment";
    public static final int FLD_EMP_ASSESSMENT_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_ASSESSMENT_ID = 2;
    public static final int FLD_SCORE = 3;
    public static final int FLD_DATE_OF_ASSESSMENT = 4;
    public static final int FLD_REMARK = 5;

    public static String[] fieldNames = {
        "EMP_ASSESSMENT_ID",
        "EMPLOYEE_ID",
        "ASSESSMENT_ID",
        "SCORE",
        "DATE_OF_ASSESSMENT",
        "REMARK"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_STRING
    };

    //variable untuk query log history
    private static String query = "";
    
    public String getQuery(){
        return query;
    }
    
    public PstEmpAssessment() {
    }

    public PstEmpAssessment(int i) throws DBException {
        super(new PstEmpAssessment());
    }

    public PstEmpAssessment(String sOid) throws DBException {
        super(new PstEmpAssessment(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpAssessment(long lOid) throws DBException {
        super(new PstEmpAssessment(0));
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
        return TBL_EMP_ASSESSMENT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpAssessment().getClass().getName();
    }

    public static EmpAssessment fetchExc(long oid) throws DBException {
        try {
            EmpAssessment entEmpAssessment = new EmpAssessment();
            PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(oid);
            entEmpAssessment.setOID(oid);
            entEmpAssessment.setEmployeeId(pstEmpAssessment.getlong(FLD_EMPLOYEE_ID));
            entEmpAssessment.setAssessmentId(pstEmpAssessment.getlong(FLD_ASSESSMENT_ID));
            entEmpAssessment.setScore(pstEmpAssessment.getdouble(FLD_SCORE));
            entEmpAssessment.setDateOfAssessment(pstEmpAssessment.getDate(FLD_DATE_OF_ASSESSMENT));
            entEmpAssessment.setRemark(pstEmpAssessment.getString(FLD_REMARK));
            return entEmpAssessment;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpAssessment entEmpAssessment = fetchExc(entity.getOID());
        entity = (Entity) entEmpAssessment;
        return entEmpAssessment.getOID();
    }

    public static synchronized long updateExc(EmpAssessment entEmpAssessment) throws DBException {
        try {
            if (entEmpAssessment.getOID() != 0) {
                PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(entEmpAssessment.getOID());
                pstEmpAssessment.setLong(FLD_EMPLOYEE_ID, entEmpAssessment.getEmployeeId());
                pstEmpAssessment.setLong(FLD_ASSESSMENT_ID, entEmpAssessment.getAssessmentId());
                pstEmpAssessment.setDouble(FLD_SCORE, entEmpAssessment.getScore());
                pstEmpAssessment.setDate(FLD_DATE_OF_ASSESSMENT, entEmpAssessment.getDateOfAssessment());
                pstEmpAssessment.setString(FLD_REMARK, entEmpAssessment.getRemark());
                pstEmpAssessment.update();
                return entEmpAssessment.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static synchronized long updateExcPending(EmpAssessment entEmpAssessment) throws DBException {
        try {
            if (entEmpAssessment.getOID() != 0) {
                PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(entEmpAssessment.getOID());
                pstEmpAssessment.setLong(FLD_EMPLOYEE_ID, entEmpAssessment.getEmployeeId());
                pstEmpAssessment.setLong(FLD_ASSESSMENT_ID, entEmpAssessment.getAssessmentId());
                pstEmpAssessment.setDouble(FLD_SCORE, entEmpAssessment.getScore());
                pstEmpAssessment.setDate(FLD_DATE_OF_ASSESSMENT, entEmpAssessment.getDateOfAssessment());
                pstEmpAssessment.setString(FLD_REMARK, entEmpAssessment.getRemark());
                query = pstEmpAssessment.getUpdateSQL();
                return entEmpAssessment.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpAssessment) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(oid);
            pstEmpAssessment.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static synchronized long deleteExcPending(long oid) throws DBException {
        try {
            PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(oid);
            query = pstEmpAssessment.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    
    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpAssessment entEmpAssessment) throws DBException {
        try {
            PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(0);
            pstEmpAssessment.setLong(FLD_EMPLOYEE_ID, entEmpAssessment.getEmployeeId());
            pstEmpAssessment.setLong(FLD_ASSESSMENT_ID, entEmpAssessment.getAssessmentId());
            pstEmpAssessment.setDouble(FLD_SCORE, entEmpAssessment.getScore());
            pstEmpAssessment.setDate(FLD_DATE_OF_ASSESSMENT, entEmpAssessment.getDateOfAssessment());
            pstEmpAssessment.setString(FLD_REMARK, entEmpAssessment.getRemark());
            pstEmpAssessment.insert();
            entEmpAssessment.setOID(pstEmpAssessment.getlong(FLD_EMPLOYEE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return entEmpAssessment.getOID();
    }
    
    public static synchronized long insertExcPending(EmpAssessment entEmpAssessment) throws DBException {
        try {
            PstEmpAssessment pstEmpAssessment = new PstEmpAssessment(0);
            pstEmpAssessment.setLong(FLD_EMPLOYEE_ID, entEmpAssessment.getEmployeeId());
            pstEmpAssessment.setLong(FLD_ASSESSMENT_ID, entEmpAssessment.getAssessmentId());
            pstEmpAssessment.setDouble(FLD_SCORE, entEmpAssessment.getScore());
            pstEmpAssessment.setDate(FLD_DATE_OF_ASSESSMENT, entEmpAssessment.getDateOfAssessment());
            pstEmpAssessment.setString(FLD_REMARK, entEmpAssessment.getRemark());
            query = pstEmpAssessment.getInsertQuery();
            entEmpAssessment.setOID(pstEmpAssessment.getlong(FLD_EMPLOYEE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpAssessment(0), DBException.UNKNOWN);
        }
        return entEmpAssessment.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpAssessment) entity);
    }

    public static void resultToObject(ResultSet rs, EmpAssessment entEmpAssessment) {
        try {
            entEmpAssessment.setOID(rs.getLong(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMP_ASSESSMENT_ID]));
            entEmpAssessment.setEmployeeId(rs.getLong(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID]));
            entEmpAssessment.setAssessmentId(rs.getLong(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_ASSESSMENT_ID]));
            entEmpAssessment.setScore(rs.getDouble(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_SCORE]));
            entEmpAssessment.setDateOfAssessment(rs.getDate(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_DATE_OF_ASSESSMENT]));
            entEmpAssessment.setRemark(rs.getString(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_REMARK]));
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
            String sql = "SELECT * FROM " + TBL_EMP_ASSESSMENT;
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
                EmpAssessment entEmpAssessment = new EmpAssessment();
                resultToObject(rs, entEmpAssessment);
                lists.add(entEmpAssessment);
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

    public static boolean checkOID(long entEmpAssessmentId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_ASSESSMENT + " WHERE "
                    + PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID] + " = " + entEmpAssessmentId;
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
            String sql = "SELECT COUNT(" + PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID] + ") FROM " + TBL_EMP_ASSESSMENT;
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
                    EmpAssessment entEmpAssessment = (EmpAssessment) list.get(ls);
                    if (oid == entEmpAssessment.getOID()) {
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
    
    public static Hashtable<String, Float> listSumEmpAssessment(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable<String, Float> lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " +fieldNames[FLD_EMPLOYEE_ID]+", "
					+ "SUM(IF(REQ."+PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_BOBOT]
					+" > 0, (REQ."+PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_BOBOT]+" / 100) * "
					+ fieldNames[FLD_SCORE]+", "+ fieldNames[FLD_SCORE]+") ) AS SUM_ASS FROM " + TBL_EMP_ASSESSMENT
					+ " LEFT JOIN "+PstCandidatePositionAssessment.TBL_CANDIDATE_POSITION_ASSESSMENT+" REQ ON "
					+ TBL_EMP_ASSESSMENT+"."+fieldNames[FLD_ASSESSMENT_ID]+" = REQ."+PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_ASSESSMENT_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            sql=sql + " GROUP BY "+ fieldNames[FLD_EMPLOYEE_ID]+ " ";
            
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
                String empId = ""+rs.getLong(PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID]);
                Float sumComp = (rs.getFloat("SUM_ASS"));
                lists.put(empId, sumComp);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new  Hashtable();
    }
    
}
