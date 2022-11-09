/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report.attendance;

import com.dimata.harisma.entity.attendance.AttendanceReportDaily;
import com.dimata.harisma.entity.attendance.I_Atendance;
import com.dimata.harisma.entity.attendance.LeaveCheckTakenDateFinish;
import com.dimata.harisma.entity.attendance.Presence;
import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.attendance.PstMachineTransaction;
import com.dimata.harisma.entity.attendance.PstPresence;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.leave.LeaveOidSym;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.HolidaysTable;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstPublicHolidays;
import com.dimata.harisma.entity.masterdata.PstReason;
import com.dimata.harisma.entity.masterdata.PstScheduleCategory;
import com.dimata.harisma.entity.masterdata.PstScheduleSymbol;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.ScheduleSymbol;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.entity.overtime.Overtime;
import com.dimata.harisma.entity.overtime.OvertimeDetail;
import com.dimata.harisma.entity.overtime.PstOvertimeDetail;
import com.dimata.harisma.entity.payroll.PayComponent;
import com.dimata.harisma.entity.payroll.PayGeneral;
import com.dimata.harisma.entity.payroll.PstPayGeneral;
import com.dimata.harisma.entity.search.SrcReportDailyXls;
import com.dimata.harisma.session.attendance.PresenceReportDaily;
import com.dimata.harisma.session.attendance.SessEmpSchedule;
import com.dimata.harisma.session.leave.SessLeaveApp;
import com.dimata.harisma.session.payroll.I_PayrollCalculator;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.DateCalc;
import com.dimata.util.Formater;
import javax.servlet.*;
import javax.servlet.http.*;

import java.util.*;

import java.io.InputStream;
import java.io.IOException;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.hssf.record.*;
import org.apache.poi.hssf.model.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
/**
 *
 * @author Satrya Ramayu
 */
public class AttendanceReportDailyXls extends HttpServlet{
    
    
     
    /** Initializes the servlet.
    */  
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
    */  
    public void destroy() {

    }

    
    private static Font createFont(SXSSFWorkbook wb, int size, int color, boolean isBold) {
        Font font = wb.createFont();
        font.setFontHeightInPoints((short) size);
        font.setColor((short) color);
        if (isBold) {
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        }
        return font;
    }
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */
     private static long Al_oid = 0;
    private static long DP_oid = 0;
    private static long LL_oid = 0;
    @SuppressWarnings("empty-statement")
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
       
       // System.out.println("\r=== specialquery_list.jsp ===");
        try {
            
        }
        catch (Exception e) {
            System.out.println("Exception SpecialQuery export Excel"+e);
        }
    response.setHeader("Content-Disposition","attachment; filename=laporan_kehadiran_harian.xls ");
    Date selectedDateFrom = FRMQueryString.requestDateVer3(request, "check_date_start");
    Date selectedDateTo = FRMQueryString.requestDateVer3(request, "check_date_finish");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String fullName = FRMQueryString.requestString(request, "full_name");
    
    //update by satrya 2013-04-08
    int reason_sts = FRMQueryString.requestInt(request, "reason_status");
    //update by satrya 2012-09-28
    //String status1st = FRMQueryString.requestString(request, "status_schedule1st");
    //String status2nd = FRMQueryString.requestString(request, "status_schedule2nd");         
    long oidDepartment = FRMQueryString.requestLong(request, "department");        
    long oidSection = FRMQueryString.requestLong(request, "section");
    
        //update by satrya 2013-1202
    long oidCompany = FRMQueryString.requestLong(request, "hidden_companyId");
     long oidDivision = FRMQueryString.requestLong(request, "hidden_divisionId");
     
     
    String[] arrCompany = FRMQueryString.requestStringValues(request, "hidden_companyId");
    String[] arrDivision = FRMQueryString.requestStringValues(request, "hidden_divisionId");
    String[] arrDepartment = FRMQueryString.requestStringValues(request, "department");
    String[] arrSection = FRMQueryString.requestStringValues(request, "section");
    
