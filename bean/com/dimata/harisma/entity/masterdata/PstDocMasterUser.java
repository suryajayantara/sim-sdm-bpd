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
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author IanRizky
 */
public class PstDocMasterUser extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_DOC_MASTER_USER = "hr_doc_master_user";
   public static final int FLD_DOC_MASTER_ID = 0;
   public static final int FLD_USER_ID = 1;
   
    public static final String[] fieldNames = {
      "DOC_MASTER_ID",
      "USER_ID"
    };
    public static final int[] fieldTypes = {
        TYPE_PK + TYPE_FK + TYPE_LONG,
        TYPE_PK + TYPE_FK + TYPE_LONG
    };

   public PstDocMasterUser() {
   }

    public PstDocMasterUser(int i) throws DBException {
        super(new PstDocMasterUser());
    }

    public PstDocMasterUser(String sOid) throws DBException {
        super(new PstDocMasterUser(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDocMasterUser(long lOid) throws DBException {
        super(new PstDocMasterUser(0));
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
	
	public PstDocMasterUser(long docMasterId, long userId) throws DBException {
        super(new PstDocMasterUser(0));
        long[] arrId = {docMasterId, userId};
        if (!locate(arrId))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_HR_DOC_MASTER_USER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDocMasterUser().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocMasterUser docMaster = fetchExc(ent.getOID());
        ent = (Entity) docMaster;
        return docMaster.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocMasterUser) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocMasterUser) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocMasterUser fetchExc(long oid) throws DBException {
        try {
            DocMasterUser docUser = new DocMasterUser();
            PstDocMasterUser pstDocMasterAction = new PstDocMasterUser(oid);
            docUser.setOID(oid);

            docUser.setDocMasterId(pstDocMasterAction.getLong(FLD_DOC_MASTER_ID));         
            docUser.setUserId(pstDocMasterAction.getLong(FLD_USER_ID));

            return docUser;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterUser(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DocMasterUser docUser) throws DBException {
        try {
            PstDocMasterUser pstDocMasterAction = new PstDocMasterUser(0);

            pstDocMasterAction.setLong(FLD_DOC_MASTER_ID, docUser.getDocMasterId());
            pstDocMasterAction.setLong(FLD_USER_ID, docUser.getUserId());
          
            pstDocMasterAction.insert();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterUser(0), DBException.UNKNOWN);
        }
        return docUser.getOID();
    }

    public static long updateExc(DocMasterUser docUser) throws DBException {
        try {
            if (docUser.getOID() != 0) {
                PstDocMasterUser pstDocMasterAction = new PstDocMasterUser(docUser.getOID());

                pstDocMasterAction.setLong(FLD_DOC_MASTER_ID, docUser.getDocMasterId());
                pstDocMasterAction.setLong(FLD_USER_ID, docUser.getUserId());

                pstDocMasterAction.update();
                return docUser.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterUser(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDocMasterUser pstDocMasterAction = new PstDocMasterUser(oid);
            pstDocMasterAction.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterUser(0), DBException.UNKNOWN);
        }
        return oid;
    }
	
	public static long deleteExc(long docMasterId, long userId) throws DBException {
        try {
            PstDocMasterUser pstDocMasterUser = new PstDocMasterUser(docMasterId, userId);
            pstDocMasterUser.delete();

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterUser(0), DBException.UNKNOWN);
        }
        return docMasterId;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER_USER;
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
                DocMasterUser docMaster = new DocMasterUser();
                resultToObject(rs, docMaster);
                lists.add(docMaster);
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
    
      public static void resultToObject(ResultSet rs, DocMasterUser docUser) {
        try {
               docUser.setDocMasterId(rs.getLong(PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_DOC_MASTER_ID]));
               docUser.setUserId(rs.getLong(PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_USER_ID]));
            
        } catch (Exception e) {
        }
    }
    
    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_DOC_MASTER_ID] + ") FROM " + TBL_HR_DOC_MASTER_USER;
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
                    DocMasterUser docMaster = (DocMasterUser) list.get(ls);
                    if (oid == docMaster.getOID()) {
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
