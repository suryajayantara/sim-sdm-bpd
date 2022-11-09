/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.FamilyMember;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.PstFamilyMember;
import com.dimata.harisma.entity.masterdata.FamRelation;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstFamRelation;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

/**
 *
 * @author Dimata 007
 */
public class ReportPihakTerkait extends HttpServlet {

       
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }
    
    public void destroy() {/*no-code*/}
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        
        int iCommand = FRMQueryString.requestCommand(request);
        String fldNrk = FRMQueryString.requestString(request, "field_nrk");
        String fldName = FRMQueryString.requestString(request, "field_name");
        long companyId = FRMQueryString.requestLong(request, "frm_company_id");
        long divisionId = FRMQueryString.requestLong(request, "frm_division_id");
        long departmentId  = FRMQueryString.requestLong(request, "frm_department_id");
        long sectionId = FRMQueryString.requestLong(request, "frm_section_id");
        String whereClause = "";
        Vector employeeList = new Vector();

        if (iCommand == Command.SEARCH){
            Vector whereVect = new Vector();

            if (fldNrk.length()>0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+fldNrk+"'";
                whereVect.add(whereClause);
            }
            if (fldName.length()>0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+"='"+fldName+"'";
                whereVect.add(whereClause);
            }
            if (companyId != 0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
                whereVect.add(whereClause);
            }
            if (divisionId != 0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
                whereVect.add(whereClause);
            }
            if (departmentId != 0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
                whereVect.add(whereClause);
            }
            if (sectionId != 0){
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
                whereVect.add(whereClause);
            }

            whereClause = "";
            if (whereVect != null && whereVect.size()>0){
                for (int i=0; i<whereVect.size(); i++){
                    String where = (String)whereVect.get(i);
                    whereClause += where;
                    if (i == (whereVect.size()-1)){
                        whereClause += " ";
                    } else {
                        whereClause += " AND ";
                    }
                }
            }

            employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]);
        }
        
        String[] dataChar = {
            "a",
            "b",
            "c",
            "d",
            "e",
            "f",
            "g",
			"h",
			"i",
			"j",
			"k",
			"l"
        };
        
        Workbook wb = new HSSFWorkbook();
        Sheet sheet = wb.createSheet("Laporan Pihak Terkait");

        Row row = sheet.createRow((short) 0);
        Cell cell = row.createCell((short) 0);
        cell.setCellValue("Daftar Rincian Pihak Terkait");

        sheet.addMergedRegion(new CellRangeAddress(
                0, //first row (0-based)
                0, //last row  (0-based)
                0, //first column (0-based)
                4  //last column  (0-based)
        ));
/* Row 2 */
        row = sheet.createRow((short) 2);
        cell = row.createCell((short) 0);
        cell.setCellValue("No");
        sheet.addMergedRegion(new CellRangeAddress(2, 4, 0, 0));
        
        cell = row.createCell((short) 1);
        cell.setCellValue("Nama Pihak Terkait");
        sheet.addMergedRegion(new CellRangeAddress(2, 4, 1, 1));
        
        cell = row.createCell((short) 2);
        cell.setCellValue("Hubungan Kepemilikan Saham");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 2, 5));
        
        cell = row.createCell((short) 6);
        cell.setCellValue("Hubungan Kepengurusan");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 6, 10));
        
        cell = row.createCell((short) 11);
        cell.setCellValue("Hubungan Keluarga");
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 11, 12));
        
        cell = row.createCell((short) 13);
        cell.setCellValue("Hubungan Keuangan");
/* Row 3 */ 
        row = sheet.createRow((short) 3);
        cell = row.createCell((short) 2);
        cell.setCellValue("Pada Bank BPD Bali %");
        sheet.addMergedRegion(new CellRangeAddress(3, 4, 2, 2));
        
        cell = row.createCell((short) 3);
        cell.setCellValue("Pada Perusahaan Lainnya");
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 3, 5));
        
        cell = row.createCell((short) 6);
        cell.setCellValue("Jabatan Pada Bank BPD Bali");
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 6, 7));
        
        cell = row.createCell((short) 8);
        cell.setCellValue("Jabatan Pada Perusahaan Lainnya");
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 8, 10));
        
        cell = row.createCell((short) 11);
        cell.setCellValue("Nama Keluarga");
        sheet.addMergedRegion(new CellRangeAddress(3, 4, 11, 11));
        
        cell = row.createCell((short) 12);
        cell.setCellValue("Status (*)");
        sheet.addMergedRegion(new CellRangeAddress(3, 4, 12, 12));
        
        cell = row.createCell((short) 13);
        cell.setCellValue("Pada Pihak Lain & Pihak Penjamin");
        sheet.addMergedRegion(new CellRangeAddress(3, 4, 13, 13));
