/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report.leave;

import com.dimata.harisma.entity.attendance.AlStockManagement;
import com.dimata.harisma.entity.attendance.AlStockTaken;
import com.dimata.harisma.entity.attendance.LLStockManagement;
import com.dimata.harisma.entity.attendance.LlStockTaken;
import com.dimata.harisma.entity.attendance.PstAlStockManagement;
import com.dimata.harisma.entity.attendance.PstAlStockTaken;
import com.dimata.harisma.entity.attendance.PstDpStockTaken;
import com.dimata.harisma.entity.attendance.PstLLStockManagement;
import com.dimata.harisma.entity.attendance.PstLlStockTaken;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.FamilyMember;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.PstFamilyMember;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.FamRelation;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstFamRelation;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.itextpdf.tool.xml.css.HeightCalculator;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFPicture;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.examples.Alignment;
import org.apache.poi.hssf.util.HSSFRegionUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import sun.font.FontScalerException;

/**
 *
 * @author Dimata 007
 */
public class LeaveForm extends HttpServlet {

       
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }
    
    public void destroy() {/*no-code*/}
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        
        
        long leaveApplicationId = 0;
        String appRoot = "";
        leaveApplicationId = FRMQueryString.requestLong(request, "oidLeaveApplication");    // untuk mendaptakan oid leave application
        appRoot = FRMQueryString.requestString(request, "approot");    // untuk mendaptakan oid leave application
        //update by satrya 2014-05-27
        int typeForm = FRMQueryString.requestInt(request, "TYPE_FORM_LEAVE");
        LeaveApplication leaveApplication = new LeaveApplication();
        Employee employee = new Employee();
        Department department = new Department();
        Position position = new Position();
        Division division = new Division();
        AlStockManagement alStockManagement = new AlStockManagement();
        LLStockManagement llStockManagement = new LLStockManagement();
        
        
        Vector alStockTaken = new Vector();
        Vector llStockTaken = new Vector();
        Vector specialTaken = new Vector();
        Vector alStockQty = new Vector();
        Vector llStockQty = new Vector();
        Vector dpTaken = new Vector();
        

        try {
            leaveApplication = PstLeaveApplication.fetchExc(leaveApplicationId);
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            employee = PstEmployee.fetchExc(leaveApplication.getEmployeeId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            department = PstDepartment.fetchExc(employee.getDepartmentId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            position = PstPosition.fetchExc(employee.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            division = PstDivision.fetchExc(employee.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        
        String whereEmployee = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "=" + leaveApplication.getEmployeeId();
        Vector listAlStockTaken = PstAlStockTaken.list(0, 0, PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveApplication.getOID(), "");
        Vector listLlStockTaken = PstLlStockTaken.list(0, 0, PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveApplication.getOID(), "");

        if (listAlStockTaken.size()>0){
            AlStockTaken alTaken = (AlStockTaken) listAlStockTaken.get(0);
            alStockQty = PstAlStockManagement.list(0, 0, PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STOCK_ID] + " =  "+alTaken.getAlStockId(), "");
        } else if (listLlStockTaken.size()>0){
            LlStockTaken llTaken = (LlStockTaken) listLlStockTaken.get(0);
            llStockQty = PstLLStockManagement.list(0, 0, PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STOCK_ID] + " = "+llTaken.getLlStockId(), "");
        } else {
            /*kemungkinan Special Leave*/
            Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leaveApplication.getOID(), "");
            if (listSlStockTaken.size()>0){
                SpecialUnpaidLeaveTaken slTaken = (SpecialUnpaidLeaveTaken) listSlStockTaken.get(0);
                String whereAl = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID]+"="+slTaken.getEmployeeId()
                        +" AND "+PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE]+" BETWEEN '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy")+"-01-01' AND "
                        +" '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy-MM-dd")+"'";
                String whereLl = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID]+"="+slTaken.getEmployeeId()
                        +" AND "+PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE]+" BETWEEN '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy")+"-01-01' AND "
                        +" '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy-MM-dd")+"'";
                listAlStockTaken = PstAlStockTaken.list(0, 1, whereAl, PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE]+" DESC");
                listLlStockTaken = PstAlStockTaken.list(0, 1, whereLl, PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE]+" DESC");
                if (listAlStockTaken.size()>0){
                    AlStockTaken alTaken = (AlStockTaken) listAlStockTaken.get(0);
                    alStockQty = PstAlStockManagement.list(0, 0, PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STOCK_ID] + " =  "+alTaken.getAlStockId(), "");
                } else if (listLlStockTaken.size()>0){
                    LlStockTaken llTaken = (LlStockTaken) listLlStockTaken.get(0);
                    llStockQty = PstLLStockManagement.list(0, 0, PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STOCK_ID] + " = "+llTaken.getLlStockId(), "");
                } else {
                    /*kemungkinan SL di bulan pertama*/
                    whereAl = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID]+"="+slTaken.getEmployeeId()
                            +" AND "+PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE]+" > '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy-MM-dd")+"'";
                    whereLl = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID]+"="+slTaken.getEmployeeId()
                            +" AND "+PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE]+" > '"+Formater.formatDate(slTaken.getTakenDate(),"yyyy-MM-dd")+"'";
                    listAlStockTaken = PstAlStockTaken.list(0, 1, whereAl, PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE]+" ASC");
                    listLlStockTaken = PstAlStockTaken.list(0, 1, whereLl, PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE]+" ASC");
                    if (listAlStockTaken.size()>0){
                        AlStockTaken alTaken = (AlStockTaken) listAlStockTaken.get(0);
                        alStockQty = PstAlStockManagement.list(0, 0, PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STOCK_ID] + " =  "+alTaken.getAlStockId(), "");
                    } else if (listLlStockTaken.size()>0){
                        LlStockTaken llTaken = (LlStockTaken) listLlStockTaken.get(0);
                        llStockQty = PstLLStockManagement.list(0, 0, PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STOCK_ID] + " = "+llTaken.getLlStockId(), "");
                    } else {
                        /*Cuti Berjalan*/
                        alStockQty = PstAlStockManagement.list(0, 0, whereEmployee + " AND " + PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS] + " = 0 ", "");
                        llStockQty = PstLLStockManagement.list(0, 0, whereEmployee + " AND " + PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS] + " = 0 ", "");
                    }
                }
            }
        }
        
        
        for (int i=0; i < alStockQty.size(); i++){
            AlStockManagement al = (AlStockManagement) alStockQty.get(i); 
            try {
                alStockManagement = PstAlStockManagement.fetchExc(al.getOID());
            } catch (Exception e) {
                System.out.println("EXCEPTION " + e.toString());
            }
        }
        for (int i=0; i < llStockQty.size(); i++){
            LLStockManagement ll = (LLStockManagement) llStockQty.get(i); 
            try {
                llStockManagement = PstLLStockManagement.fetchExc(ll.getOID());
            } catch (Exception e) {
                System.out.println("EXCEPTION " + e.toString());
            }
        }
        
        //Approval
        Employee empApproval1 = new Employee();
        Employee empApproval2 = new Employee();
        Employee empApproval3 = new Employee();
        Employee empApproval4 = new Employee();
        Employee empApproval5 = new Employee();
        Employee empApproval6 = new Employee();
        Employee empHrApproval = new Employee();
        
        try {
            empApproval1 = PstEmployee.fetchExc(leaveApplication.getApproval_1());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empApproval2 = PstEmployee.fetchExc(leaveApplication.getApproval_2());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empApproval3 = PstEmployee.fetchExc(leaveApplication.getApproval_3());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empApproval4 = PstEmployee.fetchExc(leaveApplication.getApproval_4());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empApproval5 = PstEmployee.fetchExc(leaveApplication.getApproval_5());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empApproval6 = PstEmployee.fetchExc(leaveApplication.getApproval_6());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empHrApproval = PstEmployee.fetchExc(leaveApplication.getHrManApproval());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        
        Position empPos1 = new Position();
        Position empPos2 = new Position();
        Position empPos3 = new Position();
        Position empPos4 = new Position();
        Position empPos5 = new Position();
        Position empPos6 = new Position();
        Position hrPos1 = new Position();
        
        try {
            empPos1 = PstPosition.fetchExc(empApproval1.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empPos2 = PstPosition.fetchExc(empApproval2.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empPos3 = PstPosition.fetchExc(empApproval3.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empPos4 = PstPosition.fetchExc(empApproval4.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empPos5 = PstPosition.fetchExc(empApproval5.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empPos6 = PstPosition.fetchExc(empApproval6.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            hrPos1 = PstPosition.fetchExc(empHrApproval.getPositionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        
        Division empDiv1 = new Division();
        Division empDiv2 = new Division();
        Division empDiv3 = new Division();
        Division empDiv4 = new Division();
        Division empDiv5 = new Division();
        Division empDiv6 = new Division();
        Division hrDiv = new Division();
        
        try {
            empDiv1 = PstDivision.fetchExc(empApproval1.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empDiv2 = PstDivision.fetchExc(empApproval2.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empDiv3 = PstDivision.fetchExc(empApproval3.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empDiv4 = PstDivision.fetchExc(empApproval4.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empDiv5 = PstDivision.fetchExc(empApproval5.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            empDiv6 = PstDivision.fetchExc(empApproval6.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
        try {
            hrDiv = PstDivision.fetchExc(empHrApproval.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
       
        String whereAl = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplication.getOID();
        String whereLl = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplication.getOID();
        String whereSpecial = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID] + "=" + leaveApplication.getOID();
        String whereDp = PstDpStockTaken.fieldNames[PstDpStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplication.getOID();

        alStockTaken = PstAlStockTaken.list(0, 0, whereAl, null);
        llStockTaken = PstLlStockTaken.list(0, 0, whereLl, null);
        specialTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, whereSpecial, null);
        dpTaken = PstDpStockTaken.list(0, 0, whereDp, null);

        int jumlahApp = 0;
        if (leaveApplication.getApproval_1() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getApproval_2() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getApproval_3() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getApproval_4() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getApproval_5() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getApproval_6() > 0){
            jumlahApp = jumlahApp + 1;
        } if (leaveApplication.getHrManApproval() > 0){
            jumlahApp = jumlahApp + 1;
        }
        
        
        Calendar endLeave = Calendar.getInstance();
        Calendar startLeave = Calendar.getInstance();
        Calendar startWork = Calendar.getInstance();
        int takenQty = 0;
        int leaveQty = 0;
        String Al = "";
        String CH = "";
        String S = "";
        String CP = "";
        String CT = "";
        
        if (leaveApplication.getTypeLeaveCategory() == 4 || leaveApplication.getTypeLeaveCategory() == 3){
            Al = "x";
        } if (leaveApplication.getTypeLeaveCategory() == 1){
            CH = "x";
        } if (leaveApplication.getTypeLeaveCategory() == 2){
            CP = "x";
        }
        //>>> ADDED BY DEWOK 2019-05-28
        if (leaveApplication.getTypeLeaveCategory() == 0) {
            if (!specialTaken.isEmpty()) {
                SpecialUnpaidLeaveTaken special = (SpecialUnpaidLeaveTaken) specialTaken.get(0);
                long oidSakit = Long.valueOf(PstSystemProperty.getValueByName("OID_SICK_LEAVE"));
                long oidCutiTambahan = Long.valueOf(PstSystemProperty.getValueByName("OID_SYMBOL_CUTI_TAMBAHAN"));
                if (special.getScheduledId() == oidSakit) {
                    S = " x ";
                } else if (special.getScheduledId() == oidCutiTambahan) {
                    CT = " x ";
                }
            }
        }
        
        if (alStockTaken.size() > 0){
            for (int x=0; x < 1; x++){
                AlStockTaken alStock = (AlStockTaken) alStockTaken.get(x);
                startLeave.setTime(alStock.getTakenDate());  
            }
            for (int i=0; i < alStockTaken.size(); i++){
                AlStockTaken alStock = (AlStockTaken) alStockTaken.get(i);
                endLeave.setTime(alStock.getTakenFinnishDate());
                startWork.setTime(alStock.getTakenFinnishDate());
                takenQty = takenQty + convertInteger(alStock.getTakenQty());
                leaveQty = leaveQty + convertInteger(alStock.getTakenQty());
            }
        } else if (llStockTaken.size() > 0){
            for (int i=0; i < llStockTaken.size(); i++){
                LlStockTaken llStock = (LlStockTaken) llStockTaken.get(i);
                startLeave.setTime(llStock.getTakenDate()); 
                endLeave.setTime(llStock.getTakenFinnishDate());
                startWork.setTime(llStock.getTakenFinnishDate());
                takenQty = takenQty + convertInteger(llStock.getTakenQty());
                leaveQty = leaveQty + convertInteger(llStock.getTakenQty());
            }
        } else if (specialTaken.size() > 0){
            for (int i=0; i < specialTaken.size(); i++){
                SpecialUnpaidLeaveTaken special = (SpecialUnpaidLeaveTaken) specialTaken.get(i);
                startLeave.setTime(special.getTakenDate()); 
                endLeave.setTime(special.getTakenFinnishDate());    
                startWork.setTime(special.getTakenFinnishDate());
                takenQty = takenQty + convertInteger(special.getTakenQty());
            }
        }
        startWork.add(Calendar.DATE, 1);
        if (startWork.get(Calendar.DAY_OF_WEEK) == startWork.SATURDAY) {
           startWork.add(Calendar.DATE, 2);
        } else if (endLeave.get(Calendar.DAY_OF_WEEK) == startWork.SUNDAY) {
           startWork.add(Calendar.DATE, 1);
        } 
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
        String strWork = sdf.format(startWork.getTime());
        String strLeave = sdf.format(startLeave.getTime());
        String strEndLeave = sdf.format(endLeave.getTime());
        String submitDate = sdf.format(leaveApplication.getSubmissionDate());
        
        String imagePath = String.valueOf(PstSystemProperty.getValueByName("IMGCACHE"));
        String fullPath = imagePath + "BPD.png";
        
        
        HSSFWorkbook my_workbook = new HSSFWorkbook();
        HSSFSheet sheet = my_workbook.createSheet("MyBanner");               
        /* Read the input image into InputStream */
        InputStream my_banner_image = new FileInputStream(fullPath);
        /* Convert Image to byte array */
        byte[] bytes = IOUtils.toByteArray(my_banner_image);
        /* Add Picture to workbook and get a index for the picture */
        int my_picture_id = my_workbook.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
        /* Close Input Stream */
        my_banner_image.close();                
        /* Create the drawing container */
        HSSFPatriarch drawing = sheet.createDrawingPatriarch();
        /* Create an anchor point */
        ClientAnchor my_anchor = new HSSFClientAnchor();
        /* Define top left corner, and we can resize picture suitable from there */
        my_anchor.setCol1(10);
        my_anchor.setRow1(0);
        /* Invoke createPicture and pass the anchor point and ID */
        HSSFPicture  my_picture = drawing.createPicture(my_anchor, my_picture_id);
        /* Call resize method, which resizes the image */
        
        
        sheet.addMergedRegion(new CellRangeAddress(
                0, //first row (0-based)
                2, //last row  (0-based)
                0, //first column (0-based)
                21  //last column  (0-based)
        ));
        
        sheet.setColumnWidth(0, 1000);
        sheet.setColumnWidth(1, 1200);
        sheet.setColumnWidth(2, 500);
        sheet.setColumnWidth(3, 1250);
        sheet.setColumnWidth(4, 1150);
        sheet.setColumnWidth(5, 2000);
        sheet.setColumnWidth(6, 1000);
        sheet.setColumnWidth(7, 1000);
        sheet.setColumnWidth(8, 1000);
        sheet.setColumnWidth(9, 500);
        sheet.setColumnWidth(10, 800);
        sheet.setColumnWidth(11, 500);
        sheet.setColumnWidth(12, 800);
        sheet.setColumnWidth(13, 1500);
        sheet.setColumnWidth(14, 700);
        sheet.setColumnWidth(15, 1500);
        sheet.setColumnWidth(16, 1500);
        sheet.setColumnWidth(17, 300);
        sheet.setColumnWidth(18, 1500);
        sheet.setColumnWidth(19, 300);
        sheet.setColumnWidth(20, 1800);
        sheet.setColumnWidth(21, 1500);
        
        my_picture.resize(); 
        
        //row 3
        Row row = sheet.createRow((short) 3);
        CellStyle style = my_workbook.createCellStyle();
        Font font = my_workbook.createFont();
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        style.setFont(font);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        Cell cell = row.createCell((short) 0);
        cell.setCellValue("PT. BANK PEMBANGUNAN DAERAH BALI");
        cell.setCellStyle(style);
        sheet.addMergedRegion(new CellRangeAddress(
                3, //first row (0-based)
                3, //last row  (0-based)
                0, //first column (0-based)
                21  //last column  (0-based)
        ));
        
        //row 4
        row = sheet.createRow((short) 4);
        style = my_workbook.createCellStyle();
        font = my_workbook.createFont();
        font.setFontName("Arrial Narrow");
        style.setFont(font);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        cell = row.createCell((short) 0);
        cell.setCellValue("(the regional development bank of bali)");
        cell.setCellStyle(style);
        sheet.addMergedRegion(new CellRangeAddress(
                4, //first row (0-based)
                4, //last row  (0-based)
                0, //first column (0-based)
                21  //last column  (0-based)
        ));
        
        //row 5
        row = sheet.createRow((short) 5);
        style = my_workbook.createCellStyle();
        font = my_workbook.createFont();
        font.setFontName("Arrial Narrow");
        font.setFontHeight((short)(6*20));
        font.setUnderline(Font.U_SINGLE);
        style.setFont(font);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        cell = row.createCell((short) 0);
        cell.setCellValue("kantor pusat/head office : jalan raya puputan, niti mandala, denpasar (bali), indonesia, tlp/phone : 223301-8 (8 saluran/8 lines), fax : 235806 telex : 35168 bpd dpr ia");
        cell.setCellStyle(style);
        sheet.addMergedRegion(new CellRangeAddress(
                5, //first row (0-based)
                5, //last row  (0-based)
                0, //first column (0-based)
                21  //last column  (0-based)
        ));
        
        //row 7
        row = sheet.createRow((short) 7);
        style = my_workbook.createCellStyle();
        font = my_workbook.createFont();
        font.setFontHeight((short)(11*20));
        font.setUnderline(Font.U_SINGLE);
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        style.setFont(font);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        cell = row.createCell((short) 0);
        cell.setCellValue("PERMOHONAN IZIN CUTI");
        cell.setCellStyle(style);
        sheet.addMergedRegion(new CellRangeAddress(
                7, //first row (0-based)
                7, //last row  (0-based)
                0, //first column (0-based)
                21  //last column  (0-based)
        ));
        
        /* Row 9 */         
            row = sheet.createRow((short) 9);
            cell = row.createCell((short) 0);
            cell.setCellValue("Nama");
            sheet.addMergedRegion(new CellRangeAddress(
                    9, //first row (0-based)
                    9, //last row  (0-based)
                    0, //first column (0-based)
                    1  //last column  (0-based)
            ));

            cell = row.createCell((short) 2);
            cell.setCellValue(":");

            cell = row.createCell((short) 3);
            cell.setCellValue(employee.getFullName());
            sheet.addMergedRegion(new CellRangeAddress(
                    9, //first row (0-based)
                    9, //last row  (0-based)
                    3, //first column (0-based)
                    10  //last column  (0-based)
            ));


            cell = row.createCell((short) 13);
            cell.setCellValue("NRK");


            cell = row.createCell((short) 14);
            cell.setCellValue(":");

            cell = row.createCell((short) 15);
            cell.setCellValue(employee.getEmployeeNum());
            sheet.addMergedRegion(new CellRangeAddress(
                    9, //first row (0-based)
                    9, //last row  (0-based)
                    15, //first column (0-based)
                    21  //last column  (0-based)
            ));

        /* Row 10 */         
            row = sheet.createRow((short) 10);
            cell = row.createCell((short) 0);
            cell.setCellValue("Jabatan");
            sheet.addMergedRegion(new CellRangeAddress(
                    10, //first row (0-based)
                    10, //last row  (0-based)
                    0, //first column (0-based)
                    1  //last column  (0-based)
            ));

            cell = row.createCell((short) 2);
            cell.setCellValue(":");

            cell = row.createCell((short) 3);
            cell.setCellValue(position.getPosition() + " " + division.getDivision());
            sheet.addMergedRegion(new CellRangeAddress(
                    10, //first row (0-based)
                    10, //last row  (0-based)
                    3, //first column (0-based)
                    21  //last column  (0-based)
            ));
            
        /*Row 12*/ 
            row = sheet.createRow((short) 12);
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setUnderline(Font.U_SINGLE);
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_LEFT);
            cell = row.createCell((short) 0);
            cell.setCellValue("JENIS CUTI YANG DIMINTA");
            cell.setCellStyle(style);
            sheet.addMergedRegion(new CellRangeAddress(
                    12, //first row (0-based)
                    12, //last row  (0-based)
                    0, //first column (0-based)
                    18  //last column  (0-based)
            ));
        
        /*Row 14*/ 
            row = sheet.createRow((short) 14);
            cell = row.createCell((short) 0);
            cell.setCellValue("1");
            
            String annualLeave = "Tahunan";
            String longLeave = "Besar";
            HSSFRichTextString val = new HSSFRichTextString("Cuti " + annualLeave+" / "+longLeave + " .................................");
            font = my_workbook.createFont();
            font.setStrikeout(true);
//            if(bolden.equals(home)) {u
//                val.applyFont(val.getString().indexOf("@") + 1, val.length(), Font.U_SINGLE);
//            } else if(bolden.equals(away)) {
//                val.applyFont(0, val.getString().indexOf("@"), Font.U_SINGLE);
            if (alStockManagement.getAlQty() > 0){
                val.applyFont(val.getString().indexOf(" / ") + 1, 22, font);
            } else {
                val.applyFont(5, val.getString().indexOf(" / "), font);
            }
//            }
           
            cell = row.createCell((short) 1);
            cell.setCellValue(val);
            sheet.addMergedRegion(new CellRangeAddress(
                    14, //first row (0-based)
                    14, //last row  (0-based)
                    1, //first column (0-based)
                    8  //last column  (0-based)
            ));

            cell = row.createCell((short) 9);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 10);
            cell.setCellValue(Al);
            
            cell = row.createCell((short) 11);
            cell.setCellValue(")");
            
            cell = row.createCell((short) 13);
            cell.setCellValue("Tgl. Masuk Kerja");
            sheet.addMergedRegion(new CellRangeAddress(
                    14, //first row (0-based)
                    14, //last row  (0-based)
                    13, //first column (0-based)
                    16  //last column  (0-based)
            ));
            
            cell = row.createCell((short) 17);
            cell.setCellValue(":");

            cell = row.createCell((short) 18);
            cell.setCellValue(strWork);
            sheet.addMergedRegion(new CellRangeAddress(
                    14, //first row (0-based)
                    14, //last row  (0-based)
                    18, //first column (0-based)
                    21  //last column  (0-based)
            )); 
            
        /*Row 15*/ 
            row = sheet.createRow((short) 15);
            cell = row.createCell((short) 0);
            cell.setCellValue("2");
            
            cell = row.createCell((short) 1);
            cell.setCellValue("Cuti Sakit ???????????????????????????????????????????????????");
            sheet.addMergedRegion(new CellRangeAddress(
                    15, //first row (0-based)
                    15, //last row  (0-based)
                    1, //first column (0-based)
                    8  //last column  (0-based)
            ));

            cell = row.createCell((short) 9);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 10);
            cell.setCellValue(S);
            
            cell = row.createCell((short) 11);
            cell.setCellValue(")");
            
            cell = row.createCell((short) 13);
            cell.setCellValue("Cuti yang diminta");
            sheet.addMergedRegion(new CellRangeAddress(
                    15, //first row (0-based)
                    15, //last row  (0-based)
                    13, //first column (0-based)
                    16  //last column  (0-based)
            ));
            
            cell = row.createCell((short) 17);
            cell.setCellValue(":");

            cell = row.createCell((short) 18);
            cell.setCellValue(takenQty);
            
            cell = row.createCell((short) 19);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("");
            
            cell = row.createCell((short) 21);
            cell.setCellValue(") hari");
            
        /*Row 16*/ 
            row = sheet.createRow((short) 16);
            cell = row.createCell((short) 0);
            cell.setCellValue("3");
            
            cell = row.createCell((short) 1);
            cell.setCellValue("Cuti Bersalin ?????????????????????????????????????????????");
            sheet.addMergedRegion(new CellRangeAddress(
                    16, //first row (0-based)
                    16, //last row  (0-based)
                    1, //first column (0-based)
                    8  //last column  (0-based)
            ));

            cell = row.createCell((short) 9);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 10);
            cell.setCellValue(CH);
            
            cell = row.createCell((short) 11);
            cell.setCellValue(")");
            
            cell = row.createCell((short) 13);
            cell.setCellValue("Tanggal");
            sheet.addMergedRegion(new CellRangeAddress(
                    16, //first row (0-based)
                    16, //last row  (0-based)
                    13, //first column (0-based)
                    16  //last column  (0-based)
            ));
            
            cell = row.createCell((short) 17);
            cell.setCellValue(":");

            cell = row.createCell((short) 18);
            cell.setCellValue(strLeave);
            sheet.addMergedRegion(new CellRangeAddress(
                    16, //first row (0-based)
                    16, //last row  (0-based)
                    18, //first column (0-based)
                    21  //last column  (0-based)
            ));  
            
        /*Row 17*/ 
            row = sheet.createRow((short) 17);
            cell = row.createCell((short) 0);
            cell.setCellValue("4");
            
            cell = row.createCell((short) 1);
            cell.setCellValue("Cuti karena Alasan Penting ??????????????????????????????");
            sheet.addMergedRegion(new CellRangeAddress(
                    17, //first row (0-based)
                    17, //last row  (0-based)
                    1, //first column (0-based)
                    8  //last column  (0-based)
            ));

            cell = row.createCell((short) 9);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 10);
            cell.setCellValue(CP);
            
            cell = row.createCell((short) 11);
            cell.setCellValue(")");
            
            cell = row.createCell((short) 13);
            cell.setCellValue("Sampai dengan tanggal");
            sheet.addMergedRegion(new CellRangeAddress(
                    17, //first row (0-based)
                    17, //last row  (0-based)
                    13, //first column (0-based)
                    16  //last column  (0-based)
            ));
            
            cell = row.createCell((short) 17);
            cell.setCellValue(":");

            cell = row.createCell((short) 18);
            cell.setCellValue(strEndLeave);
            sheet.addMergedRegion(new CellRangeAddress(
                    17, //first row (0-based)
                    17, //last row  (0-based)
                    18, //first column (0-based)
                    21  //last column  (0-based)
            ));  
            
            //>>> ADDED BY DEWOK 2019-05-28
            /*Row 18*/
            row = sheet.createRow((short) 18);
            cell = row.createCell((short) 0);
            cell.setCellValue("5");
            
            cell = row.createCell((short) 1);
            cell.setCellValue("Cuti Tambahan ??????????????????????????????????????????");
            sheet.addMergedRegion(new CellRangeAddress(
                    18, //first row (0-based)
                    18, //last row  (0-based)
                    1, //first column (0-based)
                    8  //last column  (0-based)
            ));

            cell = row.createCell((short) 9);
            cell.setCellValue("(");
            
            cell = row.createCell((short) 10);
            cell.setCellValue(CT);
            
            cell = row.createCell((short) 11);
            cell.setCellValue(")");
            
        /*Row 20*/ 
            row = sheet.createRow((short) 20);
            cell = row.createCell((short) 0);
            cell.setCellValue("Alasan");
            sheet.addMergedRegion(new CellRangeAddress(
                    20, //first row (0-based)
                    20, //last row  (0-based)
                    0, //first column (0-based)
                    1  //last column  (0-based)
            ));

            cell = row.createCell((short) 2);
            cell.setCellValue(":");
            
            
            cell = row.createCell((short) 3);
            cell.setCellValue(leaveApplication.getLeaveReason());
            CellRangeAddress cellRangeAddress = new CellRangeAddress(20, 20, 3, 11);
            sheet.addMergedRegion(new CellRangeAddress(
                    20, //first row (0-based)
                    20, //last row  (0-based)
                    3, //first column (0-based)
                    11  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
       
        /*Row 22*/ 
            row = sheet.createRow((short) 22);
            if (jumlahApp > 2){
                cell = row.createCell((short) 4);
                cell.setCellValue("Mengetahui");
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }

            if (jumlahApp > 2){
                cell = row.createCell((short) 12);
                cell.setCellValue("Mengetahui");
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            cell = row.createCell((short) 18);
            cell.setCellValue("Denpasar," + submitDate);
            style = my_workbook.createCellStyle();
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell.setCellStyle(style);
            
        /*Row 23*/ 
            row = sheet.createRow((short) 23);
            if (jumlahApp > 2){
                cell = row.createCell((short) 4);
                cell.setCellValue(empDiv2.getDivision());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            if (jumlahApp > 1){
                cell = row.createCell((short) 12);
                cell.setCellValue("Atasan Langsung");
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }

            cell = row.createCell((short) 18);
            cell.setCellValue("Yang Memohon,");
            style = my_workbook.createCellStyle();
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell.setCellStyle(style);
            
        /*Row 24*/ 
            row = sheet.createRow((short) 24);
            if (jumlahApp > 2){
                cell = row.createCell((short) 4);
                cell.setCellValue(empPos2.getPosition());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
        /*Row 27*/ 
            row = sheet.createRow((short) 27);
            if (jumlahApp > 2){
                cell = row.createCell((short) 4);
                cell.setCellValue(empApproval2.getFullName());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            if (jumlahApp > 1){
                cell = row.createCell((short) 12);
                cell.setCellValue(empApproval1.getFullName());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            cell = row.createCell((short) 18);
            cell.setCellValue(employee.getFullName());
            style = my_workbook.createCellStyle();
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell.setCellStyle(style);
        
        /*Row 28*/ 
            row = sheet.createRow((short) 28);
            if (jumlahApp > 2){
                cell = row.createCell((short) 4);
                cell.setCellValue("NRK." + empApproval2.getEmployeeNum());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            if (jumlahApp > 1){
                cell = row.createCell((short) 12);
                cell.setCellValue("NRK." + empApproval1.getEmployeeNum());
                style = my_workbook.createCellStyle();
                style.setAlignment(CellStyle.ALIGN_CENTER);
                cell.setCellStyle(style);
            }
            
            cell = row.createCell((short) 18);
            cell.setCellValue("NRK." + employee.getEmployeeNum());
            style = my_workbook.createCellStyle();
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell.setCellStyle(style);
            
            
        /*row 29*/    
            cellRangeAddress = new CellRangeAddress(29, 29, 0, 21);
            sheet.addMergedRegion(new CellRangeAddress(
                    29, //first row (0-based)
                    29, //last row  (0-based)
                    0, //first column (0-based)
                    21  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);   

        /*Row 31*/ 
            row = sheet.createRow((short) 31);
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setUnderline(Font.U_SINGLE);
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_LEFT);
            cell = row.createCell((short) 0);
            cell.setCellValue("KOLOM DIISI KHUSUS OLEH PERSONALIA");
            cell.setCellStyle(style);
            sheet.addMergedRegion(new CellRangeAddress(
                    31, //first row (0-based)
                    31, //last row  (0-based)
                    0, //first column (0-based)
                    21  //last column  (0-based)
            ));    
            
         /*Row 33*/ 
            row = sheet.createRow((short) 33);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah Cuti seluruhnya");
            
            
            Date dtNow = new Date();
            Calendar dt = Calendar.getInstance();
            dt.setTime(startLeave.getTime());
            
            cell = row.createCell((short) 5);
            cell.setCellValue(dt.getWeekYear());
            
            int Qty = 0;
            if (alStockManagement.getAlQty() > 0){
                Qty = convertInteger(alStockManagement.getEntitled());
            } else {
                Qty = convertInteger(llStockManagement.getEntitled());
            }
            
            cell = row.createCell((short) 18);
            cell.setCellValue(Qty + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");
            
         /*Row 34*/ 
            row = sheet.createRow((short) 34);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah cuti tahun sebelumnya");
            

            int prevQty = 0;
            if (alStockManagement.getAlQty() > 0){
                prevQty = convertInteger(alStockManagement.getPrevBalance());
            } else {
                prevQty = convertInteger(llStockManagement.getPrevBalance());
            }
            
            cell = row.createCell((short) 18);
            cell.setCellValue(prevQty + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");  
            
         /*row 35*/
            row = sheet.createRow((short) 35);
            row.setHeight((short)50);
            cell = row.createCell((short) 3);
            cellRangeAddress = new CellRangeAddress(35, 35, 18, 20);
            sheet.addMergedRegion(new CellRangeAddress(
                    35, //first row (0-based)
                    35, //last row  (0-based)
                    18, //first column (0-based)
                    20  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
         
         /*row 36*/
            row = sheet.createRow((short) 36);
            row.setHeight((short)50);
            
         /*Row 37*/ 
            row = sheet.createRow((short) 37);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah cuti seluruhnya");
            
            int total = Qty - prevQty;
            cell = row.createCell((short) 18);
            cell.setCellValue(total + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");
         
         /*Row 37*/ 
            row = sheet.createRow((short) 37);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah cuti seluruhnya");
            
            int totalQty = Qty + prevQty;
            cell = row.createCell((short) 18);
            cell.setCellValue(totalQty + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");
            
         /*Row 38*/ 
            row = sheet.createRow((short) 38);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah cuti yang telah dipergunakan");
            
            int usedQty = 0;
            if (alStockManagement.getAlQty() > 0){
                usedQty = convertInteger(PstAlStockTaken.getPreviousLeaveQty(alStockManagement.getOID(), startLeave.getTime()));
            } else {
                usedQty = convertInteger(PstLlStockTaken.getPreviousLeaveQty(llStockManagement.getOID(), startLeave.getTime()));
            }
//            if (leaveApplication.getDocStatus() == 3){
//                usedQty = Math.abs(usedQty - takenQty);
//            }
            cell = row.createCell((short) 18);
            cell.setCellValue(usedQty + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari"); 
            
         /*row 39*/
            row = sheet.createRow((short) 39);
            row.setHeight((short)50);
            cell = row.createCell((short) 3);
            cellRangeAddress = new CellRangeAddress(39, 39, 18, 20);
            sheet.addMergedRegion(new CellRangeAddress(
                    39, //first row (0-based)
                    39, //last row  (0-based)
                    18, //first column (0-based)
                    20  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
         
         /*row 40*/
            row = sheet.createRow((short) 40);
            row.setHeight((short)50);            
         
         /*Row 41*/ 
            row = sheet.createRow((short) 41);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Sisa cuti seluruhnya");
            
            int balance = totalQty - usedQty;
            cell = row.createCell((short) 18);
            cell.setCellValue(balance + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari"); 
            
         /*Row 42*/ 
            row = sheet.createRow((short) 42);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Jumlah cuti yang diminta saat ini");
            
            cell = row.createCell((short) 18);
            cell.setCellValue(leaveQty + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");
            
        /*row 43*/
            row = sheet.createRow((short) 43);
            row.setHeight((short)50);
            cell = row.createCell((short) 3);
            cellRangeAddress = new CellRangeAddress(43, 43, 18, 20);
            sheet.addMergedRegion(new CellRangeAddress(
                    43, //first row (0-based)
                    43, //last row  (0-based)
                    18, //first column (0-based)
                    20  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
         
         /*row 44*/
            row = sheet.createRow((short) 44);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Sisa cuti pada tanggal");
            
            cell = row.createCell((short) 5);
            cell.setCellValue(strWork);
            
            int totBalance = balance - takenQty;
            cell = row.createCell((short) 18);
            cell.setCellValue(totBalance + ".0");
            
            cell = row.createCell((short) 20);
            cell.setCellValue("hari");   
            
         /*row 46*/
            row = sheet.createRow((short) 46);
            
            cell = row.createCell((short) 0);
            cell.setCellValue("Uang Cuti");
            
            cell = row.createCell((short) 2);
            cell.setCellValue(":");
            
            
            Vector leaveApp = new Vector();
            String whereLeave = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + employee.getEmployeeNum() + ""
                                + " AND " + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE] + " LIKE '%2016%'";
            leaveApp = PstLeaveApplication.list(0, 0, whereLeave, "");
            boolean leave_allowance = false;
            for (int i=0; i < leaveApp.size(); i++){
                LeaveApplication lvApp = (LeaveApplication) leaveApp.get(i);
                if (lvApp.getAlAllowance() > 0 ){
                    leave_allowance = true;
                } 
                if (lvApp.getLlAllowance() > 0){
                    leave_allowance = true;
                }
            }
            if (leave_allowance) {
                cell = row.createCell((short) 3);
                cell.setCellValue("x");                
            } 
            cellRangeAddress = new CellRangeAddress(46, 46, 3, 3);
            sheet.addMergedRegion(new CellRangeAddress(
                    46, //first row (0-based)
                    46, //last row  (0-based)
                    3, //first column (0-based)
                    3  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            cell = row.createCell((short) 4);
            cell.setCellValue("telah dibayar"); 
            
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            cell.setCellValue("UNIT PERSONALIA");
            cell.setCellStyle(style);
         /*row 47*/
            row = sheet.createRow((short) 47);
            row.setHeight((short)100);
            
         /*row 48*/
            row = sheet.createRow((short) 48);
            
            if (leave_allowance) {
                cell = row.createCell((short) 3);
                cell.setCellValue("");                
            }
            else {
                cell = row.createCell((short) 3);
                cell.setCellValue("x");   
            }
            
            cellRangeAddress = new CellRangeAddress(48, 48, 3, 3);
            sheet.addMergedRegion(new CellRangeAddress(
                    48, //first row (0-based)
                    48, //last row  (0-based)
                    3, //first column (0-based)
                    3  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            
            cell = row.createCell((short) 4);
            cell.setCellValue("belum dibayar"); 
            
         /*row 50*/   
            Division div = new Division();
            try {
                div = PstDivision.fetchExc(employee.getDivisionId());
            } catch(Exception e){
                System.out.println(e.toString());
            }
            Employee emp = new Employee();
            try {
                emp = PstEmployee.fetchExc(div.getEmployeeId());
            } catch(Exception e){
                System.out.println(e.toString());
            }
            
            row = sheet.createRow((short) 50);
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            cell.setCellValue(emp.getFullName());
            cell.setCellStyle(style);
            
         /*row 51*/    
            cellRangeAddress = new CellRangeAddress(51, 51, 0, 21);
            sheet.addMergedRegion(new CellRangeAddress(
                    51, //first row (0-based)
                    51, //last row  (0-based)
                    0, //first column (0-based)
                    21  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);   

        /*Row 53*/ 
            row = sheet.createRow((short) 53);
            sheet.addMergedRegion(new CellRangeAddress(
                    52, //first row (0-based)
                    52, //last row  (0-based)
                    0, //first column (0-based)
                    9  //last column  (0-based)
            ));
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_LEFT);
            cell = row.createCell((short) 0);
            cell.setCellValue("PERSETUJUAN PEJABAT PEMUTUS");
            cell.setCellStyle(style);
            
            
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            cell.setCellValue("PEJABAT PEMUTUS");
            cell.setCellStyle(style);
            
        /*Row 54*/ 
            row = sheet.createRow((short) 54);
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            cell.setCellValue("PT. Bank Pembangunan Daerah Bali");
            cell.setCellStyle(style);
            
        /*Row 55*/ 
            row = sheet.createRow((short) 55);
            
            cellRangeAddress = new CellRangeAddress(55, 55, 1, 1);
            sheet.addMergedRegion(new CellRangeAddress(
                    55, //first row (0-based)
                    55, //last row  (0-based)
                    1, //first column (0-based)
                    1  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            cell = row.createCell((short) 3);
            cell.setCellValue("DISETUJUI"); 
            
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            if (leaveApplication.getHrManApproval() > 0){
                cell.setCellValue(hrPos1.getPosition());
            } else if (jumlahApp == 6){
                cell.setCellValue(empPos6.getPosition());                
            } else if (jumlahApp == 5){
                cell.setCellValue(empPos5.getPosition());                
            } else if (jumlahApp == 4){
                cell.setCellValue(empPos4.getPosition());                
            } else if (jumlahApp == 3){
                cell.setCellValue(empPos3.getPosition());                
            } else if (jumlahApp == 2){
                cell.setCellValue(empPos2.getPosition());                
            } else if (jumlahApp == 1){
                cell.setCellValue(empPos1.getPosition());                
            }

            cell.setCellStyle(style);  
            
        /*Row 57*/ 
            row = sheet.createRow((short) 57);
            
            cellRangeAddress = new CellRangeAddress(57, 57, 1, 1);
            sheet.addMergedRegion(new CellRangeAddress(
                    57, //first row (0-based)
                    57, //last row  (0-based)
                    1, //first column (0-based)
                    1  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            cell = row.createCell((short) 3);
            cell.setCellValue("DITOLAK"); 
            
        /*Row 59*/ 
            row = sheet.createRow((short) 59);
            
            cellRangeAddress = new CellRangeAddress(59, 59, 1, 1);
            sheet.addMergedRegion(new CellRangeAddress(
                    59, //first row (0-based)
                    59, //last row  (0-based)
                    1, //first column (0-based)
                    1  //last column  (0-based)
            ));
            HSSFRegionUtil.setBorderBottom(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderLeft(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderRight(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            HSSFRegionUtil.setBorderTop(CellStyle.BORDER_THIN, cellRangeAddress, sheet, my_workbook);
            cell = row.createCell((short) 3);
            cell.setCellValue("DISETUJUI"); 
            
            style = my_workbook.createCellStyle();
            font = my_workbook.createFont();
            font.setFontHeight((short)(11*20));
            font.setBoldweight(Font.BOLDWEIGHT_BOLD);
            font.setUnderline(Font.U_SINGLE);
            style.setFont(font);
            style.setAlignment(CellStyle.ALIGN_CENTER);
            cell = row.createCell((short) 16);
            if (leaveApplication.getHrManApproval() > 0){
                cell.setCellValue(empHrApproval.getFullName());
            } else if (jumlahApp == 6){
                cell.setCellValue(empApproval6.getFullName());                
            } else if (jumlahApp == 5){
                cell.setCellValue(empApproval5.getFullName());                
            } else if (jumlahApp == 4){
                cell.setCellValue(empApproval4.getFullName());                
            } else if (jumlahApp == 3){
                cell.setCellValue(empApproval3.getFullName());                
            } else if (jumlahApp == 2){
                cell.setCellValue(empApproval2.getFullName());                
            } else if (jumlahApp == 1){
                cell.setCellValue(empApproval1.getFullName());                
            }

            cell.setCellStyle(style);                        
            
            
            
                      
            
            
//        for (int i = 0; i < 18; i++){
//                my_workbook.getSheetAt(0).autoSizeColumn(i);
//            }
//        
        /* Write changes to the workbook */
        String fileName = "leave_form";
        response.setHeader("Content-Disposition","attachment; filename=" + fileName + ".xls");
        response.setHeader("Cache-Control", "Public");
        ServletOutputStream sos = response.getOutputStream();
        my_workbook.write(sos);
        sos.close();
    
    }
    
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    
    public String getPositionName(long posId) {
        String position = "-";
        Position pos = new Position();
        try {
            pos = PstPosition.fetchExc(posId);
            position = pos.getPosition();
        } catch (Exception ex) {
            System.out.println("getPositionName ==> " + ex.toString());
        }
        return position;
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
    
}