/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Acer
 */

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstTrainingArea extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_TRAININGAREA = "hr_training_area";
    public static final int FLD_TRAINING_AREA_ID = 0;
    public static final int FLD_AREA_NAME = 1;
    public static final int FLD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "TRAINING_AREA_ID",
        "AREA_NAME",
        "DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstTrainingArea() {
    }

    public PstTrainingArea(int i) throws DBException {
        super(new PstTrainingArea());
    }

    public PstTrainingArea(String sOid) throws DBException {
        super(new PstTrainingArea(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingArea(long lOid) throws DBException {
        super(new PstTrainingArea(0));
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
        return TBL_TRAININGAREA;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingArea().getClass().getName();
    }

    public static TrainingArea fetchExc(long oid) throws DBException {
        try {
            TrainingArea entTrainingArea = new TrainingArea();
            PstTrainingArea pstTrainingArea = new PstTrainingArea(oid);
            entTrainingArea.setOID(oid);
            entTrainingArea.setAreaName(pstTrainingArea.getString(FLD_AREA_NAME));
            entTrainingArea.setDescription(pstTrainingArea.getString(FLD_DESCRIPTION));
            return entTrainingArea;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingArea(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingArea entTrainingArea = fetchExc(entity.getOID());
        entity = (Entity) entTrainingArea;
        return entTrainingArea.getOID();
    }

    public static synchronized long updateExc(TrainingArea entTrainingArea) throws DBException {
        try {
            if (entTrainingArea.getOID() != 0) {
                PstTrainingArea pstTrainingArea = new PstTrainingArea(entTrainingArea.getOID());
                pstTrainingArea.setString(FLD_AREA_NAME, entTrainingArea.getAreaName());
                pstTrainingArea.setString(FLD_DESCRIPTION, entTrainingArea.getDescription());
                pstTrainingArea.update();
                return entTrainingArea.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingArea(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingArea) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingArea pstTrainingArea = new PstTrainingArea(oid);
            pstTrainingArea.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingArea(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingArea entTrainingArea) throws DBException {
        try {
            PstTrainingArea pstTrainingArea = new PstTrainingArea(0);
            pstTrainingArea.setString(FLD_AREA_NAME, entTrainingArea.getAreaName());
            pstTrainingArea.setString(FLD_DESCRIPTION, entTrainingArea.getDescription());
            pstTrainingArea.insert();
            entTrainingArea.setOID(pstTrainingArea.getLong(FLD_TRAINING_AREA_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingArea(0), DBException.UNKNOWN);
        }
        return entTrainingArea.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingArea) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingArea entTrainingArea) {
        try {
            entTrainingArea.setOID(rs.getLong(PstTrainingArea.fieldNames[PstTrainingArea.FLD_TRAINING_AREA_ID]));
            entTrainingArea.setAreaName(rs.getString(PstTrainingArea.fieldNames[PstTrainingArea.FLD_AREA_NAME]));
            entTrainingArea.setDescription(rs.getString(PstTrainingArea.fieldNames[PstTrainingArea.FLD_DESCRIPTION]));
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
            String sql = "SELECT * FROM " + TBL_TRAININGAREA;
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
                TrainingArea entTrainingArea = new TrainingArea();
                resultToObject(rs, entTrainingArea);
                lists.add(entTrainingArea);
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

    public static boolean checkOID(long entTrainingAreaId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAININGAREA + " WHERE "
                    + PstTrainingArea.fieldNames[PstTrainingArea.FLD_TRAINING_AREA_ID] + " = " + entTrainingAreaId;
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
            String sql = "SELECT COUNT(" + PstTrainingArea.fieldNames[PstTrainingArea.FLD_TRAINING_AREA_ID] + ") FROM " + TBL_TRAININGAREA;
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
                    TrainingArea entTrainingArea = (TrainingArea) list.get(ls);
                    if (oid == entTrainingArea.getOID()) {
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
