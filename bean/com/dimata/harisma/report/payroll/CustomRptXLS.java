/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.report.payroll;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.payroll.CustomRptConfig;
import com.dimata.harisma.entity.payroll.CustomRptDynamic;
import com.dimata.harisma.entity.payroll.CustomRptMain;
import com.dimata.harisma.entity.payroll.PstCustomRptConfig;
import com.dimata.harisma.entity.payroll.PstCustomRptMain;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
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
import org.apache.poi.hssf.usermodel.HSSFFooter;
import org.apache.poi.hssf.usermodel.HSSFHeader;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HeaderFooter;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Footer;
import org.apache.poi.ss.usermodel.Header;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.extensions.XSSFHeaderFooter;
import org.openxmlformats.schemas.spreadsheetml.x2006.main.CTSheetProtection;

/**
 * Description : Custom Report XLS
 * Date : 2015-04-11
 * @author Hendra Putu
 */
public class CustomRptXLS extends HttpServlet {

    /**
     * Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /**
     * Destroys the servlet.
     */
    public void destroy() {
    }

    private static XSSFFont createFont(XSSFWorkbook wb, int size, int color, boolean isBold) {
        XSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) size);
        font.setColor((short) color);
        if (isBold) {
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        }
        return font;
    }

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
        String dateFormat = formatDate.format(cal.getTime());
        
        cal.getTime();
    	SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");
         response.setHeader("Content-disposition", "attachment; filename=" + "custom_report.xls");
        XSSFWorkbook wb = new XSSFWorkbook();
        XSSFSheet sheet = wb.createSheet("Custom Report "+dateFormat);
        sheet.protectSheet("dimata");
        sheet.enableLocking();
         CTSheetProtection sheetProtection = sheet.getCTWorksheet().getSheetProtection();
        sheetProtection.setSelectLockedCells(false); 
        sheetProtection.setSelectUnlockedCells(false); 
        sheetProtection.setFormatCells(false); 
        sheetProtection.setFormatColumns(false); 
        sheetProtection.setFormatRows(false); 
        sheetProtection.setInsertColumns(true); 
        sheetProtection.setInsertRows(true); 
        sheetProtection.setInsertHyperlinks(true); 
        sheetProtection.setDeleteColumns(true); 
        sheetProtection.setDeleteRows(true); 
        sheetProtection.setSort(false); 
        sheetProtection.setAutoFilter(false); 
        sheetProtection.setPivotTables(true); 
        sheetProtection.setObjects(true); 
        sheetProtection.setScenarios(true);
        /* Object header */
        Header header = sheet.getHeader();
        /* Object footer */
        Footer footer = sheet.getFooter();

        /* Row and Columns to repeat */

        
        XSSFCellStyle style2 = wb.createCellStyle();
        /* cell style for locking */
        style2.setLocked(true);
        style2.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        XSSFCellStyle style3 = wb.createCellStyle();
        /* cell style for locking */
        style3.setLocked(true);
        Font fontTitle = wb.createFont();
        fontTitle.setColor(HSSFColor.WHITE.index);
        style3.setFont(fontTitle);
        style3.setFillBackgroundColor(new HSSFColor.BLUE().getIndex());//HSSFCellStyle.GREY_25_PERCENT);
        style3.setFillForegroundColor(new HSSFColor.BLUE().getIndex());//HSSFCellStyle.GREY_25_PERCENT);
        style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style3.setBorderRight(HSSFCellStyle.BORDER_THIN);

        XSSFCellStyle styleTitle = wb.createCellStyle();
        styleTitle.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        styleTitle.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        styleTitle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        XSSFCellStyle style4 = wb.createCellStyle();
        /* cell style for locking */
        style4.setLocked(true);
        style4.setFillBackgroundColor(new HSSFColor.YELLOW().getIndex());//HSSFCellStyle.WHITE);
        style4.setFillForegroundColor(new HSSFColor.YELLOW().getIndex());//HSSFCellStyle.WHITE);
        style4.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style4.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style4.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style4.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        XSSFCellStyle style5 = wb.createCellStyle();
        /* cell style for locking */
        style5.setLocked(true);
        style5.setFillBackgroundColor(new HSSFColor.ORANGE().getIndex());//HSSFCellStyle.WHITE);
        style5.setFillForegroundColor(new HSSFColor.ORANGE().getIndex());//HSSFCellStyle.WHITE);
        style5.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style5.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style5.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style5.setBorderRight(HSSFCellStyle.BORDER_THIN);
        //pemberian warna font
        CellStyle styleFont = wb.createCellStyle();
        Font font = wb.createFont();
        font.setColor(HSSFColor.RED.index);
        styleFont.setFont(font);
        
        //add by Eri Yudi 2020-10-02
         XSSFCellStyle style2Red = wb.createCellStyle();
        /* cell style for locking */
        style2Red.setLocked(true);
        style2Red.setFillBackgroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2Red.setFillForegroundColor(new HSSFColor.WHITE().getIndex());//HSSFCellStyle.WHITE);
        style2Red.setFont(font);
        style2Red.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2Red.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2Red.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2Red.setBorderRight(HSSFCellStyle.BORDER_THIN);
        
        
        XSSFCellStyle style5Red = wb.createCellStyle();
        /* cell style for locking */
        style5Red.setLocked(true);
        style5Red.setFillBackgroundColor(new HSSFColor.ORANGE().getIndex());//HSSFCellStyle.WHITE);
        style5Red.setFillForegroundColor(new HSSFColor.ORANGE().getIndex());//HSSFCellStyle.WHITE);
        style5Red.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style5Red.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style5Red.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style5Red.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style5Red.setFont(font);
        //end add by Eri 
        
        XSSFRow row = sheet.createRow((short) 0);
        XSSFCell cell = row.createCell((short) 0);
        
        XSSFRow row2 = sheet.createRow((short) 0);
        XSSFCell cell2 = row2.createCell((short) 0);

        String printHeader = PstSystemProperty.getValueByName("PRINT_HEADER");
        
        long oidCustom = FRMQueryString.requestLong(request, "oid_custom");
        String[] whereField = FRMQueryString.requestStringValues(request, "where_field");
        //String[] whereValue = FRMQueryString.requestStringValues(request, "where_value");
        /* update : vectWhereValue | 2017-02-23 */
        Vector vectWhereValue = new Vector();
        if (whereField != null){
            for (int v=0; v<whereField.length; v++){
                vectWhereValue.add(FRMQueryString.requestStringValues(request, "where_value"+v));
            }
        }
        String[] whereType = FRMQueryString.requestStringValues(request, "where_type");
        String[] operator = FRMQueryString.requestStringValues(request, "operator");
        /* Update by Hendra Putu | 2015-11-05 */
        int showValue = FRMQueryString.requestInt(request, "show_value");
        int tampilData0 = FRMQueryString.requestInt(request, "tampil_data_0");
        int grandTotal0 = FRMQueryString.requestInt(request, "grand_total_0");
        long empPrintId = FRMQueryString.requestLong(request, "print_emp_oid");
        long empSignId = FRMQueryString.requestLong(request, "employeeSign");
        int compare_gaji = FRMQueryString.requestInt(request, "compare_gaji");
        String[] whereFieldCompare = FRMQueryString.requestStringValues(request, "where_field_compare");
        Vector vectWhereValueCompare = new Vector();
        if (whereFieldCompare != null){
            for (int v=0; v<whereFieldCompare.length; v++){
                vectWhereValueCompare.add(FRMQueryString.requestStringValues(request, "where_value_compare_"+v));
            }
        }
        String[] operatorCompare = FRMQueryString.requestStringValues(request, "operator_compare");
        /*
        * showValue berfungsi jika total gross = 0 | Total Gross = Componen + Componen + ... 
        */
        
        CustomRptMain customRptMain = new CustomRptMain();
        try {
            customRptMain = PstCustomRptMain.fetchExc(oidCustom);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        int countRow = 0;
        
        Employee emp = new Employee();
        try {
            emp = PstEmployee.fetchExc(customRptMain.getRptMainCreatedBy());
        } catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        Employee empFooter = new Employee();
        try {
            empFooter = PstEmployee.fetchExc(empPrintId);
        } catch (Exception exc){
            System.out.println("Exception at CustomRptXLS fetch empFooter :" +exc.toString());
        }
        
        String period = "";
        if (whereField != null){
            for (int p=0;p<whereField.length;p++){
                if (whereField[p].equals("pay_period.PERIOD")){
                    if (vectWhereValue != null){
                        String[] dataWhereValue = (String[])vectWhereValue.get(p);
                        if (dataWhereValue != null){
                            period = dataWhereValue[0];
                        }
                    }
                }
            }
        }
        
        /* Header setting */
        String strHeader = "Company : "+printHeader;
        strHeader += "\nReport Name : "+customRptMain.getRptMainTitle();
        strHeader += "\nPeriod : "+period;
        header.setLeft(strHeader);
        /* Footer setting */
        footer.setLeft("Print on : "+dateFormat+" "+sdf.format(cal.getTime()));
        footer.setCenter("Print by : "+empFooter.getFullName());
        footer.setRight( "Page " + HeaderFooter.page() + " of " + HeaderFooter.numPages() );
        //////////////////////
        /*
        * Description : Code to find WHERE DATA 
        */
        String whereClause = "";
        String whereClauseCompare = "";
        if(compare_gaji == 1){
            whereClauseCompare =PstCustomRptConfig.findWhereData(0, whereField, vectWhereValue, whereType, operator, "",whereFieldCompare,vectWhereValueCompare,operatorCompare);
        }
        whereFieldCompare = new String[0] ;
        vectWhereValueCompare = new Vector();
        operatorCompare = new String[0];
        whereClause = PstCustomRptConfig.findWhereData(0, whereField, vectWhereValue, whereType, operator, "",whereFieldCompare,vectWhereValueCompare,operatorCompare);
        boolean checkMBT = PstCustomRptConfig.checkMBT(0, whereField, vectWhereValue, whereType, operator, "");
        String whereUnion = PstCustomRptConfig.whereDate(0, whereField, vectWhereValue, whereType, operator, "");
        //String valueInp = "";
        //String[] dataWhere = new String[whereValue.length];
        //int a = 0;
        /* Jika input selection tidak kosong /
        if (whereValue != null && whereValue.length > 0){
            whereClause = " WHERE ";
            /// Ulang sebanyak jumlah field /
            for(int w=0; w<whereField.length; w++){
                if (whereValue[w].length() > 0){
                    /// Jika tipe data field = String maka../
                    if (whereType[w].equals("1")){
                        // manipulasi data dengan menambahkan apostrophe (') 
                        valueInp = apostrophe(whereValue[w], operator[w]);
                    } else {
                        valueInp = whereValue[w];
                    }
                    dataWhere[a] = whereField[w] +" "+ operator[w] +" "+ valueInp + " ";
                    a++;
                }
            }
            for(int x=0; x < a; x++){
                whereClause += dataWhere[x];
                if (x == a-1){
                    whereClause +=" ";
                } else {
                    whereClause += " AND ";
                }
            }
        }*/
        /*
        * Description : Get SELECT DATA and JOIN DATA
        * Date : 2015-04-08 
        */
        String[] dataJoin = new String[5];

        String strSelect = "SELECT ";
        String strJoin = "";
        int inc = 0;
        /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 0 */
        String where = " RPT_CONFIG_DATA_TYPE = 0 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listData = PstCustomRptConfig.list(0, 0, where, "");
        /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 2 */
        String whereComp = " RPT_CONFIG_DATA_TYPE = 2 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listSalaryComp = PstCustomRptConfig.list(0, 0, whereComp, "");
        /* WHERE CLAUSE WITH RPT_CONFIG_DATA_TYPE = 1 */
        String whereComb = " RPT_CONFIG_DATA_TYPE = 1 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listComb = PstCustomRptConfig.list(0, 0, whereComb, "");
        /* Array join */
        int[] joinCollection = new int[PstCustomRptConfig.joinDataPriority.length];
        /* inisialisasi joinCollection */
        for(int d=0; d<PstCustomRptConfig.joinDataPriority.length; d++){
            joinCollection[d] = -1;
        }
        boolean found = false;
        if (listData != null && listData.size() > 0){
            int incC = 0;
            for(int i=0;i<listData.size(); i++){
                CustomRptConfig rpt = (CustomRptConfig)listData.get(i);
                /* mendapatkan join data */
                for(int k=0; k<PstCustomRptConfig.joinData.length; k++){
                    for (String retval : PstCustomRptConfig.joinData[k].split(" ")) {
                        dataJoin[inc] = retval;
                        inc++;
                    }
                    inc = 0;
                    /* bandingkan nilai table dengan data join */
                    if (rpt.getRptConfigTableName().equals(dataJoin[2])){
                        /* cek data join pada array joinCollection */
                        for(int c=0; c<joinCollection.length; c++){
                            if (PstCustomRptConfig.joinDataPriority[k] == joinCollection[c]){
                                found = true; /* jika found == true, maka data sudah ada di joinCollection */
                            }
                        }
                        if (found == false){
                            joinCollection[incC] = PstCustomRptConfig.joinDataPriority[k];
                        }
                        found = false;
                    }
                }
                incC++;
                /* mendapatkan data select */
                strSelect += rpt.getRptConfigTableName()+"."+rpt.getRptConfigFieldName();
                if (i == listData.size()-1){
                    strSelect +=" ";
                } else {
                    strSelect += ", ";
                }
            }
            /* join Collection */
            Arrays.sort(joinCollection); /* sorting array */
            for(int m=0; m<joinCollection.length; m++){
                if (joinCollection[m] != -1){
                    strJoin += PstCustomRptConfig.joinData[joinCollection[m]] + " ";
                }
            }
        }
        /* ORDER BY */
        String strOrderBy = "";
        String whereOrder = " RPT_CONFIG_DATA_TYPE = 0 AND RPT_CONFIG_DATA_GROUP = 2 AND RPT_MAIN_ID ="+oidCustom;
        Vector listOrder = PstCustomRptConfig.list(0, 0, whereOrder, "");
        if (listOrder != null && listOrder.size() > 0){
            strOrderBy = " ORDER BY ";
            for(int ord=0;ord<listOrder.size(); ord++){
                CustomRptConfig rptOrder = (CustomRptConfig)listOrder.get(ord);
                strOrderBy += rptOrder.getRptConfigTableName() + "." + rptOrder.getRptConfigFieldName();
                if (ord == listOrder.size()-1){
                    strOrderBy +=" ";
                } else {
                    strOrderBy +=", ";
                }
            }
        }
        String query = strSelect+" FROM hr_employee "+strJoin+" "+whereClause + strOrderBy;
        String queryCompare = strSelect+" FROM hr_employee "+strJoin+" "+whereClauseCompare + strOrderBy;
        if(checkMBT){
            String selectUnion = PstCustomRptConfig.selectJoin(listData);
            query = "("+strSelect+" FROM hr_employee "+strJoin+" "+whereClause+") "
                     + "UNION ("+ selectUnion+" "+whereUnion+" "+strOrderBy+")";
            queryCompare = "("+strSelect+" FROM hr_employee "+strJoin+" "+whereClauseCompare+") "
                     + "UNION ("+ selectUnion+" "+whereUnion+" "+strOrderBy+")";
        }
        Vector listResult = PstCustomRptConfig.listData(query, listData);
        Vector listResultCompare = new Vector();
        if(compare_gaji == 1){
         listResultCompare = PstCustomRptConfig.listData(queryCompare, listData);
        }
        //======================================================================//
        
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
        /*=== get list of no.rekening kredit | update : 2017-03-07  ===*/
        String whereNR = " RPT_CONFIG_DATA_TYPE = 5 AND RPT_CONFIG_DATA_GROUP = 0 AND RPT_MAIN_ID ="+oidCustom;
        Vector listRptNR = PstCustomRptConfig.list(0, 0, whereNR, "");
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
//        double[][] totalComp = new double[listResult.size()][listSalaryComp.size()]; /* for total salary component */
        double[] totalCombine = new double[listResult.size()]; /* for total combine */
        String[][] arrCField = new String[listResult.size()][listRptCF.size()];
        String[][] arrNRField = new String[listResult.size()][listRptNR.size()];
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
                /* get value kredit */
                for(int m=0; m<listRptNR.size(); m++){
                    CustomRptConfig rptNR = (CustomRptConfig)listRptNR.get(m);
                    arrNRField[y][m] = dyc.getField(rptNR.getRptConfigFieldName());
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
        
        countRow = 1;
        int cols = 0;
        /* Header No */
        row = sheet.createRow((short) countRow);
        cell = row.createCell((short) cols);
        cell.setCellValue("No");
        cell.setCellStyle(style3);
        cols = 1;
        
        /* mengambil field dinamis */
        for(int i=0;i<listData.size(); i++){
            CustomRptConfig fields = (CustomRptConfig)listData.get(i);    
            if(!fields.getRptConfigFieldName().equals("PAY_SLIP_ID")){
                if (!fields.getRptConfigFieldName().equals("STATUS_DATA")){
                    cell = row.createCell((short) cols);
                    cell.setCellValue(fields.getRptConfigFieldHeader());
                    cell.setCellStyle(style3);
                    cols++;
                }
            }
        }
        /* mengambil field salary component */
        for(int j=0; j<listSalaryComp.size(); j++){
            CustomRptConfig comp = (CustomRptConfig)listSalaryComp.get(j);
            cell = row.createCell((short) cols);
            cell.setCellValue(comp.getRptConfigFieldHeader());
            cell.setCellStyle(style3);
            cols++;
            if(listResultCompare.size() > 0){
                cell = row.createCell((short) cols);
                cell.setCellValue(comp.getRptConfigFieldHeader()+" (Compare) ");
                cell.setCellStyle(style3);
                cols++;
            }
        }
        /* get field custom report [2017-03-02] */
        for(int f=0; f<listRptCF.size(); f++){
            CustomRptConfig rptCF = (CustomRptConfig)listRptCF.get(f);
            cell = row.createCell((short) cols);
            cell.setCellValue(rptCF.getRptConfigFieldHeader());
            cell.setCellStyle(style3);
            cols++;
        }
        /* get field pot kredit [2017-03-02] */
        for(int m=0; m<listRptNR.size(); m++){
            CustomRptConfig rptNR = (CustomRptConfig)listRptNR.get(m);
            cell = row.createCell((short) cols);
            cell.setCellValue(rptNR.getRptConfigFieldHeader());
            cell.setCellStyle(style3);
            cols++;
        }
        /* mengambil field combine */
        for(int k=0; k<listComb.size(); k++){
            CustomRptConfig comb = (CustomRptConfig)listComb.get(k);
            cell = row.createCell((short) cols);
            cell.setCellValue(comb.getRptConfigFieldHeader());
            cell.setCellStyle(style3);
            cols++;
            if(listResultCompare.size() > 0){
                cell = row.createCell((short) cols);
                cell.setCellValue(comb.getRptConfigFieldHeader() +" (Compare) ");
                cell.setCellStyle(style3);
                cols++; 
            }
        }
        

        countRow = 1;
        int coloum = 0;
        
        /* ============== record result ==============*/
        if (listResult != null && listResult.size()>0){
            for(int y=0; y<listResult.size(); y++){
                if (showRecord[y] == true){
                int nilai = -1;
                if (listSalaryComp.size() > 0){
                 for(int k=0; k<listSalaryComp.size(); k++){
                    
                   nilai = nilai + convertInteger(totalComp[y][k]);
                }
                }
                if (nilai != 0 ) {
                countRow++;
                nomor++;
                row = sheet.createRow((short) countRow);
                sheet.createFreezePane(2, 2);
                cell = row.createCell((short) coloum);
                cell.setCellValue("" + nomor);
                cell.setCellStyle(style2);
                coloum++;

                /* Fields dinamic */
                if (listData != null && listData.size() > 0){
                    for(int i=0;i<listData.size(); i++){
                        if (arrField[y][i] != null){
                            cell = row.createCell((short) coloum);
                            cell.setCellValue("" + arrField[y][i]);
                            cell.setCellStyle(style2);
                            coloum++;
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
                    cell = row.createCell((short) coloum);
                    cell.setCellValue(Formater.formatNumber(totalComp[y][k], ""));
                    cell.setCellStyle(style2);
                    coloum++;
                    //add by Eri Yudi 2020-10-01 for compare report
                         if(listResultCompare.size()>0){
                            if(listIdxCompare[y] != -1){
                                if(totalComp[y][k] == totalCompCompare[listIdxCompare[y]][k]){
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(totalCompCompare[listIdxCompare[y]][k], ""));
                                    cell.setCellStyle(style2);
                                    coloum++;  
                                }else{
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(totalCompCompare[listIdxCompare[y]][k], ""));
                                    cell.setCellStyle(style2Red);
                                    coloum++;
                                }
                            }else{
                                if(totalComp[y][k] == 0){
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(0, ""));
                                    cell.setCellStyle(style2);
                                    coloum++;
                                }else{
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(0, ""));
                                    cell.setCellStyle(style2Red);
                                    coloum++;
                                }
                            }   
                         }
                         //end add by Eri
                }
                /* get field custom report [2017-03-02] */
                for(int f=0; f<listRptCF.size(); f++){
                    cell = row.createCell((short) coloum);
                    cell.setCellValue(arrCField[y][f]);
                    cell.setCellStyle(style2);
                    coloum++;
                }
                /*get field pot kredit */
                for(int m=0; m<listRptNR.size(); m++){
                    cell = row.createCell((short) coloum);
                    cell.setCellValue(arrNRField[y][m]);
                    cell.setCellStyle(style2);
                    coloum++;
                }
                for(int l=0; l<listComb.size(); l++){
                    cell = row.createCell((short) coloum);
                    cell.setCellValue(Formater.formatNumber(totalCombine[y],""));
                    cell.setCellStyle(style2);
                    coloum++;
                    //add by Eri Yudi 2020-10-02
                    if(listResultCompare.size()>0){
                            if(listIdxCompare[y] != -1){
                                if(totalCombine[y] == totalCombineCompare[listIdxCompare[y]]){
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(totalCombineCompare[listIdxCompare[y]],""));
                                    cell.setCellStyle(style2);
                                    coloum++;
                                }else{
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(totalCombineCompare[listIdxCompare[y]],""));
                                    cell.setCellStyle(style2Red);
                                    coloum++;
                                }
                            }else{
                                if(totalCombine[y] == 0){
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(0,""));
                                    cell.setCellStyle(style2);
                                    coloum++;
                                }else{
                                    cell = row.createCell((short) coloum);
                                    cell.setCellValue(Formater.formatNumber(0,""));
                                    cell.setCellStyle(style2Red);
                                    coloum++;
                                }
                            }
                        }
                    //end add By Eri
                }

                
                boolean addColoum = false;
                if (ketemu == true){
                    countRow++;
                    row = sheet.createRow((short) countRow);
                    coloum = 0;
                    int idxCount = 0;
                    for(int f=0; f<idx; f++){
                        if (countFind[f] == true){
                            if (addColoum == false){
                                for(int tot=0; tot<countIdx[f]; tot++){
                                    cell = row.createCell((short) coloum);
                                    if (tot == 0){
                                        cell.setCellValue("Sub Total");
                                    } else {
                                        cell.setCellValue("");
                                    }
                                    cell.setCellStyle(style4);
                                    coloum++;
                                    idxCount++;
                                }
//                                sheet.addMergedRegion(new CellRangeAddress(
//                                        countRow, //first row (0-based)
//                                        countRow, //last row  (0-based)
//                                        0, //first column (0-based)
//                                        (countIdx[f]-1)  //last column  (0-based)
//                                ));
                                addColoum = true;
                            }
                            cell = row.createCell((short) coloum);
                            cell.setCellValue(countTotal[f]);
                            cell.setCellStyle(style4);
                            coloum++;
                            idxCount++;
                            countFind[f] = false;
                            countTotal[f] = 1;
                        }
                    }
                    addColoum = false;
                    for(int b=0; b<listData.size()-(idxCount); b++){
                        cell = row.createCell((short) coloum);
                        cell.setCellValue("");
                        cell.setCellStyle(style4);
                        coloum++;
                    }
                    for(int kolom=0; kolom<listSalaryComp.size(); kolom++){
                        for(int x=yStart; x<yEnd; x++){
                            total += totalComp[x][kolom];
                        }
                        cell = row.createCell((short) coloum);
                        cell.setCellValue(Formater.formatNumber(total,""));
                        cell.setCellStyle(style4);
                        coloum++;
                        total = 0;
                    }
                    for(int x=yStart; x<yEnd; x++){
                        total += totalCombine[x];
                    }
                    cell = row.createCell((short) coloum);
                    cell.setCellValue(Formater.formatNumber(total,""));
                    cell.setCellStyle(style4);
                    coloum++;
                    total = 0;
                    ketemu = false;
                }
                coloum = 0;
                yStart = yEnd;
            }
                }
            }
            
            if (grandTotal0 == 0){
                if (isStatusData == true){
                    grandCols = grandCols - 1;
                }
                countRow++;

                row = sheet.createRow((short) countRow);
                for (int i =0; i< grandCols;i++){
                    cell = row.createCell((short) i);
                    if (i==0){
                        cell.setCellValue("Grand Total");
                    } else {
                        cell.setCellValue("");
                    }
                    cell.setCellStyle(style5);    
                }
    //            sheet.addMergedRegion(new CellRangeAddress(
    //                    countRow, //first row (0-based)
    //                    countRow, //last row  (0-based)
    //                    0, //first column (0-based)
    //                    (grandCols-1)  //last column  (0-based)
    //            ));
                coloum++;

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
                        cell = row.createCell((short) grandCols);
                        cell.setCellValue(Formater.formatNumber(grandTotalComp,""));
                        cell.setCellStyle(style5);
                        grandCols++;
                         if(listResultCompare.size()>0){
                            if(grandTotalComp == grandTotalCompCompare){
                                cell = row.createCell((short) grandCols);
                                cell.setCellValue(Formater.formatNumber(grandTotalCompCompare,""));
                                cell.setCellStyle(style5);
                                grandCols++;
                            }else{
                                cell = row.createCell((short) grandCols);
                                cell.setCellValue(Formater.formatNumber(grandTotalCompCompare,""));
                                cell.setCellStyle(style5Red);
                                grandCols++;
                            }
                         }    
                        grandTotalComp = 0;
                        grandTotalCompCompare = 0;
                }

                /* mengambil field combine */
                double grandTotalComb = 0;
                double grandTotalCombCompare = 0;
                for (int xx=0; xx<listComb.size(); xx++){
                    for(int y=0; y<listResult.size(); y++){
                        grandTotalComb = grandTotalComb +  totalCombine[y];
                        if(listResultCompare.size()>0){
                          if(listIdxCompare[y] != -1){
                            grandTotalCombCompare = grandTotalCombCompare + totalCombineCompare[listIdxCompare[y]] ;
                          }
                        }
                    }  
                    if (grandTotalComb != 0){
                        cell = row.createCell((short) grandCols);
                        cell.setCellValue(Formater.formatNumber(grandTotalComb,""));
                        cell.setCellStyle(style5);
                        grandCols++;
                        if(listResultCompare.size()>0){
                            if(grandTotalComb == grandTotalCombCompare){
                                cell = row.createCell((short) grandCols);
                                cell.setCellValue(Formater.formatNumber(grandTotalCombCompare,""));
                                cell.setCellStyle(style5);
                                grandCols++;
                            }else{
                                cell = row.createCell((short) grandCols);
                                cell.setCellValue(Formater.formatNumber(grandTotalCombCompare,""));
                                cell.setCellStyle(style5Red);
                                grandCols++;
                            }
                        }
                    }      
                    grandTotalComb = 0;
                    grandTotalCombCompare = 0;
                }
            }
            
        }
        
        
        if (empSignId != 0){
            
            Employee empSign = new Employee();
            try{
                empSign = PstEmployee.fetchExc(empSignId);
            } catch (Exception exc){
                System.out.println("Exception at fetch empSign : "+exc.toString());
            }
            
            Level levelEmpSign = new Level();
            try {
                levelEmpSign = PstLevel.fetchExc(empSign.getLevelId());
            } catch (Exception exc){
                System.out.println("Exception at fetch levelEmpSign : "+exc.toString());
            }
            
            Position posEmpSign = new Position();
            try {
                posEmpSign = PstPosition.fetchExc(empSign.getPositionId());
            } catch (Exception exc){
                System.out.println("Exception at fetch posEmpSign : "+exc.toString());
            }
            
            row = sheet.createRow((short) (countRow+2));
            cell = row.createCell((short) (cols-3));
            cell.setCellValue("PT. Bank Pembangunan Daerah Bali");
            sheet.addMergedRegion(new CellRangeAddress(
                    (countRow+2), //first row (0-based)
                    (countRow+2), //last row  (0-based)
                    (cols-3), //first column (0-based)
                    (cols-1)  //last column  (0-based)
            ));
            
            row = sheet.createRow((short) (countRow+3));
            cell = row.createCell((short) (cols-3));
            cell.setCellValue(posEmpSign.getPosition());
            sheet.addMergedRegion(new CellRangeAddress(
                    (countRow+3), //first row (0-based)
                    (countRow+3), //last row  (0-based)
                    (cols-3), //first column (0-based)
                    (cols-1)  //last column  (0-based)
            ));
            
            row = sheet.createRow((short) (countRow+6));
            CellStyle style = wb.createCellStyle();
            font = wb.createFont();
            font.setUnderline(Font.U_SINGLE);
            style.setFont(font);
            cell = row.createCell((short) (cols-3));
            cell.setCellValue(empSign.getFullName());
            cell.setCellStyle(style);
            sheet.addMergedRegion(new CellRangeAddress(
                    (countRow+6), //first row (0-based)
                    (countRow+6), //last row  (0-based)
                    (cols-3), //first column (0-based)
                    (cols-1)  //last column  (0-based)
            ));
            
            row = sheet.createRow((short) (countRow+7));
            cell = row.createCell((short) (cols-3));
            cell.setCellValue(empSign.getEmployeeNum());
            sheet.addMergedRegion(new CellRangeAddress(
                    (countRow+7), //first row (0-based)
                    (countRow+7), //last row  (0-based)
                    (cols-3), //first column (0-based)
                    (cols-1)  //last column  (0-based)
            ));
        }
        
        for (int i = 0; i < cols; i++){
            wb.getSheetAt(0).autoSizeColumn(i);
        }

        
        


        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
    }
    
    /* Convert double */
    public double convertDouble(String val){
        BigDecimal bDecimal = new BigDecimal(Double.valueOf(val));
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_EVEN);
        return bDecimal.doubleValue();
    }
    /* Convert int */
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_EVEN);
        return bDecimal.intValue();
    }

    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
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
}