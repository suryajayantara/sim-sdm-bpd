<%-- 
    Document   : KPI_target
    Created on : Sep 24, 2018, 11:34:12 AM
    Author     : dimata005
--%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiTargetDetail"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetail"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiTarget"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTarget"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Company_Target"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMaster"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMaster"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<% //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_MASTER);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PRESENCE_REPORT, AppObjInfo.OBJ_PRESENCE_DAILY_REPORT);
%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>

<%!
        public String[] alphanumeric = {
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
                "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
                "y", "z"
        };
%>

<%
 long oidTarget = FRMQueryString.requestLong(request, "targetId");
 long oidTargetDetail = FRMQueryString.requestLong(request, "oidTargetDetail");
 long oidCompany = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_COMPANY_ID]);
 int tahun = Calendar.getInstance().get(Calendar.YEAR);  
 int iCommand = FRMQueryString.requestCommand(request);
 int start = FRMQueryString.requestInt(request, "start");
 long divisionId = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_DIVISION_ID]);
 long departmentId = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_DEPARTMENT_ID]);
 long sectionId = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_SECTION_ID]);
 long groupId = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_GROUP_ID]);
 long kpiId = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_ID]);
 long detailId = FRMQueryString.requestLong(request, "detail_employee_id");
 int status = FRMQueryString.requestInt(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_SECTION_ID]);
 int deleteFor = FRMQueryString.requestInt(request, "delete_for");
 
 boolean weightValue = false;
 
 if (iCommand == Command.DELETE && deleteFor == 1){
        try {
                PstKpiTargetDetailEmployee.deleteExc(detailId);
        } catch (Exception exc){}
        iCommand = Command.EDIT;
} else if (iCommand == Command.DELETE && deleteFor == 2){
    try {
            PstKpiTargetDetail.deleteExc(oidTargetDetail);
            String whereClauseEmpDetail = PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]+"="+oidTargetDetail;
            Vector listDetailEmp = PstKpiTargetDetailEmployee.list(0, 0, whereClauseEmpDetail, "");
            if (listDetailEmp.size()>0){
                for (int i = 0; i < listDetailEmp.size(); i++){
                    KpiTargetDetailEmployee kpiTargetDetailEmployee = (KpiTargetDetailEmployee) listDetailEmp.get(i);
                    try {
                        PstKpiTargetDetailEmployee.deleteExc(kpiTargetDetailEmployee.getOID());
                    } catch (Exception exc){}
                }
            }
    } catch (Exception exc){}
    iCommand = Command.EDIT;
    oidTargetDetail = 0;
}
 
 
 
if (iCommand == Command.SAVE && detailId > 0) {
    try {
        iCommand = Command.EDIT;
        KpiTargetDetailEmployee kpiTargetDetailEmployee = PstKpiTargetDetailEmployee.fetchExc(detailId);
        detailId = 0;
        double bobot = FRMQueryString.requestDouble(request, "bobot");
        kpiTargetDetailEmployee.setBobot(bobot);
        PstKpiTargetDetailEmployee.updateExc(kpiTargetDetailEmployee);
    } catch (Exception exc){}
}
 
CtrlKpiTarget ctrlKpiTarget = new CtrlKpiTarget(request);
int iErrCode = ctrlKpiTarget.action(iCommand , oidTarget);
KpiTarget kpiTarget = ctrlKpiTarget.getKpiTarget();

 CtrlKpiTargetDetail ctrlKpiTargetDetail = new CtrlKpiTargetDetail(request);
int iErrCodeDetail = ctrlKpiTargetDetail.action(iCommand , oidTargetDetail);
KpiTargetDetail kpiTargetDetail = ctrlKpiTargetDetail.getKpiTargetDetail();



if (kpiTarget.getOID()>0){
        oidTarget = kpiTarget.getOID();
        tahun = kpiTarget.getTahun();
}

if (kpiTargetDetail.getOID()>0){
        groupId = kpiTargetDetail.getKpiGroupId();
        kpiId = kpiTargetDetail.getKpiId();
}

if(oidCompany!=0){ 
        kpiTarget.setCompanyId(oidCompany);  
} else {
        oidCompany = kpiTarget.getCompanyId();
}

if(divisionId!=0){ 
        kpiTarget.setDivisionId(divisionId);
} else{
        divisionId = kpiTarget.getDivisionId();
}
if(departmentId!=0){ 
        kpiTarget.setDepartmentId(departmentId);
} else{
        departmentId=kpiTarget.getDepartmentId();
}
if(sectionId!=0){ 
        kpiTarget.setSectionId(sectionId);
} else{
        sectionId = kpiTarget.getSectionId();
}
		   