    String inCompany = "";
    String inDivision = "";
    String inDepartment = "";
    String inSection = "";
    
    if (arrCompany != null){
        for (int i=0; i < arrCompany.length; i++){
            inCompany = inCompany + ","+ arrCompany[i];
        }
        inCompany = inCompany.substring(1);
    }
    if (arrDivision != null){
        for (int i=0; i < arrDivision.length; i++){
            inDivision = inDivision + ","+ arrDivision[i];
        }
        inDivision = inDivision.substring(1);
    }
    if (arrDepartment != null){
        for (int i=0; i < arrDepartment.length; i++){
            inDepartment = inDepartment + ","+ arrDepartment[i];
        }
        inDepartment = inDepartment.substring(1);
    }
    if (arrSection != null){
        for (int i=0; i < arrSection.length; i++){
            inSection = inSection + ","+ arrSection[i];
        }
        inSection = inSection.substring(1);
    }
    
    Date date = FRMQueryString.requestDate(request, "date");
    
    int vectSize = 0;
    
     //int recordToGet = 40000;

     String sStatusResign = FRMQueryString.requestString(request, "statusResign"); 
    int statusResign=0;
    if(sStatusResign!=null && sStatusResign.length()>0){
        statusResign = Integer.parseInt(sStatusResign); 
    }
        //update by satrya 2013-03-29
   String[] stsSchedule = null;
    String stsScheduleSel = "";
    stsSchedule = new String[PstEmpSchedule.strPresenceStatus.length]; 
    //Vector stsScheduleSel= new Vector(); 
    int maxStsSchedule = 0;

    for(int j = 0 ; j < PstEmpSchedule.strPresenceStatusIdx.length ; j++){                
        String name = "STS_SCH_"+PstEmpSchedule.strPresenceStatusIdx[j];
        String val = FRMQueryString.requestString(request,name);
        stsSchedule[j] = val;
        if(val!=null && val.length()>0){  
           stsScheduleSel = stsScheduleSel + ""+PstEmpSchedule.strPresenceStatusIdx[j]+","; 
        }
        maxStsSchedule++;
    }
    String[] stsEmpCategory = null; 
    int sizeCategory = PstEmpCategory.listAll()!=null ? PstEmpCategory.listAll().size():0;   
    stsEmpCategory = new String[sizeCategory]; 
    //Vector stsEmpCategorySel= new Vector(); 
    String stsEmpCategorySel = "";
    int maxEmpCat = 0; 
    for(int j = 0 ; j < sizeCategory ; j++){                
        String name = "EMP_CAT_"+j;
        String val = FRMQueryString.requestString(request,name);
        stsEmpCategory[j] = val;
        if(val!=null && val.length()>0){ 
           //stsEmpCategorySel.add(""+val); 
            stsEmpCategorySel = stsEmpCategorySel + val+",";
        }
        maxEmpCat++;
    }

                       //update by satrya 2013-03-29
String getEmployeePresence="";
   String[] stsPresence = null;
    stsPresence = new String[Presence.STATUS_ATT_IDX.length]; 
    Vector stsPresenceSel= new Vector(); 
    int max1 = 0;

    for(int j = 0 ; j < Presence.STATUS_ATT_IDX.length ; j++){                
        String name = "ATTD_"+Presence.STATUS_ATT_IDX[j];
        String val = FRMQueryString.requestString(request,name);
        stsPresence[j] = val;
        if(val!=null && val.equals("1")){ 
           stsPresenceSel.add(""+Presence.STATUS_ATT_IDX[j]); 
        }
        max1++;
    }

try {
    Al_oid = Long.parseLong(PstSystemProperty.getValueByName("OID_AL"));
    DP_oid = Long.parseLong(PstSystemProperty.getValueByName("OID_DP"));
    LL_oid = Long.parseLong(PstSystemProperty.getValueByName("OID_LL"));
} catch (Exception exc) {
    System.out.println("Exception:"+ exc);
}

