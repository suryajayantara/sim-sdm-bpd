/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.printout;

import java.io.FileOutputStream;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.ExceptionConverter;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfPageEventHelper;
import com.lowagie.text.pdf.PdfWriter;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;

/**
 *
 * @author Gunadi
 */
public class HeaderFooterPrinPdf extends PdfPageEventHelper {

    private String strPath = com.dimata.system.entity.PstSystemProperty.getValueByName("HARISMA_URL");
    protected float tableHeight;
    
   
    /**
     * Demonstrates the use of PageEvents.
     *
     * @param args no arguments needed
     */
    public static void main(String[] args) {
        Document document = new Document(PageSize.A4, 50, 50, 70, 70);
        try {
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream("endpage.pdf"));
            writer.setPageEvent(new HeaderFooterPrinPdf());
            document.open();
            String text = "Lots of text. ";
            for (int k = 0; k < 10; ++k) {
                text += text;
            }
            document.add(new Paragraph(text));
            document.close();
        } catch (Exception de) {
            de.printStackTrace();
        }
    }

    public void onEndPage(PdfWriter writer, Document document) {

        try {

            
            Rectangle page = document.getPageSize();
            PdfPTable head = new PdfPTable(1);
            
            Image imgHead = Image.getInstance(strPath+"/imgcompany/header_slip.jpg");
            imgHead.setAlignment(Image.RIGHT);
            imgHead.scaleAbsolute(page.width(), 100);
            
            PdfPCell cell1 = new PdfPCell(imgHead);
            cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell1.setBorder(0);

            for (int k = 1; k <= 1; ++k) {
                head.addCell(cell1);
            }
//head.addCell(new Phrase("Pueblo Nativo S.A. de C.V", FontFactory.getFont(FontFactory.HELVETICA, 16f)));


            head.setTotalWidth(page.width());
            head.writeSelectedRows(0, -1, 0, page.height() - document.topMargin() + head.getTotalHeight(),
                    writer.getDirectContent());
            tableHeight = head.getTotalHeight();

            PdfPTable foot = new PdfPTable(1);

            Image imgFoot = Image.getInstance(strPath+"/imgcompany/footer_slip.jpg");
            imgFoot.setAlignment(Image.RIGHT);
            imgFoot.scaleAbsolute(page.width(), 80);
            
            PdfPCell cell2 = new PdfPCell(imgFoot);
            cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell2.setBorder(0);

            for (int k = 1; k <= 1; ++k) {
                foot.addCell(cell2);
            }
//head.addCell(new Phrase("Pueblo Nativo S.A. de C.V", FontFactory.getFont(FontFactory.HELVETICA, 16f)));


            foot.setTotalWidth(page.width());
            foot.writeSelectedRows(0, -1, 0, document.bottomMargin(),
                    writer.getDirectContent());



        } catch (Exception e) {
            throw new ExceptionConverter(e);
        }
    }
    
     public float getTableHeight() {
        return tableHeight;
    }

    
}
