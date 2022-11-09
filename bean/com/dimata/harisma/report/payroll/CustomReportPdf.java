/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report.payroll;

import com.dimata.harisma.entity.payroll.CustomRptConfig;
import com.dimata.harisma.entity.payroll.CustomRptDynamic;
import com.dimata.harisma.entity.payroll.PayBanks;
import com.dimata.harisma.entity.payroll.PstCustomRptConfig;
import com.dimata.harisma.entity.payroll.PstPayBanks;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author mchen
 */
public class CustomReportPdf extends HttpServlet {

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    public void destroy() {

    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        System.out.println("===| Custom Report Pdf |===");
        
        /* Update by Hendra Putu | 20150403 */
        int iCommand = FRMQueryString.requestCommand(request);
        long oidCustom = FRMQueryString.requestLong(request, "oid_custom");
        int start = FRMQueryString.requestInt(request, "start");
        int prevCommand = FRMQueryString.requestInt(request, "prev_command");
        int generate = FRMQueryString.requestInt(request, "generate");
        int selectionChoose = FRMQueryString.requestInt(request, "selection_choose");
        String[] whereField = FRMQueryString.requestStringValues(request, "where_field");
        int compare_gaji = FRMQueryString.requestInt(request, "compare_gaji");
        String[] whereFieldCompare = FRMQueryString.requestStringValues(request, "where_field_compare");
        Vector vectWhereValueCompare = new Vector();
        if (whereFieldCompare != null){
            for (int v=0; v<whereFieldCompare.length; v++){
                vectWhereValueCompare.add(FRMQueryString.requestStringValues(request, "where_value_compare_"+v));
            }
        }
        String[] operatorCompare = FRMQueryString.requestStringValues(request, "operator_compare");
        /* update : vectWhereValue | 2017-02-23 */
        Vector vectWhereValue = new Vector();
        if (whereField != null){
            for (int v=0; v<whereField.length; v++){
                vectWhereValue.add(FRMQueryString.requestStringValues(request, "where_value"+v));
            }
        }
        //String[] whereValue = FRMQueryString.requestStringValues(request, "where_value");
        String[] whereType = FRMQueryString.requestStringValues(request, "where_type");
        String[] operator = FRMQueryString.requestStringValues(request, "operator");
        String whereCustom = FRMQueryString.requestString(request, "where_custom");
        /* Update by Hendra Putu | 2015-11-05 */
        int showValue = FRMQueryString.requestInt(request, "show_value");
        int tampilData0 = FRMQueryString.requestInt(request, "tampil_data_0");
    
        Color border = new Color(0x00, 0x00, 0x00);
        Color red = new Color(255, 0, 0);
        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontSmall = new Font(Font.HELVETICA, 9, Font.NORMAL);
        Font fontSmallRed = new Font(Font.HELVETICA, 9, Font.NORMAL);
        fontSmallRed.setColor(red);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Document document = new Document(PageSize.A4.rotate(), 20, 20, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            String str = PstSystemProperty.getValueByName("PRINT_HEADER");

            //Header 
            HeaderFooter header = new HeaderFooter(new Phrase(str, fontSmall), false);
            header.setAlignment(Element.ALIGN_LEFT);
            header.setBorder(Rectangle.BOTTOM);
            header.setBorderColor(blackColor);
            document.setHeader(header);
            
            document.open();
           Table tblOutput = null ;
            /*================================================================*/
            
            String dataOutput = ""+oidCustom;
            if (generate == 1) {

                /*
                * Description : Code to find WHERE DATA 
                 */
                String whereClause = "";String whereClauseCompare = "";
                if(compare_gaji == 1){
                    whereClauseCompare =PstCustomRptConfig.findWhereData(0, whereField, vectWhereValue, whereType, operator, whereCustom,whereFieldCompare,vectWhereValueCompare,operatorCompare);
                }
                whereFieldCompare = new String[0] ;
                vectWhereValueCompare = new Vector();
                operatorCompare = new String[0];
                whereClause = PstCustomRptConfig.findWhereData(selectionChoose, whereField, vectWhereValue, whereType, operator, whereCustom,whereFieldCompare,vectWhereValueCompare,operatorCompare);
                /*
                * Description : Get SELECT DATA and JOIN DATA
                * Date : 2015-04-08 
                 */
                String[] dataJoin = new String[5];

                String strSelect = "SELECT ";
                String strJoin = "";
                String strOrderBy = "";
                int inc = 0;
                /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 0 */
                String where = " RPT_CONFIG_DATA_TYPE = 0 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID =" + oidCustom;
                Vector listData = PstCustomRptConfig.list(0, 0, where, "");
                /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 2 */
                String whereComp = " RPT_CONFIG_DATA_TYPE = 2 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID =" + oidCustom;
                Vector listSalaryComp = PstCustomRptConfig.list(0, 0, whereComp, "");
                /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 1 */
                String whereComb = " RPT_CONFIG_DATA_TYPE = 1 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID =" + oidCustom;
                Vector listComb = PstCustomRptConfig.list(0, 0, whereComb, "");
                /* Array join */
                int[] joinCollection = new int[PstCustomRptConfig.joinDataPriority.length];
                /* inisialisasi joinCollection */
                for (int d = 0; d < PstCustomRptConfig.joinDataPriority.length; d++) {
                    joinCollection[d] = -1;
                }
                boolean found = false;
                if (listData != null && listData.size() > 0) {
                    int incC = 0;
                    for (int i = 0; i < listData.size(); i++) {
                        CustomRptConfig rpt = (CustomRptConfig) listData.get(i);
                        /* mendapatkan join data */
                        for (int k = 0; k < PstCustomRptConfig.joinData.length; k++) {
                            for (String retval : PstCustomRptConfig.joinData[k].split(" ")) {
                                dataJoin[inc] = retval;
                                inc++;
                            }
                            inc = 0;
                            /* bandingkan nilai table dengan data join */
                            if (rpt.getRptConfigTableName().equals(dataJoin[2])) {
                                /* cek data join pada array joinCollection */
                                for (int c = 0; c < joinCollection.length; c++) {
                                    if (PstCustomRptConfig.joinDataPriority[k] == joinCollection[c]) {
                                        found = true;
                                        /* jika found == true, maka data sudah ada di joinCollection */
                                    }
                                }
                                if (found == false) {
                                    joinCollection[incC] = PstCustomRptConfig.joinDataPriority[k];
                                }
                                found = false;
                            }
                        }
                        incC++;
                        /* mendapatkan data select */
                        strSelect += rpt.getRptConfigTableName() + "." + rpt.getRptConfigFieldName();
                        if (i == listData.size() - 1) {
                            strSelect += " ";
                        } else {
                            strSelect += ", ";
                        }
                    }
                    /* join Collection */
                    Arrays.sort(joinCollection);
                    /* sorting array */
                    for (int m = 0; m < joinCollection.length; m++) {
                        if (joinCollection[m] != -1) {
                            strJoin += PstCustomRptConfig.joinData[joinCollection[m]] + " ";
                        }
                    }
                }
                /* ORDER BY */
                String whereOrder = " RPT_CONFIG_DATA_TYPE = 0 AND RPT_CONFIG_DATA_GROUP = 2 AND RPT_MAIN_ID =" + oidCustom;
                Vector listOrder = PstCustomRptConfig.list(0, 0, whereOrder, "");
                if (listOrder != null && listOrder.size() > 0) {
                    strOrderBy = " ORDER BY ";
                    for (int ord = 0; ord < listOrder.size(); ord++) {
                        CustomRptConfig rptOrder = (CustomRptConfig) listOrder.get(ord);
                        strOrderBy += rptOrder.getRptConfigTableName() + "." + rptOrder.getRptConfigFieldName();
                        if (ord == listOrder.size() - 1) {
                            strOrderBy += " ";
                        } else {
                            strOrderBy += ", ";
                        }

                    }
                }
                Vector listResult = new Vector();
                 Vector listResultCompare = new Vector();
                if (listSalaryComp != null && listSalaryComp.size() > 0) {
                    listResult = PstCustomRptConfig.listData(strSelect + " FROM hr_employee " + strJoin + " " + whereClause + strOrderBy, listData);
                    if(compare_gaji == 1){
                        listResultCompare = PstCustomRptConfig.listData(strSelect + " FROM hr_employee " + strJoin + " " + whereClauseCompare + strOrderBy, listData);
                    }
                    
                    /* === get list of SUB TOTAL === */
                    String whereSubTotal = " RPT_CONFIG_DATA_TYPE = 3 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
                    Vector listSubTotal = PstCustomRptConfig.list(0, 0, whereSubTotal, "");
                    String[] countName = new String[listData.size()];
                    int[] countIdx = new int[listData.size()];
                    /* get name of count by SECTION or DEPARTMENT or else */
                    if (listSubTotal != null && listSubTotal.size()>0){
                        for(int st=0; st<listSubTotal.size(); st++){
                            CustomRptConfig sbt = (CustomRptConfig)listSubTotal.get(st);
                            if ("COUNT".equals(sbt.getRptConfigTableGroup())){
                                countName[st] = sbt.getRptConfigTableName();
                            }
                        }
                    }
                    /* === get list of Custom Field | Update: 2017-03-02 === */
                    String whereCF = " RPT_CONFIG_DATA_TYPE = 4 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
                    Vector listRptCF = PstCustomRptConfig.list(0, 0, whereCF, "");
                    /* Some of array variable */
                    String[][] arrFieldCompare = new String[listResultCompare.size()+1][listData.size()];
                    int[] listIdxCompare = new int[listResult.size()+1];
                    double[][] totalComp = null;
                    double[][] totalCompCompare = null;
                    double[] totalCombineCompare = null;
                    if(listResultCompare.size()>0){
                        totalComp = new double[listResult.size()][listSalaryComp.size()*2]; /* for total salary component */
                        totalCompCompare = new double[listResultCompare.size()][listSalaryComp.size()]; /* for total salary component compare */
                        totalCombineCompare = new double[listResultCompare.size()]; /* for total combine */
                    }else{
                        totalComp = new double[listResult.size()][listSalaryComp.size()]; /* for total salary component */
                    }

                    String[][] arrField = new String[listResult.size()+1][listData.size()]; /* for dinamic fields */
//                    double[][] totalComp = new double[listResult.size()][listSalaryComp.size()]; /* for total salary component */
                    double[] totalCombine = new double[listResult.size()]; /* for total combine */
                    String[][] arrCField = new String[listResult.size()][listRptCF.size()];
                    /* update by Hendra Putu | 2015-11-05 */
                    double countValueComp = 0;
                    boolean[] showRecord = new boolean[listResult.size()];

                    /* mengambil field dinamis */
                    /* Check count and get index */
                    int idx = 0;
                    for(int i=0;i<listData.size(); i++){
                        CustomRptConfig fields = (CustomRptConfig)listData.get(i);              
                        for(int cn=0; cn<countName.length; cn++){
                            if (fields.getRptConfigFieldName().equals(countName[cn])){
                                countIdx[idx] = i;
                                idx++;
                            }
                        }
                    }

                    /* 
                    ===============================================================================
                    * listRecord berisi baris data hasil query dan akan ditampung ke variabel array 
                    ===============================================================================
                    */
                    int grandCols = listData.size();
                    boolean isStatusData = false;
                    
                      //add by Eri Yudi 2020-10-02
        if (listResultCompare != null && listResultCompare.size()>0){
            for(int y=0; y<listResultCompare.size(); y++){
                CustomRptDynamic dyc = (CustomRptDynamic)listResultCompare.get(y);
                /* Get dinamis field */
                if (listData != null && listData.size() > 0){
                    for(int i=0;i<listData.size(); i++){
                        CustomRptConfig rpt = (CustomRptConfig)listData.get(i);
                        /* jika field name != PAY_SLIP_ID */
                        if(!rpt.getRptConfigFieldName().equals("PAY_SLIP_ID")){       
                            if (!rpt.getRptConfigFieldName().equals("STATUS_DATA")){
                                arrFieldCompare[y][i] = dyc.getField(rpt.getRptConfigFieldName());
                            }
                        }  
                    }
                }
                /* get value field */
                for(int k=0; k<listSalaryComp.size(); k++){
                    CustomRptConfig rptComp = (CustomRptConfig)listSalaryComp.get(k);                    
                    totalCompCompare[y][k] = convertDouble(dyc.getField(rptComp.getRptConfigFieldName()));
//                    countValueComp += totalComp[y][k];
                }
                /* get value field combine */
                for(int l=0; l<listComb.size(); l++){
                    CustomRptConfig rptComb = (CustomRptConfig)listComb.get(l);
                    totalCombineCompare[y] = convertDouble(dyc.getField(rptComb.getRptConfigFieldName()));
                }
               
            }
        }
        //end add by Eri
        
        
                    if (listResult != null && listResult.size()>0){
                        for(int y=0; y<listResult.size(); y++){
                            CustomRptDynamic dyc = (CustomRptDynamic)listResult.get(y);
                            /* Get dinamis field */
                            if (listData != null && listData.size() > 0){
                                for(int i=0;i<listData.size(); i++){
                                    CustomRptConfig rpt = (CustomRptConfig)listData.get(i);
                                    /* jika field name != PAY_SLIP_ID */
                                    if(!rpt.getRptConfigFieldName().equals("PAY_SLIP_ID")){
                                        if (!rpt.getRptConfigFieldName().equals("STATUS_DATA")){
                                            arrField[y][i] = dyc.getField(rpt.getRptConfigFieldName());
                                        } else {
                                            isStatusData = true;
                                        }
                                    }  
                                        /* jika field name == EMPLOYEE_NUM  */
                                    if(rpt.getRptConfigFieldName().equals("EMPLOYEE_NUM")){
                                        for(int xy = 0 ; xy < listResultCompare.size(); xy++){
                                            if (arrField[y][i].equals(arrFieldCompare[xy][i])){
                                               listIdxCompare[y]= xy ;
                                               break;
                                            }else{
                                               listIdxCompare[y] = -1;
                                }
                            }
                                    }
                                }
                            }
                            /* get value field */
                            for(int k=0; k<listSalaryComp.size(); k++){
                                CustomRptConfig rptComp = (CustomRptConfig)listSalaryComp.get(k);                    
                                totalComp[y][k] = convertDouble(dyc.getField(rptComp.getRptConfigFieldName()));
                                countValueComp += totalComp[y][k];
                            }
                            /* get value field combine */
                            for(int l=0; l<listComb.size(); l++){
                                CustomRptConfig rptComb = (CustomRptConfig)listComb.get(l);
                                totalCombine[y] = convertDouble(dyc.getField(rptComb.getRptConfigFieldName()));
                            }
                            /* get value field custom report [2017-03-02] */
                            for(int f=0; f<listRptCF.size(); f++){
                                CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
                                arrCField[y][f] = dyc.getField(rptCF.getRptConfigFieldName());
                            }
                            if (showValue == 0){
                               showRecord[y] = true;
                            } else {
                                if (countValueComp == 0){
                                    showRecord[y] = false;
                                } else {
                                    showRecord[y] = true;
                                }
                            }
                            if (tampilData0 == 0){
                                showRecord[y] = true;
                            } else {
                                /* get value field */
                                showRecord[y] = true;
                                for(int k=0; k<listSalaryComp.size(); k++){
                                    CustomRptConfig rptComp = (CustomRptConfig)listSalaryComp.get(k);                    
                                    totalComp[y][k] = convertDouble(dyc.getField(rptComp.getRptConfigFieldName()));
                                    if (totalComp[y][k] == 0){
                                        showRecord[y] = false;
                                    }
                                }
                            }
                            countValueComp = 0;
                        }
                    }
                    /* END of List Record */
                    int[] countTotal = new int[idx];
                    boolean[] countFind = new boolean[idx];
                    /* inisialisasi */
                    for(int d=0; d<idx; d++){
                        countTotal[d] = 1;
                        countFind[d] = false;
                    }
                    int nomor = 0;
                    int yStart = 0;
                    int yEnd = 0;
                    double total = 0;
                    boolean ketemu = false;
                    //String table = "<table class='tblStyle'>";
                    //table +="<tr>";
                    //table +="<td class='title_tbl'>No</td>";
                    
                     if(compare_gaji==1){
                        tblOutput = new Table(listData.size()+listSalaryComp.size()+listSalaryComp.size()+listRptCF.size()+listComb.size()+listComb.size());   
                     } else {
                        tblOutput = new Table(listData.size()+listSalaryComp.size()+listRptCF.size()+listComb.size());
                     }
                    tblOutput.setWidth(100);
                    Cell cellData = null;

                    cellData = new Cell(new Chunk("No", fontSmall));
                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    tblOutput.addCell(cellData);
                    /* mengambil field dinamis */
                    for(int i=0;i<listData.size(); i++){
                        CustomRptConfig fields = (CustomRptConfig)listData.get(i);    
                        if(!fields.getRptConfigFieldName().equals("PAY_SLIP_ID")){
                            if (!fields.getRptConfigFieldName().equals("STATUS_DATA")){
                                cellData = new Cell(new Chunk(fields.getRptConfigFieldHeader(), fontSmall));
                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                tblOutput.addCell(cellData);
                                //table +="<td class='title_tbl'>"+fields.getRptConfigFieldHeader()+"</td>";
                            }
                        }
                    }
                    /* mengambil field salary component */
                    for(int j=0; j<listSalaryComp.size(); j++){
                        CustomRptConfig comp = (CustomRptConfig)listSalaryComp.get(j);
                        cellData = new Cell(new Chunk(comp.getRptConfigFieldHeader(), fontSmall));
                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        tblOutput.addCell(cellData);
                        if(listResultCompare.size() > 0){
                            cellData = new Cell(new Chunk(comp.getRptConfigFieldHeader()+" (Compare) ", fontSmall));
                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            tblOutput.addCell(cellData);
                        }
                        //table +="<td class='title_tbl'>"+comp.getRptConfigFieldHeader()+"</td>";
                    }
                    /* get field custom report [2017-03-02] */
                    for(int f=0; f<listRptCF.size(); f++){
                        CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
                        cellData = new Cell(new Chunk(rptCF.getRptConfigFieldHeader(), fontSmall));
                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        tblOutput.addCell(cellData);
                        //table +="<td class='title_tbl'>"+rptCF.getRptConfigFieldHeader()+"</td>";
                    }
                    /* mengambil field combine */
                    for(int k=0; k<listComb.size(); k++){
                        CustomRptConfig comb = (CustomRptConfig)listComb.get(k);
                        cellData = new Cell(new Chunk(comb.getRptConfigFieldHeader(), fontSmall));
                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        tblOutput.addCell(cellData);
                        if(listResultCompare.size() > 0){
                            cellData = new Cell(new Chunk(comb.getRptConfigFieldHeader()+" (Compare) ", fontSmall));
                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            tblOutput.addCell(cellData);  
                        }
                        //table +="<td class='title_tbl'>"+comb.getRptConfigFieldHeader()+"</td>";
                    }
                    //table +="</tr>";
                    /* ============== record result ==============*/
                    if (listResult != null && listResult.size()>0){
                        for(int y=0; y<listResult.size(); y++){
                            if (showRecord[y] == true){
                                nomor++;
                                //table +="<tr>";
                                /////table +="<td>"+nomor+"</td>";                                
                                cellData = new Cell(new Chunk(""+nomor, fontSmall));
                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                tblOutput.addCell(cellData);
                                /* Fields dinamic */
                                if (listData != null && listData.size() > 0){
                                    for(int i=0;i<listData.size(); i++){
                                        if (arrField[y][i] != null){
                                            /////table +="<td>"+arrField[y][i]+"</td>";
                                            cellData = new Cell(new Chunk(arrField[y][i], fontSmall));
                                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            //cellData.setBorderColor(new Color(0, 0, 0));
                                            tblOutput.addCell(cellData);
                                        }
                                    }
                                    /* count record by ... */
                                    for(int sb=0; sb<idx; sb++){
                                        if (arrField[y][countIdx[sb]].equals(arrField[y+1][countIdx[sb]])){
                                            countTotal[sb] = countTotal[sb] + 1;
                                        } else {
                                            countFind[sb] = true;
                                            ketemu = true;
                                            yEnd = y+1;
                                        }
                                    }
                                }

                                for(int k=0; k<listSalaryComp.size(); k++){
                                    cellData = new Cell(new Chunk(Formater.formatNumber(totalComp[y][k], ""), fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                     //add by Eri Yudi 2020-10-01 for compare report
                                    if(listResultCompare.size()>0){
                                       if(listIdxCompare[y] != -1){
                                           if(totalComp[y][k] == totalCompCompare[listIdxCompare[y]][k]){
                                                cellData = new Cell(new Chunk(Formater.formatNumber(totalCompCompare[listIdxCompare[y]][k], ""), fontSmall));
                                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                tblOutput.addCell(cellData);  
                                           }else{
                                                cellData = new Cell(new Chunk(Formater.formatNumber(totalCompCompare[listIdxCompare[y]][k], ""), fontSmallRed));
                                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                tblOutput.addCell(cellData);
                                           }
                                       }else{
                                           if(totalComp[y][k] == 0){
                                                cellData = new Cell(new Chunk(Formater.formatNumber(0, ""), fontSmall));
                                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                tblOutput.addCell(cellData);
                                           }else{
                                               cellData = new Cell(new Chunk(Formater.formatNumber(0, ""), fontSmallRed));
                                                cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                tblOutput.addCell(cellData);
                                           }
                                       }   
                                    }
                                    //end add by Eri
                                    //////table +="<td>"+Formater.formatNumber(totalComp[y][k], "") /*convertInteger(totalComp[y][k])*/+"</td>";
                                }
                                /* get field custom report [2017-03-02] */
                                for(int f=0; f<listRptCF.size(); f++){
                                    CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
                                    cellData = new Cell(new Chunk(arrCField[y][f], fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                    /////table +="<td>"+arrCField[y][f]+"</td>";
                                }
                                for(int l=0; l<listComb.size(); l++){
                                    cellData = new Cell(new Chunk(Formater.formatNumber(totalCombine[y], ""), fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                    //add by Eri Yudi 2020-10-02
                                    if(listResultCompare.size()>0){
                                            if(listIdxCompare[y] != -1){
                                                if(totalCombine[y] == totalCombineCompare[listIdxCompare[y]]){
                                                    cellData = new Cell(new Chunk(Formater.formatNumber(totalCombineCompare[listIdxCompare[y]], ""), fontSmall));
                                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                    tblOutput.addCell(cellData);
                                                }else{
                                                    cellData = new Cell(new Chunk(Formater.formatNumber(totalCombineCompare[listIdxCompare[y]], ""), fontSmallRed));
                                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                    tblOutput.addCell(cellData);
                                                }
                                            }else{
                                                if(totalCombine[y] == 0){
                                                    cellData = new Cell(new Chunk(Formater.formatNumber(0, ""), fontSmall));
                                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                    tblOutput.addCell(cellData);
                                                }else{
                                                    cellData = new Cell(new Chunk(Formater.formatNumber(0, ""), fontSmallRed));
                                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                    tblOutput.addCell(cellData);
                                                }
                                            }
                                        }
                                    /////table +="<td>"+Formater.formatNumber(totalCombine[y], "") /*convertInteger(totalCombine[y])*/+"</td>";
                                }
                                //table +="</tr>";
                                //table +="<tr>";

                                boolean addColoum = false;
                                if (ketemu == true){
                                    for(int f=0; f<idx; f++){
                                        if (countFind[f] == true){
                                            if (addColoum == false){
                                                for(int a=0; a<countIdx[f]+1; a++){
                                                    cellData = new Cell(new Chunk(" ", fontSmall));
                                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                                    tblOutput.addCell(cellData);
                                                    /////table +="<td id='tdTotal'>&nbsp;</td>";
                                                }
                                                addColoum = true;
                                            }
                                            cellData = new Cell(new Chunk(""+countTotal[f], fontSmall));
                                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                            tblOutput.addCell(cellData);
                                            /////table +="<td id='tdTotal'>"+countTotal[f]+"</td>";

                                            countFind[f] = false;
                                            countTotal[f] = 1;
                                        }
                                    }
                                    addColoum = false;
                                    for(int b=0; b<listData.size()-(countIdx[idx-1]+2); b++){
                                        cellData = new Cell(new Chunk(" ", fontSmall));
                                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        tblOutput.addCell(cellData);
                                        /////table +="<td id='tdTotal'>&nbsp;</td>";
                                    }
                                    for(int kolom=0; kolom<listSalaryComp.size(); kolom++){
                                        for(int x=yStart; x<yEnd; x++){
                                            total += totalComp[x][kolom];
                                        }
                                        cellData = new Cell(new Chunk(Formater.formatNumber(total, ""), fontSmall));
                                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                        tblOutput.addCell(cellData);
                                        //////table +="<td id='tdTotal'>"+ Formater.formatNumber(total, "") /*convertInteger(total)*/+"</td>";
                                        total = 0;
                                    }
                                    for(int x=yStart; x<yEnd; x++){
                                        total += totalCombine[x];
                                    }
                                    cellData = new Cell(new Chunk(Formater.formatNumber(total, ""), fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                    
                                    //////table +="<td id='tdTotal'>"+Formater.formatNumber(total, "") /*convertInteger(total)*/+"</td>";
                                    total = 0;
                                    ketemu = false;
                                }
                                //table +="</tr>";
                                yStart = yEnd;
                            }
                        }
                        //table += "<tr>";
                        if (isStatusData == true){
                            grandCols = grandCols - 1;
                        }
                        cellData = new Cell(new Chunk("Grand Total", fontSmall));
                        cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                        cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        cellData.setColspan(listData.size());
                        tblOutput.addCell(cellData);
                        /////table += "<td class='td_grand_total' colspan=\""+grandCols+"\">Grand Total</td>";
                        /* mengambil field salary component */
                        double grandTotalComp = 0;
                         double grandTotalCompCompare = 0;
                        for(int j=0; j<listSalaryComp.size(); j++){
                            for(int y=0; y<listResult.size(); y++){
                                grandTotalComp = grandTotalComp + totalComp[y][j];
                                 if(listResultCompare.size()>0){
                                    if(listIdxCompare[y] != -1){
                                     grandTotalCompCompare = grandTotalCompCompare + totalCompCompare[listIdxCompare[y]][j] ;
                            }
                                 }
                            }
                            cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalComp, ""), fontSmall));
                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            tblOutput.addCell(cellData);
                            if(listResultCompare.size()>0){
                               if(grandTotalComp == grandTotalCompCompare){
                                    cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalCompCompare, ""), fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                               }else{
                                    cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalCompCompare, ""), fontSmallRed));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                               }
                            }
                            /////table +="<td class='td_grand_total'>"+ Formater.formatNumber(grandTotalComp, "") + /*convertInteger(grandTotalComp)*/"</td>";
                            grandTotalComp = 0;
                            grandTotalCompCompare = 0;
                        }
                        /* mengambil field combine */
                        double grandTotalComb = 0;
                         double grandTotalCombCompare = 0;
                        for(int y=0; y<listResult.size(); y++){
                            grandTotalComb = grandTotalComb +  totalCombine[y];
                              if(listResultCompare.size()>0){
                                if(listIdxCompare[y] != -1){
                                  grandTotalCombCompare = grandTotalCombCompare + totalCombineCompare[listIdxCompare[y]] ;
                        }
                              }
                        }
                        if (grandTotalComb != 0){
                            cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalComb, ""), fontSmall));
                            cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                            cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                            tblOutput.addCell(cellData);
                            if(listResultCompare.size()>0){
                                if(grandTotalComb == grandTotalCombCompare){
                                    cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalCombCompare, ""), fontSmall));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                }else{
                                    cellData = new Cell(new Chunk(Formater.formatNumber(grandTotalCombCompare, ""), fontSmallRed));
                                    cellData.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cellData.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                    tblOutput.addCell(cellData);
                                }
                            }
                            /////table +="<td class='td_grand_total'>"+ Formater.formatNumber(grandTotalComb, "") + /*convertInteger(grandTotalComb)*/"</td>";
                        }

