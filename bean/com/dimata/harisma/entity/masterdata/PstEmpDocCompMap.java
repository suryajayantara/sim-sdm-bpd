/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author keys
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;
import org.json.JSONObject;

public class PstEmpDocCompMap extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_EMP_DOC_COMP_MAP = "hr_emp_doc_comp_map";
   public static final int FLD_DOC_COMP_MAP_ID = 0;
   public static final int FLD_DOC_MASTER_ID = 1;
   public static final int FLD_COMPONENT_ID = 2;
   public static final int FLD_DAY_LENGTH = 3;
   public static final int FLD_PERIOD_ID = 4;

   public static String[] fieldNames = {
      "DOC_COMP_MAP_ID",
      "DOC_MASTER_ID",
      "COMPONENT_ID",
      "DAY_LENGTH",
      "PERIOD_ID"
   };

   public static int[] fieldTypes = {
      TYPE_LONG+TYPE_PK+TYPE_ID,
      TYPE_LONG,
      TYPE_LONG,
      TYPE_INT,
      TYPE_LONG
   };

   public PstEmpDocCompMap() {
   }

   public PstEmpDocCompMap(int i) throws DBException {
      super(new PstEmpDocCompMap());
   }

   public PstEmpDocCompMap(String sOid) throws DBException {
      super(new PstEmpDocCompMap(0));
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public PstEmpDocCompMap(long lOid) throws DBException {
      super(new PstEmpDocCompMap(0));
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
      return TBL_EMP_DOC_COMP_MAP;
   }

   public String[] getFieldNames() {
      return fieldNames;
   }

   public int[] getFieldTypes() {
      return fieldTypes;
   }

   public String getPersistentName() {
      return new PstEmpDocCompMap().getClass().getName();
   }

   public static EmpDocCompMap fetchExc(long oid) throws DBException {
      try {
         EmpDocCompMap entEmpdoccompmap = new EmpDocCompMap();
         PstEmpDocCompMap pstEmpdoccompmap = new PstEmpDocCompMap(oid);
          entEmpdoccompmap.setOID(oid);
          entEmpdoccompmap.setDocMasterId(pstEmpdoccompmap.getlong(FLD_DOC_MASTER_ID));
          entEmpdoccompmap.setComponentId(pstEmpdoccompmap.getlong(FLD_COMPONENT_ID));
          entEmpdoccompmap.setDayLength(pstEmpdoccompmap.getInt(FLD_DAY_LENGTH));
          entEmpdoccompmap.setPeriodId(pstEmpdoccompmap.getlong(FLD_PERIOD_ID));
         return entEmpdoccompmap;
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstEmpDocCompMap(0), DBException.UNKNOWN);
      }
   }

   public long fetchExc(Entity entity) throws Exception {
      EmpDocCompMap entEmpDocCompMap = fetchExc(entity.getOID());
      entity = (Entity) entEmpDocCompMap;
      return entEmpDocCompMap.getOID();
   }

   public static synchronized long updateExc(EmpDocCompMap entEmpDocCompMap) throws DBException {
      try {
         if (entEmpDocCompMap.getOID() != 0) {
            PstEmpDocCompMap pstEmpdoccompmap = new PstEmpDocCompMap(entEmpDocCompMap.getOID());
            pstEmpdoccompmap.setLong(FLD_DOC_MASTER_ID, entEmpDocCompMap.getDocMasterId());
            pstEmpdoccompmap.setLong(FLD_COMPONENT_ID, entEmpDocCompMap.getComponentId());
            pstEmpdoccompmap.setInt(FLD_DAY_LENGTH, entEmpDocCompMap.getDayLength());
            pstEmpdoccompmap.setLong(FLD_PERIOD_ID, entEmpDocCompMap.getPeriodId());
            pstEmpdoccompmap.update();
            return entEmpDocCompMap.getOID();
         }
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstEmpDocCompMap(0), DBException.UNKNOWN);
      }
      return 0;
   }

   public long updateExc(Entity entity) throws Exception {
      return updateExc((EmpDocCompMap) entity);
   }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpDocCompMap pstEmpdoccompmap = new PstEmpDocCompMap(oid);
            pstEmpdoccompmap.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocCompMap(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpDocCompMap entEmpDocCompMap) throws DBException {
        try {
            PstEmpDocCompMap pstEmpdoccompmap = new PstEmpDocCompMap(0);
            pstEmpdoccompmap.setLong(FLD_DOC_MASTER_ID, entEmpDocCompMap.getDocMasterId());
            pstEmpdoccompmap.setLong(FLD_COMPONENT_ID, entEmpDocCompMap.getComponentId());
            pstEmpdoccompmap.setInt(FLD_DAY_LENGTH, entEmpDocCompMap.getDayLength());
            pstEmpdoccompmap.setLong(FLD_PERIOD_ID, entEmpDocCompMap.getPeriodId());
            pstEmpdoccompmap.insert();
            entEmpDocCompMap.setOID(pstEmpdoccompmap.getlong(FLD_DOC_MASTER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocCompMap(0), DBException.UNKNOWN);
        }
        return entEmpDocCompMap.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpDocCompMap) entity);
    }

    public static void resultToObject(ResultSet rs, EmpDocCompMap entEmpDocCompMap) {
        try {
            entEmpDocCompMap.setOID(rs.getLong(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_COMP_MAP_ID]));
            entEmpDocCompMap.setDocMasterId(rs.getLong(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID]));
            entEmpDocCompMap.setComponentId(rs.getLong(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_COMPONENT_ID]));
            entEmpDocCompMap.setDayLength(rs.getInt(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DAY_LENGTH]));
            entEmpDocCompMap.setPeriodId(rs.getLong(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_PERIOD_ID]));
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
            String sql = "SELECT * FROM " + TBL_EMP_DOC_COMP_MAP;
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
                EmpDocCompMap entEmpDocCompMap = new EmpDocCompMap();
                resultToObject(rs, entEmpDocCompMap);
                lists.add(entEmpDocCompMap);
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
            String sql = "SELECT COUNT(" + PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID] + ") FROM " + TBL_EMP_DOC_COMP_MAP;
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
                    EmpDocCompMap entEmpDocCompMap = (EmpDocCompMap) list.get(ls);
                    if (oid == entEmpDocCompMap.getOID()) {
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

    public static JSONObject fetchJSON(EmpDocCompMap entEmpDocCompMap){
      JSONObject object = new JSONObject();
      try {
         object.put(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_COMP_MAP_ID],""+entEmpDocCompMap.getOID());
         object.put(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID],""+entEmpDocCompMap.getDocMasterId());
         object.put(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_COMPONENT_ID],""+entEmpDocCompMap.getComponentId());
         object.put(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DAY_LENGTH],""+entEmpDocCompMap.getDayLength());
         object.put(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_PERIOD_ID],""+entEmpDocCompMap.getPeriodId());
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return object;
   }


   public static long syncExc(JSONObject jSONObject) throws DBException {
      long oid = 0;
      try{
         oid = Long.valueOf((String)jSONObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_COMP_MAP_ID]));         EmpDocCompMap entEmpDocCompMap = PstEmpDocCompMap.parseJsonObject(jSONObject);
         oid = entEmpDocCompMap.getOID();
         boolean chekOid = PstEmpDocCompMap.checkOID(oid);
            if(chekOid){
               // Doing update
               oid = PstEmpDocCompMap.updateExc(entEmpDocCompMap);
            }else{
               // Doing insert
               oid = PstEmpDocCompMap.insertExc(entEmpDocCompMap);
            }
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return oid;
   }


   private static EmpDocCompMap parseJsonObject(JSONObject jsonObject){
      EmpDocCompMap entEmpDocCompMap = new EmpDocCompMap();
      try {
         entEmpDocCompMap.setOID(Long.valueOf((String) jsonObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_COMP_MAP_ID])));
         entEmpDocCompMap.setDocMasterId(Long.valueOf((String) jsonObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID])));
         entEmpDocCompMap.setComponentId(Long.valueOf((String) jsonObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_COMPONENT_ID])));
         entEmpDocCompMap.setDayLength(Integer.valueOf((String) jsonObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DAY_LENGTH])));
         entEmpDocCompMap.setPeriodId(Long.valueOf((String) jsonObject.get(PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_PERIOD_ID])));
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return entEmpDocCompMap;
   }




   public static boolean checkOID(long docCompMapId ) {
      DBResultSet dbrs = null;
      boolean result = false;
      try{
         String sql = "SELECT * FROM " + TBL_EMP_DOC_COMP_MAP
            +" WHERE "+ PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_COMP_MAP_ID]
            +" = " + docCompMapId;
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
   
}