
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayGeneral"%>
<%
    /* 
     * Page Name  		:  department.jsp
     * Created on 		:  [date] [time] AM/PM 
     * 
     * @author  		: karya 
     * @version  		: 01 
     */

    /**
     * *****************************************************************
     * Page Description : [project description ... ] Imput Parameters : [input
     * parameter ...] Output : [output ...] 
 ******************************************************************
     */
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package HRIS -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DEPARTMENT);%>
<%@ include file = "../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%
    boolean isSecretaryLogin = (positionType >= PstPosition.LEVEL_SECRETARY) ? true : false;
    long hrdDepartmentOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepartmentOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    //update by satrya 2013-10-07
    //boolean isDirector = positionType == PstPosition.LEVEL_DIRECTOR ? true:false;
%>
<%!    public String drawList(Vector objectClass, long departmentId, I_Dictionary dictionaryD) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DEPARTMENT), "");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DIVISION), "");
        ctrlist.addHeader(dictionaryD.getWord("DESCRIPTION"), "");
        ctrlist.addHeader("Link To Department", "");
        ctrlist.addHeader("Valid Status", "");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Department department = (Department) objectClass.get(i);
            Vector rowx = new Vector();
            if (departmentId == department.getOID()) {
                index = i;
            }

            Division division = new Division();
            try {
                division = PstDivision.fetchExc(department.getDivisionId());
            } catch (Exception e) {
            }

            rowx.add(department.getDepartment());
            rowx.add(division.getDivision());
            rowx.add(department.getDescription());
            rowx.add(department.getJoinToDepartment() != null ? department.getJoinToDepartment() : "");
            rowx.add(department.getValidStatus());
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(department.getOID()));
        }

        //return ctrlist.drawList(index);

        return ctrlist.draw(index);
    }

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidDepartment = FRMQueryString.requestLong(request, "hidden_department_id");
//String departmentName = FRMQueryString.requestString(request,FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT]);
/*variable declaration*/
    int recordToGet = 50;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID];

    CtrlDepartment ctrlDepartment = new CtrlDepartment(request);
    ControlLine ctrLine = new ControlLine();
    Vector listDepartment = new Vector(1, 1);

    /*switch statement */
//update by satrya 2013-08-23
    int iComanTmp = 0;
    if (iCommand == Command.GET) {
        iCommand = Command.EDIT;
        iComanTmp = Command.GET;
    }
    iErrCode = ctrlDepartment.action(iCommand, oidDepartment);
    /* end switch*/
    FrmDepartment frmDepartment = ctrlDepartment.getForm();

    /*count list All Department*/
    long company_id = FRMQueryString.requestLong(request, "company_id");
    long companyIdHidden = FRMQueryString.requestLong(request, "hidden_companyId");
    String joinSQL = "";
    int vectSize = 0;

    if (company_id != 0) {
        joinSQL = " inner join " + PstDivision.TBL_HR_DIVISION + " on "
                + PstDivision.TBL_HR_DIVISION + "." + PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " = "
                + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID];
        whereClause = PstDivision.TBL_HR_DIVISION + "." + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " = " + company_id;
        vectSize = PstDepartment.getCount(joinSQL, whereClause);
    } else {
        vectSize = PstDepartment.getCount(whereClause);
    }




    Department department = ctrlDepartment.getDepartment();
    msgString = ctrlDepartment.getMessage();

    /*switch list Department*/
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
        start = PstDepartment.findLimitStart(department.getOID(), recordToGet, whereClause, orderClause);
        oidDepartment = department.getOID();
    }

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlDepartment.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */


    if (company_id != 0) {
        listDepartment = PstDepartment.listWithJointToDep(start, recordToGet, joinSQL, whereClause, orderClause);
    } else {
        listDepartment = PstDepartment.listWithJointToDep(start, recordToGet, whereClause, orderClause);
    }

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDepartment.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDepartment = PstDepartment.list(start, recordToGet, whereClause, orderClause);
    }

