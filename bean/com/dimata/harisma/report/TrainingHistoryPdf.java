/*
 * EmployeeDetailPdf.java
 *
 * Created on June 23, 2003, 3:02 PM
 */
package com.dimata.harisma.report;

import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import java.util.*;
import java.sql.*;
import java.awt.Color;
import java.awt.Point;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;

import javax.servlet.*;
import javax.servlet.http.*;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;

import com.dimata.util.*;
import com.dimata.qdep.form.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.system.entity.*;
import com.dimata.harisma.session.employee.*;
import java.util.Date;

public class TrainingHistoryPdf extends HttpServlet {

    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        System.out.println("===| EmployeeDetailPdf |===");
        long companyId = FRMQueryString.requestLong(request, "company_id");
        long divisionId = FRMQueryString.requestLong(request, "division_id");
        long departmentId = FRMQueryString.requestLong(request, "department_id");
        long sectionId = FRMQueryString.requestLong(request, "section_id");
        String empName = FRMQueryString.requestString(request, "emp_name");
        String empNum = FRMQueryString.requestString(request, "emp_num");
        
        
        Vector listEmployee = new Vector();
        Vector listTrainingHistory = new Vector();
        String whereClauseEmp = "";
        String whereTrain = "";
        String whereClause = "";
        Vector<String> whereCollect = new Vector<String>();
        ChangeValue changeValue = new ChangeValue();

        if (companyId != 0){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
            whereCollect.add(whereClauseEmp);
        }
        if (divisionId != 0){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
            whereCollect.add(whereClauseEmp);
        }
        if (departmentId != 0){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
            whereCollect.add(whereClauseEmp);
        }
        if (sectionId != 0){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
            whereCollect.add(whereClauseEmp);
        }
        if (empName.length() > 1){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
            whereCollect.add(whereClauseEmp);
        }
        if (empNum.length() > 1){
            whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+empNum+"'";
            whereCollect.add(whereClauseEmp);
        }

        if (whereCollect != null && whereCollect.size()>0){
            whereClauseEmp = "";
            for (int i=0; i<whereCollect.size(); i++){
                String where = (String)whereCollect.get(i);
                whereClauseEmp += where;
                if (i < (whereCollect.size()-1)){
                     whereClauseEmp += " AND ";
                }
            }
        }
        if (whereClauseEmp.length() > 0){
            listEmployee = PstEmployee.list(0, 0, whereClauseEmp, "");
            whereClauseEmp = "";
            if (listEmployee != null && listEmployee.size()>0){
                for(int e=0; e<listEmployee.size(); e++){
                    Employee emp = (Employee)listEmployee.get(e);
                    whereClauseEmp += emp.getOID()+",";
                }
                whereClauseEmp = whereClauseEmp.substring(0, whereClauseEmp.length()-1);
            }
            listTrainingHistory = PstTrainingHistory.listJoinEmpTrainingVersi1(whereClauseEmp);
        }
        
