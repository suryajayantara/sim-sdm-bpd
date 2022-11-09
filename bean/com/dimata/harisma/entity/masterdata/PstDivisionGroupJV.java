/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

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
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstDivisionGroupJV extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    public static final String TBL_DIVISION_GROUP_JV = "hr_division_group_jv";
    public static final int FLD_DIVISION_GROUP_ID = 0;
    public static final int FLD_DIVISION_GROUP_CODE = 1;
    public static String[] fieldNames = {
        "DIVISION_GROUP_ID",
        "DIVISION_GROUP_CODE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING
    };
    
    public PstDivisionGroupJV() {
    }

    public PstDivisionGroupJV(int i) throws DBException {
        super(new PstDivisionGroupJV());
    }

    public PstDivisionGroupJV(String sOid) throws DBException {
        super(new PstDivisionGroupJV(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDivisionGroupJV(long lOid) throws DBException {
        super(new PstDivisionGroupJV(0));
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
        return TBL_DIVISION_GROUP_JV;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDivisionGroupJV().getClass().getName();
    }

    public static DivisionGroupJV fetchExc(long oid) throws DBException {
        try {
            DivisionGroupJV entDivisionGroupJV = new DivisionGroupJV();
            PstDivisionGroupJV pstDivisionGroupJV = new PstDivisionGroupJV(oid);
            entDivisionGroupJV.setOID(oid);
            entDivisionGroupJV.setDivisionGroup(pstDivisionGroupJV.getString(FLD_DIVISION_GROUP_CODE));
            return entDivisionGroupJV;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupJV(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        DivisionGroupJV entDivisionGroupJV = fetchExc(entity.getOID());
        entity = (Entity) entDivisionGroupJV;
        return entDivisionGroupJV.getOID();
    }

    public static synchronized long updateExc(DivisionGroupJV entDivisionGroupJV) throws DBException {
        try {
            if (entDivisionGroupJV.getOID() != 0) {
                PstDivisionGroupJV pstDivisionGroupJV = new PstDivisionGroupJV(entDivisionGroupJV.getOID());
                pstDivisionGroupJV.setString(FLD_DIVISION_GROUP_CODE, entDivisionGroupJV.getDivisionGroupCode());
                pstDivisionGroupJV.update();
                return entDivisionGroupJV.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupJV(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((DivisionGroupJV) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstDivisionGroupJV pstDivisionGroupJV = new PstDivisionGroupJV(oid);
            pstDivisionGroupJV.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupJV(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(DivisionGroupJV entDivisionGroupJV) throws DBException {
        try {
            PstDivisionGroupJV pstDivisionGroupJV = new PstDivisionGroupJV(0);
            pstDivisionGroupJV.setString(FLD_DIVISION_GROUP_CODE, entDivisionGroupJV.getDivisionGroupCode());
            pstDivisionGroupJV.insert();
            entDivisionGroupJV.setOID(pstDivisionGroupJV.getLong(FLD_DIVISION_GROUP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupJV(0), DBException.UNKNOWN);
        }
        return entDivisionGroupJV.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((DivisionGroupJV) entity);
    }

    public static void resultToObject(ResultSet rs, DivisionGroupJV entDivisionGroupJV) {
        try {
            entDivisionGroupJV.setOID(rs.getLong(PstDivisionGroupJV.fieldNames[PstDivisionGroupJV.FLD_DIVISION_GROUP_ID]));
            entDivisionGroupJV.setDivisionGroup(rs.getString(PstDivisionGroupJV.fieldNames[PstDivisionGroupJV.FLD_DIVISION_GROUP_CODE]));
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
            String sql = "SELECT * FROM " + TBL_DIVISION_GROUP_JV;
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
                DivisionGroupJV entDivisionGroupJV = new DivisionGroupJV();
                resultToObject(rs, entDivisionGroupJV);
                lists.add(entDivisionGroupJV);
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

    public static boolean checkOID(long entDivisionGroupJVId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_DIVISION_GROUP_JV + " WHERE "
                    + PstDivisionGroupJV.fieldNames[PstDivisionGroupJV.FLD_DIVISION_GROUP_ID] + " = " + entDivisionGroupJVId;
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
            String sql = "SELECT COUNT(" + PstDivisionGroupJV.fieldNames[PstDivisionGroupJV.FLD_DIVISION_GROUP_ID] + ") FROM " + TBL_DIVISION_GROUP_JV;
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
                    DivisionGroupJV entDivisionGroupJV = (DivisionGroupJV) list.get(ls);
                    if (oid == entDivisionGroupJV.getOID()) {
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