 ///cek untuk mendqapatkan insentif
  I_Atendance attdConfig = null;
try {
    attdConfig = (I_Atendance) (Class.forName(PstSystemProperty.getValueByName("ATTENDANCE_CONFIG")).newInstance());
} catch (Exception e) {
    System.out.println("Exception : " + e.getMessage());
    System.out.println("Please contact your system administration to setup system property: LEAVE_CONFIG ");
}
 int showOvertime = 0;
try {
    showOvertime = Integer.parseInt(PstSystemProperty.getValueByName("ATTANDACE_SHOW_OVERTIME_IN_REPORT_DAILY"));
} catch (Exception ex) {

    System.out.println("<blink>ATTANDACE_SHOW_OVERTIME_IN_REPORT_DAILY NOT TO BE SET</blink>");
    showOvertime = 0;
}

 I_PayrollCalculator payrollCalculatorConfig = null; 
 try{
      payrollCalculatorConfig = (I_PayrollCalculator)(Class.forName(PstSystemProperty.getValueByName("PAYROLL_CALC_CLASS_NAME")).newInstance());
 }catch(Exception exc){
 
 };
//update by satrya 2014-03-10
      if(payrollCalculatorConfig!=null){
          payrollCalculatorConfig.loadEmpCategoryInsentif();
      }
 
 int iPropInsentifLevel = 0;//hanya cuti full day jika fullDayLeave = 0
    try{
        iPropInsentifLevel = Integer.parseInt(PstSystemProperty.getValueByName("PAYROLL_INSENTIF_MAX_LEVEL"));
    }catch(Exception ex){

        //System.out.println("Execption PAYROLL_INSENTIF_MAX_LEVEL: " + ex);
        System.out.println("<blink>PAYROLL_INSENTIF_MAX_LEVEL NOT TO BE SET</blink>" );
    }
//update by satrya 2014-02-01
HolidaysTable holidaysTable = PstPublicHolidays.getHolidaysTable(selectedDateFrom, selectedDateTo);
 Hashtable hashPositionLevel = PstPosition.hashGetPositionLevel();  
SrcReportDailyXls srcReportDailyXls = new SrcReportDailyXls();
srcReportDailyXls.setEmpNum(empNum);
srcReportDailyXls.setFullName(fullName);
srcReportDailyXls.setOidDepartment(oidDepartment);
srcReportDailyXls.setOidSection(oidSection);
srcReportDailyXls.setReason_sts(reason_sts);
srcReportDailyXls.setSelectedDateFrom(selectedDateFrom);
srcReportDailyXls.setSelectedDateTo(selectedDateTo);
srcReportDailyXls.setStatusResign(statusResign);
srcReportDailyXls.setStatusSchedule(stsScheduleSel);
srcReportDailyXls.setStsEmpCategorySel(stsEmpCategorySel);
srcReportDailyXls.addStatusPresence(stsPresenceSel);
srcReportDailyXls.setOidCompany(oidCompany);
srcReportDailyXls.setOidDivision(oidDivision);
srcReportDailyXls.setInCompany(inCompany);
srcReportDailyXls.setInDivision(inDivision);
srcReportDailyXls.setInDepartment(inDepartment);
srcReportDailyXls.setInSection(inSection);

Vector listOvertimeDaily = null;
Vector vOvertimeDetail = new Vector();
if(showOvertime==0){
        
          listOvertimeDaily = PstOvertimeDetail.listOvertimeIn(0, 0, inDepartment, fullName.trim(), 
                  selectedDateFrom, selectedDateTo, inSection, empNum.trim(), "",stsPresenceSel,inCompany,inDivision); 
          
           vOvertimeDetail = PstOvertimeDetail.listOvertimeDetailIn(0, 0, inDepartment, fullName.trim(), 
                  selectedDateFrom, selectedDateTo, inSection, empNum.trim(), "",stsPresenceSel,inCompany,inDivision);
        
}


