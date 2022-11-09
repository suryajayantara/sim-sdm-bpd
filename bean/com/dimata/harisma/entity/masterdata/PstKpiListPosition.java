/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author IanRizky
 */
public class PstKpiListPosition extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_KPI_LIST_POSITION = "hr_kpi_list_position";
   public static final int FLD_KPI_LIST_POSITION_ID = 0;
   public static final int FLD_KPI_LIST_ID = 1;
   public static final int FLD_POSITION_ID = 2;
   
    public static final String[] fieldNames = {
      "KPI_LIST_POSITION_ID",
      "KPI_LIST_ID",
      "POSITION_ID"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

   public PstKpiListPosition() {
   }

    public PstKpiListPosition(int i) throws DBException {
        super(new PstKpiListPosition());
    }

    public PstKpiListPosition(String sOid) throws DBException {
        super(new PstKpiListPosition(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKpiListPosition(long lOid) throws DBException {
        super(new PstKpiListPosition(0));
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
        return TBL_HR_KPI_LIST_POSITION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKpiListPosition().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        KpiListPosition kpiListPosition = fetchExc(ent.getOID());
        ent = (Entity) kpiListPosition;
        return kpiListPosition.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((KpiListPosition) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((KpiListPosition) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static KpiListPosition fetchExc(long oid) throws DBException {
        try {
            KpiListPosition kpiListPosition = new KpiListPosition();
            PstKpiListPosition pstKpiListPosition = new PstKpiListPosition(oid);
            kpiListPosition.setOID(oid);
            
            kpiListPosition.setKpiId(pstKpiListPosition.getlong(FLD_KPI_LIST_ID));
            kpiListPosition.setPositionId(pstKpiListPosition.getLong(FLD_POSITION_ID));
         
            return kpiListPosition;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiListPosition(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(KpiListPosition kpiListPosition) throws DBException {
        try {
            PstKpiListPosition pstKpiListPosition = new PstKpiListPosition(0);

            pstKpiListPosition.setLong(FLD_KPI_LIST_ID, kpiListPosition.getKpiId());
            pstKpiListPosition.setLong(FLD_POSITION_ID, kpiListPosition.getPositionId());          
            pstKpiListPosition.insert();
            kpiListPosition.setOID(pstKpiListPosition.getlong(FLD_KPI_LIST_POSITION_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiListPosition(0), DBException.UNKNOWN);
        }
        return kpiListPosition.getOID();
    }

    public static long updateExc(KpiListPosition kpiListPosition) throws DBException {
        try {
            if (kpiListPosition.getOID() != 0) {
                PstKpiListPosition pstKpiListPosition = new PstKpiListPosition(kpiListPosition.getOID());

                pstKpiListPosition.setLong(FLD_KPI_LIST_ID, kpiListPosition.getKpiId());
                pstKpiListPosition.setLong(FLD_POSITION_ID, kpiListPosition.getPositionId()); 
            
                pstKpiListPosition.update();
                return kpiListPosition.getOID();
    }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiListPosition(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstKpiListPosition pstKpiListPosition = new PstKpiListPosition(oid);
            pstKpiListPosition.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiListPosition(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_LIST_POSITION;
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
                KpiListPosition kpiListPosition = new KpiListPosition();
                resultToObject(rs, kpiListPosition);
                lists.add(kpiListPosition);
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
    
      public static void resultToObject(ResultSet rs, KpiListPosition kpiListPosition) {
        try {
            kpiListPosition.setOID(rs.getLong(PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_POSITION_ID]));
            kpiListPosition.setKpiId(rs.getLong(PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_ID]));
            kpiListPosition.setPositionId(rs.getLong(PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_POSITION_ID]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long kpiPositionId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_LIST_POSITION + " WHERE "
                    + PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_POSITION_ID] + " = " + kpiPositionId;

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
            String sql = "SELECT COUNT(" + PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_POSITION_ID] + ") FROM " + TBL_HR_KPI_LIST_POSITION;
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

  public static long deletewhereGroup(long listGroup) {
        DBResultSet dbrs = null;
        long resulthasil =0;
        try {
            String sql = "DELETE  FROM " + TBL_HR_KPI_LIST_POSITION + " WHERE "
                    + PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_ID] + " = " + listGroup;
            DBHandler.execSqlInsert(sql);

        } catch (Exception e) {
            System.out.println("err : " + e.toString());
            
        } finally {
            DBResultSet.close(dbrs);
            return resulthasil;
        }
    }
  
	public static String[] getKpiPosition(long oidKpiList){
		String whereClause = PstKpiListPosition.fieldNames[PstKpiListPosition.FLD_KPI_LIST_ID]
				+" = "+oidKpiList;
		Vector listPosition = PstKpiListPosition.list(0, 0, whereClause, "");
		String[] kpi = new String[listPosition.size()];
		for (int i=0; i < listPosition.size(); i++){
			KpiListPosition kpiList = (KpiListPosition) listPosition.get(i);
			kpi[i] = ""+kpiList.getPositionId();
		}
		
		return kpi;
	}
  
    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    KpiListPosition kpiListPosition = (KpiListPosition) list.get(ls);
                    if (oid == kpiListPosition.getOID()) {
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

  
}
