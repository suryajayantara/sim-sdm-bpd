/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstCandidateResult extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATERESULT = "hr_candidate_result";
    public static final int FLD_CANDIDATE_RESULT_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_EMPLOYEE_ID = 2;
    public static final int FLD_POSITION_TYPE_ID = 3;

    public static String[] fieldNames = {
        "CANDIDATE_RESULT_ID",
        "CANDIDATE_MAIN_ID",
        "EMPLOYEE_ID",
        "POSITION_TYPE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstCandidateResult() {
    }

    public PstCandidateResult(int i) throws DBException {
        super(new PstCandidateResult());
    }

    public PstCandidateResult(String sOid) throws DBException {
        super(new PstCandidateResult(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidateResult(long lOid) throws DBException {
        super(new PstCandidateResult(0));
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
        return TBL_CANDIDATERESULT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidateResult().getClass().getName();
    }

    public static CandidateResult fetchExc(long oid) throws DBException {
        try {
            CandidateResult entCandidateResult = new CandidateResult();
            PstCandidateResult pstCandidateResult = new PstCandidateResult(oid);
            entCandidateResult.setOID(oid);
            entCandidateResult.setCandidateMainId(pstCandidateResult.getlong(FLD_CANDIDATE_MAIN_ID));
            entCandidateResult.setEmployeeId(pstCandidateResult.getlong(FLD_EMPLOYEE_ID));
            entCandidateResult.setPositionTypeId(pstCandidateResult.getlong(FLD_POSITION_TYPE_ID));
            return entCandidateResult;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidateResult(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidateResult entCandidateResult = fetchExc(entity.getOID());
        entity = (Entity) entCandidateResult;
        return entCandidateResult.getOID();
    }

    public static synchronized long updateExc(CandidateResult entCandidateResult) throws DBException {
        try {
            if (entCandidateResult.getOID() != 0) {
                PstCandidateResult pstCandidateResult = new PstCandidateResult(entCandidateResult.getOID());
                pstCandidateResult.setLong(FLD_CANDIDATE_MAIN_ID, entCandidateResult.getCandidateMainId());
                pstCandidateResult.setLong(FLD_EMPLOYEE_ID, entCandidateResult.getEmployeeId());
                pstCandidateResult.setLong(FLD_POSITION_TYPE_ID, entCandidateResult.getPositionTypeId());
                pstCandidateResult.update();
                return entCandidateResult.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidateResult(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidateResult) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidateResult pstCandidateResult = new PstCandidateResult(oid);
            pstCandidateResult.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidateResult(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidateResult entCandidateResult) throws DBException {
        try {
            PstCandidateResult pstCandidateResult = new PstCandidateResult(0);
            pstCandidateResult.setLong(FLD_CANDIDATE_MAIN_ID, entCandidateResult.getCandidateMainId());
            pstCandidateResult.setLong(FLD_EMPLOYEE_ID, entCandidateResult.getEmployeeId());
            pstCandidateResult.setLong(FLD_POSITION_TYPE_ID, entCandidateResult.getPositionTypeId());
            pstCandidateResult.insert();
            entCandidateResult.setOID(pstCandidateResult.getlong(FLD_CANDIDATE_MAIN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidateResult(0), DBException.UNKNOWN);
        }
        return entCandidateResult.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidateResult) entity);
    }

    public static void resultToObject(ResultSet rs, CandidateResult entCandidateResult) {
        try {
            entCandidateResult.setOID(rs.getLong(PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_RESULT_ID]));
            entCandidateResult.setCandidateMainId(rs.getLong(PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]));
            entCandidateResult.setEmployeeId(rs.getLong(PstCandidateResult.fieldNames[PstCandidateResult.FLD_EMPLOYEE_ID]));
            entCandidateResult.setPositionTypeId(rs.getLong(PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]));
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
            String sql = "SELECT * FROM " + TBL_CANDIDATERESULT;
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
                CandidateResult entCandidateResult = new CandidateResult();
                resultToObject(rs, entCandidateResult);
                lists.add(entCandidateResult);
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

    public static boolean checkOID(long entCandidateResultId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATERESULT + " WHERE "
                    + PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID] + " = " + entCandidateResultId;
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
            String sql = "SELECT COUNT(" + PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID] + ") FROM " + TBL_CANDIDATERESULT;
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
                    CandidateResult entCandidateResult = (CandidateResult) list.get(ls);
                    if (oid == entCandidateResult.getOID()) {
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