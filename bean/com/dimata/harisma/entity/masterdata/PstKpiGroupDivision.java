/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import static com.dimata.qdep.db.I_DBType.*;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author keys
 */
public class PstKpiGroupDivision extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language  {
   public static final String TBL_KPI_GROUP_DIVISION = "hr_kpi_group_division";
   public static final int FLD_KPI_GROUP_DIVISION_ID = 0;
   public static final int FLD_KPI_GROUP_ID = 1;
   public static final int FLD_DIVISION_ID = 2;

   public static String[] fieldNames = {
      "KPI_GROUP_DIVISION_ID",
      "KPI_GROUP_ID",
      "DIVISION_ID"
   };

   public static int[] fieldTypes = {
      TYPE_LONG+TYPE_PK+TYPE_ID,
      TYPE_LONG,
      TYPE_LONG
   };

   public PstKpiGroupDivision() {
   }

   public PstKpiGroupDivision(int i) throws DBException {
      super(new PstKpiGroupDivision());
   }

   public PstKpiGroupDivision(String sOid) throws DBException {
      super(new PstKpiGroupDivision(0));
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public PstKpiGroupDivision(long lOid) throws DBException {
      super(new PstKpiGroupDivision(0));
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
      return TBL_KPI_GROUP_DIVISION;
   }

   public String[] getFieldNames() {
      return fieldNames;
   }

   public int[] getFieldTypes() {
      return fieldTypes;
   }

   public String getPersistentName() {
      return new PstKpiGroupDivision().getClass().getName();
   }

   public static KpiGroupDivision fetchExc(long oid) throws DBException {
      try {
         KpiGroupDivision entKpiGroupDivision = new KpiGroupDivision();
         PstKpiGroupDivision pstKpitypecompany = new PstKpiGroupDivision(oid);
          entKpiGroupDivision.setOID(oid);
          entKpiGroupDivision.setKpiGroupId(pstKpitypecompany.getlong(FLD_KPI_GROUP_ID));
          entKpiGroupDivision.setDivisionId(pstKpitypecompany.getlong(FLD_DIVISION_ID));
         return entKpiGroupDivision;
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKpiGroupDivision(0), DBException.UNKNOWN);
      }
   }

   public long fetchExc(Entity entity) throws Exception {
      KpiGroupDivision entKpiGroupDivision = fetchExc(entity.getOID());
      entity = (Entity) entKpiGroupDivision;
      return entKpiGroupDivision.getOID();
   }

