
/* Created on 	:  [25-9-2002] [1.22] PM
 * 
 * @author  	: lkarunia
 * @version  	: 01
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
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

/* package harisma */
//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata. harisma.db.DBLogger;
import com.dimata.harisma.entity.employee.*;


//Gede_7Feb2012 {
import com.dimata.harisma.session.employee.*;
import com.dimata.harisma.entity.search.*;
import com.dimata.harisma.entity.payroll.*;
import com.dimata.harisma.entity.masterdata.*;
//}

public class PstEmpLanguage extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_EMP_LANGUAGE = "hr_emp_language";//"HR_EMP_LANGUAGE";
    public static final int FLD_EMP_LANGUAGE_ID = 0;
    public static final int FLD_LANGUAGE_ID = 1;
    public static final int FLD_EMPLOYEE_ID = 2;
    public static final int FLD_ORAL = 3;
    public static final int FLD_WRITTEN = 4;
    public static final int FLD_DESCRIPTION = 5;
    public static final String[] fieldNames = {
        "EMP_LANGUAGE_ID",
        "LANGUAGE_ID",
        "EMPLOYEE_ID",
        "ORAL",
        "WRITTEN",
        "DESCRIPTION"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING
    };
//    public static final int GRADE_SELECT = -1;
//    public static final int GRADE_GOOD = 0;
//    public static final int GRADE_FAIR = 1;
//    public static final int GRADE_POOR = 2;
    // di rubah karena -1 tidak boleh 2013-08-1 by satrya
    
    private static String query = "";
    
    public String getQuery(){
        return query;
    }
    
   public static final int GRADE_SELECT = 0;
    public static final int GRADE_GOOD = 1;
    public static final int GRADE_FAIR = 2;
    public static final int GRADE_POOR = 3;
    public static final int[] gradeValue = {GRADE_SELECT, GRADE_GOOD, GRADE_FAIR, GRADE_POOR};
    public static final String[] gradeKey = {"Select ..", "Good", "Fair", "Poor"};

    public static Vector getGradeKey() {
        Vector result = new Vector(1, 1);
        for (int i = 0; i < gradeKey.length; i++) {
            result.add(gradeKey[i]);
        }
        return result;
    }

    public static Vector getGradeValue() {
        Vector result = new Vector(1, 1);
        for (int i = 0; i < gradeValue.length; i++) {
            result.add(String.valueOf(gradeValue[i]));
        }
        return result;
    }

    public PstEmpLanguage() {
    }

    public PstEmpLanguage(int i) throws DBException {
        super(new PstEmpLanguage());
    }

    public PstEmpLanguage(String sOid) throws DBException {
        super(new PstEmpLanguage(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpLanguage(long lOid) throws DBException {
        super(new PstEmpLanguage(0));
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
        return TBL_HR_EMP_LANGUAGE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpLanguage().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        EmpLanguage emplanguage = fetchExc(ent.getOID());
        ent = (Entity) emplanguage;
        return emplanguage.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((EmpLanguage) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((EmpLanguage) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static EmpLanguage fetchExc(long oid) throws DBException {
        try {
            EmpLanguage emplanguage = new EmpLanguage();
            PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(oid);
            emplanguage.setOID(oid);

            emplanguage.setLanguageId(pstEmpLanguage.getlong(FLD_LANGUAGE_ID));
            emplanguage.setEmployeeId(pstEmpLanguage.getlong(FLD_EMPLOYEE_ID));
            emplanguage.setOral(pstEmpLanguage.getInt(FLD_ORAL));
            emplanguage.setWritten(pstEmpLanguage.getInt(FLD_WRITTEN));
            emplanguage.setDescription(pstEmpLanguage.getString(FLD_DESCRIPTION));

            return emplanguage;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(EmpLanguage emplanguage) throws DBException {
        try {
            PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(0);

            pstEmpLanguage.setLong(FLD_LANGUAGE_ID, emplanguage.getLanguageId());
            pstEmpLanguage.setLong(FLD_EMPLOYEE_ID, emplanguage.getEmployeeId());
            pstEmpLanguage.setInt(FLD_ORAL, emplanguage.getOral());
            pstEmpLanguage.setInt(FLD_WRITTEN, emplanguage.getWritten());
            pstEmpLanguage.setString(FLD_DESCRIPTION, emplanguage.getDescription());

            pstEmpLanguage.insert();
            emplanguage.setOID(pstEmpLanguage.getlong(FLD_EMP_LANGUAGE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
        return emplanguage.getOID();
    }
    
    public static long insertExcPending(EmpLanguage emplanguage) throws DBException {
        try {
            PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(0);

            pstEmpLanguage.setLong(FLD_LANGUAGE_ID, emplanguage.getLanguageId());
            pstEmpLanguage.setLong(FLD_EMPLOYEE_ID, emplanguage.getEmployeeId());
            pstEmpLanguage.setInt(FLD_ORAL, emplanguage.getOral());
            pstEmpLanguage.setInt(FLD_WRITTEN, emplanguage.getWritten());
            pstEmpLanguage.setString(FLD_DESCRIPTION, emplanguage.getDescription());

            query = pstEmpLanguage.getInsertQuery();
            emplanguage.setOID(pstEmpLanguage.getlong(FLD_EMP_LANGUAGE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
        return emplanguage.getOID();
    }

    public static long updateExc(EmpLanguage emplanguage) throws DBException {
        try {
            if (emplanguage.getOID() != 0) {
                PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(emplanguage.getOID());

                pstEmpLanguage.setLong(FLD_LANGUAGE_ID, emplanguage.getLanguageId());
                pstEmpLanguage.setLong(FLD_EMPLOYEE_ID, emplanguage.getEmployeeId());
                pstEmpLanguage.setInt(FLD_ORAL, emplanguage.getOral());
                pstEmpLanguage.setInt(FLD_WRITTEN, emplanguage.getWritten());
                pstEmpLanguage.setString(FLD_DESCRIPTION, emplanguage.getDescription());

                pstEmpLanguage.update();
                return emplanguage.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long updateExcPending(EmpLanguage emplanguage) throws DBException {
        try {
            if (emplanguage.getOID() != 0) {
                PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(emplanguage.getOID());

                pstEmpLanguage.setLong(FLD_LANGUAGE_ID, emplanguage.getLanguageId());
                pstEmpLanguage.setLong(FLD_EMPLOYEE_ID, emplanguage.getEmployeeId());
                pstEmpLanguage.setInt(FLD_ORAL, emplanguage.getOral());
                pstEmpLanguage.setInt(FLD_WRITTEN, emplanguage.getWritten());
                pstEmpLanguage.setString(FLD_DESCRIPTION, emplanguage.getDescription());

                query = pstEmpLanguage.getUpdateSQL();
                return emplanguage.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(oid);
            pstEmpLanguage.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public static long deleteExcPending(long oid) throws DBException {
        try {
            PstEmpLanguage pstEmpLanguage = new PstEmpLanguage(oid);
            query = pstEmpLanguage.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpLanguage(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_EMP_LANGUAGE;
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
                EmpLanguage emplanguage = new EmpLanguage();
                resultToObject(rs, emplanguage);
                lists.add(emplanguage);
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
 * @param whereClause
 * @param order
 * @return 
 */
     public static Vector listEmpLanguage(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT LANG."+PstLanguage.fieldNames[PstLanguage.FLD_LANGUAGE]
        +",EMPLANG."+PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]
        +",EMPLANG."+PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_ORAL]
        +",EMPLANG."+PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_WRITTEN]
        +",EMPLANG."+PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_DESCRIPTION]
        +" FROM "+PstEmpLanguage.TBL_HR_EMP_LANGUAGE + " AS EMPLANG "
        +" INNER JOIN "+PstLanguage.TBL_HR_LANGUAGE + " AS LANG ON EMPLANG."+PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_LANGUAGE_ID]
        +"=LANG."+PstLanguage.fieldNames[PstLanguage.FLD_LANGUAGE_ID];
            
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SessEmpLanguage sessEmpLanguage = new SessEmpLanguage();
                sessEmpLanguage.setEmployee_id(rs.getLong(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]));
                sessEmpLanguage.setLanguage(rs.getString(PstLanguage.fieldNames[PstLanguage.FLD_LANGUAGE]));
                sessEmpLanguage.setOral(PstEmpLanguage.gradeKey[rs.getInt(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_ORAL])]); 
                sessEmpLanguage.setWritten(PstEmpLanguage.gradeKey[rs.getInt(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_WRITTEN])]);
                lists.add(sessEmpLanguage);
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
    private static void resultToObject(ResultSet rs, EmpLanguage emplanguage) {
        try {
            emplanguage.setOID(rs.getLong(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMP_LANGUAGE_ID]));
            emplanguage.setLanguageId(rs.getLong(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_LANGUAGE_ID]));
            emplanguage.setEmployeeId(rs.getLong(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]));
            emplanguage.setOral(rs.getInt(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_ORAL]));
            emplanguage.setWritten(rs.getInt(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_WRITTEN]));
            emplanguage.setDescription(rs.getString(PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_DESCRIPTION]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long empLanguageId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_LANGUAGE + " WHERE "
                    + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMP_LANGUAGE_ID] + " = '" + empLanguageId + "'";

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
            String sql = "SELECT COUNT(" + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMP_LANGUAGE_ID] + ") FROM " + TBL_HR_EMP_LANGUAGE;
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
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    EmpLanguage emplanguage = (EmpLanguage) list.get(ls);
                    if (oid == emplanguage.getOID()) {
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
            String sql = " DELETE FROM " + PstEmpLanguage.TBL_HR_EMP_LANGUAGE
                    + " WHERE " + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]
                    + " = " + emplOID;

            int status = DBHandler.execUpdate(sql);
        } catch (Exception exc) {
            System.out.println("error delete language by employee " + exc.toString());
        }

        return emplOID;
    }

    public static boolean checkLanguage(long languageId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_LANGUAGE + " WHERE "
                    + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_LANGUAGE_ID] + " = '" + languageId + "'";

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

    //Gede_7Feb2012 {
    //untuk report excel
    public static int getCount2(SrcEmployee srcEmployee) {
        DBResultSet dbrs = null;
        SessEmployee sessEmployee = new SessEmployee();

        try {

            String sql = "SELECT COUNT(EL." + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMP_LANGUAGE_ID] + ") FROM " + PstEmpLanguage.TBL_HR_EMP_LANGUAGE + " EL INNER JOIN "
                    + PstEmployee.TBL_HR_EMPLOYEE + " EMP ON EL." + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID] + "=EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + (srcEmployee.getSalaryLevel().length() > 0
                    ? " LEFT JOIN  " + PstPayEmpLevel.TBL_PAY_EMP_LEVEL + " LEV " + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " = LEV." + PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID]
                    : " " + " LEFT JOIN " + PstLevel.TBL_HR_LEVEL + " HR_LEV " + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]
                    + " = HR_LEV." + PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID]) + " WHERE " + sessEmployee.whereList(srcEmployee) + "GROUP BY EL." + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]
                    + " ORDER BY COUNT(EL." + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMP_LANGUAGE_ID] + ") DESC LIMIT 1";

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
    //}

    //Gede_14Februari2012{
    //langName
    public static String getLang(String lang) {
        String language = "";
        DBResultSet dbrs = null;
        String sql = "";
        try {
            sql = "SELECT " + PstLanguage.fieldNames[PstLanguage.FLD_LANGUAGE]
                    + " FROM " + PstLanguage.TBL_HR_LANGUAGE + " WHERE " + PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_LANGUAGE_ID]
                    + "=" + lang;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql1:"+sql);
            while (rs.next()) {
                language = rs.getString(1);
            }

            rs.close();
            //return relation;
        } catch (Exception e) {
            System.out.println("Error");
        } finally {
            DBResultSet.close(dbrs);
        }
        return language;
    }
    //}
}
