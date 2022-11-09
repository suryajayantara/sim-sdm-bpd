/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
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
public class PstKpiGroupPosition  extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
     public static final String TBL_KPI_GROUP_POSITION = "hr_kpi_group_position";
   public static final int FLD_KPI_GROUP_POSITION_ID = 0;
   public static final int FLD_KPI_GROUP_ID = 1;
   public static final int FLD_POSITION_ID = 2;

   public static String[] fieldNames = {
      "KPI_GROUP_POSITION_ID",
      "KPI_GROUP_ID",
      "POSITION_ID"
   };

   public static int[] fieldTypes = {
      TYPE_LONG+TYPE_PK+TYPE_ID,
      TYPE_LONG,
      TYPE_LONG
   };

   public PstKpiGroupPosition() {
   }

   public PstKpiGroupPosition(int i) throws DBException {
      super(new PstKpiGroupPosition());
   }

   public PstKpiGroupPosition(String sOid) throws DBException {
      super(new PstKpiGroupPosition(0));
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public PstKpiGroupPosition(long lOid) throws DBException {
      super(new PstKpiGroupPosition(0));
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
      return TBL_KPI_GROUP_POSITION;
   }

   public String[] getFieldNames() {
      return fieldNames;
   }

   public int[] getFieldTypes() {
      return fieldTypes;
   }

   public String getPersistentName() {
      return new PstKpiGroupPosition().getClass().getName();
   }

   public static KpiGroupPosition fetchExc(long oid) throws DBException {
      try {
         KpiGroupPosition entKpiGroupPosition = new KpiGroupPosition();
         PstKpiGroupPosition pstKpitypecompany = new PstKpiGroupPosition(oid);
          entKpiGroupPosition.setOID(oid);
          entKpiGroupPosition.setKpiGroupId(pstKpitypecompany.getlong(FLD_KPI_GROUP_ID));
          entKpiGroupPosition.setPositionId(pstKpitypecompany.getlong(FLD_POSITION_ID));
         return entKpiGroupPosition;
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKpiGroupPosition(0), DBException.UNKNOWN);
      }
   }

   public long fetchExc(Entity entity) throws Exception {
      KpiGroupPosition entKpiGroupPosition = fetchExc(entity.getOID());
      entity = (Entity) entKpiGroupPosition;
      return entKpiGroupPosition.getOID();
   }

   public static synchronized long updateExc(KpiGroupPosition entKpiGroupPosition) throws DBException {
      try {
         if (entKpiGroupPosition.getOID() != 0) {
            PstKpiGroupPosition pstKpiGroupPosition = new PstKpiGroupPosition(entKpiGroupPosition.getOID());
            pstKpiGroupPosition.setLong(FLD_KPI_GROUP_ID, entKpiGroupPosition.getKpiGroupId());
            pstKpiGroupPosition.setLong(FLD_POSITION_ID, entKpiGroupPosition.getPositionId());
            pstKpiGroupPosition.update();
            return entKpiGroupPosition.getOID();
         }
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstKpiGroupPosition(0), DBException.UNKNOWN);
      }
      return 0;
   }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiGroupPosition) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiGroupPosition pstKpiGroupPosition = new PstKpiGroupPosition(oid);
            pstKpiGroupPosition.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiGroupPosition(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiGroupPosition entKpiGroupPosition) throws DBException {
        try {
            PstKpiGroupPosition pstKpiGroupPosition = new PstKpiGroupPosition(0);
            pstKpiGroupPosition.setLong(FLD_KPI_GROUP_ID, entKpiGroupPosition.getKpiGroupId());
            pstKpiGroupPosition.setLong(FLD_POSITION_ID, entKpiGroupPosition.getPositionId());
            pstKpiGroupPosition.insert();
            entKpiGroupPosition.setOID(pstKpiGroupPosition.getlong(FLD_KPI_GROUP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiGroupPosition(0), DBException.UNKNOWN);
        }
        return entKpiGroupPosition.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiGroupPosition) entity);
    }

    public static void resultToObject(ResultSet rs, KpiGroupPosition entKpiGroupPosition) {
        try {
            entKpiGroupPosition.setOID(rs.getLong(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_POSITION_ID]));
            entKpiGroupPosition.setKpiGroupId(rs.getLong(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID]));
            entKpiGroupPosition.setPositionId(rs.getLong(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_POSITION_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPI_GROUP_POSITION;
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
                KpiGroupPosition entKpiGroupPosition = new KpiGroupPosition();
                resultToObject(rs, entKpiGroupPosition);
                lists.add(entKpiGroupPosition);
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
            String sql = "SELECT * FROM " + TBL_KPI_GROUP_POSITION;
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
                lists.put(rs.getLong(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_POSITION_ID]),rs.getLong(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID]));
                
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
            String sql = "SELECT COUNT(" + PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID] + ") FROM " + TBL_KPI_GROUP_POSITION;
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
                    KpiGroupPosition entKpiGroupPosition = (KpiGroupPosition) list.get(ls);
                    if (oid == entKpiGroupPosition.getOID()) {
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

    public static JSONObject fetchJSON(KpiGroupPosition entKpiGroupPosition){
      JSONObject object = new JSONObject();
      try {
         object.put(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_POSITION_ID],""+entKpiGroupPosition.getOID());
         object.put(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID],""+entKpiGroupPosition.getKpiGroupId());
         object.put(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_POSITION_ID],""+entKpiGroupPosition.getPositionId());
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return object;
   }


   public static long syncExc(JSONObject jSONObject) throws DBException {
      long oid = 0;
      try{
         oid = Long.valueOf((String)jSONObject.get(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_POSITION_ID]));         KpiGroupPosition entKpiGroupPosition = PstKpiGroupPosition.parseJsonObject(jSONObject);
         oid = entKpiGroupPosition.getOID();
         boolean chekOid = PstKpiGroupPosition.checkOID(oid);
            if(chekOid){
               // Doing update
               oid = PstKpiGroupPosition.updateExc(entKpiGroupPosition);
            }else{
               // Doing insert
               oid = PstKpiGroupPosition.insertExc(entKpiGroupPosition);
            }
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return oid;
   }


   private static KpiGroupPosition parseJsonObject(JSONObject jsonObject){
      KpiGroupPosition entKpiGroupPosition = new KpiGroupPosition();
      try {
         entKpiGroupPosition.setOID(Long.valueOf((String) jsonObject.get(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_POSITION_ID])));
         entKpiGroupPosition.setKpiGroupId(Long.valueOf((String) jsonObject.get(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID])));
         entKpiGroupPosition.setPositionId(Long.valueOf((String) jsonObject.get(PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_POSITION_ID])));
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return entKpiGroupPosition;
   }

   public static boolean checkOID(long kpiGroupPositionId ) {
      DBResultSet dbrs = null;
      boolean result = false;
      try{
         String sql = "SELECT * FROM " + TBL_KPI_GROUP_POSITION
            +" WHERE "+ PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_POSITION_ID]
            +" = " + kpiGroupPositionId;
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
            String sql = "DELETE FROM " + PstKpiGroupPosition.TBL_KPI_GROUP_POSITION+
                         " WHERE " + PstKpiGroupPosition.fieldNames[PstKpiGroupPosition.FLD_KPI_GROUP_ID] +
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
    
     public static Vector listKpiGroupPosition(long oid_kpi_group) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n" +
                        "  DISTINCT(pos.`POSITION_ID`) AS POSITION_ID\n" +
                        "FROM\n" +
                        "  hr_position pos\n" +
                        "  INNER JOIN `hr_kpi_group_position` AS map\n" +
                        "  ON pos.`POSITION_ID` = map.`POSITION_ID`\n" +
                        "WHERE map.kpi_group_id = "+ oid_kpi_group;
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
     
}
