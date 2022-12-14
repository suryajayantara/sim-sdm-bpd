
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	: lkarunia
 * @version  	: 01
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 ******************************************************************
 */
package com.dimata.harisma.entity.employee;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.harisma.entity.masterdata.*;

/* package  harisma */
//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata.harisma.db.DBLogger;
import com.dimata.harisma.entity.employee.*;

//Gede_7Feb2012 {
import com.dimata.harisma.session.employee.*;
import com.dimata.harisma.entity.search.*;
import com.dimata.harisma.entity.payroll.*;
//}
public class PstFamilyMember extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_FAMILY_MEMBER = "hr_family_member";//"HR_FAMILY_MEMBER";
    public static final int FLD_FAMILY_MEMBER_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_FULL_NAME = 2;
    public static final int FLD_RELATIONSHIP = 3;
    public static final int FLD_BIRTH_DATE = 4;
    public static final int FLD_JOB = 5;
    public static final int FLD_ADDRESS = 6;
    public static final int FLD_GUARANTEED = 7;
    public static final int FLD_IGNORE_BIRTH = 8;
    public static final int FLD_EDUCATION_ID = 9;
    public static final int FLD_RELIGION_ID = 10;
    public static final int FLD_SEX = 11;

    /* Add Field by Hendra Putu | 2016-03-27 */
    public static final int FLD_CARD_ID = 12;
    public static final int FLD_NO_TELP = 13;
    public static final int FLD_BPJS_NO = 14;
    public static final int FLD_JOB_PLACE = 15;
    public static final int FLD_JOB_POSITION = 16;
    //add by eri yudi 2020-07-07
     public static final int FLD_BIRTH_PLACE = 17;
    public static final String[] fieldNames = {
        "FAMILY_MEMBER_ID",
        "EMPLOYEE_ID",
        "FULL_NAME",
        "RELATIONSHIP",
        "BIRTH_DATE",
        "JOB",
        "ADDRESS",
        "GUARANTEED",
        "IGNORE_BIRTH",
        "EDUCATION_ID",
        "RELIGION_ID",
        "SEX",
        "CARD_ID",
        "NO_TELP",
        "BPJS_NUM",
        "JOB_PLACE",
        "JOB_POSITION",
        "BIRTH_PLACE"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_BOOL,
        TYPE_BOOL,
        TYPE_LONG + TYPE_FK,
        TYPE_LONG + TYPE_FK,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    /*
     public static final int REL_WIFE			= 0;
     public static final int REL_HUSBAND			= 1;
     public static final int REL_CHILDREN		= 2;

     public static String[] relationValue = {"Wife","Husband","Children"};

     public static Vector getRelation(){
     Vector result = new Vector(1,1);
     for(int i=0;i<relationValue.length;i++){
     result.add(relationValue[i]);
     }
     return result;
     }*/
    
    //variable untuk query log history
    private static String query = "";
    
    public String getQuery(){
        return query;
    }
    
    public PstFamilyMember() {
    }

    public PstFamilyMember(int i) throws DBException {
        super(new PstFamilyMember());
    }

    public PstFamilyMember(String sOid) throws DBException {
        super(new PstFamilyMember(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstFamilyMember(long lOid) throws DBException {
        super(new PstFamilyMember(0));
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
        return TBL_HR_FAMILY_MEMBER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstFamilyMember().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FamilyMember familymember = fetchExc(ent.getOID());
        ent = (Entity) familymember;
        return familymember.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FamilyMember) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FamilyMember) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FamilyMember fetchExc(long oid) throws DBException {
        try {
            FamilyMember familymember = new FamilyMember();
            PstFamilyMember pstFamilyMember = new PstFamilyMember(oid);
            familymember.setOID(oid);

            familymember.setEmployeeId(pstFamilyMember.getlong(FLD_EMPLOYEE_ID));
            familymember.setFullName(pstFamilyMember.getString(FLD_FULL_NAME));
            familymember.setRelationship(pstFamilyMember.getString(FLD_RELATIONSHIP));
            familymember.setBirthDate(pstFamilyMember.getDate(FLD_BIRTH_DATE));
            familymember.setJob(pstFamilyMember.getString(FLD_JOB));
            familymember.setAddress(pstFamilyMember.getString(FLD_ADDRESS));
            familymember.setGuaranteed(pstFamilyMember.getboolean(FLD_GUARANTEED));
            familymember.setIgnoreBirth(pstFamilyMember.getboolean(FLD_IGNORE_BIRTH));
            familymember.setEducationId(pstFamilyMember.getlong(FLD_EDUCATION_ID));
            familymember.setReligionId(pstFamilyMember.getlong(FLD_RELIGION_ID));
            familymember.setSex(pstFamilyMember.getInt(FLD_SEX));

            familymember.setCardId(pstFamilyMember.getString(FLD_CARD_ID));

            familymember.setNoTelp(pstFamilyMember.getLong(FLD_NO_TELP));
            familymember.setBpjsNum(pstFamilyMember.getString(FLD_BPJS_NO));
            familymember.setJobPlace(pstFamilyMember.getString(FLD_JOB_PLACE));
            familymember.setJobPosition(pstFamilyMember.getString(FLD_JOB_POSITION));
            familymember.setBirtPlace(pstFamilyMember.getString(FLD_BIRTH_PLACE));
            return familymember;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(FamilyMember familymember) throws DBException {
        try {
            PstFamilyMember pstFamilyMember = new PstFamilyMember(0);

            pstFamilyMember.setLong(FLD_EMPLOYEE_ID, familymember.getEmployeeId());
            pstFamilyMember.setString(FLD_FULL_NAME, familymember.getFullName());
            pstFamilyMember.setString(FLD_RELATIONSHIP, familymember.getRelationship());
            pstFamilyMember.setDate(FLD_BIRTH_DATE, familymember.getBirthDate());
            pstFamilyMember.setString(FLD_JOB, familymember.getJob());
            pstFamilyMember.setString(FLD_ADDRESS, familymember.getAddress());
            pstFamilyMember.setboolean(FLD_GUARANTEED, familymember.getGuaranteed());
            pstFamilyMember.setboolean(FLD_IGNORE_BIRTH, familymember.getIgnoreBirth());
            pstFamilyMember.setLong(FLD_EDUCATION_ID, familymember.getEducationId());
            pstFamilyMember.setLong(FLD_RELIGION_ID, familymember.getReligionId());
            pstFamilyMember.setInt(FLD_SEX, familymember.getSex());

            pstFamilyMember.setString(FLD_CARD_ID, familymember.getCardId());

            pstFamilyMember.setLong(FLD_NO_TELP, familymember.getNoTelp());
            pstFamilyMember.setString(FLD_BPJS_NO, familymember.getBpjsNum());
            pstFamilyMember.setString(FLD_JOB_PLACE, familymember.getJobPlace());
            pstFamilyMember.setString(FLD_JOB_POSITION, familymember.getJobPosition());
            pstFamilyMember.setString(FLD_BIRTH_PLACE, familymember.getBirtPlace());

            pstFamilyMember.insert();
            familymember.setOID(pstFamilyMember.getlong(FLD_FAMILY_MEMBER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return familymember.getOID();
    }
    
    public static long insertExcPending(FamilyMember familymember) throws DBException {
        try {
            PstFamilyMember pstFamilyMember = new PstFamilyMember(0);

            pstFamilyMember.setLong(FLD_EMPLOYEE_ID, familymember.getEmployeeId());
            pstFamilyMember.setString(FLD_FULL_NAME, familymember.getFullName());
            pstFamilyMember.setString(FLD_RELATIONSHIP, familymember.getRelationship());
            pstFamilyMember.setDate(FLD_BIRTH_DATE, familymember.getBirthDate());
            pstFamilyMember.setString(FLD_JOB, familymember.getJob());
            pstFamilyMember.setString(FLD_ADDRESS, familymember.getAddress());
            pstFamilyMember.setboolean(FLD_GUARANTEED, familymember.getGuaranteed());
            pstFamilyMember.setboolean(FLD_IGNORE_BIRTH, familymember.getIgnoreBirth());
            pstFamilyMember.setLong(FLD_EDUCATION_ID, familymember.getEducationId());
            pstFamilyMember.setLong(FLD_RELIGION_ID, familymember.getReligionId());
            pstFamilyMember.setInt(FLD_SEX, familymember.getSex());

            pstFamilyMember.setString(FLD_CARD_ID, familymember.getCardId());

            pstFamilyMember.setLong(FLD_NO_TELP, familymember.getNoTelp());
            pstFamilyMember.setString(FLD_BPJS_NO, familymember.getBpjsNum());
            pstFamilyMember.setString(FLD_JOB_PLACE, familymember.getJobPlace());
            pstFamilyMember.setString(FLD_JOB_POSITION, familymember.getJobPosition());
            pstFamilyMember.setString(FLD_BIRTH_PLACE, familymember.getBirtPlace());

            query = pstFamilyMember.getInsertQuery();
            familymember.setOID(pstFamilyMember.getlong(FLD_FAMILY_MEMBER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return familymember.getOID();
    }
    
    public static long updateExc(FamilyMember familymember) throws DBException {
        try {
            if (familymember.getOID() != 0) {
                PstFamilyMember pstFamilyMember = new PstFamilyMember(familymember.getOID());

                pstFamilyMember.setLong(FLD_EMPLOYEE_ID, familymember.getEmployeeId());
                pstFamilyMember.setString(FLD_FULL_NAME, familymember.getFullName());
                pstFamilyMember.setString(FLD_RELATIONSHIP, familymember.getRelationship());
                pstFamilyMember.setDate(FLD_BIRTH_DATE, familymember.getBirthDate());
                pstFamilyMember.setString(FLD_JOB, familymember.getJob());
                pstFamilyMember.setString(FLD_ADDRESS, familymember.getAddress());
                pstFamilyMember.setboolean(FLD_GUARANTEED, familymember.getGuaranteed());
                pstFamilyMember.setboolean(FLD_IGNORE_BIRTH, familymember.getIgnoreBirth());
                pstFamilyMember.setLong(FLD_EDUCATION_ID, familymember.getEducationId());
                pstFamilyMember.setLong(FLD_RELIGION_ID, familymember.getReligionId());
                pstFamilyMember.setInt(FLD_SEX, familymember.getSex());

                pstFamilyMember.setString(FLD_CARD_ID, familymember.getCardId());


                pstFamilyMember.setLong(FLD_NO_TELP, familymember.getNoTelp());
                pstFamilyMember.setString(FLD_BPJS_NO, familymember.getBpjsNum());
                pstFamilyMember.setString(FLD_JOB_PLACE, familymember.getJobPlace());
                pstFamilyMember.setString(FLD_JOB_POSITION, familymember.getJobPosition());
                pstFamilyMember.setString(FLD_BIRTH_PLACE, familymember.getBirtPlace());

                pstFamilyMember.update();
                return familymember.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long updateExcPending(FamilyMember familymember) throws DBException {
        try {
            if (familymember.getOID() != 0) {
                PstFamilyMember pstFamilyMember = new PstFamilyMember(familymember.getOID());

                pstFamilyMember.setLong(FLD_EMPLOYEE_ID, familymember.getEmployeeId());
                pstFamilyMember.setString(FLD_FULL_NAME, familymember.getFullName());
                pstFamilyMember.setString(FLD_RELATIONSHIP, familymember.getRelationship());
                pstFamilyMember.setDate(FLD_BIRTH_DATE, familymember.getBirthDate());
                pstFamilyMember.setString(FLD_JOB, familymember.getJob());
                pstFamilyMember.setString(FLD_ADDRESS, familymember.getAddress());
                pstFamilyMember.setboolean(FLD_GUARANTEED, familymember.getGuaranteed());
                pstFamilyMember.setboolean(FLD_IGNORE_BIRTH, familymember.getIgnoreBirth());
                pstFamilyMember.setLong(FLD_EDUCATION_ID, familymember.getEducationId());
                pstFamilyMember.setLong(FLD_RELIGION_ID, familymember.getReligionId());
                pstFamilyMember.setInt(FLD_SEX, familymember.getSex());

                pstFamilyMember.setString(FLD_CARD_ID, familymember.getCardId());


                pstFamilyMember.setLong(FLD_NO_TELP, familymember.getNoTelp());
                pstFamilyMember.setString(FLD_BPJS_NO, familymember.getBpjsNum());
                pstFamilyMember.setString(FLD_JOB_PLACE, familymember.getJobPlace());
                pstFamilyMember.setString(FLD_JOB_POSITION, familymember.getJobPosition());
                pstFamilyMember.setString(FLD_BIRTH_PLACE, familymember.getBirtPlace());

                query = pstFamilyMember.getUpdateSQL();
                return familymember.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    private FamRelation famRelation;

    public static void updateFamRelation(String PrevFamRelation, String FamilyRelation) {
        try {
            String sql = " UPDATE " + PstFamilyMember.TBL_HR_FAMILY_MEMBER + " SET "
                    + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + " = " + "'" + FamilyRelation + "'"
                    + " WHERE " + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + " = " + "'" + PrevFamRelation + "'";

            int status = DBHandler.execUpdate(sql);
        } catch (Exception exc) {
            System.out.println("error delete experience by employee " + exc.toString());
        }


    }

    public static boolean existFamRelation(String FamilyRelation) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + " FROM " + PstFamilyMember.TBL_HR_FAMILY_MEMBER + " AS FM "
                    + " WHERE " + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + " = '" + FamilyRelation + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            /*if (rs!=null){
             result = true;
             }
             } catch (Exception e) {
             System.out.println("Exception " + e.toString());
            
             }
             return result;*/
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

    public static long deleteExc(long oid) throws DBException {
        try {
            PstFamilyMember pstFamilyMember = new PstFamilyMember(oid);
            pstFamilyMember.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public static long deleteExcPending(long oid) throws DBException {
        try {
            PstFamilyMember pstFamilyMember = new PstFamilyMember(oid);
            query = pstFamilyMember.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public static String getQueryDelete(long oid) throws DBException {
        String query = "";
        try {
            PstFamilyMember pstFamilyMember = new PstFamilyMember(oid);
            query = pstFamilyMember.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFamilyMember(0), DBException.UNKNOWN);
        }
        return query;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            /**
             * Ari_20111008
             */
            String sql = "SELECT FM.*,FR." + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_TYPE] + " FROM " + TBL_HR_FAMILY_MEMBER + " AS FM "
                    + " LEFT JOIN " + PstFamRelation.TBL_HR_FAM_RELATION + " AS FR "
                    + "ON FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + " = "
                    + "FR." + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_ID];
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
            System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                FamilyMember familymember = new FamilyMember();
                resultToObject(rs, familymember);
                lists.add(familymember);
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

    /**
     * create by satrya 2013-07-31
     *
     * @param whereClause
     * @param order
     * @return
     */
    public static Vector listEmpFamily(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FULL_NAME]
                    + ",FR." + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_BIRTH_DATE]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_JOB]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_ADDRESS]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_GUARANTEED]
                    + ",REL." + PstReligion.fieldNames[PstReligion.FLD_RELIGION]
                    + ",EDU." + PstEducation.fieldNames[PstEducation.FLD_EDUCATION]
                    + ",FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_SEX] + " FROM " + PstFamilyMember.TBL_HR_FAMILY_MEMBER + " AS FM "
                    + " INNER JOIN " + PstFamRelation.TBL_HR_FAM_RELATION + " AS FR  ON FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + "=FR." + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_ID]
                    + " LEFT JOIN " + PstEducation.TBL_HR_EDUCATION + " AS EDU ON EDU." + PstEducation.fieldNames[PstEducation.FLD_EDUCATION_ID] + "=FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_EDUCATION_ID]
                    + " LEFT JOIN " + PstReligion.TBL_HR_RELIGION + " AS REL ON REL." + PstReligion.fieldNames[PstReligion.FLD_RELIGION_ID] + "=FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELIGION_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                //FamilyMember familymember = new FamilyMember(); xx
                SessEmpFamilyMember sessEmpFamilyMember = new SessEmpFamilyMember();
                sessEmpFamilyMember.setEmployeeId(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]));
                sessEmpFamilyMember.setFamilyRelation(rs.getString(PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION]));
                sessEmpFamilyMember.setBirthDate(rs.getDate(PstFamilyMember.fieldNames[PstFamilyMember.FLD_BIRTH_DATE]));
                sessEmpFamilyMember.setJob(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_JOB]));
                sessEmpFamilyMember.setAddress(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_ADDRESS]));
                sessEmpFamilyMember.setGuaranted(rs.getInt(PstFamilyMember.fieldNames[PstFamilyMember.FLD_GUARANTEED]));
                sessEmpFamilyMember.setReligion(rs.getString(PstReligion.fieldNames[PstReligion.FLD_RELIGION]));
                sessEmpFamilyMember.setEducation(rs.getString(PstEducation.fieldNames[PstEducation.FLD_EDUCATION]));
                sessEmpFamilyMember.setSex(rs.getInt(PstFamilyMember.fieldNames[PstFamilyMember.FLD_SEX]));
                sessEmpFamilyMember.setFullName(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_FULL_NAME]));
                //resultToObject(rs, familymember);
                //familymember.set
                lists.add(sessEmpFamilyMember);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }

    private static void resultToObject(ResultSet rs, FamilyMember familymember) {
        try {
            familymember.setOID(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID]));
            familymember.setEmployeeId(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]));
            familymember.setFullName(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_FULL_NAME]));
            familymember.setRelationship(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP]));
            familymember.setBirthDate(rs.getDate(PstFamilyMember.fieldNames[PstFamilyMember.FLD_BIRTH_DATE]));
            familymember.setJob(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_JOB]));
            familymember.setAddress(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_ADDRESS]));
            familymember.setGuaranteed(rs.getBoolean(PstFamilyMember.fieldNames[PstFamilyMember.FLD_GUARANTEED]));
            familymember.setIgnoreBirth(rs.getBoolean(PstFamilyMember.fieldNames[PstFamilyMember.FLD_IGNORE_BIRTH]));
            familymember.setRelationType(rs.getInt(PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_TYPE]));
            familymember.setEducationId(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_EDUCATION_ID]));
            familymember.setReligionId(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELIGION_ID]));
            familymember.setSex(rs.getInt(PstFamilyMember.fieldNames[PstFamilyMember.FLD_SEX]));

            familymember.setCardId(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_CARD_ID]));

            familymember.setNoTelp(rs.getLong(PstFamilyMember.fieldNames[PstFamilyMember.FLD_NO_TELP]));
            familymember.setBpjsNum(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_BPJS_NO]));
            familymember.setJobPlace(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_JOB_PLACE]));
            familymember.setJobPosition(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_JOB_POSITION]));
            familymember.setBirtPlace(rs.getString(PstFamilyMember.fieldNames[PstFamilyMember.FLD_BIRTH_PLACE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long familyMemberId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_FAMILY_MEMBER + " WHERE "
                    + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID] + " = " + familyMemberId;

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

    /**
     * Ari_20110930 Menambah checkFamRelation {
     *
     * @param whereClause
     * @return
     */
    public static boolean checkFamRelation(long famRelationId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_FAMILY_MEMBER + " WHERE "
                    + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID] + " = '" + famRelationId + "'";

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
    /* } */

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID] + ") FROM " + TBL_HR_FAMILY_MEMBER;
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

    //Gede_6Feb2012 {
    //untuk report excel 
    public static int getCount2(SrcEmployee srcEmployee) {
        DBResultSet dbrs = null;
        SessEmployee sessEmployee = new SessEmployee();

        try {
            String sql = "SELECT COUNT(FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID] + ") FROM " + PstFamilyMember.TBL_HR_FAMILY_MEMBER + " FM INNER JOIN "
                    + PstEmployee.TBL_HR_EMPLOYEE + " EMP ON FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID] + "=EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + (srcEmployee.getSalaryLevel().length() > 0
                    ? " LEFT JOIN  " + PstPayEmpLevel.TBL_PAY_EMP_LEVEL + " LEV " + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " = LEV." + PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID]
                    : " " + " LEFT JOIN " + PstLevel.TBL_HR_LEVEL + " HR_LEV " + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]
                    + " = HR_LEV." + PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID]) + " WHERE " + sessEmployee.whereList(srcEmployee) + "GROUP BY FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]
                    + " ORDER BY COUNT(FM." + PstFamilyMember.fieldNames[PstFamilyMember.FLD_FAMILY_MEMBER_ID] + ") DESC LIMIT 1";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql1:"+sql);

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

    /* Gak jadi di pake
     //relationship 
     public static String getRelation(String getRelationship) {
     String relation = "";
     DBResultSet dbrs = null;
     String sql="";
     try {
     sql = "SELECT " + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION] +
     " FROM " + PstFamRelation.TBL_HR_FAM_RELATION+ " WHERE " + PstFamRelation.fieldNames[PstFamRelation.FLD_FAMILY_RELATION_ID]
     +"=" +getRelationship;
     dbrs = DBHandler.execQueryResult(sql);
     ResultSet rs = dbrs.getResultSet();
     //System.out.println("sql1:"+sql);
     while (rs.next()) {
     relation = rs.getString(1);
     }

     rs.close();
     //return relation;
     } catch (Exception e) {
     System.out.println("Error");
     }
     finally {
     DBResultSet.close(dbrs);
     }
     return relation;
     }

     //}
     * 
     */
    //Gede_13Februari2012{
    //religion name
    public static String getReligion(String religi) {
        String religion = "";
        DBResultSet dbrs = null;
        String sql = "";
        try {
            sql = "SELECT " + PstReligion.fieldNames[PstReligion.FLD_RELIGION]
                    + " FROM " + PstReligion.TBL_HR_RELIGION + " WHERE " + PstReligion.fieldNames[PstReligion.FLD_RELIGION_ID]
                    + "=" + religi;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql1:"+sql);
            while (rs.next()) {
                religion = rs.getString(1);
            }

            rs.close();
            //return relation;
        } catch (Exception e) {
            System.out.println("Error");
        } finally {
            DBResultSet.close(dbrs);
        }
        return religion;
    }

    //education name
    public static String getEducation(String edu) {
        String education = "";
        DBResultSet dbrs = null;
        String sql = "";
        try {
            sql = "SELECT " + PstEducation.fieldNames[PstEducation.FLD_EDUCATION]
                    + " FROM " + PstEducation.TBL_HR_EDUCATION + " WHERE " + PstEducation.fieldNames[PstEducation.FLD_EDUCATION_ID]
                    + "=" + edu;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql1:"+sql);
            while (rs.next()) {
                education = rs.getString(1);
            }

            rs.close();
            //return relation;
        } catch (Exception e) {
            System.out.println("Error");
        } finally {
            DBResultSet.close(dbrs);
        }
        return education;
    }
    //}

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    FamilyMember familymember = (FamilyMember) list.get(ls);
                    if (oid == familymember.getOID()) {
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
        vectSize = vectSize + mdl;
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

    public static long deleteByEmployee(long emplOID) {
        try {
            String sql = " DELETE FROM " + PstFamilyMember.TBL_HR_FAMILY_MEMBER
                    + " WHERE " + PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]
                    + " = " + emplOID;

            int status = DBHandler.execUpdate(sql);
        } catch (Exception exc) {
            System.out.println("error delete fam member by employee " + exc.toString());
        }

        return emplOID;
    }
}
