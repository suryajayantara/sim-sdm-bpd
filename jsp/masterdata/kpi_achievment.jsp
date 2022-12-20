<%@page import="com.dimata.harisma.entity.attendance.I_Atendance"%>
<%
            /*
             * Page Name  		:  kpi achievment.jsp
             * Created on 		:  [date] [time] AM/PM
             *
             * @author  		: Priska_20150917
             * @version  		: -
             */

            /*******************************************************************
             * Page Description 	: [project description ... ]
             * Imput Parameters 	: [input parameter ...]
             * Output 			: [output ...]
             *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_PERFORMANCE, AppObjInfo.OBJ_KPI_COMPANY_TARGET);%>
<%@ include file = "../main/checkuser.jsp" %>
<%!
	public String[] alphanumeric = {
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
		"m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
		"y", "z"
	};
%>
<%!    public String drawList(Vector objectClass, long empId) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("80%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader("No ","5%");
        ctrlist.addHeader("Company","20%");
        ctrlist.addHeader("KPI Title","20%");
        ctrlist.addHeader("Description","30%");
        ctrlist.addHeader("Valid from","10%");
        ctrlist.addHeader("Valid to","10%");
        ctrlist.addHeader("Value Type","5%");
        ctrlist.addHeader("TARGET","5%");
        ctrlist.addHeader("ACHIEVMENT SCORE","5%");
        ctrlist.addHeader("PERBEDAAN","5%");
        ctrlist.addHeader("Add Achievment","5%");
        // ctrlist.addHeader("List Group","30%");

        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.reset();
        int index = -1;

        //kpi_list
                    Vector listComp = PstCompany.list(0, 0, "", " COMPANY ");
                   
                    Hashtable<String, String> compNames = new Hashtable();
                    for (int c = 0; c < listComp.size(); c++) {
                        Company comp = (Company) listComp.get(c);
                        compNames.put(""+comp.getOID(), comp.getCompany());                       
                    }
        
        for (int i = 0; i < objectClass.size(); i++) {
            KPI_List kpi_list = (KPI_List) objectClass.get(i);
            Vector rowx = new Vector();
            rowx.add(""+(i+1));
            rowx.add(""+compNames.get(""+kpi_list.getCompany_id()));
            rowx.add(""+kpi_list.getKpi_title());
            rowx.add(""+kpi_list.getDescription());
            rowx.add(""+kpi_list.getValid_from());
            rowx.add(""+kpi_list.getValid_to());
            rowx.add(""+kpi_list.getValue_type());
            
            double totalTarget = PstKPI_Employee_Target.getTotalTargetEmployee(empId, kpi_list.getOID());//mencari total target
            double totalAchievment = PstKPI_Employee_Achiev.getTotalAchievEmployee(empId, kpi_list.getOID());//mencari total achievment
            
            rowx.add(""+totalTarget);
            rowx.add(""+totalAchievment);
            rowx.add(""+(Math.abs(totalTarget-totalAchievment)));
            rowx.add("<a href=\"javascript:cmdAddAchievment('"+empId+"','"+kpi_list.getOID()+"')\">Add Achievment</a>");
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(kpi_list.getOID()));
        }
        return ctrlist.draw(index);
    }

%>

<%
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidKPI_Employee_Achiev = FRMQueryString.requestLong(request, "hidden_kPI_Employee_Achiev_id");

      
            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CtrlKPI_Employee_Achiev ctrlKPI_Employee_Achiev = new CtrlKPI_Employee_Achiev(request);
            ControlLine ctrLine = new ControlLine();
            Vector listKPI_Employee_Achiev = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlKPI_Employee_Achiev.action(iCommand, oidKPI_Employee_Achiev);
            /* end switch*/
            FrmKPI_Employee_Achiev frmKPI_Employee_Achiev = ctrlKPI_Employee_Achiev.getForm();

            
            KPI_Employee_Achiev kPI_Employee_Achiev = ctrlKPI_Employee_Achiev.getdKPI_Employee_Achiev();
            msgString = ctrlKPI_Employee_Achiev.getMessage();
            //long empId = 504404524286105253L;
            long empId = emplx.getOID();
