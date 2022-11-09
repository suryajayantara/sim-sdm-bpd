<%-- 
    Document   : laporan_pihak_terkait_xls
    Created on : 11-Oct-2017, 14:22:35
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.FamRelation"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstFamRelation"%>
<%@page import="com.dimata.harisma.entity.employee.FamilyMember"%>
<%@page import="com.dimata.harisma.entity.employee.PstFamilyMember"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.employee.PstCareerPath"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="java.util.Vector"%>
<%@ include file = "../../../main/javainit.jsp" %>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<%!
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
%>
<%
    response.setHeader("Content-Disposition","attachment; filename=laporan_pihak_terkait.xls ");
    int iCommand = FRMQueryString.requestCommand(request);
    String fldNrk = FRMQueryString.requestString(request, "field_nrk");
    String fldName = FRMQueryString.requestString(request, "field_name");
    long companyId = FRMQueryString.requestLong(request, "frm_company_id");
    long divisionId = FRMQueryString.requestLong(request, "frm_division_id");
    long departmentId  = FRMQueryString.requestLong(request, "frm_department_id");
    long sectionId = FRMQueryString.requestLong(request, "frm_section_id");
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    String whereClause = "";
    Vector employeeList = new Vector();
    
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
    if (employeeId != 0){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+"="+employeeId;
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
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table border="0">
             <tr>
                <td colspan="14" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 18px"><strong>Daftar Rincian Pihak Terkait</strong></td>
            </tr>
            <tr></tr>
            <tr></tr>
        </table>
        <table border="1">
                <tr valign="top" style="text-align: center; font-size: 12px"> <!--font 9 on excel-->
                    <td rowspan="3">
                        <strong>No.</strong>
                    </td>
                    <td rowspan="3">
                        <strong>Nama Pihak Terkait</strong>
                    </td>
                    <td colspan="4">
                        <strong>Hubungan Kepemilikan Saham</strong>
                    </td>
                    <td colspan="5">
                        <strong>Hubungan Kepengurusan</strong>
                    </td>
                    <td colspan="2">
                        <strong>Hubungan Keluarga</strong>
                    </td>
                    <td>
                        <strong>Hubungan Keuangan</strong>
                    </td>
                </tr>
                <tr valign="top" style=" text-align: center;font-size: 12px">
                    <td rowspan="2">
                        <strong>Pada Bank BPD Bali %</strong>
                    </td>
                    <td colspan="3">
                        <strong>Pada Perusahaan Lainnya</strong>
                    </td>
                    <td colspan="2">
                        <strong>Jabatan Pada Bank BPD Bali</strong>
                    </td>
                    <td colspan="3">
                        <strong>Jabatan Pada Perusahaan Lainnya</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Nama Keluarga</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Status (*)</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Pada Pihak Lain & Pihak Penjamin</strong>
                    </td>
                </tr>
                <tr valign="top" style=" text-align: center;font-size: 12px">
                    <td>
                        <strong>Nama Perusahaan</strong>
                    </td>
                    <td>
                        <strong>Sektor Usaha</strong>
                    </td>
                    <td>
                        <strong>%</strong>
                    </td>
                    <td>
                        <strong>Jabatan</strong>
                    </td>
                    <td>
                        <strong>Sejak</strong>
                    </td>
                    <td>
                        <strong>Jabatan</strong>
                    </td>
                    <td>
                        <strong>Nama Perusahaan</strong>
                    </td>
                    <td>
                        <strong>Sektor Usaha</strong>
                    </td>
                </tr>
                <%
                if (employeeList != null && employeeList.size()>0){
                    for (int i=0; i<employeeList.size(); i++){
                        Employee emp = (Employee)employeeList.get(i);
                        
                        String since = PstCareerPath.getLastWorkFrom(emp.getOID());
                %>
                <tr style=" font-size: 13px">
                    <td style="vertical-align: middle"><%= (i+1) %></td>
                    <td style="vertical-align: middle"><%= emp.getFullName() %></td>
                    <td style="vertical-align: middle"></td>
                    <td style="vertical-align: middle"></td>
                    <td style="vertical-align: middle"></td>
                    <td style="vertical-align: middle"></td>
                    <td style="vertical-align: middle"><%= getPositionName(emp.getPositionId()) %></td>
                    <td style="vertical-align: middle"><%=since%></td>

                    <td style="vertical-align: middle">&nbsp;</td>
                    <td style="vertical-align: middle">&nbsp;</td>

                    <td style="vertical-align: middle"></td>
                    <td colspan="2">
                        <%
                        whereClause = PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                        Vector famList = PstFamilyMember.list(0, 0, whereClause, PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP]);
                        if (famList != null && famList.size()>0){
                        %>
                        <table border="1">
                            <%
                            for (int j=0; j < famList.size(); j++){
                                FamilyMember fam = (FamilyMember)famList.get(j);
                                Vector listRelationX = PstFamRelation.listRelationName(0,0,fam.getRelationship(),""); 
                                FamRelation famRelation = (FamRelation) listRelationX.get(0);
                            %>
                            <tr>
                                <td><strong>(<%= dataChar[famRelation.getFamRelationType()] %>)</strong> <%= fam.getFullName() %></td>
                                <td><%= famRelation.getFamRelation() %></td>
                            </tr>
                            <% } %>
                        </table>
                        <% 
                        }                     
                        %>
                    </td>
                    <td></td>
                </tr>
                <% 
                    }
                }
                %>
            </table> 
            <table>
                <tr></tr>
                <tr>
                    <td colspan="6"><strong>Keterangan (*) :</strong></td>
                </tr>
                <tr>
                    <td colspan="6">a   = Orang Tua Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>
                    <td colspan="6">b   = Saudara Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>    
                    <td colspan="6">c   = Suami atau istri</td>
                </tr>
                <tr>   
                    <td colspan="6">d   = Mertua atau Besan</td>
                </tr>
                <tr>    
                    <td colspan="6">e   = Anak Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>   
                    <td colspan="6">f   = Kakek atau Nenek Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>    
                    <td colspan="6">g   = Cucu Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>    
                    <td colspan="6">h   = Saudara Kandung/ Tiri/ Angkat dari Orang Tua</td>
                </tr>
                <tr>    
                    <td colspan="6">i   = Suami atau Istri dari Anak Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>    
                    <td colspan="6">j   = Kakek atau Nenek dari Suami atau Istri</td>
                </tr>
                <tr>    
                    <td colspan="6">k   = Suami atau Istri dari Cucu Kandung/ Tiri/ Angkat</td>
                </tr>
                <tr>    
                    <td colspan="6">l   = Saudara Kandung/ Tiri/ Angkat dari Suami atau Istri Beserta Suami atau Istrinya dari Saudara yang Bersangkutan</td>
                </tr>
            </table>
    </body>
</html>
