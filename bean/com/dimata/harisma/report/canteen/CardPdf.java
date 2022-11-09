/* Generated by Together */
/*
 * EmpPresencePdf.java
 * @author gedhy
 * @version 1.0
 * Created on July 13, 2002, 09:10 PM
 */

package com.dimata.harisma.report.canteen;

/* package java */
import java.util.*;
import java.text.*;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.*;
/* package servlet */
import javax.servlet.*;
import javax.servlet.http.*;

/* package lowagie */
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;

/* package qdep */
import com.dimata.util.*;
import com.dimata.qdep.form.*;

/* package harisma */
import com.dimata.harisma.entity.canteen.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.employee.*;

public class CardPdf extends HttpServlet {

    /* declaration constant */
    public static Color blackColor = new Color(0,0,0);
    public static Color whiteColor = new Color(255,255,255);
    public static Color titleColor = new Color(200,200,200);
    public static Color summaryColor = new Color(240,240,240);
    public static String formatDate  = "MMM dd, yyyy";
    public static String formatNumber = "#,###";

    /* setting some fonts in the color chosen by the user */
    public static Font fontHeader = new Font(Font.TIMES_NEW_ROMAN, 12, Font.BOLD, blackColor);
    public static Font fontTitle = new Font(Font.TIMES_NEW_ROMAN, 10, Font.NORMAL, blackColor);
    public static Font fontContent = new Font(Font.TIMES_NEW_ROMAN, 10, Font.NORMAL, blackColor);

