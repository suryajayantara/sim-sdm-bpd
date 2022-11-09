/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;

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

public class PstOutSourceIndicator extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_OUTSOURCEINDICATOR = "hr_out_indicator";
    public static final int FLD_OUT_INDICATOR_ID = 0;
    public static final int FLD_INDICATOR_NAME = 1;

    public static String[] fieldNames = {
        "OUT_INDICATOR_ID",
        "INDICATOR_NAME"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING
    };

    public PstOutSourceIndicator() {
    }

    public PstOutSourceIndicator(int i) throws DBException {
        super(new PstOutSourceIndicator());
    }

    public PstOutSourceIndicator(String sOid) throws DBException {
        super(new PstOutSourceIndicator(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstOutSourceIndicator(long lOid) throws DBException {
        super(new PstOutSourceIndicator(0));
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
        return TBL_OUTSOURCEINDICATOR;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstOutSourceIndicator().getClass().getName();
    }

    public static OutSourceIndicator fetchExc(long oid) throws DBException {
        try {
            OutSourceIndicator entOutSourceIndicator = new OutSourceIndicator();
            PstOutSourceIndicator pstOutSourceIndicator = new PstOutSourceIndicator(oid);
            entOutSourceIndicator.setOID(oid);
            entOutSourceIndicator.setIndicatorName(pstOutSourceIndicator.getString(FLD_INDICATOR_NAME));
            return entOutSourceIndicator;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstOutSourceIndicator(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        OutSourceIndicator entOutSourceIndicator = fetchExc(entity.getOID());
        entity = (Entity) entOutSourceIndicator;
        return entOutSourceIndicator.getOID();
    }

    public static synchronized long updateExc(OutSourceIndicator entOutSourceIndicator) throws DBException {
        try {
            if (entOutSourceIndicator.getOID() != 0) {
                PstOutSourceIndicator pstOutSourceIndicator = new PstOutSourceIndicator(entOutSourceIndicator.getOID());
                pstOutSourceIndicator.setString(FLD_INDICATOR_NAME, entOutSourceIndicator.getIndicatorName());
                pstOutSourceIndicator.update();
                return entOutSourceIndicator.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstOutSourceIndicator(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((OutSourceIndicator) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstOutSourceIndicator pstOutSourceIndicator = new PstOutSourceIndicator(oid);
            pstOutSourceIndicator.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstOutSourceIndicator(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(OutSourceIndicator entOutSourceIndicator) throws DBException {
        try {
            PstOutSourceIndicator pstOutSourceIndicator = new PstOutSourceIndicator(0);
            pstOutSourceIndicator.setString(FLD_INDICATOR_NAME, entOutSourceIndicator.getIndicatorName());
            pstOutSourceIndicator.insert();
            entOutSourceIndicator.setOID(pstOutSourceIndicator.getLong(FLD_OUT_INDICATOR_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstOutSourceIndicator(0), DBException.UNKNOWN);
        }
        return entOutSourceIndicator.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((OutSourceIndicator) entity);
    }

    public static void resultToObject(ResultSet rs, OutSourceIndicator entOutSourceIndicator) {
        try {
            entOutSourceIndicator.setOID(rs.getLong(PstOutSourceIndicator.fieldNames[PstOutSourceIndicator.FLD_OUT_INDICATOR_ID]));
            entOutSourceIndicator.setIndicatorName(rs.getString(PstOutSourceIndicator.fieldNames[PstOutSourceIndicator.FLD_INDICATOR_NAME]));
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
            String sql = "SELECT * FROM " + TBL_OUTSOURCEINDICATOR;
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
                OutSourceIndicator entOutSourceIndicator = new OutSourceIndicator();
                resultToObject(rs, entOutSourceIndicator);
                lists.add(entOutSourceIndicator);
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

    public static boolean checkOID(long entOutSourceIndicatorId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_OUTSOURCEINDICATOR + " WHERE "
                    + PstOutSourceIndicator.fieldNames[PstOutSourceIndicator.FLD_OUT_INDICATOR_ID] + " = " + entOutSourceIndicatorId;
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
            String sql = "SELECT COUNT(" + PstOutSourceIndicator.fieldNames[PstOutSourceIndicator.FLD_OUT_INDICATOR_ID] + ") FROM " + TBL_OUTSOURCEINDICATOR;
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
                    OutSourceIndicator entOutSourceIndicator = (OutSourceIndicator) list.get(ls);
                    if (oid == entOutSourceIndicator.getOID()) {
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
        } else if (start == (vectSize - recordToGet)) {
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
        return cmd;
    }
}
