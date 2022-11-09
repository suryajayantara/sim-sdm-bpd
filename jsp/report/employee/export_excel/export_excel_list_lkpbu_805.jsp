<%-- 
    Document   : export_excel_list_lkpbu_801
    Created on : Aug 11, 2015, 3:44:55 PM
    Author     : khirayinnura
--%>

<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu805"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu805"%>
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
    response.setHeader("Content-Disposition","attachment;filename= Laporan_LKPBU_805.xls");
    
    String sandiPelapor = PstSystemProperty.getValueByNameWithStringNull("LKPBU_SANDI_PELAPOR");  
    String lkpbu803Period = PstSystemProperty.getValueByNameWithStringNull("LKPBU_803_PERIOD");  
    String lkpbuRptType = PstSystemProperty.getValueByNameWithStringNull("LKPBU_803_RPT_TYPE"); 
    int year = FRMQueryString.requestInt(request,"year");    

    HashMap<String, Lkpbu> mapLkpbu805= new HashMap<String, Lkpbu>();
    //int year = session.getValue("year");
    
    if(session.getValue("listLkpbu805")!=null){
        mapLkpbu805 = (HashMap<String, Lkpbu>)session.getValue("listLkpbu805"); 
    }
    
    int[] data = new int[5];
    
    Arrays.sort(data);
    
    Vector listKadiv = new Vector(1, 1);

    String oidPelapor = PstSystemProperty.getValueByName("LKPBU_OID_PELAPOR");
    Employee employeeKadiv = new Employee();
    Division division = new Division();
    Level level = new Level();
    try {
        employeeKadiv = PstEmployee.fetchExc(Long.parseLong(oidPelapor));
        division = PstDivision.fetchExc(employeeKadiv.getDivisionId());
        level = PstLevel.fetchExc(employeeKadiv.getLevelId());
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
        
    </head>
    <body>
        <!--%=drawList(listResult)%-->
        
        <table>
            <tr>
                <td>
                    <center>
                        <p>
                            <b>TENAGA KERJA PERBANKAN</b><br>
                            <b>PREDIKSI KEBUTUHAN PEGAWAI BERDASARKAN</b><br>
                            <b>JENIS PEKERJAAN DAN KUALIFIKASI Form 805</b>
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
                            <td colspan="2">No Form</td>
                            <td colspan="2">Jumlah Record Isi</td>  
                        </tr>
                        <tr style="text-align: center">
                            <td>="<%=sandiPelapor%>"</td>
                            <td>A</td>
                            <td><%=year+"0101"%></td>
                            <td>A</td>
                            <td colspan="2">805</td>
                            <td colspan="2"><%=mapLkpbu805.size()%></td>  
                        </tr>
                        <tr style="text-align: center; vertical-align: middle">
                            <td rowspan="2">Jenis Pekerjaan</td>
                            <td rowspan="2">Jenis Pendidikan</td>
                            <td rowspan="2">Status Pegawai</td>
                            <td rowspan="2">Tahun Realisasi</td>
                            <td colspan="4">Jumlah Tenaga Kerja</td>   
                        </tr>
                        <tr style="text-align: center">
                            <td>Tahun Prediksi 1</td>
                            <td>Tahun Prediksi 2</td>
                            <td>Tahun Prediksi 3</td>
                            <td>Tahun Prediksi 4</td>
                        </tr>
                        <%

                        if(!mapLkpbu805.isEmpty()){
                            Map<String, Lkpbu> sorted = new TreeMap<String, Lkpbu>(mapLkpbu805);
                                for(Lkpbu temp: sorted.values()){
                                    
                                long lkpbuId = PstLkpbu805.getLkpbu805Id(temp.getCode(), year);
                                Lkpbu805 eLkpbu = new Lkpbu805();
                                try {
                                    eLkpbu = PstLkpbu805.fetchExc(lkpbuId);
                                } catch (Exception exc) {
                                    System.out.println(exc.toString());
                                }

                        %>
                        <tr>
                            <td style="text-align: center">="<%=temp.getJenisPekerjaan() %>"</td>
                            <td style="text-align: center">="<%=temp.getJenisPendidikan() %>"</td>
                            <td style="text-align: center">="<%= temp.getStatusPegawai() %>"</td>
                            <td style="text-align: center"><%=(temp.getJumlahKaryawan() != 0 ? temp.getJumlahKaryawan() : 0)%></td>
                            <td style="text-align: center"><%=(eLkpbu.getLkpbu805YearPrediksi1() != 0 ? eLkpbu.getLkpbu805YearPrediksi1() : 0)%></td>
                            <td style="text-align: center"><%=(eLkpbu.getLkpbu805YearPrediksi2() != 0 ? eLkpbu.getLkpbu805YearPrediksi2() : 0)%></td>
                            <td style="text-align: center"><%=(eLkpbu.getLkpbu805YearPrediksi3() != 0 ? eLkpbu.getLkpbu805YearPrediksi3() : 0)%></td>
                            <td style="text-align: center"><%=(eLkpbu.getLkpbu805YearPrediksi4() != 0 ? eLkpbu.getLkpbu805YearPrediksi4() : 0)%></td>
                        </tr>
                        <%} } %>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" >
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4">Denpasar, <%=str_dt_now%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4">PT. BANK PEMBANGUNAN DAERAH BALI</td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4"><%=division.getDivision()%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4"><%=level.getLevel()%></td>
                        </tr>
                        <tr>
                            <td colspan="4"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="4"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="4"></td>
                            <td colspan="4"></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4"><b><u><%=employeeKadiv.getFullName()%></u></b></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="4"></td>
                            <td colspan="4"><b>NRK. <%=employeeKadiv.getEmployeeNum()%></b></td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>

