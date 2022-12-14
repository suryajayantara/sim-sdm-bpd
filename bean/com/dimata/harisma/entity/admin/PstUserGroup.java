/*
 * PstUserGroup.java
 *
 * Created on April 7, 2002, 9:29 AM
 */

package com.dimata.harisma.entity.admin;

/**
 *
 * @author  ktanjana
 * @version
 */

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;


public class PstUserGroup extends DBHandler implements I_DBInterface, I_DBType, I_Persintent  {
    
    public static final String TBL_USER_GROUP = "hr_user_group";
    public static final int FLD_USER_ID		= 0;
    public static final int FLD_GROUP_ID                 = 1;    
    
    public static  final String[] fieldNames = {
        "USER_ID", "GROUP_ID"
    } ;
    
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_FK + TYPE_LONG,
        TYPE_PK + TYPE_FK + TYPE_LONG
    };
    
    
    /** Creates new PstUserGroup */
    public PstUserGroup() {
    }
        
    public PstUserGroup(int i) throws DBException {
        super(new PstUserGroup());
    }
    
    
    public PstUserGroup(String sOid) throws DBException 
    {
        super(new PstUserGroup(0));
        if(!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    
    public PstUserGroup(long userOID, long groupOID) throws DBException 
    {
        super(new PstUserGroup(0));
        
        if(!locate(userOID, groupOID))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
        
    }
    
    
    /**
     *	Implemanting I_Entity interface methods
     */
    public int getFieldSize() {
        return fieldNames.length;
    }
    
    public String getTableName() {
        return TBL_USER_GROUP;
    }
    
    public String[] getFieldNames() {
        return fieldNames;
    }
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }
    
    public String getPersistentName() {                
        return new PstUserGroup().getClass().getName();
    }
    
    
    /**
     *	Implementing I_DBInterface interface methods
     */
    public long fetch(Entity ent) {        
        UserGroup entObj = PstUserGroup.fetch(ent.getOID(0),ent.getOID(1));
        ent = (Entity)entObj;
        return entObj.getOID();         
    }
    

    public long insert(Entity ent) {
        return PstUserGroup.insert((UserGroup) ent);
    }
    
    public long update(Entity ent) {
        return update((UserGroup) ent);
    }
    
    public long delete(Entity ent) {
        return delete((UserGroup) ent);
    }
        
    
    
    public static UserGroup fetch(long userID, long groupID)
    {
        UserGroup entObj = new UserGroup();
        try {
            PstUserGroup pstObj = new PstUserGroup(userID, groupID);
            entObj.setUserID(userID);
            entObj.setGroupID(groupID);
        }
        catch(DBException e) {
            System.out.println(e);
        }
        return entObj;
    }
    
     public static boolean listwithUserIdAndGroupId(long UserId,long GroupId)
    {
        boolean nilai = false;
        long us=0;
        DBResultSet dbrs=null;
        try {
            String sql = "SELECT USER_ID FROM " + TBL_USER_GROUP;
                    sql = sql + " WHERE USER_ID = "+UserId+" AND GROUP_ID = "+GroupId;


            dbrs=DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                us = rs.getLong(fieldNames[FLD_USER_ID]);
                if (us > 0){
                    nilai=true;
                }
            }
            return nilai;

       }catch(Exception e) {
            System.out.println(e);            
       }
       finally{
            DBResultSet.close(dbrs);
       }
       return false;
    }

    
    public static long insert(UserGroup entObj)
    {
        try{
            PstUserGroup pstObj = new PstUserGroup(0);
            
            pstObj.setLong(FLD_USER_ID, entObj.getUserID());            
            pstObj.setLong(FLD_GROUP_ID, entObj.getGroupID());
            
            pstObj.insert();            
            return entObj.getUserID();
        }
        catch(DBException e) {
            System.out.println(e);
        }
        return 0;  
    }
    

    public static long deleteByUser(long oid)
    {
       PstUserGroup pstObj = new PstUserGroup();
       DBResultSet dbrs=null;
       try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                         " WHERE " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] +
                         " = '" + oid +"'";
            System.out.println(sql);             
            int status = DBHandler.execUpdate(sql);
            return oid;            
       }catch(Exception e) {
            System.out.println(e);            
        }
        finally{
            DBResultSet.close(dbrs);
        }        
        
        return 0;
    }

    public static long deleteByGroup(long oid)
    {
       PstUserGroup pstObj = new PstUserGroup();
       DBResultSet dbrs=null;
       try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                         " WHERE " + PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] +
                         " = '" + oid +"'";
            System.out.println(sql);             
            int status = DBHandler.execUpdate(sql);
            return oid;            
       }catch(Exception e) {
            System.out.println(" PstUserGroup.deleteByPriv "+e);            
        }
        finally{
            DBResultSet.close(dbrs);
        }
        
        return 0;
    }
    

    public static long update(UserGroup entObj)
    {
        if(entObj != null && entObj.getUserID() != 0)
        {
            try {
                PstUserGroup pstObj = new PstUserGroup(entObj.getUserID(), entObj.getGroupID());
                
                pstObj.update();
                return entObj.getUserID();
            }catch(Exception e) {
                System.out.println(e);
            }            
        }
        return 0;
    }
   
    
    public static Vector listAll()
    {
        return list(0, 0, null,null);
    }
    
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order)
    {
       Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_USER_GROUP;
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
                UserGroup userGroup = new UserGroup();
                resultToObject(rs, userGroup);
                lists.add(userGroup);
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
    
    public static void resultToObject(ResultSet rs, UserGroup userGroup) {
        try {
            userGroup.setOID(rs.getLong(fieldNames[FLD_USER_ID]));
            userGroup.setUserID(rs.getLong(fieldNames[FLD_USER_ID]));
            userGroup.setGroupID(rs.getLong(fieldNames[FLD_GROUP_ID]));
        } catch (Exception e) {
        }
    }
    
}
