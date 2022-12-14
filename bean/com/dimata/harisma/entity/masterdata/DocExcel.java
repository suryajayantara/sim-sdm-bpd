/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;
import com.dimata.harisma.entity.employee.PstEmployee;
import java.util.Vector;
import java.text.NumberFormat;
import java.io.*;
import java.util.*;
import java.lang.System;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import com.dimata.util.Excel;
import com.dimata.util.Formater;
import com.dimata.util.blob.TextLoader;
import org.apache.poi.hssf.usermodel.*;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.hssf.record.*;
import org.apache.poi.hssf.model.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;


import com.dimata.util.*;
import com.dimata.gui.jsp.*;
import com.dimata.qdep.form.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.attendance.*;
import com.dimata.harisma.entity.payroll.*;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Dimata 007
 */
public class DocExcel {

    public String processImportExcel(long docId, String docTitle, ServletConfig config, HttpServletRequest request, HttpServletResponse response) {
        String html = "";
        int NUM_HEADER = 2;
        int NUM_CELL = 0;
        String tdColor = "#FFF;";
        try {
            TextLoader uploader = new TextLoader();
            ByteArrayInputStream inStream = null;

            uploader.uploadText(config, request, response);
            Object obj = uploader.getTextFile("file");
            byte byteText[] = null;
            byteText = (byte[]) obj;
            inStream = new ByteArrayInputStream(byteText);

            POIFSFileSystem fs = new POIFSFileSystem(inStream);

            HSSFWorkbook wb = new HSSFWorkbook(fs);
            System.out.println("creating workbook");

            int numOfSheets = wb.getNumberOfSheets();

            for (int i = 0; i < numOfSheets; i++) {

                int r = 0;

                HSSFSheet sheet = (HSSFSheet) wb.getSheetAt(i);
                html += "<div class=\"info\"><strong> Document Title : " + docTitle + "<br>";
                html += "<strong> Sheet name : " + sheet.getSheetName() + "</div>";
                if (sheet == null || sheet.getSheetName() == null || sheet.getSheetName().length() < 1) {
                    html += " NOT MATCH : Document title name and sheet name";
                    continue;
                }
                if (sheet.getSheetName().equals(docTitle)){
                    int rows = sheet.getPhysicalNumberOfRows();

                    // loop untuk row dimulai dari numHeaderRow (0, .. numHeaderRow diabaikan) => untuk yang bukan sheet pertaman
                    int start = (i == 0) ? 0 : NUM_HEADER;
                    int countInsert = 0;
                    html += "<table class=\"tblStyle\">";
                    for (r = start; r < rows; r++) {
                        EmpDocListMutation empDocListMutation = new EmpDocListMutation();
                        EmpDocList empDocList = new EmpDocList();
                        empDocListMutation.setEmpDocId(docId);
                        empDocList.setEmp_doc_id(docId);
                        try {
                            HSSFRow row = sheet.getRow(r);
                            int cells = 0;
                            //if number of cell is static
                            if (NUM_CELL > 0) {
                                cells = NUM_CELL;
                            } //number of cell is dinamyc
                            else {
                                cells = row.getPhysicalNumberOfCells();
                            }

                            // ambil jumlah kolom yang sebenarnya
                            NUM_CELL = cells;
                            html += "<tr>";
                            for (int c = 0; c < cells; c++) {
                                HSSFCell cell = row.getCell((short) c);
                                String value = null;
                                if (cell != null) {
                                    switch (cell.getCellType()) {
                                        case HSSFCell.CELL_TYPE_FORMULA:
                                            value = String.valueOf(cell.getCellFormula());
                                            break;
                                        case HSSFCell.CELL_TYPE_NUMERIC:
                                            value = Formater.formatNumber(cell.getNumericCellValue(), "###");
                                            break;
                                        case HSSFCell.CELL_TYPE_STRING:
                                            value = String.valueOf(cell.getStringCellValue());
                                            break;
                                        default:
                                            value = String.valueOf(cell.getStringCellValue() != null ? cell.getStringCellValue() : "");
                                            ;
                                    }
                                }
                                if (r == 0){
                                    html += "<td style=\"background-color:#DDD;\"><strong>"+ value + "</strong></td>";
                                } else {
                                    long oidValue = 0;
                                    if (value.equals("NULL")){
                                        html += "<td style=\"background-color:"+tdColor+"\">-</td>";
                                        Date dateNow = new Date();
                                        switch(c){
                                            case 1:
                                                empDocListMutation.setEmployeeId(0);
                                                empDocList.setEmployee_id(0);
                                                break;
                                            case 2:
                                                empDocListMutation.setCompanyId(0);
                                                break;
                                            case 3:
                                                empDocListMutation.setDivisionId(0);
                                                break;
                                            case 4:
                                                empDocListMutation.setDepartmentId(0);
                                                break;
                                            case 5:
                                                empDocListMutation.setSectionId(0);
                                                break;
                                            case 6:
                                                empDocListMutation.setPositionId(0);
                                                break;
                                            case 7:
                                                empDocListMutation.setEmpCatId(0);
                                                break;
                                            case 8:
                                                empDocListMutation.setLevelId(0);
                                                break;
                                            case 9:
                                                empDocListMutation.setWorkFrom(dateNow);
                                                break;
                                            case 10:
                                                empDocListMutation.setWorkTo(dateNow);
                                                break;
                                            case 11:
                                                empDocListMutation.setGradeLevelId(0);
                                                break;
                                            case 12:
                                                empDocListMutation.setHistoryGroup(0);
                                                break;
                                            case 13:
                                                empDocListMutation.setHistoryType(0);
                                                break;
                                            case 14:
                                                empDocListMutation.setObjectName("");
                                                empDocList.setObject_name("");
                                                break;
                                            case 15:
                                                empDocListMutation.setTipeDoc(0);
                                                break;
                                            case 16:
                                                empDocListMutation.setEmpNum("");
                                                break;
                                            
                                        }
                                    } else {
                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                        switch(c){
                                            case 1:
                                                oidValue = getEmployeeId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                }
                                                else{
                                                    html += "<td style\"background-color:#fcd4dc; color#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setEmployeeId(oidValue);
                                                empDocList.setEmployee_id(oidValue);
                                                break;
                                            case 2:
                                                oidValue = getCompanyId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setCompanyId(oidValue);
                                                break;
                                            case 3:
                                                oidValue = getDivisionId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setDivisionId(oidValue);
                                                break;
                                            case 4:
                                                oidValue = getDepartmentId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setDepartmentId(oidValue);
                                                break;
                                            case 5:
                                                oidValue = getSectionId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setSectionId(oidValue);
                                                break;
                                            case 6:
                                                oidValue = getPositionId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setPositionId(oidValue);
                                                break;
                                            case 7:
                                                oidValue = getEmployeeCategoryId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setEmpCatId(oidValue);
                                                break;
                                            case 8:
                                                oidValue = getLevelId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setLevelId(oidValue);
                                                break;
                                            case 9:
                                                Date dateStart = sdf.parse(value);
                                                html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                empDocListMutation.setWorkFrom(dateStart);
                                                break;
                                                
                                            case 10:
                                                Date dateEnd = sdf.parse(value);
                                                html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                empDocListMutation.setWorkTo(dateEnd);
                                                break;
                                            case 11:
                                                oidValue = getGradeId(value);
                                                if (oidValue != 0){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setGradeLevelId(oidValue);
                                                break;
                                            case 12:
                                                int valHisGroup = -1;
                                                if ((value.equals("Riwayat Jabatan"))||(value.equals("Riwayat Grade")) || (value.equals("Riwayat Jabatan dan Grade"))){
                                                    if (value.equals("Riwayat Jabatan")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisGroup = 0;
                                                    } 
                                                    if (value.equals("Riwayat Grade")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisGroup = 1;
                                                    }
                                                    if (value.equals("Riwayat Jabatan dan Grade")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisGroup = 2;
                                                    }
                                                } else {
                                                    html += "<td style=\"background-color:"+tdColor+"\">-</td>";
                                                    valHisGroup = -1;
                                                }
                                                empDocListMutation.setHistoryGroup(valHisGroup);
                                                break;
                                            case 13:
                                                int valHisType = -1;
                                                if ((value.equals("Career"))||(value.equals("Pejabat Sementara")) || (value.equals("Pelaksana Tugas")) || (value.equals("Detasir"))){
                                                    if (value.equals("Career")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisType = 0;
                                                    } 
                                                    if (value.equals("Pejabat Sementara")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisType = 1;
                                                    }
                                                    if (value.equals("Pelaksana Tugas")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisType = 2;
                                                    }
                                                    if (value.equals("Detasir")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valHisType = 3;
                                                    }
                                                } else {
                                                    html += "<td style=\"background-color:"+tdColor+"\">-</td>";
                                                    valHisType = -1;
                                                }
                                                empDocListMutation.setHistoryType(valHisType);
                                                break;
                                            case 14:
                                                if (value != null){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                } else {
                                                    html += "<td style=\"background-color:#fcd4dc; color:#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setObjectName(value);
                                                empDocList.setObject_name(value);
                                                break;
                                            case 15:
                                                int valTipeDoc = -1;
                                                if ((value.equals("Mutasi Dan Promosi"))||(value.equals("Pengangkatan")) || (value.equals("Resign"))){
                                                    if (value.equals("Mutasi Dan Promosi")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valTipeDoc = 0;
                                                    } 
                                                    if (value.equals("Pengangkatan")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valTipeDoc = 1;
                                                    }
                                                    if (value.equals("Resign")){
                                                        html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                        valTipeDoc = 2;
                                                    }
                                                    
                                                } else {
                                                    html += "<td style=\"background-color:"+tdColor+"\">-</td>";
                                                    valTipeDoc = -1;
                                                }
                                                empDocListMutation.setTipeDoc(valTipeDoc);
                                                break;
                                            case 16:
                                                if (!value.equals("0")){
                                                    html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                                }
                                                else{
                                                    html += "<td style\"background-color:#fcd4dc; color#d04761;\">"+ value + "</td>";
                                                }
                                                empDocListMutation.setEmpNum(value);
                                                break;
                                            default:
                                                html += "<td style=\"background-color:"+tdColor+"\">"+ value + "</td>";
                                        }
                                    } 
                                    
                                }
                                
                            } /*End For Cols*/
                            if (r > 0){
                                countInsert++;
                                PstEmpDocListMutation.insertExc(empDocListMutation);
                                PstEmpDocList.insertExc(empDocList);
                            }
                            
                            html += "</tr>";
                        } catch (Exception e) {
                            System.out.println("=> Can't get data ..sheet : " + i + ", row : " + r + ", => Exception e : " + e.toString());
                        }
                    } //end of sheet
                    html += "</table>";
                    int bnyakData = rows - 1;
                    html += "<div class=\"info\">Success : "+countInsert+"<br>Failed : "+(bnyakData-countInsert)+"</div>";
                    html += "<div class=\"warning\">";
                        html += "Jika ada kolom merah pada table, maka data tersebut tidak ada kaitannya dengan master data di database.";
                    html += "</div>";
                } else {
                    html += "<div class=\"info\">Not match document name and sheet name</div>";
                }                
            } //end of all sheets

        } catch (Exception e) {
            System.out.println("---=== Error : ReadStream ===---\n" + e);
        }
        ////////////////////////////////////////////
        return html;
    }
    
    public long getCompanyId(String company){
        long companyId = 0;
        String where = PstCompany.fieldNames[PstCompany.FLD_COMPANY]+"='"+company+"'";
        Vector listCompany = PstCompany.list(0, 1, where, "");
        if (listCompany != null && listCompany.size()>0){
            Company comp = (Company)listCompany.get(0);
            companyId = comp.getOID();
        }
        return companyId;
    }
    
    public long getDivisionId(String division){
        long divisionId = 0;
        String where = PstDivision.fieldNames[PstDivision.FLD_DIVISION]+"='"+division+"'";
        Vector listDivision = PstDivision.list(0, 1, where, "");
        if (listDivision != null && listDivision.size()>0){
            Division divi = (Division)listDivision.get(0);
            divisionId = divi.getOID();
        }
        return divisionId;
    }
    
    public long getDepartmentId(String department){
        long departmentId = 0;
        String where = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]+"='"+department+"'";
        departmentId = getDepartmentIdByName(where);
        return departmentId;
    }
    
    public long getSectionId(String section){
        long sectionId = 0;
        String where = PstSection.fieldNames[PstSection.FLD_SECTION]+"='"+section+"'";
        Vector listSection = PstSection.list(0, 1, where, "");
        if (listSection != null && listSection.size()>0){
            Section sect = (Section)listSection.get(0);
            sectionId = sect.getOID();
        }
        return sectionId;
    }
    
    public long getLevelId(String level){
        long levelId = 0;
        String where = PstLevel.fieldNames[PstLevel.FLD_LEVEL]+"='"+level+"'";
        Vector listLevel = PstLevel.list(0, 1, where, "");
        if (listLevel != null && listLevel.size()>0){
            Level lev = (Level)listLevel.get(0);
            levelId = lev.getOID();
        }
        return levelId;
    }
    
    public long getMaritalId(String maritalCode){
        long maritalId = 0;
        String where = PstMarital.fieldNames[PstMarital.FLD_MARITAL_CODE]+"='"+maritalCode+"'";
        Vector listMarital = PstMarital.list(0, 1, where, "");
        if (listMarital != null && listMarital.size()>0){
            Marital marital = (Marital)listMarital.get(0);
            maritalId = marital.getOID();
        }
        return maritalId;
    }
    
    public long getEmployeeCategoryId(String empCat){
        long empCatId = 0;
        String where = PstEmpCategory.fieldNames[PstEmpCategory.FLD_EMP_CATEGORY]+"='"+empCat+"'";
        Vector listEmpCat = PstEmpCategory.list(0, 1, where, "");
        if (listEmpCat != null && listEmpCat.size()>0){
            EmpCategory empCategory = (EmpCategory)listEmpCat.get(0);
            empCatId = empCategory.getOID();
        }
        return empCatId;
    }
    
    public long getPositionId(String position){
        long positionId = 0;
        String where = PstPosition.fieldNames[PstPosition.FLD_POSITION]+"='"+position+"'";
        Vector listPosition = PstPosition.list(0, 1, where, "");
        if (listPosition != null && listPosition.size()>0){
            Position pos = (Position)listPosition.get(0);
            positionId = pos.getOID();
        }
        return positionId;
    }
    
    public long getGradeId(String gradeCode){
        long gradeId = 0;
        String where = PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE]+"='"+gradeCode+"'";
        Vector listGrade = PstGradeLevel.list(0, 1, where, "");
        if (listGrade != null && listGrade.size()>0){
            GradeLevel grade = (GradeLevel)listGrade.get(0);
            gradeId = grade.getOID();
        }
        return gradeId;
    }
    
