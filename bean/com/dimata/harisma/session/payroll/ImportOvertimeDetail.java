/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.payroll;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.MappingPosition;
import com.dimata.harisma.entity.masterdata.PstMappingPosition;
import com.dimata.harisma.entity.overtime.Overtime;
import com.dimata.harisma.entity.overtime.OvertimeDetail;
import com.dimata.harisma.entity.overtime.PstOvertime;
import com.dimata.harisma.entity.overtime.PstOvertimeDetail;
import com.dimata.util.Formater;
import com.dimata.util.blob.TextLoader;
import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
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
 * @author mchen
 */
public class ImportOvertimeDetail {
    public static String drawImport(ServletConfig config, HttpServletRequest request, HttpServletResponse response, JspWriter output, long userId){
        String html = "";
        int NUM_HEADER = 2;
        int NUM_CELL = 0;
        
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch(Exception e){
            System.out.println("Get AppUser: userId");
        }

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
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            int errInsert = 0;
            for (int i = 0; i < numOfSheets; i++) {
                int r = 0;
                HSSFSheet sheet = (HSSFSheet) wb.getSheetAt(i);
                html += "<strong> Sheet name : " + sheet.getSheetName() + "</strong>";
                if (sheet == null || sheet.getSheetName() == null || sheet.getSheetName().length() < 1) {
                   html += " NOT MATCH : Period name and sheet name ";
                    continue;
                }
                    int rows = sheet.getPhysicalNumberOfRows();

                    // loop untuk row dimulai dari numHeaderRow (0, .. numHeaderRow diabaikan) => untuk yang bukan sheet pertaman
                    int start = (i == 0) ? 0 : NUM_HEADER;
                    String empNum = "";
                    html += "<table class=\"tblStyle\">";
                    String[][] dataDetail = new String[rows][7];
                    Vector overtimeCollect = new Vector();
                    long oidOvertime = 0;
                    String overtimeDate = "";
                    boolean checkOt = false;
                    int typeLembur = 0;
                    for (r = start; r < rows; r++) {
                        Employee employee = null;
                        OvertimeDetail overtimeDetail = new OvertimeDetail();
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
                            html += "<tr>";
                            int caseValue = 0;
                            int errCell = 0;
                            
                            boolean createForm = false;
                            
                            String startDate = "";
                            String startTime = "";
                            String endDate = "";
                            String endTime = "";
                            
                            for (int c = 0; c < cells; c++) {
                                HSSFCell cell = row.getCell((short) c);
                                String value = null;
                                boolean check = false;
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
                                    try {
                                        employee = PstEmployee.getEmployeeByNum(value);
                                        value = "("+ value + ") "+ employee.getFullName();
                                        overtimeDetail.setEmployeeId(employee.getOID());
                                        if (employee.getDivisionId() != emp.getDivisionId() && appUser.getAdminStatus() !=1){
                                            tdColor = "#DC143C;";
                                            errCell++;
                                        }
                                        //overtimeDetail.setOvertimeId(oidOvertime);
                                    } catch(Exception e){
                                        System.out.println("emp num is not available=>"+e.toString());
                                    }
                                    /* change color if nothing employee with emp num */
                                    if (employee == null || employee.getOID() == 0){
                                        tdColor = "#DC143C;";
                                        errCell++;
                                    }
                                }
                                
                                if (r > 0 && c == 2){ /* start date */
                                    check = isStringDate(""+value);
                                    if (check){
                                        startDate = value;
                                    } else {
                                        errCell++;
                                        tdColor = "#DC143C;";
                                    }
                                }
                                
                                if (r > 0 && c == 3){ /* start time */
                                    check = isStringTime(""+value);
                                    if (check){
                                        startTime = value;
                                    } else {
                                        errCell++;
                                        tdColor = "#DC143C;";
                                    }
                                }
                                if (startDate.length()>0 && startTime.length()>0){
                                    Date dateFrom = sdf.parse(startDate+" "+startTime);
                                    overtimeDetail.setDateFrom(dateFrom);
                                }
                                
                                if (r > 0 && c == 4){ /* end date */
                                    check = isStringDate(""+value);
                                    if (check){
                                        endDate = value;
                                    } else {
                                        errCell++;
                                    }
                                }
                                
                                if (r > 0 && c == 5){ /* end time */
                                    check = isStringTime(""+value);
                                    if (check){
                                        endTime = value;
                                    } else {
                                        errCell++;
                                        tdColor = "#DC143C;";
                                    }
                                }
                                if (endDate.length()>0 && endTime.length()>0){
                                    Date dateTo = sdf.parse(endDate+" "+endTime);
                                    overtimeDetail.setDateTo(dateTo);
                                }
                                
                                if (r > 0 && c == 6){ /* rest hour */
                                    double restTime = Double.valueOf(""+value);
                                    overtimeDetail.setRestTimeinHr(restTime);
                                    Date dateRest = sdf.parse(startDate+" 12:00");
                                    overtimeDetail.setRestStart(dateRest);
                                }
                                
                                if (r > 0 && c == 7){ /* description */
                                    overtimeDetail.setJobDesk(""+value);
                                }
                                
                                if (r > 0 && c == 8){ /* type */
                                    int type = 1;
                                    if(value.equalsIgnoreCase("Yes")){
                                        type= 0;
                                    }
                                    overtimeDetail.setNormalOvertime(type);
                                }
                                
                                if (r > 0 && c == 9){ /* type */
                                    int lateApp = 0;
                                    if(value.equalsIgnoreCase("Yes")){
                                        lateApp= 1;
                                    }
                                    overtimeDetail.setLateApproval(lateApp);
                                }
                                
                                if (r > 0 && c == 10){ /* type */
                                    if(value.equalsIgnoreCase("Operasional")){
                                        typeLembur= 1;
                                    } else {
                                        typeLembur =0;
                                    }
                                }
                                
                                if (r > 0 && !startDate.equals("") && !startTime.equals("") && !endDate.equals("") && !endTime.equals("") && !tdColor.equals("#DC143C;") ){
                                    checkOt = PstOvertimeDetail.checkOvertime(employee.getOID(), startDate+" "+startTime,endDate+" "+endTime);
                                    if (checkOt){
                                        tdColor = "#DC143C;";
                                    }
                                }
                                
                                
                                /* Proses menampilkan data ke html table */
                                if (r == 0){ /* Baris Header table */
                                    html += "<td style=\"background-color:#DDD;\"><strong>"+ value + "</strong></td>";
                                } else {
                                    if (value.equals("NULL")){
                                        html += "<td style=\"background-color:"+tdColor+"\">-</td>";
                                    } else {
                                        html +="<td style=\"background-color:"+tdColor+"\">"+value+"</td>";
                                    }
                                }
                                
                                
                            }
                            /*End For Cols*/
                            html +="</tr>";
                            long oidOt = 0;
                            if (employee != null){
                                
                                String whereMapping = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK]+" = "+PstMappingPosition.OVERTIME_REQUEST_NON_OP
                                                        + " AND ("+PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID]+" = "+employee.getPositionId()
                                                        + " OR "+PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+" = "+employee.getPositionId()+")";
                                Vector listPositionMap = PstMappingPosition.list(0, 0, whereMapping, "");
                                String listPos = "";
                                String listPosIn = "";
                                long upPosId = 0;
                                if (listPositionMap.size()> 0){
                                    for (int x=0; x < listPositionMap.size(); x++){
                                        MappingPosition mapPos = (MappingPosition) listPositionMap.get(x);
                                        if (employee.getOID() != upPosId){
                                            String whereUpPos = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK]+" = "+PstMappingPosition.OVERTIME_REQUEST_NON_OP
                                                            + " AND "+PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+" = "+mapPos.getUpPositionId();

                                            Vector listUpPos = PstMappingPosition.list(0, 0, whereUpPos, ""+PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
                                            if (listUpPos.size()>0){
                                                for (int up=0; up<listUpPos.size();up++){
                                                    MappingPosition upPos = (MappingPosition) listUpPos.get(up);
                                                    listPos = listPos+ ","+upPos.getDownPositionId();
                                                }
                                            }
                                        }
                                        upPosId = mapPos.getUpPositionId();
                                        listPos = listPos+ ","+mapPos.getDownPositionId()+","+mapPos.getUpPositionId();
                                    }
                                    
                                    listPos = listPos.substring(1);
                                    String[] listPosArray = listPos.split(",");
                                    listPosArray = new HashSet<String>(Arrays.asList(listPosArray)).toArray(new String[0]);
                                    
                                    
                                    if (listPosArray.length> 0){
                                        for (int n=0; n<listPosArray.length;n++){
                                            listPosIn = listPosIn+","+listPosArray[n];
                                        }
                                        listPosIn = listPosIn.substring(1);
                                    }
                                    
                                } else {
                                    listPosIn = ""+employee.getPositionId();
                                }
                                
                                oidOt = PstOvertimeDetail.getOvertimeId(employee.getOID(), startDate, typeLembur, listPosIn);
                            }
                            
