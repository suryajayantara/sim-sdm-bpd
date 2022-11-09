<%-- 
    Document   : export_excel_list_lkpbu_801
    Created on : Aug 11, 2015, 3:44:55 PM
    Author     : khirayinnura
--%>

<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.FrmLkpbu"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.CtrlLkpbu"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
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
    response.setHeader("Content-Disposition","attachment; filename=lkpbu_801.xls ");
    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    String whereclause = "" + PstPeriod.fieldNames[PstPeriod.FLD_PERIOD_ID] + "=" + oidPeriod + "";
    Vector getPeriod = PstPeriod.list(0, 1, whereclause, "");
    String periodFrom = "";
    String periodTo = "";
    for (int i = 0; i < getPeriod.size(); i++) {
        Period period = (Period) getPeriod.get(i);
        periodFrom = String.valueOf(period.getStartDate());
        periodTo = String.valueOf(period.getEndDate());
    }

    String actions[] = request.getParameterValues("result");
    ArrayList dataSplit= new ArrayList();
    if(actions != null){
        String allData = actions[0];
        String[] splits = allData.split(",");
        
        for(int j=0; j < splits.length ; j++){
            dataSplit.add(splits[j].trim());
        }
    }
    
    Vector listResult = new Vector(1, 1);
    if(session.getValue("listresult")!=null){
        listResult = (Vector)session.getValue("listresult"); 
    }
    
    Vector listLkpbu = new Vector(1, 1);
    if(session.getValue("listlkpbu")!=null){
        listLkpbu = (Vector)session.getValue("listlkpbu"); 
    }
    
    String period = "";
    if(session.getValue("period")!=null){
        period = (String)session.getValue("period"); 
    }
    period = period.replaceAll("[-]", "");
    
    String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
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
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- #BeginEditable "styles" -->
        
    </head>
    <body>
        <table>
             <tr>
                <td>
                      <p>
                            <b>PEJABAT EKSEKUTIF</b><br>
                            <b>DATA PEJABAT EKSEKUTIF Form 801</b><br><br>
                            
                        </p>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="1">
                        <tr style="text-align: center; vertical-align:middle">
                            <td colspan="6"><b>Sandi Pelapor</b></td>
                            <td colspan="3"><b>Jenis Periode Laporan</b></td>
                            <td colspan="4"><b>Priode Data Laporan</b></td>
                            <td colspan="5"><b>Jenis Laporan</b></td>
                            <td colspan="2"><b>No Form</b></td>
                            <td colspan="3"><b>Jumlah Record Isi</b></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="6">="<%=sandiPelapor%>"</td>
                            <td colspan="3">M</td>
                            <td colspan="4">="<%=period%>"</td>
                            <td colspan="5">A</td>
                            <td colspan="2">801</td>
                            <td colspan="3"><%=listResult.size()%></td>
                        </tr>
                        <tr style="text-align: center; vertical-align:middle">
                            <td><b>Status Data</b></td>
                            <td><b>NIP</b></td>
                            <td><b>Nama Pejabat Eksekutif</b></td>
                            <td><b>Status Tenaga Kerja</b></td>
                            <td><b>Nama Jabatan</b></td>
                            <td><b>Alamat Rumah (Saat Ini)</b></td>
                            <td><b>Alamat KTP atau Paspor atau KITAS (WNA)</b></td>
                            <td><b>No. Telp</b></td>
                            <td><b>No. Fax</b></td>
                            <td><b>NPWP</b></td>
                            <td><b>No. ID</b></td>
                            <td><b>Tempat Lahir</b></td>
                            <td><b>Tgl Lahir</b></td>
                            <td><b>Kewarganegaraan</b></td>
                            <td><b>Jenis kelamin</b></td>
                            <td><b>No. Surat Pelaporan</b></td>	
                            <td><b>Tanggal Surat Pelaporan</b></td>
                            <td><b>Status PE</b></td>
                            <td><b>Nomor Surat Keputusan Pengangkatan/Penggantian/Penggantian Sementara</b></td>
                            <td><b>Tanggal Efektif Pengangkatan/Penggantian/Penggantian Sementara</b></td>
                            <td><b>Nomor Surat Keputusan Pemberhentian</b></td>
                            <td><b>Tanggal Efektif Pemberhentian</b></td>
                            <td><b>Keterangan</b></td>
                        </tr>
                        <%
                        if (listResult.size() > 0 && listResult != null) {
                            for (int i = 0; i < listResult.size(); i++) {
                                CareerPath cp = (CareerPath) listResult.get(i);

                                Vector listCareerPath = new Vector();
                                listCareerPath = PstCareerPath.listKadivCareer(cp.getEmployeeId(), periodTo);
                                int statusData = 1;
                                if (listCareerPath.size() > 0) {
                                    statusData = 2;
                                }
                                
                                long lkpbuId = PstLkpbu.lkpbu801byEmployee(cp.getEmployeeId(), oidPeriod);
                                System.out.println(oidPeriod);
                                Lkpbu lkpbu = new Lkpbu();
                                if (lkpbuId != 0){
                                    try {
                                        lkpbu = PstLkpbu.fetchExc(lkpbuId);
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                }

                                Employee emp = new Employee();

                                try {
                                    emp = PstEmployee.fetchExc(cp.getEmployeeId());
                                } catch (Exception exc) {
                                }

                                //nationality
                                Nationality nat = new Nationality();
                                String code = "";
                                try {

                                    nat = PstNationality.fetchExc(emp.getNationalityId());
                                    code = PstNationality.typeCode[nat.getNationalityType()];
                                } catch (Exception ee) {
                                }

                                Position pos = new Position();
                                try {
                                    pos = PstPosition.fetchExc(cp.getPositionId());
                                } catch (Exception exc){

                                }

                                Division div = new Division();
                                try {
                                    if (pos.getJenisJabatan() != PstPosition.JENIS_PEJABAT_EKSEKUTIF){
                                        String whereClause = ""+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+cp.getEmployeeId()
                                                        +" AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" <> 1"
                                                        +" AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN (0,1)"
                                                        + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" DESC LIMIT 1";
                                        Vector listCareer = PstCareerPath.list(0,0,whereClause,"");
                                        if(listCareer.size()>0){
                                            CareerPath career = (CareerPath) listCareer.get(0);
                                            try{
                                                div = PstDivision.fetchExc(career.getDivisionId());
                                                 pos = PstPosition.fetchExc(career.getPositionId());
                                            } catch (Exception exc){}

                                        }
                                    } else {
                                        try{
                                                div = PstDivision.fetchExc(cp.getDivisionId());                                                                                                                            
                                        } catch (Exception exc){}
                                    }
                                } catch (Exception exc){

                                }
                                //sex
                                String sex = "";
                                if (emp.getSex() == 0) {
                                    sex = "2";
                                } else {
                                    sex = "1";
                                }

                                //History Type
                                String statusPE = "";
                                if (cp.getHistoryType() == PstCareerPath.CAREER_TYPE) {
                                    statusPE = "1";
                                } else {
                                    statusPE = "2";
                                }

                                String jabatan="";
                                if (cp.getHistoryType()==PstCareerPath.PEJABAT_SEMENTARA_TYPE){
                                    jabatan = "PJS ";
                                }

                                if(cp.getHistoryType()==PstCareerPath.DETASIR_TYPE){
                                    jabatan = "Pejabat Detasir PLT ";
                                }
                        %>
                        <tr>
                            <td><%=statusData%></td>
                            <td>="0000000000000000<%=emp.getEmployeeNum()%>"</td>
                            <td><%=""+emp.getNameCard().toUpperCase()%></td>
                            <td>="<%=""+code%>"</td>
                            <td><%=jabatan.toUpperCase()%><%=pos.getAlias().toUpperCase()%> <%=div.getDivision().toUpperCase()%></td>
                            <% if (!emp.getAddress().equals("null")) {%>
                            <td><%=""+emp.getAddress().toUpperCase()%></td>
                            <% } else {%>
                            <td>-</td><%}%>
                            <% if (!emp.getAddressPermanent().equals("null")) {%>
                            <td><%=""+emp.getAddressPermanent().toUpperCase()%></td>
                            <% } else {%>
                            <td>-</td><%}%>
                            <%if(!div.getTelphone().equals(null)){%><td>="<%=""+(div.getTelphone().length() > 10 ? div.getTelphone().substring(0,10) : div.getTelphone())%>"</td><%}else{%><td>-</td><%}%>
                            <%if(!div.getFaxNumber().equals(null)){%><td>="<%=""+(div.getFaxNumber().length() > 10 ? div.getFaxNumber().substring(0,10) : div.getFaxNumber())%>"</td><%}else{%><td>-</td><%}%>

                            <%
                                String npwp = emp.getNpwp();
                                npwp = npwp.replaceAll("[-,.]", "");
                            %>
                            <td>="<%=npwp%>"</td>

                            <td>="<%=""+emp.getIndentCardNr()%>"</td>
                            <td><%=""+emp.getBirthPlace().toUpperCase()%></td>
                            <td>="<%=Formater.formatDate(emp.getBirthDate(),"ddMMyyyy")%>"</td>
                            <td><%=""+nat.getNationalityCode()%></td>
                            <td><%=sex%></td>
                            <td><%=lkpbu.getNoSuratPelaporan().toUpperCase()%></td>
                            <td><%=lkpbu.getTanggalSuratPelaporan()%></td>
                            <td><%=statusPE%></td>
                            <td><%=lkpbu.getNoSK().toUpperCase()%></td>
                            <td><%=lkpbu.getTanggalSK()%></td>
                            <td><%=lkpbu.getNoSKPemberhentian().toUpperCase()%></td>
                            <td><%=lkpbu.getTanggalSuratPelaporan()%></td>
                            <td><%=lkpbu.getKeterangan().toUpperCase()%></td>
                            
                        </tr>
                        <%}
                            }%>
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
                            <td colspan="16"></td>
                            <td colspan="16">Denpasar, <%=str_dt_now%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="16"></td>
                            <td colspan="16">PT. BANK PEMBANGUNAN DAERAH BALI</td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="16"></td>
                            <td colspan="16"><%=division.getDivision()%></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="16"></td>
                            <td colspan="16"><%=level.getLevel()%></td>
                        </tr>
                        <tr>
                            <td colspan="16"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="16"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="16"></td>
                            <td colspan="16"></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="16"></td>
                            <td colspan="16"><b><u><%=employeeKadiv.getFullName()%></u></b></td>
                        </tr>
                        <tr style="text-align: center">
                            <td colspan="16"></td>
                            <td colspan="16"><b>NRK. <%=employeeKadiv.getEmployeeNum()%></b></td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
