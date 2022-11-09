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
public class PstPositionTypeMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POSITION_TYPE_MAPPING = "hr_position_type_mapping";
    public static final int FLD_POSITION_TYPE_MAPPING_ID = 0;
    public static final int FLD_LEVEL_ID = 1;
    public static final int FLD_POSITION_TYPE_ID = 2;

    public static String[] fieldNames = {
        "POSITION_TYPE_MAPPING_ID",
        "LEVEL_ID",
        "POSITION_TYPE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstPositionTypeMapping() {
    }

    public PstPositionTypeMapping(int i) throws DBException {
        super(new PstPositionTypeMapping());
    }

    public PstPositionTypeMapping(String sOid) throws DBException {
        super(new PstPositionTypeMapping(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPositionTypeMapping(long lOid) throws DBException {
        super(new PstPositionTypeMapping(0));
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
        return TBL_POSITION_TYPE_MAPPING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPositionTypeMapping().getClass().getName();
    }

    public static PositionTypeMapping fetchExc(long oid) throws DBException {
        try {
            PositionTypeMapping entPositionTypeMapping = new PositionTypeMapping();
            PstPositionTypeMapping pstPositionTypeMapping = new PstPositionTypeMapping(oid);
            entPositionTypeMapping.setOID(oid);
            entPositionTypeMapping.setLevelId(pstPositionTypeMapping.getlong(FLD_LEVEL_ID));
            entPositionTypeMapping.setPositionTypeId(pstPositionTypeMapping.getlong(FLD_POSITION_TYPE_ID));
            return entPositionTypeMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionTypeMapping(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        PositionTypeMapping entPositionTypeMapping = fetchExc(entity.getOID());
        entity = (Entity) entPositionTypeMapping;
        return entPositionTypeMapping.getOID();
    }

    public static synchronized long updateExc(PositionTypeMapping entPositionTypeMapping) throws DBException {
        try {
            if (entPositionTypeMapping.getOID() != 0) {
                PstPositionTypeMapping pstPositionTypeMapping = new PstPositionTypeMapping(entPositionTypeMapping.getOID());
                pstPositionTypeMapping.setLong(FLD_LEVEL_ID, entPositionTypeMapping.getLevelId());
                pstPositionTypeMapping.setLong(FLD_POSITION_TYPE_ID, entPositionTypeMapping.getPositionTypeId());
                pstPositionTypeMapping.update();
                return entPositionTypeMapping.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionTypeMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((PositionTypeMapping) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstPositionTypeMapping pstPositionTypeMapping = new PstPositionTypeMapping(oid);
            pstPositionTypeMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionTypeMapping(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(PositionTypeMapping entPositionTypeMapping) throws DBException {
        try {
            PstPositionTypeMapping pstPositionTypeMapping = new PstPositionTypeMapping(0);
            pstPositionTypeMapping.setLong(FLD_LEVEL_ID, entPositionTypeMapping.getLevelId());
            pstPositionTypeMapping.setLong(FLD_POSITION_TYPE_ID, entPositionTypeMapping.getPositionTypeId());
            pstPositionTypeMapping.insert();
            entPositionTypeMapping.setOID(pstPositionTypeMapping.getlong(FLD_POSITION_TYPE_MAPPING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionTypeMapping(0), DBException.UNKNOWN);
        }
        return entPositionTypeMapping.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((PositionTypeMapping) entity);
    }

    public static void resultToObject(ResultSet rs, PositionTypeMapping entPositionTypeMapping) {
        try {
            entPositionTypeMapping.setOID(rs.getLong(PstPositionTypeMapping.fieldNames[PstPositionTypeMapping.FLD_POSITION_TYPE_MAPPING_ID]));
            entPositionTypeMapping.setLevelId(rs.getLong(PstPositionTypeMapping.fieldNames[PstPositionTypeMapping.FLD_LEVEL_ID]));
            entPositionTypeMapping.setPositionTypeId(rs.getLong(PstPositionTypeMapping.fieldNames[PstPositionTypeMapping.FLD_POSITION_TYPE_ID]));
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
            String sql = "SELECT * FROM " + TBL_POSITION_TYPE_MAPPING;
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
                PositionTypeMapping entPositionTypeMapping = new PositionTypeMapping();
                resultToObject(rs, entPositionTypeMapping);
                lists.add(entPositionTypeMapping);
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

    public static boolean checkOID(long entPositionTypeMappingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POSITION_TYPE_MAPPING + " WHERE "
                    + PstPositionTypeMapping.fieldNames[PstPositionTypeMapping.FLD_POSITION_TYPE_MAPPING_ID] + " = " + entPositionTypeMappingId;
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
            String sql = "SELECT COUNT(" + PstPositionTypeMapping.fieldNames[PstPositionTypeMapping.FLD_POSITION_TYPE_MAPPING_ID] + ") FROM " + TBL_POSITION_TYPE_MAPPING;
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
                    PositionTypeMapping entPositionTypeMapping = (PositionTypeMapping) list.get(ls);
                    if (oid == entPositionTypeMapping.getOID()) {
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
