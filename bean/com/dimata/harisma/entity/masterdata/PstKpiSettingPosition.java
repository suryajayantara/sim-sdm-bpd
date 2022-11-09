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

public class PstKpiSettingPosition extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_KPISETTINGPOSITION = "hr_kpi_setting_position";
    public static final int FLD_KPI_SETTING_POSITION_ID = 0;
    public static final int FLD_KPI_SETTING_ID = 1;
    public static final int FLD_POSITION_ID = 2;

    public static String[] fieldNames = {
        "KPI_SETTING_POSITION_ID",
        "KPI_SETTING_ID",
        "POSITION_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstKpiSettingPosition() {
    }

    public PstKpiSettingPosition(int i) throws DBException {
        super(new PstKpiSettingPosition());
    }

    public PstKpiSettingPosition(String sOid) throws DBException {
        super(new PstKpiSettingPosition(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKpiSettingPosition(long lOid) throws DBException {
        super(new PstKpiSettingPosition(0));
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
        return TBL_KPISETTINGPOSITION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKpiSettingPosition().getClass().getName();
    }

    public static KpiSettingPosition fetchExc(long oid) throws DBException {
        try {
            KpiSettingPosition entKpiSettingPosition = new KpiSettingPosition();
            PstKpiSettingPosition pstKpiSettingPosition = new PstKpiSettingPosition(oid);
            entKpiSettingPosition.setOID(oid);
            entKpiSettingPosition.setKpiSettingId(pstKpiSettingPosition.getlong(FLD_KPI_SETTING_ID));
            entKpiSettingPosition.setPositionId(pstKpiSettingPosition.getlong(FLD_POSITION_ID));
            return entKpiSettingPosition;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingPosition(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        KpiSettingPosition entKpiSettingPosition = fetchExc(entity.getOID());
        entity = (Entity) entKpiSettingPosition;
        return entKpiSettingPosition.getOID();
    }

    public static synchronized long updateExc(KpiSettingPosition entKpiSettingPosition) throws DBException {
        try {
            if (entKpiSettingPosition.getOID() != 0) {
                PstKpiSettingPosition pstKpiSettingPosition = new PstKpiSettingPosition(entKpiSettingPosition.getOID());
                pstKpiSettingPosition.setLong(FLD_KPI_SETTING_ID, entKpiSettingPosition.getKpiSettingId());
                pstKpiSettingPosition.setLong(FLD_POSITION_ID, entKpiSettingPosition.getPositionId());
                pstKpiSettingPosition.update();
                return entKpiSettingPosition.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingPosition(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiSettingPosition) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiSettingPosition pstKpiSettingPosition = new PstKpiSettingPosition(oid);
            pstKpiSettingPosition.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingPosition(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiSettingPosition entKpiSettingPosition) throws DBException {
        try {
            PstKpiSettingPosition pstKpiSettingPosition = new PstKpiSettingPosition(0);
            pstKpiSettingPosition.setLong(FLD_KPI_SETTING_ID, entKpiSettingPosition.getKpiSettingId());
            pstKpiSettingPosition.setLong(FLD_POSITION_ID, entKpiSettingPosition.getPositionId());
            pstKpiSettingPosition.insert();
            entKpiSettingPosition.setOID(pstKpiSettingPosition.getlong(FLD_KPI_SETTING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSettingPosition(0), DBException.UNKNOWN);
        }
        return entKpiSettingPosition.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiSettingPosition) entity);
    }

    public static void resultToObject(ResultSet rs, KpiSettingPosition entKpiSettingPosition) {
        try {
            entKpiSettingPosition.setOID(rs.getLong(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_POSITION_ID]));
            entKpiSettingPosition.setKpiSettingId(rs.getLong(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID]));
            entKpiSettingPosition.setPositionId(rs.getLong(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_POSITION_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPISETTINGPOSITION;
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
                KpiSettingPosition entKpiSettingPosition = new KpiSettingPosition();
                resultToObject(rs, entKpiSettingPosition);
                lists.add(entKpiSettingPosition);
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

    public static Vector listKpiSettingPosition(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT DISTINCT\n"
                    + "  (posx.`POSITION_ID`) AS POSITION_ID \n"
                    + "FROM\n"
                    + "  `hr_position` posx\n"
                    + "  INNER JOIN `hr_kpi_setting_position` AS map\n"
                    + "    ON posx.`POSITION_ID` = map.`POSITION_ID`\n"
                    + " WHERE " + whereClause;
                    
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Position position = new Position();
                position = PstPosition.fetchExc(rs.getLong(PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]));
                lists.add(position);
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
    
    public static String[] arrayKpiSettingPositionOID(long oid_kpi_setting) {
        Vector<String> listsToArray = new Vector();
        String[] res = null;
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT DISTINCT\n"
                    + "  (posx.`POSITION_ID`) AS POSITION_ID \n"
                    + "FROM\n"
                    + "  `hr_position` posx\n"
                    + "  INNER JOIN `hr_kpi_setting_position` AS map\n"
                    + "    ON posx.`POSITION_ID` = map.`POSITION_ID`\n"
                    + " WHERE map.kpi_setting_id = " + oid_kpi_setting;
                    
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String oidPosition = rs.getString(PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]);
                listsToArray.add(oidPosition);
            }
            rs.close();
            return listsToArray.toArray(new String[listsToArray.size()]);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new String[0];
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID] + ") FROM " + TBL_KPISETTINGPOSITION;
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
                    KpiSettingPosition entKpiSettingPosition = (KpiSettingPosition) list.get(ls);
                    if (oid == entKpiSettingPosition.getOID()) {
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

    public static JSONObject fetchJSON(KpiSettingPosition entKpiSettingPosition) {
        JSONObject object = new JSONObject();
        try {
            object.put(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_POSITION_ID], "" + entKpiSettingPosition.getOID());
            object.put(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID], "" + entKpiSettingPosition.getKpiSettingId());
            object.put(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_POSITION_ID], "" + entKpiSettingPosition.getPositionId());
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) throws DBException {
        long oid = 0;
        try {
            oid = Long.valueOf((String) jSONObject.get(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_POSITION_ID]));
            KpiSettingPosition entKpiSettingPosition = PstKpiSettingPosition.parseJsonObject(jSONObject);
            oid = entKpiSettingPosition.getOID();
            boolean chekOid = PstKpiSettingPosition.checkOID(oid);
            if (chekOid) {
                // Doing update
                oid = PstKpiSettingPosition.updateExc(entKpiSettingPosition);
            } else {
                // Doing insert
                oid = PstKpiSettingPosition.insertExc(entKpiSettingPosition);
            }
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return oid;
    }

    private static KpiSettingPosition parseJsonObject(JSONObject jsonObject) {
        KpiSettingPosition entKpiSettingPosition = new KpiSettingPosition();
        try {
            entKpiSettingPosition.setOID(Long.valueOf((String) jsonObject.get(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_POSITION_ID])));
            entKpiSettingPosition.setKpiSettingId(Long.valueOf((String) jsonObject.get(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID])));
            entKpiSettingPosition.setPositionId(Long.valueOf((String) jsonObject.get(PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_POSITION_ID])));
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return entKpiSettingPosition;
    }

    public static boolean checkOID(long kpiSettingPositionId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_KPISETTINGPOSITION
                    + " WHERE " + PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_POSITION_ID]
                    + " = " + kpiSettingPositionId;
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

    public static long deleteByKpiSettingId(long kpi_setting_oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKpiSettingPosition.TBL_KPISETTINGPOSITION
                    + " WHERE " + PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID]
                    + " = '" + kpi_setting_oid + "'";

            int status = DBHandler.execUpdate(sql);
            return kpi_setting_oid;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
    }

}
