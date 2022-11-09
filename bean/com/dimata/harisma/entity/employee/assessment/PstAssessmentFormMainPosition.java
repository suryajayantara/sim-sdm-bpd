/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee.assessment;

import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
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
public class PstAssessmentFormMainPosition extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
   public static final String TBL_ASS_FORM_MAIN_POSITION = "hr_ass_form_main_position";
   public static final int FLD_ASS_MAIN_FORM_POSITION_ID = 0;
   public static final int FLD_ASS_FORM_MAIN_ID = 1;
   public static final int FLD_POSITION_ID = 2;
   
    public static String[] fieldNames = {
      "ASS_MAIN_FORM_POSITION_ID",
      "ASS_FORM_MAIN_ID",
      "POSITION_ID"
   };

   public static int[] fieldTypes = {
      TYPE_LONG+TYPE_PK+TYPE_ID,
      TYPE_LONG,
      TYPE_LONG
   };

   public PstAssessmentFormMainPosition() {
   }

   public PstAssessmentFormMainPosition(int i) throws DBException {
      super(new PstAssessmentFormMainPosition());
   }

   public PstAssessmentFormMainPosition(String sOid) throws DBException {
      super(new PstAssessmentFormMainPosition(0));
      if(!locate(sOid))
         throw new DBException(this, DBException.RECORD_NOT_FOUND);
      else
         return;
   }

   public PstAssessmentFormMainPosition(long lOid) throws DBException {
      super(new PstAssessmentFormMainPosition(0));
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
      return TBL_ASS_FORM_MAIN_POSITION;
   }

   public String[] getFieldNames() {
      return fieldNames;
   }

   public int[] getFieldTypes() {
      return fieldTypes;
   }

   public String getPersistentName() {
      return new PstAssessmentFormMainPosition().getClass().getName();
   }

   public static AssessmentFormMainPosition fetchExc(long oid) throws DBException {
      try {
         AssessmentFormMainPosition entAssessmentFormMainPosition = new AssessmentFormMainPosition();
         PstAssessmentFormMainPosition pstKpitypecompany = new PstAssessmentFormMainPosition(oid);
          entAssessmentFormMainPosition.setOID(oid);
          entAssessmentFormMainPosition.setAssFormMainId(pstKpitypecompany.getlong(FLD_ASS_FORM_MAIN_ID));
          entAssessmentFormMainPosition.setPositionId(pstKpitypecompany.getlong(FLD_POSITION_ID));
         return entAssessmentFormMainPosition;
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstAssessmentFormMainPosition(0), DBException.UNKNOWN);
      }
   }

   public long fetchExc(Entity entity) throws Exception {
      AssessmentFormMainPosition entAssessmentFormMainPosition = fetchExc(entity.getOID());
      entity = (Entity) entAssessmentFormMainPosition;
      return entAssessmentFormMainPosition.getOID();
   }

   public static synchronized long updateExc(AssessmentFormMainPosition entAssessmentFormMainPosition) throws DBException {
      try {
         if (entAssessmentFormMainPosition.getOID() != 0) {
            PstAssessmentFormMainPosition pstAssessmentFormMainPosition = new PstAssessmentFormMainPosition(entAssessmentFormMainPosition.getOID());
            pstAssessmentFormMainPosition.setLong(FLD_ASS_FORM_MAIN_ID, entAssessmentFormMainPosition.getAssFormMainId());
            pstAssessmentFormMainPosition.setLong(FLD_POSITION_ID, entAssessmentFormMainPosition.getPositionId());
            pstAssessmentFormMainPosition.update();
            return entAssessmentFormMainPosition.getOID();
         }
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstAssessmentFormMainPosition(0), DBException.UNKNOWN);
      }
      return 0;
   }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((AssessmentFormMainPosition) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstAssessmentFormMainPosition pstAssessmentFormMainPosition = new PstAssessmentFormMainPosition(oid);
            pstAssessmentFormMainPosition.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessmentFormMainPosition(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(AssessmentFormMainPosition entAssessmentFormMainPosition) throws DBException {
        try {
            PstAssessmentFormMainPosition pstAssessmentFormMainPosition = new PstAssessmentFormMainPosition(0);
            pstAssessmentFormMainPosition.setLong(FLD_ASS_FORM_MAIN_ID, entAssessmentFormMainPosition.getAssFormMainId());
            pstAssessmentFormMainPosition.setLong(FLD_POSITION_ID, entAssessmentFormMainPosition.getPositionId());
            pstAssessmentFormMainPosition.insert();
            entAssessmentFormMainPosition.setOID(pstAssessmentFormMainPosition.getlong(FLD_ASS_FORM_MAIN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAssessmentFormMainPosition(0), DBException.UNKNOWN);
        }
        return entAssessmentFormMainPosition.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((AssessmentFormMainPosition) entity);
    }

    public static void resultToObject(ResultSet rs, AssessmentFormMainPosition entAssessmentFormMainPosition) {
        try {
            entAssessmentFormMainPosition.setOID(rs.getLong(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_MAIN_FORM_POSITION_ID]));
            entAssessmentFormMainPosition.setAssFormMainId(rs.getLong(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID]));
            entAssessmentFormMainPosition.setPositionId(rs.getLong(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_POSITION_ID]));
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
            String sql = "SELECT * FROM " + TBL_ASS_FORM_MAIN_POSITION;
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
                AssessmentFormMainPosition entAssessmentFormMainPosition = new AssessmentFormMainPosition();
                resultToObject(rs, entAssessmentFormMainPosition);
                lists.add(entAssessmentFormMainPosition);
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
            String sql = "SELECT * FROM " + TBL_ASS_FORM_MAIN_POSITION;
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
                lists.put(rs.getLong(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_POSITION_ID]),rs.getLong(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID]));
                
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
            String sql = "SELECT COUNT(" + PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID] + ") FROM " + TBL_ASS_FORM_MAIN_POSITION;
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
                    AssessmentFormMainPosition entAssessmentFormMainPosition = (AssessmentFormMainPosition) list.get(ls);
                    if (oid == entAssessmentFormMainPosition.getOID()) {
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

    public static JSONObject fetchJSON(AssessmentFormMainPosition entAssessmentFormMainPosition){
      JSONObject object = new JSONObject();
      try {
         object.put(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_MAIN_FORM_POSITION_ID],""+entAssessmentFormMainPosition.getOID());
         object.put(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID],""+entAssessmentFormMainPosition.getAssFormMainId());
         object.put(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_POSITION_ID],""+entAssessmentFormMainPosition.getPositionId());
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return object;
   }


   public static long syncExc(JSONObject jSONObject) throws DBException {
      long oid = 0;
      try{
         oid = Long.valueOf((String)jSONObject.get(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_MAIN_FORM_POSITION_ID]));         AssessmentFormMainPosition entAssessmentFormMainPosition = PstAssessmentFormMainPosition.parseJsonObject(jSONObject);
         oid = entAssessmentFormMainPosition.getOID();
         boolean chekOid = PstAssessmentFormMainPosition.checkOID(oid);
            if(chekOid){
               // Doing update
               oid = PstAssessmentFormMainPosition.updateExc(entAssessmentFormMainPosition);
            }else{
               // Doing insert
               oid = PstAssessmentFormMainPosition.insertExc(entAssessmentFormMainPosition);
            }
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return oid;
   }


   private static AssessmentFormMainPosition parseJsonObject(JSONObject jsonObject){
      AssessmentFormMainPosition entAssessmentFormMainPosition = new AssessmentFormMainPosition();
      try {
         entAssessmentFormMainPosition.setOID(Long.valueOf((String) jsonObject.get(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_MAIN_FORM_POSITION_ID])));
         entAssessmentFormMainPosition.setAssFormMainId(Long.valueOf((String) jsonObject.get(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID])));
         entAssessmentFormMainPosition.setPositionId(Long.valueOf((String) jsonObject.get(PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_POSITION_ID])));
      }catch(Exception exc){
         System.out.println("Err :"+exc);
      }
      return entAssessmentFormMainPosition;
   }

   public static boolean checkOID(long kpiGroupPositionId ) {
      DBResultSet dbrs = null;
      boolean result = false;
      try{
         String sql = "SELECT * FROM " + TBL_ASS_FORM_MAIN_POSITION
            +" WHERE "+ PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_MAIN_FORM_POSITION_ID]
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
   
    public static long deleteByAssFormMainId(long oid_ass_form_main)
    { 
       DBResultSet dbrs = null;
       try {
            String sql = "DELETE FROM " + PstAssessmentFormMainPosition.TBL_ASS_FORM_MAIN_POSITION+
                         " WHERE " + PstAssessmentFormMainPosition.fieldNames[PstAssessmentFormMainPosition.FLD_ASS_FORM_MAIN_ID] +
                         " = '" + oid_ass_form_main +"'";
                         
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
    
     public static Vector listAssessmentFormMainPosition(long oid_ass_main_form) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n" +
                        "  DISTINCT(pos.`POSITION_ID`) AS POSITION_ID\n" +
                        "FROM\n" +
                        "  hr_position pos\n" +
                        "  INNER JOIN `hr_ass_form_main_position` AS map\n" +
                        "  ON pos.`POSITION_ID` = map.`POSITION_ID`\n" +
                        "WHERE map.kpi_group_id = "+ oid_ass_main_form;
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
