/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

import com.dimata.harisma.entity.employee.CareerPath;
import com.dimata.harisma.entity.employee.EmpEducation;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstCareerPath;
import com.dimata.harisma.entity.employee.PstEmpEducation;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.Education;
import com.dimata.harisma.entity.masterdata.EmpCategory;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.entity.payroll.PstValue_Mapping;
import com.dimata.harisma.entity.payroll.SalaryLevelDetail;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import java.sql.Date;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;

/**
 *
 * @author Dimata 007
 */
public class EmployeeAmountXLS extends HttpServlet {
    public String[] divisionSelect = null;
    public String[] levelSelect = null;
    public String[] categorySelect = null;
    public String[] positionSelect = null;
    public int chooseBy = 0;
    public int month = 0;
    public int year = 0;
    
    private String payroll = "";
    private String testData = "";
    private String fieldKey = "";
    private String valueKey = "";
    private Vector listCareer = new Vector();
    
    public void setParameter(HttpServletRequest request){
        this.divisionSelect = FRMQueryString.requestStringValues(request, "division_select");
        this.levelSelect = FRMQueryString.requestStringValues(request, "level_select");
        this.categorySelect = FRMQueryString.requestStringValues(request, "category_select");
        this.positionSelect = FRMQueryString.requestStringValues(request, "position_select");
        this.chooseBy = FRMQueryString.requestInt(request, "choose_by");
        this.month = FRMQueryString.requestInt(request, "month");
        this.year = FRMQueryString.requestInt(request, "year");
    }
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }
    
    public void destroy() {/*no-code*/}
    
    private static HSSFFont createFont(HSSFWorkbook wb, int size, int color, boolean isBold) {
        HSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) size);
        font.setColor((short) color);
        if (isBold) {
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        }
        return font;
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        

        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Employee Amount XLS");

        HSSFCellStyle style1 = wb.createCellStyle();
        
        HSSFCellStyle style2 = wb.createCellStyle();
        style2.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());
        style2.setFillForegroundColor(new HSSFColor.WHITE().getIndex());
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);

        HSSFCellStyle style3 = wb.createCellStyle();
        style3.setFillBackgroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style3.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style3.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style3.setBorderRight(HSSFCellStyle.BORDER_THIN);

        HSSFRow row = sheet.createRow((short) 0);
        HSSFCell cell = row.createCell((short) 0);

        String[] divisionSelect = FRMQueryString.requestStringValues(request, "division_select");
        String[] levelSelect = FRMQueryString.requestStringValues(request, "level_select");
        String[] categorySelect = FRMQueryString.requestStringValues(request, "category_select");
        String[] positionSelect = FRMQueryString.requestStringValues(request, "position_select");
        int chooseBy = FRMQueryString.requestInt(request, "choose_by");
        int month = FRMQueryString.requestInt(request, "month");
        int year = FRMQueryString.requestInt(request, "year");
        
        GregorianCalendar calendar = new GregorianCalendar();
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.MONTH, month-1);
        String monthName = Formater.formatDate(calendar.getTime(), "MMMM");
        
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 3, 5)); // Periode :
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 3, 5)); // Satuan Kerja :
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 3, 5)); // Level || Emp Category || Position
        
        int countRow = 0;
        row = sheet.createRow((short) 1);
        cell = row.createCell((short) 2);
        cell.setCellValue("PERIODE");
        cell.setCellStyle(style1);
        cell = row.createCell((short) 3);
        cell.setCellValue(monthName+" "+year);
        cell.setCellStyle(style1);
        
        row = sheet.createRow((short) 2);
        cell = row.createCell((short) 2);
        cell.setCellValue("SATUAN KERJA");
        cell.setCellStyle(style1);
        cell = row.createCell((short) 3);
        cell.setCellValue("-CUSTOM-");
        cell.setCellStyle(style1);
        Vector listEdu = new Vector();
        switch(chooseBy){
            case 0: // For Level Selected
                row = sheet.createRow((short) 3);
                cell = row.createCell((short) 2);
                cell.setCellValue("LEVEL");
                cell.setCellStyle(style1);
                cell = row.createCell((short) 3);
                cell.setCellValue("-CUSTOM-");
                cell.setCellStyle(style1);
                countRow = 5;
                row = sheet.createRow((short) countRow);

                cell = row.createCell((short) 1);
                cell.setCellValue("NO");
                cell.setCellStyle(style3);

                cell = row.createCell((short) 2);
                cell.setCellValue("DIVISI / SATUAN KERJA");
                cell.setCellStyle(style3);
                
                /* For Title Table : No & Divisi / Satuan Kerja */
                sheet.addMergedRegion(new CellRangeAddress(5, 6, 1, 1)); // merge row 5 dengan row 6 | merge col 1 dengan col 1
                sheet.addMergedRegion(new CellRangeAddress(5, 6, 2, 2)); // merge row 5 dengan row 6 | merge col 2 dengan col 2
                
                if (levelSelect != null){
                    int kol = 3;
                    for(int h=0; h<levelSelect.length; h++){
                        sheet.addMergedRegion(new CellRangeAddress(5, 5, kol, kol+1));
                        cell = row.createCell((short) kol);
                        cell.setCellValue(getLevelName(Long.valueOf(levelSelect[h])));
                        cell.setCellStyle(style3);
                        kol = kol + 2;
                    }
                    sheet.addMergedRegion(new CellRangeAddress(5, 5, kol, kol+1));
                    cell = row.createCell((short) kol);
                    cell.setCellValue("TOTAL");
                    cell.setCellStyle(style3);
                }
                countRow = 6;
                row = sheet.createRow((short) countRow);
                if (levelSelect != null){
                    int kol1 = 3;
                    int kol2 = 4;
                    for(int j=0; j<levelSelect.length; j++){
                        cell = row.createCell((short) kol1);
                        cell.setCellValue("LAKI-LAKI");
                        cell.setCellStyle(style3);
                        cell = row.createCell((short) kol2);
                        cell.setCellValue("PEREMPUAN");
                        cell.setCellStyle(style3);
                        kol1 = kol1 + 2;
                        kol2 = kol2 + 2;
                    }
                    cell = row.createCell((short) kol1);
                    cell.setCellValue("LAKI-LAKI");
                    cell.setCellStyle(style3);
                    cell = row.createCell((short) kol2);
                    cell.setCellValue("PEREMPUAN");
                    cell.setCellStyle(style3);
                }
                break; // end level
            case 1: // For Emp Category Selected
                row = sheet.createRow((short) 3);
                cell = row.createCell((short) 2);
                cell.setCellValue("KATEGORI KARYAWAN");
                cell.setCellStyle(style1);
                cell = row.createCell((short) 3);
                cell.setCellValue("-CUSTOM-");
                cell.setCellStyle(style1);
                countRow = 5;
                row = sheet.createRow((short) countRow);

                cell = row.createCell((short) 1);
                cell.setCellValue("NO");
                cell.setCellStyle(style3);

                cell = row.createCell((short) 2);
                cell.setCellValue("DIVISI / SATUAN KERJA");
                cell.setCellStyle(style3);
                
                /* For Title Table : No & Divisi / Satuan Kerja */
                sheet.addMergedRegion(new CellRangeAddress(5, 6, 1, 1)); // merge row 5 dengan row 6 | merge col 1 dengan col 1
                sheet.addMergedRegion(new CellRangeAddress(5, 6, 2, 2)); // merge row 5 dengan row 6 | merge col 2 dengan col 2
                
                if (categorySelect != null){
                    /* Get Education Data */
                    listEdu = PstEducation.list(0, 0, "", "");
                    
                    int kol = 3;
                    for(int h=0; h<categorySelect.length; h++){
                        sheet.addMergedRegion(new CellRangeAddress(5, 5, kol, kol+(listEdu.size()-1)));
                        cell = row.createCell((short) kol);
                        cell.setCellValue(getEmpCategory(Long.valueOf(categorySelect[h])));
                        cell.setCellStyle(style3);
                        kol = kol + listEdu.size();
                    }
                    sheet.addMergedRegion(new CellRangeAddress(5, 6, kol, kol));
                    cell = row.createCell((short) kol);
                    cell.setCellValue("TOTAL");
                    cell.setCellStyle(style3);
                    countRow = 6;
                    row = sheet.createRow((short) countRow);
                    kol = 3;
                    for(int i=0; i<categorySelect.length; i++){
                        if (listEdu != null && listEdu.size()>0){
                            for(int e=0; e<listEdu.size(); e++){
                                Education edu = (Education)listEdu.get(e);
                                cell = row.createCell((short) kol);
                                cell.setCellValue(edu.getEducation());
                                cell.setCellStyle(style3);
                                kol++;
                            }
                        }
                    }
                }
                break; // end emp category
            case 2: // For Position Selected
                row = sheet.createRow((short) 3);
                cell = row.createCell((short) 2);
                cell.setCellValue("POSITION");
                cell.setCellStyle(style1);
                cell = row.createCell((short) 3);
                cell.setCellValue("-CUSTOM-");
                cell.setCellStyle(style1);
                countRow = 5;
                row = sheet.createRow((short) countRow);

                cell = row.createCell((short) 1);
                cell.setCellValue("NO");
                cell.setCellStyle(style3);

                cell = row.createCell((short) 2);
                cell.setCellValue("DIVISI / SATUAN KERJA");
                cell.setCellStyle(style3);
                
                if (positionSelect != null){
                    int kol = 3;
                    for (int h=0; h<positionSelect.length; h++){
                        cell = row.createCell((short) kol);
                        cell.setCellValue(getPositionName(Long.valueOf(positionSelect[h])));
                        cell.setCellStyle(style3);
                        kol++;
                    }
                    cell = row.createCell((short) kol);
                    cell.setCellValue("TOTAL");
                    cell.setCellStyle(style3);
                }
                break; // end position
        }

        int no = 0;
        /* Record Result */
        if (divisionSelect != null){
            for(int i=0; i<divisionSelect.length; i++){
                no++;
                countRow++;
                row = sheet.createRow((short) (countRow));
                cell = row.createCell((short) 1);
                cell.setCellValue(no);
                cell.setCellStyle(style2);
                
                cell = row.createCell((short) 2);
                cell.setCellValue(getDivisionName(Long.valueOf(divisionSelect[i])));
                cell.setCellStyle(style2);
                switch(chooseBy){
                    case 0: 
                        if (levelSelect != null){
                            int kol1 = 3;
                            int kol2 = 4;
                            int total1 = 0;
                            int total2 = 0;
                            for (int h=0; h<levelSelect.length; h++){
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionSelect[i];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+levelSelect[h];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_SEX]+"=0";
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] +" <= '"+year+"-"+month+"-01'";
                                int total = getTotalEmployeeByPosition(where);
                                total1 = total1 + total;
                                cell = row.createCell((short) kol1);
                                cell.setCellValue(total);
                                cell.setCellStyle(style2);
                                where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionSelect[i];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+"="+levelSelect[h];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_SEX]+"=1";
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] +" <= '"+year+"-"+month+"-01'";
                                total = getTotalEmployeeByPosition(where);
                                total2 = total2 + total;
                                cell = row.createCell((short) kol2);
                                cell.setCellValue(total);
                                cell.setCellStyle(style2);
                                kol1 = kol1 + 2;
                                kol2 = kol2 + 2;
                            }
                            cell = row.createCell((short) kol1);
                            cell.setCellValue(total1);
                            cell.setCellStyle(style2);
                            
                            cell = row.createCell((short) kol2);
                            cell.setCellValue(total2);
                            cell.setCellStyle(style2);
                        }
                        break;
                    case 1:
                        if (categorySelect != null){
                            int kol = 3;
                            int totalAll = 0;
                            for (int h=0; h<categorySelect.length; h++){
                                /* cari data employee berdasarkan divisi dan kategori */
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionSelect[i];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+categorySelect[h];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] +" <= '"+year+"-"+month+"-01'";
                                
                                Vector listEmp = PstEmployee.list(0, 0, where, "");
                                Vector<Long> vEmpEdu = new Vector<Long>();
                                /* data karyawan berdasarkan divisi dan kategori didapat */
                                int totalKategori = 0;
                                if (listEmp != null && listEmp.size()>0){
                                    totalKategori = listEmp.size();
                                    for(int em=0; em<listEmp.size(); em++){
                                        Employee emp = (Employee)listEmp.get(em);
                                        String whereEmpEdu = " EMPLOYEE_ID="+emp.getOID();
                                        Vector listEmpEdu = PstEmpEducation.list(0, 1, whereEmpEdu, "START_DATE DESC");
                                        if (listEmpEdu != null && listEmpEdu.size()>0){
                                            EmpEducation empEdu = (EmpEducation)listEmpEdu.get(0);
                                            vEmpEdu.add(empEdu.getEducationId());
                                        }
                                    }
                                }
                                int total = 0;
                                
                                if(listEdu != null && listEdu.size()>0){
                                    for(int e=0; e<listEdu.size(); e++){
                                        Education edu = (Education)listEdu.get(e);
                                        
                                        for(int v=0; v<vEmpEdu.size(); v++){
                                            Long dEmpEdu = (Long)vEmpEdu.get(v);
                                            if (edu.getOID()==dEmpEdu){
                                                total++;
                                            }
                                        }
                                        cell = row.createCell((short) kol);
                                        cell.setCellValue(total);
                                        cell.setCellStyle(style2);
                                        total = 0;
                                        kol++;
                                    }
                                }
                                totalAll = totalAll + totalKategori;
                                cell = row.createCell((short) kol);
                                cell.setCellValue(totalAll);
                                cell.setCellStyle(style2);
                            }
                        }
                        break;
                    case 2: 
                        if (positionSelect != null){
                            int kol = 3;
                            int totalAll = 0;
                            for (int h=0; h<positionSelect.length; h++){
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionSelect[i];
                                where += " AND "+ PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionSelect[h];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] +" <= '"+year+"-"+month+"-01'";
                                int total = getTotalEmployeeByPosition(where);
                                totalAll = totalAll + total;
                                cell = row.createCell((short) kol);
                                cell.setCellValue(total);
                                cell.setCellStyle(style2);
                                kol++;
                            }
                            cell = row.createCell((short) kol);
                            cell.setCellValue(totalAll);
                            cell.setCellStyle(style2);
                        }
                        break;
                }
                
            }
        }

        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
    
    }
    
    public String getDrawListAmount(int chooseBy, String dateFrom, String dateTo, String[] divisionSelect, String[] levelSelect, String[] categorySelect, String[] positionSelect){
        return getDrawListAmount(chooseBy, dateFrom, dateTo, divisionSelect, levelSelect, categorySelect, positionSelect, null, null);
    }
    
    public String getDrawListAmount(int chooseBy, String dateFrom, String dateTo, String[] divisionSelect, String[] levelSelect, String[] categorySelect, String[] positionSelect, String[] departmentSelect, String[] sectionSelect){
        String strDate = dateTo.replaceAll("-", "");
        int periodDate = Integer.valueOf(strDate);
        String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo+ "'";
        Vector dataNoResign = getEmployeeNoResign(whereClause, periodDate);
        String strTable = "";
        int no = 0;
        
        String multiDepartmentId = "";
        if (departmentSelect != null) {
            for (String s : departmentSelect) {
                multiDepartmentId += (multiDepartmentId.length() == 0) ? s : "," + s;
            }
        }
        
        String multiSectionId = "";
        if (sectionSelect != null) {
            for (String s : sectionSelect) {
                multiSectionId += (multiSectionId.length() == 0) ? s : "," + s;
            }
        }
        
        String styleText = "white-space: nowrap;";
        String styleTextDepartment = "padding-left: 10px;";
        String styleTextSection = "padding-left: 27px;";
        String styleDivision = "background-color:#BBB; text-align: center;";
        String styleDepartment = "background-color:#CCC; text-align: center;";
        String styleSection = "background-color:#DDD; text-align: center;";
        String styleTotal = "background-color:#EEE; text-align: center;";
        
        switch (chooseBy) {
            case 0:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">Satuan Kerja / Unit / Sub Unit</td>";
                
                if (levelSelect != null) {
                    for (String s : levelSelect) {
                        strTable += "<td class=\"title_tbl\" colspan=\"2\" style=\"background-color: #EEE; text-align: center;\">" + getLevelName(Long.valueOf(s)) + "</td>";
                    }
                    strTable += "<td class=\"title_tbl\" colspan=\"2\" style=\"background-color: #EEE; text-align: center;\">Total</td>";
                }
                strTable += "</tr>";
                strTable += "<tr>";
                if (levelSelect != null) {
                    for (String s : levelSelect) {
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">L</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">P</td>";
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">L</td>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">P</td>";
                }
                strTable += "</tr>";
                
                if (levelSelect != null) {
                    if (divisionSelect != null) {
                        int arrTotalM[][] = new int [divisionSelect.length][levelSelect.length];
                        int arrTotalW[][] = new int [divisionSelect.length][levelSelect.length];
                        int arrTotalAllM[] = new int [divisionSelect.length];
                        int arrTotalAllW[] = new int [divisionSelect.length];
                        int totRowM = 0; 
                        int totRowW = 0;

                        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SEX] + "=0";
                        whereClause += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo + "'";
                        Vector dataNoResignM = getEmployeeNoResign(whereClause, periodDate);
                        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SEX] + "=1";
                        whereClause += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo + "'";
                        Vector dataNoResignW = getEmployeeNoResign(whereClause, periodDate);
                        for (int i = 0; i < divisionSelect.length; i++) {
                            no++;
                            strTable += "<tr>";
                            strTable += "<td>" + no + "</td>";
                            strTable += "<td style='" + styleText + "'>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                            ////////////////////
                            int total1 = 0;
                            int total2 = 0;
                            for (int h = 0; h < levelSelect.length; h++) {
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + "=" + levelSelect[h];
                                int total = getDataCareerPath(dataNoResignM, where, dateFrom, dateTo);
                                total1 = total1 + total;
                                arrTotalM[i][h] = total;
                                strTable += "<td style='" + styleDivision + "'>" + total + "</td>";
                                where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + "=" + levelSelect[h];
                                total = getDataCareerPath(dataNoResignW, where, dateFrom, dateTo);
                                total2 = total2 + total;
                                arrTotalW[i][h] = total;
                                strTable += "<td style='" + styleDivision + "'>" + total + "</td>";
                            }
                            arrTotalAllM[i] = total1;
                            arrTotalAllW[i] = total2;
                            strTable += "<td style='" + styleTotal + "'>" + total1 + "</td>";
                            strTable += "<td style='" + styleTotal + "'>" + total2 + "</td>";
                            ////////////////////
                            strTable += "</tr>";
                            
                            //CEK APAKAH PUNYA DEPARTMENT SESUAI DENGAN DEPARTMENT YG DIPILIH
                            if (multiDepartmentId.length() > 0) {
                                String whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + divisionSelect[i];
                                whereDept += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " IN (" + multiDepartmentId + ")";
                                Vector<Department> listDep = PstDepartment.list(0, 0, whereDept, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
                                int deptIndex = 0;
                                for (Department dep : listDep) {
                                    deptIndex++;
                                    strTable += "<tr>";
                                    strTable += "<td></td>";
                                    strTable += "<td style='" + styleText + styleTextDepartment + "'>" + deptIndex + ". &nbsp;" + dep.getDepartment() + "</td>";
                                    int totalDeptMale = 0;
                                    int totalDeptFemaleMale = 0;
                                    for (String level : levelSelect) {
                                        //MALE
                                        String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + divisionSelect[i];
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = " + level;
                                        int total = getDataCareerPath(dataNoResignM, where, dateFrom, dateTo);
                                        totalDeptMale += total;
                                        strTable += "<td style='" + styleDepartment + "'>" + total + "</td>";
                                        //FEMALE
                                        where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = " + level;
                                        total = getDataCareerPath(dataNoResignW, where, dateFrom, dateTo);
                                        totalDeptFemaleMale += total;
                                        strTable += "<td style='" + styleDepartment + "'>" + total + "</td>";
                                    }
                                    strTable += "<td style='" + styleTotal + "'>" + totalDeptMale + "</td>";
                                    strTable += "<td style='" + styleTotal + "'>" + totalDeptFemaleMale + "</td>";
                                    strTable += "</tr>";
                                    
                                    //CEK APAKAH PUNYA SECTION SESUAI DENGAN SECTION YG DIPILIH
                                    if (multiSectionId.length() > 0) {
                                        String whereSec = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                        whereSec += " AND " + PstSection.fieldNames[PstSection.FLD_SECTION_ID] + " IN (" + multiSectionId + ")";
                                        Vector<Section> listSec = PstSection.list(0, 0, whereSec, PstSection.fieldNames[PstSection.FLD_SECTION]);
                                        int secIndex = 0;
                                        for (Section sec : listSec) {
                                            secIndex++;
                                            strTable += "<tr>";
                                            strTable += "<td></td>";
                                            strTable += "<td style='" + styleText + styleTextSection + "'>" + secIndex + ") &nbsp;" + sec.getSection()+ "</td>";
                                            int totalSecMale = 0;
                                            int totalSecFemaleMale = 0;
                                            for (String level : levelSelect) {
                                                //MALE
                                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + divisionSelect[i];
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + sec.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = " + level;
                                                int total = getDataCareerPath(dataNoResignM, where, dateFrom, dateTo);
                                                totalSecMale += total;
                                                strTable += "<td style='" + styleSection + "'>" + total + "</td>";
                                                //FEMALE
                                                where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + sec.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = " + level;
                                                total = getDataCareerPath(dataNoResignW, where, dateFrom, dateTo);
                                                totalSecFemaleMale += total;
                                                strTable += "<td style='" + styleSection + "'>" + total + "</td>";
                                            }
                                            strTable += "<td style='" + styleTotal + "'>" + totalSecMale + "</td>";
                                            strTable += "<td style='" + styleTotal + "'>" + totalSecFemaleMale + "</td>";
                                            strTable += "</tr>";
                                        }
                                    }
                                }
                            }
                            
                        }
                        strTable += "<tr>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                        for(int k=0; k<levelSelect.length; k++){
                            for(int l=0; l<divisionSelect.length; l++){
                                totRowM = totRowM + arrTotalM[l][k];
                                totRowW = totRowW + arrTotalW[l][k];
                            }
                            strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totRowM+"</td>";
                            strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totRowW+"</td>";
                            totRowM = 0;
                            totRowW = 0;
                        }
                        int totAllM = 0;
                        int totAllW = 0;
                        for(int m=0; m<divisionSelect.length; m++){
                            totAllM = totAllM + arrTotalAllM[m];
                            totAllW = totAllW + arrTotalAllW[m];
                        }
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totAllM+"</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totAllW+"</td>";
                        strTable += "</tr>";
                    }
                }
                strTable += "</table>";
                break;
            case 1:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">Satuan Kerja / Unit / Sub Unit</td>";
                /* Get Education Data */
                Vector listEdu = PstEducation.list(0, 0, "", "");
                no = 0;
                if (categorySelect != null) {
                    for (int h = 0; h < categorySelect.length; h++) {
                        strTable += "<td colspan=\"" + listEdu.size() + "\" class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">" + getEmpCategory(Long.valueOf(categorySelect[h])) + "</td>";
                    }
                    strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">Total</td>";
                    strTable += "</tr>";
                    strTable += "<tr>";
                    for (int i = 0; i < categorySelect.length; i++) {
                        if (listEdu != null && listEdu.size() > 0) {
                            for (int e = 0; e < listEdu.size(); e++) {
                                Education edu = (Education) listEdu.get(e);
                                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">" + edu.getEducation() + "</td>";
                            }
                        }
                    }
                }
                strTable += "</tr>";
                int arrTotCat[][] = new int[divisionSelect.length][categorySelect.length];
                int arrAllCat[] = new int[divisionSelect.length];
                if (divisionSelect != null) {
                    String empl = "";
                    Vector vEmp = new Vector();
                    for (int i = 0; i < divisionSelect.length; i++) {
                        no++;
                        int totalKategori = 0;
                        strTable += "<tr>";
                        strTable += "<td>" + no + "</td>";
                        strTable += "<td style='" + styleText + "'>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                        ////////////////////
                        int totalAll = 0;
                        for (int h = 0; h < categorySelect.length; h++) {
                            /* cari data employee berdasarkan divisi dan kategori */
                            String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                            where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + "=" + categorySelect[h];
                            //Vector<String> dataEmpIds = getDataEmployeeId(dataNoResign, where, year + "-" + month + "-01");
                            Vector<String> dataEmpIds = getDataEmployeeCareer(dataNoResign, where, dateFrom, dateTo);
                            Vector<Long> vEmpEdu = new Vector<Long>();
                            /* data karyawan berdasarkan divisi dan kategori didapat */
                            if (dataEmpIds != null && dataEmpIds.size() > 0) {
                                totalKategori = dataEmpIds.size();
                                for (int em = 0; em < dataEmpIds.size(); em++) {
                                    String dataEmpId = (String) dataEmpIds.get(em);
                                    String whereEmpEdu = " EMPLOYEE_ID=" + dataEmpId;
                                    Vector listEmpEdu = PstEmpEducation.list(0, 1, whereEmpEdu, "START_DATE DESC");
                                    if (listEmpEdu != null && listEmpEdu.size() > 0) {
                                        EmpEducation empEdu = (EmpEducation) listEmpEdu.get(0);
                                        vEmpEdu.add(empEdu.getEducationId());
                                        vEmp.add(dataEmpId);
                                    }
                                }
                                totalAll = totalAll + totalKategori;
                                arrTotCat[i][h] = totalKategori;
                                arrAllCat[i] = totalAll;
                            }
                            int total = 0;

                            if (listEdu != null && listEdu.size() > 0) {
                                for (int e = 0; e < listEdu.size(); e++) {
                                    Education edu = (Education) listEdu.get(e);

                                    for (int v = 0; v < vEmpEdu.size(); v++) {
                                        Long dEmpEdu = (Long) vEmpEdu.get(v);
                                        String strEmp = (String)vEmp.get(v);
                                        if (edu.getOID() == dEmpEdu) {
                                            total++;
                                            empl = empl + strEmp + "<br>";
                                        }
                                    }
                                    strTable += "<td style='" + styleDivision + "'>" + total + "</td>";
                                    total = 0;
                                    empl = "";
                                }
                            }
                        }
                        strTable += "<td style='" + styleTotal + "'>" + totalAll + "</td>";
                        ////////////////////
                        strTable += "</tr>";
                        
                        //CEK APAKAH PUNYA DEPARTMENT SESUAI DENGAN DEPARTMENT YG DIPILIH
                        if (multiDepartmentId.length() > 0) {
                            String whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + divisionSelect[i];
                            whereDept += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " IN (" + multiDepartmentId + ")";
                            Vector<Department> listDep = PstDepartment.list(0, 0, whereDept, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
                            int deptIndex = 0;
                            for (Department dep : listDep) {
                                deptIndex++;
                                strTable += "<tr>";
                                strTable += "<td></td>";
                                strTable += "<td style='" + styleText + styleTextDepartment + "'>" + deptIndex + ". &nbsp;" + dep.getDepartment() + "</td>";
                                //>>>>>>>>>>
                                int totalAllDept = 0;
                                for (int h = 0; h < categorySelect.length; h++) {
                                    /* cari data employee berdasarkan divisi, department dan kategori */
                                    String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                    where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "=" + dep.getOID();
                                    where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + "=" + categorySelect[h];
                                    //Vector<String> dataEmpIds = getDataEmployeeId(dataNoResign, where, year + "-" + month + "-01");
                                    Vector<String> dataEmpIds = getDataEmployeeCareer(dataNoResign, where, dateFrom, dateTo);
                                    Vector<Long> vEmpEdu = new Vector<Long>();
                                    /* data karyawan berdasarkan divisi dan kategori didapat */
                                    if (dataEmpIds != null && dataEmpIds.size() > 0) {
                                        totalKategori = dataEmpIds.size();
                                        for (int em = 0; em < dataEmpIds.size(); em++) {
                                            String dataEmpId = (String) dataEmpIds.get(em);
                                            String whereEmpEdu = " EMPLOYEE_ID = " + dataEmpId;
                                            Vector listEmpEdu = PstEmpEducation.list(0, 1, whereEmpEdu, "START_DATE DESC");
                                            if (listEmpEdu != null && listEmpEdu.size() > 0) {
                                                EmpEducation empEdu = (EmpEducation) listEmpEdu.get(0);
                                                vEmpEdu.add(empEdu.getEducationId());
                                                vEmp.add(dataEmpId);
                                            }
                                        }
                                        totalAllDept += totalKategori;
                                    }
                                    int total = 0;

                                    if (listEdu != null && listEdu.size() > 0) {
                                        for (int e = 0; e < listEdu.size(); e++) {
                                            Education edu = (Education) listEdu.get(e);
                                            for (int v = 0; v < vEmpEdu.size(); v++) {
                                                Long dEmpEdu = (Long) vEmpEdu.get(v);
                                                String strEmp = (String)vEmp.get(v);
                                                if (edu.getOID() == dEmpEdu) {
                                                    total++;
                                                    empl = empl + strEmp + "<br>";
                                                }
                                            }
                                            strTable += "<td style='" + styleDepartment + "'>" + total + "</td>";
                                            total = 0;
                                            empl = "";
                                        }
                                    }
                                }
                                strTable += "<td style='" + styleTotal + "'>" + totalAllDept + "</td>";
                                //<<<<<<<<<<
                                strTable += "</tr>";
                                
                                //CEK APAKAH PUNYA SECTION SESUAI DENGAN SECTION YG DIPILIH
                                if (multiSectionId.length() > 0) {
                                        String whereSec = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                        whereSec += " AND " + PstSection.fieldNames[PstSection.FLD_SECTION_ID] + " IN (" + multiSectionId + ")";
                                        Vector<Section> listSec = PstSection.list(0, 0, whereSec, PstSection.fieldNames[PstSection.FLD_SECTION]);
                                        int secIndex = 0;
                                        for (Section sec : listSec) {
                                            secIndex++;
                                            strTable += "<tr>";
                                            strTable += "<td></td>";
                                            strTable += "<td style='" + styleText + styleTextSection + "'>" + secIndex + ") &nbsp;" + sec.getSection()+ "</td>";
                                            //>>>>>>>>>>
                                            int totalAllSec = 0;
                                            for (int h = 0; h < categorySelect.length; h++) {
                                                /* cari data employee berdasarkan divisi, department dan kategori */
                                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "=" + dep.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + "=" + sec.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + "=" + categorySelect[h];
                                                //Vector<String> dataEmpIds = getDataEmployeeId(dataNoResign, where, year + "-" + month + "-01");
                                                Vector<String> dataEmpIds = getDataEmployeeCareer(dataNoResign, where, dateFrom, dateTo);
                                                Vector<Long> vEmpEdu = new Vector<Long>();
                                                /* data karyawan berdasarkan divisi dan kategori didapat */
                                                if (dataEmpIds != null && dataEmpIds.size() > 0) {
                                                    totalKategori = dataEmpIds.size();
                                                    for (int em = 0; em < dataEmpIds.size(); em++) {
                                                        String dataEmpId = (String) dataEmpIds.get(em);
                                                        String whereEmpEdu = " EMPLOYEE_ID = " + dataEmpId;
                                                        Vector listEmpEdu = PstEmpEducation.list(0, 1, whereEmpEdu, "START_DATE DESC");
                                                        if (listEmpEdu != null && listEmpEdu.size() > 0) {
                                                            EmpEducation empEdu = (EmpEducation) listEmpEdu.get(0);
                                                            vEmpEdu.add(empEdu.getEducationId());
                                                            vEmp.add(dataEmpId);
                                                        }
                                                    }
                                                    totalAllSec += totalKategori;
                                                }
                                                int total = 0;

                                                if (listEdu != null && listEdu.size() > 0) {
                                                    for (int e = 0; e < listEdu.size(); e++) {
                                                        Education edu = (Education) listEdu.get(e);
                                                        for (int v = 0; v < vEmpEdu.size(); v++) {
                                                            Long dEmpEdu = (Long) vEmpEdu.get(v);
                                                            String strEmp = (String)vEmp.get(v);
                                                            if (edu.getOID() == dEmpEdu) {
                                                                total++;
                                                                empl = empl + strEmp + "<br>";
                                                            }
                                                        }
                                                        strTable += "<td style='" + styleSection + "'>" + total + "</td>";
                                                        total = 0;
                                                        empl = "";
                                                    }
                                                }
                                            }
                                            strTable += "<td style='" + styleTotal + "'>" + totalAllSec + "</td>";
                                            //<<<<<<<<<<
                                            strTable += "</tr>";
                                        }
                                }
                            }
                        }                        
                    }
                    strTable += "<tr>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                    int totRow = 0;
                    int totRowCol = 0;
                    for (int c = 0; c < categorySelect.length; c++) {
                        for(int d=0; d < divisionSelect.length; d++){
                            totRow = totRow + arrTotCat[d][c];
                        }
                        strTable += "<td colspan=\"" + listEdu.size() + "\" class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">" + totRow + "</td>";
                        totRow = 0;
                    }
                    for (int n=0; n<divisionSelect.length; n++){
                        totRowCol = totRowCol + arrAllCat[n];
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">" + totRowCol + "</td>";
                    strTable += "</tr>";
                }
                strTable += "</table>";
                break;
            case 2:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Satuan Kerja / Unit / Sub Unit</td>";

                if (positionSelect != null) {
                    for (int h = 0; h < positionSelect.length; h++) {
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">" + getPositionName(Long.valueOf(positionSelect[h])) + "</td>";
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">Total</td>";
                }
                strTable += "</tr>";
                int arrTotal[][] = new int [divisionSelect.length][positionSelect.length];
                int arrTotalAll [] = new int [divisionSelect.length];
                int totalRow = 0;
                int totalRowCol = 0;
                if (divisionSelect != null) {
                    no = 0;
                    for (int i = 0; i < divisionSelect.length; i++) {
                        no++;
                        strTable += "<tr>";
                        strTable += "<td>" + no + "</td>";
                        strTable += "<td style='" + styleText + "'>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                        if (positionSelect != null) {
                            int totalAll = 0;
                            for (int h = 0; h < positionSelect.length; h++) {
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + positionSelect[h];
                                int total = getDataCareerPath(dataNoResign, where, dateFrom, dateTo);
                                arrTotal[i][h] = total;
                                totalAll = totalAll + total;
                                strTable += "<td style='" + styleDivision + "'>" + total + "</td>";
                            }
                            arrTotalAll[i] = totalAll;
                            strTable += "<td style='" + styleTotal + "'>" + totalAll + "</td>";
                        }
                        strTable += "</tr>";
                        totalRowCol = totalRowCol + arrTotalAll[i];
                        
                        //CEK APAKAH PUNYA DEPARTMENT SESUAI DENGAN DEPARTMENT YG DIPILIH
                        if (multiDepartmentId.length() > 0) {
                            String whereDept = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + divisionSelect[i];
                            whereDept += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " IN (" + multiDepartmentId + ")";
                            Vector<Department> listDep = PstDepartment.list(0, 0, whereDept, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
                            int deptIndex = 0;
                            for (Department dep : listDep) {
                                deptIndex++;
                                strTable += "<tr>";
                                strTable += "<td></td>";
                                strTable += "<td style='" + styleText + styleTextDepartment + "'>" + deptIndex + ". &nbsp;" + dep.getDepartment() + "</td>";
                                if (positionSelect != null) {
                                    int totalAllDept = 0;
                                    for (int h = 0; h < positionSelect.length; h++) {
                                        String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "=" + dep.getOID();
                                        where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + positionSelect[h];
                                        int total = getDataCareerPath(dataNoResign, where, dateFrom, dateTo);
                                        totalAllDept += total;
                                        strTable += "<td style='" + styleDepartment + "'>" + total + "</td>";
                                    }
                                    strTable += "<td style='" + styleTotal + "'>" + totalAllDept + "</td>";
                                }
                                strTable += "</tr>";
                                
                                //CEK APAKAH PUNYA SECTION SESUAI DENGAN SECTION YG DIPILIH
                                if (multiSectionId.length() > 0) {
                                    String whereSec = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + dep.getOID();
                                    whereSec += " AND " + PstSection.fieldNames[PstSection.FLD_SECTION_ID] + " IN (" + multiSectionId + ")";
                                    Vector<Section> listSec = PstSection.list(0, 0, whereSec, PstSection.fieldNames[PstSection.FLD_SECTION]);
                                    int secIndex = 0;
                                    for (Section sec : listSec) {
                                        secIndex++;
                                        strTable += "<tr>";
                                        strTable += "<td></td>";
                                        strTable += "<td style='" + styleText + styleTextSection + "'>" + secIndex + ") &nbsp;" + sec.getSection()+ "</td>";
                                        
                                        if (positionSelect != null) {
                                            int totalAllSec = 0;
                                            for (int h = 0; h < positionSelect.length; h++) {
                                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + "=" + dep.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + "=" + sec.getOID();
                                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + positionSelect[h];
                                                int total = getDataCareerPath(dataNoResign, where, dateFrom, dateTo);
                                                totalAllSec += total;
                                                strTable += "<td style='" + styleSection + "'>" + total + "</td>";
                                            }
                                            strTable += "<td style='" + styleTotal + "'>" + totalAllSec + "</td>";
                                        }
                                        strTable += "</tr>";
                                    }
                                }
                            }
                        }
                    }
                }
                strTable += "<tr>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                
                if (positionSelect != null) {
                    for (int h = 0; h < positionSelect.length; h++) {
                        for(int i=0; i < divisionSelect.length; i++){
                            totalRow = totalRow + arrTotal[i][h];
                        }
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totalRow+"</td>";
                        totalRow = 0;
                    }
                }
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE; text-align: center;\">"+totalRowCol+"</td>";
                strTable += "</tr>";
                strTable += "</table>";
                break;
        }
        return strTable;
    }
    
    
    public String getDrawListAmountOld(int chooseBy, String dateFrom, String dateTo, String[] divisionSelect, String[] levelSelect, String[] categorySelect, String[] positionSelect){
        String strDate = dateTo.replaceAll("-", "");
        int periodDate = Integer.valueOf(strDate);
        String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo+ "'";
        Vector dataNoResign = getEmployeeNoResign(whereClause, periodDate);
        String strTable = "";
        int no = 0;
        
        switch (chooseBy) {
            case 0:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">Divisi / Satuan Kerja</td>";
                
                if (levelSelect != null) {
                    for (int h = 0; h < levelSelect.length; h++) {
                        strTable += "<td class=\"title_tbl\" colspan=\"2\" style=\"background-color: #EEE\">" + getLevelName(Long.valueOf(levelSelect[h])) + "</td>";
                    }
                    strTable += "<td class=\"title_tbl\" colspan=\"2\" style=\"background-color: #EEE\">Total</td>";
                }
                strTable += "</tr>";
                
                strTable += "<tr>";
                if (levelSelect != null) {
                    for (int j = 0; j < levelSelect.length; j++) {
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">L</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">P</td>";
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">L</td>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">P</td>";
                }
                strTable += "</tr>";
                
                if (levelSelect != null) {
                    int arrTotalM[][] = new int [divisionSelect.length][levelSelect.length];
                    int arrTotalW[][] = new int [divisionSelect.length][levelSelect.length];
                    int arrTotalAllM[] = new int [divisionSelect.length];
                    int arrTotalAllW[] = new int [divisionSelect.length];
                    int totRowM = 0; 
                    int totRowW = 0;
                    if (divisionSelect != null) {
                        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SEX] + "=0";
                        whereClause += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo + "'";
                        Vector dataNoResignM = getEmployeeNoResign(whereClause, periodDate);
                        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SEX] + "=1";
                        whereClause += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " <= '" + dateTo + "'";
                        Vector dataNoResignW = getEmployeeNoResign(whereClause, periodDate);
                        for (int i = 0; i < divisionSelect.length; i++) {
                            no++;
                            strTable += "<tr>";
                            strTable += "<td>" + no + "</td>";
                            strTable += "<td>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                            ////////////////////
                            if (levelSelect != null) {
                                int total1 = 0;
                                int total2 = 0;
                                for (int h = 0; h < levelSelect.length; h++) {
                                    String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                    where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + "=" + levelSelect[h];
                                    int total = getDataCareerPath(dataNoResignM, where, dateFrom, dateTo);
                                    total1 = total1 + total;
                                    arrTotalM[i][h] = total;
                                    strTable += "<td>" + total + "</td>";
                                    where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                    where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + "=" + levelSelect[h];
                                    total = getDataCareerPath(dataNoResignW, where, dateFrom, dateTo);
                                    total2 = total2 + total;
                                    arrTotalW[i][h] = total;
                                    strTable += "<td>" + total + "</td>";
                                }
                                arrTotalAllM[i] = total1;
                                arrTotalAllW[i] = total2;
                                strTable += "<td>" + total1 + "</td>";
                                strTable += "<td>" + total2 + "</td>";
                            }
                            ////////////////////
                            strTable += "</tr>";
                        }
                        strTable += "<tr>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                        if (levelSelect != null) {
                            for(int k=0; k<levelSelect.length; k++){
                                for(int l=0; l<divisionSelect.length; l++){
                                    totRowM = totRowM + arrTotalM[l][k];
                                    totRowW = totRowW + arrTotalW[l][k];
                                }
                                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totRowM+"</td>";
                                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totRowW+"</td>";
                                totRowM = 0;
                                totRowW = 0;
                            }
                        }
                        int totAllM = 0;
                        int totAllW = 0;
                        if (divisionSelect != null){
                            for(int m=0; m<divisionSelect.length; m++){
                                totAllM = totAllM + arrTotalAllM[m];
                                totAllW = totAllW + arrTotalAllW[m];
                            }
                        }
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totAllM+"</td>";
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totAllW+"</td>";
                        strTable += "</tr>";
                    }
                }
                strTable += "</table>";
                break;
            case 1:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">Divisi / Satuan Kerja</td>";
                /* Get Education Data */
                Vector listEdu = PstEducation.list(0, 0, "", "");
                no = 0;
                if (categorySelect != null) {
                    for (int h = 0; h < categorySelect.length; h++) {
                        strTable += "<td colspan=\"" + listEdu.size() + "\" class=\"title_tbl\" style=\"background-color: #EEE\">" + getEmpCategory(Long.valueOf(categorySelect[h])) + "</td>";
                    }
                    strTable += "<td rowspan=\"2\" class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                    strTable += "</tr>";
                    strTable += "<tr>";
                    for (int i = 0; i < categorySelect.length; i++) {
                        if (listEdu != null && listEdu.size() > 0) {
                            for (int e = 0; e < listEdu.size(); e++) {
                                Education edu = (Education) listEdu.get(e);
                                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">" + edu.getEducation() + "</td>";
                            }
                        }
                    }
                }
                strTable += "</tr>";
                int arrTotCat[][] = new int[divisionSelect.length][categorySelect.length];
                int arrAllCat[] = new int[divisionSelect.length];
                if (divisionSelect != null) {
                    String empl = "";
                    Vector vEmp = new Vector();
                    for (int i = 0; i < divisionSelect.length; i++) {
                        no++;
                        int totalKategori = 0;
                        strTable += "<tr>";
                        strTable += "<td>" + no + "</td>";
                        strTable += "<td>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                        ////////////////////
                        if (categorySelect != null) {
                            int totalAll = 0;
                            for (int h = 0; h < categorySelect.length; h++) {
                                /* cari data employee berdasarkan divisi dan kategori */
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + "=" + categorySelect[h];
                                //Vector<String> dataEmpIds = getDataEmployeeId(dataNoResign, where, year + "-" + month + "-01");
                                Vector<String> dataEmpIds = getDataEmployeeCareer(dataNoResign, where, dateFrom, dateTo);
                                Vector<Long> vEmpEdu = new Vector<Long>();
                                /* data karyawan berdasarkan divisi dan kategori didapat */
                                if (dataEmpIds != null && dataEmpIds.size() > 0) {
                                    totalKategori = dataEmpIds.size();
                                    for (int em = 0; em < dataEmpIds.size(); em++) {
                                        String dataEmpId = (String) dataEmpIds.get(em);
                                        String whereEmpEdu = " EMPLOYEE_ID=" + dataEmpId;
                                        Vector listEmpEdu = PstEmpEducation.list(0, 1, whereEmpEdu, "START_DATE DESC");
                                        if (listEmpEdu != null && listEmpEdu.size() > 0) {
                                            EmpEducation empEdu = (EmpEducation) listEmpEdu.get(0);
                                            vEmpEdu.add(empEdu.getEducationId());
                                            vEmp.add(dataEmpId);
                                        }
                                    }
                                    totalAll = totalAll + totalKategori;
                                    arrTotCat[i][h] = totalKategori;
                                    arrAllCat[i] = totalAll;
                                }
                                int total = 0;

                                if (listEdu != null && listEdu.size() > 0) {
                                    for (int e = 0; e < listEdu.size(); e++) {
                                        Education edu = (Education) listEdu.get(e);

                                        for (int v = 0; v < vEmpEdu.size(); v++) {
                                            Long dEmpEdu = (Long) vEmpEdu.get(v);
                                            String strEmp = (String)vEmp.get(v);
                                            if (edu.getOID() == dEmpEdu) {
                                                total++;
                                                empl = empl + strEmp + "<br>";
                                            }
                                        }
                                        strTable += "<td>" + total + "</td>";
                                        total = 0;
                                        empl = "";
                                    }
                                }
                            }
                            strTable += "<td>" + totalAll + "</td>";
                        }
                        ////////////////////
                        strTable += "</tr>";
                    }
                    strTable += "<tr>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                    int totRow = 0;
                    int totRowCol = 0;
                    for (int c = 0; c < categorySelect.length; c++) {
                        for(int d=0; d < divisionSelect.length; d++){
                            totRow = totRow + arrTotCat[d][c];
                        }
                        strTable += "<td colspan=\"" + listEdu.size() + "\" class=\"title_tbl\" style=\"background-color: #EEE\">" + totRow + "</td>";
                        totRow = 0;
                    }
                    for (int n=0; n<divisionSelect.length; n++){
                        totRowCol = totRowCol + arrAllCat[n];
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">" + totRowCol + "</td>";
                    strTable += "</tr>";
                }
                strTable += "</table>";
                break;
            case 2:
                strTable = "<table class=\"tblStyle\">";
                strTable += "<tr>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">No</td>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Divisi / Satuan Kerja</td>";

                if (positionSelect != null) {
                    for (int h = 0; h < positionSelect.length; h++) {
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">" + getPositionName(Long.valueOf(positionSelect[h])) + "</td>";
                    }
                    strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                }
                strTable += "</tr>";
                int arrTotal[][] = new int [divisionSelect.length][positionSelect.length];
                int arrTotalAll [] = new int [divisionSelect.length];
                int totalRow = 0;
                int totalRowCol = 0;
                if (divisionSelect != null) {
                    no = 0;
                    for (int i = 0; i < divisionSelect.length; i++) {
                        no++;
                        strTable += "<tr>";
                        strTable += "<td>" + no + "</td>";
                        strTable += "<td>" + getDivisionName(Long.valueOf(divisionSelect[i])) + "</td>";
                        if (positionSelect != null) {
                            int totalAll = 0;
                            for (int h = 0; h < positionSelect.length; h++) {
                                String where = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + "=" + divisionSelect[i];
                                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + positionSelect[h];
                                int total = getDataCareerPath(dataNoResign, where, dateFrom, dateTo);
                                arrTotal[i][h] = total;
                                totalAll = totalAll + total;
                                strTable += "<td>" + total + "</td>";
                            }
                            arrTotalAll[i] = totalAll;
                            strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">" + totalAll + "</td>";
                        }
                        strTable += "</tr>";
                        totalRowCol = totalRowCol + arrTotalAll[i];
                    }
                }
                strTable += "<tr>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">&nbsp;</td>";
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">Total</td>";
                
                if (positionSelect != null) {
                    for (int h = 0; h < positionSelect.length; h++) {
                        for(int i=0; i < divisionSelect.length; i++){
                            totalRow = totalRow + arrTotal[i][h];
                        }
                        strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totalRow+"</td>";
                        totalRow = 0;
                    }
                }
                strTable += "<td class=\"title_tbl\" style=\"background-color: #EEE\">"+totalRowCol+"</td>";
                strTable += "</tr>";
                strTable += "</table>";
                break;
        }
        return strTable;
    }
    
    public Vector getEmployeeNoResign(String whereClause, int periodDate){
        Vector dataBruto = new Vector();
        Vector hasilCekResign = new Vector();
        /* Tahap 1 */
        dataBruto = getEmployeeData(whereClause);
        /* Tahap 2 */
        if (dataBruto != null && dataBruto.size()>0){
            int resignDate = 0;
            for (int i=0; i<dataBruto.size(); i++){
                Employee emp = (Employee)dataBruto.get(i);
                emp.getResignedDate();
                if (emp.getResignedDate() != null){ /* RESIGN_DATE != 0000-00-00 */

                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String stringDate = sdf.format(emp.getResignedDate());
                        String yearR = stringDate.substring(0, 4);  
                        String mountR = stringDate.substring(5, 7);
                        String tglR = stringDate.substring(8, 10);
                        resignDate = Integer.valueOf(yearR+mountR+tglR);
                        if (resignDate > periodDate){
                           hasilCekResign.add(emp); 
                        }
                    } catch(Exception e){
                        System.out.println("getAmount [resigndate]=>"+e.toString());
                    }

                } else {
                    hasilCekResign.add(emp);
                } 
            }
        }
        return hasilCekResign;
    }
    
    public int getDataCareerPath(Vector dataNoResign, String whereClause, String dateFrom, String dateTo){
        int amount = 0;
        //String listEmp = "";
        Vector empOnCareer = new Vector();
        String[] arrDFrom = dateFrom.split("-");
        String[] arrDTo = dateTo.split("-");
        int intDateFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
        int intDateTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
        if (dataNoResign != null && dataNoResign.size()>0){
            String whereIn = "";
            for(int i=0; i<dataNoResign.size(); i++){
                Employee employee = (Employee)dataNoResign.get(i);
                whereIn += employee.getOID()+",";
            }
            whereIn += "0";
            String where = whereClause;
            //where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+dateFrom+"'";
           // where += " AND '"+dateTo+"'";
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector listCareer = PstCareerPath.list(0, 0, where, "");

            if (listCareer != null && listCareer.size()>0){
                for (int i=0; i<listCareer.size(); i++){
                    CareerPath career = (CareerPath)listCareer.get(i);
                    String startDate = ""+career.getWorkFrom();
                    String endDate = ""+career.getWorkTo();
                    String[] arrStartDate = startDate.split("-");
                    String[] arrEndDate = endDate.split("-");
                    int intStartDate = Integer.valueOf(arrStartDate[0] + arrStartDate[1] + arrStartDate[2]);
                    int intEndDate = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
                    if (intStartDate >= intDateFrom){
                        amount = amount + 1;
                        //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                        empOnCareer.add(career.getEmployeeId());
                    } else {
                        if (intEndDate >= intDateFrom){
                            amount = amount + 1;
                            //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                            empOnCareer.add(career.getEmployeeId());
                        }
                    }
                }
                //amount = amount + careerPath.size();
            }
            /* manipulasi whereIn */
            if (empOnCareer != null && empOnCareer.size()>0){
                for (int j=0; j<empOnCareer.size(); j++){
                    Long empId = (Long)empOnCareer.get(j);
                    String oldChar = ""+empId;
                    whereIn = whereIn.replace(oldChar, "0");
                }
            }

            where = whereClause + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector empData = getEmployeeData(where);
            if (empData != null && empData.size()>0){
                for (int i=0; i<empData.size(); i++){
                    Employee emp = (Employee)empData.get(i);
                    /* cek Work From */
                    int workFrom = getWorkFromEmployee(emp.getOID());
                    if (workFrom >= intDateFrom){
                        if (workFrom <= intDateTo){
                            amount = amount + 1;
                        }
                        //listEmp += "<div>FE: "+emp.getOID()+"</div>";
                    } else {
                        /* Date NOW (Current) */
                        amount = amount + 1;
                        //listEmp += "<div>FE: "+emp.getOID()+"</div>";
                    }
                }
            }
        }
        return amount;
    }
    
    public String getEmpCareerPath(Vector dataNoResign, String whereClause, String dateFrom, String dateTo){
        int amount = 0;
        ChangeValue changeValue = new ChangeValue();
        String output = "";
        //String listEmp = "";
        Vector empOnCareer = new Vector();
        String[] arrDFrom = dateFrom.split("-");
        String[] arrDTo = dateTo.split("-");
        int intDateFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
        int intDateTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
        if (dataNoResign != null && dataNoResign.size()>0){
            String whereIn = "";
            for(int i=0; i<dataNoResign.size(); i++){
                Employee employee = (Employee)dataNoResign.get(i);
                whereIn += employee.getOID()+",";
            }
            whereIn += "0";
            String where = whereClause;
            //where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+dateFrom+"'";
           // where += " AND '"+dateTo+"'";
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector listCareer = PstCareerPath.list(0, 0, where, "");

            if (listCareer != null && listCareer.size()>0){
                for (int i=0; i<listCareer.size(); i++){
                    CareerPath career = (CareerPath)listCareer.get(i);
                    String startDate = ""+career.getWorkFrom();
                    String endDate = ""+career.getWorkTo();
                    String[] arrStartDate = startDate.split("-");
                    String[] arrEndDate = endDate.split("-");
                    int intStartDate = Integer.valueOf(arrStartDate[0] + arrStartDate[1] + arrStartDate[2]);
                    int intEndDate = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
                    if (intStartDate >= intDateFrom){
                        amount = amount + 1;
                        //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                        output += "<div class=\"item\">"+infoEmp(career.getEmployeeId())+"</div>";
                        empOnCareer.add(career.getEmployeeId());
                    } else {
                        if (intEndDate >= intDateFrom){
                            amount = amount + 1;
                            //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                            output += "<div class=\"item\">"+infoEmp(career.getEmployeeId())+"</div>";
                            empOnCareer.add(career.getEmployeeId());
                        }
                    }
                }
                //amount = amount + careerPath.size();
            }
            /* manipulasi whereIn */
            if (empOnCareer != null && empOnCareer.size()>0){
                for (int j=0; j<empOnCareer.size(); j++){
                    Long empId = (Long)empOnCareer.get(j);
                    String oldChar = ""+empId;
                    whereIn = whereIn.replace(oldChar, "0");
                }
            }

            where = whereClause + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector empData = getEmployeeData(where);
            if (empData != null && empData.size()>0){
                for (int i=0; i<empData.size(); i++){
                    Employee emp = (Employee)empData.get(i);
                    /* cek Work From */
                    int workFrom = getWorkFromEmployee(emp.getOID());
                    if (workFrom >= intDateFrom){
                        if (workFrom <= intDateTo){
                            amount = amount + 1;
                        }
                        //listEmp += "<div>FE: "+emp.getOID()+"</div>";
                        output += "<div class=\"item\">"+infoEmp(emp.getOID())+"</div>";
                    } else {
                        /* Date NOW (Current) */
                        amount = amount + 1;
                        //listEmp += "<div>FE: "+emp.getOID()+"</div>";
                        output += "<div class=\"item\">"+infoEmp(emp.getOID())+"</div>";
                    }
                }
            }
        }
        return output;
    }
    
    public String infoEmp(long employeeId){
        String output = "";
        try {
            Employee emp = PstEmployee.fetchExc(employeeId);
            output = emp.getFullName()+" ("+emp.getEmployeeNum()+")";
        } catch(Exception e){
            System.out.print(""+e.toString());
        }
        return output;
    }
    
    public int getWorkFromEmployee(long employeeId){
        int intWorkFrom = 0;
        String where = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId;
        String order = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" DESC";
        Vector listCareer = PstCareerPath.list(0, 1, where, order);
        if (listCareer != null && listCareer.size()>0){
            CareerPath career = (CareerPath)listCareer.get(0);
             /* Get the next Date */
            String nextDate = "-";
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); /*new SimpleDateFormat("dd MMMM yyyy");*/
                Calendar c = Calendar.getInstance();
                c.setTime(career.getWorkTo());
                c.add(Calendar.DATE, 1);  // number of days to add
                nextDate = sdf.format(c.getTime());  // dt is now the new date
                String[] arrEndDate = nextDate.split("-");
                intWorkFrom = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
            } catch(Exception e){
                System.out.println("Date=>"+e.toString());
            }
            
        } else {
            /* get Commencing date */
            try {
                Employee emp = PstEmployee.fetchExc(employeeId);
                String endDate = ""+emp.getCommencingDate();
                String[] arrEndDate = endDate.split("-");
                intWorkFrom = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
            } catch(Exception e){
                System.out.println(e.toString());
            }
        }
        return intWorkFrom;
    }
    
    public Vector<String> getDataEmployeeId(Vector dataNoResign, String whereClause, String period){
        Vector<String> dataEmployeeIds = new Vector<String>();
        if (dataNoResign != null && dataNoResign.size()>0){
            String whereIn = "";
            for(int i=0; i<dataNoResign.size(); i++){
                Employee employee = (Employee)dataNoResign.get(i);
                whereIn += employee.getOID()+",";
            }
            whereIn += "0";
            String where = whereClause;
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" <= '"+period+"'";
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector careerPath = PstCareerPath.list(0, 0, where, "");
            if (careerPath != null && careerPath.size()>0){
                for(int i=0; i<careerPath.size(); i++){
                    CareerPath path = (CareerPath)careerPath.get(i);
                    dataEmployeeIds.add(""+path.getEmployeeId());
                }
            }
            where = whereClause + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector empData = getEmployeeData(where);
            if (empData != null && empData.size()>0){
                for(int i=0; i<empData.size(); i++){
                    Employee emp = (Employee)empData.get(i);
                    dataEmployeeIds.add(""+emp.getOID());
                }
            }
        }
        return dataEmployeeIds;
    }
    
    public Vector<String> getDataEmployeeCareer(Vector dataNoResign, String whereClause, String dateFrom, String dateTo){
        int amount = 0;
        Vector<String> dataEmployeeIds = new Vector<String>();
        Vector empOnCareer = new Vector();
        String[] arrDFrom = dateFrom.split("-");
        String[] arrDTo = dateTo.split("-");
        int intDateFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
        int intDateTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
        if (dataNoResign != null && dataNoResign.size()>0){
            String whereIn = "";
            for(int i=0; i<dataNoResign.size(); i++){
                Employee employee = (Employee)dataNoResign.get(i);
                whereIn += employee.getOID()+",";
            }
            whereIn += "0";
            String where = whereClause;
            //where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+dateFrom+"'";
           // where += " AND '"+dateTo+"'";
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector listCareer = PstCareerPath.list(0, 0, where, "");

            if (listCareer != null && listCareer.size()>0){
                for (int i=0; i<listCareer.size(); i++){
                    CareerPath career = (CareerPath)listCareer.get(i);
					if (i==1215){
						System.out.println(i);
					}
                    String startDate = ""+career.getWorkFrom();
                    String endDate = ""+(career.getWorkTo() != null ? career.getWorkTo() : Formater.formatDate(new java.util.Date(), "yyyy-MM-dd"));
                    String[] arrStartDate = startDate.split("-");
                    String[] arrEndDate = endDate.split("-");
                    int intStartDate = Integer.valueOf(arrStartDate[0] + arrStartDate[1] + arrStartDate[2]);
                    int intEndDate = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
                    if (intStartDate >= intDateFrom){
                        amount = amount + 1;
                        //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                        empOnCareer.add(career.getEmployeeId());
                        dataEmployeeIds.add(""+career.getEmployeeId());
                    } else {
                        if (intEndDate >= intDateFrom){
                            amount = amount + 1;
                            //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                            empOnCareer.add(career.getEmployeeId());
                            dataEmployeeIds.add(""+career.getEmployeeId());
                        }
                    }
                }
                //amount = amount + careerPath.size();
            }
            /* manipulasi whereIn */
            if (empOnCareer != null && empOnCareer.size()>0){
                for (int j=0; j<empOnCareer.size(); j++){
                    Long empId = (Long)empOnCareer.get(j);
                    String oldChar = ""+empId;
                    whereIn = whereIn.replace(oldChar, "0");
                }
            }

            where = whereClause + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector empData = getEmployeeData(where);
            if (empData != null && empData.size()>0){
                for (int i=0; i<empData.size(); i++){
                    Employee emp = (Employee)empData.get(i);
                    /* cek Work From */
                    int workFrom = getWorkFromEmployee(emp.getOID());
                    if (workFrom >= intDateFrom){
                        if (workFrom <= intDateTo){
                            amount = amount + 1;
                            dataEmployeeIds.add(""+emp.getOID());
                        }
                    } else {
                        /* Date NOW (Current) */
                        amount = amount + 1;
                        dataEmployeeIds.add(""+emp.getOID());
                    }
                }
            }
        }
        return dataEmployeeIds;
    }
    
    public static Vector getEmployeeData(String whereClause){
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = " SELECT * FROM "+PstEmployee.TBL_HR_EMPLOYEE;
            sql += " WHERE ";            
            sql += whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                list.add(employee);
            }

            rs.close();
            return list;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return list;
    }
    
    public String getDivisionName(long divisionId){
        String name = "-";
        if (divisionId != 0) {
            try {
                Division division = PstDivision.fetchExc(divisionId);
                name = division.getDivision();
            } catch (Exception e) {
                System.out.println("Division Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public String getEmpCategory(long empCategoryId){
        String name = "-";
        if (empCategoryId != 0){
            try {
                EmpCategory empCategory = PstEmpCategory.fetchExc(empCategoryId);
                name = empCategory.getEmpCategory();
            } catch (Exception e){
                System.out.println("Category Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public String getPositionName(long positionId){
        String name = "-";
        if (positionId != 0){
             try {
                Position position = PstPosition.fetchExc(positionId);
                name = position.getPosition();
            } catch (Exception e) {
                System.out.println("Position Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public String getLevelName(long levelId){
        String name = "-";
        if (levelId != 0){
            try {
                Level level = PstLevel.fetchExc(levelId);
                name = level.getLevel();
            } catch (Exception e) {
                System.out.println("Level Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public static int getTotalEmployeeByPosition(String whereClause){
        DBResultSet dbrs = null;

        try {
            String sql = " SELECT COUNT("+PstEmployee.TBL_HR_EMPLOYEE+"."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+") AS total_employee ";
            sql += " FROM "+PstEmployee.TBL_HR_EMPLOYEE+" ";
            sql += " WHERE ";            
            sql += whereClause;

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
    
    public static int getTotalEmpEducation(String whereClause){
        DBResultSet dbrs = null;

        try {
            String sql = " SELECT COUNT("+PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMP_EDUCATION_ID]+") AS total_emp_edu";
            sql += " FROM "+PstEmpEducation.TBL_HR_EMP_EDUCATION+" ";
            sql += " WHERE ";            
            sql += whereClause;

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
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Short description";
    }

    /**
     * @return the payroll
     */
    public String getPayroll() {
        return payroll;
    }

    /**
     * @param payroll the payroll to set
     */
    public void setPayroll(String payroll) {
        this.payroll = payroll;
    }
    
    public double getValuemapping(String fromdate, String todate, String employeeId, String salaryComp) {
        DBResultSet dbrs = null;
        double nilai = 0;
        String test = "";
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(Long.valueOf(employeeId));
        } catch (Exception e) {
        }
        try {
            String sql = " SELECT * FROM " + PstValue_Mapping.TBL_VALUE_MAPPING + " WHERE "
                    + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMP_CODE] + " = \"" + salaryComp + "\" "
                    + " AND ((" + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_END_DATE]
                    + " >= \"" + fromdate+" 00:00:00" + "\") OR (END_DATE = \"0000-00-00  00:00:00\")  OR ( END_DATE IS NULL ) )";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                // Employee employee = PstEmployee.fetchExc(employeeId);

                long VmCompanyId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                long VmDivisionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                long VmDepartmentId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                long VmSectionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                long VmLevelId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                long VmMaritalId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_MARITAL_ID]);
                double VmLengthOfService = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LENGTH_OF_SERVICE]);
                long VmEmpCategoryId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                long VmPositionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                long VmEmployeeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_ID]);
                double VmValue = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_VALUE]);
                long VmGradeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                int VmSex = rs.getInt(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SEX]);

                java.util.Date today = new java.util.Date();
                boolean nilaitf = true;
                /* melakukan perbandingan ke object Employee */
                if ((VmCompanyId != 0) && (VmCompanyId > 0)) {
                    if (VmCompanyId != employee.getCompanyId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                        setValueKey(""+VmCompanyId);
                    }
                }

                if ((VmDivisionId != 0) && (VmDivisionId > 0)) {
                    if (VmDivisionId != employee.getDivisionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                        setValueKey(""+VmDivisionId);
                    }
                }
                if ((VmDepartmentId != 0) && (VmDepartmentId > 0)) {
                    if (VmDepartmentId != employee.getDepartmentId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                        setValueKey(""+VmDepartmentId);
                    }
                }
                if ((VmSectionId != 0) && (VmSectionId > 0)) {
                    if (VmSectionId != employee.getSectionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                        setValueKey(""+VmSectionId);
                    }
                }
                if ((VmPositionId != 0) && (VmPositionId > 0)) {
                    if (VmPositionId != employee.getPositionId()) {
                        nilaitf = false;
                    } else { 
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                        setValueKey(""+VmPositionId);
                    }
                }
                if ((VmGradeId != 0) && (VmGradeId > 0)) {
                    if (VmGradeId != employee.getGradeLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                        setValueKey(""+VmGradeId);
                    }
                }
                if ((VmEmpCategoryId != 0) && (VmEmpCategoryId > 0)) {
                    if (VmEmpCategoryId != employee.getEmpCategoryId()) {
                        nilaitf = false;
                    } else { 
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                        setValueKey(""+VmEmpCategoryId);
                    }
                }
                if ((VmLevelId != 0) && (VmLevelId > 0)) {
                    if (VmLevelId != employee.getLevelId()) {
                        nilaitf = false;
                    } else { 
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                        setValueKey(""+VmLevelId);
                    }
                }
                if ((VmMaritalId != 0) && (VmMaritalId > 0)) {
                    if (VmMaritalId != employee.getMaritalId()) {
                        nilaitf = false;
                    }
                }
                if ((VmEmployeeId != 0) && (VmEmployeeId > 0)) {
                    if (VmEmployeeId != employee.getOID()) {
                        nilaitf = false;
                    }
                }

                if ((VmSex != -1) && (VmSex > -1)) {
                    if (VmSex != employee.getSex()) {
                        nilaitf = false;
                    }
                }


                if ((VmLengthOfService != 0) && (VmLengthOfService > 0)) {
                    double diff = today.getTime() - employee.getCommencingDate().getTime();
                    double yeardiff = diff / (1000 * 60 * 60 * 24 * 365);
                    if ((yeardiff != VmLengthOfService) || (yeardiff < VmLengthOfService)) {
                        nilaitf = false;
                    }
                }
                /* End melakukan perbandingan ke object Employee// */
                if (nilaitf) {
                    nilai = VmValue;
                }                
            }
            //rs.close();
            return nilai;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }
    
    public long getCareerOid(String periodFrom, String employeeId){
        boolean math = false;
        long oidCareer = 0;
        String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId;
        Vector listCareer = PstCareerPath.list(0, 0, whereClause, "");
        if (listCareer != null && listCareer.size()>0){
            for(int i=0; i<listCareer.size(); i++){
                CareerPath career = (CareerPath)listCareer.get(i);
                Vector listRangeDate = getRangeOfDate("" + career.getWorkFrom(), "" + career.getWorkTo());
                if (listRangeDate != null && listRangeDate.size() > 0) {
                    for (int r = 0; r < listRangeDate.size(); r++) {
                        String rDate = (String) listRangeDate.get(r);
                        if (rDate.equals(periodFrom)) {
                            math = true;
                            oidCareer = career.getOID();
                        }
                    }
                }
            }
        }
        return oidCareer;
    }
    
    public void setListCareer(Vector data){
        this.listCareer = data;
    }
    public Vector getListCareer(){
        return this.listCareer;
    }
    
    /* Function for value Mapping Process */
    public String getDigit(int val){
        String str = "";
        String nilai = String.valueOf(val);
        if (nilai.length() == 1){
            str = "0"+nilai;
        } else {
            str = nilai;
        }
        return str;
    }
    
    /**
     * getRangeOfDate :
     * mencari rentangan tanggal dari start date to end date.
     * misal :
     * start date = 2015-09-09 To 2015-09-13, maka hasilnya::
     * 2015-09-09, 2015-09-10, 2015-09-11, 2015-09-12, 2015-09-13
     */
    public Vector<String> getRangeOfDate(String startDate, String endDate) {
        Vector<String> rangeDate = new Vector<String>();
        String[] arrStart = startDate.split("-");
        String[] arrEnd = endDate.split("-");

        int yearStart = Integer.valueOf(arrStart[0]);	
        int monthStart = Integer.valueOf(arrStart[1]);
        int dayStart = Integer.valueOf(arrStart[2]);	

        int yearEnd = Integer.valueOf(arrEnd[0]);	
        int monthEnd = Integer.valueOf(arrEnd[1]);	
        int dayEnd = Integer.valueOf(arrEnd[2]);	

        String tanggal = "";
        if (yearStart != yearEnd) {
            for (int y = yearStart; y <= yearEnd; y++) {
                if (y < yearEnd){ // 2014-01-01 AND 2016-01-01 (2014-01-01, 2015-01-01, 2016-05-01)
                    if (monthStart == 1){
                        for(int m=1; m<=12; m++){
                            if (dayStart == 1){
                                for (int d = 1; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                for (int d = dayStart; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                                dayStart = 1;
                            }
                        }
                    } else {
                        for(int m=monthStart; m<=12; m++){
                            if (dayStart == 1){
                                for (int d = 1; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                for (int d = dayStart; d <= 31; d++) {
                                    tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                                dayStart = 1;
                            }
                        }
                        monthStart = 1;
                    }
                } else {
                    if (monthStart == monthEnd) {
                        if (dayStart == dayEnd) {
                            tanggal = y + "-" + getDigit(monthStart) + "-" + getDigit(dayStart);
                            rangeDate.add(tanggal);
                        } else {
                            if (dayStart < dayEnd) {
                                for (int d = dayStart; d <= dayEnd; d++) {
                                    tanggal = y + "-" + getDigit(monthStart) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            }
                        }
                    } else {
                        if (monthStart < monthEnd){ // 2015-01-01 AND 2015-02-05
                            for(int m=monthStart; m<=monthEnd; m++){
                                if (m < monthEnd){
                                    if (dayStart == 1){
                                        for(int d=1; d<=31; d++){
                                            tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                            rangeDate.add(tanggal);
                                        }
                                    } else {
                                        if (dayStart > 1){
                                            for(int d=dayStart; d<=31; d++){
                                                tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                                rangeDate.add(tanggal);
                                            }
                                        }
                                    }
                                } else {
                                    for(int d=1; d<=dayEnd; d++){
                                        tanggal = y + "-" + getDigit(m) + "-" + getDigit(d);
                                        rangeDate.add(tanggal);
                                    }
                                }

                            }
                        } 
                    }
                }
            }
        } else {
            if (monthStart == monthEnd) {
                if (dayStart == dayEnd) {
                    tanggal = yearStart + "-" + getDigit(monthStart) + "-" + getDigit(dayStart);
                    rangeDate.add(tanggal);
                } else {
                    if (dayStart < dayEnd) {
                        for (int d = dayStart; d <= dayEnd; d++) {
                            tanggal = yearStart + "-" + getDigit(monthStart) + "-" + getDigit(d);
                            rangeDate.add(tanggal);
                        }
                    }
                }
            } else {
                if (monthStart < monthEnd){ // 2015-01-01 AND 2015-02-05
                    for(int m=monthStart; m<=monthEnd; m++){
                        if (m < monthEnd){
                            if (dayStart == 1){
                                for(int d=1; d<=31; d++){
                                    tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                    rangeDate.add(tanggal);
                                }
                            } else {
                                if (dayStart > 1){
                                    for(int d=dayStart; d<=31; d++){
                                        tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                        rangeDate.add(tanggal);
                                    }
                                }
                            }
                        } else {
                            for(int d=1; d<=dayEnd; d++){
                                tanggal = yearStart + "-" + getDigit(m) + "-" + getDigit(d);
                                rangeDate.add(tanggal);
                            }
                        }
                        
                    }
                } 
            }
        }

        return rangeDate;
    }
    
    
    public Vector<String> getRangeOfDateCalendar(String startDate, String endDate) throws ParseException {
        Vector rangeDate = new Vector();
        String tanggal = "";
        
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        
        java.util.Date fromDate = (java.util.Date) format.parse(startDate);
        java.util.Date toDate = (java.util.Date) format.parse(endDate);
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(fromDate);
        tanggal = format.format(cal.getTime());
        rangeDate.add(tanggal);
        while (cal.getTime().before(toDate)){
            cal.add(Calendar.DATE, 1);
            tanggal = format.format(cal.getTime());
            rangeDate.add(tanggal);
        }
        
        return rangeDate;
    }

    /**
     * @return the testData
     */
    public String getTestData() {
        return testData;
    }

    /**
     * @param testData the testData to set
     */
    public void setTestData(String testData) {
        this.testData = testData;
    }

    /**
     * @return the fieldKey
     */
    public String getFieldKey() {
        return fieldKey;
    }

    /**
     * @param fieldKey the fieldKey to set
     */
    public void setFieldKey(String fieldKey) {
        this.fieldKey = fieldKey;
    }

    /**
     * @return the valueKey
     */
    public String getValueKey() {
        return valueKey;
    }

    /**
     * @param valueKey the valueKey to set
     */
    public void setValueKey(String valueKey) {
        this.valueKey = valueKey;
    }
    
    /* Update new get Data with career path - 2016-08-03 */
    public Vector getDataEmpWithCareer(String whereClause, String dateFrom, String dateTo, long divisionId, long positionId) {
        Vector employeeList = new Vector();
        String[] arrDFrom = dateFrom.split("-");
        String[] arrDTo = dateTo.split("-");
        boolean ketemu = false;
        int intPeriodFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
        int intPeriodTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
        String strBiner = "";
        int[] biner = new int[8];
        whereClause += " AND " + PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP] + "=" + PstCareerPath.RIWAYAT_JABATAN;
        String orderBy = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];
        Vector listCareer = PstCareerPath.list(0, 0, whereClause, orderBy);
        if (listCareer != null && listCareer.size() > 0) {
            for (int c = 0; c < listCareer.size(); c++) {
                CareerPath career = (CareerPath) listCareer.get(c);
                String workFrom = "" + career.getWorkFrom();
                String workTo = "" + career.getWorkTo();
                String[] arrWorkFrom = workFrom.split("-");
                String[] arrWorkTo = workTo.split("-");
                int intWorkFrom = Integer.valueOf(arrWorkFrom[0] + arrWorkFrom[1] + arrWorkFrom[2]);
                int intWorkTo = Integer.valueOf(arrWorkTo[0] + arrWorkTo[1] + arrWorkTo[2]);
                for (int b = 0; b < biner.length; b++) {
                    biner[b] = 0;
}
                strBiner = "";
                if (intWorkFrom >= intPeriodFrom) {
                    biner[0] = 1;
                } else { /* intWorkFrom < intPeriodFrom */
                    biner[1] = 1;
                }
                if (intWorkFrom >= intPeriodTo) {
                    biner[2] = 1;
                } else { /* intWorkFrom < intPeriodTo */
                    biner[3] = 1;
                }

                if (intWorkTo >= intPeriodFrom) {
                    biner[4] = 1;
                } else { /* intWorkTo < intPeriodFrom */
                    biner[5] = 1;
                }
                if (intWorkTo >= intPeriodTo) {
                    biner[6] = 1;
                } else { /* intWorkTo < intPeriodTo */
                    biner[7] = 1;
                }

                for (int b = 0; b < biner.length; b++) {
                    strBiner = strBiner + biner[b];
                }
                if (strBiner.equals("10011001")) {
                    /*
                     * Pf ===================== Pt
                     *      Sd =========== Ed
                     */
                    employeeList.add(career.getEmployeeId());
                    ketemu = true;
                    break;
                }
                if (strBiner.equals("01011010")) {
                    /*
                     *      Pf ======= Pt
                     * Sd ================== Ed
                     */
                    employeeList.add(career.getEmployeeId());
                    ketemu = true;
                    break;
                }
                if (strBiner.equals("10011010")) {
                    /* 
                     * Pf ================== Pt
                     *          Sd ================ Ed
                     */
                    employeeList.add(career.getEmployeeId());
                    ketemu = true;
                    break;
                }
                if (strBiner.equals("01011001")) {
                    /*
                     *          Pf ============ Pt
                     * Sd ============= Ed
                     */
                    employeeList.add(career.getEmployeeId());
                    ketemu = true;
                    break;
                }
                if (strBiner.equals("01010101")) {
                    /*
                     *              Pf ========== Pt
                     * Sd ===== Ed
                     */
                    //output = "<div>Kondisi ke-5:</div>";
                    //output += "<div>Cari ke databank</div>";
                    String where = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "=" + career.getEmployeeId();
                    Vector dataEmp = PstEmployee.list(0, 0, where, "");
                    if (dataEmp != null && dataEmp.size() > 0) {
                        Employee emp = (Employee) dataEmp.get(0);
                        if (positionId == emp.getPositionId()) {
                            employeeList.add(emp.getOID());
                            ketemu = true;
                        }
                    }

                }
                if (strBiner.equals("10101010")) {
                    /* 
                     * Pf ========== Pt
                     *                  Sd ========= Ed
                     */
                    ///output  = "<div>Kondisi ke-6:</div>";
                }
            }
        } 
        if (ketemu == false){
            String where = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + positionId;
            if (divisionId != 0){
                where += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+ "="+divisionId;
            }
            Vector dataEmp = PstEmployee.list(0, 0, where, "");
            if (dataEmp != null && dataEmp.size() > 0) {
                for (int e=0; e<dataEmp.size(); e++){
                    Employee emp = (Employee) dataEmp.get(e);
                    if (divisionId != 0) {
                        if (divisionId == emp.getDivisionId() && positionId == emp.getPositionId()) {
                            employeeList.add(emp.getOID());
                        }
                    } else {
                        if (positionId == emp.getPositionId()) {
                            employeeList.add(emp.getOID());
                        }
                    }
                }
            }
        }

        return employeeList;
    }
    
    public Employee dataEmployeeCheck(long employeeId){
        Employee emp = new Employee();
        try {
            emp = PstEmployee.fetchExc(employeeId);
        } catch(Exception e){
            System.out.print(""+e.toString());
        }
        return emp;
    }
    
}