        NumberSpeller numSpeller = new NumberSpeller();

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontHeaderSmall = new Font(Font.HELVETICA, 6, Font.NORMAL, border);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 8, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.HELVETICA, 8, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);

        Color blackColor = new Color(0, 0, 0);

        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 50, 50);
        //Document document = new Document(PageSize.A4.rotate(), 10, 10, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int start = 0;

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            String str = PstSystemProperty.getValueByName("PRINT_HEADER");

            //Header 
            HeaderFooter header = new HeaderFooter(new Phrase(str, fontHeaderSmall), false);
            header.setAlignment(Element.ALIGN_LEFT);
            header.setBorder(Rectangle.BOTTOM);
            header.setBorderColor(blackColor);
            document.setHeader(header);

            HeaderFooter footer = new HeaderFooter(new Phrase("printed : " + Formater.formatDate(new Date(), "dd/MM/yyyy"), fontHeaderSmall), false);
            footer.setAlignment(Element.ALIGN_RIGHT);
            footer.setBorder(Rectangle.TOP);
            footer.setBorderColor(blackColor);
            document.setFooter(footer);

            // step 3.4: opening the document
            document.open();

            //Personal Data

            int personalHeaderTop[] = {30, 2, 20, 5, 40, 5, 10, 5, 20};
            Table personTable = new Table(9);
            personTable.setWidth(100);
            personTable.setWidths(personalHeaderTop);
            personTable.setBorderColor(new Color(255, 255, 255));
            personTable.setBorderWidth(1);
            personTable.setAlignment(1);
            personTable.setCellpadding(0);
            personTable.setCellspacing(1);

            //0
            Cell titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop = new Cell(new Chunk("TRAINING HISTORY", fontHeaderBig));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setColspan(9);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(9);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            //1Employee Number
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setRowspan(7);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_TOP);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);
            //end space
            
            document.add(personTable);

            //TRANING HISTORY 
            
            if (listEmployee != null && listEmployee.size()>0){
                for (int x=0; x< listEmployee.size();x++){
                    Employee emp = (Employee) listEmployee.get(x);
                    listTrainingHistory = PstTrainingHistory.listJoinEmpTrainingVersi1(""+emp.getOID());
                    int employeeHeaderTop[] = {10,1,30,5,10,1,30,13};
                    Table employeeTable = new Table(8);
                    employeeTable.setWidth(100);
                    employeeTable.setWidths(employeeHeaderTop);
                    employeeTable.setBorderColor(new Color(255, 255, 255));
                    employeeTable.setBorderWidth(1);
                    employeeTable.setAlignment(1);
                    employeeTable.setCellpadding(0);
                    employeeTable.setCellspacing(1);
                    
                    // Row 1
                    Cell employeeCellTop = new Cell(new Chunk("NRK", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(emp.getEmployeeNum(), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("Satuan Kerja", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(PstEmployee.getDivisionName(emp.getDivisionId()), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    //end Row 1
                    
                    //Row 2
                    employeeCellTop = new Cell(new Chunk("Nama", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(emp.getFullName(), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("Unit", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(PstEmployee.getDepartmentName(emp.getDepartmentId()), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    //End Row 2
                    
                    //Row 3
                    employeeCellTop = new Cell(new Chunk("Jabatan", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(PstEmployee.getPositionName(emp.getPositionId()), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("Level", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(":", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk(PstEmployee.getLevelName(emp.getLevelId()), fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    
                    employeeCellTop = new Cell(new Chunk("", fontHeader));
                    employeeCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    employeeCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    employeeCellTop.setBorderColor(new Color(255, 255, 255));
                    employeeTable.addCell(employeeCellTop);
                    //End Row 3
                    if (listTrainingHistory != null && listTrainingHistory.size() > 0) {

                        //membuat table Career Profile
                        int careerHeaderTop[] = {10, 10, 10, 10, 10, 10,10};
                        Table careerTable = new Table(7);
                        careerTable.setWidth(100);
                        careerTable.setWidths(careerHeaderTop);
                        careerTable.setBorderColor(new Color(255, 255, 255));
                        careerTable.setBorderWidth(1);
                        careerTable.setAlignment(1);
                        careerTable.setCellpadding(0);
                        careerTable.setCellspacing(1);

                        //1
                        Cell titleCareerCellTop = new Cell(new Chunk("No", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        titleCareerCellTop = new Cell(new Chunk("Satuan Kerja", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        titleCareerCellTop = new Cell(new Chunk("Judul Pelatihan", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        titleCareerCellTop = new Cell(new Chunk("Program Pelatihan", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        titleCareerCellTop = new Cell(new Chunk("Tanggal Pelaksana", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        titleCareerCellTop = new Cell(new Chunk("Tempat", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);
                        
                        titleCareerCellTop = new Cell(new Chunk("Penyelengara", fontHeader));
                        titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                        titleCareerCellTop.setBackgroundColor(bgColor);
                        careerTable.addCell(titleCareerCellTop);

                        //value-valuenya

                        for (int i = 0; i < listTrainingHistory.size(); i++) {
                            String[] data = (String[]) listTrainingHistory.get(i);
                            TrainingActivityActual actual = new TrainingActivityActual();
                            try {
                                actual = PstTrainingActivityActual.fetchExc(Long.valueOf(data[6]));
                            } catch(Exception e){
                                System.out.print("=>"+e.toString());
                            }
                            
                            
                            //1

                            titleCareerCellTop = new Cell(new Chunk(""+(i+1), tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                            /*  int digit = cr.getDepartment().length();
                             String potS = cr.getDepartment();
                             if(digit > 20){
                             potS = potS.substring(0,20);
                             potS = potS + ".....";
                             }*/
                            titleCareerCellTop = new Cell(new Chunk(changeValue.getDivisionName(Long.valueOf(data[2])), tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                            titleCareerCellTop = new Cell(new Chunk(data[4], tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                            titleCareerCellTop = new Cell(new Chunk(data[5], tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                            titleCareerCellTop = new Cell(new Chunk(data[7], tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                            titleCareerCellTop = new Cell(new Chunk(actual.getVenue(), tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);
                            
                            titleCareerCellTop = new Cell(new Chunk(data[8], tableContent));
                            titleCareerCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                            titleCareerCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            titleCareerCellTop.setBorderColor(new Color(255, 255, 255));
                            careerTable.addCell(titleCareerCellTop);

                        }
                        document.add(employeeTable);    
                        document.add(careerTable);
                    }
                }
            }
            

            //Header Traning
           
        } catch (Exception e) {
            System.out.println("PRINT EMPLOYEE DATA ==>" + e);
        }

        document.close();

        System.out.println("print==============");
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
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
    
    /* Update by Hendra Putu | 2015-11-04 */
    public String getRelationName(String oids){
        String str = "-";
        long oid = Long.valueOf(oids);
        try {
            FamRelation famRelation = PstFamRelation.fetchExc(oid);
            str = famRelation.getFamRelation();
        } catch(Exception e){
            System.out.println(e.toString());
        }
        return str;
    }
}
