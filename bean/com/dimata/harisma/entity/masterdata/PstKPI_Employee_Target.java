/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstKPI_Employee_Target extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_KPI_EMPLOYEE_TARGET = "hr_kpi_employee_target";
   public static final int FLD_KPI_EMPLOYEE_TARGET_ID = 0;
   public static final int FLD_KPI_LIST_ID = 1;
   public static final int FLD_STARTDATE = 2;
   public static final int FLD_ENDDATE = 3;
   public static final int FLD_EMPLOYEE_ID = 4;
   public static final int FLD_TARGET = 5;
   public static final int FLD_ACHIEVEMENT = 6;
   public static final int FLD_ACHIEV_DATE = 7;
   public static final int FLD_ACHIEV_PROOF = 8;
   public static final int FLD_KPI_TARGET_DETAIL_ID = 9;
   
    public static final String[] fieldNames = {
      "KPI_EMPLOYEE_TARGET_ID",
      "KPI_LIST_ID",
      "STARTDATE",
      "ENDDATE",
      "EMPLOYEE_ID",
      "TARGET",
      "ACHIEVEMENT",
      "ACHIEV_DATE",
      "ACHIEV_PROOF",
      "KPI_TARGET_DETAIL_ID"
    };
    public static final int[] fieldTypes = {
      TYPE_LONG + TYPE_PK + TYPE_ID,
      TYPE_STRING,
      TYPE_DATE,
      TYPE_DATE,
      TYPE_LONG,
      TYPE_FLOAT,
      TYPE_FLOAT,
      TYPE_DATE,
      TYPE_STRING,
      TYPE_LONG
    };

   public PstKPI_Employee_Target() {
   }

    public PstKPI_Employee_Target(int i) throws DBException {
        super(new PstKPI_Employee_Target());
    }

    public PstKPI_Employee_Target(String sOid) throws DBException {
        super(new PstKPI_Employee_Target(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKPI_Employee_Target(long lOid) throws DBException {
        super(new PstKPI_Employee_Target(0));
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
        return TBL_HR_KPI_EMPLOYEE_TARGET;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKPI_Employee_Target().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        KPI_Employee_Target kPI_Employee_Target = fetchExc(ent.getOID());
        ent = (Entity) kPI_Employee_Target;
        return kPI_Employee_Target.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((KPI_Employee_Target) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((KPI_Employee_Target) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static KPI_Employee_Target fetchExc(long oid) throws DBException {
        try {
            KPI_Employee_Target kPI_Employee_Target = new KPI_Employee_Target();
            PstKPI_Employee_Target pstKPI_Employee_Target = new PstKPI_Employee_Target(oid);
            kPI_Employee_Target.setOID(oid);

            kPI_Employee_Target.setOID(oid);
            kPI_Employee_Target.setKpiEmployeeTargetId(pstKPI_Employee_Target.getlong(FLD_KPI_EMPLOYEE_TARGET_ID));
            kPI_Employee_Target.setKpiListId(pstKPI_Employee_Target.getlong(FLD_KPI_LIST_ID));
            kPI_Employee_Target.setStartDate(pstKPI_Employee_Target.getDate(FLD_STARTDATE));
            kPI_Employee_Target.setEndDate(pstKPI_Employee_Target.getDate(FLD_ENDDATE));
            kPI_Employee_Target.setEmployeeId(pstKPI_Employee_Target.getlong(FLD_EMPLOYEE_ID));
            kPI_Employee_Target.setTarget(pstKPI_Employee_Target.getdouble(FLD_TARGET));
            kPI_Employee_Target.setAchievement(pstKPI_Employee_Target.getdouble(FLD_ACHIEVEMENT));
            kPI_Employee_Target.setAchievDate(pstKPI_Employee_Target.getDate(FLD_ACHIEV_DATE));
            kPI_Employee_Target.setAchievProof(pstKPI_Employee_Target.getString(FLD_ACHIEV_PROOF));
            kPI_Employee_Target.setKpiTargetDetailId(pstKPI_Employee_Target.getLong(FLD_KPI_TARGET_DETAIL_ID));
            return kPI_Employee_Target;

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Target(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(KPI_Employee_Target kPI_Employee_Target) throws DBException {
        try {
            PstKPI_Employee_Target pstKPI_Employee_Target = new PstKPI_Employee_Target(0);
            
            pstKPI_Employee_Target.setLong(FLD_KPI_LIST_ID, kPI_Employee_Target.getKpiListId());
            pstKPI_Employee_Target.setDate(FLD_STARTDATE, kPI_Employee_Target.getStartDate());
            pstKPI_Employee_Target.setDate(FLD_ENDDATE, kPI_Employee_Target.getEndDate());
            pstKPI_Employee_Target.setLong(FLD_EMPLOYEE_ID, kPI_Employee_Target.getEmployeeId());
            pstKPI_Employee_Target.setDouble(FLD_TARGET, kPI_Employee_Target.getTarget());
            pstKPI_Employee_Target.setDouble(FLD_ACHIEVEMENT, kPI_Employee_Target.getAchievement());
            pstKPI_Employee_Target.setDate(FLD_ACHIEV_DATE, kPI_Employee_Target.getAchievDate());
            pstKPI_Employee_Target.setString(FLD_ACHIEV_PROOF, kPI_Employee_Target.getAchievProof());
            pstKPI_Employee_Target.setLong(FLD_KPI_TARGET_DETAIL_ID, kPI_Employee_Target.getKpiTargetDetailId());
            
            pstKPI_Employee_Target.insert();
            kPI_Employee_Target.setOID(pstKPI_Employee_Target.getlong(FLD_KPI_EMPLOYEE_TARGET_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Target(0), DBException.UNKNOWN);
        }
        return kPI_Employee_Target.getOID();
    }

    public static long updateExc(KPI_Employee_Target kPI_Employee_Target) throws DBException {
        try {
            if (kPI_Employee_Target.getOID() != 0) {
                PstKPI_Employee_Target pstKPI_Employee_Target = new PstKPI_Employee_Target(kPI_Employee_Target.getOID());

                pstKPI_Employee_Target.setLong(FLD_KPI_EMPLOYEE_TARGET_ID, kPI_Employee_Target.getKpiEmployeeTargetId());
                pstKPI_Employee_Target.setLong(FLD_KPI_LIST_ID, kPI_Employee_Target.getKpiListId());
                pstKPI_Employee_Target.setDate(FLD_STARTDATE, kPI_Employee_Target.getStartDate());
                pstKPI_Employee_Target.setDate(FLD_ENDDATE, kPI_Employee_Target.getEndDate());
                pstKPI_Employee_Target.setLong(FLD_EMPLOYEE_ID, kPI_Employee_Target.getEmployeeId());
                pstKPI_Employee_Target.setDouble(FLD_TARGET, kPI_Employee_Target.getTarget());
                pstKPI_Employee_Target.setDouble(FLD_ACHIEVEMENT, kPI_Employee_Target.getAchievement());
                pstKPI_Employee_Target.setDate(FLD_ACHIEV_DATE, kPI_Employee_Target.getAchievDate());
                pstKPI_Employee_Target.setString(FLD_ACHIEV_PROOF, kPI_Employee_Target.getAchievProof());
                pstKPI_Employee_Target.setLong(FLD_KPI_TARGET_DETAIL_ID, kPI_Employee_Target.getKpiTargetDetailId());
                pstKPI_Employee_Target.update();

                pstKPI_Employee_Target.update();
                return kPI_Employee_Target.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Target(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstKPI_Employee_Target pstKPI_Employee_Target = new PstKPI_Employee_Target(oid);
            pstKPI_Employee_Target.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Target(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_TARGET;
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
                KPI_Employee_Target kPI_Employee_Target = new KPI_Employee_Target();
                resultToObject(rs, kPI_Employee_Target);
                lists.add(kPI_Employee_Target);
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
	
	 public static Vector listJoinKpi(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT TAR.* FROM " + TBL_HR_KPI_EMPLOYEE_TARGET+" AS TAR "
					+ " INNER JOIN hr_kpi_list AS KPI "
					+ " ON TAR.KPI_LIST_ID = KPI.KPI_LIST_ID ";
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
                KPI_Employee_Target kPI_Employee_Target = new KPI_Employee_Target();
                resultToObject(rs, kPI_Employee_Target);
                lists.add(kPI_Employee_Target);
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
	
	public static Vector listJoinGrup(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT TAR.*, GR.KPI_GROUP_ID, GR.GROUP_TITLE FROM " + TBL_HR_KPI_EMPLOYEE_TARGET +" AS TAR "
					+ " INNER JOIN hr_kpi_list AS KPI "
					+ " ON TAR.KPI_LIST_ID = KPI.KPI_LIST_ID "
					+ " INNER JOIN hr_kpi_list_group AS LG "
					+ " ON KPI.KPI_LIST_ID = LG.KPI_LIST_ID "
					+ " INNER JOIN hr_kpi_group AS GR "
					+ " ON LG.KPI_GROUP_ID = GR.KPI_GROUP_ID ";
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
				
				Vector temp = new Vector();
				
                KPI_Employee_Target kPI_Employee_Target = new KPI_Employee_Target();
                resultToObject(rs, kPI_Employee_Target);
                temp.add(kPI_Employee_Target);
				
				KPI_Group group = new KPI_Group();
				group.setKpi_group_id(rs.getLong("KPI_GROUP_ID"));
				group.setGroup_title(rs.getString("GROUP_TITLE"));
				temp.add(group);
				
				lists.add(temp);
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
    
      public static double getTotalTargetEmployee(long employeeId, long kpiListId) {
        double nilai = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT SUM(ket." + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_TARGET] + ") FROM  " + PstKPI_Employee_Target.TBL_HR_KPI_EMPLOYEE_TARGET +" ket ";
            sql =  sql + " WHERE ket." + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_EMPLOYEE_ID] + " = " + employeeId ; 
            sql =  sql + " AND ket." + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = " + kpiListId ; 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               nilai  = rs.getInt(1);
            }
            rs.close();
            return nilai;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return nilai;
    }
    
    
    public static Hashtable Hlist(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable hashListSec = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_TARGET;
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
                KPI_Employee_Target kPI_Employee_Target = new KPI_Employee_Target();
                resultToObject(rs, kPI_Employee_Target);
                hashListSec.put(kPI_Employee_Target.getEmployeeId(), kPI_Employee_Target);  
            }
            rs.close();
            return hashListSec;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
    }
      public static void resultToObject(ResultSet rs, KPI_Employee_Target kPI_Employee_Target) {
        try {
            kPI_Employee_Target.setKpiEmployeeTargetId(rs.getLong(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_EMPLOYEE_TARGET_ID]));
            kPI_Employee_Target.setKpiListId(rs.getLong(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID]));
            kPI_Employee_Target.setStartDate(rs.getDate(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_STARTDATE]));
            kPI_Employee_Target.setEndDate(rs.getDate(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ENDDATE]));
            kPI_Employee_Target.setEmployeeId(rs.getLong(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_EMPLOYEE_ID]));
            kPI_Employee_Target.setTarget(rs.getDouble(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_TARGET]));
            kPI_Employee_Target.setAchievement(rs.getDouble(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ACHIEVEMENT]));
            kPI_Employee_Target.setAchievDate(rs.getDate(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ACHIEV_DATE]));
            kPI_Employee_Target.setAchievProof(rs.getString(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ACHIEV_PROOF]));
            kPI_Employee_Target.setKpiTargetDetailId(rs.getLong(PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_TARGET_DETAIL_ID]));

        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long kPI_Employee_TargetId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_TARGET + " WHERE "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_EMPLOYEE_TARGET_ID] + " = " + kPI_Employee_TargetId;

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

      public static long deleteKpiEmployeTarget(int year, long kpiListId, long companyId) {
        DBResultSet dbrs = null;
        long resulthasil =0;
        try {
            String sql = "DELETE  FROM " + TBL_HR_KPI_EMPLOYEE_TARGET + " WHERE "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_STARTDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ENDDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = " + kpiListId + "";
             
            DBHandler.execSqlInsert(sql);
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
            
        } finally {
            DBResultSet.close(dbrs);
            return resulthasil;
        }
    }
    
    public static long deleteKpiEmployePerDepartTarget(int year, long kpiListId, long companyId, String employeeId) {
        DBResultSet dbrs = null;
        long resulthasil =0;
        try {
            String sql = "DELETE  FROM " + TBL_HR_KPI_EMPLOYEE_TARGET + " WHERE "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_STARTDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ENDDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = " + kpiListId + ""
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_EMPLOYEE_ID] + " IN (" + employeeId + ")";
             
            DBHandler.execSqlInsert(sql);
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
            
        } finally {
            DBResultSet.close(dbrs);
            return resulthasil;
        }
    }
      
    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_EMPLOYEE_TARGET_ID] + ") FROM " + TBL_HR_KPI_EMPLOYEE_TARGET;
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
                    KPI_Employee_Target kPI_Employee_Target = (KPI_Employee_Target) list.get(ls);
                    if (oid == kPI_Employee_Target.getOID()) {
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
