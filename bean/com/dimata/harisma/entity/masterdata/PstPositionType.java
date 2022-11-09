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
public class PstPositionType extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POSITION_TYPE = "hr_position_type";
    public static final int FLD_POSITION_TYPE_ID = 0;
    public static final int FLD_TYPE = 1;
    public static final int FLD_DESC = 2;

    public static String[] fieldNames = {
        "POSITION_TYPE_ID",
        "TYPE",
        "DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstPositionType() {
    }

    public PstPositionType(int i) throws DBException {
        super(new PstPositionType());
    }

    public PstPositionType(String sOid) throws DBException {
        super(new PstPositionType(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPositionType(long lOid) throws DBException {
        super(new PstPositionType(0));
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
        return TBL_POSITION_TYPE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPositionType().getClass().getName();
    }

    public static PositionType fetchExc(long oid) throws DBException {
        try {
            PositionType entPositionType = new PositionType();
            PstPositionType pstPositionType = new PstPositionType(oid);
            entPositionType.setOID(oid);
            entPositionType.setType(pstPositionType.getString(FLD_TYPE));
            entPositionType.setDesc(pstPositionType.getString(FLD_DESC));
            return entPositionType;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionType(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        PositionType entPositionType = fetchExc(entity.getOID());
        entity = (Entity) entPositionType;
        return entPositionType.getOID();
    }

    public static synchronized long updateExc(PositionType entPositionType) throws DBException {
        try {
            if (entPositionType.getOID() != 0) {
                PstPositionType pstPositionType = new PstPositionType(entPositionType.getOID());
                pstPositionType.setString(FLD_TYPE, entPositionType.getType());
                pstPositionType.setString(FLD_DESC, entPositionType.getDesc());
                pstPositionType.update();
                return entPositionType.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionType(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((PositionType) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstPositionType pstPositionType = new PstPositionType(oid);
            pstPositionType.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionType(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(PositionType entPositionType) throws DBException {
        try {
            PstPositionType pstPositionType = new PstPositionType(0);
            pstPositionType.setString(FLD_TYPE, entPositionType.getType());
            pstPositionType.setString(FLD_DESC, entPositionType.getDesc());
            pstPositionType.insert();
            entPositionType.setOID(pstPositionType.getlong(FLD_TYPE));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionType(0), DBException.UNKNOWN);
        }
        return entPositionType.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((PositionType) entity);
    }

    public static void resultToObject(ResultSet rs, PositionType entPositionType) {
        try {
            entPositionType.setOID(rs.getLong(PstPositionType.fieldNames[PstPositionType.FLD_POSITION_TYPE_ID]));
            entPositionType.setType(rs.getString(PstPositionType.fieldNames[PstPositionType.FLD_TYPE]));
            entPositionType.setDesc(rs.getString(PstPositionType.fieldNames[PstPositionType.FLD_DESC]));
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
            String sql = "SELECT * FROM " + TBL_POSITION_TYPE;
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
                PositionType entPositionType = new PositionType();
                resultToObject(rs, entPositionType);
                lists.add(entPositionType);
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
    
    public static Vector listJoin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ty.* FROM `hr_position_type` ty INNER JOIN `hr_position_type_mapping` map ON ty.`POSITION_TYPE_ID` = map.`POSITION_TYPE_ID`";
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
                PositionType entPositionType = new PositionType();
                resultToObject(rs, entPositionType);
                lists.add(entPositionType);
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

    public static boolean checkOID(long entPositionTypeId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POSITION_TYPE + " WHERE "
                    + PstPositionType.fieldNames[PstPositionType.FLD_TYPE] + " = " + entPositionTypeId;
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
            String sql = "SELECT COUNT(" + PstPositionType.fieldNames[PstPositionType.FLD_TYPE] + ") FROM " + TBL_POSITION_TYPE;
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
                    PositionType entPositionType = (PositionType) list.get(ls);
                    if (oid == entPositionType.getOID()) {
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
