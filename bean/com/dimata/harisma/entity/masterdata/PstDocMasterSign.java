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
public class PstDocMasterSign extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language  {

   public static final String TBL_HR_DOC_MASTER_FLOW = "hr_doc_master_sign";
   public static final int FLD_DOC_MASTER_SIGN_ID = 0;
   public static final int FLD_DOC_MASTER_ID = 1;
   public static final int FLD_SIGN_INDEX = 2;
   public static final int FLD_POSITION_ID = 3;
   public static final int FLD_EMPLOYEE_ID = 4;
   public static final int FLD_SIGN_FOR_DIVISION_ID = 5;
   
    public static final String[] fieldNames = {
      "DOC_MASTER_SIGN_ID",
      "DOC_MASTER_ID",
      "SIGN_INDEX",
      "POSITION_ID",
      "EMPLOYEE_ID",
      "SIGN_FOR_DIVISION_ID"

    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
      TYPE_INT,
      TYPE_LONG,
      TYPE_LONG,
      TYPE_LONG
    };
    
    public static final int POSITION= 1;
    public static final int EMPLOYEE = 2;
    public static String[] filterBy = {
        "-Select-","Jabatan", "Karyawan"
    };

   public PstDocMasterSign() {
   }

    public PstDocMasterSign(int i) throws DBException {
        super(new PstDocMasterSign());
    }

    public PstDocMasterSign(String sOid) throws DBException {
        super(new PstDocMasterSign(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDocMasterSign(long lOid) throws DBException {
        super(new PstDocMasterSign(0));
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
        return TBL_HR_DOC_MASTER_FLOW;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDocMasterSign().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocMasterSign docMasterSign = fetchExc(ent.getOID());
        ent = (Entity) docMasterSign;
        return docMasterSign.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocMasterSign) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocMasterSign) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocMasterSign fetchExc(long oid) throws DBException {
        try {
            DocMasterSign docMasterSign = new DocMasterSign();
            PstDocMasterSign pstDocMasterFlow = new PstDocMasterSign(oid);
            docMasterSign.setOID(oid);

         docMasterSign.setDocMasterId(pstDocMasterFlow.getlong(FLD_DOC_MASTER_ID));
         docMasterSign.setSignIndex(pstDocMasterFlow.getInt(FLD_SIGN_INDEX));
         docMasterSign.setPositionId(pstDocMasterFlow.getlong(FLD_POSITION_ID));
         docMasterSign.setEmployeeId(pstDocMasterFlow.getlong(FLD_EMPLOYEE_ID));
         docMasterSign.setSignForDivisionId(pstDocMasterFlow.getlong(FLD_SIGN_FOR_DIVISION_ID));
         
            
            
            return docMasterSign;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterSign(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DocMasterSign docMasterSign) throws DBException {
        try {
            PstDocMasterSign pstDocMasterFlow = new PstDocMasterSign(0);

            pstDocMasterFlow.setLong(FLD_DOC_MASTER_ID, docMasterSign.getDocMasterId());
            pstDocMasterFlow.setInt(FLD_SIGN_INDEX, docMasterSign.getSignIndex());
            pstDocMasterFlow.setLong(FLD_POSITION_ID, docMasterSign.getPositionId());
            pstDocMasterFlow.setLong(FLD_EMPLOYEE_ID, docMasterSign.getEmployeeId());
            pstDocMasterFlow.setLong(FLD_SIGN_FOR_DIVISION_ID, docMasterSign.getSignForDivisionId());
            
            pstDocMasterFlow.insert();
            docMasterSign.setOID(pstDocMasterFlow.getlong(FLD_DOC_MASTER_SIGN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterSign(0), DBException.UNKNOWN);
        }
        return docMasterSign.getOID();
    }

    public static long updateExc(DocMasterSign docMasterSign) throws DBException {
        try {
            if (docMasterSign.getOID() != 0) {
                PstDocMasterSign pstDocMasterFlow = new PstDocMasterSign(docMasterSign.getOID());

                pstDocMasterFlow.setLong(FLD_DOC_MASTER_ID, docMasterSign.getDocMasterId());
				pstDocMasterFlow.setInt(FLD_SIGN_INDEX, docMasterSign.getSignIndex());
				pstDocMasterFlow.setLong(FLD_POSITION_ID, docMasterSign.getPositionId());
				pstDocMasterFlow.setLong(FLD_EMPLOYEE_ID, docMasterSign.getEmployeeId());
				pstDocMasterFlow.setLong(FLD_SIGN_FOR_DIVISION_ID, docMasterSign.getSignForDivisionId());
            
                pstDocMasterFlow.update();
                return docMasterSign.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterSign(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDocMasterSign pstDocMasterFlow = new PstDocMasterSign(oid);
            pstDocMasterFlow.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterSign(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER_FLOW;
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
                DocMasterSign docMasterSign = new DocMasterSign();
                resultToObject(rs, docMasterSign);
                lists.add(docMasterSign);
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
    
      public static void resultToObject(ResultSet rs, DocMasterSign docMasterSign) {
        try {
  
               docMasterSign.setOID(rs.getLong(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_SIGN_ID]));
               docMasterSign.setDocMasterId(rs.getLong(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_ID]));
               docMasterSign.setSignIndex(rs.getInt(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_SIGN_INDEX]));
               docMasterSign.setPositionId(rs.getLong(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_POSITION_ID]));
               docMasterSign.setEmployeeId(rs.getLong(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_EMPLOYEE_ID]));
               docMasterSign.setSignForDivisionId(rs.getLong(PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_SIGN_FOR_DIVISION_ID]));
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long docMasterFlowId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER_FLOW + " WHERE "
                    + PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_SIGN_ID] + " = " + docMasterFlowId;

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
            String sql = "SELECT COUNT(" + PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_SIGN_ID] + ") FROM " + TBL_HR_DOC_MASTER_FLOW;
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
                    DocMasterSign docMasterSign = (DocMasterSign) list.get(ls);
                    if (oid == docMasterSign.getOID()) {
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
