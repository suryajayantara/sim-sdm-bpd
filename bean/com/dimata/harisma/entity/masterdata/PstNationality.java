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
import java.util.Vector;

/**
 *
 * @author khirayinnura
 */
public class PstNationality extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_NATIONALITY = "hr_nationality";
    public static final int FLD_NATIONALITY_ID = 0;
    public static final int FLD_NATIONALITY_CODE = 1;
    public static final int FLD_NATIONALITY_NAME = 2;
    public static final int FLD_NATIONALITY_TYPE = 3;
    public static String[] fieldNames = {
        "NATIONALITY_ID",
        "NATIONALITY_CODE",
        "NATIONALITY_NAME",
        "NATIONALITY_TYPE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT
    };

    public static int[] typeValue = {
        0, 1
    };
    
    //digunakan untuk report LKPB 801
    public static String[] typeCode = {
        "1", "2"
    };
    
    public static String[] typeNames = {
        "Lokal", "Asing"
    };
    
    public PstNationality() {
    }

    public PstNationality(int i) throws DBException {
        super(new PstNationality());
    }

    public PstNationality(String sOid) throws DBException {
        super(new PstNationality(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstNationality(long lOid) throws DBException {
        super(new PstNationality(0));
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
        return TBL_HR_NATIONALITY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstNationality().getClass().getName();
    }

    public static Nationality fetchExc(long oid) throws DBException {
        try {
            Nationality entNationality = new Nationality();
            PstNationality pstNationality = new PstNationality(oid);
            entNationality.setOID(oid);
            entNationality.setNationalityCode(pstNationality.getString(FLD_NATIONALITY_CODE));
            entNationality.setNationalityName(pstNationality.getString(FLD_NATIONALITY_NAME));
            entNationality.setNationalityType(pstNationality.getInt(FLD_NATIONALITY_TYPE));
            return entNationality;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNationality(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Nationality entNationality = fetchExc(entity.getOID());
        entity = (Entity) entNationality;
        return entNationality.getOID();
    }

    public static synchronized long updateExc(Nationality entNationality) throws DBException {
        try {
            if (entNationality.getOID() != 0) {
                PstNationality pstNationality = new PstNationality(entNationality.getOID());
                pstNationality.setString(FLD_NATIONALITY_CODE, entNationality.getNationalityCode());
                pstNationality.setString(FLD_NATIONALITY_NAME, entNationality.getNationalityName());
                pstNationality.setInt(FLD_NATIONALITY_TYPE, entNationality.getNationalityType());
                pstNationality.update();
                return entNationality.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNationality(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Nationality) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstNationality pstNationality = new PstNationality(oid);
            pstNationality.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNationality(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Nationality entNationality) throws DBException {
        try {
            PstNationality pstNationality = new PstNationality(0);
            pstNationality.setString(FLD_NATIONALITY_CODE, entNationality.getNationalityCode());
            pstNationality.setString(FLD_NATIONALITY_NAME, entNationality.getNationalityName());
            pstNationality.setInt(FLD_NATIONALITY_TYPE, entNationality.getNationalityType());
            pstNationality.insert();
            entNationality.setOID(pstNationality.getLong(FLD_NATIONALITY_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNationality(0), DBException.UNKNOWN);
        }
        return entNationality.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Nationality) entity);
    }
    
    public static Vector listAll(){ 
        return list(0, 500, "",""); 
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order){
        Vector lists = new Vector(); 
        DBResultSet dbrs = null;
        
        try {
            String sql = "SELECT * FROM " + TBL_HR_NATIONALITY; 
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            if(limitStart == 0 && recordToGet == 0)
                sql = sql + "";
            else
                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
         
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                Nationality nationality = new Nationality();
                resultToObject(rs, nationality);
                lists.add(nationality);
            }
            rs.close();
            
            return lists;
        }
        catch(Exception e) {
            System.out.println(e);
        }
        finally {
            DBResultSet.close(dbrs);
        }
        
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, Nationality entNationality) {
        try {
            entNationality.setOID(rs.getLong(PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_ID]));
            entNationality.setNationalityCode(rs.getString(PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_CODE]));
            entNationality.setNationalityName(rs.getString(PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_NAME]));
            entNationality.setNationalityType(rs.getInt(PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_TYPE]));
        } catch (Exception e) {
        }
    }
    public static boolean checkOID(long natId){
        DBResultSet dbrs = null;
        boolean result = false;
        
        try{
            String sql = "SELECT * FROM " + TBL_HR_NATIONALITY + " WHERE " + 
                         PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_ID] + " = " + natId;
                    
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()) { result = true; }
            rs.close();
        }
        catch(Exception e){
            System.out.println("err : "+e.toString());
        }
        finally{
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause){
        DBResultSet dbrs = null;
        
        try {
            String sql = "SELECT COUNT("+ PstNationality.fieldNames[PstNationality.FLD_NATIONALITY_ID] + ") FROM " + TBL_HR_NATIONALITY;
            
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while(rs.next()) { count = rs.getInt(1); }

            rs.close();
            return count;
        }
        catch(Exception e) {
            return 0;
        }
        finally {
            DBResultSet.close(dbrs);
        }
    }

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause){
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found =false;
        
        for(int i=0; (i < size) && !found ; i=i+recordToGet){
             Vector list = list(i,recordToGet, whereClause, order); 
             start = i;
             
             if(list.size()>0) {                 
                for(int ls=0;ls<list.size();ls++){ 
                   Race race = (Race)list.get(ls);
                   
                   if(oid == race.getOID())
                      found=true;
                }
            }
        }
        
        if((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }
}
