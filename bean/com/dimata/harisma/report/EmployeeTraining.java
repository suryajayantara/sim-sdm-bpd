/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

/**
 *
 * @author Acer
 */


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
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.system.entity.*;
import com.dimata.harisma.session.employee.*;
import java.util.Date;

public class EmployeeTraining extends HttpServlet{
    
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
        long oidEmployee = FRMQueryString.requestLong(request, "oid");

        Employee employee = new Employee();
        Department department = new Department();
        com.dimata.harisma.entity.masterdata.Section section = new com.dimata.harisma.entity.masterdata.Section();
        Position position = new Position();
        EmpCategory empCategory = new EmpCategory();
        Level level = new Level();
        GradeLevel gLvl = new GradeLevel();

        TrainingHistory tr = new TrainingHistory();

        try {
            employee = PstEmployee.fetchExc(oidEmployee);
            
            
            if (employee.getDepartmentId() != 0){
                department = PstDepartment.fetchExc(employee.getDepartmentId());
            }
            if (employee.getSectionId() != 0){
                section = PstSection.fetchExc(employee.getSectionId());
            }
            if (employee.getPositionId() != 0){
                position = PstPosition.fetchExc(employee.getPositionId());
            }
            if (employee.getEmpCategoryId() != 0){
                empCategory = PstEmpCategory.fetchExc(employee.getEmpCategoryId());
            }
            if (employee.getLevelId() != 0){
                level = PstLevel.fetchExc(employee.getLevelId());
            }
            if (employee.getGradeLevelId() != 0){
                gLvl = PstGradeLevel.fetchExc(employee.getGradeLevelId());
            }
            
        } catch (Exception e) {
        }


        

        Vector vTraning = PstTrainingHistory.list(0, 0, "employee_id=" + employee.getOID() + "", "START_DATE ASC");
        if (vTraning != null && vTraning.size() > 0) {
            tr = (TrainingHistory) vTraning.get(0);
        }

        

