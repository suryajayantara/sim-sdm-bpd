<%-- 
    Document   : jurnal_report
    Created on : Aug 22, 2016, 3:40:39 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.payroll.PaySlipComp"%>
<%@page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% 
int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_JURNAL_REPORT);
%>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%!
    public String getPeriodName(long oid){
        String str = "-";
        try {
            PayPeriod payPeriod = PstPayPeriod.fetchExc(oid);
            str = payPeriod.getPeriod();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return str;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    String[] divisionSelect = FRMQueryString.requestStringValues(request, "division_select");
    ChangeValue changeValue = new ChangeValue();
    String where = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID]+"!=0";
    Vector listCompany = PstCompany.list(0, 0, where, "");
    if (listCompany != null && listCompany.size()>0){
        Company comp = (Company)listCompany.get(0);
        companyId = comp.getOID();
    }
    
    Vector listPerkiraan = new Vector(1,1);
    if (iCommand == Command.VIEW){
        listPerkiraan = PstPerkiraan.list(0, 0, "", "");
    }
    /* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    if (appUserSess.getAdminStatus()==0){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Jurnal Report</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            .td_title {
                font-weight: bold; 
                color: #373737;
                padding-right: 12px;
            }
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            #btn {
              background: #3498db;
              border: 1px solid #0066CC;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn:hover {
              background: #3cb0fd;
              border: 1px solid #3498db;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #FFF;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 21px 23px;
            }
            .content-list {
                padding: 21px;
                margin: 5px 0px;
                border: 1px solid #DDD;
                border-radius: 3px;
                background-color: #EEE;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
            #title-small {
                color:#797979;
                font-size: 11px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 9px 11px;
                margin: 5px 11px 5px 0px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info-debit {
                padding:12px;
                background-color: #C0ECFA; 
                color: #38839C;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-debit:hover {
                color:#FFF;
                background-color: #85C3D6;
            }
            .box-info-credit {
                padding:12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-credit:hover {
                color:#FFF;
                background-color: #9EC272;
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            #debit_value {
                font-size: 12px;
                color: #38839C;
                background-color: #C0ECFA;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            #credit_value {
                font-size: 12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                color:#474747;
                padding: 11px 21px;
                text-align: left;
                background-color: #CCC;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #EEE;
            }
            .form-footer {
                padding: 21px;
                background-color: #CCC;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 5px 7px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            #btn-confirm {
                padding: 3px 5px; border-radius: 2px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px; 
            }
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .item {
                background-color: #DDD;
                color:#575757;
                padding: 5px;
                border-radius: 3px;
            }
            .title-list {
                border-left: 1px solid #007fba;
                color:#575757;
                background-color: #EEE;
                padding: 5px 7px;
                font-size: 12px;
                margin: 3px 0px;
            }
        </style>
        <script type="text/javascript">
            function cmdView() {
                document.frm.command.value="<%=Command.VIEW%>";               
                document.frm.action = "jurnal_report.jsp";
                document.frm.submit();
            }
            function cmdExportToExcel(){
                document.frm.action="<%=printroot%>.report.payroll.JurnalReportXLS"; 
                document.frm.target = "ReportExcel";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title">Jurnal Report</span>
        </div>
        
        <form name="frm" method="post" action="">
            <input type="hidden" name="command" value="<%= iCommand %>" /> 
            <input type="hidden" name="company_id" value="<%= companyId %>" /> 
            <div class="content-main">
                <table>
                    <tr>
                        <td valign="top">
                            <div class="caption">Period</div>
                            <div class="divinput">
                                <select name="period_id">
                                    <option value="0">-select-</option>
                                    <%
                                    Vector listPayPeriod = PstPayPeriod.list(0, 0, "", "");
                                    if (listPayPeriod != null && listPayPeriod.size()>0){
                                        for(int i=0; i<listPayPeriod.size(); i++){
                                            PayPeriod payPeriod = (PayPeriod)listPayPeriod.get(i);
                                            %>
                                            <option value="<%=payPeriod.getOID()%>"><%=payPeriod.getPeriod()%></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <div class="caption">Perusahaan</div>
                            <div class="divinput">
                                <div class="item">PT. Bank Pembangunan Daerah Bali</div>
                            </div>
                            <div class="caption">Satuan Kerja</div>
                            <div class="divinput">
                                <select name="division_select" multiple="multiple" size="25">
                                    <option value="0">-Select-</option>
                                    <%
                                    if (empDivisionId == 0){
                                        String whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"=1";
                                        Vector listDivision = PstDivision.list(0, 0, whereClause, "");
                                        if (listDivision != null && listDivision.size()>0){
                                            for (int i=0; i<listDivision.size(); i++){
                                                Division divisi = (Division)listDivision.get(i);
                                                %>
                                                <option value="<%= divisi.getOID() %>"><%= divisi.getDivision() %></option>
                                                <%
                                            }
                                        }
                                    } else {
                                        %>
                                        <option value="<%= empDivisionId %>"><%= changeValue.getDivisionName(empDivisionId) %></option>
                                        <%
                                    }
                                    %>
                                </select>
                            </div>
                            
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF;" href="javascript:cmdView()">View</a>
                            <a class="btn" style="color:#FFF;" href="javascript:cmdExportToExcel()">Export to Excel</a>
                        </td>
                        <td valign="top" style="padding-left: 32px">
                            <%
                            double[][] dataCoa = null;
                            String [][] dataAccount = null;
                            int n = 0;
                            if (divisionSelect != null && divisionSelect.length > 0){
                                if (listPerkiraan != null && listPerkiraan.size()>0){
                                %>
                                <div class="title-list">Hasil Laporan Jurnal Period : <strong><%= getPeriodName(oidPeriod) %></strong></div>
                                <div>&nbsp;</div>
                                    <%
                                    for (int i=0; i<divisionSelect.length; i++){
                                        String divisionName = changeValue.getDivisionName(Long.valueOf(divisionSelect[i]));
                                        %>
                                        <div class="content-list">
                                            <table>
                                                <tr>
                                                    <td class="td_title" valign="top">Satuan Kerja</td>
                                                    <td>
                                                        <%= changeValue.getDivisionName(Long.valueOf(divisionSelect[i])) %>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div>&nbsp;</div>
                                            <table class="tblStyle">
                                                <tr>
                                                    <td class="title_tbl">No</td>
                                                    <td class="title_tbl">Account</td>
                                                    <td class="title_tbl">Description</td>
                                                    <td class="title_tbl">Debit</td>
                                                    <td class="title_tbl">Credit</td>
                                                </tr>
                                                <%
                                                double total = 0;
                                                double debitTotal = 0;
                                                double creditTotal = 0;
                                                double debitSum = 0;
                                                double creditSum = 0;
                                                int no = 0;
                                                /* inisialisasi arr 2 dimenesi */
                                                if (dataCoa == null){
                                                    for(int p=0; p < listPerkiraan.size(); p++){
                                                        Perkiraan perkiraan = (Perkiraan)listPerkiraan.get(p); 
                                                        divisionId = Long.valueOf(divisionSelect[i]);
                                                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                        if (check){
                                                            n++;
                                                        }
                                                    }
                                                    dataCoa = new double[n][2];
                                                    dataAccount = new String[n][2];
                                                }
                                                
                                                
                                                for(int p=0; p < listPerkiraan.size(); p++){
                                                    Perkiraan perkiraan = (Perkiraan)listPerkiraan.get(p); 
                                                    divisionId = Long.valueOf(divisionSelect[i]);
                                                    boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                    if (check){
                                                        total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId);
                                                        dataAccount[no][0] = perkiraan.getNoPerkiraan();
                                                        dataAccount[no][1] = perkiraan.getNama();
                                                        if (perkiraan.getTandaDebetKredit()==0){
                                                            debitTotal = total;
                                                            creditTotal = 0;
                                                            dataCoa[no][0] = dataCoa[no][0] + total;
                                                            debitSum = debitSum + debitTotal;
                                                        } else {
                                                            debitTotal = 0;
                                                            creditTotal = total;
                                                            dataCoa[no][1] = dataCoa[no][1] + total;
                                                            creditSum = creditSum + creditTotal;
                                                        }
                                                        
                                                        no++;
                                                    %>
                                                    <tr>
                                                        <td style="background-color: #FFF"><%= no %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNoPerkiraan() %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNama() %></td>
                                                        <td style="background-color: #FFF"><%= Formater.formatNumberMataUang(debitTotal, "Rp") %></td>
                                                        <td style="background-color: #FFF"><%= Formater.formatNumberMataUang(creditTotal, "Rp") %></td>
                                                    </tr>
                                                <% 
                                                    }
                                                }
                                                %>
                                                <tr>
                                                    <td style="background-color: #EEE;" colspan="3"><strong>Total</strong></td>
                                                    <td style="background-color: #EEE;">
                                                        <strong><%= Formater.formatNumberMataUang(debitSum, "Rp")  %></strong>
                                                    </td>
                                                    <td style="background-color: #EEE;">
                                                        <strong><%= Formater.formatNumberMataUang(creditSum, "Rp") %></strong>
                                                    </td>
                                                </tr>
                                            </table>
                                            
                                        </div>
                                        <%
                                    }
                                }
                            }
                            %>
                            
                            <%
                            if (divisionSelect != null && divisionSelect.length > 1){
                                double dataDebitSum = 0;
                                double dataCreditSum = 0;
                                if (dataCoa != null){
                                    %>
                                    <div>&nbsp;</div>
                                    <div class="content-list">
                                        <strong style="color:#575757">Gabungan dari Satuan Kerja</strong>
                                        <div>&nbsp;</div>
                                        <table class="tblStyle">
                                            <tr>
                                                <td class="title_tbl">No</td>
                                                <td class="title_tbl">Account</td>
                                                <td class="title_tbl">Description</td>
                                                <td class="title_tbl">Debit</td>
                                                <td class="title_tbl">Credit</td>
                                            </tr>
                                            <%
                                            for (int i=0; i<n; i++){
                                                dataDebitSum = dataDebitSum + dataCoa[i][0];
                                                dataCreditSum = dataCreditSum + dataCoa[i][1];
                                            %>
                                            <tr>
                                                <td><%= (i+1) %></td>
                                                <td><%= dataAccount[i][0] %></td>
                                                <td><%= dataAccount[i][1] %></td>
                                                <td><%= Formater.formatNumberMataUang(dataCoa[i][0], "Rp")  %>
                                                <td><%= Formater.formatNumberMataUang(dataCoa[i][1], "Rp")  %>
                                            </tr>
                                            <% } %>
                                            <tr>
                                                <td colspan="3"><strong>Total</strong></td>
                                                <td><strong><%= Formater.formatNumberMataUang(dataDebitSum, "Rp")  %></strong></td>
                                                <td><strong><%= Formater.formatNumberMataUang(dataCreditSum, "Rp")  %></strong></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <%
                                }
                            }
                            %>
                            
                        </td>
                    </tr>
                </table>
            </div>
            
        </form>

        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>