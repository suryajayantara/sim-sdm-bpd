<%-- 
    Document   : ll_owning_report
    Created on : Mar 2, 2020, 10:13:34 AM
    Author     : gndiw
--%>

<%@page import="com.dimata.util.Command"%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>
<%@ include file = "../../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_LEAVE_REPORT); %>
<%@ include file = "../../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long companyId = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department_id");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section_id");

    String[] positionId = FRMQueryString.requestStringValues(request, "position_id");
    int year = FRMQueryString.requestInt(request, "year");
    
    response.setHeader("Content-Disposition","attachment; filename=Daftar_Penerima_Cuti_Besar_"+year+".xls ");
	
	String whereClauseEmp = "";
    Vector<String> whereCollect = new Vector<String>();
    
	if (companyId != 0){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
        whereCollect.add(whereClauseEmp);
    }

    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
            inDiv = inDiv + ","+ oidDiv[i];
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
            inDept = inDept + ","+ oidDept[i];
        }
        inDept = inDept.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
            inSec = inSec + ","+ oidSec[i];
        }
        inSec = inSec.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
    }
    
    if (positionId != null){
        String inPos = "";
        for (int i=0; i < positionId.length; i++){
            inPos = inPos + ","+ positionId[i];
        }
        inPos = inPos.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN ("+inPos+")";
        whereCollect.add(whereClauseEmp);
    }
	if (whereCollect != null && whereCollect.size()>0){
        whereClauseEmp = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClauseEmp += where;
            if (i < (whereCollect.size()-1)){
                 whereClauseEmp += " AND ";
            }
        }
    }
	
	Vector vList = new Vector();
	if (iCommand == Command.LIST){
			vList = PstEmployee.getEmployeeLLEligibleByYear(year, whereClauseEmp+" AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+"= 0");
	}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold; background-color: #DDD; color: #575757; text-align: center;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            
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
            #title-box {
                color: #007fba;
                border-bottom: 1px solid #DDD; 
                font-weight: bold; 
                font-size: 14px;
                padding-bottom: 9px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 15px 17px;
                margin: 5px;
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
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
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
                padding: 13px 17px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                visibility: hidden;
            }
            #btn-confirm {
                padding: 4px 9px; border-radius: 3px;
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
        </style>
    </head>
    <body>
        <%
            if (vList != null && vList.size()>0){

                    %>
                    <table class="tblStyle">
                            <tr>
                                    <td class="title_tbl">No</td>
                                    <td class="title_tbl">NRK</td>
                                    <td class="title_tbl">Nama Karyawan</td>
                                    <td class="title_tbl">Satua Kerja</td>
                                    <td class="title_tbl">Unit</td>
                                    <td class="title_tbl">Jabatan</td>
                                    <td class="title_tbl">Mulai Bekerja</td>
                                    <td class="title_tbl">Periode Sebelumnya</td>
                                    <td class="title_tbl">Masa Kerja</td>
                            </tr>
                    <%
                    int jum = 0;
                    for(int i=0; i<vList.size(); i++){
                            Vector temp = (Vector) vList.get(i);
                            jum++;
                            %>
                                    <tr>
                                            <td><%= jum%></td>
                                            <td><%= String.valueOf(temp.get(0)) %></td>
                                            <td><%= String.valueOf(temp.get(1)) %></td>
                                            <td><%= String.valueOf(temp.get(2)) %></td>
                                            <td><%= String.valueOf(temp.get(3)) %></td>
                                            <td><%= String.valueOf(temp.get(4)) %></td>
                                            <td><%= String.valueOf(temp.get(5)) %></td>
                                            <td><%= String.valueOf(temp.get(6)) %></td>
                                            <td><%= String.valueOf(temp.get(7)) %></td>
                                    </tr>
                                    <%
                    }
                    %> </table> <%
            }
            %>
    </body>
</html>
