<%-- 
    Document   : kpi_setting_target
    Created on : Oct 12, 2022, 2:47:43 PM
    Author     : User
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetailEmployee"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetail"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSetting"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);

    int iCommand = FRMQueryString.requestCommand(request);
    String urlBack = FRMQueryString.requestString(request, "urlBack");
    
    KpiSetting entKpiSetting = new KpiSetting();
    KpiSettingList entKpiSettingList = new KpiSettingList();
    KpiSettingGroup entKpiSettingGroup = new KpiSettingGroup();
    KPI_List entKpiList = new KPI_List();
    KPI_Group entKpiGroup = new KPI_Group();
    if(oidKpiSettingList > 0){
        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
        entKpiSettingGroup = PstKpiSettingGroup.fetchExc(entKpiSettingList.getKpiSettingGroupId());
        entKpiSetting = PstKpiSetting.fetchExc(entKpiSettingList.getKpiSettingId());
        entKpiList = PstKPI_List.fetchExc(entKpiSettingList.getKpiListId());
        entKpiGroup = PstKPI_Group.fetchExc(entKpiSettingGroup.getKpiGroupId());
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING TARGET</title>  
        
        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">

        <link rel="stylesheet" href="../../../../styles/main.css" type="text/css">

        <!--end-->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>

        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <link href="../../styles/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">

        <!--bootsrtrap untuk menu pop up-->
        <link href="../../styles/bootstrap 5.0/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <script src="../../styles/bootstrap 5.0/js/bootstrap.bundle.js" type="text/javascript"></script>

        <!--end-->
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
                    <%@include file="../../styletemplate/template_header.jsp" %>
                <%} else {%>
                    <tr> 
                        <td ID="TOPTITLE" style="background:<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
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
                                    <td align="center" style="background:<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                                    <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                <%}%>
            </table>
        </div>
            
        <div id="menu_utama">
            <span id="menu_title">KPI Setting Detail / KPI Setting Target</span>
        </div>
            
        <div class="content-main">
        <a href="javascript:cmdBack();" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
            <div class="formstyle" style="margin-top: 1rem;">
                <!--judul ini merupakan judul dari KPI-->
                <span><%= entKpiList.getKpi_title() %></span>
                <hr>
                <table>
                    <tr>
                        <td>
                            <br><div style="font-size: 12px;">Perusahaan:<%=PstCompany.getCompanyName(entKpiSetting.getCompanyId())%></div>
                            <br><div style="font-size: 12px;">Jabatan        :
                                <%
                                    Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(entKpiSetting.getOID());
                                    for (int i = 0; i < vListPosisi.size(); i++) {
                                        Position objPosisi = (Position) vListPosisi.get(i);
                                %>
                                <%=objPosisi.getPosition()%>,
                                <%
                                    }
                                %>
                            </div>
                            <br><div style="font-size: 12px;">Status         :<%= I_DocStatus.fieldDocumentStatus[entKpiSetting.getStatus()]%></div>
                            <br><div style="font-size: 12px;">Tanggal Mulai  :<%= entKpiSetting.getStartDate()%></div>
                            <br><div style="font-size: 12px;">Tanggal Selesai:<%= entKpiSetting.getValidDate()%></div>
                            <br><div style="font-size: 12px;">KPI Group      :<%= entKpiGroup.getGroup_title() %></div>
                            <br><div style="font-size: 12px;">Tahun          :<%= entKpiSetting.getTahun()%></div>
                        </td>
                    </tr>
                </table>
            </div>

            <div style="display: flex; justify-content: space-between; margin-top: 2rem;">
                <span style="font-size: 15px"><strong>KPI Target Per Satuan Kerja</strong></span>
                <form action="kpi_setting_target_form.jsp" method="POST">
                    <input type="hidden" name="<%= FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID] %>" value="<%= entKpiSettingList.getOID() %>">
                    <button type="submit" style="color:#fff; border: none;" class="btn-add btn-add1">Tambah Data Target <i class="fa fa-plus"></i></a>
                </form>
                <!--<a href="" style="color:#fff;" class="btn-copy btn-copy1">Salin Data Target Sebelumnya <strong><i class="fa fa-copy"></i></strong></a>-->
            </div>
            <div class="formstyle" style="margin-bottom: 1rem;">
                <table class="tblStyle" style="width:100%">
                    <tr>
                        <td class="title_tbl">No.</td>
                        <td class="title_tbl">Divisi</td>
                        <td class="title_tbl">Departemen</td>
                        <td class="title_tbl">Section</td>
                        <td class="title_tbl">Tahun</td>
                        <td class="title_tbl">Periode</td>
                        <td class="title_tbl" width="5%">Target(<%= PstKPI_List.strType[entKpiList.getInputType()] %>)</td>
                        <td class="title_tbl">Status</td>
                        <!--<td class="title_tbl //" class="text-center">Action</td>-->
                    </tr>
                    <%
                        Vector vKpiTargetDetail = PstKpiTargetDetail.list(0, 0, PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_SETTING_LIST_ID] + " = " + oidKpiSettingList, "");
                        for(int i = 0; i < vKpiTargetDetail.size(); i++){
                            KpiTargetDetail entKpiTargetDetail = (KpiTargetDetail) vKpiTargetDetail.get(i);
                            KpiTarget entKpiTarget = PstKpiTarget.fetchExc(entKpiTargetDetail.getKpiTargetId());
                            Department entDepartment = new Department();
                            Section entSection= new Section();
                            if(entKpiTarget.getDepartmentId() > 0){
                                  entDepartment = PstDepartment.fetchExc(entKpiTarget.getDepartmentId());
                            }
                            if(entKpiTarget.getSectionId() > 0){
                                entSection = PstSection.fetchExc(entKpiTarget.getSectionId());
                            }
                    %>
                        <tr>
                            <td><%= i+1 %></td>
                            <td><%= PstDivision.fetchExc(entKpiTarget.getDivisionId()).getDivision() %></td>
                            <td><%= entDepartment.getDepartment()%></td>
                            <td><%= entSection.getSection() %></td>
                            <td><%= entKpiTarget.getTahun() %></td>
                            <td><%= PstKpiTargetDetail.period[entKpiTargetDetail.getPeriod()] %></td>
                            <td>
                                <span style="cursor: pointer; color: blue;" id="target-<%=entKpiTargetDetail.getOID()%>" class="target">
                                    <%= Math.round(entKpiTargetDetail.getAmount()) %>
                                </span>
                                <input type="number" 
                                       id="inputtarget-<%=entKpiTargetDetail.getOID()%>" 
                                       class="input-target" 
                                       style="display: none; width: 6rem;" 
                                       value="<%= Math.round(entKpiTargetDetail.getAmount()) %>"
                                       />
                            </td>
                            <td><%= I_DocStatus.fieldDocumentStatus[entKpiTarget.getStatusDoc()] %></td>
                            <!--<td class="text-center">
                                Edit 
                                || 
                                Delete
                            </td>-->
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="9">
                                <table class="tblStyle" style="width:100%">
                                    <tr>
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NIK</td>
                                        <td class="title_tbl">Nama</td>
                                        <td class="title_tbl" width="10%">Bobot Distribusi</td>
                                        <!--<td class="title_tbl">Action</td>-->
                                    </tr>
                                    <%
                                        Vector vKpiTargetDetailEmploye = PstKpiTargetDetailEmployee.list(0, 0, PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID] + " = " + entKpiTargetDetail.getOID(), "");
                                        for(int j = 0; j < vKpiTargetDetailEmploye.size(); j++){
                                            KpiTargetDetailEmployee entKpiTargetDetailEmploye = (KpiTargetDetailEmployee) vKpiTargetDetailEmploye.get(j);
                                            Employee entEmploye = PstEmployee.getNumAndFullname(entKpiTargetDetailEmploye.getEmployeeId());
                                    %>
                                        <tr>
                                            <td><%= j+1 %></td>
                                            <td><%= entEmploye.getEmployeeNum() %></td>
                                            <td><%= entEmploye.getFullName()%></td>
                                            <td>
                                                <span style="cursor: pointer; color: blue;" id="bobot-<%=entKpiTargetDetailEmploye.getOID()%>" class="bobot">
                                                    <%= Math.round(entKpiTargetDetailEmploye.getBobot()) %>
                                                </span>
                                                <input type="number" 
                                                       id="inputbobot-<%=entKpiTargetDetailEmploye.getOID()%>" 
                                                       class="input-bobot" 
                                                       style="display: none; width: 6rem;" 
                                                       value="<%= Math.round(entKpiTargetDetailEmploye.getBobot()) %>"
                                                       />
                                            </td>
                                            <!--<td><center>Edit || De //lete</center></td>-->
                                        </tr>
                                    <% } %>
                                </table>
                            </td>
                        </tr>
                    <% } %>
                </table>
            </div>
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

        <script src="../../javascripts/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script type="text/javascript">
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': {allow_single_deselect: true},
                '.chosen-select-no-single': {disable_search_tdreshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, notding found!'},
                '.chosen-select-widtd': {widtd: "100%"}
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
        <script type="text/javascript">
            function cmdEdit(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdAdd(oidKpiSetting) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oidKpiSetting;
                document.frm.command.value = "<%= Command.ADD%>";
                document.frm.action = "kpi_setting_target_form.jsp";
                document.frm.submit();
            }

            function cmdDelete(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.DELETE%>";
                document.frm.action = "kpi_setting_list.jsp";
                document.frm.submit();
            }

            /*untuk tombol back yang dimana kondisi khususnya, memiliki 1 jsp, tapi jsp tersebut bisa di akses dari beberapa jsp lain*/
            <%if (urlBack.equals("kpi_setting_list_detail.jsp")) {%>
            function cmdBack() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%= entKpiSetting.getOID() %>";
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_list_detail.jsp";
                document.frm.submit();
            }
            <%} else {%>
            function cmdBack() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%= entKpiSetting.getOID() %>";
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            <%}%>
            
            $("body").on("click", ".target", function(){
                const targetOID = $(this).attr("id").split("-")[1];
                $("#inputtarget-"+targetOID).show().focus().select();
                $(this).hide();
            });
            $("body").on("focusout", ".input-target", function(){
                const targetOID = $(this).attr("id").split("-")[1];
                const value = $(this).val();
                if(value != ""){
                    const data = {
                        <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID]%> : targetOID,
                        <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]%> : value,
                        isTarget: true
                    }
                    $.ajax({
                        url: "<%=approot%>/AjaxUpdateTargetAmount",
                        type: 'POST',
                        data: data,
                        success: function() {
                            $("#target-"+targetOID).text(value);
                        },
                        error: function(){
                            alert("Terjadi kesalahan pada server.");
                        }
                    });
                }
                $("#target-"+targetOID).show();
                $(this).hide();
            });
            
            $("body").on("click", ".bobot", function(){
                const OID = $(this).attr("id").split("-")[1];
                $("#inputbobot-"+OID).show().focus().select();
                $(this).hide();
            });
            $("body").on("focusout", ".input-bobot", function(){
                const OID = $(this).attr("id").split("-")[1];
                const value = $(this).val();
                if(value != ""){
                    const data = {
                        <%=FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID]%> : OID,
                        <%=FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_BOBOT]%> : value,
                        isTarget : false
                    }
                    $.ajax({
                        url: "<%=approot%>/AjaxUpdateTargetAmount",
                        type: 'POST',
                        data: data,
                        success: function() {
                            $("#bobot-"+OID).text(value);
                        },
                        error: function(){
                            alert("Terjadi kesalahan pada server.");
                        }
                    });
                }
                $("#bobot-"+OID).show();
                $(this).hide();
            });
        </script>
    </body>
</html>
