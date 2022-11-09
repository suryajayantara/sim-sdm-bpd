/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.payroll.PayPeriod;
import com.dimata.harisma.entity.payroll.PstPayPeriod;
import com.dimata.harisma.entity.payroll.PstPaySlip;
import com.dimata.qdep.form.FRMQueryString;
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

/**
 *
 * @author Dimata 007
 */
public class SalaryFormXLS extends HttpServlet {
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
        response.setHeader("Content-Disposition","attachment;filename= import_gaji.xls");
        String[] divisionSelect = FRMQueryString.requestStringValues(request, "division_select");
        String[] benefitSelect = FRMQueryString.requestStringValues(request, "benefit_select");
        String[] deductionSelect = FRMQueryString.requestStringValues(request, "deduction_select");
        String pay_period = FRMQueryString.requestString(request, "pay_period");
        String whereClause = "";
		
		String wherePayPeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_PERIOD]+"='"+pay_period+"'";
		Vector listPayPeriod = PstPayPeriod.list(0, 0, wherePayPeriod, "");
		PayPeriod payPeriod = new PayPeriod();
		if (listPayPeriod.size()>0){
			payPeriod = (PayPeriod) listPayPeriod.get(0);
		}
		
        
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet(pay_period);

        HSSFCellStyle style1 = wb.createCellStyle();
        style1.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style1.setBorderRight(HSSFCellStyle.BORDER_THIN);        
        
        HSSFCellStyle style2 = wb.createCellStyle();
        style2.setFillBackgroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style2.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        HSSFFont font = wb.createFont();
        font.setColor(HSSFColor.BLACK.index);
        style2.setFont(font);

        HSSFCellStyle style3 = wb.createCellStyle();
        style3.setFillBackgroundColor(new HSSFColor.LIME().getIndex());
        style3.setFillForegroundColor(new HSSFColor.LIME().getIndex());
        style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style3.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style3.setBorderRight(HSSFCellStyle.BORDER_THIN);

        HSSFRow row = sheet.createRow((short) 0);
        HSSFCell cell = row.createCell((short) 0);
        
        
        int countRow = 0;
        int coloum = 0;
        row = sheet.createRow((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("No");
        cell.setCellStyle(style2);
        
        cell = row.createCell((short) 1);
        cell.setCellValue("Emp Num");
        cell.setCellStyle(style2);
        
        cell = row.createCell((short) 2);
        cell.setCellValue("Name");
        cell.setCellStyle(style2);
        coloum = 2;
        if (benefitSelect != null){
            for(int i=0; i<benefitSelect.length; i++){
                coloum++;
                cell = row.createCell((short) coloum);
                cell.setCellValue(benefitSelect[i]);
                cell.setCellStyle(style2);
            }
        }
        
        if (deductionSelect != null){
            for(int i=0; i<deductionSelect.length; i++){
                coloum++;
                cell = row.createCell((short) coloum);
                cell.setCellValue(deductionSelect[i]);
                cell.setCellStyle(style2);
            }
        }
        int baris = 1;
        if (divisionSelect != null){
            for(int i=0; i<divisionSelect.length; i++){
                whereClause = "slip."+PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]+"='"+divisionSelect[i]+"'"
						+" AND slip."+PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+payPeriod.getOID();
                Vector employeeList = PstEmployee.listJoinSlip(0, 0, whereClause, "");
                if (employeeList != null && employeeList.size()>0){
                    for(int j=0; j<employeeList.size(); j++){
                        Employee emp = (Employee)employeeList.get(j);
                        row = sheet.createRow((short) baris);
                        cell = row.createCell((short) 0);
                        cell.setCellValue(baris);
                        cell.setCellStyle(style1);
                        
                        cell = row.createCell((short) 1);
                        cell.setCellValue(emp.getEmployeeNum());
                        cell.setCellStyle(style1);
                        
                        cell = row.createCell((short) 2);
                        cell.setCellValue(emp.getFullName());
                        cell.setCellStyle(style1);
                        for (int k=3; k<=coloum; k++){
                            cell = row.createCell((short) k);
                            cell.setCellValue("-");
                            cell.setCellStyle(style1);
                        }
                        baris++;
                    }
                }
            }
        }
        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
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
