<%-- 
    Document   : akumulasi_cuti
    Created on : 24-Apr-2017, 10:08:41
    Author     : Gunadi
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.harisma.session.leave.SessLeaveApplication"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.LLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%><!DOCTYPE html>
<%@ include file = "../../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_REKAP_CUTI); %>
<%@ include file = "../../../main/checkuser.jsp" %>
<%!
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }

    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true ;
    
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long compId = FRMQueryString.requestLong(request, "company_id");
    String[] div = FRMQueryString.requestStringValues(request, "division_id");
    String[] dept = FRMQueryString.requestStringValues(request, "department");
    String[] sec = FRMQueryString.requestStringValues(request, "section");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    
    if (dateFrom.isEmpty()) {
        dateFrom = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    if (dateTo.isEmpty()) {
        dateTo = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    SessEmpSchedule empSchedule = new SessEmpSchedule();
    String inCompany = (compId == 0) ? "" : ""+compId;
    inCompany = (inCompany.isEmpty()) ? "" : inCompany.substring(1, inCompany.length() - 1);
    empSchedule.setInCompany(inCompany);

    String inDivision = (div == null) ? "" : Arrays.toString(div);
    inDivision = (inDivision.isEmpty()) ? "" : inDivision.substring(1, inDivision.length() - 1);
    empSchedule.setInDivision(inDivision);

    String inDepartment = (dept == null) ? "" : Arrays.toString(dept);
    inDepartment = (inDepartment.isEmpty()) ? "" : inDepartment.substring(1, inDepartment.length() - 1);
    empSchedule.setInDepartment(inDepartment);

    String inSection = (sec == null) ? "" : Arrays.toString(sec);
    inSection = (inSection.isEmpty()) ? "" : inSection.substring(1, inSection.length() - 1);
    empSchedule.setInSection(inSection);
    
    empSchedule.setEmpNum(empNum);
    empSchedule.setEmpFullName(empName);

    
    if (!dateFrom.isEmpty()) {
        empSchedule.setFromDate(Formater.formatDate(dateFrom, "yyyy-MM-dd"));
    }
    if (!dateTo.isEmpty()) {
        empSchedule.setToDate(Formater.formatDate(dateTo, "yyyy-MM-dd"));
    }
    
    Vector listRekap = SessEmpSchedule.listAkumulasiCutiBySymbol(empSchedule);
    response.setHeader("Content-Disposition","attachment; filename=laporan_akumulasi_cuti.xls ");
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rekap Cuti</title>
    </head>
    <body>
        <% 
            if (listRekap.size() > 0 ){ 
                String whereSchedule = "";
                String oidSpecialLeave = "";
                String oidUnpaidLeave = "";
                try {
                    oidSpecialLeave = String.valueOf(PstSystemProperty.getValueByName("OID_SPECIAL"));
                } catch (Exception E) {
                    oidSpecialLeave = "0";
                    System.out.println("EXCEPTION SYS PROP OID_SPECIAL : " + E.toString());
                }
                try {
                    oidUnpaidLeave = String.valueOf(PstSystemProperty.getValueByName("OID_UNPAID"));
                } catch (Exception E) {
                    oidUnpaidLeave = "0";
                    System.out.println("EXCEPTION SYS PROP OID_UNPAID : " + E.toString());
                }
                whereSchedule = "("+PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidSpecialLeave
                + " OR " + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidUnpaidLeave+") AND "
                + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SHOW_ON_USER_LEAVE]+ " = 1";
                Vector listSchedule = PstScheduleSymbol.list(0, 0, whereSchedule, null);
        %>
        <table border="1">
            <tr>
                <td style="text-align:center; vertical-align:middle">No</td>
                <td style="text-align:center; vertical-align:middle">NRK</td>
                <td style="text-align:center; vertical-align:middle">Nama</td>
                <td style="text-align:center; vertical-align:middle">Satuan Kerja</td>
                <td style="text-align:center; vertical-align:middle">Jabatan</td>
                <td style="text-align:center; vertical-align:middle">Cuti Penting</td>
                <td style="text-align:center; vertical-align:middle">Cuti Tahunan</td>
                <td style="text-align:center; vertical-align:middle">Cuti Besar</td>
                <td style="text-align:center; vertical-align:middle">Cuti Hamil</td>
                <%
                for (int i=0; i < listSchedule.size(); i++){
                    ScheduleSymbol sym = (ScheduleSymbol) listSchedule.get(i);
                    %><td style="text-align:center; vertical-align:middle"><%=sym.getSchedule()%></td><%
                }

                %>
            </tr>
            <%
            if (listRekap != null && listRekap.size() > 0) {

                for (int idx = 0; idx < listRekap.size(); idx++) {
                    Vector temp = (Vector) listRekap.get(idx);
                    Employee emp = (Employee) temp.get(0);
                    Map<String, Integer> mapLv = (Map<String, Integer>) temp.get(1);

                    Position pos = new Position();
                    String position = "";
                    try{
                        pos = PstPosition.fetchExc(emp.getPositionId());
                        position = pos.getPosition();
                    } catch (Exception exc){

                    }

                    Division dv = new Division();
                    String division = "";
                    try{
                        dv = PstDivision.fetchExc(emp.getDivisionId());
                        division = dv.getDivision();
                    } catch (Exception exc){

                    }

                     String bgColor = "";
                     if((idx%2)==0){
                         bgColor = "#FFF";
                     } else {
                         bgColor = "#F9F9F9";
                     }

                    %>
                         <tr>
                            <td style="background-color: <%=bgColor%>;"><%=""+ (idx+1)%></td>
                            <td style="background-color: <%=bgColor%>;">="<%=""+ emp.getEmployeeNum()%>"</td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ emp.getFullName()%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ division%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ position%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ ((mapLv.get("CP") == null) ? 0 : mapLv.get("CP"))%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ ((mapLv.get("CT") == null) ? 0 : mapLv.get("CT"))%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ ((mapLv.get("CB") == null) ? 0 : mapLv.get("CB"))%></td>
                            <td style="background-color: <%=bgColor%>;"><%=""+ ((mapLv.get("CH") == null) ? 0 : mapLv.get("CH"))%></td>
                            <%
                            for (int i=0; i < listSchedule.size(); i++){
                                ScheduleSymbol sym = (ScheduleSymbol) listSchedule.get(i);
                                %><td style="background-color: <%=bgColor%>;"><%=""+ ((mapLv.get(sym.getSymbol()) == null) ? 0 : mapLv.get(sym.getSymbol()))%></td><%
                            }

                            %>
                         </tr>
                    <%

                 }
             }

            %>

        </table>
        <%
            } else {
        %>
            <h6><strong>Tidak ada data</strong></h6>
        <%
            }
        %>        
    </body>
</html>
