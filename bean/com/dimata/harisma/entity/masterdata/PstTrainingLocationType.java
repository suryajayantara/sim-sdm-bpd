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

public class PstTrainingLocationType extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_TRAININGLOCATIONTYPE = "hr_training_location_type";
    public static final int FLD_TRAINING_LOCATION_TYPE_ID = 0;
    public static final int FLD_LOCATION_NAME = 1;
    public static final int FLD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "TRAINING_LOCATION_TYPE_ID",
        "LOCATION_NAME",
        "DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstTrainingLocationType() {
    }

    public PstTrainingLocationType(int i) throws DBException {
        super(new PstTrainingLocationType());
    }

    public PstTrainingLocationType(String sOid) throws DBException {
        super(new PstTrainingLocationType(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingLocationType(long lOid) throws DBException {
        super(new PstTrainingLocationType(0));
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
        return TBL_TRAININGLOCATIONTYPE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingLocationType().getClass().getName();
    }

    public static TrainingLocationType fetchExc(long oid) throws DBException {
        try {
            TrainingLocationType entTrainingLocationType = new TrainingLocationType();
            PstTrainingLocationType pstTrainingLocationType = new PstTrainingLocationType(oid);
            entTrainingLocationType.setOID(oid);
            entTrainingLocationType.setLocationName(pstTrainingLocationType.getString(FLD_LOCATION_NAME));
            entTrainingLocationType.setDescription(pstTrainingLocationType.getString(FLD_DESCRIPTION));
            return entTrainingLocationType;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingLocationType(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingLocationType entTrainingLocationType = fetchExc(entity.getOID());
        entity = (Entity) entTrainingLocationType;
        return entTrainingLocationType.getOID();
    }

    public static synchronized long updateExc(TrainingLocationType entTrainingLocationType) throws DBException {
        try {
            if (entTrainingLocationType.getOID() != 0) {
                PstTrainingLocationType pstTrainingLocationType = new PstTrainingLocationType(entTrainingLocationType.getOID());
                pstTrainingLocationType.setString(FLD_LOCATION_NAME, entTrainingLocationType.getLocationName());
                pstTrainingLocationType.setString(FLD_DESCRIPTION, entTrainingLocationType.getDescription());
                pstTrainingLocationType.update();
                return entTrainingLocationType.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingLocationType(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingLocationType) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingLocationType pstTrainingLocationType = new PstTrainingLocationType(oid);
            pstTrainingLocationType.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingLocationType(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingLocationType entTrainingLocationType) throws DBException {
        try {
            PstTrainingLocationType pstTrainingLocationType = new PstTrainingLocationType(0);
            pstTrainingLocationType.setString(FLD_LOCATION_NAME, entTrainingLocationType.getLocationName());
            pstTrainingLocationType.setString(FLD_DESCRIPTION, entTrainingLocationType.getDescription());
            pstTrainingLocationType.insert();
            entTrainingLocationType.setOID(pstTrainingLocationType.getLong(FLD_TRAINING_LOCATION_TYPE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingLocationType(0), DBException.UNKNOWN);
        }
        return entTrainingLocationType.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingLocationType) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingLocationType entTrainingLocationType) {
        try {
            entTrainingLocationType.setOID(rs.getLong(PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_TRAINING_LOCATION_TYPE_ID]));
            entTrainingLocationType.setLocationName(rs.getString(PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_LOCATION_NAME]));
            entTrainingLocationType.setDescription(rs.getString(PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_DESCRIPTION]));
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
            String sql = "SELECT * FROM " + TBL_TRAININGLOCATIONTYPE;
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
                TrainingLocationType entTrainingLocationType = new TrainingLocationType();
                resultToObject(rs, entTrainingLocationType);
                lists.add(entTrainingLocationType);
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

    public static boolean checkOID(long entTrainingLocationTypeId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAININGLOCATIONTYPE + " WHERE "
                    + PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_TRAINING_LOCATION_TYPE_ID] + " = " + entTrainingLocationTypeId;
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
            String sql = "SELECT COUNT(" + PstTrainingLocationType.fieldNames[PstTrainingLocationType.FLD_TRAINING_LOCATION_TYPE_ID] + ") FROM " + TBL_TRAININGLOCATIONTYPE;
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
                    TrainingLocationType entTrainingLocationType = (TrainingLocationType) list.get(ls);
                    if (oid == entTrainingLocationType.getOID()) {
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