        //end load - file    

        
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
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("EMPLOYEE TRAINING HISTORY ", fontHeaderBig));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setColspan(7);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(9);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            //1Employee Number
            
            titleCellTop = new Cell(new Chunk("Employee Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(employee.getEmployeeNum(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            //add space
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);
            //end space 

            //2 Nama
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk("Name", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(employee.getFullName(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255, 255, 255));
            personTable.addCell(titleCellTop);

                  

            document.add(personTable);

            
            //LAST CARRIER
            int lastCarrierHeaderTop[] = {24, 5, 45, 5, 25, 5, 40};
            Table lastCarrierTable = new Table(7);
            lastCarrierTable.setWidth(100);
            lastCarrierTable.setWidths(lastCarrierHeaderTop);
            lastCarrierTable.setBorderColor(blackColor);
            lastCarrierTable.setBorderWidth(0);
            lastCarrierTable.setAlignment(1);
            lastCarrierTable.setCellpadding(0);
            lastCarrierTable.setCellspacing(1);


            Cell titleCellCarrierTop = new Cell(new Chunk(" ", tableContent));
            titleCellCarrierTop.setColspan(7);
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            
            titleCellCarrierTop = new Cell(new Chunk("NRK", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(employee.getEmployeeNum(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);
            
            titleCellCarrierTop = new Cell(new Chunk("", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);
            
            titleCellCarrierTop = new Cell(new Chunk("EMPLOYEE NAME", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(employee.getFullName(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);
            
            Division div = new Division();
            try {
                div = PstDivision.fetchExc(employee.getDivisionId());
            } catch (Exception exx) {
                System.out.println(exx.toString());
            }

            //1Division
            titleCellCarrierTop = new Cell(new Chunk("Division", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(div.getDivision(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            //titleCellCarrierTop.setBorder(Rectangle.BOTTOM);
            lastCarrierTable.addCell(titleCellCarrierTop);

            
            //2Department
            titleCellCarrierTop = new Cell(new Chunk("Department", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk("" + department.getDepartment(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            

            //3 Section
            titleCellCarrierTop = new Cell(new Chunk("Section", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk("" + section.getSection(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);
            
            titleCellCarrierTop = new Cell(new Chunk("", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);
            
            titleCellCarrierTop = new Cell(new Chunk("Position", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk("" + position.getPosition(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            

            //4 Locker
           /* titleCellCarrierTop = new Cell(new Chunk("Locker", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            titleCellCarrierTop = new Cell(new Chunk(":", tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);

            LockerLocation lock = new LockerLocation();
            try {
                lock = PstLockerLocation.fetchExc(employee.getLockerId());
            } catch (Exception ev) {
                System.out.println(ev.toString());
            }

            titleCellCarrierTop = new Cell(new Chunk("" + lock.getLocation(), tableContent));
            titleCellCarrierTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellCarrierTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellCarrierTop.setBorderColor(new Color(255, 255, 255));
            lastCarrierTable.addCell(titleCellCarrierTop);
*/
                 
            

            // end space
            
            

            //TRANING HISTORY 

            //Header Traning
            if (vTraning != null && vTraning.size() > 0) {

                int traningHeader[] = {10, 10, 10, 10, 10, 10};
                Table traningTableH = new Table(6);
                traningTableH.setWidth(100);
                traningTableH.setWidths(traningHeader);
                traningTableH.setBorderColor(new Color(255, 255, 255));
                traningTableH.setBorderWidth(1);
                traningTableH.setAlignment(1);
                traningTableH.setCellpadding(0);
                traningTableH.setCellspacing(1);


                //0(Traning Header)
                Cell titleTraningCell = new Cell(new Chunk("", fontHeader));
                titleTraningCell.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCell.setColspan(6);
                titleTraningCell.setBorderColor(new Color(255, 255, 255));
                traningTableH.addCell(titleTraningCell);

                titleTraningCell = new Cell(new Chunk("Traning History : ", fontHeader));
                titleTraningCell.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCell.setColspan(6);
                titleTraningCell.setBorderColor(new Color(255, 255, 255));
                traningTableH.addCell(titleTraningCell);

                document.add(traningTableH);
            }

            if (vTraning != null && vTraning.size() > 0) {

                //membuat table Traning
                int familyTraningTop[] = {10, 10, 5, 10, 10, 10};
                Table traningTable = new Table(6);
                traningTable.setWidth(100);
                traningTable.setWidths(familyTraningTop);
                traningTable.setBorderColor(new Color(255, 255, 255));
                traningTable.setBorderWidth(1);
                traningTable.setAlignment(1);
                traningTable.setCellpadding(0);
                traningTable.setCellspacing(1);

                //1
                Cell titleTraningCellTop = new Cell(new Chunk("Program", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);
                traningTable.addCell(titleTraningCellTop);

                titleTraningCellTop = new Cell(new Chunk("Period", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);
                traningTable.addCell(titleTraningCellTop);

                titleTraningCellTop = new Cell(new Chunk("Duration", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);
                traningTable.addCell(titleTraningCellTop);

                titleTraningCellTop = new Cell(new Chunk("Trainer", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);
                traningTable.addCell(titleTraningCellTop);

                titleTraningCellTop = new Cell(new Chunk("Training Title", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);

                traningTable.addCell(titleTraningCellTop);

                titleTraningCellTop = new Cell(new Chunk("Description", fontHeader));
                titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                titleTraningCellTop.setBackgroundColor(bgColor);
                traningTable.addCell(titleTraningCellTop);

                //value-valuenya
                for (int i = 0; i < vTraning.size(); i++) {
                    TrainingHistory training = (TrainingHistory) vTraning.get(i);

                    Training trn1 = new Training();
                    try {
                        trn1 = PstTraining.fetchExc(training.getTrainingId());
                    } catch (Exception e) {
                        trn1 = new Training();
                    }


                    int digitNam = trn1.getName().length();
                    String potNam = trn1.getName();
                    if(digitNam > 30){
                        potNam = potNam.substring(0,30);
                        potNam = potNam + ".....";
                    }
                    
                    titleTraningCellTop = new Cell(new Chunk(potNam, tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                    titleTraningCellTop = new Cell(new Chunk(Formater.formatDate(training.getStartDate(), "dd-MM-yy") + " // " + Formater.formatDate(training.getEndDate(), "dd-MM-yy"), tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                    titleTraningCellTop = new Cell(new Chunk(SessTraining.getDurationString(training.getDuration()), tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                    titleTraningCellTop = new Cell(new Chunk(training.getTrainer(), tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                    int digitRem = training.getRemark().length();
                    String potRem = training.getRemark();
                    if(digitRem > 30){
                        potRem = potRem.substring(0,30);
                        potRem = potRem + ".....";
                    }
                    
                    titleTraningCellTop = new Cell(new Chunk(potRem, tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                    titleTraningCellTop = new Cell(new Chunk(trn1.getDescription(), tableContent));
                    titleTraningCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleTraningCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleTraningCellTop.setBorderColor(new Color(255, 255, 255));
                    traningTable.addCell(titleTraningCellTop);

                }

                document.add(traningTable);
            }


            
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
