<%-- 
    Document   : export_excel_list_lkpbu_801
    Created on : Aug 11, 2015, 3:44:55 PM
    Author     : khirayinnura
--%>

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
    response.setHeader("Content-Disposition","attachment;filename= Laporan_LKPBU_802.xls");
    int iCommand = FRMQueryString.requestCommand(request);
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

    // period = "";

    Vector listResult = new Vector(1, 1);
    listResult = PstCareerPath.listEmployeePECareerPath(periodFrom, periodTo);
    
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
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <table>
            <tr>
                <td colspan="7" style="text-align: center;"><strong>PEJABAT EKSEKUTIF</strong></td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center;"><strong>DAFTAR RIWAYAT PEKERJAAN INDIVIDUAL PEJABAT EKSEKUTIF</strong></td>
            </tr>
            <tr>
                <td colspan="7" style="text-align: center;"><strong>Form 802</strong></td>
            </tr>
            <tr>
                <td>
                    <% 
                    if(iCommand == Command.LIST || iCommand == Command.ADD || iCommand == Command.SAVE || iCommand == Command.EDIT)
                    {
                          String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
                          String jenisPeriodPelaporan = PstSystemProperty.getValueByNameWithStringNull("LKPBU_801_PERIOD");
                          String jenisLaporan = PstSystemProperty.getValueByNameWithStringNull("JENIS_LAPORAN_801");
                          Period periode = new Period();
                          String datelap = "";
                          try {
                              periode = PstPeriod.fetchExc(oidPeriod);
                              Date periodelap = periode.getStartDate();
                              datelap = "" + periodelap;
                              datelap = datelap.replaceAll("-", "");

                          } catch (Exception exc) {
                          }
                          int jmlRecord = 0;
                          for(int i = 0; i < listResult.size(); i++) {
                              CareerPath cp = (CareerPath)listResult.get(i);
                              Vector listCareerPath = PstCareerPath.listKadivCareer(cp.getEmployeeId(), periodTo);
                              int statusData = 1;
                              if (listCareerPath.size() > 0) {
                                  statusData = 2;
                              }
                              Vector careerCount = new Vector();
                              String whereClause = "";
                                if (cp.getHistoryType() == PstCareerPath.DETASIR_TYPE){
                                    Date dt = cp.getWorkTo();
                                    Calendar c = Calendar.getInstance(); 
                                    c.setTime(dt); 
                                    c.add(Calendar.DATE, 1);
                                    dt = c.getTime();
                                    
                                    int intWorkTo = PstCareerPath.getConvertDateToInt(""+Formater.formatDate(dt, "yyyy-MM-dd"));
                                    int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
                                    int intPeriodTo = PstCareerPath.getConvertDateToInt(periodTo);
                                    if (intWorkTo>= intPeriodFrom && intWorkTo <= intPeriodTo){
                                        whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+"="+cp.getOID();
                                        careerCount = PstCareerPath.list(0, 0, whereClause, "");
                                    } else {
                                        careerCount = PstCareerPath.lastCareerPE(cp.getEmployeeId(), periodTo);
                                    }
                                } else {
                                    whereClause = " "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+cp.getEmployeeId()
                                                    + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] +"<= '" + periodTo +"'"
                                                    + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN ("+PstCareerPath.RIWAYAT_JABATAN+","+PstCareerPath.RIWAYAT_CAREER_N_GRADE+") "
                                                    + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+" IN("+PstCareerPath.CAREER_TYPE+","+PstCareerPath.PEJABAT_SEMENTARA_TYPE+")"
                                                    + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];

                                    if(statusData == 2){
                                        whereClause += " DESC LIMIT 1";
                                    }
                                     careerCount = PstCareerPath.list(0, 0, whereClause, "");
                                }
                              for(int j = 0; j < careerCount.size(); j++) {
                                  jmlRecord++;
                              }
                          }
                    %>
                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                      <tr>
                        <td><hr></td>
                      </tr>
                      <tr>
                        <td>
                            <table border="1" >
                              <tr>
                                  <td class="title_tbl" style="text-align: center;" colspan="2"><strong>Sandi Pelapor </strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Jenis Periode Pelaporan</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Periode Data Pelaporan</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Jenis Laporan</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>No Form</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Jumlah Record Isi</strong></td>
                              </tr>
                              <tr>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="2"><%= sandiPelapor%></td>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jenisPeriodPelaporan%></td>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= datelap%></td>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jenisLaporan%></td>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center">802</td>
                                  <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jmlRecord%></td>
                              </tr>
                              <tr>
                                  <td class="title_tbl" style="text-align: center;"><strong>NIP</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Nama Perusahaan</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Tanggal Mulai</strong></td>
                                  <td class="title_tbl" style="text-align: center;"><strong>Tanggal Berakhir</strong></td>
                                  <td class="title_tbl" style="text-align: center;" colspan="3"><strong>Nama Jabatan atau Posisi</strong></td>
                              </tr>
                              <%
                                  for(int i = 0; i < listResult.size(); i++) {
                                      CareerPath careerPath = (CareerPath)listResult.get(i);
                                      Vector listCareerPath = PstCareerPath.listKadivCareer(careerPath.getEmployeeId(), periodTo);
                                      int statusData = 1;
                                      if (listCareerPath.size() > 0) {
                                          statusData = 2;
                                      }
                                      String whereClause = " ";
                                        Vector career = new Vector();
                                        if (careerPath.getHistoryType() == PstCareerPath.DETASIR_TYPE){
                                            Date dt = careerPath.getWorkTo();
                                            Calendar c = Calendar.getInstance(); 
                                            c.setTime(dt); 
                                            c.add(Calendar.DATE, 1);
                                            dt = c.getTime();

                                            int intWorkTo = PstCareerPath.getConvertDateToInt(""+Formater.formatDate(dt, "yyyy-MM-dd"));
                                            int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
                                            int intPeriodTo = PstCareerPath.getConvertDateToInt(periodTo);
                                            if (intWorkTo>= intPeriodFrom && intWorkTo <= intPeriodTo){
                                                whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+"="+careerPath.getOID();
                                                career = PstCareerPath.list(0, 0, whereClause, "");
                                            } else {
                                                career = PstCareerPath.lastCareerPE(careerPath.getEmployeeId(), periodTo);
                                            }
                                        } else {
                                            whereClause = " "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+careerPath.getEmployeeId()
                                                            + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] +"<= '" + periodTo +"'"
                                                            + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN ("+PstCareerPath.RIWAYAT_JABATAN+","+PstCareerPath.RIWAYAT_CAREER_N_GRADE+") "
                                                            + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+" IN("+PstCareerPath.CAREER_TYPE+","+PstCareerPath.PEJABAT_SEMENTARA_TYPE+")"
                                                            + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];

                                            if(statusData == 2){
                                                whereClause += " DESC LIMIT 1";
                                            }
                                             career = PstCareerPath.list(0, 0, whereClause, "");
                                        }

                                      for(int j = 0; j < career.size(); j++) {
                                          CareerPath careerAll = (CareerPath)career.get(j);

                                          Employee empFetch = new Employee();
                                          try{
                                              empFetch = PstEmployee.fetchExc(careerAll.getEmployeeId());
                                          }catch(Exception ee){

                                          }

                                          Company comp = new Company();
                                          try{
                                              comp = PstCompany.fetchExc(empFetch.getCompanyId());
                                          }catch(Exception ee){

                                          }

                                          Division div = new Division();
                                          try{
                                              div = PstDivision.fetchExc(careerAll.getDivisionId());
                                          }catch(Exception ee){

                                          }

                                          Position pos = new Position();
                                          try{
                                              pos = PstPosition.fetchExc(careerAll.getPositionId());
                                          }catch(Exception ee){

                                          }

                                          /*if(j == 0){*/
                                          int jmlhNum = 20 - empFetch.getEmployeeNum().length();
                                          String empNum = "";
                                          for(int h = 0; h < jmlhNum; h++){
                                              empNum = empNum + "0";
                                          }

                                          Date dt = careerAll.getWorkTo();
                                          Calendar c = Calendar.getInstance(); 
                                          c.setTime(dt); 
                                          c.add(Calendar.DATE, 1);
                                          dt = c.getTime();
                              %>
                              <tr>
                                  <td nowrap="" style="background-color: #FFF; text-align: center">="<%=empNum+empFetch.getEmployeeNum()%>"</td>
                                  <td nowrap="" style="background-color: #FFF; text-align: center"><%=comp.getCompany()%></td>
                                  <td nowrap="" style="background-color: #FFF; text-align: center">="<%=Formater.formatDate(careerAll.getWorkFrom(), "ddMMyyyy")%>"</td>
                                  <td nowrap="" style="background-color: #FFF; text-align: center">="<%=Formater.formatDate(dt, "ddMMyyyy")%>"</td>
                                  <td nowrap="" style="background-color: #FFF;" colspan="3"><%=pos.getAlias()+" "+div.getDivision()%></td>
                              </tr>
                              <%
                                      }
                                  }
                              %>
                            </table>
                            <%
                              }
                            %>
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
                </td>
            </tr>
</table>
    </body>
</html>
