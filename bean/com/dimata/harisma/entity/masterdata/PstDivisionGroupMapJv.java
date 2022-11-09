/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author gndiw
 */

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

public class PstDivisionGroupMapJv extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    public static final String TBL_DIVISION_GROUP_MAP_JV = "hr_division_group_map_jv";
    public static final int FLD_DIVISION_GROUP_MAP_ID = 0;
    public static final int FLD_DIVISION_GROUP_ID = 1;
    public static final int FLD_DIVISION_CODE_ID = 2;
    public static final int FLD_ACCOUNT_NAME = 3;
    public static final int FLD_ACCOUNT_NUMBER = 4;
    public static String[] fieldNames = {
        "DIVISION_GROUP_MAP_ID",
        "DIVISION_GROUP_ID",
        "DIVISION_CODE_ID",
        "ACCOUNT_NAME",
        "ACCOUNT_NUMBER"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public PstDivisionGroupMapJv() {
    }

    public PstDivisionGroupMapJv(int i) throws DBException {
        super(new PstDivisionGroupMapJv());
    }

    public PstDivisionGroupMapJv(String sOid) throws DBException {
        super(new PstDivisionGroupMapJv(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDivisionGroupMapJv(long lOid) throws DBException {
        super(new PstDivisionGroupMapJv(0));
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
        return TBL_DIVISION_GROUP_MAP_JV;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDivisionGroupMapJv().getClass().getName();
    }

    public static DivisionGroupMapJv fetchExc(long oid) throws DBException {
        try {
            DivisionGroupMapJv entDivisionGroupMapJv = new DivisionGroupMapJv();
            PstDivisionGroupMapJv pstDivisionGroupMapJv = new PstDivisionGroupMapJv(oid);
            entDivisionGroupMapJv.setOID(oid);
            entDivisionGroupMapJv.setDivisionGroupCodeId(pstDivisionGroupMapJv.getlong(FLD_DIVISION_GROUP_ID));
            entDivisionGroupMapJv.setDivisionCodeId(pstDivisionGroupMapJv.getlong(FLD_DIVISION_CODE_ID));
            entDivisionGroupMapJv.setAccountName(pstDivisionGroupMapJv.getString(FLD_ACCOUNT_NAME));
            entDivisionGroupMapJv.setAccountNumber(pstDivisionGroupMapJv.getString(FLD_ACCOUNT_NUMBER));
            return entDivisionGroupMapJv;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupMapJv(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        DivisionGroupMapJv entDivisionGroupMapJv = fetchExc(entity.getOID());
        entity = (Entity) entDivisionGroupMapJv;
        return entDivisionGroupMapJv.getOID();
    }

    public static synchronized long updateExc(DivisionGroupMapJv entDivisionGroupMapJv) throws DBException {
        try {
            if (entDivisionGroupMapJv.getOID() != 0) {
                PstDivisionGroupMapJv pstDivisionGroupMapJv = new PstDivisionGroupMapJv(entDivisionGroupMapJv.getOID());
                pstDivisionGroupMapJv.setLong(FLD_DIVISION_GROUP_ID, entDivisionGroupMapJv.getDivisionGroupCodeId());
                pstDivisionGroupMapJv.setLong(FLD_DIVISION_CODE_ID, entDivisionGroupMapJv.getDivisionCodeId());
                pstDivisionGroupMapJv.setString(FLD_ACCOUNT_NAME, entDivisionGroupMapJv.getAccountName());
                pstDivisionGroupMapJv.setString(FLD_ACCOUNT_NUMBER, entDivisionGroupMapJv.getAccountNumber());
                pstDivisionGroupMapJv.update();
                return entDivisionGroupMapJv.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupMapJv(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((DivisionGroupMapJv) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstDivisionGroupMapJv pstDivisionGroupMapJv = new PstDivisionGroupMapJv(oid);
            pstDivisionGroupMapJv.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupMapJv(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(DivisionGroupMapJv entDivisionGroupMapJv) throws DBException {
        try {
            PstDivisionGroupMapJv pstDivisionGroupMapJv = new PstDivisionGroupMapJv(0);
            pstDivisionGroupMapJv.setLong(FLD_DIVISION_GROUP_ID, entDivisionGroupMapJv.getDivisionGroupCodeId());
            pstDivisionGroupMapJv.setLong(FLD_DIVISION_CODE_ID, entDivisionGroupMapJv.getDivisionCodeId());
            pstDivisionGroupMapJv.setString(FLD_ACCOUNT_NAME, entDivisionGroupMapJv.getAccountName());
            pstDivisionGroupMapJv.setString(FLD_ACCOUNT_NUMBER, entDivisionGroupMapJv.getAccountNumber());
            pstDivisionGroupMapJv.insert();
            entDivisionGroupMapJv.setOID(pstDivisionGroupMapJv.getLong(FLD_DIVISION_GROUP_MAP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDivisionGroupMapJv(0), DBException.UNKNOWN);
        }
        return entDivisionGroupMapJv.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((DivisionGroupMapJv) entity);
    }

    public static void resultToObject(ResultSet rs, DivisionGroupMapJv entDivisionGroupMapJv) {
        try {
            entDivisionGroupMapJv.setOID(rs.getLong(PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_GROUP_MAP_ID]));
            entDivisionGroupMapJv.setDivisionGroupCodeId(rs.getLong(PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_GROUP_ID]));
            entDivisionGroupMapJv.setDivisionCodeId(rs.getLong(PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_CODE_ID]));
            entDivisionGroupMapJv.setAccountName(rs.getString(PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_ACCOUNT_NAME]));
            entDivisionGroupMapJv.setAccountNumber(rs.getString(PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_ACCOUNT_NUMBER]));
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
            String sql = "SELECT * FROM " + TBL_DIVISION_GROUP_MAP_JV;
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
                DivisionGroupMapJv entDivisionGroupMapJv = new DivisionGroupMapJv();
                resultToObject(rs, entDivisionGroupMapJv);
                lists.add(entDivisionGroupMapJv);
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

    public static boolean checkOID(long entDivisionGroupMapJvId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_DIVISION_GROUP_MAP_JV + " WHERE "
                    + PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_GROUP_MAP_ID] + " = " + entDivisionGroupMapJvId;
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
            String sql = "SELECT COUNT(" + PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_GROUP_MAP_ID] + ") FROM " + TBL_DIVISION_GROUP_MAP_JV;
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
                    DivisionGroupMapJv entDivisionGroupMapJv = (DivisionGroupMapJv) list.get(ls);
                    if (oid == entDivisionGroupMapJv.getOID()) {
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
