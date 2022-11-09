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

<!DOCTYPE html>

<%

    response.setHeader("Content-Disposition","attachment;filename= Laporan_LKPBU_803.xls");
    
    String sandiPelapor = PstSystemProperty.getValueByNameWithStringNull("LKPBU_SANDI_PELAPOR");  
    String lkpbu803Period = PstSystemProperty.getValueByNameWithStringNull("LKPBU_803_PERIOD");  
    String lkpbuRptType = PstSystemProperty.getValueByNameWithStringNull("LKPBU_803_RPT_TYPE"); 
    int year = FRMQueryString.requestInt(request,"year");    
    
    HashMap<String, Lkpbu> mapLkpbu803= new HashMap<String, Lkpbu>();
    //int year = session.getValue("year");
    
    if(session.getValue("listresult")!=null){
        mapLkpbu803 = (HashMap<String, Lkpbu>)session.getValue("listresult"); 
    }
    
    int[] data = new int[5];
    
    Arrays.sort(data);
    
    Vector listKadiv = new Vector(1, 1);

    if(session.getValue("listkadiv")!=null){
        listKadiv = (Vector)session.getValue("listkadiv"); 
    }
    
%>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
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
                            <b>DATA STRUKTUR TENAGA KERJA MENURUT JENJANG INFORMASI</b><br>
                            <b>PENDIDIKAN, STATUS TENAGA KERJA, JENIS KELAMIN, USIA, PENDIDIKAN</b><br>
                            <b>DAN JABATAN</b><br>
                            <b>Form 803</b>
                        </p>
                    </center>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="1">
                        <tr style="text-align: center">
                            <td colspan="2">Sandi Pelapor</td>
                            <td>Jenis Periode Laporan</td>
                            <td>Periode Data Laporan</td>
                            <td>Jenis Pelaporan</td>
                            <td>No Form</td>
                            <td>Jumlah Record Isi</td>  
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="2">="<%=sandiPelapor%>"</td>
                            <td><%=lkpbu803Period%></td>
                            <td><%=year+"0101"%></td>
                            <td><%=lkpbuRptType%></td>
                            <td>="803"</td>
                            <td>="<%=mapLkpbu803.size()%>"</td>
                        </tr>
                        <tr style="text-align: center">
                            <td>Status Pegawai</td>               
                            <td>Jenis Usia</td>
                            <td>Jenis Jabatan</td>
                            <td>Jenis Pendidikan</td>
                            <td>Jenis Pekerjaan Berdasarkan Jenis Tenaga Kerja</td>	
                            <td>Jumlah Laki-laki</td>
                            <td>Jumlah Perempuan</td>
                        </tr>
                        <%
                            if(!mapLkpbu803.isEmpty()){
                            
                            Map<String, Lkpbu> sorted = new TreeMap<String, Lkpbu>(mapLkpbu803);
                            for(Lkpbu temp: sorted.values()){
                        %>
                            <tr>
                        <td>="<%=temp.getStatusPegawai()%>"</td>
                            <td>="<%=temp.getJenisUsia()%>"</td>
                            <td>="<%=temp.getJenisJabatan()%>"</td>
                            <td>="<%=temp.getJenisPendidikan()%>"</td>
                            <td>="<%=temp.getJenisPekerjaan()%>"</td>
                            <td><%=temp.getJumlahLaki()%></td>
                            <td><%=temp.getJumlahPerempuan()%></td>
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
                        <%
                        if(listKadiv.size() > 0){
                            Lkpbu lkpbu = (Lkpbu)listKadiv.get(0);
                            String str_dt_now = ""; 
                            Date dt_NowDate = new Date();
                            str_dt_now = Formater.formatDate(dt_NowDate, "dd MMMM yyyy");
                        %>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3">......................, <%=str_dt_now%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><%=lkpbu.getCompanyTtd()%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><%=lkpbu.getDivisiTtd()%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3">Kepala,</td>
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
                            <td colspan="3"><b><u><%=lkpbu.getNameTtd()%></u></b></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="3"></td>
                            <td colspan="3"><b>NRK.<%=lkpbu.getEmpNumTtd()%></b></td>
                        </tr>
                        <%}%>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>

