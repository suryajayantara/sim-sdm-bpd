/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.payroll;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.payroll.PstPayComponent;
import com.dimata.harisma.entity.payroll.PstPaySlip;
import com.dimata.harisma.entity.payroll.PstPaySlipComp;
import com.dimata.harisma.entity.search.SrcPeriodicalComp;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.util.LogicParser;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class SessPeriodicalComp {
    
    private static Vector logicParser(String text) {
        Vector vector = LogicParser.textSentence(text);
        for (int i = 0; i < vector.size(); i++) {
            String code = (String) vector.get(i);
            if (((vector.get(vector.size() - 1)).equals(LogicParser.SIGN))
                    && ((vector.get(vector.size() - 1)).equals(LogicParser.ENGLISH))) {
                vector.remove(vector.size() - 1);
            }
        }
        return vector;
    }
    
    public static Vector listEmployee(SrcPeriodicalComp objSrcPeriodicalComp, int start, int recordToGet){
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        boolean status = false;
        if (objSrcPeriodicalComp == null) {
            return new Vector(1, 1);
        }
        
        try{
            String sql = "SELECT * FROM "+PstEmployee.TBL_HR_EMPLOYEE
                    +" WHERE 1=1";
            String strFullName = "";
            if ((objSrcPeriodicalComp.getFullName() != null) && (objSrcPeriodicalComp.getFullName().length() > 0)) {
                Vector vectName = logicParser(objSrcPeriodicalComp.getFullName());
                if (vectName != null && vectName.size() > 0) {
                    strFullName = strFullName + " (";
                    for (int i = 0; i < vectName.size(); i++) {
                        String str = (String) vectName.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strFullName = strFullName + " " + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]
                                    + " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strFullName = strFullName + str.trim();
                        }
                    }
                    strFullName = strFullName + ")";
                }
            }
            
            if (strFullName != null && strFullName.length() > 0) {
                sql = sql + " AND " + strFullName;
            }
            
            if ((objSrcPeriodicalComp.getEmpNum() != null) && (objSrcPeriodicalComp.getEmpNum().length() > 0)) {
                sql = sql + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                        + " LIKE '%" + objSrcPeriodicalComp.getEmpNum() + "%'";
            }
            
            if (objSrcPeriodicalComp.getStatusResign() != 1) {
                sql = sql + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]
                        + " = " + objSrcPeriodicalComp.getStatusResign();
            }
            
            if (objSrcPeriodicalComp.getArrCompany(0)!=null){
                String[] companyId = objSrcPeriodicalComp.getArrCompany(0);
                    if (! (companyId!=null && (companyId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<companyId.length; i++) {
                        sql = sql +PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+
                                    " = "+ companyId[i] + " OR ";
                        if (i==(companyId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
            }
            
            if (objSrcPeriodicalComp.getArrDivision(0)!=null){
                String[] divisionId = objSrcPeriodicalComp.getArrDivision(0);
                    if (! (divisionId!=null && (divisionId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<divisionId.length; i++) {
                        sql = sql + " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+
                                    " = "+ divisionId[i] + " OR ";
                        if (i==(divisionId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
            }
            
            if (objSrcPeriodicalComp.getArrDepartment(0)!=null){
                String[] departmentId = objSrcPeriodicalComp.getArrDepartment(0);
                    if (! (departmentId!=null && (departmentId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<departmentId.length; i++) {
                        sql = sql + " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+
                                    " = "+ departmentId[i] + " OR ";
                        if (i==(departmentId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
            }
            
            if (objSrcPeriodicalComp.getArrSection(0)!=null){
                String[] sectionId = objSrcPeriodicalComp.getArrSection(0);
                    if (! (sectionId!=null && (sectionId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<sectionId.length; i++) {
                        sql = sql + " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+
                                    " = "+ sectionId[i] + " OR ";
                        if (i==(sectionId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
            }
            
            if ((recordToGet != 0)) {
                sql = sql + " LIMIT " + start + "," + recordToGet;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                result.add(employee);
            }
            return result;
        } catch (Exception e) {
            System.out.println("\t Exception on seach LeaveApplication : " + e);
        } finally {
            DBResultSet.close(dbrs);
        }
        
        
        return result;
    }
    
    
    
    public static double getValue(SrcPeriodicalComp objSrcPeriodicalComp, long periodId, long employeeId) {
        DBResultSet dbrs = null;
        double value = 0;
        boolean status = false;
        if (objSrcPeriodicalComp == null) {
            return 0;
        }
        
        try{
            String sql = "SELECT SUM(PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]+") AS COMP_VALUE FROM "
                    + PstPaySlipComp.TBL_PAY_SLIP_COMP+" AS PC "
                    + "INNER JOIN "+PstPaySlip.TBL_PAY_SLIP+" AS PS "
                    + "ON PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " = PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " INNER JOIN "+PstPayComponent.TBL_PAY_COMPONENT+" AS COMP "
                    + "ON PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = COMP."+PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = "+periodId
                    + " AND PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = "+employeeId;
            
            String inComponent = "";
            if (objSrcPeriodicalComp.getArrComponent(0)!=null){
                String[] componentId = objSrcPeriodicalComp.getArrComponent(0);
                if (! (componentId!=null && (componentId[0].equals("0")))) {
                    for (int i=0; i < componentId.length; i++){
                        inComponent = inComponent + ","+ componentId[i];
                    }
                    inComponent = inComponent.substring(1);
                }
                sql += " AND COMP."+PstPayComponent.fieldNames[PstPayComponent.FLD_COMPONENT_ID] + 
                        " IN ("+inComponent+")";
            }
            System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                value = rs.getDouble("COMP_VALUE");
            }
            
        } catch (Exception exc){
            System.out.println(exc.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return value;
    }
    
    public static double getValueCompare(SrcPeriodicalComp objSrcPeriodicalComp, long periodId, long employeeId) {
        DBResultSet dbrs = null;
        double value = 0;
        boolean status = false;
        if (objSrcPeriodicalComp == null) {
            return 0;
        }
        
        try{
            String sql = "SELECT PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]+" FROM "
                    + PstPaySlipComp.TBL_PAY_SLIP_COMP+" AS PC "
                    + "INNER JOIN "+PstPaySlip.TBL_PAY_SLIP+" AS PS "
                    + "ON PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " = PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " INNER JOIN "+PstPayComponent.TBL_PAY_COMPONENT+" AS COMP "
                    + "ON PC."+PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = COMP."+PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE COMP."+PstPayComponent.fieldNames[PstPayComponent.FLD_COMPONENT_ID]
                    + " = "+objSrcPeriodicalComp.getCompareCompId()
                    + " AND PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = "+periodId
                    + " AND PS."+PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = "+employeeId;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                value = rs.getDouble(PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]);
            }
            
        } catch (Exception exc){
            System.out.println(exc.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return value;
    }
    
}