/* Row 4 */         
        row = sheet.createRow((short) 4);
        cell = row.createCell((short) 3);
        cell.setCellValue("Nama Perusahaan");
        
        cell = row.createCell((short) 4);
        cell.setCellValue("Sektor Usaha");
        
        cell = row.createCell((short) 5);
        cell.setCellValue("%");
        
        cell = row.createCell((short) 6);
        cell.setCellValue("Jabatan");
        
        cell = row.createCell((short) 7);
        cell.setCellValue("Sejak");
        
        cell = row.createCell((short) 8);
        cell.setCellValue("Jabatan");
        
        cell = row.createCell((short) 9);
        cell.setCellValue("Nama Perusahaan");
        
        cell = row.createCell((short) 10);
        cell.setCellValue("Sektor Usaha");
        /* start from Row 5 */
        int rowFrom = 5;
        int rowTo = 0;
        int size = 0;
        if (employeeList != null && employeeList.size()>0){
            for (int i=0; i<employeeList.size(); i++){
                Employee emp = (Employee)employeeList.get(i);
                
                whereClause = PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                Vector famList = PstFamilyMember.list(0, 0, whereClause, PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP]);
                if (!famList.isEmpty()){
                    size = famList.size() - 1;
                } else {
                    size = 0;
                }
                rowTo = rowFrom + size;
                
                row = sheet.createRow((short) rowFrom);
                cell = row.createCell((short) 0);
                cell.setCellValue(i+1);
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 0, 0));
                
                cell = row.createCell((short) 1);
                cell.setCellValue(emp.getEmployeeNum()+" - "+emp.getFullName());
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 1, 1));
                
                cell = row.createCell((short) 2);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 2, 2));
                
                cell = row.createCell((short) 3);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 3, 3));
                
                cell = row.createCell((short) 4);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 4, 4));
                
                cell = row.createCell((short) 5);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 5, 5));
                
                cell = row.createCell((short) 6);
                cell.setCellValue(getPositionName(emp.getPositionId()));
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 6, 6));
                
                cell = row.createCell((short) 7);
                cell.setCellValue(Formater.formatDate(emp.getCommencingDate(),"dd MMMM yyyy"));
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 7, 7));
                
                cell = row.createCell((short) 8);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 8, 8));
                
                cell = row.createCell((short) 9);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 9, 9));
                
                cell = row.createCell((short) 10);
                cell.setCellValue(" ");
                sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowTo, 10, 10));
                
                if (famList != null && famList.size()>0){
                    for (int j=0; j < famList.size(); j++){
                        FamilyMember fam = (FamilyMember)famList.get(j);
                        Vector listRelationX = PstFamRelation.listRelationName(0,0,fam.getRelationship(),""); 
                        FamRelation famRelation = (FamRelation) listRelationX.get(0);
                        
                        cell = row.createCell((short) 11);
                        cell.setCellValue(dataChar[famRelation.getFamRelationType()]+") "+ fam.getFullName());
                        
                        cell = row.createCell((short) 12);
                        cell.setCellValue(famRelation.getFamRelation());
                        if (j < famList.size()){
                            rowFrom++;
                            row = sheet.createRow((short) rowFrom);
                        }
                    }
                }
                rowFrom = rowFrom + 1;
            }
        }

        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("Keterangan (*)");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("a = Orang Tua Kandung / Tiri / Angkat");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("b = Saudara Kandung / Tiri / Angkat");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("c = Suami atau Istri");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("d = Mertua atau Besan");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("e = Anak Kandung / Tiri / Angkat");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("f = Kakek atau Nenek Kandung / Tiri / Angkat");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        rowFrom++;
        row = sheet.createRow((short) rowFrom);
        cell = row.createCell((short) 0);
        cell.setCellValue("g = Cucu Kandung / Tiri / Angkat");
        sheet.addMergedRegion(new CellRangeAddress(rowFrom, rowFrom, 0, 5));
        
        // Write the output to a file
        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
    
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