                            if (oidOt == 0 && !checkOt && employee != null){
                                if (employee.getDivisionId() == emp.getDivisionId() || appUser.getAdminStatus() == 1){
                                    Overtime overtime = new Overtime();
                                    overtime.setCompanyId(emp.getCompanyId());
                                    overtime.setDivisionId(emp.getDivisionId());
                                    overtime.setDepartmentId(emp.getDepartmentId());
                                    overtime.setObjective("upload from excel");
                                    overtime.setStatusDoc(0);
                                    overtime.setRequestDate(new Date());
                                    overtime.setOvertimeType(typeLembur);

                                    oidOvertime = PstOvertime.insertExc(overtime);
                                }
                            } else {
                                oidOvertime = oidOt;
                            }
                            
                            
                            
                            if (errCell == 0 && r > 0 && oidOvertime != 0 && (employee.getDivisionId() == emp.getDivisionId() || appUser.getAdminStatus() == 1) && !checkOt ){
                                if (oidOt != 0){
                                    overtimeDetail.setOvertimeId(oidOt);
                                } else {
                                    overtimeDetail.setOvertimeId(oidOvertime);                                    
                                }

                                long oidDetail = PstOvertimeDetail.insertExc(overtimeDetail);
                                overtimeDate = startDate;
                            } else if (r != 0) {
                                errInsert++;
                            }
                            
                            
                            
                        } catch (Exception e) {
                            System.out.println("=> Can't get data ..sheet : " + i + ", row : " + r + ", => Exception e : " + e.toString());
                        }
                    } //end of sheet
                    html += "</table>";
                    html += "<div>&nbsp;</div>";
                    if (errInsert > 0){
                        html +="<div>Gagal insert data : "+errInsert+"</div>";
                    }

//                    for (int inc=0; inc < overtimeCollect.size(); inc++){
//                        OvertimeDetail overtimeDetail = (OvertimeDetail)overtimeCollect.get(inc);
//                        try {
//                            PstOvertimeDetail insertOvertime = new PstOvertimeDetail();
//                            insertOvertime.insertExc(overtimeDetail);
//                        } catch(Exception e){
//                            System.out.println(e.toString());
//                        }
//                    }
                    
                    
            } //end of all sheets
            
        } catch (Exception e) {
            System.out.println("---=== Error : ReadStream ===---\n" + e);
        }
        
        return html;
    }
    
    public static boolean isStringDate(String value){
        boolean check = false;
        if (value.length() == 10){
            String[] data = value.split("-");
            if (data.length == 3){
                check = true;
            }
        }
        return check;
    }
    
    public static boolean isStringTime(String value){
        boolean check = false;
        if (value.length() == 5){
            String[] data = value.split(":");
            if (data.length == 2){
                check = true;
            }
        }
        return check;
    }
}