//            String whereEmployeeID = " hket."+ PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_EMPLOYEE_ID] + " = " + empId ;
	    String whereEmployeeID =  PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_EMPLOYEE_ID] + " = " + empId ;
            Vector listKpiTarget = PstKpiTargetDetailEmployee.list(0, 0, whereEmployeeID, "") ; 

%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Performance Management Input Realisasi</title>
        <script language="JavaScript">

function cmdAddAchievment(oidEmp,kpiListId,targetId){
        window.open("kpi_achievment_add.jsp?oidEmp="+oidEmp+"&kpiListId="+kpiListId+"&targetId="+targetId, null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}

            function cmdAdd(){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value="0";
                document.frmkPI_Employee_Achiev.command.value="<%=Command.ADD%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdAsk(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.ASK%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdConfirmDelete(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.DELETE%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }
            function cmdSave(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.SAVE%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdEdit(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.EDIT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdCancel(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.EDIT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdBack(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.BACK%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListFirst(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.FIRST%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.FIRST%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListPrev(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.PREV%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.PREV%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListNext(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.NEXT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.NEXT%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListLast(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.LAST%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.LAST%>";
                document.frmkPI_Employee_Achiev.action="kPI_Employee_Achiev.jsp";
                document.frmkPI_Employee_Achiev.submit();
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

        </SCRIPT>
        <!-- #EndEditable -->
    </head>

    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
             <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%@include file="../styletemplate/template_header.jsp" %>
            <%}else{%>
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
            <tr>
                <td width="88%" valign="top" align="left">
                    <table width="100%" border="0" cellspacing="3" cellpadding="2">
                        <tr>
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="20">
                                            <font color="#FF6600" face="Arial"><strong>
                                                    <!-- #BeginEditable "contenttitle" -->
                                                    Performance Management &gt; Input Realisasi<!-- #EndEditable -->
                                                </strong></font>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td  style="background-color:<%=bgColorContent%>; "> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                            <tr>
                                                                <td valign="top">
                                                                    <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                                        <tr>
                                                                            <td valign="top">
                                                                                <!-- #BeginEditable "content" -->
                                                                                <form name="frmkPI_Employee_Achiev" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="hidden_kPI_Employee_Achiev_id" value="<%=oidKPI_Employee_Achiev%>">
                                                                                    <input type="hidden" name="test" value="<%= emplx.getOID()  %>">
                                                                                    <% if (listKpiTarget.size()>0){%>
                                                                                    <table class="listgen" width="100%" cellspacing="1" border="0">
                                                                                        <tbody>
                                                                                            <tr>
                                                                                                <td class="listgentitle" width="2%" colspan="2"><strong>No</strong></td>
                                                                                                <td class="listgentitle" width="50%"><strong>KPI</strong></td>
                                                                                                <td class="listgentitle" width="15%"><strong>Target</strong></td>
                                                                                            </tr>
                                                                                            <%
                                                                                                for (int i = 0; i < listKpiTarget.size(); i++) {
                                                                                                    KpiTargetDetailEmployee objKpiTargetEmployee = (KpiTargetDetailEmployee) listKpiTarget.get(i);
                                                                                                    KpiTargetDetail targetDetail = PstKpiTargetDetail.fetchExc(objKpiTargetEmployee.getKpiTargetDetailId());
                                                                                                    KPI_List objKpiList = PstKPI_List.fetchExc(targetDetail.getKpiId());
                                                                                                    KPI_Employee_Achiev objKpiEmployeeAchiev = new KPI_Employee_Achiev();
                                                                                                     String whereKpiAndEmployeeId =  PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_LIST_ID] + " = " + targetDetail.getKpiId() +" AND "+ PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID] + " = " + objKpiTargetEmployee.getEmployeeId() ;
                                                                                                    Vector vKpiEmployeeAchiev = PstKPI_Employee_Achiev.list(0, 1, whereKpiAndEmployeeId, "");
                                                                                                    if(vKpiEmployeeAchiev.size() > 0){
                                                                                                        objKpiEmployeeAchiev = (KPI_Employee_Achiev) vKpiEmployeeAchiev.get(0);
                                                                                                    }
                                                                                            %>
                                                                                            
                                                                              
                                                                                            <tr>

                                                                                                <td class="listgensell" colspan="2" style="text-align: center"><%=i+1%></td>
                                                                                                <td class="listgensell" style="padding: 5px"><b><%=objKpiList.getKpi_title()%></b></td>
                                                                                                <%
                                                                                                    switch (objKpiList.getInputType()) {
                                                                                                        case PstKPI_List.TYPE_WAKTU:
                                                                                                %>
                                                                                                <td class="listgensell"style="padding: 5px"><b><%= Formater.formatDate(targetDetail.getDateFrom(), "yyyy-MM-dd") + " - " + Formater.formatDate(targetDetail.getDateTo(), "yyyy-MM-dd")%></b></td>
                                                                                                <%
                                                                                                        break;
                                                                                                    case PstKPI_List.TYPE_JUMLAH:
                                                                                                %>
                                                                                                <td class="listgensell"><b><%= String.format("%,.0f", targetDetail.getAmount())%></b></td>
                                                                                                <%
                                                                                                        break;
                                                                                                    case PstKPI_List.TYPE_PERSENTASE:
                                                                                                %>
                                                                                                <td class="listgensell"><b><%= String.format("%,.0f", targetDetail.getAmount())%> %</b></td>
                                                                                                <%
                                                                                                            break;
                                                                                                    }
                                                                                                %>
                                                                                           </tr>
                                                                             
                                                                                                
                                                                                            <tr>
                                                                                                <td class="listgensell" colspan="2">&nbsp;</td>
                                                                                                <td class="listgensell" colspan="3" style="padding: 10px">
                                                                                                    <%
                                                                                                        String whereTargetDetailEmp = PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]+"="+targetDetail.getOID()
                                                                                                         +" AND "+ PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_EMPLOYEE_ID]+"="+objKpiTargetEmployee.getEmployeeId();
                                                                                                        Vector listEmployeeTarget = PstKpiTargetDetailEmployee.list(0, 0, whereTargetDetailEmp, "");
                                                                                                        if (listEmployeeTarget.size()>0){
                                                                                                    %>
                                                                                                        <table class="listgen" width="100%" cellspacing="1" border="0">
                                                                                                            <tbody>
                                                                                                                <tr>
                                                                                                                    <td class="listgentitle" width="5%"><strong>No</strong></td>
                                                                                                                    <td class="listgentitle" width="5%"><strong>NRK</strong></td>
                                                                                                                    <td class="listgentitle" width="15%"><strong>Nama</strong></td>
                                                                                                                    <td class="listgentitle" width="15%"><strong>Satuan Kerja</strong></td>
                                                                                                                    <td class="listgentitle" width="10%"><strong>Achievment Score</strong></td>
                                                                                                                    <td class="listgentitle" width="10%"><strong>Score</strong></td>
                                                                                                                    <td class="listgentitle" width="10%"><strong>status</strong></td>
                                                                                                                    <td class="listgentitle" width="10%"><strong>Notes</strong></td>
                                                                                                                </tr>  
                                                                                                                <%
                                                                                                                    int no = 0;
                                                                                                                    double totalScore = 0;
                                                                                                                    for (int xx = 0; xx < listEmployeeTarget.size(); xx++){
                                                                                                                        no++;
                                                                                                                        KpiTargetDetailEmployee kpiTargetDetailEmployee = (KpiTargetDetailEmployee) listEmployeeTarget.get(xx);
                                                                                                                        Employee empDetail = new Employee();
                                                                                                                        try {
                                                                                                                            empDetail = PstEmployee.fetchExc(kpiTargetDetailEmployee.getEmployeeId());
                                                                                                                        } catch (Exception exc){}

                                                                                                                        %>
                                                                                                                        <tr>
                                                                                                                            <td class="listgensell"><%=no%></td>
                                                                                                                            <td class="listgensell"><%=empDetail.getEmployeeNum()%></td>
                                                                                                                            <td class="listgensell"><%=empDetail.getFullName()%></td>
                                                                                                                            <td class="listgensell"><%=PstEmployee.getDivisionName(empDetail.getDivisionId())%></td>
                                                                                                                            <%
                                                                                                                            String whereClauseAchiev = "" + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID] + " = " + empDetail.getOID() + " AND " + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_LIST_ID] + " = " + targetDetail.getKpiId()
                                                                                                                                        + " AND " + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_TARGET_ID] + " = " + targetDetail.getOID();
                                                                                                                                listKPI_Employee_Achiev = PstKPI_Employee_Achiev.list(start, recordToGet, whereClauseAchiev, orderClause);
                                                                                                                                double score = 0;
                                                                                                                                for (int x = 0; x < listKPI_Employee_Achiev.size(); x++) {
                                                                                                                                    KPI_Employee_Achiev kpiea = (KPI_Employee_Achiev) listKPI_Employee_Achiev.get(x);
                                                                                                                                    if (kpiea.getAchievType() == PstKPI_Employee_Achiev.TYPE_FINISH) {
                                                                                                                                        score = PstKPI_Employee_Achiev.getScore(kpiea.getOID());
                                                                                                                                        totalScore = totalScore + score;
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            %>
                                                                                                                            <td class="listgensell"><%= score%> %</td>
                                                                                                                            <%
                                                                                                                                if (empId == empDetail.getOID()){
                                                                                                                                    %>
                                                                                                                                        <td class="listgensell">
                                                                                                                                            <input class="achievement" type="number" id="achievement-<%=targetDetail.getOID()%>" value="<%=objKpiEmployeeAchiev.getAchievement()%> ">
                                                                                                                                    </td>
                                                                                                                                    <%
                                                                                                                                } else {
                                                                                                                                    %><td class="listgensell">&nbsp;</td><%
                                                                                                                                }
                                                                                                                            %>
                                                                                                                                <td>
                                                                                                                                    <select class="status" id="status-<%=targetDetail.getOID() %>">
                                                                                                                                       <% 
                                                                                                                                           String InProgress = "";
                                                                                                                                           String Finish = "";         
                                                                                                                                           if (objKpiEmployeeAchiev.getStatus() == PstKPI_Employee_Achiev.TYPE_IN_PROGRESS){ 
                                                                                                                                           InProgress = "selected";
                                                                                                                                           
                                                                                                                                       }
                                                                                                                                           if (objKpiEmployeeAchiev.getStatus() == PstKPI_Employee_Achiev.TYPE_FINISH){ 
                                                                                                                                           Finish = "selected";
                                                                                                                                           }
                                                                                                                                        %>
                                                                                                                                    <option value="<%=PstKPI_Employee_Achiev.TYPE_IN_PROGRESS%>"><%=
                                                                                                                                        PstKPI_Employee_Achiev.typeAchiev[PstKPI_Employee_Achiev.TYPE_IN_PROGRESS]
                                                                                                                                        %></option>
                                                                                                                                        <option value="<%=PstKPI_Employee_Achiev.TYPE_FINISH%>"><%=
                                                                                                                                        PstKPI_Employee_Achiev.typeAchiev[PstKPI_Employee_Achiev.TYPE_FINISH]
                                                                                                                                        %></option>
                                                                                                                                    <option></option>
                                                                                                                                    </select>
                                                                                                                            </td>
                                                                                                                                <td>
                                                                                                                                    <textarea class="notes" id="notes-<%=targetDetail.getOID() %>"><%=objKpiEmployeeAchiev.getAchievNote() %></textarea> 
                                                                                                                            </td>
                                                                                                            <input type="hidden" id="kpiListId-<%=targetDetail.getOID() %>" value="<%=targetDetail.getKpiId()%>">
                                                                                                            <input type="hidden" id="targetId-<%=targetDetail.getOID() %>" value="<%=targetDetail.getKpiTargetId() %>">
                                                                                                            <input type="hidden" id="employeeId-<%=targetDetail.getOID() %>" value="<%=kpiTargetDetailEmployee.getOID() %>">
                                                                                                            <input type="hidden" id="oidKpiEmployeeAchiev-<%=targetDetail.getOID() %>" value="<%=objKpiEmployeeAchiev.getOID() %>">
                                                                                                                        </tr>
                                                                                                                        <%
                                                                                                                    }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td class="listgensell" colspan="4" style="text-align: right"><b>Rata-Rata Score</b></td>
                                                                                                                    <td class="listgensell"><b><%=totalScore/no%> %</b></td>
                                                                                                                    <td class="listgensell">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </tbody>
                                                                                                        </table>
                                                                                                    <%
                                                                                                        }
                                                                                                    %>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <% } else { %>
                                                                                    No Target set..
                                                                                    <% } %>
                                                                                </form>
                                                                                <!-- #EndEditable -->
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
             <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%>
            <tr>
                            <td valign="bottom">
                               <!-- untuk footer -->
                                <%@include file="../footer.jsp" %>
                            </td>
                            
            </tr>
            <%}else{%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
      <%@ include file = "../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
     <script src="<%=approot%>/javascripts/jquery.js"></script>
    <!-- #BeginEditable "script" -->
    <script language="JavaScript">
           $("body").on("change", ".achievement, .status, .notes", function(e){
            let isReady = {};
            const targetDetail = $(this).attr("id").split("-")[1];
            const achievement = parseInt($("#achievement-"+targetDetail).val());
            const status = parseInt($("#status-"+targetDetail).val());
            const notes = parseInt($("#notes-"+targetDetail).val());
            const kpiListId = parseInt($("#kpiListId-"+targetDetail).val());
            const targetId = parseInt($("#targetId-"+targetDetail).val());
            const employeeId = parseInt($("#employeeId-"+targetDetail).val());
            const data = { 
                <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEVMENT] %> : achievement,
                <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_STATUS] %> : status,
                 <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_NOTE] %> : notes,
                  <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_LIST_ID] %> : kpiListId,
                  <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_TARGET_ID] %> : targetId,
                 <%=FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_EMPLOYEE_ID] %> : employeeId
                 }
            if(achievement < 0){
                isReady.achievement = false;
            }
            if(status <= 0){
                isReady.status = false;
            }
            if(notes <= 0){
                isReady.notes = false;
            }
            if(kpiListId <= 0){
                isReady.kpiListId = false;
            }
              if(targetId <= 0){
                isReady.targetId = false;
            }
              if(employeeId <= 0){
                isReady.employeeId = false;
            }

            if(Object.keys(isReady).length <= 0){
                $.ajax({
                  url: "<%= approot %>/AjaxInsertRealitation",
                  data: data,
                  type: 'POST',
                  beforeSend: function() {
//                        $("#loading-" + targetDetail).fadeIn("slow");
                  },
                  success: function(res) {
//                        form.parent().css("background-color", "#BDF5C3");
                  },
                  error: function(err) {
//                        form.parent().css("background-", "#F7D8D8");
                  },
                  complete: function() {
//                        $("#loading-" + targetDetail).fadeOut("slow");
                  }
                });
            }
            
        });
                                
                //var oBody = document.body;
                //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
    <!-- #EndEditable -->
    <!-- #EndTemplate --></html>