%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>HARISMA - Master Data Department</title>
        <%@ include file = "../main/konfigurasi_jquery.jsp" %>    
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
        <script language="JavaScript">

            function checkValueJoinDepartment(){
                var valcost = document.frmovertime.<%=FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_JOIN_TO_DEP_ID]%>.value;
                if(valcost==-1){
                    alert("Please select department, you have selected company name");
                }
                if(valcost==-2){
                    alert("Please select department, you have selected division name");
                }
            }

            function cmdUpdateDiv(){
                document.frmdepartment.command.value="<%=String.valueOf(Command.GET)%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            function cmdAdd(){
                document.frmdepartment.hidden_department_id.value="0";
                document.frmdepartment.command.value="<%=Command.ADD%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdAsk(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=Command.ASK%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdConfirmDelete(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=Command.DELETE%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            function cmdSave(){
                document.frmdepartment.command.value="<%=Command.SAVE%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdEdit(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=Command.EDIT%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdCancel(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=Command.EDIT%>";
                document.frmdepartment.prev_command.value="<%=prevCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdBack(){
                document.frmdepartment.command.value="<%=Command.BACK%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdListFirst(){
                document.frmdepartment.command.value="<%=Command.FIRST%>";
                document.frmdepartment.prev_command.value="<%=Command.FIRST%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdListPrev(){
                document.frmdepartment.command.value="<%=Command.PREV%>";
                document.frmdepartment.prev_command.value="<%=Command.PREV%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdListNext(){
                document.frmdepartment.command.value="<%=Command.NEXT%>";
                document.frmdepartment.prev_command.value="<%=Command.NEXT%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdListLast(){
                document.frmdepartment.command.value="<%=Command.LAST%>";
                document.frmdepartment.prev_command.value="<%=Command.LAST%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }

            function cmdValid(){
                window.open("set_all_valid.jsp?master=department", null, "height=550,width=500, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");  
            }

            function fnTrapKD(){
                //alert(event.keyCode);
                switch(event.keyCode) {
                    case <%=LIST_PREV%>:
                            cmdListPrev();
                        break;
                    case <%=LIST_NEXT%>:
                            cmdListNext();
                        break;
                    case <%=LIST_FIRST%>:
                            cmdListFirst();
                        break;
                    case <%=LIST_LAST%>:
                            cmdListLast();
                        break;
                    default:
                        break;
                    }
                }


                //-------------- script control line -------------------
                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                }

                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }

        </script>
        <!-- #EndEditable --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <SCRIPT language=JavaScript>
                    function cmdUpdateList(){
                        document.frmdepartment.command.value="<%=String.valueOf(Command.GOTO)%>";
                        document.frmdepartment.action="department.jsp";
                        document.frmdepartment.submit();
                    }
                    function hideObjectForEmployee(){    
                    } 
	 
                    function hideObjectForLockers(){ 
                    }
	
                    function hideObjectForCanteen(){
                    }
	
                    function hideObjectForClinic(){
                    }

                    function hideObjectForMasterdata(){
                    }

                    function cmdExportExcel(){
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        var valid_status_select = document.frmdepartment.valid_status_select.value;
                        var depart_name = document.frmdepartment.depart_name.value;
                        if (depart_name.length <= 0) { 
                            division_name = "0";
                        }
                        var linkPage = "<%=approot%>/masterdata/export_excel/export_excel_department.jsp?depart_name="+depart_name+"&valid_status_select="+ valid_status_select;    
                        var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                        newWin.focus();
                        xmlhttp.open("GET", linkPage, true);
                        xmlhttp.send();
                    }

        </SCRIPT>
        <script type="text/javascript">
                    function loadList(depart_name) {
                        valid_status_select = document.frmdepartment.valid_status_select.value;
                        if (depart_name.length == 0) { 
                            depart_name = "0";
                        } 
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        xmlhttp.open("GET", "department_ajax.jsp?depart_name=" + depart_name+"&valid_status_select="+ valid_status_select, true);
                        xmlhttp.send();
                
                    }
            
                    function prepare(){
                        loadList("0");
                    }
            
                    function cmdListFirst(start){         
                        var depart_name = document.frmdepartment.depart_name.value;
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        xmlhttp.open("GET", "department_ajax.jsp?depart_name="+depart_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.FIRST%> + "&start="+start, true);
                        xmlhttp.send();
                    }

                    function cmdListPrev(start){
                        var depart_name = document.frmdepartment.depart_name.value;
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        xmlhttp.open("GET", "department_ajax.jsp?depart_name="+depart_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.PREV%> + "&start="+start, true);
                        xmlhttp.send();
                    }

                    function cmdListNext(start){
                        var depart_name = document.frmdepartment.depart_name.value;
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        xmlhttp.open("GET", "department_ajax.jsp?depart_name="+depart_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.NEXT%> + "&start="+start, true);
                        xmlhttp.send();
                    }

                    function cmdListLast(start){
                        var depart_name = document.frmdepartment.depart_name.value;
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function() {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                            }
                        };
                        xmlhttp.open("GET", "department_ajax.jsp?depart_name="+depart_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.LAST%> + "&start="+start, true);
                        xmlhttp.send();
                    }
        </script>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
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
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script>
                    $(function() {
                        $( "#datepicker1" ).datepicker({ dateFormat: "yy-mm-dd" });
                        $( "#datepicker2" ).datepicker({ dateFormat: "yy-mm-dd" });
                    });
        </script>
        <!-- #EndEditable -->
    </head> 

    <body onload="prepare()">
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
            <span id="menu_title">Masterdata <strong style="color:#333;"> / </strong><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></span>
        </div>
        <div class="content-main">
            <form name="frmdepartment" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="hidden_department_id" value="<%=oidDepartment%>">
                <table>   
                    <tr>
                        <td></td>
                        <td><b>Searching Unit<b></td>
                                    <td><b>Valid Status<b></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <a class="btn" style="color:#FFF" href="javascript:cmdValid()">Set Valid Status</a>
                                                    </td>
                                                    <td>
                                                        <input type="text" style="padding:6px 7px" name="depart_name" onkeyup="loadList(this.value)" placeholder="Type unit name..." size="70" />
                                                    </td>
                                                    <td>
                                                        <select id="valid_status_select" name="valid_status_select" onkeyup="loadList('')" onchange="loadList('')" >
                                                            <option value="2">- All -</option>
                                                            <option selected value="<%=PstDepartment.VALID_ACTIVE%>"><%= PstDepartment.validStatusValue[PstDepartment.VALID_ACTIVE]%></option>
                                                            <option value="<%=PstDepartment.VALID_HISTORY%>"><%= PstDepartment.validStatusValue[PstDepartment.VALID_HISTORY]%></option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <a class="btn" style="color:#FFF" href="javascript:cmdExportExcel()">Export To Excel</a> 
                                                    </td>
                                                </tr>
                                                </table>
                                                <div>&nbsp;</div>
                                                <div id="div_respon"></div>
                                                <div>&nbsp;</div>

                                                <table border="0" cellspacing="0" cellpadding="0">
                                                    <tr valign="top"> 
                                                        <td  colspan="3"> 
                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                <%
                                                                    Vector comp_value = new Vector(1, 1);
                                                                    Vector comp_key = new Vector(1, 1);
                                                                    comp_value.add("0");
                                                                    comp_key.add("select ...");
                                                                    Vector listComp = PstCompany.list(0, 0, "", " COMPANY ");
                                                                    for (int i = 0; i < listComp.size(); i++) {
                                                                        Company comp = (Company) listComp.get(i);
                                                                        comp_key.add(comp.getCompany());
                                                                        comp_value.add(String.valueOf(comp.getOID()));
                                                                    }
                                                                %> 

                                                                <%
                            if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmDepartment.errorSize() < 1)) {
                                if (privAdd) {%>
                                                                <tr valign="top"> 
                                                                    <td>
                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                <td><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                <td valign="middle" colspan="3" width="951"> 
                                                                                    <a href="javascript:cmdAdd()" class="command">Add New </a> </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%}
                            }%>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                        <td valign="middle" colspan="3"> 
                                                            <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmDepartment.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                                                            <table border="0" cellspacing="2" cellpadding="2">
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellspacing="2" cellpadding="2">
                                                                            <tr valign="top">
                                                                                <td valign="top">&nbsp;</td>
                                                                                <td class="comment">*)entry required </td>
                                                                            </tr>
                                                                            <tr valign="top">
                                                                                <td valign="top">
                                                                                    <%=dictionaryD.getWord(I_Dictionary.DIVISION)%></td>
                                                                                <td>
                                                                                    <!-- update by satrya 2013-08-23-->
                                                                                    <%
                                                                                        comp_value = new Vector(1, 1);
                                                                                        comp_key = new Vector(1, 1);
                                                                                        String whereCompany = "";
                                                                                        if (!(isHRDLogin || isEdpLogin || isGeneralManager || isDirector)) {
                                                                                            whereCompany = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] + "='" + emplx.getCompanyId() + "'";
                                                                                        } else {
                                                                                            comp_value.add("0");
                                                                                            comp_key.add("select ...");
                                                                                        }
                                                                                    //long companyId=0;
                                                                                        if (!(iComanTmp == Command.GET) && department.getDivisionId() != 0) {
                                                                                            companyIdHidden = PstDivision.getOidCompany(PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + department.getDivisionId(), "");
                                                                                        }
                                                                                        listComp = PstCompany.list(0, 0, whereCompany, " COMPANY ");
                                                                                        for (int i = 0; i < listComp.size(); i++) {
                                                                                            Company comp = (Company) listComp.get(i);
                                                                                            if (companyIdHidden == 0) {
                                                                                                companyIdHidden = comp.getOID();
                                                                                            }
                                                                                            comp_key.add(comp.getCompany());
                                                                                            comp_value.add(String.valueOf(comp.getOID()));
                                                                                        }
                                                                                    %> <%= ControlCombo.draw("hidden_companyId", "formElemen", null, "" + companyIdHidden, comp_value, comp_key, "onChange=\"javascript:cmdUpdateDiv()\"")%>

                                                                                    <%
                                                                                        String whereClauseComp = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + "=" + companyIdHidden;
                                                                                        /*if(companyIdHidden!=0){
                                                                                         whereClauseComp= PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+"="+companyIdHidden;
                                                                                         }*/
                                                                                        Vector divKey = new Vector(1, 1);
                                                                                        Vector divValue = new Vector(1, 1);
                                                                                        Vector listDiv = PstDivision.list(0, 0, whereClauseComp, "DIVISION");
                                                                                        for (int i = 0; i < listDiv.size(); i++) {
                                                                                            Division division = (Division) listDiv.get(i);
                                                                                            divKey.add(division.getDivision());
                                                                                            divValue.add("" + division.getOID());
                                                                                        }
                                                                                        String attTag = "data-placeholder=\"Choose a Department...\"";
                                                                                    %>
                                                                                    <%=ControlCombo.draw(frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DIVISION_ID], "chosen-select", null, "" + department.getDivisionId(), divKey, divValue, null, attTag)%>
                                                                                    * <%=frmDepartment.getErrorMsg(frmDepartment.FRM_FIELD_DIVISION_ID)%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr valign="top">
                                                                                <td valign="top">
                                                                                    <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></td>
                                                                                <td>
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT]%>"  value="<%= department.getDepartment()%>" class="elemenForm" size="57">
                                                                                    * <%=frmDepartment.getErrorMsg(FrmDepartment.FRM_FIELD_DEPARTMENT)%></td>
                                                                            </tr>
                                                                            <tr valign="top">
                                                                                <td valign="top">
                                                                                    <%=dictionaryD.getWord("DESCRIPTION")%></td>
                                                                                <td>
                                                                                    <textarea name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DESCRIPTION]%>" class="elemenForm" cols="30" rows="3"><%= department.getDescription()%></textarea>
                                                                                </td>
                                                                            </tr>
                                                                            <tr valign="top">
                                                                                <td valign="top">
                                                                                    HOD Join to <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></td>
                                                                                <td>
                                                                                    <%
                                                                                        Vector joinDep_value = new Vector(1, 1);
                                                                                        Vector joinDep_key = new Vector(1, 1);
                                                                                        joinDep_value.add("0");
                                                                                        joinDep_key.add("select ...");
                                                                                        String strWhereDept = "";
                                                                                        Vector listCostDept = PstDepartment.listWithCompanyDiv(0, 0, strWhereDept);
                                                                                        String prevCompany = "";
                                                                                        String prevDivision = "";
                                                                                        for (int i = 0; i < listCostDept.size(); i++) {
                                                                                            Department dept = (Department) listCostDept.get(i);
                                                                                            if (prevCompany.equals(dept.getCompany())) {
                                                                                                if (prevDivision.equals(dept.getDivision())) {
                                                                                                    joinDep_key.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept.getDepartment());
                                                                                                    joinDep_value.add(String.valueOf(dept.getOID()));
                                                                                                } else {
                                                                                                    joinDep_key.add("&nbsp;-" + dept.getDivision() + "-");
                                                                                                    joinDep_value.add("-2");
                                                                                                    joinDep_key.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept.getDepartment());
                                                                                                    joinDep_value.add(String.valueOf(dept.getOID()));
                                                                                                    prevDivision = dept.getDivision();
                                                                                                }
                                                                                            } else {
                                                                                                joinDep_key.add("-" + dept.getCompany() + "-");
                                                                                                joinDep_value.add("-1");
                                                                                                joinDep_key.add("&nbsp;-" + dept.getDivision() + "-");
                                                                                                joinDep_value.add("-2");
                                                                                                joinDep_key.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept.getDepartment());
                                                                                                joinDep_value.add(String.valueOf(dept.getOID()));
                                                                                                prevCompany = dept.getCompany();
                                                                                                prevDivision = dept.getDivision();
                                                                                            }
                                                                                        }


                                                                                    %> <%= ControlCombo.draw(FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_JOIN_TO_DEP_ID], "formElemen", null, ""
                              + department.getJoinToDepartmentId(), joinDep_value, joinDep_key,
                              "onChange=\"javascript:checkValueJoinDepartment()\"")%>
                                                                                </td>
                                                                            </tr>

                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Department Type Id
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <select name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT_TYPE_ID]%>">
                                                                                        <option value="0">-select-</option>
                                                                                        <%
                                                                                            Vector listDepartmentType = PstDepartmentType.list(0, 0, "", "");
                                                                                            if (listDepartmentType != null && listDepartmentType.size() > 0) {
                                                                                                for (int ldt = 0; ldt < listDepartmentType.size(); ldt++) {
                                                                                                    DepartmentType depT = (DepartmentType) listDepartmentType.get(ldt);
                                                                                                    if (department.getDepartmentTypeId() == depT.getOID()) {
                                                                                        %>
                                                                                        <option selected="selected" value="<%=depT.getOID()%>"><%=depT.getTypeName()%></option>
                                                                                        <%
                                                                                        } else {
                                                                                        %>
                                                                                        <option value="<%=depT.getOID()%>"><%=depT.getTypeName()%></option>
                                                                                        <%
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        %>

                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">Level Unit</td>
                                                                                <td valign="middle">
                                                                                    <select name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_LEVEL_DEPARTMENT]%>">
                                                                                        <%
                                                                                        for(int x = 0 ; x < PstDepartment.departmentLevel.length ; x++){
                                                                                            if (department.getLevelDepartment()== x) {
                                                                                        %>
                                                                                            <option value="<%=x%>" selected="selected"><%=PstDepartment.departmentLevelName[x]%></option>
                                                                                        <%
                                                                                            } else {
                                                                                        %>
                                                                                            <option value="<%=x%>" ><%=PstDepartment.departmentLevelName[x]%></option>
                                                                                        <%
                                                                                            }
                                                                                        }   
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">Valid Status</td>
                                                                                <td valign="middle">
                                                                                    <select name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_VALID_STATUS]%>">
                                                                                        <%
                                                                                            if (department.getValidStatus() == PstDepartment.VALID_ACTIVE) {
                                                                                        %>
                                                                                        <option value="<%=PstDepartment.VALID_ACTIVE%>" selected="selected">Active</option>
                                                                                        <option value="<%=PstDepartment.VALID_HISTORY%>">History</option>
                                                                                        <%
                                                                                        } else {
                                                                                        %>
                                                                                        <option value="<%=PstDepartment.VALID_ACTIVE%>">Active</option>
                                                                                        <option value="<%=PstDepartment.VALID_HISTORY%>" selected="selected">History</option>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="top">Masa berlaku</td>
                                                                                <td valign="top">
                                                                                    <%
                                                                                        String DATE_FORMAT_NOW = "yyyy-MM-dd";
                                                                                        Date dateStart = department.getValidStart() == null ? new Date() : department.getValidStart();
                                                                                        Date dateEnd = department.getValidEnd() == null ? new Date() : department.getValidEnd();
                                                                                        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
                                                                                        String strValidStart = sdf.format(dateStart);
                                                                                        String strValidEnd = sdf.format(dateEnd);
                                                                                    %>
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[frmDepartment.FRM_FIELD_VALID_START]%>" id="datepicker1" value="<%=strValidStart%>" />&nbsp;to
                                                                                    &nbsp;<input type="text" name="<%=frmDepartment.fieldNames[frmDepartment.FRM_FIELD_VALID_END]%>" id="datepicker2" value="<%=strValidEnd%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <div class="note">
                                                                                        <strong>note:</strong> fill some of field below, if you choose Branch of Company
                                                                                    </div>
                                                                                </td>
                                                                            </tr>

                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Address
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_ADDRESS]%>" size="50" value="<%=department.getAddress()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    City
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_CITY]%>" size="50" value="<%=department.getCity()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    NPWP
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_NPWP]%>" size="50" value="<%=department.getNpwp()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Province
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_PROVINCE]%>" size="50" value="<%=department.getProvince()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Region
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_REGION]%>" size="50" value="<%=department.getRegion()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Sub Region
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_SUB_REGION]%>" size="50" value="<%=department.getSubRegion()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Village
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_VILLAGE]%>" size="50" value="<%=department.getVillage()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Area
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_AREA]%>" size="50" value="<%=department.getArea()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Telephone
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_TELEPHONE]%>" size="50" value="<%=department.getTelphone()%>" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle">
                                                                                    Fax Number
                                                                                </td>
                                                                                <td valign="middle">
                                                                                    <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_FAX_NUMBER]%>" size="50" value="<%=department.getFaxNumber()%>" />
                                                                                </td>
                                                                            </tr>



                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <tr valign="top" > 
                                                                    <td class="command"> 
                                                                        <%
                                                                            ctrLine.setLocationImg(approot + "/images");
                                                                            ctrLine.initDefault();
                                                                            ctrLine.setTableWidth("80%");
                                                                            String scomDel = "javascript:cmdAsk('" + oidDepartment + "')";
                                                                            String sconDelCom = "javascript:cmdConfirmDelete('" + oidDepartment + "')";
                                                                            String scancel = "javascript:cmdEdit('" + oidDepartment + "')";
                                                                            ctrLine.setBackCaption("Back to List");
                                                                            ctrLine.setCommandStyle("buttonlink");
                                                                            ctrLine.setBackCaption("Back to List");
                                                                            ctrLine.setSaveCaption("Save ");
                                                                            ctrLine.setConfirmDelCaption("Yes Delete");
                                                                            ctrLine.setDeleteCaption("Delete");

                                                                            if (privDelete) {
                                                                                ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                ctrLine.setDeleteCommand(scomDel);
                                                                                ctrLine.setEditCommand(scancel);
                                                                            } else {
                                                                                ctrLine.setConfirmDelCaption("");
                                                                                ctrLine.setDeleteCaption("");
                                                                                ctrLine.setEditCaption("");
                                                                            }

                                                                            if (privAdd == false && privUpdate == false) {
                                                                                ctrLine.setSaveCaption("");
                                                                            }

                                                                            if (privAdd == false) {
                                                                                ctrLine.setAddCaption("");
                                                                            }

                                                                            if (iCommand == Command.ASK) {
                                                                                ctrLine.setDeleteQuestion(msgString);
                                                                            }
                                                                        %>
                                                                        <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%}%>
                                                        </td>
                                                    </tr>
                                                </table>
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