    public long getEmployeeId(String payrollnum){
        long employeeId = 0;
        String where = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+payrollnum+"'";
        Vector listEmployee = PstEmployee.list(0, 1, where, "");
        if (listEmployee != null && listEmployee.size()>0){
            Employee emp = (Employee)listEmployee.get(0);
            employeeId = emp.getOID();
        }
        return employeeId;
    }
    
    public static String getEmployeeNum(long employeeId){
        String empNum = "0";
        String where = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+"="+employeeId;
        Vector listEmployee = PstEmployee.list(0, 1, where, "");
        if (listEmployee != null && listEmployee.size()>0){
            Employee emp = (Employee)listEmployee.get(0);
            empNum = emp.getEmployeeNum();
        }
        return empNum;
    }
    
    public static long getDepartmentIdByName(String where) {
        long departmentId = 0;
        DBResultSet dbrs = null;
        String untukTest = "";
        try {
            String sql  = "SELECT "+PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID];
            sql += " FROM "+PstDepartment.TBL_HR_DEPARTMENT;
            sql += " WHERE "+where;

            dbrs = DBHandler.execQueryResult(sql);
            untukTest = sql;
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                departmentId = rs.getLong(PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]);
            }
            rs.close();
            return departmentId;

        } catch (Exception e) {
            System.out.println("Exception Deopartement: " + e.toString());
            System.out.println("exc" + untukTest);
        } finally {
            DBResultSet.close(dbrs);
        }
        return departmentId;
    }
}
