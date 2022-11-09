/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
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
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author IanRizky
 */
public class LeaveFormPdf extends HttpServlet {
	
	public static Color blackColor = new Color(0,0,0);
    public static Color whiteColor = new Color(255,255,255);
	public static Color greyColor = new Color(211,211,211);
	
	public static Font fontHeader = new Font(Font.HELVETICA, 14, Font.BOLD, blackColor);    
    public static Font fontContentSmall = new Font(Font.HELVETICA,6, Font.NORMAL, blackColor);
    public static Font fontContent = new Font(Font.HELVETICA, 10, Font.NORMAL, blackColor);
	public static Font fontContentStrikeThrou = new Font(Font.HELVETICA, 10, Font.STRIKETHRU, blackColor);
	public static Font fontContentGrey = new Font(Font.HELVETICA, 10, Font.NORMAL, greyColor);
    public static Font fontContentItalic = new Font(Font.HELVETICA, 10, Font.ITALIC, blackColor);
	public static Font fontContentItalicGrey = new Font(Font.HELVETICA, 10, Font.ITALIC, greyColor);
    public static Font fontContentBold = new Font(Font.HELVETICA, 10, Font.BOLD, blackColor);
	public static Font fontContentBoldUnderline = new Font(Font.HELVETICA, 10, Font.BOLD|Font.UNDERLINE, blackColor);

	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
	 * methods.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
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
				if (leaveApplication.getRep_approval_1()>0){
					empApproval1 = PstEmployee.fetchExc(leaveApplication.getRep_approval_1());
				} else {
					empApproval1 = PstEmployee.fetchExc(leaveApplication.getApproval_1());
				}
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
			try {
				if (leaveApplication.getRep_approval_2()>0){
					empApproval2 = PstEmployee.fetchExc(leaveApplication.getRep_approval_2());
				} else {
					empApproval2 = PstEmployee.fetchExc(leaveApplication.getApproval_2());
				}
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
			try {
				if (leaveApplication.getRep_approval_3()>0){
					empApproval3 = PstEmployee.fetchExc(leaveApplication.getRep_approval_3());
				} else {
					empApproval3 = PstEmployee.fetchExc(leaveApplication.getApproval_3());
				}
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
			try {
				if (leaveApplication.getRep_approval_4()>0){
					empApproval4 = PstEmployee.fetchExc(leaveApplication.getRep_approval_4());
				} else {
					empApproval4 = PstEmployee.fetchExc(leaveApplication.getApproval_4());
				}
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
			try {
				if (leaveApplication.getRep_approval_5()>0){
					empApproval5 = PstEmployee.fetchExc(leaveApplication.getRep_approval_5());
				} else {
					empApproval5 = PstEmployee.fetchExc(leaveApplication.getApproval_5());
				}
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
			try {
				if (leaveApplication.getRep_approval_6()>0){
					empApproval6 = PstEmployee.fetchExc(leaveApplication.getRep_approval_6());
				} else {
					empApproval6 = PstEmployee.fetchExc(leaveApplication.getApproval_6());
				}
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
				//jumlahApp = jumlahApp + 1;
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

			if (leaveApplication.getTypeLeaveCategory() == 4 || leaveApplication.getTypeLeaveCategory() == 3){
				Al = "x";
			} if (leaveApplication.getTypeLeaveCategory() == 1){
				CH = "x";
			} if (leaveApplication.getTypeLeaveCategory() == 2){
				CP = "x";
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
			} else if (startWork.get(Calendar.DAY_OF_WEEK) == startWork.SUNDAY) {
			   startWork.add(Calendar.DATE, 1);
			} 

			SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
			String strWork = sdf.format(startWork.getTime());
			String strLeave = sdf.format(startLeave.getTime());
			String strEndLeave = sdf.format(endLeave.getTime());
			String submitDate = sdf.format(leaveApplication.getSubmissionDate());
			
			Vector leaveApp = new Vector();
            String whereLeave = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + employee.getEmployeeNum() + ""
                                + " AND " + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE] + " LIKE '%"+(leaveApplication.getSubmissionDate().getYear() + 1900)+"%'";
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
			
			String pejabatPos = "";
			String pejabatName = "";
			String appDate = "";
			String app1Division = "";
			String app1Position = "";
			String app1Date = "";
			String app1Name = "";
			String app1Payroll= "";
			String app2Division = "";
			String app2Position = "";
			String app2Date = "";
			String app2Name = "";
			String app2Payroll= "";
			if (leaveApplication.getHrManApproval() > 0){
                pejabatPos = hrPos1.getPosition();
				pejabatName = empHrApproval.getFullName();
				try {
					appDate = sdf.format(leaveApplication.getHrManApproveDate());
				} catch (Exception exc){}
            } else if (jumlahApp == 6){
				pejabatPos = empPos6.getPosition();    
				pejabatName = empApproval6.getFullName();  
				try {
				appDate = sdf.format(leaveApplication.getApproval_6_date());
				} catch (Exception exc){}
            } else if (jumlahApp == 5){
				pejabatPos = empPos5.getPosition();
				pejabatName = empApproval5.getFullName();
				try {
				appDate = sdf.format(leaveApplication.getApproval_5_date());
				} catch (Exception exc){}
            } else if (jumlahApp == 4){
				pejabatPos = empPos4.getPosition(); 
				pejabatName = empApproval4.getFullName();
				try {
				appDate = sdf.format(leaveApplication.getApproval_4_date());
				} catch (Exception exc){}
            } else if (jumlahApp == 3){
				pejabatPos = empPos3.getPosition();  
				pejabatName = empApproval3.getFullName();
				try {
				appDate = sdf.format(leaveApplication.getApproval_3_date());
				} catch (Exception exc){}
            } else if (jumlahApp == 2){
				pejabatPos = empPos2.getPosition();    
				pejabatName = empApproval2.getFullName();
				try {
				appDate = sdf.format(leaveApplication.getApproval_2_date());
				} catch (Exception exc){}
            } else if (jumlahApp == 1){
				pejabatPos = empPos1.getPosition();    
				pejabatName = empApproval1.getFullName();
				try {
				appDate = sdf.format(leaveApplication.getApproval_1_date());
				} catch (Exception exc){}
            }
			
			if (jumlahApp == 6){
				app1Division = empDiv5.getDivision();
				app1Position = empPos5.getPosition();
				try {
				app1Date = sdf.format(leaveApplication.getApproval_5_date());
				} catch (Exception exc){}
				app1Name = empApproval5.getFullName();
				app1Payroll = empApproval5.getEmployeeNum();
				app2Division = empDiv6.getDivision();
				app2Position = empPos6.getPosition();
				try {
				app2Date = sdf.format(leaveApplication.getApproval_6_date());
				} catch (Exception exc){}
				app2Name = empApproval6.getFullName();
				app2Payroll = empApproval6.getEmployeeNum();
            } else if (jumlahApp == 5){
				app1Division = empDiv4.getDivision();
				app1Position = empPos4.getPosition();
				try {
				app1Date = sdf.format(leaveApplication.getApproval_4_date());
				} catch (Exception exc){}
				app1Name = empApproval4.getFullName();
				app1Payroll = empApproval4.getEmployeeNum();
				app2Division = empDiv5.getDivision();
				app2Position = empPos5.getPosition();
				try {
				app2Date = sdf.format(leaveApplication.getApproval_5_date());
				} catch (Exception exc){}
				app2Name = empApproval5.getFullName();
				app2Payroll = empApproval5.getEmployeeNum();
            } else if (jumlahApp == 4){
				app1Division = empDiv3.getDivision();
				app1Position = empPos3.getPosition();
				try {
				app1Date = sdf.format(leaveApplication.getApproval_3_date());
				} catch (Exception exc){}
				app1Name = empApproval3.getFullName();
				app1Payroll = empApproval3.getEmployeeNum();
				app2Division = empDiv4.getDivision();
				app2Position = empPos4.getPosition();
				try {
				app2Date = sdf.format(leaveApplication.getApproval_4_date());
				} catch (Exception exc){}
				app2Name = empApproval4.getFullName();
				app2Payroll = empApproval4.getEmployeeNum();
            } else if (jumlahApp == 3){
				app1Division = empDiv2.getDivision();
				app1Position = empPos2.getPosition();
				try {
				app1Date = sdf.format(leaveApplication.getApproval_2_date());
				} catch (Exception exc){}
				app1Name = empApproval2.getFullName();
				app1Payroll = empApproval2.getEmployeeNum();
				app2Division = empDiv3.getDivision();
				app2Position = empPos3.getPosition();
				try {
				app2Date = sdf.format(leaveApplication.getApproval_3_date());
				} catch (Exception exc){}
				app2Name = empApproval3.getFullName();
				app2Payroll = empApproval3.getEmployeeNum();
            } else if (jumlahApp == 2){
				app1Division = "Atasan Langsung";
				app1Position = "";
				try {
				app1Date = sdf.format(leaveApplication.getApproval_1_date());
				} catch (Exception exc){}
				app1Name = empApproval1.getFullName();
				app1Payroll = empApproval1.getEmployeeNum();
				app2Division = empDiv2.getDivision();
				app2Position = empPos2.getPosition();
				try {
				app2Date = sdf.format(leaveApplication.getApproval_2_date());
				} catch (Exception exc){}
				app2Name = empApproval2.getFullName();
				app2Payroll = empApproval2.getEmployeeNum();
            } else if (jumlahApp == 1){
				app1Division = "Atasan Langsung";
				app1Position = "";
				try {
				app1Date = sdf.format(leaveApplication.getApproval_1_date());
				} catch (Exception exc){}
				app1Name = empApproval1.getFullName();
				app1Payroll = empApproval1.getEmployeeNum();
            }
			
			
			if (leaveApplication.getHrManApproval() > 0){
                
            } else if (jumlahApp == 6){
                              
            } else if (jumlahApp == 5){
                              
            } else if (jumlahApp == 4){
                                
            } else if (jumlahApp == 3){
                pejabatName = empApproval3.getFullName();                
            } else if (jumlahApp == 2){
                pejabatName = empApproval2.getFullName();                
            } else if (jumlahApp == 1){
                pejabatName = empApproval1.getFullName();                
            }
			
			/* TODO output your page here. You may use following sample code. */
			Document document = new Document(PageSize.A4, 50, 50, 25, 25);
			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			try {
				PdfWriter writer = PdfWriter.getInstance(document, baos);
				
				document.open(); 
				document.add(getTableHeader());
				document.add(getTableContent(employee, position, division, leaveApplication, alStockManagement,
						strWork, strLeave, strEndLeave, submitDate, takenQty, specialTaken));
				document.add(getTableApprovalV2(employee,position,leaveApplication, app1Division, app1Position,
					app1Date, app1Name, app1Payroll, app2Division,app2Position, 
					app2Date, app2Name, app2Payroll, submitDate));
				document.add(getTableLeaveStock(alStockManagement, leaveApplication, leaveQty, llStockManagement,
						takenQty, strWork, startLeave.getTime()));
				document.add(getTableLeaveStatus(leave_allowance));
				document.add(getTableLeaveStatus2(leave_allowance));
				document.add(getTablePejabat(pejabatPos, pejabatName, appDate));
				
			} catch(DocumentException de) 
			{
				System.err.println(de.getMessage());
				de.printStackTrace();
			}
			
			// closing the document 
			document.close();

			// we have written the pdfstream to a ByteArrayOutputStream, now going to write this outputStream to the ServletOutputStream
		// after we have set the contentlength        
			response.setContentType("application/pdf");
			response.setContentLength(baos.size());
			ServletOutputStream out = response.getOutputStream();
			baos.writeTo(out);
			out.flush();
	}
	
	public static Table getTableHeader() throws BadElementException, DocumentException, IOException {
			Table tableHeader = new Table(1);   
			tableHeader.setCellpadding(1);
            tableHeader.setBorderColor(whiteColor);
			int widthHeader[] = {100};
    	    tableHeader.setWidths(widthHeader);
            tableHeader.setWidth(100);
			
			Image logo = null;
			String imagePath = String.valueOf(PstSystemProperty.getValueByName("IMGCACHE"));
			String fullPath = imagePath + "BPD.jpg";
			logo = Image.getInstance(fullPath);
			logo.scalePercent(65);
			logo.setAlignment(Image.MIDDLE);
			
			Cell cellHeader = new Cell(new Chunk("",fontContentBold));    
			try {
                cellHeader.add(logo);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
			cellHeader.setVerticalAlignment(Cell.ALIGN_BOTTOM);
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
			tableHeader.addCell(cellHeader);
			
			cellHeader = new Cell(new Chunk("PT. BANK PEMBANGUNAN DAERAH BALI",fontContentBold));            
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
            tableHeader.addCell(cellHeader);
			
			cellHeader = new Cell(new Chunk("(the regional development bank of bali)",fontContent));            
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
            tableHeader.addCell(cellHeader);
			
			cellHeader = new Cell(new Chunk("kantor pusat/head office : jalan raya puputan, niti mandala, denpasar (bali), indonesia, tlp/phone : 223301-8 (8 saluran/8 lines), fax : 235806 telex : 35168 bpd dpr ia",fontContentSmall));            
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
            tableHeader.addCell(cellHeader);
			
			cellHeader = new Cell(new Chunk("PERMOHONAN IZIN CUTI",fontContentBoldUnderline));            
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
            tableHeader.addCell(cellHeader);
			
			cellHeader = new Cell(new Chunk("",fontContent));            
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(whiteColor);
            tableHeader.addCell(cellHeader);
			
			return tableHeader;
	}

        public static Table getTableContent(Employee employee, Position position, Division division, LeaveApplication leaveApplication, AlStockManagement alStockManagement, String strWork, String strLeave, String strEndLeave, String submitDate, int takenQty, Vector specialTaken) throws BadElementException, DocumentException, IOException {
            Table tableContent = new Table(9);
            tableContent.setCellpadding(1);
            tableContent.setBorderColor(whiteColor);
            int widthContent[] = {15, 10, 50, 15, 10, 10, 20, 10, 30};
            tableContent.setWidths(widthContent);
            tableContent.setWidth(100);

            String Al = "    ";
            String CH = "    ";
            String S = "    ";
            String CP = "    ";
            String CT = "    ";

            if (leaveApplication.getTypeLeaveCategory() == 4 || leaveApplication.getTypeLeaveCategory() == 3) {
                Al = " x ";
            }
            if (leaveApplication.getTypeLeaveCategory() == 1) {
                CH = " x ";
            }
            if (leaveApplication.getTypeLeaveCategory() == 2) {
                CP = " x ";
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

            /*row 1*/
            Cell cellContent = new Cell(new Chunk("Nama", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + employee.getFullName(), fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("NRK", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + employee.getEmployeeNum(), fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 2*/
            cellContent = new Cell(new Chunk("Jabatan", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + position.getPosition() + " " + division.getDivision(), fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(7);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 3 blankspace*/
            cellContent = new Cell(new Chunk("", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(9);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 4 */
            cellContent = new Cell(new Chunk("JENIS CUTI YANG DIMINTA", fontContentBoldUnderline));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(9);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 5 blankspace*/
            cellContent = new Cell(new Chunk("", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(9);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 6 */
            Phrase phrase = new Phrase();
            phrase.add(new Chunk("1    Cuti ", fontContent));
            if (alStockManagement.getAlQty() > 0) {
                phrase.add(new Chunk("Tahunan / ", fontContent));
                phrase.add(new Chunk("Besar", fontContentStrikeThrou));
            } else {
                phrase.add(new Chunk("Tahunan", fontContentStrikeThrou));
                phrase.add(new Chunk(" / Besar", fontContent));
            }
            phrase.add(new Chunk(" .................................", fontContent));
            cellContent = new Cell(phrase);
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("( " + Al + " )", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("Tgl. Masuk Kerja ", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + strWork, fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 7 */
            cellContent = new Cell(new Chunk("2    Cuti Sakit ....................................................", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("( " + S + " )", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("Cuti yang diminta ", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + takenQty + " hari", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 8 */
            cellContent = new Cell(new Chunk("3    Cuti Bersalin ...............................................", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("( " + CH + " )", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("Tanggal ", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + strLeave, fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 9 */
            cellContent = new Cell(new Chunk("4    Cuti karena Alasan Penting ........................", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("( " + CP + " )", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("Sampai dengan tanggal ", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + strEndLeave, fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            //>>> ADDED BY DEWOK 2019-05-28
            /*row 10 */
            cellContent = new Cell(new Chunk("5    Cuti Tambahan ...........................................", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(3);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("( " + CT + " )", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(6);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);
            //<<< ADDED BY DEWOK 2019-05-28
            
            /*row 11 blankspace*/
            cellContent = new Cell(new Chunk("", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(9);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            /*row 12*/
            cellContent = new Cell(new Chunk("Alasan", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk(":", fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            cellContent = new Cell(new Chunk("" + leaveApplication.getLeaveReason(), fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setColspan(2);
            cellContent.setBorderColor(blackColor);
            cellContent.setBorderWidth(1.5f);
            cellContent.setBackgroundColor(whiteColor);
            tableContent.addCell(cellContent);

            return tableContent;
        }

	public static Table getTableApproval(Employee employee, Position position,
			LeaveApplication leaveApplication, Employee employee1, Position position1,
			Employee employee2, Position position2, String submitDate, Division division2) throws BadElementException, DocumentException, IOException {
			Table tableApproval = new Table(3);   
			tableApproval.setCellpadding(1);
            tableApproval.setBorderColor(whiteColor);
			int widthApproval[] = {30,30,30};
    	    tableApproval.setWidths(widthApproval);
            tableApproval.setWidth(100);
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
			String approval1 = "";
			String approval2 = "";
			
			try {
				approval1 = sdf.format(leaveApplication.getApproval_1_date());
			} catch (Exception exc){}
			
			try {
				approval2 = sdf.format(leaveApplication.getApproval_2_date());
			} catch (Exception exc){}
			
			/*row 1 blankspace*/
			Cell cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellApproval.setColspan(3);
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 2*/
			cellApproval = new Cell(new Chunk("Mengetahui",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Mengetahui",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Denpasar,"+submitDate,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 3*/
			cellApproval = new Cell(new Chunk(""+division2.getDivision(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Atasan Langsung",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Yang Memohon,",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 4*/
			cellApproval = new Cell(new Chunk(""+position2.getPosition(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 5*/
			cellApproval = new Cell(new Chunk("Approved",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Approved",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Created through The Sistem",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 6*/
			cellApproval = new Cell(new Chunk(""+approval2,fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+approval1,fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 7*/
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 8*/
			cellApproval = new Cell(new Chunk(""+employee2.getFullName(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+employee1.getFullName(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+employee.getFullName(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 9*/
			cellApproval = new Cell(new Chunk("NRK."+employee2.getEmployeeNum(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("NRK."+employee1.getEmployeeNum(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("NRK."+employee.getEmployeeNum(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 10 blankspace*/
			cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellApproval.setColspan(3);
			cellApproval.setBorder(Rectangle.BOTTOM);
			cellApproval.setBorderColor(blackColor);
			cellApproval.setBorderWidth(1.5f);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			return tableApproval;
	}
	
	public static Table getTableApprovalV2(Employee employee, Position position,
				LeaveApplication leaveApplication, String app1Division, String app1Position,
				String app1Date, String app1Name, String app1Payroll, String app2Division,
				String app2Position, String app2Date, String app2Name, String app2Payroll, 
				String submitDate) throws BadElementException, DocumentException, IOException {
		
			Table tableApproval = new Table(3);   
			tableApproval.setCellpadding(1);
            tableApproval.setBorderColor(whiteColor);
			int widthApproval[] = {30,30,30};
    	    tableApproval.setWidths(widthApproval);
            tableApproval.setWidth(100);
			
			
			/*row 1 blankspace*/
			Cell cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellApproval.setColspan(3);
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 2*/
			cellApproval = new Cell(new Chunk("Mengetahui",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Mengetahui",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Denpasar,"+submitDate,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 3*/
			cellApproval = new Cell(new Chunk(""+app2Division,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+app1Division,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Yang Memohon,",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 4*/
			cellApproval = new Cell(new Chunk(""+app2Position,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+app1Position,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 5*/
			cellApproval = new Cell(new Chunk("Approved",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Approved",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("Created through The Sistem",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 6*/
			cellApproval = new Cell(new Chunk(""+app2Date,fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+app1Date,fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 7*/
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("By",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("",fontContentItalicGrey));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 8*/
			cellApproval = new Cell(new Chunk(""+app2Name,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+app1Name,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk(""+employee.getFullName(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 9*/
			cellApproval = new Cell(new Chunk("NRK."+app2Payroll,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("NRK."+app1Payroll,fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			cellApproval = new Cell(new Chunk("NRK."+employee.getEmployeeNum(),fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE);            
            cellApproval.setBorderColor(whiteColor);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			/*row 10 blankspace*/
			cellApproval = new Cell(new Chunk("",fontContent));            
            cellApproval.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellApproval.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellApproval.setColspan(3);
			cellApproval.setBorder(Rectangle.BOTTOM);
			cellApproval.setBorderColor(blackColor);
			cellApproval.setBorderWidth(1.5f);
            cellApproval.setBackgroundColor(whiteColor);
            tableApproval.addCell(cellApproval);
			
			return tableApproval;
	}
	
	public static Table getTableLeaveStock(AlStockManagement alStockManagement,
			LeaveApplication leaveApplication, int leaveQty, 
			LLStockManagement llStockManagement, int takenQty, String strWork, Date takenDate) throws BadElementException, DocumentException, IOException {
			Table tableLeaveStock = new Table(6);   
			tableLeaveStock.setCellspacing(2);
			tableLeaveStock.setBorderColor(whiteColor);
			int widthtableLeaveStock[] = {13, 7, 30, 30,10, 10};
    	    tableLeaveStock.setWidths(widthtableLeaveStock);
            tableLeaveStock.setWidth(100);
			
			/*row 2*/
			Cell cellLeaveStock = new Cell(new Chunk("KOLOM DIISI KHUSUS OLEH PERSONALIA",fontContentBoldUnderline));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(6);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			/* row 3 */
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(6);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			Date dtNow = new Date();
            Calendar dt = Calendar.getInstance();
            dt.setTime(takenDate);
			/*row 4*/
			cellLeaveStock = new Cell(new Chunk("Jumlah Cuti seluruhnya      "+dt.getWeekYear(),fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			int Qty = 0;
            if (alStockManagement.getAlQty() > 0){
                Qty = convertInteger(alStockManagement.getEntitled());
            } else {
                Qty = convertInteger(llStockManagement.getEntitled());
            }
			
			cellLeaveStock = new Cell(new Chunk(Qty+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			/*row 4*/
			cellLeaveStock = new Cell(new Chunk("Jumlah cuti tahun sebelumnya",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			int prevQty = 0;
            if (alStockManagement.getAlQty() > 0){
                prevQty = convertInteger(alStockManagement.getPrevBalance());
            } else {
                prevQty = convertInteger(llStockManagement.getPrevBalance());
            }
			
			cellLeaveStock = new Cell(new Chunk(prevQty+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			/*row 5*/
			cellLeaveStock = new Cell(new Chunk("Jumlah cuti seluruhnya",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			int totalQty = Qty + prevQty;
			
			cellLeaveStock = new Cell(new Chunk(totalQty+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
			cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
            int usedQty = 0;
            if (alStockManagement.getAlQty() > 0){
                usedQty = convertInteger(PstAlStockTaken.getPreviousLeaveQty(alStockManagement.getOID(), takenDate));
            } else {
                usedQty = convertInteger(PstLlStockTaken.getPreviousLeaveQty(llStockManagement.getOID(), takenDate));
            }
//            if (leaveApplication.getDocStatus() == 3){
//                usedQty = Math.abs(usedQty - leaveQty);
//            }
			
			/*row 6*/
			cellLeaveStock = new Cell(new Chunk("Jumlah cuti yang telah dipergunakan",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
			cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk(usedQty+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			/*row 7*/
			cellLeaveStock = new Cell(new Chunk("Sisa cuti seluruhnya",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			int balance = totalQty - usedQty;
			
			cellLeaveStock = new Cell(new Chunk(balance+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
			cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			/*row 8*/
			cellLeaveStock = new Cell(new Chunk("Jumlah cuti yang diminta saat ini",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
			cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk(leaveQty+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorder(Rectangle.BOTTOM);
			cellLeaveStock.setBorderWidth(1f);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			int totBalance = balance - leaveQty;
			
			/*row 9*/
			cellLeaveStock = new Cell(new Chunk("Sisa cuti pada tanggal   "+strWork,fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setColspan(3);
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
            cellLeaveStock.setBorderColor(whiteColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk(totBalance+"",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
			cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			cellLeaveStock = new Cell(new Chunk("hari",fontContent));            
            cellLeaveStock.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellLeaveStock.setVerticalAlignment(Cell.ALIGN_MIDDLE); 
			cellLeaveStock.setBorder(Rectangle.TOP);
            cellLeaveStock.setBorderColor(blackColor);
            cellLeaveStock.setBackgroundColor(whiteColor);
            tableLeaveStock.addCell(cellLeaveStock);
			
			return tableLeaveStock;
	}
	
	public static Table getTableLeaveStatus(boolean leaveAllowance) throws BadElementException, DocumentException, IOException {
			Table tableLeaveStatus = new Table(4);  
			tableLeaveStatus.setBorderColor(whiteColor);
			int widthtableLeaveStatus[] = {13, 2, 7, 80};
    	    tableLeaveStatus.setWidths(widthtableLeaveStatus);
            tableLeaveStatus.setWidth(100);
			
			/*row 1*/
			Cell cellLeaveStatus = new Cell(new Chunk("Uang Cuti :",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk(""+(leaveAllowance ? "x" : ""),fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("  telah dibayar",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorder(Rectangle.LEFT);
			cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			return tableLeaveStatus;
	}
	
	public static Table getTableLeaveStatus2(boolean leaveAllowance) throws BadElementException, DocumentException, IOException {
			Table tableLeaveStatus = new Table(4);  
			tableLeaveStatus.setBorderColor(whiteColor);
			int widthtableLeaveStatus[] = {13, 2, 7, 80};
    	    tableLeaveStatus.setWidths(widthtableLeaveStatus);
            tableLeaveStatus.setWidth(100);
			
			/*row 1*/
			Cell 
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk(""+(!leaveAllowance ? "x" : ""),fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("  belum dibayar",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorder(Rectangle.LEFT);
			cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			return tableLeaveStatus;
	}
	
	public static Table getTablePejabat(String position, String name, String date) throws BadElementException, DocumentException, IOException {
			Table tableLeaveStatus = new Table(4);  
			tableLeaveStatus.setBorderColor(whiteColor);
			int widthtableLeaveStatus[] = {5, 7, 37, 50};
    	    tableLeaveStatus.setWidths(widthtableLeaveStatus);
            tableLeaveStatus.setWidth(100);
			
			/*row 1*/
			Cell cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
			cellLeaveStatus.setColspan(4);
			cellLeaveStatus.setBorder(Rectangle.TOP);
			cellLeaveStatus.setBorderWidth(1.5f);
			cellLeaveStatus.setBorderColor(blackColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 2 */
			cellLeaveStatus = new Cell(new Chunk("PERSETUJUAN PEJABAT PEMUTUS",fontContentBold));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
			cellLeaveStatus.setColspan(3);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("PEJABAT PEMUTUS",fontContentBold));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 3 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
			cellLeaveStatus.setColspan(3);
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("PT. Bank Pembangunan Daerah Bali",fontContentBold));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 4 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			
			cellLeaveStatus = new Cell(new Chunk("  DISETUJUI",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorder(Rectangle.LEFT);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk(""+position,fontContentBold));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 5 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorder(Rectangle.TOP);
			cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("Approved",fontContentGrey));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 6 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			
			cellLeaveStatus = new Cell(new Chunk("  DITOLAK",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorder(Rectangle.LEFT);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk(""+date,fontContentGrey));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 7 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorder(Rectangle.TOP);
			cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("By",fontContentGrey));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			/* row 8 */
			cellLeaveStatus = new Cell(new Chunk("",fontContentBold));   
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk("",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			
			cellLeaveStatus = new Cell(new Chunk("  DITUNDA",fontContent));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_LEFT);
			cellLeaveStatus.setVerticalAlignment(Element.ALIGN_MIDDLE); 
            cellLeaveStatus.setBorderColor(blackColor);
			cellLeaveStatus.setBorder(Rectangle.LEFT);
			cellLeaveStatus.setBorderWidth(1f);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			cellLeaveStatus = new Cell(new Chunk(""+name,fontContentBoldUnderline));            
            cellLeaveStatus.setHorizontalAlignment(Cell.ALIGN_CENTER);
			cellLeaveStatus.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellLeaveStatus.setBorderColor(whiteColor);
            cellLeaveStatus.setBackgroundColor(whiteColor);
            tableLeaveStatus.addCell(cellLeaveStatus);
			
			return tableLeaveStatus;
	}
	
	public static int convertInteger(double val){
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

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**
	 * Handles the HTTP <code>GET</code> method.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Handles the HTTP <code>POST</code> method.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Returns a short description of the servlet.
	 *
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

}
