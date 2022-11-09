<%-- 
    Document   : organization_view
    Created on : Jan 25, 2016, 9:58:30 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.report.EmployeeAmountXLS"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_ORGANISASI, AppObjInfo.G2_MENU_STRUKTUR_ORGANISASI, AppObjInfo.OBJ_MENU_STRUKTUR_ORGANISASI); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!   
    public Employee getEmployeeData(long positionId, Vector empPosition){
        Employee emp = new Employee();
        long empId = 0;
        if (empPosition != null && empPosition.size()>0){
            for (int i=0; i<empPosition.size(); i++){
                EmployeeAndPosition empPos = (EmployeeAndPosition)empPosition.get(i);
                if (positionId == empPos.getPositionId()){
                    empId = empPos.getEmployeeId();
                    break;
                }
            }
        }
        try {
            emp = PstEmployee.fetchExc(empId);
        } catch (Exception e){
            System.out.println(""+e.toString());
        }
        return emp;
    }
    
    public long getEmployeeDivision(long employeeId){
        Employee emp = new Employee();
        try {
            emp = PstEmployee.fetchExc(employeeId);
        } catch (Exception e){
            System.out.println(""+e.toString());
        }
        return emp.getDivisionId();
    }
    
    public long getLevelPosition(long oidPosition){
        long levelId = 0;
        try {
            Position pos = PstPosition.fetchExc(oidPosition);
            levelId = pos.getLevelId();
        } catch(Exception e){
            System.out.println("organizatio_view.jsp/getLevelPosition =>"+e.toString());
        }
        return levelId;
    }
    public String getDrawDownPosition(long oidPosition, long oidTemplate, String approot, Vector employeeList, int divType, String periodFrom, String periodTo){
        String str = "";
        int umurPensiun = 0;
        int umurMbt = 0;
        try {
            umurPensiun = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
            umurMbt = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
        } catch (Exception exc){}
        EmployeeAmountXLS empAmount = new EmployeeAmountXLS();
        String whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+"="+oidPosition;
        whereClause += " AND "+PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+oidTemplate;
        Vector listDown = PstMappingPosition.list(0, 0, whereClause, "");
        String topkiri = "border-top:1px solid #999;";
        String topkanan = "border-top:1px solid #999;";
        long divisionId = 0;
        if (listDown != null && listDown.size()>0){
            str = "<table class=\"tblStyle1\"><tr>";
            for(int i=0; i<listDown.size(); i++){
                MappingPosition pos = (MappingPosition)listDown.get(i);
                //
                String tes = "";
                long employeeOid = 0;
				ArrayList<Long> arrEmployeeId = new ArrayList<Long>();
                if (divType == PstDivisionType.TYPE_BOD){
                    employeeOid = PstCareerPath.getEmployeeIdCaseBOD(periodFrom, periodTo, pos.getDownPositionId());
                } else {
                    if (employeeList != null && employeeList.size()>0){
                        for(int e=0; e < employeeList.size(); e++){
                            EmployeeAndPosition emp = (EmployeeAndPosition)employeeList.get(e);
                            if (emp.getPositionId() == pos.getDownPositionId()){
                                employeeOid = emp.getEmployeeId();
								arrEmployeeId.add(emp.getEmployeeId());
                                divisionId = emp.getDivisionId();
                            }
                        }
                    }
                }
                
                if (listDown.size() == 1){
                    topkiri = "";
                    topkanan = "";
                } else {
                    if (i == 0 || i == (listDown.size()-1)){
                        if (i == 0){
                            topkiri = "";
                            topkanan = "border-top:1px solid #999;";
                        } else {
                            topkiri = "border-top:1px solid #999;";
                            topkanan = "";
                        }
                    } else {
                        topkiri = "border-top:1px solid #999;";
                        topkanan = "border-top:1px solid #999;";
                    }
                }

				if (arrEmployeeId.size()>1){
					str += "<td valign=\"top\">";
					str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
					str += "<tr>";
					str += "<td width=\"50%\" style=\"border-right:1px solid #999; "+topkiri+"\">&nbsp;</td><td width=\"50%\" style=\""+topkanan+"\">&nbsp;</td>";
					str += "</tr>";
					str += "</table>";
					str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
					str += "<tr>";
					int loop = 0;
					for (long empId : arrEmployeeId){
						if (loop == 0){
							topkiri = "";
                            topkanan = "border-top:1px solid #999;";
						} else if ((loop+1) == arrEmployeeId.size()){
							topkiri = "border-top:1px solid #999;";
                            topkanan = "";
						} else {
							topkiri = "border-top:1px solid #999;";
                            topkanan = "border-top:1px solid #999;";
						}
						str += "<td valign=\"top\">";
						str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
						str += "<tr>";
						str += "<td width=\"50%\" style=\"border-right:1px solid #999; "+topkiri+"\">&nbsp;</td><td width=\"50%\" style=\""+topkanan+"\">&nbsp;</td>";
						str += "</tr></table>";
						String pictPath = "";
						try {
							SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
							pictPath = sessEmployeePicture.fetchImageEmployee(empId);

						} catch (Exception e) {
							System.out.println("err." + e.toString());
						} 

						if (pictPath != null && pictPath.length() > 0) {
						   str += "<img  height=\"64\" id=\"photo\" src=\"" + approot + "/" + pictPath + "\">";
						} else {
						   str += "<img height=\"64\" id=\"photo\" src=\""+approot+"/imgcache/no-img.jpg\" />";   
						}

						String empNama = empAmount.infoEmp(empId);
						if (empNama.equals("")){
							empNama = "Empty";
						}

						String clss = "";
						int empAge = PstEmployee.getEmployeeAge(empId);
						if (empAge == umurMbt){
							clss = "class='mbt'";
						} else if (empAge >= umurPensiun){
							clss = "class='pensiun'";
						}

						str += "<div style=\"color: #373737\"><a id=\"linkStyle\" "+clss+" href=\"javascript:cmdViewEmployee('" + empId + "','"+ divisionId +"')\">";
						str += "<strong>"+empNama+"</strong></a></div>";
						str += "<div id=\"position\">" + getPositionName(pos.getDownPositionId()) + "</div>";

						str += "</td>";
						loop++;
						
					}
					str += "</tr></table></td>"+getDrawDownPosition(pos.getDownPositionId(), oidTemplate, approot, employeeList, divType, periodFrom, periodTo);
				} else {
                
					str += "<td valign=\"top\">";

					str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
					str += "<tr>";
					str += "<td width=\"50%\" style=\"border-right:1px solid #999; "+topkiri+"\">&nbsp;</td><td width=\"50%\" style=\""+topkanan+"\">&nbsp;</td>";
					str += "</tr>";
					if (pos.getVerticalLine() > 0){
						for(int v=0; v<pos.getVerticalLine(); v++){
							str += "<tr>";
							str += "<td width=\"50%\" style=\"border-right:1px solid #999;>&nbsp;</td><td width=\"50%\">&nbsp;</td>";
							str += "</tr>";
						}
					}
					str += "</table>";

					String pictPath = "";
					try {
						SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
						pictPath = sessEmployeePicture.fetchImageEmployee(employeeOid);

					} catch (Exception e) {
						System.out.println("err." + e.toString());
					} 

					if (pictPath != null && pictPath.length() > 0) {
					   str += "<img  height=\"64\" id=\"photo\" src=\"" + approot + "/" + pictPath + "\">";
					} else {
					   str += "<img height=\"64\" id=\"photo\" src=\""+approot+"/imgcache/no-img.jpg\" />";   
					}

					String empNama = empAmount.infoEmp(employeeOid);
					if (empNama.equals("")){
						empNama = "Empty";
					}

					String clss = "";
					int empAge = PstEmployee.getEmployeeAge(employeeOid);
					if (empAge == umurMbt){
						clss = "class='mbt'";
					} else if (empAge >= umurPensiun){
						clss = "class='pensiun'";
					}

					str += "<div style=\"color: #373737\"><a id=\"linkStyle\" "+clss+" href=\"javascript:cmdViewEmployee('" + employeeOid + "','"+ divisionId +"')\">";
					str += "<strong>"+empNama+"</strong></a></div>";
					str += "<div id=\"position\">" + getPositionName(pos.getDownPositionId()) + "</div>" + getDrawDownPosition(pos.getDownPositionId(), oidTemplate, approot, employeeList, divType, periodFrom, periodTo);

					str += "</td>";
				}
            }
            str += "</tr></table>";
        }
        
        return str;
    }

    public String getPositionName(long posId){
        String position = "";
        Position pos = new Position();
        try {
            pos = PstPosition.fetchExc(posId);
        } catch(Exception ex){
            System.out.println("getPositionName ==> "+ex.toString());
        }
        position = pos.getPosition();
        return position;
    }

    public String getDivisionName(long divisionId){
        String name = "-";
        if (divisionId != 0) {
            try {
                Division division = PstDivision.fetchExc(divisionId);
                name = division.getDivision();
            } catch (Exception e) {
                System.out.println("Division Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public String getDepartmentName(long departmentId){
        String name = "-";
        if (departmentId != 0){
            try {
                Department depart = PstDepartment.fetchExc(departmentId);
                name = depart.getDepartment();
            } catch (Exception e) {
                System.out.println("Department Name =>" + e.toString());
            }
        }
        return name;
    }
    
    public String getSectionName(long sectionId){
        String name = "-";
        if (sectionId != 0){
            try {
                Section section = PstSection.fetchExc(sectionId);
                name = section.getSection();
            } catch (Exception e) {
                System.out.println("Section Name =>" + e.toString());
            }
        }
        return name;
    }
%>
<%
    long sdmDivisionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_SDM_DIVISION)));
    long selectStructure = FRMQueryString.requestLong(request, "select_structure");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "section_id");
    String whereMap = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+selectStructure;
    Vector listMap = PstMappingPosition.list(0, 0, whereMap, "");
       
    /* Period From and Period To */
    String periodFrom = FRMQueryString.requestString(request, "period_from");
    String periodTo = FRMQueryString.requestString(request, "period_to");
    
    String whereClause = "";
    EmployeeAmountXLS empAmount = new EmployeeAmountXLS();
    Date dateNow = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String strDateNow = sdf.format(dateNow);
    if (periodFrom.equals("")){
        periodFrom = strDateNow;
    }
    if (periodTo.equals("")){
        periodTo = strDateNow;
    }

    int checkUp = 0;
    long topMain = 0;
    /* get Data Division Type ID */
    Division division = new Division();
    String labelStructure = "-";
    long divisiTypeId = 0;
    int divType = 0;
    String testOut = "";
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        try {
            /* Output dari proses ini adalah division name dan division type (divType) */
            division = PstDivision.fetchExc(divisionId);
            divisiTypeId = division.getDivisionTypeId();
            labelStructure = dictionaryD.getWord(I_Dictionary.DIVISION)+" : "+division.getDivision();
            if (divisiTypeId != 0){
                DivisionType divisiType = PstDivisionType.fetchExc(divisiTypeId);
                divType = divisiType.getGroupType();
            }
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    if (divisionId == 0 && departmentId != 0 && sectionId == 0){
        /* Jika departmentId tidak sama dengan 0, maka secara default division Type adalah Branch Of Company */
        divType = PstDivisionType.TYPE_BRANCH_OF_COMPANY;
        labelStructure = dictionaryD.getWord(I_Dictionary.DEPARTMENT)+" : "+getDepartmentName(departmentId);
    }
    if (divisionId == 0 && departmentId == 0 && sectionId != 0){
        divType = PstDivisionType.TYPE_BRANCH_OF_COMPANY;
        labelStructure = dictionaryD.getWord("SECTION")+" : "+getSectionName(sectionId);
    }

    /* Get template name */
    String templateName = "-";
    try {
        StructureTemplate structTemp = PstStructureTemplate.fetchExc(selectStructure);
        templateName = structTemp.getTemplateName();
    } catch(Exception e){
        System.out.println(""+e.toString());
    }
    /* end Get template name */
 /*
 * Update 2016-07-25
 * Load employee by Position and Period
 */
    
    Vector listPosition = new Vector();
    Vector listPosColl = new Vector();
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionId;
        listPosColl = PstPositionDivision.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionDivision posDiv = (PositionDivision)listPosColl.get(i);
                listPosition.add(posDiv.getPositionId());
            }
        }
    }
    if (divisionId == 0 && departmentId != 0 && sectionId == 0){
        whereClause = PstPositionDepartment.fieldNames[PstPositionDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
        listPosColl = PstPositionDepartment.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionDepartment posDep = (PositionDepartment)listPosColl.get(i);
                listPosition.add(posDep.getPositionId());
            }
        }
    }
    if (divisionId == 0 && departmentId == 0 && sectionId != 0){
        whereClause = PstPositionSection.fieldNames[PstPositionSection.FLD_SECTION_ID]+"="+sectionId;
        listPosColl = PstPositionSection.list(0, 0, whereClause, "");
        if (listPosColl != null && listPosColl.size()>0){
            for(int i=0; i<listPosColl.size(); i++){
                PositionSection posSec = (PositionSection)listPosColl.get(i);
                listPosition.add(posSec.getPositionId());
            }
        }
    }
    /*===================================*/
    /* Sorting Position by Level         */
    /*
    SELECT hr_position.`POSITION_ID`, hr_level.`LEVEL` FROM hr_position
    INNER JOIN hr_level ON hr_position.`LEVEL_ID`=hr_level.`LEVEL_ID`
    ORDER BY hr_level.`LEVEL_RANK` DESC;
    */
    whereClause = "";
    if (listPosition != null && listPosition.size()>0){
        for(int i=0; i<listPosition.size(); i++){
            Long posId = (Long)listPosition.get(i);
            whereClause = whereClause + posId + ",";
        }
        whereClause = whereClause.substring(0, whereClause.length()-1);
    }
    
    if (departmentId != 0){
        /* Cari division id */
        String where = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
        Vector deptList = PstDepartment.listVerySimple(where);
        if (deptList != null && deptList.size()>0){
            Department dept = (Department)deptList.get(0);
            divisionId = dept.getDivisionId();
        }
    }
    
    if (sectionId != 0){
        String where = PstSection.fieldNames[PstSection.FLD_SECTION_ID]+"="+sectionId;
        Vector sectList = PstSection.list(0, 0, where, "");
        if (sectList != null && sectList.size()>0){
            Section sect = (Section)sectList.get(0);
            departmentId = sect.getDepartmentId();
            
            if (departmentId != 0){
                /* Cari division id */
                where = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]+"="+departmentId;
                Vector deptList = PstDepartment.listVerySimple(where);
                if (deptList != null && deptList.size()>0){
                    Department dept = (Department)deptList.get(0);
                    divisionId = dept.getDivisionId();
                }
            }
            departmentId = 0;
        }
    }
    Vector listPositionAfterSort = PstPosition.getPositionSortByLevel(whereClause);
    Vector employeeTemp = PstCareerPath.getEmployeeByPeriod(periodFrom, periodTo, divisionId, whereClause);
    Vector employeeList = new Vector();
    if (divisionId != 0 && departmentId == 0 && sectionId == 0){
        employeeList = PstCareerPath.getEmployeeByPeriod(periodFrom, periodTo, divisionId, whereClause);
    }
    if (departmentId != 0 && sectionId == 0){
        if (employeeTemp != null && employeeTemp.size()>0){
            for(int e=0; e < employeeTemp.size(); e++){
                EmployeeAndPosition emp = (EmployeeAndPosition)employeeTemp.get(e);
                if (departmentId == emp.getDepartmentId()){
                    employeeList.add(emp);
                }
            }
        }
    }
    if (departmentId == 0 && sectionId != 0){
        if (employeeTemp != null && employeeTemp.size()>0){
            for(int e=0; e < employeeTemp.size(); e++){
                EmployeeAndPosition emp = (EmployeeAndPosition)employeeTemp.get(e);
                if (sectionId == emp.getSectionId()){
                    employeeList.add(emp);
                }
            }
        }
    }
    
    int umurPensiun = 0;
    int umurMbt = 0;
    try {
        umurPensiun = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
        umurMbt = Integer.parseInt(PstSystemProperty.getValueByName("UMUR_PENSIUN"));
    } catch (Exception exc){}
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Organization - View</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                color:#373737; 
                background-color: #EEE;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; background-color: #FFF;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; }
            .tblStyle1 {border-collapse: collapse; background-color: #FFF;}
            .tblStyle1 td {color:#575757; text-align: center; font-size: 11px; padding: 3px 0px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3; }
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            .header {
                
            }
            .content-main {
                padding: 13px 17px;
                margin: 0px 23px 21px 23px;
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
            
            #photo {
                padding: 3px; 
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
            .item {
                color: #474747;
                background-color: #E5E5E5;
                padding: 3px 5px;
                margin: 3px 0px;
                border-radius: 3px;
            }
            #position {
                padding: 2px 3px;
                margin: 3px;
            }
            
            a.pensiun:link, 
            a.pensiun:visited, 
            a.pensiun:active {
                color: red;
            }
            
            a.mbt:link, 
            a.mbt:visited, 
            a.mbt:active {
                color: orange;
            }
        </style>
        <script type="text/javascript">
            function cmdViewEmployee(oid, oidDivision){
                document.frm.employee_oid.value=oid;
                document.frm.division_id.value = oidDivision;
                document.frm.action="employee_detail.jsp";
                document.frm.target="_blank";
                document.frm.submit();
            }
            function cmdExportExcel(){
                document.frm.action="<%=printroot%>.report.ExportPositionOrgXLS"; 
                document.frm.target = "ReportExcel";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div id="menu_utama">
            <span id="menu_title"><strong style="color:#474747">Organization :</strong> 
                <%=templateName%><strong style="color:#333;"> / </strong><%=labelStructure%>
                <strong style="color:#333;"> / </strong><%= periodFrom +" to "+periodTo %>
            </span>
        </div>
        <div class="content-main">
            <form name="frm">
                <input type="hidden" name="employee_oid" value="0" />
                <input type="hidden" name="division_id" value="<%= divisionId %>" />
                <input type="hidden" name="department_id" value="<%= departmentId %>" />
                <input type="hidden" name="section_id" value="<%= sectionId %>" />
                <input type="hidden" name="period_from" value="<%= periodFrom %>" />
                <input type="hidden" name="period_to" value="<%= periodTo %>" />                        
            </form>
            <%
            if (listMap != null && listMap.size()>0){
                long[] arrUp = new long[listMap.size()];
                long[] arrDown = new long[listMap.size()];
                /* inisialisasi array up position dan down position */
                for(int i=0; i<listMap.size(); i++){
                    MappingPosition map = (MappingPosition)listMap.get(i);
                    arrUp[i] = map.getUpPositionId();
                    arrDown[i] = map.getDownPositionId();
                }
                if (divType == PstDivisionType.TYPE_DIVISION){ /* Division Regular */
                    testOut = "Division Regular";
                    /* ambil data position pada mapping PositionDivision */
                    whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionId;
                    Vector listPosDivision = PstPositionDivision.list(0, 0, whereClause, "");
                    String strPos = "";
                    /* jika data list position division ada, maka tampung ke strPos */
                    if (listPosDivision != null && listPosDivision.size()>0){
                        for(int i=0; i<listPosDivision.size(); i++){
                            PositionDivision posDiv = (PositionDivision)listPosDivision.get(i);
                            strPos += posDiv.getPositionId() +", ";
                        }
                        strPos += "0";
                        whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+" IN("+strPos+")"
                                    + " AND " + PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK]+" = "+PstMappingPosition.SUPERVISORY;
                        Vector listMap2 = PstMappingPosition.list(0, 0, whereClause, "");
                        /* manipulasi atau isi ulang arrUp dan arrDown dg MappingPosition baru */
                        if (listMap2 != null && listMap2.size()>0){
                            arrUp = new long[listMap2.size()];
                            arrDown = new long[listMap2.size()];
                            for(int i=0; i<listMap2.size(); i++){
                                MappingPosition map = (MappingPosition)listMap2.get(i);
                                arrUp[i] = map.getUpPositionId();
                                arrDown[i] = map.getDownPositionId();
                            }
                        }
                        /* mencari position teratas */
                        for(int j=0; j<arrUp.length; j++){
                            for(int k=0; k<arrDown.length; k++){
                                if (arrUp[j] == arrDown[k]){
                                    checkUp++;
                                }
                            }
                            if (checkUp == 0){
                                topMain = arrUp[j];
                            }
                            checkUp = 0;
                        }
                    }
                } else {

                    for(int j=0; j<arrUp.length; j++){
                        for(int k=0; k<arrDown.length; k++){
                            if (arrUp[j] == arrDown[k]){
                                checkUp++;
                            }
                        }
                        if (checkUp == 0){
                            topMain = arrUp[j];
                        }
                        checkUp = 0;
                    }
                    if (divType == PstDivisionType.TYPE_BRANCH_OF_COMPANY){
                        testOut = "B O C";
                    }
                    
                    if (divType == PstDivisionType.TYPE_BOD){
                        testOut = "B O D";
                    }
                }
                /* Draw Structure */
                if (topMain > 0){
                    %>      
                    <table class="tblStyle1">
                        <tr>
                            <td valign="top" style="padding: 21px">
                                <%
                                long employeeOid = 0;
                                
                                if (divType == PstDivisionType.TYPE_BOD){
                                    employeeOid = PstCareerPath.getEmployeeIdCaseBOD(periodFrom, periodTo, topMain);
                                } else {
                                    if (employeeList != null && employeeList.size()>0){
                                        for(int e=0; e < employeeList.size(); e++){
                                            EmployeeAndPosition emp = (EmployeeAndPosition)employeeList.get(e);
                                            if (emp.getPositionId() == topMain){
                                                employeeOid = emp.getEmployeeId();
                                            }
                                        }
                                    }
                                }
                                
                                
                                String pictPath = "";
                                try {
                                    SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                    pictPath = sessEmployeePicture.fetchImageEmployee(employeeOid);

                                } catch (Exception e) {
                                    System.out.println("err." + e.toString());
                                }%>
                                <%
                                     if (pictPath != null && pictPath.length() > 0) {
                                         %>
                                        <img height="64" id="photo" src="<%= approot +"/"+ pictPath %>" />
                                        <%
                                     } else {
                                %>
                                        <img height="64" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                <%
                                    }
                                %> 
                                <div style="color: #373737;">
                                    <%
                                    if (employeeOid != 0){
                                        String clss = "";
                                        int empAge = PstEmployee.getEmployeeAge(employeeOid);
                                        if (empAge == umurMbt){
                                            clss = "class='mbt'";
                                        } else if (empAge >= umurPensiun){
                                            clss = "class='pensiun'";
                                        }
                                        %>
                                        <a <%=clss%> href="javascript:cmdViewEmployee('<%=employeeOid%>','<%= divisionId %>')">
                                            <strong><%= empAmount.infoEmp(employeeOid) %></strong>
                                        </a>
                                        <%
                                    } else {
                                        %>
                                        <strong>-Kosong x-</strong>
                                        <%
                                    }
                                    %>
                                </div>
                                <%=getPositionName(topMain)%>
                                <%=getDrawDownPosition(topMain, selectStructure, approot, employeeList, divType, periodFrom, periodTo)%>
                            </td>
                        </tr>
                    </table>
                    <%
                }
            }
            %>
        </div>
       
        <div class="content-main">
            <div id="menu_utama">
                <span id="menu_title">Jabatan yang Tersedia</span>
            </div>
            <div>&nbsp;</div>
            <div>&nbsp;</div>
            <div>
                <%

                    
                    if (getEmployeeDivision(appUserSess.getEmployeeId()) == sdmDivisionOid){
                        %>
                        <a class="btn" style="color:#FFF" href="javascript:cmdExportExcel()">Export Data to Excel</a>
                        <%
                    } else {
                        if (getEmployeeDivision(appUserSess.getEmployeeId())==divisionId){
                            %>
                            <a class="btn" style="color:#FFF" href="javascript:cmdExportExcel()">Export Data to Excel</a>
                            <%
                        }
                    }
                    

                %>
                
            </div>
            <div>&nbsp;</div>
            <table class="tblStyle">
                <tr>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Position name</td>
                    <td class="title_tbl">Jumlah</td>
                </tr>
<%
    int total = 0;
    if (listPositionAfterSort != null && listPositionAfterSort.size()>0){
        for(int i=0; i<listPositionAfterSort.size(); i++){
            Long posId = (Long)listPositionAfterSort.get(i);
            int jumlah = 0;
            %>
            <tr>
                <td><%=(i+1)%></td>
                <td>
                    <div><strong><%= getPositionName(posId) %></strong></div>
                    <% 
                    if (divType == PstDivisionType.TYPE_BOD){
                        long employeeOid = PstCareerPath.getEmployeeIdCaseBOD(periodFrom, periodTo, posId);
                        jumlah++;
                        %>
                        <div class="item">
                            <%
                                String clss = "";
                                int empAge = PstEmployee.getEmployeeAge(employeeOid);
                                if (empAge == umurMbt){
                                    clss = "class='mbt'";
                                } else if (empAge >= umurPensiun){
                                    clss = "class='pensiun'";
                                }
                            %>
                            <a <%=clss%> href="javascript:cmdViewEmployee('<%=employeeOid%>','<%= divisionId %>')">
                                <%= empAmount.infoEmp(employeeOid) %>
                            </a>
                            <%--= empAmount.infoEmp(employeeOid) --%>
                        </div>
                        <%
                    } else {
                    if (employeeList != null && employeeList.size()>0){
                        for(int e=0; e < employeeList.size(); e++){
                            EmployeeAndPosition emp = (EmployeeAndPosition)employeeList.get(e);
                            if (emp.getPositionId() == posId){
                                jumlah++;
                                %>
                                <%
                                    String clss = "";
                                    int empAge = PstEmployee.getEmployeeAge(emp.getEmployeeId());
                                    if (empAge == umurMbt){
                                        clss = "class='mbt'";
                                    } else if (empAge >= umurPensiun){
                                        clss = "class='pensiun'";
                                    }
                                %>
                                <div>
                                    <a <%=clss%> href="javascript:cmdViewEmployee('<%=emp.getEmployeeId()%>','<%= divisionId %>')">
                                        <%= empAmount.infoEmp(emp.getEmployeeId()) %>
                                    </a>
                                </div>
                                <%--<div class="item"><%= empAmount.infoEmp(emp.getEmployeeId()) %></div>--%>
                                <%
                            }
                        }
                    }
                    }
            
                    
                    %>
                </td>
                <td><%= jumlah %></td>
            </tr>
            <%
            total = total + jumlah;
        }
    }
%>
                <tr>
                    <td colspan="2"><strong>Total</strong></td>
                    <td><%= total %></td>
                </tr>
            </table>
        </div>
    </body>
</html>