<%-- 
    Document   : export_excel_masa_jabatan_terakhir
    Created on : Feb 4, 2020, 10:19:06 AM
    Author     : IanRizky
--%>

<%@page import="com.dimata.harisma.entity.employee.CareerPath"%>
<%@page import="com.dimata.util.DateCalc"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.employee.PstCareerPath"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@ include file = "../../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

    int iCommand = FRMQueryString.requestCommand(request);
    
    String[] arrCompany = FRMQueryString.requestStringValues(request, "companyId");
    String[] arrDivision = FRMQueryString.requestStringValues(request, "divisionId");
    String[] arrDepartment = FRMQueryString.requestStringValues(request, "departmentId");
    String[] arrSection = FRMQueryString.requestStringValues(request, "sectionId");
    String date = FRMQueryString.requestString(request, "date");
    long positionId = FRMQueryString.requestLong(request, "positionId");
    long lvlId = FRMQueryString.requestLong(request, "levelId");
	int reportType = FRMQueryString.requestInt(request, "reportType");
    
	switch(reportType){
		case 0:
			response.setHeader("Content-Disposition","attachment; filename=laporan_jabatan_terakhir.xls ");
			break;
		case 1:
			response.setHeader("Content-Disposition","attachment; filename=laporan_level_sama.xls ");
			break;
		case 2:
			response.setHeader("Content-Disposition","attachment; filename=laporan_lama_satuan_kerja_saat_ini.xls ");
			break;
	}
	
	
    Vector listEmployee = new Vector();
    if (iCommand == Command.LIST){
        Vector<String> whereCollectEmp = new Vector<String>();
        String whereEmployee = "";
        String inCompany = "";
        String inDivision = "";
        String inDepartment = "";
        String inSection = "";
        
        if (arrCompany != null){
            for (int i=0; i < arrCompany.length; i++){
                inCompany = inCompany + ","+ arrCompany[i];
            }
            inCompany = inCompany.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" IN ("+inCompany+")");
        }
        if (arrDivision != null){
            for (int i=0; i < arrDivision.length; i++){
                inDivision = inDivision + ","+ arrDivision[i];
            }
            inDivision = inDivision.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")");
        }
        if (arrDepartment != null){
            for (int i=0; i < arrDepartment.length; i++){
                inDepartment = inDepartment + ","+ arrDepartment[i];
            }
            inDepartment = inDepartment.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDepartment+")");        
        }
        if (arrSection != null){
            for (int i=0; i < arrSection.length; i++){
                inSection = inSection + ","+ arrSection[i];
            }
            inSection = inSection.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSection+")");        
        }
        
        if (positionId != 0){
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" = "+positionId);   
        }
		
		if (lvlId != 0){
			whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+" = "+lvlId);   
		}
        
        if (whereCollectEmp != null && whereCollectEmp.size()>0){
            for (int i=0; i<whereCollectEmp.size(); i++){
                String where = (String)whereCollectEmp.get(i);
                whereEmployee += where;
                if (i < (whereCollectEmp.size()-1)){
                     whereEmployee += " AND ";
                }
            }
        }
        
        listEmployee = PstEmployee.list(0, 0, whereEmployee, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
            
            body {background-color: #EEE;}
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
        <%
			if (listEmployee.size() > 0){
				switch(reportType){
					case 0:
					%>
					<table class="tblStyle" width="100%">
						<tr>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Lama Menjabat (Bulan)</td>
						</tr>
					<%
					for (int i=0; i<listEmployee.size();i++){
						Employee emp = (Employee) listEmployee.get(i);
						String bgColor = "";
						if((i%2)==0){
							bgColor = "#FFF";
						} else {
							bgColor = "#F9F9F9";
						}

						String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
						if (startMenjabat == null || startMenjabat.equals("")){
							startMenjabat = ""+emp.getCommencingDate();
						}
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Date dtStart = sdf.parse(startMenjabat);
						Date dtSearch = sdf.parse(date);

						int month = DateCalc.monthDifference(dtStart, dtSearch);

						%>
							<tr>
								<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
								<td style="background-color: <%=bgColor%>;"><%=month%></td>
							</tr>
						<%
					}
					%>
					</table>
					<%
					break;
					case 1:
					%>
					<table class="tblStyle" width="100%">
						<tr>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Lama Pada Level Sama (Bulan)</td>
						</tr>
					<%
					for (int i=0; i<listEmployee.size();i++){
						Employee emp = (Employee) listEmployee.get(i);
						String bgColor = "";
						if((i%2)==0){
							bgColor = "#FFF";
						} else {
							bgColor = "#F9F9F9";
						}

						String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
						if (startMenjabat == null || startMenjabat.equals("")){
							startMenjabat = ""+emp.getCommencingDate();
						}
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Date dtStart = sdf.parse(startMenjabat);
						Date dtSearch = sdf.parse(date);

						int month = DateCalc.monthDifference(dtStart, dtSearch);

						Vector vectLvl = new Vector();
						vectLvl = PstCareerPath.getLevelSama(emp.getOID(), emp.getLevelId());
						for (int x=0; x < vectLvl.size();x++){
							CareerPath careerPath = (CareerPath) vectLvl.get(x);
							month = month + DateCalc.monthDifference(careerPath.getWorkFrom(), careerPath.getWorkTo());
						}

						%>
							<tr>
								<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
								<td style="background-color: <%=bgColor%>;"><%=month%></td>
							</tr>
						<%
					}
					%>
					</table>
					<%
					break;
					case 2:
					%>
					<table class="tblStyle" width="100%">
						<tr>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
							<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja Saat Ini (Bulan)</td>
						</tr>
					<%
					for (int i=0; i<listEmployee.size();i++){
						Employee emp = (Employee) listEmployee.get(i);
						String bgColor = "";
						if((i%2)==0){
							bgColor = "#FFF";
						} else {
							bgColor = "#F9F9F9";
						}

						String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
						if (startMenjabat == null || startMenjabat.equals("")){
							startMenjabat = ""+emp.getCommencingDate();
						}
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Date dtStart = sdf.parse(startMenjabat);
						Date dtSearch = sdf.parse(date);

						int month = DateCalc.monthDifference(dtStart, dtSearch);

						Vector vectLvl = new Vector();
						vectLvl = PstCareerPath.getDivisiSama(emp.getOID(), emp.getDivisionId());
						for (int x=0; x < vectLvl.size();x++){
							CareerPath careerPath = (CareerPath) vectLvl.get(x);
							month = month + DateCalc.monthDifference(careerPath.getWorkFrom(), careerPath.getWorkTo());
							startMenjabat = ""+careerPath.getWorkFrom();
						}

						%>
							<tr>
								<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
								<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
								<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
								<td style="background-color: <%=bgColor%>;"><%=month%></td>
							</tr>
						<%
					}
					%>
					</table>
					<%
					break;
				}
			}
		%>
    </body>
</html>
