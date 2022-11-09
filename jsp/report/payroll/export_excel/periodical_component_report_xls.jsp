<%-- 
    Document   : periodical_component_report_xls
    Created on : 06-Oct-2017, 09:27:27
    Author     : Gunadi
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.session.payroll.TaxCalculator"%>
<%@page import="com.dimata.harisma.session.payroll.SessPeriodicalComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcPeriodicalComp"%>
<%@page import="com.dimata.harisma.entity.search.SrcPeriodicalComp"%>
<%@ include file = "../../../main/javainit.jsp" %>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<%

   response.setHeader("Content-Disposition","attachment; filename=periodical_report.xls ");

    int iCommand = FRMQueryString.requestCommand(request);
    Vector listEmployee= new Vector();
    int vectSize = 0;
    SrcPeriodicalComp objSrcPeriodicalComp = new SrcPeriodicalComp();
    FrmSrcPeriodicalComp objFrmSrcPeriodicalComp = new FrmSrcPeriodicalComp();
    SessPeriodicalComp sessPeriodicalComp = new SessPeriodicalComp();
    int a1 = FRMQueryString.requestInt(request, "a1");
    
    if (iCommand == Command.LIST){
        objFrmSrcPeriodicalComp = new FrmSrcPeriodicalComp(request, objSrcPeriodicalComp);
        objFrmSrcPeriodicalComp.requestEntityObject(objSrcPeriodicalComp);
        listEmployee = sessPeriodicalComp.listEmployee(objSrcPeriodicalComp, 0, 0);
        //vectSize = sessLeaveApplication.searchCountLeaveApplication(objSrcLeaveApp, 0, 0);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Periodical Component Report</title>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

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
            .breadcrumb {
                background-color: #EEE;
                color:#0099FF;
                padding: 7px 9px;
            }
            .navbar {
                font-family: sans-serif;
                font-size: 12px;
                background-color: #0084ff;
                padding: 7px 9px;
                color : #FFF;
                border-top:1px solid #0084ff;
                border-bottom: 1px solid #0084ff;
            }
            .navbar ul {
                list-style-type: none;
                margin: 0;
                padding: 0;
            }

            .navbar li {
                padding: 7px 9px;
                display: inline;
                cursor: pointer;
            }
            
            .navbar li a {
                color : #F5F5F5;
                text-decoration: none;
            }
            
            .navbar li a:hover {
                color:#FFF;
            }
            
            .navbar li a:active {
                color:#FFF;
            }

            .navbar li:hover {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }

            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #FFF;}
            .header {
                
            }
            .content-main {
                padding: 21px 32px;
                margin: 0px 23px 59px 23px;
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
                margin: 17px 7px;
                background-color: #FFF;
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
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
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
            
            #photo {
                padding: 7px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
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
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
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
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            .formstyle {
                background-color: #FFF;
                padding: 21px;
                border-radius: 3px;
                margin: 3px 0px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
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
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-e:hover { background-color: #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-x:hover { background-color: #D14D4D; color: #FFF;}
            
        </style>
    </head>
    <body>
        <div class="content-main">
                <% 
                    if (listEmployee.size() > 0 && listEmployee != null){
                        Vector listPeriod = PstPayPeriod.getPayPeriodBySelectedPeriodV(objSrcPeriodicalComp.getPeriodFrom(), objSrcPeriodicalComp.getPeriodTo());
                        String compCode = "";
                        String compName = "";
                        
                        if (objSrcPeriodicalComp.getArrComponent(0)!=null){
                            String[] componentId = objSrcPeriodicalComp.getArrComponent(0);
                            if (! (componentId!=null && (componentId[0].equals("0")))) {
                                for (int i=0; i < componentId.length; i++){
                                    PayComponent payComp = new PayComponent();
                                    try {
                                        payComp = PstPayComponent.fetchExc(Long.valueOf(componentId[i]));
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    compCode = compCode + "," + payComp.getCompCode();
                                    compName = compName + "," + payComp.getCompName();
                                }
                                compCode = compCode.substring(1);
                                compName = compName.substring(1);
                            }
                        }
                        
                        
                        double[] totalValue = new double[listPeriod.size()];
                        double totalJumlah = 0;
                        double totalCompare = 0;
                        double totalSelish = 0;
                %>
                <table border="0">
                    <tr>
                        <td colspan="2" style="background-color: #FFF;"><strong style="font-size: 18px;">REKAP PENGHASILAN</strong></td>
                    </tr>
                    <tr>
                        <td colspan="12" style="background-color: #FFF;"><strong style="font-size: 18px;">KOMPONEN "<%=compCode%>" <%=compName%></strong></td>                        
                    </tr>  
                </table>
                <table class="tblStyle">
                    
                    <tr>
                        <td rowspan="2" class="title_tbl">NRK</td>
                        <td rowspan="2" class="title_tbl">Nama</td>
                        <td colspan="<%=listPeriod.size()%>" class="title_tbl" style="text-align: center">PERIODE</td>
                        <td rowspan="2" class="title_tbl">JUMLAH</td>
                        <%
                            if (a1==1){
                        %>
                            <td rowspan="2" class="title_tbl">KOMPARASI</td>
                            <td rowspan="2" class="title_tbl">SELISIH</td>
                        <%
                            }
                        %>
                    </tr>
                    <tr>
                        <%
                            for (int p=0;p<listPeriod.size();p++){
                                Long periodId = (Long) listPeriod.get(p);
                                PayPeriod payPeriod = new PayPeriod();
                                try {
                                    payPeriod = PstPayPeriod.fetchExc(periodId);
                                } catch (Exception exc){
                                    exc.printStackTrace();
                                }
                        %>
                            <td class="title_tbl"><%=payPeriod.getPeriod()%></td>
                        <%
                            }
                        %>
                    </tr>
                    <%
                        for (int i=0; i<listEmployee.size();i++){
                            Employee emp = (Employee) listEmployee.get(i);
                    %>
                    <tr>
                        <td style="background-color: #FFF;"><%=emp.getEmployeeNum()%></td>
                        <td style="background-color: #FFF;"><%=emp.getFullName()%></td>
                        <%
                            double total =0;
                            for (int p=0;p<listPeriod.size();p++){
                                Long periodId = (Long) listPeriod.get(p);
                                PayPeriod payPeriod = new PayPeriod();
                                try {
                                    payPeriod = PstPayPeriod.fetchExc(periodId);
                                } catch (Exception exc){
                                    exc.printStackTrace();
                                }
                                
                                double value= sessPeriodicalComp.getValue(objSrcPeriodicalComp,periodId,emp.getOID() );
                                total = total+value;
                                totalValue[p]=totalValue[p]+value;
                                
                        %>
                            <td style="background-color: #FFF;"><%=Formater.formatNumber(value, "")%></td>
                        <%
                            } totalJumlah = totalJumlah + total;
                        %>
                            <td style="background-color: #FFF;"><%=Formater.formatNumber(total, "")%></td>
                        <%
                            if (a1==1){
                                double lastValue = 0;
                                for (int p=0;p<listPeriod.size();p++){
                                    Long periodId = (Long) listPeriod.get(p);
                                    double value = sessPeriodicalComp.getValueCompare(objSrcPeriodicalComp,periodId,emp.getOID());
                                    if (value != 0){
                                        lastValue = value;
                                    }
                                }
                                totalCompare=totalCompare+lastValue;
                                totalSelish=totalSelish+(total-lastValue);
                                    %>
                                        <td style="background-color: #FFF;"><%=Formater.formatNumber(lastValue, "")%></td>
                                        <td style="background-color: #FFF;"><%=Formater.formatNumber((total-lastValue), "")%></td>
                                    <%
                            }
                        %>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2" style="background-color: #FFF; text-align: center;" >Jumlah</td>
                        <%
                            for (int p=0;p<listPeriod.size();p++){
                        %>
                            <td style="background-color: #FFF;" ><%=Formater.formatNumber(totalValue[p], "")%></td>
                        <%
                            } 
                        %>
                            <td style="background-color: #FFF;" ><%=Formater.formatNumber(totalJumlah, "")%></td>
                        <%
                        if (a1==1){
                               %>
                                    <td style="background-color: #FFF;"><%=Formater.formatNumber(totalCompare, "")%></td>
                                    <td style="background-color: #FFF;"><%=Formater.formatNumber(totalSelish, "")%></td>
                                <% 
                            }
                        %>
                    </tr>
                </table>
                <%
                    }
                %>
        </div>
    </body>
</html>
