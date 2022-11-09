/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.payroll;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.payroll.PayComponent;
import com.dimata.harisma.entity.payroll.PayEmpLevel;
import com.dimata.harisma.entity.payroll.PayPeriod;
import com.dimata.harisma.entity.payroll.PaySlip;
import com.dimata.harisma.entity.payroll.PaySlipComp;
import com.dimata.harisma.entity.payroll.PstPayComponent;
import com.dimata.harisma.entity.payroll.PstPayEmpLevel;
import com.dimata.harisma.entity.payroll.PstPaySlip;
import com.dimata.harisma.entity.payroll.PstValue_Mapping;
import com.dimata.harisma.entity.payroll.Value_Mapping;
import com.dimata.util.Formater;
import com.dimata.util.blob.TextLoader;
import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

/**
 *
 * @author Dimata 007
 */
public class ProcessImportExcel {
    
    public Vector getListEmpResign(String startDate) {
        String query = PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = 1 AND ";
        query += PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DATE] + " < '" + startDate + "' ";
        Vector listData = PstEmployee.list(0, 0, query, "");
        return listData;
    }
    
    public void drawImportResult(PayPeriod payPeriod, String periodDate, ServletConfig config, HttpServletRequest request, HttpServletResponse response, JspWriter output, long empDivisionId, long sdmDivisionId) {
        String html = "";
        int NUM_HEADER = 2;
        int NUM_CELL = 0;

        ChangeValue changeValue = new ChangeValue();
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
            Hashtable payCompInput = new Hashtable();

            String divisionName = "";
            try {
                Division division = PstDivision.fetchExc(empDivisionId);
                divisionName = division.getDivision();
            } catch (Exception exc){}
            
            Vector<PaySlip> listOfPaySlip = new Vector();
            for (int i = 0; i < numOfSheets; i++) {
                int r = 0;
                HSSFSheet sheet = (HSSFSheet) wb.getSheetAt(i);
                output.print("<div class=\"info\"><strong> Period name : " + periodDate + "</strong><br>");
                output.print("<strong> Sheet name : " + sheet.getSheetName() + "</strong></div>");
                if (sheet == null || sheet.getSheetName() == null || sheet.getSheetName().length() < 1) {
                    output.print(" NOT MATCH : Period name and sheet name ");
                    continue;
                }
                if (sheet.getSheetName().equals(periodDate)){
                    int rows = sheet.getPhysicalNumberOfRows();

                    // loop untuk row dimulai dari numHeaderRow (0, .. numHeaderRow diabaikan) => untuk yang bukan sheet pertaman
                    int start = (i == 0) ? 0 : NUM_HEADER;
                    String empNum = "";
                    output.print("<table class=\"tblStyle\">");
                    for (r = start; r < rows; r++) {
                        Employee employee = null;
                        PaySlip paySlip = new PaySlip();
                        try {
                            HSSFRow row = sheet.getRow(r);
                            int cells = 0;
                            //if number of cell is static
                            if (NUM_CELL > 0) {
                                cells = NUM_CELL;
                            } else { //number of cell is dinamyc
                                cells = row.getPhysicalNumberOfCells();
                            }
                            tdColor = "#FFF;";
                            // ambil jumlah kolom yang sebenarnya
                            NUM_CELL = cells;
                            output.print("<tr>");
                            int caseValue = 0;
                            for (int c = 0; c < cells; c++) {
                                HSSFCell cell = row.getCell((short) c);
                                String value = null;
                                if (cell != null) {
                                    /* proses mem-filter value */
                                    switch (cell.getCellType()) {
                                        case HSSFCell.CELL_TYPE_FORMULA:
                                            value = String.valueOf(cell.getCellFormula());
                                            caseValue = 1;
                                            break;
                                        case HSSFCell.CELL_TYPE_NUMERIC:
                                            value = Formater.formatNumber(cell.getNumericCellValue(), "###");
                                            caseValue = 2;
                                            break;
                                        case HSSFCell.CELL_TYPE_STRING:
                                            value = String.valueOf(cell.getStringCellValue());
                                            caseValue = 3;
                                            break;
                                        default:
                                            value = String.valueOf(cell.getStringCellValue() != null ? cell.getStringCellValue() : "");
                                    }
                                }
                                /* Ambil data employee num */
                                if (caseValue == 3 && c == 1 && r > 0){ /* colom ini adalah employee number */
                                    empNum = value;
                                }
                                /* Ambil data Employee */
                                if (empNum.length()>0 && r > 0 && c == 1){
                                    try {
                                        employee = PstEmployee.getEmployeeByNum(empNum);
                                    } catch(Exception e){
                                        System.out.println("emp num is not available=>"+e.toString());
                                    }
                                    /* change color if nothing employee with emp num */
                                    if (employee == null){
                                        tdColor = "#fde1e8;";
                                    } else {
                                        if (empDivisionId == sdmDivisionId){
                                            tdColor = "#FFF;";
                                        } else {
                                            long oid = PstPaySlip.getPaySlipId(payPeriod.getOID(), employee.getOID());
                                            try {
                                                paySlip = PstPaySlip.fetchExc(oid);
                                            } catch (Exception exc){}
                                            //if (employee.getDivisionId() != empDivisionId){
                                            if (!paySlip.getDivision().equals(divisionName)){
                                                tdColor = "#fde1e8;";
                                            }
                                        }
                                    }
                                }
                                
                                
                                /* Proses menampilkan data ke html table */
                                if (r == 0){ /* Baris Header table */
                                    output.print("<td style=\"background-color:#DDD;\"><strong>"+ value + "</strong></td>");
                                } else {
                                    if (value.equals("NULL")){
                                        output.print("<td style=\"background-color:"+tdColor+"\">-</td>");
                                    } else {
                                        output.print("<td style=\"background-color:"+tdColor+"\">"+value+"</td>");
                                    }
                                }
                                
                                if (value != null && r == 0 && c > 2) {
                                    PayComponent comp = PstPayComponent.getManualInputComponent(value);
                                    if (comp != null && comp.getCompName().length() > 0) {
                                        payCompInput.put("" + c, comp.getCompCode());
                                    }
                                }
                                
                                if (r > 0 && payCompInput.containsKey("" + c)) {
                                    PaySlipComp slipComp = new PaySlipComp();
                                    try {
                                        String compCode = (String)payCompInput.get("" + c);
                                        slipComp.setCompCode(compCode);
                                        slipComp.setCompValue(Double.parseDouble(value));
                                    } catch (Exception exc) {
                                        System.out.println("r=" + r + " c=" + c + " " + exc);
                                    }
                                    paySlip.addPaySlipComp(slipComp);
                                }
                                
                            } /*End For Cols*/
                            
                            /* Check Emp Salary Level */
                            PayEmpLevel payEmpLevel = null;
                            if (employee.getOID() != 0){
                                if (payPeriod != null) {
                                    payEmpLevel = PstPayEmpLevel.getPayLevelByEmployeeOid(employee.getOID(), payPeriod.getStartDate(),
                                            payPeriod.getEndDate(), PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_LEVEL_CODE]);
                                } else {
                                    payEmpLevel = PstPayEmpLevel.getActiveLevelByEmployeeOid(employee.getOID());
                                }
                            }
                            if (payEmpLevel != null){
                                paySlip.setEmployeeId(employee.getOID());
                                paySlip.setPeriodId(payPeriod.getOID());
                                paySlip.setCommencDate(employee.getCommencingDate());
                                paySlip.setPaySlipDate(payPeriod.getPaySlipDate());
                                paySlip.setNote(employee.getEmployeeNum());
                            }
                            
                            if (paySlip != null) {
                                
                                try {
                                    if (employee != null) {
//                                        paySlip.setCompCode(changeValue.getCompanyName(employee.getCompanyId()));
//                                        paySlip.setDivision(changeValue.getDivisionName(employee.getDivisionId()));
//                                        paySlip.setDepartment(changeValue.getDepartmentName(employee.getDepartmentId()));
//                                        paySlip.setSection(changeValue.getSectionName(employee.getSectionId()));
//                                        paySlip.setPosition(changeValue.getPositionName(employee.getPositionId()));
//                                        paySlip.setGradeCode(changeValue.getGradeLevelName(employee.getGradeLevelId()));
                                        
                                        if (empDivisionId == sdmDivisionId){
                                            listOfPaySlip.add(paySlip);
                                        } else {
                                            if (paySlip.getDivision().equals(divisionName)){
                                                listOfPaySlip.add(paySlip);
                                            }
                                        }
                                    }
                                    
                                } catch (Exception exc) {
                                    System.out.println("Exception payslip:" + exc);
                                }
                            }
                            
                            output.print("</tr>");
                        } catch (Exception e) {
                            System.out.println("=> Can't get data ..sheet : " + i + ", row : " + r + ", => Exception e : " + e.toString());
                        }
                    } //end of sheet
                    output.print("</table>");
                    output.print("<div>&nbsp;</div>");
                } else {
                    output.print("<div class=\"info\">Not match period name and sheet name</div>");
                }                
            } //end of all sheets
            /* insert or update PaySlip */
            if (listOfPaySlip != null && listOfPaySlip.size()>0){
                String str = PstPaySlip.insertOrUpdateByExcel(listOfPaySlip);
                output.print("<div class=\"info\">"+str+"</div>");
            }
        } catch (Exception e) {
            System.out.println("---=== Error : ReadStream ===---\n" + e);
        }
    }
}
