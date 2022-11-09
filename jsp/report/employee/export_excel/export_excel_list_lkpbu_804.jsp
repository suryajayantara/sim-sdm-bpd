<%-- 
    Document   : export_excel_list_lkpbu_801
    Created on : Aug 11, 2015, 3:44:55 PM
    Author     : khirayinnura
--%>

<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" %>
<!-- package java -->
<%@ page import ="java.util.*,
                  java.text.*,				  
                  com.dimata.qdep.form.*,				  
                  com.dimata.gui.jsp.*,
                  com.dimata.util.*,				  
                  com.dimata.harisma.entity.masterdata.*,				  				  
                  com.dimata.harisma.entity.employee.*,
                  com.dimata.harisma.entity.attendance.*,
                  com.dimata.harisma.entity.search.*,
                  com.dimata.harisma.form.masterdata.*,				  				  
                  com.dimata.harisma.form.attendance.*,
                  com.dimata.harisma.form.search.*,				  
                  com.dimata.harisma.session.attendance.*,
                  com.dimata.harisma.session.leave.SessLeaveApp,
                  com.dimata.harisma.session.leave.*,
                  com.dimata.harisma.session.attendance.SessLeaveManagement,
                  com.dimata.harisma.session.leave.RepItemLeaveAndDp"%>
<!-- package qdep -->
<%@ include file = "../../../main/javainit.jsp" %>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<%
    
    response.setHeader(" Content-Disposition","attachment;filename= Laporan_LKPBU_804.xls ");

    int year = FRMQueryString.requestInt(request,"year");
    HashMap<String, Lkpbu> mapLkpbu804= new HashMap<String, Lkpbu>();
    //int year = session.getValue("year");
    
    if(session.getValue("listresult")!=null){
        mapLkpbu804 = (HashMap<String, Lkpbu>)session.getValue("listresult"); 
    }
    
    String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
    String oidPelapor = PstSystemProperty.getValueByName("LKPBU_OID_PELAPOR");
    Employee employee = new Employee();
    Division division = new Division();
    Level level = new Level();
    try {
        employee = PstEmployee.fetchExc(Long.parseLong(oidPelapor));
        division = PstDivision.fetchExc(employee.getDivisionId());
        level = PstLevel.fetchExc(employee.getLevelId());
    } catch (Exception exc){
        
    }
    String str_dt_now = ""; 
    Date dt_NowDate = new Date();
    str_dt_now = Formater.formatDate(dt_NowDate, "dd MMMM yyyy");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- #EndEditable -->
    </head>
    <body>
        
        <table>
            <tr>
                <td>
                    <center>
                        <p>
                            <b>TENAGA KERJA PERBANKAN</b><br>
                            <b>PERKEMBANGAN JUMLAH TENAGA KERJA PENSIUN, PENSIUN DINI DAN</b><br>
                            <b>TENAGA KERJA DIBERHENTIKAN Form 804</b>
                         </p>
                    </center>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="1">
                        <tr style="text-align: center">
                            <td>Sandi Pelapor</td>
                            <td>Jenis Periode Laporan</td>
                            <td>Periode Data Laporan</td>
                            <td>Jenis Laporan</td>
                            <td>No Form</td>
                            <td>Jumlah Record Isi</td>  
                        </tr>
                        <tr style="text-align: center">
                            <td>="<%=sandiPelapor%>"</td>
                            <td>A</td>
                            <td><%=year+"0101"%></td>
                            <td>A</td>
                            <td>804</td>
                            <td><%=mapLkpbu804.size()%></td>  
                        </tr>
                        <tr style="text-align: center">
                            <td style="text-align: center" rowspan="2">Kategori Pegawai Berhenti</td>               
                            <td style="text-align: center" rowspan="2">Jenis Jabatan</td>
                            <td colspan="4">Jumlah Tenaga Kerja</td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="2">Laki-laki</td>
                            <td colspan="2">Perempuan</td>
                        </tr>
                        <%
                            if(!mapLkpbu804.isEmpty()){
                            
                            Map<String, Lkpbu> sorted = new TreeMap<String, Lkpbu>(mapLkpbu804);
                            for(Lkpbu temp: sorted.values()){
                        %>
                            <tr>
                            <td>="<%=temp.getResignCategory()%>"</td>
                            <td>="<%=temp.getJenisJabatan()%>"</td>
                            <td colspan="2"><%=temp.getJumlahLaki()%></td>
                            <td colspan="2"><%=temp.getJumlahPerempuan()%></td>
                        </tr>
                        <%  }
                            }%>
                    </table>
                </td>
            </tr>
            <tr>
                <td></td>
            </tr>
            <tr>
                <td>
                    <table width="100%" >
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3">Denpasar, <%=str_dt_now%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3">PT. BANK PEMBANGUNAN DAERAH BALI</td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><%=division.getDivision()%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><%=level.getLevel()%></td>
                        </tr>
                        <tr>
                            <td colspan="3"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="3"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="3"></td>
                            <td colspan="3"></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><b><u><%=employee.getFullName()%></u></b></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><b>NRK. <%=employee.getEmployeeNum()%></b></td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>