String strDisable = "";
if (appUserSess.getAdminStatus()==0){
        oidCompany = emplx.getCompanyId();
        if (!privViewAllDivision){
                divisionId = emplx.getDivisionId();
                strDisable = "disabled=\"disabled\"";            
        }

}	   

if (!privViewAllDivision && appUserSess.getAdminStatus() != 1){
    divisionId = emplx.getDivisionId();
}

Vector listDetail = PstKpiTargetDetail.listJoinKpi(0, 0,
                "DET."+PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_ID]+"="+kpiTarget.getOID(), "LST.PARENT_ID");
           
String whereClause = "COMPANY_ID = '" + oidCompany + "'";
Vector valTahun = new Vector();
Vector vKpiSetting = PstKpiSetting.list(0, 0, whereClause, "");
Vector listCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
Company entCompany = PstCompany.fetchExc(oidCompany);

Calendar calNow = Calendar.getInstance();
for (int i=calNow.get(Calendar.YEAR) ; i >= 2000 ; i--){
    valTahun.add(""+i);
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Target & Distribusi</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(function () {
                $(".datepicker").datepicker({dateFormat: "yy-mm-dd"});
            });
        </script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../stylesheets/custom.css" >
        <script language="JavaScript">
            function cmdUpdateSec() {
                document.frmKPI_Company_Target.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function cmdCancel() {
                document.frmKPI_Company_Target.command.value = "<%=Command.EDIT%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.oidTargetDetail.value = 0;
                document.frmKPI_Company_Target.submit();
            }

            function cmdBack() {
                document.frmKPI_Company_Target.command.value = "<%=Command.LIST%>";
                document.frmKPI_Company_Target.action = "kpi_target_list.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function cmdEditDetail(oid) {
                document.frmKPI_Company_Target.command.value = "<%=Command.EDIT%>";
                document.frmKPI_Company_Target.oidTargetDetail.value = oid;
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function cmdSave() {
                var size = document.getElementById("detail-size").value;
                var docStatus = document.getElementById("status-doc").value;
                if (docStatus == <%=I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED%>) {
                    if (size > 0) {
                        document.frmKPI_Company_Target.command.value = "<%=Command.SAVE%>";
                        document.frmKPI_Company_Target.action = "KPI_target.jsp";
                        document.frmKPI_Company_Target.submit();
                    } else {
                        alert("Belum ada detail!, Tidak bisa rubah ke to be approve");
                    }
                } else {
                    document.frmKPI_Company_Target.command.value = "<%=Command.SAVE%>";
                    document.frmKPI_Company_Target.action = "KPI_target.jsp";
                    document.frmKPI_Company_Target.submit();
                }

            }

            function cmdSaveDetail() {
                document.frmKPI_Company_Target.command.value = "<%=Command.SAVE%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function cmdAddDetail() {
                document.frmKPI_Company_Target.command.value = "<%=Command.ASSIGN%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }
            
            function cmdAddDetailByKpiSetting() {
                
            }

            function cmdDep(divId) {
                document.frmKPI_Company_Target.command.value = "<%=Command.EDIT%>";
                document.frmKPI_Company_Target.divId.value = divId;
                document.frmKPI_Company_Target.depId.value = 0;
                document.frmKPI_Company_Target.secId.value = 0;
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function loadKpi() {
                document.frmKPI_Company_Target.command.value = "<%=Command.ASSIGN%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.submit();
            }

            function loadKpiDetail(groupId) {

                var strUrl = "";
                if (groupId.length == 0) {
                    document.getElementById("kpi-list").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function () {
                        alert(xmlhttp.responseText);
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("kpi-list").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "kpi_target_ajax.jsp";

                    strUrl += "?groupId=" + groupId;

                    strUrl += "&FRM_FIELD_DATA_FOR=kpiList";
                    xmlhttp.open("GET", strUrl, true);

                    xmlhttp.send();
                }
            }

            function cmdAddEmployee(oidTargetDetail, oidKPI) {
                window.open("<%=approot%>/masterdata/kpi_emp_search.jsp?oidTargetDetail=" + oidTargetDetail + "&oidKPI=" + oidKPI + "&targetId=<%=oidTarget%>", null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }

            function appendData(id, data) {
                var div = document.getElementById(id);
                div.innerHTML += data;
            }

            function cmdDeleteEmp(oid) {
                var r = confirm("Hapus Data?");
                if (r == true) {
                    ;
                    document.frmKPI_Company_Target.command.value = "<%=Command.DELETE%>";
                    document.frmKPI_Company_Target.delete_for.value = "1";
                    document.frmKPI_Company_Target.action = "KPI_target.jsp";
                    document.frmKPI_Company_Target.detail_employee_id.value = oid;
                    document.frmKPI_Company_Target.submit();
                }
            }

            function cmdDeleteDetail(oid) {
                var r = confirm("Hapus Data?");
                if (r == true) {
                    ;
                    document.frmKPI_Company_Target.command.value = "<%=Command.DELETE%>";
                    document.frmKPI_Company_Target.delete_for.value = "2";
                    document.frmKPI_Company_Target.action = "KPI_target.jsp";
                    document.frmKPI_Company_Target.oidTargetDetail.value = oid;
                    document.frmKPI_Company_Target.submit();
                }
            }

            function cmdEditEmp(oid) {
                document.frmKPI_Company_Target.command.value = "<%=Command.EDIT%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.detail_employee_id.value = oid;
                document.frmKPI_Company_Target.submit();
            }
            function cmdSaveEmp(oid) {
                document.frmKPI_Company_Target.command.value = "<%=Command.SAVE%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.detail_employee_id.value = oid;
                document.frmKPI_Company_Target.submit();
            }
            function cmdBackEmp() {
                document.frmKPI_Company_Target.command.value = "<%=Command.EDIT%>";
                document.frmKPI_Company_Target.action = "KPI_target.jsp";
                document.frmKPI_Company_Target.detail_employee_id.value = 0;
                document.frmKPI_Company_Target.submit();
            }
            function showKpiSettingDetail(chosen){
                var strUrl = "";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("detailKpiSetting").innerHTML = xmlhttp.responseText;
                    }
                }
                strUrl = "ajax_kpi_setting_detail.jsp";
                strUrl += "?kpi_setting_id="+chosen;
                xmlhttp.open("GET", strUrl, true);
                xmlhttp.send();
            }

        </script>
    </head>
    <body onload="prepare()" >
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
                <%@include file="../styletemplate/template_header.jsp" %>
                <%} else {%>
                <tr> 
                    <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                        <!-- #BeginEditable "header" --> 
                        <%@ include file = "../main/header.jsp" %>
                        <!-- #EndEditable --> 
                    </td>
                </tr>
                <tr> 
                    <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                        <%@ include file = "../main/mnmain.jsp" %>
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
            <span id="menu_title"><strong>Performance Management</strong> <strong style="color:#333;"> / </strong>Target & Distribusi</span>
        </div>
        <div class="content-main">
            <form name="frmKPI_Company_Target" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="oidTargetDetail" value="<%=oidTargetDetail%>">
                <input type="hidden" id="detail-size" value="<%=listDetail.size()%>">
                <input type="hidden" name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_AUTHOR_ID]%>" value="<%=appUserSess.getEmployeeId()%>">
                <input type="hidden" name="targetId" value="<%=oidTarget%>">
                <input type='hidden' name='detail_employee_id'>
                <input type="hidden" name="delete_for">
                <input type="hidden" name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_CREATE_DATE]%>" value="<%=(kpiTarget.getCreateDate() != null ? kpiTarget.getCreateDate() : Formater.formatDate(new Date(), "yyyy-MM-dd"))%>">
                <div class="formstyle">
                    <table width="100%">
                        <tr>
                            <td valign="top" width="35%">
                                <div id="caption">Company</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_COMPANY_ID]%>" id="company" class="chosen-select" data-placeholder='Select Company...' onchange="javascript:cmdUpdateSec()" <%= strDisable%> >
                                        <option value="0">-select-</option>
                                        <%
                                            if (listCompany != null && listCompany.size() > 0) {
                                                for (int i = 0; i < listCompany.size(); i++) {
                                                    Company comp = (Company) listCompany.get(i);
                                                    if (kpiTarget.getCompanyId() == comp.getOID()) {
                                        %>
                                        <option selected="selected" value="<%=comp.getOID()%>"><%= comp.getCompany()%></option>
                                        <%
                                        } else if (!privViewAllDivision && comp.getOID() == emplx.getCompanyId() && appUserSess.getAdminStatus() == 0) {
                                        %><option selected="selected" value="<%=comp.getOID()%>"><%=comp.getCompany()%></option><%
                                        } else {
                                        %>
                                        <option value="<%=comp.getOID()%>"><%= comp.getCompany()%></option>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </select>
                                    <%
                                        if (strDisable.length() > 0) {
                                    %>
                                    <input type="hidden" name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_COMPANY_ID]%>" id="company" value="<%= oidCompany%>" />
                                    <%
                                        }
                                    %>
                                </div>
                                <div id="caption">Division</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_DIVISION_ID]%>" id="division" class="chosen-select" data-placeholder='Select Division...' onchange="javascript:cmdUpdateSec()" <%= strDisable%>>
                                        <option value="0">-select-</option>
                                        <%
                                            if (oidCompany > 0) {
                                                String whereDiv = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " = " + oidCompany + "";
                                                whereDiv += " AND " + PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + "=" + PstDivision.VALID_ACTIVE;
                                                Vector listDivision = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                                if (listDivision != null && listDivision.size() > 0) {
                                                    for (int i = 0; i < listDivision.size(); i++) {
                                                        Division divisi = (Division) listDivision.get(i);
                                                        if (kpiTarget.getDivisionId() == divisi.getOID()) {
                                        %><option selected="selected" value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                                        } else if (!privViewAllDivision && divisi.getOID() == emplx.getDivisionId() && appUserSess.getAdminStatus() == 0) {
                                        %><option selected="selected" value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                                        } else {
                                            %><option value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                                                            }
                                                        }
                                                    }
                                                }
                                            %>
                                    </select>
                                    <%
                                        if (strDisable.length() > 0) {
                                    %>
                                    <input type="hidden" name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_DIVISION_ID]%>" id="division" value="<%= divisionId%>" />
                                    <%
                                        }
                                    %>
                                </div>
                                <div id="caption">Department</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_DEPARTMENT_ID]%>" id="department" class="chosen-select" data-placeholder='Select Department...' onchange="javascript:cmdUpdateSec()">
                                        <option value="0">-select-</option>
                                        <%
                                            if (divisionId > 0) {
                                                Vector listDepart = PstDepartment.listDepartmentVer1(0, 0, "" + oidCompany, "" + divisionId);
                                                if (listDepart != null && listDepart.size() > 0) {
                                                    for (int i = 0; i < listDepart.size(); i++) {
                                                        Department depart = (Department) listDepart.get(i);
                                                        if (kpiTarget.getDepartmentId() == depart.getOID()) {
                                        %><option selected="selected" value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
                                        } else {
                                        %><option value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
                                                        }
                                                    }
                                                }
                                            }
                                            %>
                                    </select>
                                </div>    
                                <div id="caption">Section</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_SECTION_ID]%>" id="section" class="chosen-select" data-placeholder='Select Section...'>
                                        <option value="0">-select-</option>
                                        <%
                                            if (departmentId > 0) {
                                                String whereSection = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + departmentId + " AND " + PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + "= 1";
                                                Vector listSection = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);

                                                if (listSection != null && listSection.size() > 0) {
                                                    for (int i = 0; i < listSection.size(); i++) {
                                                        Section section = (Section) listSection.get(i);
                                                        if (kpiTarget.getSectionId() == section.getOID()) {
                                        %><option selected="selected" value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                                        } else {
                                        %><option value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                                                        }
                                                    }
                                                }

                                            }
                                            %>
                                    </select>
                                </div> 
                            </td>
                            <td valign="top" width="65%">
                                <div id="caption">Judul</div>
                                <div id="divinput">
                                    <textarea name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TITLE]%>" style="width: 50%"><%=kpiTarget.getTitle()%></textarea>
                                </div>
                                <div id="caption">Tahun</div>
                                <div id="divinput">
                                    <%= ControlCombo.draw(FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TAHUN], "chosen-select", null, "" + tahun, valTahun, valTahun, "style='width : 20%'")%> 
                                </div>
                                <div id="caption">Status</div>
                                <div id="divinput">
                                    <%
                                        Vector val_status = new Vector(1, 1);
                                        Vector key_status = new Vector(1, 1);

                                    
                                        val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_DRAFT));
                                        key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);

                                        if (oidTarget > 0){
                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED]);

                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CANCELLED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CANCELLED]);
                                        }
                                    %>
                                    <%= ControlCombo.draw(FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_STATUS_DOC], "chosen-select", null, "" + kpiTarget.getStatusDoc(), val_status, key_status, "style='width : 20%' id='status-doc'")%> 
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan</a>
                    <a href="javascript:cmdBack()" style="color:#FFF;" class="btn btn-red">Kembali</a>
                    <%
                        if (kpiTarget.getOID() > 0) {
                    %>
                    <a href="javascript:cmdAddDetail()" style="color:#FFF;" class="btn btn-add">Tambah Detail</a>
                    <a href="javascript:cmdAddDetailByKpiSetting()" style="color:#FFF;" class="btn btn-add" data-bs-toggle="modal" data-bs-target="#modal-copy-kpi-setting">Tambah Detail Berdasarkan KPI Setting</a>
                    <%
                        }
                    %>
                    <div>&nbsp;</div>
                </div>
                <div>&nbsp;</div>
                <%if (iCommand == Command.ASSIGN || (iCommand == Command.EDIT && oidTargetDetail > 0)){%>
                <div class="formstyle">
                    <input type="hidden" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_ID]%>" value="<%=oidTarget%>">
                    <table width="100%">
                        <tr>
                            <td>
                                <div id="caption">KPI Group</div>
                                <div id="divinput">
                                    <%
                                        Vector group_value = new Vector(1, 1);
                                        Vector group_key = new Vector(1, 1);
                                        Vector listGroup = PstKPI_Group.list(0, 0, "", PstKPI_Group.fieldNames[PstKPI_Group.FLD_GROUP_TITLE]);
                                        group_value.add(""+0);
                                        group_key.add("Select...");
                                        for (int i = 0; i < listGroup.size(); i++) {
                                            KPI_Group group = (KPI_Group) listGroup.get(i);
                                            group_key.add(group.getGroup_title());
                                            group_value.add(String.valueOf(group.getOID()));
                                        }
            
                                    %>
                                    <%=ControlCombo.draw(FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_GROUP_ID],"chosen-select", null, "" + groupId, group_value, group_key, "onchange='javascript:loadKpi(this.value)' style='width: 90%' data-placeholder='Select Group...'")%>    
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table width="100%">
                        <tr>
                            <td>
                                <div id="caption">KPI</div>
                                <div id="divinput">
                                    <%
                                        Vector kpi_value = new Vector(1, 1);
                                        Vector kpi_key = new Vector(1, 1);
                                        String whereKPI = PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]+
                                            " IN ( SELECT "+PstKPI_List_Group.fieldNames[PstKPI_List_Group.FLD_KPI_LIST_ID]+
                                            " FROM "+PstKPI_List_Group.TBL_HR_KPI_LIST_GROUP+" WHERE "+
                                            PstKPI_List_Group.fieldNames[PstKPI_List_Group.FLD_KPI_GROUP_ID]+"="+groupId+") AND "+
                                            PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"=0 AND "+
                                                                            PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]+
                                            " NOT IN ( SELECT "+PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+
                                            " FROM "+PstKPI_List.TBL_HR_KPI_LIST+")";
                                        Vector listKpi = PstKPI_List.list(0, 0, whereKPI, PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_TITLE]);
                                        kpi_value.add(""+0);
                                        kpi_key.add("Select...");
                                        for (int i = 0; i < listKpi.size(); i++) {
                                            KPI_List kpiList = (KPI_List) listKpi.get(i);
                                            String titleX = "";
                                            if (kpiList.getKpi_title().length()>100){
                                                                                titleX = kpiList.getKpi_title().substring(0,97)+"...";
                                            } else {
                                                                                titleX = kpiList.getKpi_title();
                                            }
                                            Vector listChild = PstKPI_List.list(0, 0, 
                                                                                PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"="+kpiList.getOID()+" AND "+
                                                                                PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"<> 0"
                                                                                , "");
                                            if (listChild.size()>0){
                                                                                kpi_key.add(titleX);
                                                                                kpi_value.add(String.valueOf(-1));
                                                                                for (int x = 0; x < listChild.size(); x++) {
                                                                                    KPI_List kpiList1 = (KPI_List) listChild.get(x);
                                                                                    String titleX1 = "";
                                                                                    if (kpiList1.getKpi_title().length()>100){
                                                                                            titleX1 = kpiList1.getKpi_title().substring(0,97)+"...";
                                                                                    } else {
                                                                                            titleX1 = kpiList1.getKpi_title();
                                                                                    }
                                                                                    kpi_key.add(titleX1);
                                                                                    kpi_value.add(String.valueOf(kpiList1.getOID()));
                                                                                }
                                            } else {
                                                                                kpi_key.add(titleX);
                                                                                kpi_value.add(String.valueOf(kpiList.getOID()));
                                            }
                                        }
                                                                    whereKPI = PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]+
                                            " IN ( SELECT "+PstKPI_List_Group.fieldNames[PstKPI_List_Group.FLD_KPI_LIST_ID]+
                                            " FROM "+PstKPI_List_Group.TBL_HR_KPI_LIST_GROUP+" WHERE "+
                                            PstKPI_List_Group.fieldNames[PstKPI_List_Group.FLD_KPI_GROUP_ID]+"="+groupId+") AND "+
                                            PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"=0 AND "+
                                                                            PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]+
                                            " IN ( SELECT "+PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+
                                            " FROM "+PstKPI_List.TBL_HR_KPI_LIST+")";
                                        listKpi = PstKPI_List.list(0, 0, whereKPI, PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_TITLE]);
                                        for (int i = 0; i < listKpi.size(); i++) {
                                            KPI_List kpiList = (KPI_List) listKpi.get(i);
                                            String titleX = "";
                                            if (kpiList.getKpi_title().length()>100){
                                                                                titleX = kpiList.getKpi_title().substring(0,97)+"...";
                                            } else {
                                                                                titleX = kpiList.getKpi_title();
                                            }
                                            Vector listChild = PstKPI_List.list(0, 0, 
                                                                                PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"="+kpiList.getOID()+" AND "+
                                                                                PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"<> 0"
                                                                                , "");
                                            if (listChild.size()>0){
                                                                                kpi_key.add(titleX);
                                                                                kpi_value.add(String.valueOf(-1));
                                                                                for (int x = 0; x < listChild.size(); x++) {
                                                                                    KPI_List kpiList1 = (KPI_List) listChild.get(x);
                                                                                    String titleX1 = "";
                                                                                    if (kpiList1.getKpi_title().length()>100){
                                                                                            titleX1 = kpiList1.getKpi_title().substring(0,97)+"...";
                                                                                    } else {
                                                                                            titleX1 = kpiList1.getKpi_title();
                                                                                    }
                                                                                    kpi_key.add(titleX1);
                                                                                    kpi_value.add(String.valueOf(kpiList1.getOID()));
                                                                                }
                                            } else {
                                                                                kpi_key.add(titleX);
                                                                                kpi_value.add(String.valueOf(kpiList.getOID()));
                                            }
                                        }
                                        String[] kpiIdList = {
                                            ""+kpiId
                                        };
                                    %>
                                    <%=ControlCombo.drawStringArraySelectedOptGroup(FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_ID],"chosen-select", null, kpiIdList, kpi_key, kpi_value, null , "onchange='javascript:loadKpi(this.value)' data-placeholder='Select Group...'")%>    
                                    <%
                                                                    if (groupId > 0){
                                    %> <a href="javascript:cmdAddKPI()" class="btn-small" style="color:#FFF;">Tambah KPI</a> <%
                                                                    }
                                    %>
                                </div>
                                <% if (kpiId > 0) { 
                                    KPI_List kPI_List = new KPI_List();
                                    try {
                                        kPI_List = PstKPI_List.fetchExc(kpiId);
                                    } catch (Exception exc){}
                                %>
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td width="10%">
                                <div id="caption">Periode</div>
                                <div id="divinput">
                                    <%
                                        Vector periode_value = new Vector(1, 1);
                                        Vector periode_key = new Vector(1, 1);
                                        for (int i = 0; i < PstKpiTargetDetail.period.length; i++) {
                                            periode_key.add(PstKpiTargetDetail.period[i]);
                                            periode_value.add(String.valueOf(i));
                                        }
            
                                    %>
                                    <%=ControlCombo.draw(FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD],"chosen-select", null, ""+kpiTargetDetail.getPeriod(), periode_value, periode_key, " data-placeholder='Select Group...'")%> 
                                </div>
                            </td>
                            <td width="10%">
                                <div id="caption">Periode Index</div>
                                <div id="divinput">                                    
                                    <input type="text" name="" id="" placeholder="Periode Index">    
                                </div>
                            </td>
                            <td width="10%">
                                <div id="caption">Date From</div>
                                <div id="divinput">                                    
                                    <input type="date" id="" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_FROM]%>" value="<%=kpiTargetDetail.getDateFrom()%>">    
                                </div>
                            </td>
                            <td>
                                <div id="caption">Date To</div>
                                <div id="divinput">                                    
                                    <input type="date" id="" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_TO]%>" value="<%=kpiTargetDetail.getDateTo()%>">    
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td width="10%">
                                <%
                                    switch(kPI_List.getInputType()){
                                        case PstKPI_List.TYPE_WAKTU:
                                            weightValue = true;
                                %>
                                <div id="caption">Target (Waktu)</div>
                                <div id="divinput">
                                    <input type="text" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_FROM]%>" id="date_from" class="datepicker" value="<%=Formater.formatDate((kpiTargetDetail.getDateFrom() != null ? kpiTargetDetail.getDateFrom() : new Date()), "yyyy-MM-dd")%>" /> to 
                                    <input type="text" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_TO]%>" id="date_to" class="datepicker" value="<%=Formater.formatDate((kpiTargetDetail.getDateTo()!= null ? kpiTargetDetail.getDateTo() : new Date()), "yyyy-MM-dd")%>"/>
                                </div>
                                <%
                            break;
                            case PstKPI_List.TYPE_JUMLAH:
                                weightValue = true;
                                %>
                                <div id="caption">Target (Jumlah)</div>
                                <div id="divinput">
                                    <input type="text" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]%>" value="<%=kpiTargetDetail.getAmount()%>"/>
                                </div>
                                <%
                            break;
                            case PstKPI_List.TYPE_PERSENTASE:
                                weightValue = true;
                                %>
                                <div id="caption">Target (Persentase)</div>
                                <div id="divinput">
                                    <input type="text" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]%>" value="<%=kpiTargetDetail.getAmount()%>"/>
                                </div>
                                <%
                            break;
                        }
                                %>
                                <% } %>
                            </td>

                            <% if(weightValue) { %>
                            <td>
                                <div id="caption">Weight Value</div>
                                <div id="divinput">                                    
                                    <input type="text" id="" placeholder="Weight Value" name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_WEIGHT_VALUE]%>" value="<%=kpiTargetDetail.getWeightValue()%>">    
                                </div>
                            </td>
                            <% } %>
                        </tr>
                    </table>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdSaveDetail()" style="color:#FFF;" class="btn">Simpan Detail</a>
                    <a href="javascript:cmdCancel()" style="color:#FFF;" class="btn btn-red">Batal</a>
                    <div>&nbsp;</div>
                </div>
                <%
                        } if (kpiTarget.getOID()>0){
                %>
                <div class="formstyle">
                    <table class="tblStyle" style="width: 100%">
                        <tr>
                            <td style="width: 5%; text-align: center" colspan="2"><strong>No</strong></td>
                            <td style="width: 50%; text-align: center"><strong>KPI</strong></td>
                            <td style="width: 20%; text-align: center"><strong>Target</strong></td>
                            <td style="width: 20%; text-align: center"><strong>Action</strong></td>
                        </tr>
                        <%
                                if (listDetail.size()>0){
                                        int number = 0;
                                        int numbAlpha = 0;
                                        boolean isSub = false;
                                        long oidParent = 0;
                                        for (int i =0 ; i < listDetail.size(); i++){
                                                KpiTargetDetail targetDetail = (KpiTargetDetail) listDetail.get(i);
									
                                                KPI_List kpil = new KPI_List();
                                                try {
                                                        kpil = PstKPI_List.fetchExc(targetDetail.getKpiId());
                                                } catch (Exception exc){}
									
                                                if (kpil.getParentId()>0){
                                                        isSub = true;
                                                        KPI_List kpiParent = new KPI_List();
                                                        try {
                                                                kpiParent = PstKPI_List.fetchExc(kpil.getParentId());
                                                        } catch (Exception exc){}
										
                                                        if (oidParent != kpil.getParentId()){
                                                                number++;
                                                                numbAlpha = 0;
                        %>
                        <tr>
                            <td colspan="2" style="text-align: center"><%=number%></td>
                            <td colspan="3"><strong><%=kpiParent.getKpi_title()%></strong></td>
                        </tr>
                        <%
                        oidParent = kpiParent.getOID();
                } else {
                        numbAlpha++;
                }
        } else {
                number++;
        }
            String target = "";
            if (kpil.getInputType()==PstKPI_List.TYPE_WAKTU){
                target = Formater.formatDate(targetDetail.getDateFrom(), "yyyy-MM-dd")+" - "+Formater.formatDate(targetDetail.getDateTo(), "yyyy-MM-dd");
            } else if (kpil.getInputType()==PstKPI_List.TYPE_PERSENTASE){
                target = targetDetail.getAmount()+" %";
            } else {
                target = ""+targetDetail.getAmount();
            }
                        %>
                        <tr>
                            <%
                                    if (isSub){
                            %>
                            <td colspan="2" style="text-align: right"><%=alphanumeric[numbAlpha]%></td>
                            <%
                    } else {
                            %>
                            <td colspan="2" style="text-align: center"><%=number%></td>
                            <%
                    }
                            %>
                            <td><%=kpil.getKpi_title()%></td>
                            <td><%=target%></td>

                            <td>
                                <a href="javascript:cmdEditDetail('<%=targetDetail.getOID()%>')" class="btn-small-e" style="color:#FFF;">e</a> 
                                <a href="javascript:cmdDeleteDetail('<%=targetDetail.getOID()%>')" class="btn-small-x" style="color:#FFF;">x</a>
                                <a href="javascript:cmdAddEmployee('<%=targetDetail.getOID()%>','<%=targetDetail.getKpiId()%>')" class="btn-small" style="color:#FFF;">Tambah Karyawan</a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">&nbsp;</td>
                            <td colspan="3">
                                <%
                                    String whereTargetDetailEmp = PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]+"="+targetDetail.getOID();
                                    Vector listEmployeeTarget = PstKpiTargetDetailEmployee.list(0, 0, whereTargetDetailEmp, "");
                                    if (listEmployeeTarget.size()>0){
                                %>
                                <table class="tblStyle" style="width: 100%">
                                    <tr>
                                        <td style="width: 5%; text-align: center" ><strong>No</strong></td>
                                        <td style="width: 10%; text-align: center"><strong>NRK</strong></td>
                                        <td style="width: 30%; text-align: center"><strong>Nama</strong></td>
                                        <td style="width: 30%; text-align: center"><strong>Satuan Kerja</strong></td>
                                        <td style="width: 10%; text-align: center"><strong>Bobot Distribusi</strong></td>
                                        <td style="width: 10%; text-align: center"><strong>Action</strong></td>
                                    </tr>
                                    <%
                                        int no = 0;
                                        for (int xx = 0; xx < listEmployeeTarget.size(); xx++){
                                            no++;
                                            KpiTargetDetailEmployee kpiTargetDetailEmployee = (KpiTargetDetailEmployee) listEmployeeTarget.get(xx);
                                            Employee empDetail = new Employee();
                                            try {
                                                empDetail = PstEmployee.fetchExc(kpiTargetDetailEmployee.getEmployeeId());
                                            } catch (Exception exc){}
                                                                                                    
                                    %>
                                    <tr>
                                        <td><%=no%></td>
                                        <td><%=empDetail.getEmployeeNum()%></td>
                                        <td><%=empDetail.getFullName()%></td>
                                        <td><%=PstEmployee.getDivisionName(empDetail.getDivisionId())%></td>
                                        <% if (iCommand == Command.EDIT && detailId == kpiTargetDetailEmployee.getOID()) { %>
                                        <td><input type='text' name='bobot' value='<%=kpiTargetDetailEmployee.getBobot()%>'></td>
                                        <td><a href="javascript:cmdSaveEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-e" style="color:#FFF;">s</a> 
                                            <a href="javascript:cmdBackEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-x" style="color:#FFF;">b</a></td>
                                            <% } else {%>
                                        <td><%=kpiTargetDetailEmployee.getBobot()%></td>
                                        <td><a href="javascript:cmdEditEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-e" style="color:#FFF;">e</a> 
                                            <a href="javascript:cmdDeleteEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-x" style="color:#FFF;">x</a></td>
                                            <% }  %>

                                    </tr>
                                    <%
                                }
                                    %>

                                </table>
                                <%
                            } else {
                                                                                        
                            }
                                %>

                            </td>
                        </tr>
                        <%
										
                        String whereEmployee = PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]+"="+targetDetail.getOID();
                        Vector listEmployee = PstKpiTargetDetailEmployee.list(0, 0, whereEmployee, "");
                        String empList = "";
                        for (int x = 0; x < listEmployee.size(); x++){
                                KpiTargetDetailEmployee detEmp = (KpiTargetDetailEmployee) listEmployee.get(x);
                                Employee emp = new Employee();
                                try {
                                        emp = PstEmployee.fetchExc(detEmp.getEmployeeId());
                                } catch (Exception exc){}
                                if (empList.length()==0){
                                        empList+= emp.getFullName()+" <a href=\"javascript:cmdDelete('"+detEmp.getOID()+"')\"> x </a>";
                                } else {
                                        empList+= ", "+ emp.getFullName()+" <a href=\"javascript:cmdDelete('"+detEmp.getOID()+"')\"> x </a>";
                                }
                        }	
										
                }
                        %>

                        <%
                                } else {
                        %>
                        <tr>
                            <td colspan="4"><span style="text-align: center; width: 100%">Belum ada data</span></td>
                        </tr>
                        <%
                                }
                        %>
                    </table>
                </div>
                <%
                        }
                %>
            </form>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
        <script type="text/javascript">
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': {allow_single_deselect: true},
                '.chosen-select-no-single': {disable_search_threshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
                '.chosen-select-width': {width: "100%"}
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
        
        <!-- Modal Copy Kpi Setting -->
        <div class="modal fade" id="modal-copy-kpi-setting" data-bs-backdrop="static" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">Pilih Kpi Setting</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
                <form>
                  <div class="modal-body">
                      <div class="mb-3">
                        <label for="exampleInputEmail1" class="form-label">Pilih Kpi Setting</label>
                        <select class="form-control" id="kpiSettingId" onchange="showKpiSettingDetail(this.options[this.selectedIndex].value)">
                            <% for(int i = 0; i < vKpiSetting.size(); i++){ 
                                KpiSetting entKpiSetting = (KpiSetting) vKpiSetting.get(i);
                                DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        
                                Date objStartDate = entKpiSetting.getStartDate();
                                Date objValidDate = entKpiSetting.getValidDate();

                                String startDate = dateFormat.format(objStartDate);  
                                String validDate = dateFormat.format(objValidDate);  
                            %>
                                <option value="<%= entKpiSetting.getOID() %>">KPI Setting <%= entKpiSetting.getTahun() %> (Berlaku <%= startDate %> s/d <%= validDate %>)</option>
                            <% } %>
                        </select>
                      </div>
                      
                          <div class="row">
                            <div class="col-md-2">
                                <h6>Company</h6>
                                <h6>Position</h6>
                                <h6>Status</h6>
                                <h6>Periode</h6>
                            </div>
                            <div class="col-md-10">
                                <h6>: <%= entCompany.getCompany()%></h6>
                                <div id="detailKpiSetting">
                                    
                                </div>
                            </div>
                          </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-red" data-bs-dismiss="modal">Batal</button>
                    <button type="button" class="btn">Simpan</button>
                  </div>
                </form>
            </div>
          </div>
        </div>
    </body>
</html>