    /** Initializes the servlet
    */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /** Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Destroys the servlet
    */
    public void destroy() {
    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        /* creating the document object */
        Document document = new Document(PageSize.A4, 30, 30, 30, 30);

	/* creating an OutputStream */
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            /* creating an instance of the writer */
            PdfWriter writer = PdfWriter.getInstance(document, baos);

            /* get data from session */
            long oidCommentCardHeader = FRMQueryString.requestLong(request, "cardId");
            
            CommentCardHeader commentCardHeader = new CommentCardHeader();
            try {
                commentCardHeader = PstCommentCardHeader.fetchExc(oidCommentCardHeader);
            }
            catch (Exception e) {
            }

            Employee emp = new Employee();
            Department dep = new Department();
            Position pos = new Position();

            if (commentCardHeader.getEmployeeId() > 0) {
                try {
                    emp = PstEmployee.fetchExc(commentCardHeader.getEmployeeId());
                }
                catch (Exception e) {}
                if (emp.getPositionId() > 0) {
                    try {
                        pos = PstPosition.fetchExc(emp.getPositionId());
                    }
                    catch (Exception e) {}
                }
                if (emp.getDepartmentId() > 0) {
                    try {
                        dep = PstDepartment.fetchExc(emp.getDepartmentId());
                    }
                    catch (Exception e) {}
                }
            }
            /* adding a Header of page, i.e. : title, align and etc */
            /* opening the document, needed for add something into document */
            document.open();

           Table tableTop = new Table(3);
           tableTop.setCellpadding(0);
           tableTop.setCellspacing(1);
           tableTop.setBorder(0);
           tableTop.setDefaultCellBorderColor(whiteColor);
           tableTop.setBorder(Rectangle.NO_BORDER);
           int widthHeader[] = {50, 20, 30};
    	   tableTop.setWidths(widthHeader);
           tableTop.setWidth(100);

           Cell cellTop = new Cell(new Chunk("EMPLOYEE COMMENT CARD",fontContent));
           cellTop.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellTop.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellTop.setBackgroundColor(whiteColor);
         	tableTop.addCell(cellTop);

                            
           cellTop = new Cell(new Chunk("Date: " + Formater.formatDate(commentCardHeader.getCardDatetime(), "dd MMMM yyyy"),fontContent));
           cellTop.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellTop.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellTop.setBackgroundColor(whiteColor);
         	tableTop.addCell(cellTop);
                
           cellTop = new Cell(new Chunk("Time: " + Formater.formatDate(commentCardHeader.getCardDatetime(), "hh:mm"),fontContent));
           cellTop.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellTop.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellTop.setBackgroundColor(whiteColor);
         	tableTop.addCell(cellTop);
                
            document.add(tableTop);

            /* create header */
            Table table = getTableHeader();

            /* generate employee attendance report's data */
            Cell cell = new Cell("");

            Vector listquestion = PstCardQuestion.list(0, 0, "", "CARD_QUESTION_GROUP_ID");
            long currGroupId = 0;
            long prevGroupId = 0;
            int cnt = 1;
            for (int i=0; i<listquestion.size(); i++) {
                cnt++;
                CardQuestion cq = (CardQuestion) listquestion.get(i);
                currGroupId = cq.getCardQuestionGroupId();
                if (currGroupId != prevGroupId) { 
                    cnt=1;
                    CardQuestionGroup cqg = new CardQuestionGroup();
                    try {
                        cqg = PstCardQuestionGroup.fetchExc(currGroupId);
                    }
                    catch(Exception e) {
                    }
                    
                    cell = new Cell(new Chunk(" ",fontContent));
                    cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
                   cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cell.setBackgroundColor(whiteColor);
                    cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                        table.addCell(cell);
                    cell = new Cell(new Chunk(" " + cqg.getGroupName(),fontContent));
                    cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
                   cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cell.setBackgroundColor(whiteColor);
                    cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                        table.addCell(cell);
                    cell = new Cell(new Chunk(" ",fontContent));
                    cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
                   cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cell.setBackgroundColor(whiteColor);
                    cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                        table.addCell(cell);
                    cell = new Cell(new Chunk(" ",fontContent));
                    cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
                   cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cell.setBackgroundColor(whiteColor);
                    cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                        table.addCell(cell);
                }

                cell = new Cell(new Chunk(" " + cnt + " ",fontContent));
                cell.setHorizontalAlignment(Cell.ALIGN_RIGHT);
               cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cell.setBackgroundColor(whiteColor);
                cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                    table.addCell(cell);

                cell = new Cell(new Chunk(" " + cq.getQuestion(),fontContent));
                cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
               cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cell.setBackgroundColor(whiteColor);
                cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                    table.addCell(cell);

                    String wherelist = "";
                    String sOID = "";
                    wherelist += PstCommentCard.fieldNames[PstCommentCard.FLD_COMMENT_CARD_HEADER_ID];
                    wherelist += "=" + oidCommentCardHeader;
                    wherelist += " AND " + PstCommentCard.fieldNames[PstCommentCard.FLD_CARD_QUESTION_ID];
                    wherelist += "=" + cq.getOID();
                    System.out.println("wherelist = " + wherelist);
                    Vector vchecklist = PstCommentCard.list(0, 0, wherelist, "");
                    CommentCard cc = new CommentCard();
                    if (vchecklist.size() > 0) {
                        cc = (CommentCard) vchecklist.get(0);
                        sOID = String.valueOf(cc.getChecklistMarkId());
                        System.out.println("sOID = "+sOID);
                    }
                    
                ChecklistMark cm = new ChecklistMark();
                try {
                    cm = PstChecklistMark.fetchExc(cc.getChecklistMarkId());
                }
                catch (Exception e) {
                }

                cell = new Cell(new Chunk(" " + cm.getChecklistMark(),fontContent));
                cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
               cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cell.setBackgroundColor(whiteColor);
                cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                    table.addCell(cell);
                    
                cell = new Cell(new Chunk(" " + cc.getRemark(),fontContent));
                cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
               cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cell.setBackgroundColor(whiteColor);
                cell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
                    table.addCell(cell);
                    
                prevGroupId = currGroupId;
            }
            document.add(table);
            
           Table tableBottom = new Table(3);
           tableBottom.setCellpadding(0);
           tableBottom.setCellspacing(1);
           tableBottom.setBorder(0);
           tableBottom.setDefaultCellBorderColor(whiteColor);
           tableBottom.setBorder(Rectangle.NO_BORDER);
           int widthHeaderBottom[] = {50, 20, 30};
    	   tableBottom.setWidths(widthHeaderBottom);
           tableBottom.setWidth(100);

           Cell cellBottom = new Cell(new Chunk("Filled up by:" + "\n" + emp.getFullName(),fontContent));
           cellBottom.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellBottom.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellBottom.setBackgroundColor(whiteColor);
         	tableBottom.addCell(cellBottom);
                            
           cellBottom = new Cell(new Chunk("Department: " + "\n" + dep.getDepartment(),fontContent));
           cellBottom.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellBottom.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellBottom.setBackgroundColor(whiteColor);
         	tableBottom.addCell(cellBottom);
                
           cellBottom = new Cell(new Chunk("Position: " + "\n" + pos.getPosition(),fontContent));
           cellBottom.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cellBottom.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cellBottom.setBackgroundColor(whiteColor);
         	tableBottom.addCell(cellBottom);
                
            document.add(tableBottom);
        }
        catch(DocumentException de) {
            System.err.println(de.getMessage());
            de.printStackTrace();
        }

        /* closing the document */
        document.close();

        /* we have written the pdfstream to a ByteArrayOutputStream, now going to write this outputStream to the ServletOutputStream
		 * after we have set the contentlength
         */
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }


    /**
    * this method used to create header table
    */
    public static Table getTableHeader() throws BadElementException, DocumentException {
           Table table = new Table(4);
           table.setCellpadding(2);
           //table.setCellspacing(1);
           //table.setBorder(Rectangle.TOP | Rectangle.BOTTOM);
           int widthHeader[] = {5, 40, 15, 40};
    	   table.setWidths(widthHeader);
           table.setWidth(100);

           Cell cell = new Cell(new Chunk(" NO",fontContent));
           cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cell.setHorizontalAlignment(Cell.ALIGN_LEFT);
           cell.setBackgroundColor(summaryColor);
         	table.addCell(cell);

           cell = new Cell(new Chunk(" QUESTION",fontContent));
           cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
           cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cell.setBackgroundColor(summaryColor);
         	table.addCell(cell);
                
           cell = new Cell(new Chunk(" MARK",fontContent));
           cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
           cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cell.setBackgroundColor(summaryColor);
         	table.addCell(cell);

           cell = new Cell(new Chunk(" REMARK",fontContent));
           cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
           cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
           cell.setBackgroundColor(summaryColor);
         	table.addCell(cell);

           return table;
    }

}