                        //table += "</tr>";
                    }
                    //table +="</table>";
                    
                } else {
                    listResult = PstCustomRptConfig.listDataWithoutPaySlip(strSelect + " FROM hr_employee " + strJoin + " " + whereClause + strOrderBy, listData);
                    dataOutput = drawListWithoutPaySlip(listData, listResult, oidCustom);
                }
            }

            
            document.add(tblOutput);
            /*================================================================*/
        } catch (Exception e) {
            System.out.println("Print Pdf Custom Report ==>" + e.toString());
        }
        document.close();
        System.out.println("print==============");
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }
    
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
    
    /*///
    * method name : apostrophe(String value, String opr)
    * Description : memanipulasi value dengan menampahkan 'kutip satu
    */
    public String apostrophe(String value, String opr){
        String str = "";
        if (opr.equals("=")){
            str = "'"+value+"'";
        } else if (opr.equals("BETWEEN")){
            String[] data = new String[5];
            int inc = 0;
            for (String retval : value.split(" ")) {
                data[inc]= retval;
                inc++;
            }
            str = "'"+data[0]+"' AND '"+data[1]+"'";
        } else if (opr.equals("LIKE")){
            str = "'"+value+"'";
        } else if (opr.equals("IN")){
            String stIn = "";
            for (String retval : value.split(",")) {
                stIn += " '"+ retval +"', ";
            }
            stIn += "'0'";
            str += "("+stIn+")";
        } else if (opr.equals("!=")) {
            str = "'"+value+"'";
        } else {
            str = value;
        }
        return str;
    }
    /* Convert double */
    public double convertDouble(String val){
        BigDecimal bDecimal = new BigDecimal(Double.valueOf(val));
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.doubleValue();
    }
    /* Convert int */
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    /* drawList Table*/
    public String drawList(Vector listField, Vector listRecord, Vector listComp, Vector listComb, long oidCustom, int showValue, int tampilData0) {
        /* === get list of SUB TOTAL === */
        String whereSubTotal = " RPT_CONFIG_DATA_TYPE = 3 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listSubTotal = PstCustomRptConfig.list(0, 0, whereSubTotal, "");
        String[] countName = new String[listField.size()];
        int[] countIdx = new int[listField.size()];
        /* get name of count by SECTION or DEPARTMENT or else */
        if (listSubTotal != null && listSubTotal.size()>0){
            for(int st=0; st<listSubTotal.size(); st++){
                CustomRptConfig sbt = (CustomRptConfig)listSubTotal.get(st);
                if ("COUNT".equals(sbt.getRptConfigTableGroup())){
                    countName[st] = sbt.getRptConfigTableName();
                }
            }
        }
        /* === get list of Custom Field | Update: 2017-03-02 === */
        String whereCF = " RPT_CONFIG_DATA_TYPE = 4 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listRptCF = PstCustomRptConfig.list(0, 0, whereCF, "");
        /* Some of array variable */
        String[][] arrField = new String[listRecord.size()+1][listField.size()]; /* for dinamic fields */
        double[][] totalComp = new double[listRecord.size()][listComp.size()]; /* for total salary component */
        double[] totalCombine = new double[listRecord.size()]; /* for total combine */
        String[][] arrCField = new String[listRecord.size()][listRptCF.size()];
        /* update by Hendra Putu | 2015-11-05 */
        double countValueComp = 0;
        boolean[] showRecord = new boolean[listRecord.size()];
       
        /* mengambil field dinamis */
        /* Check count and get index */
        int idx = 0;
        for(int i=0;i<listField.size(); i++){
            CustomRptConfig fields = (CustomRptConfig)listField.get(i);              
            for(int cn=0; cn<countName.length; cn++){
                if (fields.getRptConfigFieldName().equals(countName[cn])){
                    countIdx[idx] = i;
                    idx++;
                }
            }
        }
        
        /* 
        ===============================================================================
        * listRecord berisi baris data hasil query dan akan ditampung ke variabel array 
        ===============================================================================
        */
        int grandCols = listField.size();
        boolean isStatusData = false;
        if (listRecord != null && listRecord.size()>0){
            for(int y=0; y<listRecord.size(); y++){
                CustomRptDynamic dyc = (CustomRptDynamic)listRecord.get(y);
                /* Get dinamis field */
                if (listField != null && listField.size() > 0){
                    for(int i=0;i<listField.size(); i++){
                        CustomRptConfig rpt = (CustomRptConfig)listField.get(i);
                        /* jika field name != PAY_SLIP_ID */
                        if(!rpt.getRptConfigFieldName().equals("PAY_SLIP_ID")){
                            if (!rpt.getRptConfigFieldName().equals("STATUS_DATA")){
                                arrField[y][i] = dyc.getField(rpt.getRptConfigFieldName());
                            } else {
                                isStatusData = true;
                            }
                        }  
                    }
                }
                /* get value field */
                for(int k=0; k<listComp.size(); k++){
                    CustomRptConfig rptComp = (CustomRptConfig)listComp.get(k);                    
                    totalComp[y][k] = convertDouble(dyc.getField(rptComp.getRptConfigFieldName()));
                    countValueComp += totalComp[y][k];
                }
                /* get value field combine */
                for(int l=0; l<listComb.size(); l++){
                    CustomRptConfig rptComb = (CustomRptConfig)listComb.get(l);
                    totalCombine[y] = convertDouble(dyc.getField(rptComb.getRptConfigFieldName()));
                }
                /* get value field custom report [2017-03-02] */
                for(int f=0; f<listRptCF.size(); f++){
                    CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
                    arrCField[y][f] = dyc.getField(rptCF.getRptConfigFieldName());
                }
                if (showValue == 0){
                   showRecord[y] = true;
                } else {
                    if (countValueComp == 0){
                        showRecord[y] = false;
                    } else {
                        showRecord[y] = true;
                    }
                }
                if (tampilData0 == 0){
                    showRecord[y] = true;
                } else {
                    /* get value field */
                    showRecord[y] = true;
                    for(int k=0; k<listComp.size(); k++){
                        CustomRptConfig rptComp = (CustomRptConfig)listComp.get(k);                    
                        totalComp[y][k] = convertDouble(dyc.getField(rptComp.getRptConfigFieldName()));
                        if (totalComp[y][k] == 0){
                            showRecord[y] = false;
                        }
                    }
                }
                countValueComp = 0;
            }
        }
        /* END of List Record */
        int[] countTotal = new int[idx];
        boolean[] countFind = new boolean[idx];
        /* inisialisasi */
        for(int d=0; d<idx; d++){
            countTotal[d] = 1;
            countFind[d] = false;
        }
        int nomor = 0;
        int yStart = 0;
        int yEnd = 0;
        double total = 0;
        boolean ketemu = false;
        String table = "<table class='tblStyle'>";
        table +="<tr>";
        table +="<td class='title_tbl'>No</td>";
        /* mengambil field dinamis */
        for(int i=0;i<listField.size(); i++){
            CustomRptConfig fields = (CustomRptConfig)listField.get(i);    
            if(!fields.getRptConfigFieldName().equals("PAY_SLIP_ID")){
                if (!fields.getRptConfigFieldName().equals("STATUS_DATA")){
                    table +="<td class='title_tbl'>"+fields.getRptConfigFieldHeader()+"</td>";
                }
            }
        }
        /* mengambil field salary component */
        for(int j=0; j<listComp.size(); j++){
            CustomRptConfig comp = (CustomRptConfig)listComp.get(j);
            table +="<td class='title_tbl'>"+comp.getRptConfigFieldHeader()+"</td>";
        }
        /* get field custom report [2017-03-02] */
        for(int f=0; f<listRptCF.size(); f++){
            CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
            table +="<td class='title_tbl'>"+rptCF.getRptConfigFieldHeader()+"</td>";
        }
        /* mengambil field combine */
        for(int k=0; k<listComb.size(); k++){
            CustomRptConfig comb = (CustomRptConfig)listComb.get(k);
            table +="<td class='title_tbl'>"+comb.getRptConfigFieldHeader()+"</td>";
        }
        table +="</tr>";
        /* ============== record result ==============*/
        if (listRecord != null && listRecord.size()>0){
            for(int y=0; y<listRecord.size(); y++){
                if (showRecord[y] == true){
                    nomor++;
                    table +="<tr>";
                    table +="<td>"+nomor+"</td>";
                    /* Fields dinamic */
                    if (listField != null && listField.size() > 0){
                        for(int i=0;i<listField.size(); i++){
                            if (arrField[y][i] != null){
                                table +="<td>"+arrField[y][i]+"</td>";
                            }
                        }
                        /* count record by ... */
                        for(int sb=0; sb<idx; sb++){
                            if (arrField[y][countIdx[sb]].equals(arrField[y+1][countIdx[sb]])){
                                countTotal[sb] = countTotal[sb] + 1;
                            } else {
                                countFind[sb] = true;
                                ketemu = true;
                                yEnd = y+1;
                            }
                        }
                    }

                    for(int k=0; k<listComp.size(); k++){
                        table +="<td>"+Formater.formatNumber(totalComp[y][k], "") /*convertInteger(totalComp[y][k])*/+"</td>";
                    }
                    /* get field custom report [2017-03-02] */
                    for(int f=0; f<listRptCF.size(); f++){
                        CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
                        table +="<td>"+arrCField[y][f]+"</td>";
                    }
                    for(int l=0; l<listComb.size(); l++){
                        table +="<td>"+Formater.formatNumber(totalCombine[y], "") /*convertInteger(totalCombine[y])*/+"</td>";
                    }
                    table +="</tr>";
                    table +="<tr>";

                    boolean addColoum = false;
                    if (ketemu == true){
                        for(int f=0; f<idx; f++){
                            if (countFind[f] == true){
                                if (addColoum == false){
                                    for(int a=0; a<countIdx[f]+1; a++){
                                        table +="<td id='tdTotal'>&nbsp;</td>";
                                    }
                                    addColoum = true;
                                }
                                table +="<td id='tdTotal'>"+countTotal[f]+"</td>";

                                countFind[f] = false;
                                countTotal[f] = 1;
                            }
                        }
                        addColoum = false;
                        for(int b=0; b<listField.size()-(countIdx[idx-1]+2); b++){
                            table +="<td id='tdTotal'>&nbsp;</td>";
                        }
                        for(int kolom=0; kolom<listComp.size(); kolom++){
                            for(int x=yStart; x<yEnd; x++){
                                total += totalComp[x][kolom];
                            }
                            table +="<td id='tdTotal'>"+ Formater.formatNumber(total, "") /*convertInteger(total)*/+"</td>";
                            total = 0;
                        }
                        for(int x=yStart; x<yEnd; x++){
                            total += totalCombine[x];
                        }
                        table +="<td id='tdTotal'>"+Formater.formatNumber(total, "") /*convertInteger(total)*/+"</td>";
                        total = 0;
                        ketemu = false;
                    }
                    table +="</tr>";
                    yStart = yEnd;
                }
            }
            table += "<tr>";
            if (isStatusData == true){
                grandCols = grandCols - 1;
            }
            table += "<td class='td_grand_total' colspan=\""+grandCols+"\">Grand Total</td>";
            /* mengambil field salary component */
            double grandTotalComp = 0;
            for(int j=0; j<listComp.size(); j++){
                for(int y=0; y<listRecord.size(); y++){
                    grandTotalComp = grandTotalComp + totalComp[y][j];
                }
                table +="<td class='td_grand_total'>"+ Formater.formatNumber(grandTotalComp, "") + /*convertInteger(grandTotalComp)*/"</td>";
                grandTotalComp = 0;
            }
            /* mengambil field combine */
            double grandTotalComb = 0;
            
            for(int y=0; y<listRecord.size(); y++){
                grandTotalComb = grandTotalComb +  totalCombine[y];
            }
            if (grandTotalComb != 0){
                table +="<td class='td_grand_total'>"+ Formater.formatNumber(grandTotalComb, "") + /*convertInteger(grandTotalComb)*/"</td>";
            }
            
            table += "</tr>";
        }
        table +="</table>";
        
        return table;

    }
    
    public String drawListWithoutPaySlip(Vector listField, Vector listRecord, long oidCustom){
        String table = "";
        String[][] arrField = new String[listRecord.size() + 1][listField.size()]; /* for dinamic fields */
            
        if (listRecord != null && listRecord.size() > 0) {
            for (int y = 0; y < listRecord.size(); y++) {
                CustomRptDynamic dyc = (CustomRptDynamic) listRecord.get(y);
                /* Get dinamis field */
                if (listField != null && listField.size() > 0) {
                    for (int i = 0; i < listField.size(); i++) {
                        CustomRptConfig rpt = (CustomRptConfig) listField.get(i);
                        arrField[y][i] = dyc.getField(rpt.getRptConfigFieldName());
                    }
                }
            }
        }
            
        int nomor = 0;
        int yStart = 0;
        int yEnd = 0;
        double total = 0;
        boolean ketemu = false;
        table = "<table class='tblStyle'>";
        table += "<tr>";
        table += "<td class='title_tbl'>No</td>";
        /* mengambil field dinamis */
        for (int i = 0; i < listField.size(); i++) {
            CustomRptConfig fields = (CustomRptConfig) listField.get(i);
            table += "<td class='title_tbl'>" + fields.getRptConfigFieldHeader() + "</td>";
        }
            
        table += "</tr>";
        /* ============== record result ==============*/
        if (listRecord != null && listRecord.size() > 0) {
            for (int y = 0; y < listRecord.size(); y++) {
                nomor++;
                table += "<tr>";
                table += "<td>" + nomor + "</td>";
                /* Fields dinamic */
                if (listField != null && listField.size() > 0) {
                    for (int i = 0; i < listField.size(); i++) {
                        if (arrField[y][i] != null) {
                            table += "<td>" + arrField[y][i] + "</td>";
                        }
                    }
                }
                table += "</tr>";
                yStart = yEnd;
            }
        }
        table += "</table>";
            
        return table;
    }
    
    /* Update 2016-04-15 */
    public String getBankName(String oid){
        String name = "";
        if (oid.equals("0")){
            name = "CASH";
        } else {
            try {
                PayBanks payBank = PstPayBanks.fetchExc(Long.valueOf(oid));
                name = payBank.getBankName();
            } catch(Exception e){
                System.out.println(e.toString());
            }
        }
        
        return name;
    }
}
