/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class PstEmpDocListExpense extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_DOC_LIST_EXPENSE = "hr_emp_doc_list_expense";
    public static final int FLD_EMP_DOC_LIST_EXPENSE_ID = 0;
    public static final int FLD_EMP_DOC_ID = 1;
    public static final int FLD_EMPLOYEE_ID = 2;
    public static final int FLD_COMPONENT_ID = 3;
    public static final int FLD_DAY_LENGTH = 4;
    public static final int FLD_COMP_VALUE = 5;
    public static final int FLD_OBJECT_NAME = 6;
    public static final int FLD_PERIOD_ID = 7;
    
    public static String[] fieldNames = {
        "EMP_DOC_LIST_EXPENSE_ID",
        "EMP_DOC_ID",
        "EMPLOYEE_ID",
        "COMPONENT_ID",
        "DAY_LENGTH",
        "COMP_VALUE",
        "OBJECT_NAME",
        "PERIOD_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG
    };

    public PstEmpDocListExpense() {
    }

    public PstEmpDocListExpense(int i) throws DBException {
        super(new PstEmpDocListExpense());
    }

    public PstEmpDocListExpense(String sOid) throws DBException {
        super(new PstEmpDocListExpense(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpDocListExpense(long lOid) throws DBException {
        super(new PstEmpDocListExpense(0));
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
        return TBL_EMP_DOC_LIST_EXPENSE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpDocListExpense().getClass().getName();
    }

    public static EmpDocListExpense fetchExc(long oid) throws DBException {
        try {
            EmpDocListExpense entEmpDocListExpense = new EmpDocListExpense();
            PstEmpDocListExpense pstEmpDocListExpense = new PstEmpDocListExpense(oid);
            entEmpDocListExpense.setOID(oid);
            entEmpDocListExpense.setEmpDocId(pstEmpDocListExpense.getLong(FLD_EMP_DOC_ID));
            entEmpDocListExpense.setEmployeeId(pstEmpDocListExpense.getLong(FLD_EMPLOYEE_ID));
            entEmpDocListExpense.setComponentId(pstEmpDocListExpense.getLong(FLD_COMPONENT_ID));
            entEmpDocListExpense.setDayLength(pstEmpDocListExpense.getInt(FLD_DAY_LENGTH));
            entEmpDocListExpense.setCompValue(pstEmpDocListExpense.getdouble(FLD_COMP_VALUE));
            entEmpDocListExpense.setObjectName(pstEmpDocListExpense.getString(FLD_OBJECT_NAME));
            entEmpDocListExpense.setPeriodeId(pstEmpDocListExpense.getLong(FLD_PERIOD_ID));
            return entEmpDocListExpense;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocListExpense(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpDocListExpense entEmpDocListExpense = fetchExc(entity.getOID());
        entity = (Entity) entEmpDocListExpense;
        return entEmpDocListExpense.getOID();
    }

    public static synchronized long updateExc(EmpDocListExpense entEmpDocListExpense) throws DBException {
        try {
            if (entEmpDocListExpense.getOID() != 0) {
                PstEmpDocListExpense pstEmpDocListExpense = new PstEmpDocListExpense(entEmpDocListExpense.getOID());
                pstEmpDocListExpense.setLong(FLD_EMP_DOC_ID, entEmpDocListExpense.getEmpDocId());
                pstEmpDocListExpense.setLong(FLD_EMPLOYEE_ID, entEmpDocListExpense.getEmployeeId());
                pstEmpDocListExpense.setLong(FLD_COMPONENT_ID, entEmpDocListExpense.getComponentId());
                pstEmpDocListExpense.setInt(FLD_DAY_LENGTH, entEmpDocListExpense.getDayLength());
                pstEmpDocListExpense.setDouble(FLD_COMP_VALUE, entEmpDocListExpense.getCompValue());
                pstEmpDocListExpense.setString(FLD_OBJECT_NAME, entEmpDocListExpense.getObjectName());
                pstEmpDocListExpense.setLong(FLD_PERIOD_ID, entEmpDocListExpense.getPeriodeId());
                pstEmpDocListExpense.update();
                return entEmpDocListExpense.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocListExpense(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpDocListExpense) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpDocListExpense pstEmpDocListExpense = new PstEmpDocListExpense(oid);
            pstEmpDocListExpense.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocListExpense(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpDocListExpense entEmpDocListExpense) throws DBException {
        try {
            PstEmpDocListExpense pstEmpDocListExpense = new PstEmpDocListExpense(0);
            pstEmpDocListExpense.setLong(FLD_EMP_DOC_ID, entEmpDocListExpense.getEmpDocId());
            pstEmpDocListExpense.setLong(FLD_EMPLOYEE_ID, entEmpDocListExpense.getEmployeeId());
            pstEmpDocListExpense.setLong(FLD_COMPONENT_ID, entEmpDocListExpense.getComponentId());
            pstEmpDocListExpense.setInt(FLD_DAY_LENGTH, entEmpDocListExpense.getDayLength());
            pstEmpDocListExpense.setDouble(FLD_COMP_VALUE, entEmpDocListExpense.getCompValue());
            pstEmpDocListExpense.setString(FLD_OBJECT_NAME, entEmpDocListExpense.getObjectName());
            pstEmpDocListExpense.setLong(FLD_PERIOD_ID, entEmpDocListExpense.getPeriodeId());
            pstEmpDocListExpense.insert();
            entEmpDocListExpense.setOID(pstEmpDocListExpense.getLong(FLD_EMP_DOC_LIST_EXPENSE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocListExpense(0), DBException.UNKNOWN);
        }
        return entEmpDocListExpense.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpDocListExpense) entity);
    }

    public static void resultToObject(ResultSet rs, EmpDocListExpense entEmpDocListExpense) {
        try {
            entEmpDocListExpense.setOID(rs.getLong(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID]));
            entEmpDocListExpense.setEmpDocId(rs.getLong(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]));
            entEmpDocListExpense.setEmployeeId(rs.getLong(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]));
            entEmpDocListExpense.setComponentId(rs.getLong(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID]));
            entEmpDocListExpense.setDayLength(rs.getInt(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_DAY_LENGTH]));
            entEmpDocListExpense.setCompValue(rs.getDouble(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE]));
            entEmpDocListExpense.setObjectName(rs.getString(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]));
            entEmpDocListExpense.setPeriodeId(rs.getLong(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_PERIOD_ID]));
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
            String sql = "SELECT * FROM " + TBL_EMP_DOC_LIST_EXPENSE;
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
                EmpDocListExpense entEmpDocListExpense = new EmpDocListExpense();
                resultToObject(rs, entEmpDocListExpense);
                lists.add(entEmpDocListExpense);
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
    
    public static double getTotalPerEmployee(long employeeId, long documentId) {
        DBResultSet dbrs = null;
        double totalComponent = 0;
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT SUM("+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_DAY_LENGTH]+" * "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE]+")"
                    + " AS TOTAL FROM "+TBL_EMP_DOC_LIST_EXPENSE+" WHERE "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+documentId+" "
                    + "AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+" = "+employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                
                totalComponent = rs.getDouble("TOTAL");
                
            }
            return totalComponent;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return totalComponent;
    }
    
    public static double getTotal(long documentId) {
        DBResultSet dbrs = null;
        double totalComponent = 0;
       
        try {
            String sql = " SELECT SUM("+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_DAY_LENGTH]+" * "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE]+")"
                    + " AS TOTAL FROM "+TBL_EMP_DOC_LIST_EXPENSE+" WHERE "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+documentId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                
                totalComponent = rs.getDouble("TOTAL");
                
            }
            return totalComponent;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return totalComponent;
    }
	
    public static double getTotalCompValue(long documentId) {
        DBResultSet dbrs = null;
        double totalComponent = 0;
       
        try {
            String sql = " SELECT SUM("+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE]+")"
                    + " AS TOTAL FROM "+TBL_EMP_DOC_LIST_EXPENSE+" WHERE "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+documentId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                
                totalComponent = rs.getDouble("TOTAL");
                
            }
            return totalComponent;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return totalComponent;
    }
    
    public static double getTotalCompValueByEmployee(long documentId, long employeeId) {
        DBResultSet dbrs = null;
        double totalComponent = 0;
       
        try {
            String sql = " SELECT SUM("+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE]+")"
                    + " AS TOTAL FROM "+TBL_EMP_DOC_LIST_EXPENSE+" WHERE "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+documentId
                    + " AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+" = "+employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                
                totalComponent = rs.getDouble("TOTAL");
                
            }
            return totalComponent;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return totalComponent;
    }
    
    public static Vector getDocExpenseId(Date fromdate, Date todate, long employeeId, long compId){
        DBResultSet dbrs = null;
        Vector listDocExpense = new Vector();
        Employee employee = new Employee();
           try {
               employee = PstEmployee.fetchExc(employeeId);
           } catch (Exception e) {}
           try {
               String sql = " SELECT hedlm.* FROM " + PstEmpDocListExpense.TBL_EMP_DOC_LIST_EXPENSE + " hedlm"
                       + " INNER JOIN "+PstEmpDoc.TBL_HR_EMP_DOC+" hed "
                       + " ON ( hed."+PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] +" = hedlm."+ PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] +" )" 
                       + " WHERE "
                       + " ("
                       + " ( hed." + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE]
                       + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                       + " OR "
                       + " ( hed." + PstEmpDoc.fieldNames[PstEmpDoc.FLD_REQUEST_DATE]
                       + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                       + " )"
                       + " AND "
                       + " (`hedlm`." + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID] + " IS NOT NULL OR `hedlm`." + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID] + " != 0 ) "
                       + " AND `hedlm`.`EMPLOYEE_ID` = "+employeeId+""
                       + " AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID]+" = \""+compId+"\"";
               dbrs = DBHandler.execQueryResult(sql);
               ResultSet rs = dbrs.getResultSet();

               while (rs.next()) {
                EmpDocListExpense entEmpDocListExpense = new EmpDocListExpense();
                resultToObject(rs, entEmpDocListExpense);
                listDocExpense.add(entEmpDocListExpense);
               }
               return listDocExpense;
           } catch (Exception e) {
               System.out.println(e);
           } finally {
               DBResultSet.close(dbrs);
           }
           return listDocExpense;
       }

    public static boolean checkOID(long entEmpDocListExpenseId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_DOC_LIST_EXPENSE + " WHERE "
                    + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID] + " = " + entEmpDocListExpenseId;
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
            String sql = "SELECT COUNT(" + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_LIST_EXPENSE_ID] + ") FROM " + TBL_EMP_DOC_LIST_EXPENSE;
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
                    EmpDocListExpense entEmpDocListExpense = (EmpDocListExpense) list.get(ls);
                    if (oid == entEmpDocListExpense.getOID()) {
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
    
    public static void updateValueComp(double compValue, String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "";
            sql = " UPDATE " + PstEmpDocListExpense.TBL_EMP_DOC_LIST_EXPENSE + " SET " +
                    PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE] + " = " + compValue;

            sql = sql + " WHERE " + whereClause;
            //System.out.println("updateValueComp : " + sql);
            int status = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.err.println("\tupdateNote : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        //return result;
        }
    }
        
    public static void updateDay(int day, long idDocExpense) {
        try {
            String sql = "UPDATE " + PstEmpDocListExpense.TBL_EMP_DOC_LIST_EXPENSE
                    + " SET " + PstEmpDocListExpense.fieldNames[FLD_DAY_LENGTH] + " = '" + day + "'"
                    + " WHERE " + PstEmpDocListExpense.fieldNames[FLD_EMP_DOC_LIST_EXPENSE_ID]
                    + " = " + idDocExpense;
            System.out.println("sql PstEmpDoc.updateFileName : " + sql);
            int result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("\tExc updateFileName : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
        }
    }    
    
    public static double getTotalExpenses(long docId){
        double total = 0.0;
        
        EmpDoc empDoc = new EmpDoc();
        try{
            empDoc = PstEmpDoc.fetchExc(docId);
        } catch (Exception exc){}
        
        String whereEmpDocField = PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]+" = 'NOSPJ' AND "+
                                PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE]+" = '"+empDoc.getDoc_number()+"'";
        Vector listEmpDocField = PstEmpDocField.list(0,0,whereEmpDocField,"");
        long documentId = 0;
        if (listEmpDocField.size()>0){
            EmpDocField empDocField = (EmpDocField) listEmpDocField.get(0);
            documentId = empDocField.getEmp_doc_id();
        }
        
        String whereClause = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = "+documentId;
        Vector listExpenses = PstEmpDocListExpense.list(0,0,whereClause,"");
        if (listExpenses.size()>0){
            for (int i =0; i<listExpenses.size(); i++){
                EmpDocListExpense empDocExpense = (EmpDocListExpense) listExpenses.get(i);
                total = total + (empDocExpense.getDayLength() * empDocExpense.getCompValue());
                
            }
        }
        
        return total;
    }
    
    public static double getTotalExpensesEmployee(long docId, long empId){
        double total = 0.0;
        
        EmpDoc empDoc = new EmpDoc();
        try{
            empDoc = PstEmpDoc.fetchExc(docId);
        } catch (Exception exc){}
        
        String whereEmpDocField = PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]+" = 'NOSPJ' AND "+
                                PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE]+" = '"+empDoc.getDoc_number()+"'";
        Vector listEmpDocField = PstEmpDocField.list(0,0,whereEmpDocField,"");
        long documentId = 0;
        if (listEmpDocField.size()>0){
            EmpDocField empDocField = (EmpDocField) listEmpDocField.get(0);
            documentId = empDocField.getEmp_doc_id();
        }
        
        String whereClause = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = "+documentId
                            + " AND "+ PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID] + " = "+empId;
        Vector listExpenses = PstEmpDocListExpense.list(0,0,whereClause,"");
        if (listExpenses.size()>0){
            for (int i =0; i<listExpenses.size(); i++){
                EmpDocListExpense empDocExpense = (EmpDocListExpense) listExpenses.get(i);
                total = total + (empDocExpense.getDayLength() * empDocExpense.getCompValue());
                
            }
        }
        
        return total;
    }    
}
