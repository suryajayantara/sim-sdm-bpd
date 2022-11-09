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
public class PstAssessment extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_ASSESSMENT = "hr_assessment_type";
    public static final int FLD_ASSESSMENT_ID = 0;
    public static final int FLD_ASSESSMENT_TYPE = 1;
    public static final int FLD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "ASSESSMENT_ID",
        "ASSESSMENT_TYPE",
        "DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstAssessment() {
    }

    public PstAssessment(int i) throws DBException {
        super(new PstAssessment());
    }

    public PstAssessment(String sOid) throws DBException {
        super(new PstAssessment(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstAssessment(long lOid) throws DBException {
        super(new PstAssessment(0));
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
        return TBL_ASSESSMENT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstAssessment().getClass().getName();
    }

    public static Assessment fetchExc(long oid) throws DBException {
        try {
            Assessment entAssessment = new Assessment();
            PstAssessment pstAssessment = new PstAssessment(oid);
            entAssessment.setOID(oid);
            entAssessment.setAssessmentType(pstAssessment.getString(FLD_ASSESSMENT_TYPE));
            entAssessment.setDescription(pstAssessment.getString(FLD_DESCRIPTION));
            return entAssessment;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessment(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Assessment entAssessment = fetchExc(entity.getOID());
        entity = (Entity) entAssessment;
        return entAssessment.getOID();
    }

    public static synchronized long updateExc(Assessment entAssessment) throws DBException {
        try {
            if (entAssessment.getOID() != 0) {
                PstAssessment pstAssessment = new PstAssessment(entAssessment.getOID());
                pstAssessment.setString(FLD_ASSESSMENT_TYPE, entAssessment.getAssessmentType());
                pstAssessment.setString(FLD_DESCRIPTION, entAssessment.getDescription());
                pstAssessment.update();
                return entAssessment.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessment(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Assessment) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstAssessment pstAssessment = new PstAssessment(oid);
            pstAssessment.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessment(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Assessment entAssessment) throws DBException {
        try {
            PstAssessment pstAssessment = new PstAssessment(0);
            pstAssessment.setString(FLD_ASSESSMENT_TYPE, entAssessment.getAssessmentType());
            pstAssessment.setString(FLD_DESCRIPTION, entAssessment.getDescription());
            pstAssessment.insert();
            entAssessment.setOID(pstAssessment.getlong(FLD_ASSESSMENT_TYPE));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessment(0), DBException.UNKNOWN);
        }
        return entAssessment.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Assessment) entity);
    }

    public static void resultToObject(ResultSet rs, Assessment entAssessment) {
        try {
            entAssessment.setOID(rs.getLong(PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_ID]));
            entAssessment.setAssessmentType(rs.getString(PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE]));
            entAssessment.setDescription(rs.getString(PstAssessment.fieldNames[PstAssessment.FLD_DESCRIPTION]));
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
            String sql = "SELECT * FROM " + TBL_ASSESSMENT;
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
                Assessment entAssessment = new Assessment();
                resultToObject(rs, entAssessment);
                lists.add(entAssessment);
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

    public static boolean checkOID(long entAssessmentId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_ASSESSMENT + " WHERE "
                    + PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE] + " = " + entAssessmentId;
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
            String sql = "SELECT COUNT(" + PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE] + ") FROM " + TBL_ASSESSMENT;
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
                    Assessment entAssessment = (Assessment) list.get(ls);
                    if (oid == entAssessment.getOID()) {
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
