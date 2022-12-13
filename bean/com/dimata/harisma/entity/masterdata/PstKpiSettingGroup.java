/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;
/**
 *
 * @author User
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;
import org.json.JSONObject;

public class PstKpiSettingGroup extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_KPISETTINGGROUP = "hr_kpi_setting_group";
    public static final int FLD_KPI_SETTING_GROUP_ID = 0;
    public static final int FLD_KPI_SETTING_ID = 1;
    public static final int FLD_KPI_GROUP_ID = 2;
    public static final int FLD_KPI_SETTING_TYPE_ID = 3;

    public static String[] fieldNames = {
        "KPI_SETTING_GROUP_ID",
        "KPI_SETTING_ID",
        "KPI_GROUP_ID",
        "KPI_SETTING_TYPE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG 
    };

    public PstKpiSettingGroup() {
    }

    public PstKpiSettingGroup(int i) throws DBException {
        super(new PstKpiSettingGroup());
    }

    public PstKpiSettingGroup(String sOid) throws DBException {
        super(new PstKpiSettingGroup(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKpiSettingGroup(long lOid) throws DBException {
        super(new PstKpiSettingGroup(0));
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
        return TBL_KPISETTINGGROUP;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKpiSettingGroup().getClass().getName();
    }

    public static KpiSettingGroup fetchExc(long oid) throws DBException {
        try {
            KpiSettingGroup entKpisettinggroup = new KpiSettingGroup();
            PstKpiSettingGroup pstKpiSettingGroup = new PstKpiSettingGroup(oid);
            entKpisettinggroup.setOID(oid);
            entKpisettinggroup.setKpiSettingId(pstKpiSettingGroup.getlong(FLD_KPI_SETTING_ID));
            entKpisettinggroup.setKpiGroupId(pstKpiSettingGroup.getlong(FLD_KPI_GROUP_ID));
            entKpisettinggroup.setKpiSettingTypeId(pstKpiSettingGroup.getLong(FLD_KPI_SETTING_TYPE_ID));
            return entKpisettinggroup;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingGroup(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        KpiSettingGroup entKpiSettingGroup = fetchExc(entity.getOID());
        entity = (Entity) entKpiSettingGroup;
        return entKpiSettingGroup.getOID();
    }

    public static synchronized long updateExc(KpiSettingGroup entKpiSettingGroup) throws DBException {
        try {
            if (entKpiSettingGroup.getOID() != 0) {
                PstKpiSettingGroup pstKpiSettingGroup = new PstKpiSettingGroup(entKpiSettingGroup.getOID());
                pstKpiSettingGroup.setLong(FLD_KPI_SETTING_ID, entKpiSettingGroup.getKpiSettingId());
                pstKpiSettingGroup.setLong(FLD_KPI_GROUP_ID, entKpiSettingGroup.getKpiGroupId());
                pstKpiSettingGroup.update();
                return entKpiSettingGroup.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingGroup(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiSettingGroup) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiSettingGroup pstKpiSettingGroup = new PstKpiSettingGroup(oid);
            pstKpiSettingGroup.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingGroup(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiSettingGroup entKpiSettingGroup) throws DBException {
        try {
            PstKpiSettingGroup pstKpiSettingGroup = new PstKpiSettingGroup(0);
            pstKpiSettingGroup.setLong(FLD_KPI_SETTING_ID, entKpiSettingGroup.getKpiSettingId());
            pstKpiSettingGroup.setLong(FLD_KPI_GROUP_ID, entKpiSettingGroup.getKpiGroupId());
            pstKpiSettingGroup.setLong(FLD_KPI_SETTING_TYPE_ID, entKpiSettingGroup.getKpiSettingTypeId());
            pstKpiSettingGroup.insert();
            entKpiSettingGroup.setOID(pstKpiSettingGroup.getlong(FLD_KPI_SETTING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingGroup(0), DBException.UNKNOWN);
        }
        return entKpiSettingGroup.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiSettingGroup) entity);
    }

    public static void resultToObject(ResultSet rs, KpiSettingGroup entKpiSettingGroup) {
        try {
            entKpiSettingGroup.setOID(rs.getLong(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_GROUP_ID]));
            entKpiSettingGroup.setKpiSettingId(rs.getLong(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_ID]));
            entKpiSettingGroup.setKpiGroupId(rs.getLong(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_GROUP_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPISETTINGGROUP;
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
                KpiSettingGroup entKpiSettingGroup = new KpiSettingGroup();
                resultToObject(rs, entKpiSettingGroup);
                lists.add(entKpiSettingGroup);
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

    public static Vector listWithJoinKpiSettingAndKpiSettingType(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_kpi_setting_group.* FROM hr_kpi_setting_type \n" +
"INNER JOIN hr_kpi_type ON hr_kpi_setting_type.`KPI_TYPE_ID` = hr_kpi_type.`KPI_TYPE_ID` \n" +
"INNER JOIN hr_kpi_setting ON hr_kpi_setting_type.`KPI_SETTING_ID` = hr_kpi_setting.`KPI_SETTING_ID` \n" +
"INNER JOIN hr_kpi_setting_group ON hr_kpi_setting_type.`KPI_SETTING_TYPE_ID` = hr_kpi_setting_group.`KPI_SETTING_TYPE_ID` \n" +
                            "WHERE " + whereClause;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KpiSettingGroup entKpiSettingGroup = new KpiSettingGroup();
                resultToObject(rs, entKpiSettingGroup);
                lists.add(entKpiSettingGroup);
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
            String sql = "SELECT COUNT(" + PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_ID] + ") FROM " + TBL_KPISETTINGGROUP;
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
                    KpiSettingGroup entKpiSettingGroup = (KpiSettingGroup) list.get(ls);
                    if (oid == entKpiSettingGroup.getOID()) {
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

    public static JSONObject fetchJSON(KpiSettingGroup entKpiSettingGroup) {
        JSONObject object = new JSONObject();
        try {
            object.put(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_GROUP_ID], "" + entKpiSettingGroup.getOID());
            object.put(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_ID], "" + entKpiSettingGroup.getKpiSettingId());
            object.put(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_GROUP_ID], "" + entKpiSettingGroup.getKpiGroupId());
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) throws DBException {
        long oid = 0;
        try {
            oid = Long.valueOf((String) jSONObject.get(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_GROUP_ID]));
            KpiSettingGroup entKpiSettingGroup = PstKpiSettingGroup.parseJsonObject(jSONObject);
            oid = entKpiSettingGroup.getOID();
            boolean chekOid = PstKpiSettingGroup.checkOID(oid);
            if (chekOid) {
                // Doing update
                oid = PstKpiSettingGroup.updateExc(entKpiSettingGroup);
            } else {
                // Doing insert
                oid = PstKpiSettingGroup.insertExc(entKpiSettingGroup);
            }
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return oid;
    }

    private static KpiSettingGroup parseJsonObject(JSONObject jsonObject) {
        KpiSettingGroup entKpiSettingGroup = new KpiSettingGroup();
        try {
            entKpiSettingGroup.setOID(Long.valueOf((String) jsonObject.get(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_GROUP_ID])));
            entKpiSettingGroup.setKpiSettingId(Long.valueOf((String) jsonObject.get(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_ID])));
            entKpiSettingGroup.setKpiGroupId(Long.valueOf((String) jsonObject.get(PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_GROUP_ID])));
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return entKpiSettingGroup;
    }

    public static boolean checkOID(long kpiSettingGroupId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_KPISETTINGGROUP
                    + " WHERE " + PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_GROUP_ID]
                    + " = " + kpiSettingGroupId;
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
    
    public static long deleteByKpiGroup(long kpi_group_id) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKpiSettingGroup.TBL_KPISETTINGGROUP
                    + " WHERE " + PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_GROUP_ID]
                    + " = '" + kpi_group_id + "'";
                        
            int status = DBHandler.execUpdate(sql);
            return kpi_group_id;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
        
    }

}
