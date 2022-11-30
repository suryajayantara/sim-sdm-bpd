/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.harisma.entity.masterdata.KpiSettingList;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;
import org.json.JSONObject;

public class PstKpiSettingList extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_KPISETTINGLIST = "hr_kpi_setting_list";
    public static final int FLD_KPI_SETTING_LIST_ID = 0;
    public static final int FLD_KPI_SETTING_ID = 1;
    public static final int FLD_KPI_LIST_ID = 2;
    public static final int FLD_KPI_DISTRIBUTION_ID = 3;

    public static String[] fieldNames = {
        "KPI_SETTING_LIST_ID",
        "KPI_SETTING_ID",
        "KPI_LIST_ID",
        "KPI_DISTRIBUTION_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstKpiSettingList() {
    }

    public PstKpiSettingList(int i) throws DBException {
        super(new PstKpiSettingList());
    }

    public PstKpiSettingList(String sOid) throws DBException {
        super(new PstKpiSettingList(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKpiSettingList(long lOid) throws DBException {
        super(new PstKpiSettingList(0));
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
        return TBL_KPISETTINGLIST;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKpiSettingList().getClass().getName();
    }

    public static KpiSettingList fetchExc(long oid) throws DBException {
        try {
            KpiSettingList entKpisettinglist = new KpiSettingList();
            PstKpiSettingList pstKpiSettingList = new PstKpiSettingList(oid);
            entKpisettinglist.setOID(oid);
            entKpisettinglist.setKpiSettingId(pstKpiSettingList.getlong(FLD_KPI_SETTING_ID));
            entKpisettinglist.setKpiListId(pstKpiSettingList.getlong(FLD_KPI_LIST_ID));
            entKpisettinglist.setKpiDistributionId(pstKpiSettingList.getlong(FLD_KPI_DISTRIBUTION_ID));
            return entKpisettinglist;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingList(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        KpiSettingList entKpiSettingList = fetchExc(entity.getOID());
        entity = (Entity) entKpiSettingList;
        return entKpiSettingList.getOID();
    }

    public static synchronized long updateExc(KpiSettingList entKpiSettingList) throws DBException {
        try {
            if (entKpiSettingList.getOID() != 0) {
                PstKpiSettingList pstKpiSettingList = new PstKpiSettingList(entKpiSettingList.getOID());
                pstKpiSettingList.setLong(FLD_KPI_SETTING_ID, entKpiSettingList.getKpiSettingId());
                pstKpiSettingList.setLong(FLD_KPI_LIST_ID, entKpiSettingList.getKpiListId());
                pstKpiSettingList.setLong(FLD_KPI_DISTRIBUTION_ID, entKpiSettingList.getKpiDistributionId());
                pstKpiSettingList.update();
                return entKpiSettingList.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingList(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiSettingList) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiSettingList pstKpiSettingList = new PstKpiSettingList(oid);
            pstKpiSettingList.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingList(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiSettingList entKpiSettingList) throws DBException {
        try {
            PstKpiSettingList pstKpiSettingList = new PstKpiSettingList(0);
            pstKpiSettingList.setLong(FLD_KPI_SETTING_ID, entKpiSettingList.getKpiSettingId());
            pstKpiSettingList.setLong(FLD_KPI_LIST_ID, entKpiSettingList.getKpiListId());
            pstKpiSettingList.setLong(FLD_KPI_DISTRIBUTION_ID, entKpiSettingList.getKpiDistributionId());
            pstKpiSettingList.insert();
            entKpiSettingList.setOID(pstKpiSettingList.getlong(FLD_KPI_SETTING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingList(0), DBException.UNKNOWN);
        }
        return entKpiSettingList.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiSettingList) entity);
    }

    public static void resultToObject(ResultSet rs, KpiSettingList entKpiSettingList) {
        try {
            entKpiSettingList.setOID(rs.getLong(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_LIST_ID]));
            entKpiSettingList.setKpiSettingId(rs.getLong(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_ID]));
            entKpiSettingList.setKpiListId(rs.getLong(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_LIST_ID]));
            entKpiSettingList.setKpiDistributionId(rs.getLong(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_DISTRIBUTION_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPISETTINGLIST;
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
                KpiSettingList entKpiSettingList = new KpiSettingList();
                resultToObject(rs, entKpiSettingList);
                lists.add(entKpiSettingList);
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

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_ID] + ") FROM " + TBL_KPISETTINGLIST;
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
                    KpiSettingList entKpiSettingList = (KpiSettingList) list.get(ls);
                    if (oid == entKpiSettingList.getOID()) {
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
//Add by Eri Yudi 2020-07-01
//Method for API

    public static JSONObject fetchJSON(KpiSettingList entKpiSettingList) {
        JSONObject object = new JSONObject();
        try {
            object.put(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_LIST_ID], "" + entKpiSettingList.getOID());
            object.put(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_ID], "" + entKpiSettingList.getKpiSettingId());
            object.put(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_LIST_ID], "" + entKpiSettingList.getKpiListId());
            object.put(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_DISTRIBUTION_ID], "" + entKpiSettingList.getKpiDistributionId());
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) throws DBException {
        long oid = 0;
        try {
            oid = Long.valueOf((String) jSONObject.get(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_LIST_ID]));
            KpiSettingList entKpiSettingList = PstKpiSettingList.parseJsonObject(jSONObject);
            oid = entKpiSettingList.getOID();
            boolean chekOid = PstKpiSettingList.checkOID(oid);
            if (chekOid) {
                // Doing update
                oid = PstKpiSettingList.updateExc(entKpiSettingList);
            } else {
                // Doing insert
                oid = PstKpiSettingList.insertExc(entKpiSettingList);
            }
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return oid;
    }

    private static KpiSettingList parseJsonObject(JSONObject jsonObject) {
        KpiSettingList entKpiSettingList = new KpiSettingList();
        try {
            entKpiSettingList.setOID(Long.valueOf((String) jsonObject.get(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_LIST_ID])));
            entKpiSettingList.setKpiSettingId(Long.valueOf((String) jsonObject.get(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_ID])));
            entKpiSettingList.setKpiListId(Long.valueOf((String) jsonObject.get(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_LIST_ID])));
            entKpiSettingList.setKpiDistributionId(Long.valueOf((String) jsonObject.get(PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_DISTRIBUTION_ID])));
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return entKpiSettingList;
    }

    public static boolean checkOID(long kpiSettingListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_KPISETTINGLIST
                    + " WHERE " + PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_LIST_ID]
                    + " = " + kpiSettingListId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }
    
    public static long deleteByKpiList(long kpi_setting_list_id) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKpiSettingList.TBL_KPISETTINGLIST
                    + " WHERE " + PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_LIST_ID]
                    + " = '" + kpi_setting_list_id + "'";

            int status = DBHandler.execUpdate(sql);
            return kpi_setting_list_id;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
        
    }
    
    public static Vector listDataKpiSettingList(long oidKpiSetting) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM `hr_kpi_setting_group` \n" +
                            "INNER JOIN `hr_kpi_setting_list`\n" +
                            "ON `hr_kpi_setting_group`.`KPI_SETTING_ID` = `hr_kpi_setting_list`.`KPI_SETTING_ID`\n" +
                            "LEFT JOIN `hr_kpi_list`\n" +
                            "ON `hr_kpi_setting_list`.`KPI_LIST_ID` = `hr_kpi_list`.`KPI_LIST_ID`\n" +
                            "WHERE `hr_kpi_setting_list`.`KPI_SETTING_ID` = "+ oidKpiSetting;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KpiSettingList entKpiSettingList = new KpiSettingList();
                resultToObject(rs, entKpiSettingList);
                lists.add(entKpiSettingList);
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
     
    
}