        Vector vListReportDaily = SessEmpSchedule.listEmpPresenceDailyXls(srcReportDailyXls); 
        Hashtable hashSchSymbol = PstScheduleSymbol.getHashTlScheduleAll();
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");

        SXSSFWorkbook wb = new SXSSFWorkbook(1);
        Sheet sheet = wb.createSheet("Attedance Report Daily");

        CellStyle style2 = wb.createCellStyle();
        style2.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
         CellStyle style3RedFont = wb.createCellStyle();
        style3RedFont.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style3RedFont.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style3RedFont.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style3RedFont.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style3RedFont.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style3RedFont.setBorderRight(HSSFCellStyle.BORDER_THIN);
        //style3RedFont.setFont();
        Font fontRed = wb.createFont();
        fontRed.setColor(new HSSFColor.RED().getIndex()); 
        style3RedFont.setFont(fontRed);
        //style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);

        CellStyle style3 = wb.createCellStyle();
        style3.setFillBackgroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());//HSSFCellStyle.GREY_25_PERCENT);
        style3.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());//HSSFCellStyle.GREY_25_PERCENT);
        style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        
        CellStyle styleTitle = wb.createCellStyle();
        styleTitle.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        styleTitle.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        styleTitle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleTitle.setFont(createFont(wb, 12, HSSFFont.COLOR_NORMAL /*HSSFFont.BLACK*/, true));
        // Create a row and put some cells in it. Rows are 0 based.
        // Create a row and put some cells in it. Rows are 0 based.
        //HSSFRow row = sheet.createRow((short) 0);
        //HSSFCell cell = row.createCell((short) 0);
        
        //update by satrya 2014-02-01
        //pemberian warna font
        CellStyle styleFont = wb.createCellStyle();
        Font font = wb.createFont();
        font.setColor(HSSFColor.RED.index);
        styleFont.setFont(font);
        
        Row row = sheet.createRow((short) 0);
        Cell cell = row.createCell((short) 0);
        
           String printHeader = PstSystemProperty.getValueByName("PRINT_HEADER");

            if (printHeader.equals(PstSystemProperty.SYS_NOT_INITIALIZED)) {
                printHeader = "";
            }
            PayGeneral payGeneral = new PayGeneral();
            if(srcReportDailyXls!=null && srcReportDailyXls.getOidCompany()!=0){
               try{
                payGeneral = PstPayGeneral.fetchExc(srcReportDailyXls.getOidCompany());
               }catch(Exception exc){
               
               }
            }
            Division division = new Division();
            if(srcReportDailyXls!=null && srcReportDailyXls.getOidDivision()!=0){
              try{
                division = PstDivision.fetchExc( srcReportDailyXls.getOidDivision());
              }catch(Exception exc){
              
              }
            }
            Department department = new Department();
            if(srcReportDailyXls!=null && srcReportDailyXls.getOidDepartment()!=0){
               try{
                department =PstDepartment.fetchExc(srcReportDailyXls.getOidDepartment());
               }catch(Exception exc){
               
               }
            }
            Section section = new Section();
            if(srcReportDailyXls!=null && srcReportDailyXls.getOidSection()!=0){
               try{
                section = PstSection.fetchExc(srcReportDailyXls.getOidSection());
               }catch(Exception exc){
               
               }
            }
            String companyName = payGeneral!=null && payGeneral.getCompanyName().length()>0?payGeneral.getCompanyName():"-";
            String divisionName = division!=null && division.getDivision().length()>0?division.getDivision():"-";
            String departmenName = department!=null && department.getDepartment().length()>0?department.getDepartment():"-";
            String sectionName = section!=null && section.getSection().length()>0?section.getSection():"-";
            String[] tableTitle = {
                printHeader,
                "REPORT ATENDANCE DAILY",
                "DATE : " + (srcReportDailyXls.getSelectedDateFrom() != null ? Formater.formatDate(srcReportDailyXls.getSelectedDateFrom(), "dd-MM-yyyy") : "") + " To " + (srcReportDailyXls.getSelectedDateTo() != null ? Formater.formatDate(srcReportDailyXls.getSelectedDateTo(), "dd-MM-yyyy") : ""),
                "COMPANY : " + companyName,
                "DIVISION : " + divisionName,
                "DEPARTEMENT : " + departmenName,
                "SECTION : " + sectionName
            };

        int countRow = 0;
        /**
         * 
         */
        for (int k = 0; k < tableTitle.length; k++) {
                row = sheet.createRow((short) (countRow));
               
                countRow++;
                cell = row.createCell((short) 0);
                cell.setCellValue(tableTitle[k]);
                cell.setCellStyle(styleTitle);
         }
        
        
        
        row = sheet.createRow((short) 6);
        cell = row.createCell((short) 0);
        int totTanpaOvertime=6;
        //row = sheet.createRow((short) (0));
        if(showOvertime==0){
           totTanpaOvertime=11;
            String[] tableHeaderWithOT = {

            "No","Payrol Number","Nama","Company","Division","Departement","Section","Date"
            ,"Schedule","Time In","Time Out","Break Out","Break In","Diff In"
            ,"Diff Out","Duration","insentif","Ot.Form","Allowance","Paid/Dp","Net.Ot","Reason","Note","Status"

            };
             for (int k = 0; k < tableHeaderWithOT.length; k++) {
                cell = row.createCell((short) k);
                cell.setCellValue(tableHeaderWithOT[k]);
                cell.setCellStyle(style3);
            }
        }else{
           String[] tableHeaderNotOT = {

            "No","NRK","Nama","Company","Division","Departement","Section", "Level", "Position" , "Date"
            ,"Schedule","Time In","Time Out","Break Out","Break In","Diff In"
            ,"Diff Out","Duration","Reason","Note","Status"

            };
            for (int k = 0; k < tableHeaderNotOT.length; k++) {
                cell = row.createCell((short) k);
                cell.setCellValue(tableHeaderNotOT[k]);
                cell.setCellStyle(style3);
            }
        }

        
        
        
     countRow = 6 ;
      // int addRow =0;
      if(vListReportDaily!=null && vListReportDaily.size()>0){
         int no=1;
         //long tmpEmpId=0;
         String order = "DATE("+PstPresence.fieldNames[PstPresence.FLD_PRESENCE_DATETIME] + " )ASC, "
                        + "TIME("+PstPresence.fieldNames[PstPresence.FLD_PRESENCE_DATETIME] + " )ASC, " 
                        + PstPresence.fieldNames[PstPresence.FLD_EMPLOYEE_ID]
                        + " , "+ PstPresence.fieldNames[PstPresence.FLD_STATUS] + " ASC ";  
         Vector listPresencePersonalInOut =  PstPresence.list(0 , 0, order, oidDepartment, fullName.trim(), 
              selectedDateFrom, selectedDateTo, oidSection, empNum.trim(),stsPresenceSel,stsEmpCategorySel,statusResign); 
         Hashtable breakTimeDuration = PstScheduleSymbol.getBreakTimeDuration();
         Hashtable hashReason = PstReason.getReason(0, 0, "", "");
         //Hashtable tmpDataEmployeeExist= new Hashtable();
          // priska 20150610
                        Hashtable outletname = new Hashtable();
                        String InEmpNum = " 1";
                        
                        //str1.contains(cs1)
                        
                        for ( int is = 0 ; is < vListReportDaily.size(); is++ ){
                             AttendanceReportDaily attendanceReportDaily = (AttendanceReportDaily) vListReportDaily.get(is);
                            if (attendanceReportDaily != null && (!InEmpNum.contains(attendanceReportDaily.getPayrollNumb().toString())) ){
                            InEmpNum = InEmpNum + "," +attendanceReportDaily.getPayrollNumb();
                            }
                        }
                        Date newDateTo = (Date) selectedDateTo.clone();
                        newDateTo.setDate(newDateTo.getDate() + 1);
                        String wherestation = " he." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " IN ( "+ InEmpNum +") AND ( hmt." + PstMachineTransaction.fieldNames[PstMachineTransaction.FLD_DATE_TRANS] +" >= \""+ Formater.formatDate(selectedDateFrom, "yyyy-MM-dd") + " 00:00:00\"" + " AND hmt." + PstMachineTransaction.fieldNames[PstMachineTransaction.FLD_DATE_TRANS] +" <= \""+ Formater.formatDate(newDateTo, "yyyy-MM-dd") + " 23:59:59\""  +" )" ;
                        outletname = PstMachineTransaction.GetStationByDate(0, 0, wherestation, PstMachineTransaction.fieldNames[PstMachineTransaction.FLD_DATE_TRANS]);
                           
        for (int i = 0; i < vListReportDaily.size(); i++) {
         AttendanceReportDaily attendanceReportDaily = (AttendanceReportDaily) vListReportDaily.get(i);
          try{
            countRow++;
            //countRow = countRow + addRow;
            row = sheet.createRow((short) (countRow));
            sheet.createFreezePane(9, 7);
            //cell = row.createCell((short) 0);cell.setCellValue("");cell.setCellStyle(style2);    
            //if(attendanceReportDaily!=null && attendanceReportDaily.getEmployeeId()!=tmpEmpId && tmpDataEmployeeExist.get(attendanceReportDaily.getEmployeeId())==null){ 
            //    tmpEmpId = attendanceReportDaily.getEmployeeId();
                //tmpDataEmployeeExist.put(attendanceReportDaily.getEmployeeId(), true);
                cell = row.createCell((short) 0);cell.setCellValue(no);cell.setCellStyle(style2);    
                no++;
                cell = row.createCell((short) 1);cell.setCellValue(attendanceReportDaily.getPayrollNumb()!=null && attendanceReportDaily.getPayrollNumb().length()>0?attendanceReportDaily.getPayrollNumb():"-");cell.setCellStyle(style2);            
                cell = row.createCell((short) 2);cell.setCellValue(attendanceReportDaily.getFullName()!=null &&attendanceReportDaily.getFullName().length()>0?attendanceReportDaily.getFullName():"-");cell.setCellStyle(style2);            
                cell = row.createCell((short) 3);cell.setCellValue(attendanceReportDaily.getCompanyName()!=null && attendanceReportDaily.getCompanyName().length()>0?attendanceReportDaily.getCompanyName():"-");cell.setCellStyle(style2);            
                cell = row.createCell((short) 4);cell.setCellValue(attendanceReportDaily.getDivisionName()!=null&& attendanceReportDaily.getDivisionName().length()>0?attendanceReportDaily.getDivisionName():"-");cell.setCellStyle(style2);   
                cell = row.createCell((short) 5);cell.setCellValue(attendanceReportDaily.getDepartementName()!=null&& attendanceReportDaily.getDepartementName().length()>0?attendanceReportDaily.getDepartementName():"-");cell.setCellStyle(style2);   
                cell = row.createCell((short) 6);cell.setCellValue(attendanceReportDaily.getSectionName()!=null&& attendanceReportDaily.getSectionName().length()>0?attendanceReportDaily.getSectionName():"-");cell.setCellStyle(style2);   
                cell = row.createCell((short) 7);cell.setCellValue(attendanceReportDaily.getLevelName()!=null&& attendanceReportDaily.getLevelName().length()>0?attendanceReportDaily.getLevelName():"-");cell.setCellStyle(style2);   
                cell = row.createCell((short) 8);cell.setCellValue(attendanceReportDaily.getPositionName()!=null&& attendanceReportDaily.getPositionName().length()>0?attendanceReportDaily.getPositionName():"-");cell.setCellStyle(style2);   
                
//            }else{
//                for(int idx=0;idx<7;idx++){
//                    cell = row.createCell((short) idx);cell.setCellValue("");cell.setCellStyle(style2);   
//                }
//            }
            ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
            if(hashSchSymbol!=null && hashSchSymbol.get(attendanceReportDaily.getSchedule1st())!=null){
                scheduleSymbol = (ScheduleSymbol)hashSchSymbol.get(attendanceReportDaily.getSchedule1st());
            }
            String actualIn="";
            String actualOut="";
            if(attendanceReportDaily.getTimeIn()!=null){
                //String fDtActualIn1st = Formater.formatDate(attendanceReportDaily.getTimeIn(), "yyyy-MM-dd HH:mm:ss");
                String fDtActualIn1st = Formater.formatDate(attendanceReportDaily.getTimeIn(), "HH:mm:ss");
                Object stationIn = outletname.get(attendanceReportDaily.getPayrollNumb()+"_"+fDtActualIn1st);
                actualIn = fDtActualIn1st +"/"+(stationIn != null ? stationIn : "-" );
            }else{
                actualIn = "-";
            }
            if(attendanceReportDaily.getTimeOut()!=null){
               // String fDtActualOut1st = Formater.formatDate(attendanceReportDaily.getTimeOut(), "yyyy-MM-dd HH:mm:ss");
                String fDtActualOut1st = Formater.formatDate(attendanceReportDaily.getTimeOut(), "HH:mm:ss");
              Object stationOut = outletname.get(attendanceReportDaily.getPayrollNumb()+"_"+fDtActualOut1st);
                actualOut = fDtActualOut1st +"/"+(stationOut != null ? stationOut : "-" );
            }else{
                actualOut = "-";
            }
             //update by satrya 2014-02-01
              long oidLeave  = 0;
              String sSymbolLeave = ""; 
              String strSchldSymbol1 = attendanceReportDaily.getScheduleSymbol1st(); 
//               Vector listLeaveAplication =  PstLeaveApplication.listOid(attendanceReportDaily.getEmployeeId(), attendanceReportDaily.getSchTimeIn1st(),attendanceReportDaily.getSchTimeOut1st());
//               //update by satrya 2013-12-12
//               Vector vctSchIDOff = PstScheduleSymbol.getScheduleId(PstScheduleCategory.CATEGORY_OFF);
//               if(listLeaveAplication !=null && listLeaveAplication.size()>0){
//                   //LeaveOidSym obj = new LeaveOidSym();
//                   try{
//                   for (int j = 0; j < listLeaveAplication.size(); j++) {
//                    LeaveOidSym leaveOidSym = (LeaveOidSym) listLeaveAplication.get(j);
//                    oidLeave = leaveOidSym.getLeaveOid();
//                    String sSymbolLeaveX= (String.valueOf(leaveOidSym.getLeaveSymbol()));
//                    //update by satrya 2013-12-12
//                    //mencari jika ada schedule off
//                    if(vctSchIDOff!=null && vctSchIDOff.size()>0){
//                        for(int xOff=0;xOff<vctSchIDOff.size();xOff++){
//                            long oidOff = (Long)vctSchIDOff.get(xOff);
//                            //jika schedulenya off maka dihilangkan symbol cutinya
//                            if((attendanceReportDaily.getSchedule1st() == oidOff)){
//                                sSymbolLeaveX="";
//                            }
//                        }
//                    }
//                    sSymbolLeave = sSymbolLeave  + sSymbolLeaveX + ",";
//                }
//                    if(sSymbolLeave!=null && sSymbolLeave.length()>0){
//                         sSymbolLeave= sSymbolLeave.substring(0,sSymbolLeave.length()-1); 
//                        }
//                 
//                   }catch(Exception ex){System.out.println("Exception list Leave Application"+ex);}
//                
//               }
            String selectedDate = attendanceReportDaily.getSelectedDt()!=null?Formater.formatDate(attendanceReportDaily.getSelectedDt(), "EE, dd/MM/yyyy"):"-";
            cell = row.createCell((short) 9);cell.setCellValue(selectedDate);cell.setCellStyle(style2);            
            cell = row.createCell((short) 10);cell.setCellValue(scheduleSymbol.getSymbol()!=null && scheduleSymbol.getSymbol().length()>0?scheduleSymbol.getSymbol()+(sSymbolLeave!=null && sSymbolLeave.length()>0?"/"+sSymbolLeave:""):"-");cell.setCellStyle(style2);            
            cell = row.createCell((short) 11);cell.setCellValue(actualIn);cell.setCellStyle(style2);            
            cell = row.createCell((short) 12);cell.setCellValue(actualOut);cell.setCellStyle(style2);
           
             String reason1st="";
            if(hashReason!=null && hashReason.get(""+attendanceReportDaily.getReason1st())!=null){
                reason1st = (String)hashReason.get(""+attendanceReportDaily.getReason1st());
            }
            
           
            
            
            //menginisialisasikan variable untuk overtime
                String insentif ="-";
                int oVForm =-1;
                int allwance =-1;
                int paid =-1 ;
                long ovId=0;
                //double   NetOv =0.0;
                String   NetOv ="-";
                //double oVerIdx= 0.0;
                String oVerIdx= "-";
                Presence preBOut = null;
                long preBreakOut = 0;
                long preBreakIn = 0;
                long breakDuration =0L;
                long breakOvertime=0;
                String payCompCode = PayComponent.COMPONENT_INS; 
                String bOut =""; 
                String bIn = "";
                String dBout = "";
                String dBin = ""; 
            
                //break out dan in
            cell = row.createCell((short) 13);cell.setCellValue(bOut);cell.setCellStyle(style2);//breakOut            
            cell = row.createCell((short) 14);cell.setCellValue(bIn);cell.setCellStyle(style2); //breakIn           
            
            
             String strDiffIn1st = "-";
             String strDiffOut1st = "-";
                try { 
                    strDiffIn1st = SessEmpSchedule.getDiffIn(attendanceReportDaily.getSchTimeIn1st(), attendanceReportDaily.getTimeIn());
                    strDiffOut1st = SessEmpSchedule.getDiffOut(attendanceReportDaily.getSchTimeOut1st(), attendanceReportDaily.getTimeOut());
                }catch(Exception ex){
                    System.out.println("exCeption Interval "+ex);
                }
            String strDurationFirst = SessEmpSchedule.getWorkingDuration(attendanceReportDaily.getTimeIn(), attendanceReportDaily.getTimeOut(), (breakDuration + breakOvertime));
            
            cell = row.createCell((short) 15);cell.setCellValue(strDiffIn1st.length()>0?strDiffIn1st:"-");cell.setCellStyle(style2);//diffIn            
            cell = row.createCell((short) 16);cell.setCellValue(strDiffOut1st.length()>0?strDiffOut1st:"-");cell.setCellStyle(style2);//diffOut            
            cell = row.createCell((short) 17);cell.setCellValue(strDurationFirst);cell.setCellStyle(style2);//duration
            
            cell = row.createCell((short) 18);cell.setCellValue(""+reason1st);cell.setCellStyle(style2);//,Reason
                cell = row.createCell((short) 19);cell.setCellValue(""+attendanceReportDaily.getNote1st());cell.setCellStyle(style2);//note            
                cell = row.createCell((short) 20);cell.setCellValue(""+attendanceReportDaily.getStatus1st());cell.setCellStyle(style2);    //status      
             //System.out.println(" Employee "+sessTmpSpecialEmployee.getFullName()+" Employee Num: "+ sessTmpSpecialEmployee.getEmployeeNum()+" DEPARTEMENT "+sessTmpSpecialEmployee.getDepartement());
            }catch(Exception exc){
                System.out.println("Exception export excel data bank employee "+ exc +" Employee Num "+ attendanceReportDaily.getPayrollNumb());
            }
        }
      }
        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
    } 

    /** Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    } 

    /** Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
    */
    public String getServletInfo() {
        return "Short description";
    }

}

