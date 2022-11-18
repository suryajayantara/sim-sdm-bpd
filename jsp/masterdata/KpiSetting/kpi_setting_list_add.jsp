<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


<%@page import="com.dimata.harisma.form.masterdata.FrmKpiDistribution"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKPI_Group"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Group"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKPI_List"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingType"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingType"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPosition"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPosition"%>
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
    long oidKpiGroup = FRMQueryString.requestLong(request, FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_GROUP_ID]);

    Vector vKpiList = new Vector();
    Vector vKpiGroup = new Vector();
    String groupName = "";
    try {
        if (oidKpiGroup != 0) {
            // untuk mengambil data KPI List berdasarkan KPI grup
            String query = "hr_kpi_group.`KPI_GROUP_ID` = '" + oidKpiGroup + "'";
            vKpiList = PstKPI_List.listWithJoinGroup(query);
            
            // untuk mengambil data KPI grup
            String queryForGroup = "KPI_GROUP_ID = '"+ oidKpiGroup +"'";
            vKpiGroup = PstKPI_Group.list(0, 1, queryForGroup, "");
            for(int i = 0; i < vKpiGroup.size(); i++){
                KPI_Group objKpiGroup = (KPI_Group) vKpiGroup.get(i);
                groupName = objKpiGroup.getGroup_title();
            }
        }
    } catch (Exception e) {
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING LIST ADD</title>


        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">

        <!--css tanggal-->
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <!--end-->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <link href="../../styles/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">

        <!--bootsrtrap untuk menu pop up-->
        <link href="../../styles/bootstrap 5.0/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <script href="../../styles/bootstrap 5.0/js/bootstrap.bundle.js" type="text/javascript"></script>

        <!--end-->
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >

        <script language="JavaScript">

            function pageLoad() {
                $(".mydate").datepicker({dateFormat: "yy-mm-dd"});
            }

//            function cmdUpdateDivision() {
//                document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
//                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
//                document.FRM_NAME_KPISETTING.submit();
//            }
            function cmdUpdateSec() {
                document.FRM_NAME_KPISETTING.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }

            function cmdCancel() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.oidKpiSetting.value = 0;
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdBack() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdEditDetail(oid) {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.oidKpiSetting.value = oid;
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdAdd() {
                document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }


            function cmdSave() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }


            function cmdSaveKpi() {
                document.FRM_NAME_KPI.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPI.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPI.submit();
            }

            function cmdEdit(oid) {
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%= Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_target.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            var popup;
            function init() {
                onload = "init()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("kpi_distribution.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            function masterKpiGroup() {
                onload = "masterKpiGroup()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_group.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            function masterKpi() {
                onload = "masterKpi()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_list.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }

        </script>
    </head>
    <body onload="prepare()" >
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

        <!--data ini akan muncul ketika user klik detail pada kpi setting list-->

        <div class="box">
            <form name="FRM_NAME_KPISETTING" method ="post" action="">
                <input type="hidden" name="command" value="">
                <input type="hidden" name="urlBack" value="kpi_setting_list_detail.jsp">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
                <div class="content-main">
                    <div>&nbsp;</div>
                    <!--data ini akan muncul ketika user klik detail pada kpi setting list-->
                    <span> <%= groupName %></span>
                    <div style="border-bottom: 1px solid #DDD;">&nbsp;</div>
                    <div class="item mt-3 mb-3">
                        <table>
                            <%
                                for (int i = 0; i < vKpiList.size(); i++) {
                                    KPI_List objKpiList = (KPI_List) vKpiList.get(i);
                            %>
                            <tr>
                                <td>
                                    <input type="checkbox" id="myCheck" name="KPI_ID" value="" checked>&nbsp;
                                </td>
                                <td>
                                    <div><strong><%= objKpiList.getKpi_title() %></strong></div>
                                </td>
                            </tr>
                            <% } %>
                        </table>
                    </div>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <div style="text-align: right; padding: 9px 15px;">
                        <button class="btn" style="color:#FFF" onclick="window.history.go(-1)">Back</button>
                        <a class="btn" style="color:#FFF" href="javascript:check()">Check All</a>
                        <a class="btn" style="color:#FFF" href="javascript:uncheck()">Uncheck All</a>
                        <a class="btn" style="color:#FFF" href="javascript:cmdGet()">Get Data</a>
                    </div>  
                    <!--Tampilan form setelah input data kpi type-->
                </div>  
            </form>
        </div>


        <script src="../../javascripts/jquery.min.js" type="text/javascript"></script>
        <script src="../../styles/select2/js/select2.full.min.js" type="text/javascript"></script>
        <script src="../../javascripts/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script language="JavaScript">
            //var oBody = document.body;
            //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
            $(document).ready(function(){
              $('[data-toggle="popover"]').popover();
            });
            $(function () {
                //Initialize Select2 Elements
                $('.select2').select2()

            //Initialize Select2 Elements

            $('.select2bs4').select2({
                theme: 'bootstrap4'
            })
        </script>
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
        <script>
            $(function () {
                $('#only-number').on('keydown', '#number', function (e) {
                    -1 !== $
                            .inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) || /65|67|86|88/
                            .test(e.keyCode) && (!0 === e.ctrlKey || !0 === e.metaKey)
                            || 35 <= e.keyCode && 40 >= e.keyCode || (e.shiftKey || 48 > e.keyCode || 57 < e.keyCode)
                            && (96 > e.keyCode || 105 < e.keyCode) && e.preventDefault()
                });
            })

            function check() {
                checkboxes = document.getElementsByName('KPI_ID');  
                for(var i = 0; i < checkboxes.length; i++){  
                    if(checkboxes[i].type=='checkbox')  
                        checkboxes[i].checked = true;  
                }
            }
            
            function uncheck() {
                checkboxes = document.getElementsByName('KPI_ID');  
                for(var i = 0; i < checkboxes.length; i++){  
                    if(checkboxes[i].type=='checkbox')  
                        checkboxes[i].checked = false;  
                }
            }

            function cmdGet(){
                document.frm.action="kpi_emp_search.jsp";
                document.frm.submit();
            }
        </script>
        <script>
            function cmdSaveKpiSettingGroup() {
                document.FRM_NAME_KPISETTINGGROUP.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGGROUP.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGGROUP.submit();
            }
            function cmdSaveKpiSettingList() {
                //document.FRM_NAME_KPISETTINGLIST.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLIST.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGLIST.submit();
            }
            function cmdDeleteGroup(oid) {
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_ID]%>.value=oid;
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.DELETE %>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
        </script>

</html>
