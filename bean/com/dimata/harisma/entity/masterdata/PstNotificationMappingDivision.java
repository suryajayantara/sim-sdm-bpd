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
public class PstNotificationMappingDivision extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_NOTIFICATION_MAPPING_DIVISION = "hr_notification_mapping_division";
    public static final int FLD_NOTIFICATION_MAPPING_DIVISION_ID = 0;
    public static final int FLD_NOTIFICATION_ID = 1;
    public static final int FLD_DIVISION_ID = 2;

    public static String[] fieldNames = {
        "NOTIFICATION_MAPPING_DIVISION_ID",
        "NOTIFICATION_ID",
        "DIVISION_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstNotificationMappingDivision() {
    }

    public PstNotificationMappingDivision(int i) throws DBException {
        super(new PstNotificationMappingDivision());
    }

    public PstNotificationMappingDivision(String sOid) throws DBException {
        super(new PstNotificationMappingDivision(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstNotificationMappingDivision(long lOid) throws DBException {
        super(new PstNotificationMappingDivision(0));
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
        return TBL_NOTIFICATION_MAPPING_DIVISION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstNotificationMappingDivision().getClass().getName();
    }

    public static NotificationMappingDivision fetchExc(long oid) throws DBException {
        try {
            NotificationMappingDivision entNotificationMappingDivision = new NotificationMappingDivision();
            PstNotificationMappingDivision pstNotificationMappingDivision = new PstNotificationMappingDivision(oid);
            entNotificationMappingDivision.setOID(oid);
            entNotificationMappingDivision.setNotificationId(pstNotificationMappingDivision.getlong(FLD_NOTIFICATION_ID));
            entNotificationMappingDivision.setDivisionId(pstNotificationMappingDivision.getlong(FLD_DIVISION_ID));
            return entNotificationMappingDivision;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotificationMappingDivision(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        NotificationMappingDivision entNotificationMappingDivision = fetchExc(entity.getOID());
        entity = (Entity) entNotificationMappingDivision;
        return entNotificationMappingDivision.getOID();
    }

    public static synchronized long updateExc(NotificationMappingDivision entNotificationMappingDivision) throws DBException {
        try {
            if (entNotificationMappingDivision.getOID() != 0) {
                PstNotificationMappingDivision pstNotificationMappingDivision = new PstNotificationMappingDivision(entNotificationMappingDivision.getOID());
                pstNotificationMappingDivision.setLong(FLD_NOTIFICATION_ID, entNotificationMappingDivision.getNotificationId());
                pstNotificationMappingDivision.setLong(FLD_DIVISION_ID, entNotificationMappingDivision.getDivisionId());
                pstNotificationMappingDivision.update();
                return entNotificationMappingDivision.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotificationMappingDivision(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((NotificationMappingDivision) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstNotificationMappingDivision pstNotificationMappingDivision = new PstNotificationMappingDivision(oid);
            pstNotificationMappingDivision.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotificationMappingDivision(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(NotificationMappingDivision entNotificationMappingDivision) throws DBException {
        try {
            PstNotificationMappingDivision pstNotificationMappingDivision = new PstNotificationMappingDivision(0);
            pstNotificationMappingDivision.setLong(FLD_NOTIFICATION_ID, entNotificationMappingDivision.getNotificationId());
            pstNotificationMappingDivision.setLong(FLD_DIVISION_ID, entNotificationMappingDivision.getDivisionId());
            pstNotificationMappingDivision.insert();
            entNotificationMappingDivision.setOID(pstNotificationMappingDivision.getlong(FLD_NOTIFICATION_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotificationMappingDivision(0), DBException.UNKNOWN);
        }
        return entNotificationMappingDivision.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((NotificationMappingDivision) entity);
    }

    public static void resultToObject(ResultSet rs, NotificationMappingDivision entNotificationMappingDivision) {
        try {
            entNotificationMappingDivision.setOID(rs.getLong(PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_MAPPING_DIVISION_ID]));
            entNotificationMappingDivision.setNotificationId(rs.getLong(PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID]));
            entNotificationMappingDivision.setDivisionId(rs.getLong(PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_DIVISION_ID]));
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
            String sql = "SELECT * FROM " + TBL_NOTIFICATION_MAPPING_DIVISION;
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
                NotificationMappingDivision entNotificationMappingDivision = new NotificationMappingDivision();
                resultToObject(rs, entNotificationMappingDivision);
                lists.add(entNotificationMappingDivision);
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

    public static boolean checkOID(long entNotificationMappingDivisionId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_NOTIFICATION_MAPPING_DIVISION + " WHERE "
                    + PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID] + " = " + entNotificationMappingDivisionId;
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
            String sql = "SELECT COUNT(" + PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID] + ") FROM " + TBL_NOTIFICATION_MAPPING_DIVISION;
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
                    NotificationMappingDivision entNotificationMappingDivision = (NotificationMappingDivision) list.get(ls);
                    if (oid == entNotificationMappingDivision.getOID()) {
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
    
    public static synchronized int deleteExcByNotificationOid(long oid) throws DBException {
          DBResultSet dbrs = null;
        try {
            
            if(oid != 0){
            String sql = "DELETE FROM " + TBL_NOTIFICATION_MAPPING_DIVISION;
            sql = sql + " WHERE " + PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID]+" = ";
            sql = sql +  oid ;
            
            System.out.println("delete custom data : " + sql);
            DBHandler.execUpdate(sql);
            }else{
               return 1; 
            }
            //dbrs = DBHandler.execQueryResult(sql);
            //ResultSet rs = dbrs.getResultSet();

            //rs.close();
        } catch (Exception e) {
            return 1;
        } finally {
            DBResultSet.close(dbrs);
            return 0;
        }
   }
}