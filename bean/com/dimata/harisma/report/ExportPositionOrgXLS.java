/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

import com.dimata.harisma.entity.employee.CareerPath;
import com.dimata.harisma.entity.employee.EmpEducation;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstCareerPath;
import com.dimata.harisma.entity.employee.PstEmpEducation;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.DivisionType;
import com.dimata.harisma.entity.masterdata.Education;
import com.dimata.harisma.entity.masterdata.EmployeeAndPosition;
import com.dimata.harisma.entity.masterdata.MappingPosition;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PositionDepartment;
import com.dimata.harisma.entity.masterdata.PositionDivision;
import com.dimata.harisma.entity.masterdata.PositionSection;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstDivisionType;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.entity.masterdata.PstMappingPosition;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstPositionDepartment;
import com.dimata.harisma.entity.masterdata.PstPositionDivision;
import com.dimata.harisma.entity.masterdata.PstPositionSection;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.entity.masterdata.StructureModule;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
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
import org.apache.poi.ss.util.CellRangeAddress;

/**
 *
 * @author Dimata 007
 */
public class ExportPositionOrgXLS extends HttpServlet {
    
    public String whereEmpGlobal = "";
    public long tempUpPos = -1; 
    public int incUp = 0;
    public int nomor = 0;
    public int incTd = 0;
    
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

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Struktur Organisasi");

        HSSFCellStyle style1 = wb.createCellStyle();
        
        HSSFCellStyle style2 = wb.createCellStyle();
        style2.setFillBackgroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style2.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
        HSSFFont font = wb.createFont();
        font.setColor(HSSFColor.WHITE.index);
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
        
        HSSFCellStyle styleOrange = wb.createCellStyle();
        HSSFFont fontOrange = wb.createFont();
        fontOrange.setColor(HSSFColor.ORANGE.index);
        styleOrange.setFont(fontOrange);
        
        HSSFCellStyle styleRed = wb.createCellStyle();
        HSSFFont fontRed = wb.createFont();
        fontRed.setColor(HSSFColor.RED.index);
        styleRed.setFont(fontRed);

        long selectStructure = FRMQueryString.requestLong(request, "select_structure");
        long divisionId = FRMQueryString.requestLong(request, "division_id");
        long departmentId = FRMQueryString.requestLong(request, "department_id");
        long sectionId = FRMQueryString.requestLong(request, "section_id");
        String whereClause = "";
        ChangeValue changeValue = new ChangeValue();
        /* Period From and Period To */
        String periodFrom = FRMQueryString.requestString(request, "period_from");
        String periodTo = FRMQueryString.requestString(request, "period_to");
        
