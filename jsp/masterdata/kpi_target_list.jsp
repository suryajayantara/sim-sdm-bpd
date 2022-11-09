<%-- 
    Document   : kpi_target_list
    Created on : Nov 26, 2019, 11:37:38 AM
    Author     : IanRizky
--%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
int iCommand = FRMQueryString.requestCommand(request);	
int tahun = FRMQueryString.requestInt(request, "tahun");
int status = FRMQueryString.requestInt(request, "status");
String judul = FRMQueryString.requestString(request, "title");
long divisionId = FRMQueryString.requestLong(request, "division_search");

Vector listTarget = new Vector();
boolean selectDiv = true;
Vector valTahun = new Vector();
Vector keyTahun = new Vector();
valTahun.add("0");
keyTahun.add("Select..");
Calendar calNow = Calendar.getInstance();
for (int i=calNow.get(Calendar.YEAR) ; i >= 2000 ; i--){
    valTahun.add(""+i);
    keyTahun.add(""+i);
}

if (iCommand == Command.LIST){
    String whereClause = " 1=1 ";
    if (judul.length()>0){
        whereClause += " AND "+PstKpiTarget.fieldNames[PstKpiTarget.FLD_TITLE]+" = '"+judul+"'";
    }
    if (divisionId > 0){
        whereClause += " AND "+PstKpiTarget.fieldNames[PstKpiTarget.FLD_DIVISION_ID]+" = '"+divisionId+"'";
    }
    if (tahun > 0) {
        whereClause += " AND "+PstKpiTarget.fieldNames[PstKpiTarget.FLD_TAHUN]+" = '"+tahun+"'";
    }
    if (status > -1) {
        whereClause += " AND "+PstKpiTarget.fieldNames[PstKpiTarget.FLD_STATUS_DOC]+" = '"+status+"'";
    }
    listTarget = PstKpiTarget.list(0, 0, whereClause, PstKpiTarget.fieldNames[PstKpiTarget.FLD_CREATE_DATE]+" DESC");
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daftar Target KPI</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../stylesheets/custom.css" >
		<script type="text/javascript">
            function cmdEdit(oid){
				document.frm.targetId.value=oid;
                document.frm.command.value="<%= Command.EDIT %>";
                document.frm.action="KPI_target.jsp";
                document.frm.submit();
            }
            function cmdAdd(){
                document.frm.targetId.value=0;
                document.frm.command.value="<%= Command.ADD %>";
                document.frm.action="KPI_target.jsp";
                document.frm.submit();
            }
            function cmdSearch(){
                document.frm.targetId.value=0;
                document.frm.command.value="<%= Command.LIST %>";
                document.frm.action="kpi_target_list.jsp";
                document.frm.submit();
            }
			
			function cmdViewApproval(targetId){
                newWindow=window.open("view_approval.jsp?target_id="+targetId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
            }
        </script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
		<script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
                <link rel="stylesheet" href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css" >
                <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
		<link rel="stylesheet" href="../stylesheets/chosen.css" >
     </head>
    <body>
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
                    <table width="100%" bo
						   rder="0" cellspacing="0" cellpadding="0">
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
            <span id="menu_title">Daftar Target</span>
        </div>
            <form name="frm" method="post" action="">
                 <input type="hidden" name="command" value="<%= iCommand %>"> 
                <input type="hidden" name="targetId">
        <div class="box">
            <div id="box-title">Pencarian</div>
            <div id="box-content">
                <table>
                    <tr>
                        <td><strong>Judul</strong></td>
                        <td>
                            <input type="text" name="title" id="title" size="57" value="">
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Satuan Kerja</strong></td>
                        <td>
                            <select name="division_search" id="division_search" class="chosen-select">
                                <%
                                if (selectDiv){
                                    %>
                                    <option value="0">Select</option>
                                    <%
                                }
                                %>

                                <%
                                String whereDiv = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"=1";

                                if (appUserSess.getAdminStatus()==0){
                                    whereDiv += " AND "+ PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+"="+emplx.getDivisionId();
                                    selectDiv = false;
                                }
                                Vector divisionList = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                if (divisionList != null && divisionList.size()>0){
                                    for(int i=0; i<divisionList.size(); i++){
                                        Division divisi = (Division)divisionList.get(i);
                                        %>
                                        <option value="<%= divisi.getOID() %>"><%= divisi.getDivision() %></option>
                                        <%
                                    }
                                }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Tahun</strong></td>
                        <td>
                            <%= ControlCombo.draw("tahun", "chosen-select", null, "" + tahun, valTahun, keyTahun, "style='width : 30%'")%> 
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Status</strong></td>
                        <td>
                            <%
                                Vector val_status = new Vector(1, 1);
                                Vector key_status = new Vector(1, 1);

                                val_status.add("-1");
                                key_status.add("All");

                                val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_DRAFT));
                                key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);

                                val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED));
                                key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED]);
                                
                                val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_FINAL));
                                key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_FINAL]);

                                val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CANCELLED));
                                key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CANCELLED]);
                            %>
                            <%= ControlCombo.draw("status", "chosen-select", null, "" + status, val_status, key_status, "style='width : 30%'")%> 
                        </td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <div>
                    <a href="javascript:cmdSearch()" style="color:#FFF;" class="btn">Cari</a>   
                    <a href="javascript:cmdAdd()" style="color:#FFF;" class="btn">Tambah Baru</a>
                </div>
            </div>
        </div>
        <% if (listTarget.size()>0) {%>
        <div class="content-main">
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" colspan="7">Daftar Target KPI</td>
                    </tr>
                    <tr>
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">Tanggal Buat</td>
                        <td class="title_tbl">Tahun</td>
                        <td class="title_tbl">Satuan Kerja</td>
                        <td class="title_tbl">Judul</td>
						<td class="title_tbl">Status</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                    if (listTarget != null && listTarget.size()>0){
                        for (int i=0; i<listTarget.size(); i++){
                            KpiTarget kpiTarget = (KpiTarget)listTarget.get(i);
                            %>
                            <tr>
                                <td style="background-color: #FFF;"><%= (i+1) %></td>
                                <td style="background-color: #FFF;"><%= Formater.formatDate(kpiTarget.getCreateDate(), "yyyy-MM-dd") %></td>
                                <td style="background-color: #FFF;"><%= kpiTarget.getTahun() %></td>
                                <td style="background-color: #FFF;"><%= PstEmployee.getDivisionName(kpiTarget.getDivisionId()) %></td>
                                <td style="background-color: #FFF;"><%= kpiTarget.getTitle() %></td>
								<td style="background-color: #FFF;"><%= I_DocStatus.fieldDocumentStatus[kpiTarget.getStatusDoc()] %></td>
                                <td style="background-color: #FFF;">
                                   <a href="javascript:cmdEdit('<%=kpiTarget.getOID()%>')">Edit</a> || 
								   <a href="javascript:cmdViewApproval('<%=kpiTarget.getOID()%>')">View Approval</a>
                                </td>
                            </tr>
                            <%
                        }
                    }
                    %>
                    
                </table>
                    <% }%>
		<div>&nbsp;</div>
				
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
			'.chosen-select'           : {},
			'.chosen-select-deselect'  : {allow_single_deselect:true},
			'.chosen-select-no-single' : {disable_search_threshold:10},
			'.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
			'.chosen-select-width'     : {width:"100%"}
		}
		for (var selector in config) {
			$(selector).chosen(config[selector]);
		}
                
        
	</script>    
    </body>
</html>
