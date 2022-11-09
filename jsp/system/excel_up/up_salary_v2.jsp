<%-- 
    Document   : up_salary_v2
    Created on : Jun 28, 2016, 10:15:32 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
long periodId=  FRMQueryString.requestLong(request,"periodId");
PayPeriod payPeriod = new PayPeriod();
//Period period = new Period();
try{
payPeriod = PstPayPeriod.fetchExc(periodId);
//period = PstPeriod.fetchExc(periodId);
} catch(Exception exc){
    
}
session.putValue("PERIOD_UPLOAD_EXCEL", payPeriod); 

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Import Data Penggajian</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse;}
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; font-weight: bold; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
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
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 5px 25px 25px 25px;
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
                padding: 7px 15px 7px 15px;
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
            
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                margin-bottom: 2px;
                border-bottom: 1px solid #DDD;
                background-color: #EEE;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                padding: 21px;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                margin-top: 2px;
                background-color: #EEE;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                font-size: 12px;
                padding: 7px 0px 8px 15px;
                background-color: #FF6666;
                color: #FFF;
                visibility: hidden;
            }
            #btn-confirm-y {
                padding: 7px 15px 8px 15px;
                background-color: #F25757; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
            #btn-confirm-n {
                padding: 7px 15px 8px 15px;
                background-color: #E34949; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px;
            }
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            .caption {font-weight: bold; padding-bottom: 3px;}
            .divinput {margin-bottom: 7px;}
            #payroll_num {
                background-color: #DEDEDE;
                border-radius: 3px;
                font-family: Arial;
                font-weight: bold;
                color: #474747;
                font-size: 12px;
                padding: 5px 11px 5px 11px;
                cursor: pointer;
            }
        </style>
        <script type="text/javascript">
            function cmdGenerateForm(){
                document.form1.action="generate_form_xls.jsp";
                document.form1.submit();
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
            <span id="menu_title">Payroll <strong style="color:#333;"> / </strong>Import Data Penggajian</span>
        </div>
        <div class="content-main">
            <form name="form1" method="post" action="up_salary_process_v3.jsp" enctype="multipart/form-data">
            <input type="hidden" name="periodId" value="<%=periodId%>">
            <table border="0" cellspacing="2" cellpadding="2">
              <tr> 
                <td>&nbsp;Period : <%=payPeriod.getPeriod()%> : <%=payPeriod.getStartDate() %> ~  <%=payPeriod.getEndDate() %> 
                    Pay Slip Date : <% if(payPeriod.getPaySlipDate()==null ){ out.println("PLEASE specify payroll date");} else{ out.println(payPeriod.getPaySlipDate());} %>
                </td>
              </tr>
              <% if(payPeriod.getPaySlipDate()!=null ) {%>
              <tr> 
                <td> 
                  <input type="file" name="file" size="40">
                  <input type="submit" name="Submit" value="Submit">
                </td>
              </tr>
               <!-- update by devin 2014-02-14 
              <tr> 
                <td>&nbsp;<a href="Sample Data Gaji.xls">You may downloaded format example here, please RIGHT CLICK AND SAVE TARGET AS : Employee Salary Data.xls</a></td>
              </tr>-->
              <% } %>
            </table>
            <div>&nbsp;</div>
            <a href="javascript:cmdGenerateForm()" class="btn" style="color:#FFF;">Generate Form XLS</a>
            </form>
        </div>
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