        int countRow = 0;
        row = sheet.createRow((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("Laporan Struktur Organisasi "+periodFrom+" to "+periodTo);
        cell.setCellStyle(style1);
        
        int umurPensiun = 0;
        int umurMbt = 0;
        try {
            umurPensiun = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
            umurMbt = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
        } catch (Exception exc){}
     
        
    int checkUp = 0;
    long topMain = 0;
    /* get Data Division Type ID */
    Division division = new Division();
    String labelStructure = "-";
    long divisiTypeId = 0;
    int divType = 0;
    String testOut = "";
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        try {
            /* Output dari proses ini adalah division name dan division type (divType) */
            division = PstDivision.fetchExc(divisionId);
            divisiTypeId = division.getDivisionTypeId();

            if (divisiTypeId != 0){
                DivisionType divisiType = PstDivisionType.fetchExc(divisiTypeId);
                divType = divisiType.getGroupType();
            }
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    if (divisionId == 0 && departmentId != 0 && sectionId == 0){
        /* Jika departmentId tidak sama dengan 0, maka secara default division Type adalah Branch Of Company */
        divType = PstDivisionType.TYPE_BRANCH_OF_COMPANY;
    }
    if (divisionId == 0 && departmentId == 0 && sectionId != 0){
        divType = PstDivisionType.TYPE_BRANCH_OF_COMPANY;
    }
/*================== Position Available ==================*/
    /* end Get template name */
 /*
 * Update 2016-07-25
 * Load employee by Position and Period
 */
    
    Vector listPosition = new Vector();
    Vector listPosColl = new Vector();
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionId;
        listPosColl = PstPositionDivision.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionDivision posDiv = (PositionDivision)listPosColl.get(i);
                listPosition.add(posDiv.getPositionId());
            }
        }
    }
    if (divisionId == 0 && departmentId != 0 && sectionId == 0){
        whereClause = PstPositionDepartment.fieldNames[PstPositionDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
        listPosColl = PstPositionDepartment.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionDepartment posDep = (PositionDepartment)listPosColl.get(i);
                listPosition.add(posDep.getPositionId());
            }
        }
    }
    if (divisionId == 0 && departmentId == 0 && sectionId != 0){
        whereClause = PstPositionSection.fieldNames[PstPositionSection.FLD_SECTION_ID]+"="+sectionId;
        listPosColl = PstPositionSection.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionSection posSec = (PositionSection)listPosColl.get(i);
                listPosition.add(posSec.getPositionId());
            }
        }
    }
    /*===================================*/
    /* Sorting Position by Level         */
    /*
    SELECT hr_position.`POSITION_ID`, hr_level.`LEVEL` FROM hr_position
    INNER JOIN hr_level ON hr_position.`LEVEL_ID`=hr_level.`LEVEL_ID`
    ORDER BY hr_level.`LEVEL_RANK` DESC;
    */
    whereClause = "";
    if (listPosition != null && listPosition.size()>0){
        for(int i=0; i<listPosition.size(); i++){
            Long posId = (Long)listPosition.get(i);
            whereClause = whereClause + posId + ",";
        }
        whereClause = whereClause.substring(0, whereClause.length()-1);
    }
    
    if (departmentId != 0){
        /* Cari division id */
        String where = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
        Vector deptList = PstDepartment.listVerySimple(where);
        if (deptList != null && deptList.size()>0){
            Department dept = (Department)deptList.get(0);
            divisionId = dept.getDivisionId();
        }
    }
    
    if (sectionId != 0){
        String where = PstSection.fieldNames[PstSection.FLD_SECTION_ID]+"="+sectionId;
        Vector sectList = PstSection.list(0, 0, where, "");
        if (sectList != null && sectList.size()>0){
            Section sect = (Section)sectList.get(0);
            departmentId = sect.getDepartmentId();
            
            if (departmentId != 0){
                /* Cari division id */
                where = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
                Vector deptList = PstDepartment.listVerySimple(where);
                if (deptList != null && deptList.size()>0){
                    Department dept = (Department)deptList.get(0);
                    divisionId = dept.getDivisionId();
                }
            }
            departmentId = 0;
        }
    }
    Vector listPositionAfterSort = PstPosition.getPositionSortByLevel(whereClause);
    Vector employeeTemp = PstCareerPath.getEmployeeByPeriod(periodFrom, periodTo, divisionId, whereClause);
    Vector employeeList = new Vector();
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        employeeList = PstCareerPath.getEmployeeByPeriod(periodFrom, periodTo, divisionId, whereClause);
    }
    if (departmentId != 0 && sectionId == 0){
        if (employeeTemp != null && employeeTemp.size()>0){
            for(int e=0; e < employeeTemp.size(); e++){
                EmployeeAndPosition emp = (EmployeeAndPosition)employeeTemp.get(e);
                if (departmentId == emp.getDepartmentId()){
                    employeeList.add(emp);
                }
            }
        }
    }
    if (departmentId == 0 && sectionId != 0){
        if (employeeTemp != null && employeeTemp.size()>0){
            for(int e=0; e < employeeTemp.size(); e++){
                EmployeeAndPosition emp = (EmployeeAndPosition)employeeTemp.get(e);
                if (sectionId == emp.getSectionId()){
                    employeeList.add(emp);
                }
            }
        }
    }
    /*----------------------------------------------*/
    row = sheet.createRow((short) 2);
    cell = row.createCell((short) 0);
    cell.setCellValue("No");
    cell.setCellStyle(style3);
    
    cell = row.createCell((short) 1);
    cell.setCellValue("Position name");
    cell.setCellStyle(style3);
    
    cell = row.createCell((short) 2);
    cell.setCellValue("Jumlah");
    cell.setCellStyle(style3);
    
    int incRow = 2;
    int incRowTemp = 0;
    int total = 0;
        if (listPositionAfterSort != null && listPositionAfterSort.size()>0){
            for(int i=0; i<listPositionAfterSort.size(); i++){
                Long posId = (Long)listPositionAfterSort.get(i);
                int jumlah = 0;
                incRow++;
                incRowTemp = incRow;
                row = sheet.createRow((short) incRow);
                cell = row.createCell((short) 0);
                cell.setCellValue(i+1);
                cell.setCellStyle(style2);

                cell = row.createCell((short) 1);
                cell.setCellValue(getPositionName(posId));
                cell.setCellStyle(style2);
                
                cell = row.createCell((short) 2);
                cell.setCellValue(" ");
                cell.setCellStyle(style2);

                if (divType == PstDivisionType.TYPE_BOD){
                    long employeeOid = PstCareerPath.getEmployeeIdCaseBOD(periodFrom, periodTo, posId);
                    jumlah++;
                    cell = row.createCell((short) 2);
                    cell.setCellValue(jumlah);
                    cell.setCellStyle(style2);
                    incRow++;
                    row = sheet.createRow((short) incRow);            
                    cell = row.createCell((short) 1);
                    cell.setCellValue(infoEmp(employeeOid));
                    cell.setCellStyle(style1);

                } else {
                if (employeeList != null && employeeList.size()>0){
                    for(int e=0; e < employeeList.size(); e++){
                        EmployeeAndPosition emp = (EmployeeAndPosition)employeeList.get(e);
                        if (emp.getPositionId() == posId){
                            jumlah++;
                            cell = row.createCell((short) 2);
                            cell.setCellValue(jumlah);
                            cell.setCellStyle(style2);
                        }
                    }
                }
                
                if (employeeList != null && employeeList.size()>0){
                    for(int e=0; e < employeeList.size(); e++){
                        EmployeeAndPosition emp = (EmployeeAndPosition)employeeList.get(e);
                        if (emp.getPositionId() == posId){
                            incRow++;
                            row = sheet.createRow((short) incRow);
                            cell = row.createCell((short) 1);
                            cell.setCellValue(infoEmp(emp.getEmployeeId()));
                            String clss = "";
                            int empAge = PstEmployee.getEmployeeAge(emp.getEmployeeId());
                            if (empAge == umurMbt){
                                cell.setCellStyle(styleOrange);
                            } else if (empAge >= umurPensiun){
                                cell.setCellStyle(styleRed);
                            }
                        }
                    }
                }
                }


                total = total + jumlah;
            }
        }

        incRow++;
        row = sheet.createRow((short) incRow++);
        cell = row.createCell((short) 0);
        cell.setCellValue(" ");
        cell.setCellStyle(style3);
        
        cell = row.createCell((short) 1);
        cell.setCellValue("Total All");
        cell.setCellStyle(style3);

        cell = row.createCell((short) 2);
        cell.setCellValue(total);
        cell.setCellStyle(style3);

        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
    
    }
    
    public String getEmpCareerPath(Vector dataNoResign, String whereClause, String dateFrom, String dateTo){
        String output = "";
        //String listEmp = "";
        Vector empOnCareer = new Vector();
        String[] arrDFrom = dateFrom.split("-");
        String[] arrDTo = dateTo.split("-");
        int intDateFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
        int intDateTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
        if (dataNoResign != null && dataNoResign.size()>0){
            String whereIn = "";
            for(int i=0; i<dataNoResign.size(); i++){
                Employee employee = (Employee)dataNoResign.get(i);
                whereIn += employee.getOID()+",";
            }
            whereIn += "0";
            String where = whereClause;
            //where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+dateFrom+"'";
           // where += " AND '"+dateTo+"'";
            where += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector listCareer = PstCareerPath.list(0, 0, where, "");

            if (listCareer != null && listCareer.size()>0){
                for (int i=0; i<listCareer.size(); i++){
                    CareerPath career = (CareerPath)listCareer.get(i);
                    String startDate = ""+career.getWorkFrom();
                    String endDate = ""+career.getWorkTo();
                    String[] arrStartDate = startDate.split("-");
                    String[] arrEndDate = endDate.split("-");
                    int intStartDate = Integer.valueOf(arrStartDate[0] + arrStartDate[1] + arrStartDate[2]);
                    int intEndDate = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
                    if (intStartDate >= intDateFrom){

                        //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                        output += "<div class=\"item\">"+infoEmp(career.getEmployeeId())+"</div>";
                        empOnCareer.add(career.getEmployeeId());
                    } else {
                        if (intEndDate >= intDateFrom){

                            //listEmp += "<div>FC: "+career.getEmployeeId()+"</div>";
                            output += "<div class=\"item\">"+infoEmp(career.getEmployeeId())+"</div>";
                            empOnCareer.add(career.getEmployeeId());
                        }
                    }
                }
                //amount = amount + careerPath.size();
            }
            /* manipulasi whereIn */
            if (empOnCareer != null && empOnCareer.size()>0){
                for (int j=0; j<empOnCareer.size(); j++){
                    Long empId = (Long)empOnCareer.get(j);
                    String oldChar = ""+empId;
                    whereIn = whereIn.replace(oldChar, "0");
                }
            }

            where = whereClause + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" IN("+whereIn+")";
            Vector empData = getEmployeeData(where);
            if (empData != null && empData.size()>0){
                for (int i=0; i<empData.size(); i++){
                    Employee emp = (Employee)empData.get(i);
                    /* cek Work From */
                    int workFrom = getWorkFromEmployee(emp.getOID());
                    if (workFrom >= intDateFrom){
                        if (workFrom <= intDateTo){
                            output += "<div class=\"item\">"+infoEmp(emp.getOID())+"</div>";
                        }
                    } else {
                        output += "<div class=\"item\">"+infoEmp(emp.getOID())+"</div>";
                    }
                }
            }
        }
        return output;
    }
    
    public String infoEmp(long employeeId){
        String output = "";
        try {
            Employee emp = PstEmployee.fetchExc(employeeId);
            output = emp.getFullName()+" ("+emp.getEmployeeNum()+")";
        } catch(Exception e){
            System.out.print(""+e.toString());
        }
        return output;
    }
    
    public int getWorkFromEmployee(long employeeId){
        int intWorkFrom = 0;
        String where = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employeeId;
        String order = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" DESC";
        Vector listCareer = PstCareerPath.list(0, 1, where, order);
        if (listCareer != null && listCareer.size()>0){
            CareerPath career = (CareerPath)listCareer.get(0);
             /* Get the next Date */
            String nextDate = "-";
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); /*new SimpleDateFormat("dd MMMM yyyy");*/
                Calendar c = Calendar.getInstance();
                c.setTime(career.getWorkTo());
                c.add(Calendar.DATE, 1);  // number of days to add
                nextDate = sdf.format(c.getTime());  // dt is now the new date
                String[] arrEndDate = nextDate.split("-");
                intWorkFrom = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
            } catch(Exception e){
                System.out.println("Date=>"+e.toString());
            }
            
        } else {
            /* get Commencing date */
            try {
                Employee emp = PstEmployee.fetchExc(employeeId);
                String endDate = ""+emp.getCommencingDate();
                String[] arrEndDate = endDate.split("-");
                intWorkFrom = Integer.valueOf(arrEndDate[0] + arrEndDate[1] + arrEndDate[2]);
            } catch(Exception e){
                System.out.println(e.toString());
            }
        }
        return intWorkFrom;
    }
    
    public static Vector getEmployeeData(String whereClause){
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = " SELECT * FROM "+PstEmployee.TBL_HR_EMPLOYEE;
            sql += " WHERE ";            
            sql += whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                list.add(employee);
            }

            rs.close();
            return list;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return list;
    }
    
    public String getDrawDownPosition(long oidPosition, long oidTemplate, String approot){
        String str = "";
        String whereEmployee = "";
        StructureModule structureModule = new StructureModule();
        structureModule.setWhereEmployee(this.whereEmpGlobal);
        String whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+"="+oidPosition;
        whereClause += " AND "+PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+oidTemplate;
        Vector listDown = PstMappingPosition.list(0, 0, whereClause, "");
        String topkiri = "border-top:1px solid #999;";
        String topkanan = "border-top:1px solid #999;";
        if (listDown != null && listDown.size()>0){
            str = "<table class=\"tblStyle1\"><tr>";
            for(int i=0; i<listDown.size(); i++){
                MappingPosition pos = (MappingPosition)listDown.get(i);
                whereEmployee = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+pos.getDownPositionId();
                structureModule.setupEmployee(whereEmployee);     
                if (listDown.size() == 1){
                    topkiri = "";
                    topkanan = "";
                } else {
                    if (i == 0 || i == (listDown.size()-1)){
                        if (i == 0){
                            topkiri = "";
                            topkanan = "border-top:1px solid #999;";
                        } else {
                            topkiri = "border-top:1px solid #999;";
                            topkanan = "";
                        }
                    } else {
                        topkiri = "border-top:1px solid #999;";
                        topkanan = "border-top:1px solid #999;";
                    }
                }
                
                str += "<td valign=\"top\">";
                
                str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
                str += "<tr>";
                str += "<td width=\"50%\" style=\"border-right:1px solid #999; "+topkiri+"\">&nbsp;</td><td width=\"50%\" style=\""+topkanan+"\">&nbsp;</td>";
                str += "</tr>";
                str += "</table>";
                
                String pictPath = "";
                 
                
                if (pictPath != null && pictPath.length() > 0) {
                   str += "<img  height=\"64\" id=\"photo\" src=\"" + approot + "/" + pictPath + "\">";
                } else {
                   str += "<img height=\"64\" id=\"photo\" src=\""+approot+"/imgcache/no-img.jpg\" />";   
                }

                if (structureModule.getEmployeeResign()== 0){
                    str += "<div style=\"color: #373737\"><a id=\"linkStyle\" href=\"javascript:cmdViewEmployee('" + structureModule.getEmployeeId() + "')\">";
                    str += "<strong>"+ structureModule.getEmployeeName() + "</strong></a></div>";
                    str += "<div>" + getPositionName(pos.getDownPositionId()) + "</div>" + getDrawDownPosition(pos.getDownPositionId(), oidTemplate, approot);
                } else {
                    str += "<div style=\"color: #373737\"><strong>-Kosong-</strong></div>";
                    str += "<div>" + getPositionName(pos.getDownPositionId()) + "</div>" + getDrawDownPosition(pos.getDownPositionId(), oidTemplate, approot); 
                }
                str += "</td>";
            }
            str += "</tr></table>";
        }
        
        return str;
    }
    
    public String getPositionName(long posId){
        String position = "";
        Position pos = new Position();
        try {
            pos = PstPosition.fetchExc(posId);
        } catch(Exception ex){
            System.out.println("getPositionName ==> "+ex.toString());
        }
        position = pos.getPosition();
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