   public static synchronized long updateExc(KpiGroupDivision entKpiGroupDivision) throws DBException {
      try {
         if (entKpiGroupDivision.getOID() != 0) {
            PstKpiGroupDivision pstKpiGroupDivision = new PstKpiGroupDivision(entKpiGroupDivision.getOID());
            pstKpiGroupDivision.setLong(FLD_KPI_GROUP_ID, entKpiGroupDivision.getKpiGroupId());
            pstKpiGroupDivision.setLong(FLD_DIVISION_ID, entKpiGroupDivision.getDivisionId());
            pstKpiGroupDivision.update();
            return entKpiGroupDivision.getOID();
         }
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKpiGroupDivision(0), DBException.UNKNOWN);
      }
      return 0;
   }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiGroupDivision) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiGroupDivision pstKpiGroupDivision = new PstKpiGroupDivision(oid);
            pstKpiGroupDivision.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiGroupDivision(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiGroupDivision entKpiGroupDivision) throws DBException {
        try {
            PstKpiGroupDivision pstKpiGroupDivision = new PstKpiGroupDivision(0);
            pstKpiGroupDivision.setLong(FLD_KPI_GROUP_ID, entKpiGroupDivision.getKpiGroupId());
            pstKpiGroupDivision.setLong(FLD_DIVISION_ID, entKpiGroupDivision.getDivisionId());
            pstKpiGroupDivision.insert();
            entKpiGroupDivision.setOID(pstKpiGroupDivision.getlong(FLD_KPI_GROUP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiGroupDivision(0), DBException.UNKNOWN);
        }
        return entKpiGroupDivision.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiGroupDivision) entity);
    }

    public static void resultToObject(ResultSet rs, KpiGroupDivision entKpiGroupDivision) {
        try {
            entKpiGroupDivision.setOID(rs.getLong(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_DIVISION_ID]));
            entKpiGroupDivision.setKpiGroupId(rs.getLong(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID]));
            entKpiGroupDivision.setDivisionId(rs.getLong(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_DIVISION_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPI_GROUP_DIVISION;
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
                KpiGroupDivision entKpiGroupDivision = new KpiGroupDivision();
                resultToObject(rs, entKpiGroupDivision);
                lists.add(entKpiGroupDivision);
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
            String sql = "SELECT * FROM " + TBL_KPI_GROUP_DIVISION;
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
                lists.put(rs.getLong(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_DIVISION_ID]),rs.getLong(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID]));
                
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
            String sql = "SELECT COUNT(" + PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID] + ") FROM " + TBL_KPI_GROUP_DIVISION;
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
                    KpiGroupDivision entKpiGroupDivision = (KpiGroupDivision) list.get(ls);
                    if (oid == entKpiGroupDivision.getOID()) {
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

    public static JSONObject fetchJSON(KpiGroupDivision entKpiGroupDivision){
      JSONObject object = new JSONObject();
      try {
         object.put(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_DIVISION_ID],""+entKpiGroupDivision.getOID());
         object.put(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID],""+entKpiGroupDivision.getKpiGroupId());
         object.put(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_DIVISION_ID],""+entKpiGroupDivision.getDivisionId());
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return object;
   }


   public static long syncExc(JSONObject jSONObject) throws DBException {
      long oid = 0;
      try{
         oid = Long.valueOf((String)jSONObject.get(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_DIVISION_ID]));         KpiGroupDivision entKpiGroupDivision = PstKpiGroupDivision.parseJsonObject(jSONObject);
         oid = entKpiGroupDivision.getOID();
         boolean chekOid = PstKpiGroupDivision.checkOID(oid);
            if(chekOid){
               // Doing update
               oid = PstKpiGroupDivision.updateExc(entKpiGroupDivision);
            }else{
               // Doing insert
               oid = PstKpiGroupDivision.insertExc(entKpiGroupDivision);
            }
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return oid;
   }


   private static KpiGroupDivision parseJsonObject(JSONObject jsonObject){
      KpiGroupDivision entKpiGroupDivision = new KpiGroupDivision();
      try {
         entKpiGroupDivision.setOID(Long.valueOf((String) jsonObject.get(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_DIVISION_ID])));
         entKpiGroupDivision.setKpiGroupId(Long.valueOf((String) jsonObject.get(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID])));
         entKpiGroupDivision.setDivisionId(Long.valueOf((String) jsonObject.get(PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_DIVISION_ID])));
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return entKpiGroupDivision;
   }

   public static boolean checkOID(long kpiGroupDivisionId ) {
      DBResultSet dbrs = null;
      boolean result = false;
      try{
         String sql = "SELECT * FROM " + TBL_KPI_GROUP_DIVISION
            +" WHERE "+ PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_DIVISION_ID]
            +" = " + kpiGroupDivisionId;
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
   
    public static long deleteByKpiGroupId(long kpi_group_id)
    { 
       DBResultSet dbrs = null;
       try {
            String sql = "DELETE FROM " + PstKpiGroupDivision.TBL_KPI_GROUP_DIVISION+
                         " WHERE " + PstKpiGroupDivision.fieldNames[PstKpiGroupDivision.FLD_KPI_GROUP_ID] +
                         " = '" + kpi_group_id +"'";
                         
            int status = DBHandler.execUpdate(sql);
            return status;            
       }catch(Exception e) {
            System.out.println(e);            
        }
        finally{
            DBResultSet.close(dbrs);
        }
        
        return 0;
    }
    
     public static Vector listKpiGroupDivision(long oid_kpi_group) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n" +
                        "  DISTINCT(divi.`DIVISION_ID`) AS DIVISION_ID\n" +
                        "FROM\n" +
                        "  hr_division divi\n" +
                        "  INNER JOIN `hr_kpi_group_division` AS map\n" +
                        "  ON divi.`DIVISION_ID` = map.`DIVISION_ID`\n" +
                        "WHERE map.kpi_group_id = "+ oid_kpi_group;
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
}
