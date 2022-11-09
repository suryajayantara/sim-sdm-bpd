/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.*;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.DBResultSet;
import static com.dimata.qdep.db.I_DBType.TYPE_ID;
import static com.dimata.qdep.db.I_DBType.TYPE_LONG;
import static com.dimata.qdep.db.I_DBType.TYPE_PK;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.sun.org.apache.xalan.internal.xsltc.runtime.Hashtable;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author keys
 */
public class PstKPITypeDivsion extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_KPITYPEDivision = "hr_kpi_type_division";
   public static final int FLD_KPI_TYPE_DIVISION_ID = 0;
   public static final int FLD_KPI_TYPE_ID = 1;
   public static final int FLD_DIVISION_ID = 2;

   public static String[] fieldNames = {
      "KPI_TYPE_DIVISION_ID",
      "KPI_TYPE_ID",
      "DIVISION_ID"
   };

   public static int[] fieldTypes = {
      TYPE_LONG+TYPE_PK+TYPE_ID,
      TYPE_LONG,
      TYPE_LONG
   };

   public PstKPITypeDivsion() {
   }

   public PstKPITypeDivsion(int i) throws DBException {
      super(new PstKPITypeDivsion());
   }

   public PstKPITypeDivsion(String sOid) throws DBException {
      super(new PstKPITypeDivsion(0));
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public PstKPITypeDivsion(long lOid) throws DBException {
      super(new PstKPITypeDivsion(0));
      String sOid = "0";
      try {
         sOid = String.valueOf(lOid);
      }catch(Exception e) {
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      }
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public int getFieldSize() {
      return fieldNames.length;
   }

   public String getTableName() {
      return TBL_KPITYPEDivision;
   }

   public String[] getFieldNames() {
      return fieldNames;
   }

   public int[] getFieldTypes() {
      return fieldTypes;
   }

   public String getPersistentName() {
      return new PstKPITypeDivsion().getClass().getName();
   }

   public static KpiTypeDivision fetchExc(long oid) throws DBException {
      try {
         KpiTypeDivision entKpitypeDivision = new KpiTypeDivision();
         PstKPITypeDivsion pstKpitypecompany = new PstKPITypeDivsion(oid);
          entKpitypeDivision.setOID(oid);
          entKpitypeDivision.setKpiTypeId(pstKpitypecompany.getlong(FLD_KPI_TYPE_ID));
          entKpitypeDivision.setDivisionId(pstKpitypecompany.getlong(FLD_DIVISION_ID));
         return entKpitypeDivision;
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKPITypeDivsion(0), DBException.UNKNOWN);
      }
   }

   public long fetchExc(Entity entity) throws Exception {
      KpiTypeDivision entKpiTypeDivision = fetchExc(entity.getOID());
      entity = (Entity) entKpiTypeDivision;
      return entKpiTypeDivision.getOID();
   }

   public static synchronized long updateExc(KpiTypeDivision entKpiTypeDivision) throws DBException {
      try {
         if (entKpiTypeDivision.getOID() != 0) {
            PstKPITypeDivsion pstKpiTypeDivision = new PstKPITypeDivsion(entKpiTypeDivision.getOID());
            pstKpiTypeDivision.setLong(FLD_KPI_TYPE_ID, entKpiTypeDivision.getKpiTypeId());
            pstKpiTypeDivision.setLong(FLD_DIVISION_ID, entKpiTypeDivision.getDivisionId());
            pstKpiTypeDivision.update();
            return entKpiTypeDivision.getOID();
         }
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKPITypeDivsion(0), DBException.UNKNOWN);
      }
      return 0;
   }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiTypeDivision) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKPITypeDivsion pstKpiTypeDivision = new PstKPITypeDivsion(oid);
            pstKpiTypeDivision.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeDivsion(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiTypeDivision entKpiTypeDivision) throws DBException {
        try {
            PstKPITypeDivsion pstKpiTypeDivision = new PstKPITypeDivsion(0);
            pstKpiTypeDivision.setLong(FLD_KPI_TYPE_ID, entKpiTypeDivision.getKpiTypeId());
            pstKpiTypeDivision.setLong(FLD_DIVISION_ID, entKpiTypeDivision.getDivisionId());
            pstKpiTypeDivision.insert();
            entKpiTypeDivision.setOID(pstKpiTypeDivision.getlong(FLD_KPI_TYPE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeDivsion(0), DBException.UNKNOWN);
        }
        return entKpiTypeDivision.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiTypeDivision) entity);
    }

    public static void resultToObject(ResultSet rs, KpiTypeDivision entKpiTypeDivision) {
        try {
            entKpiTypeDivision.setOID(rs.getLong(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_DIVISION_ID]));
            entKpiTypeDivision.setKpiTypeId(rs.getLong(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID]));
            entKpiTypeDivision.setDivisionId(rs.getLong(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_DIVISION_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPITYPEDivision;
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
                KpiTypeDivision entKpiTypeDivision = new KpiTypeDivision();
                resultToObject(rs, entKpiTypeDivision);
                lists.add(entKpiTypeDivision);
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
    
     public static Vector listKpiTypeDivision(long oid_kpi_type,long companyId) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            
            String sql = "SELECT DISTINCT\n" +
                        "  (divx.`DIVISION_ID`) AS DIVISION_ID \n" +
                        "FROM\n" +
                        "  `hr_division` divx\n" +
                        "  INNER JOIN `hr_kpi_type_division` AS map\n" +
                        "    ON divx.`DIVISION_ID` = map.`DIVISION_ID`\n" +
                        " WHERE map.kpi_type_id = "+ oid_kpi_type +
                       " AND divx.`COMPANY_ID` = "+ companyId ;
                    
                  
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Division division = new Division();
                division = PstDivision.fetchExc(rs.getLong(PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]));
                lists.add(division);
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
    
    public static Hashtable listHashTable(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_KPITYPEDivision;
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
                lists.put(rs.getLong(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_DIVISION_ID]),rs.getLong(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID]));
                
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID] + ") FROM " + TBL_KPITYPEDivision;
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
                    KpiTypeDivision entKpiTypeDivision = (KpiTypeDivision) list.get(ls);
                    if (oid == entKpiTypeDivision.getOID()) {
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

    public static JSONObject fetchJSON(KpiTypeDivision entKpiTypeDivision){
      JSONObject object = new JSONObject();
      try {
         object.put(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_DIVISION_ID],""+entKpiTypeDivision.getOID());
         object.put(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID],""+entKpiTypeDivision.getKpiTypeId());
         object.put(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_DIVISION_ID],""+entKpiTypeDivision.getDivisionId());
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return object;
   }


   public static long syncExc(JSONObject jSONObject) throws DBException {
      long oid = 0;
      try{
         oid = Long.valueOf((String)jSONObject.get(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_DIVISION_ID]));         KpiTypeDivision entKpiTypeDivision = PstKPITypeDivsion.parseJsonObject(jSONObject);
         oid = entKpiTypeDivision.getOID();
         boolean chekOid = PstKPITypeDivsion.checkOID(oid);
            if(chekOid){
               // Doing update
               oid = PstKPITypeDivsion.updateExc(entKpiTypeDivision);
            }else{
               // Doing insert
               oid = PstKPITypeDivsion.insertExc(entKpiTypeDivision);
            }
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return oid;
   }


   private static KpiTypeDivision parseJsonObject(JSONObject jsonObject){
      KpiTypeDivision entKpiTypeDivision = new KpiTypeDivision();
      try {
         entKpiTypeDivision.setOID(Long.valueOf((String) jsonObject.get(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_DIVISION_ID])));
         entKpiTypeDivision.setKpiTypeId(Long.valueOf((String) jsonObject.get(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID])));
         entKpiTypeDivision.setDivisionId(Long.valueOf((String) jsonObject.get(PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_DIVISION_ID])));
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return entKpiTypeDivision;
   }

   public static boolean checkOID(long kpiTypeCompanyId ) {
      DBResultSet dbrs = null;
      boolean result = false;
      try{
         String sql = "SELECT * FROM " + TBL_KPITYPEDivision
            +" WHERE "+ PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_DIVISION_ID]
            +" = " + kpiTypeCompanyId;
         dbrs = DBHandler.execQueryResult(sql);
         ResultSet rs = dbrs.getResultSet();
         
         while (rs.next()) {
            result = true;
         }
         rs.close();
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      } finally {
         DBResultSet.close(dbrs);
      }
      return result;
   }
   
    public static long deleteByKPITypeId(long kpi_typ_oid)
    { 
       DBResultSet dbrs = null;
       try {
            String sql = "DELETE FROM " + PstKPITypeDivsion.TBL_KPITYPEDivision+
                         " WHERE " + PstKPITypeDivsion.fieldNames[PstKPITypeDivsion.FLD_KPI_TYPE_ID] +
                         " = '" + kpi_typ_oid +"'";
                         
            int status = DBHandler.execUpdate(sql);
            return kpi_typ_oid;            
       }catch(Exception e) {
            System.out.println(e);            
        }
        finally{
            DBResultSet.close(dbrs);
        }
        
        return 0;
    }

}

   

