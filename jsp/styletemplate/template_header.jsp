<%-- 
    Document   : template_header
    Created on : Jul 29, 2013, 2:31:38 PM
    Author     : user
--%>
<%@page import="com.dimata.harisma.entity.masterdata.PstNotification"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.aplikasi.entity.mastertemplate.TempDinamis"%>
<%@page import="com.dimata.aplikasi.entity.mastertemplate.PstTempDinamis"%>
<%@page import="com.dimata.aplikasi.entity.picturecompany.PictureCompany"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aplikasi.entity.picturecompany.PstPictureCompany"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--<!DOCTYPE html-->
<%
    String userAgent = request.getHeader("User-Agent");
    boolean isMSIE = (userAgent != null && userAgent.indexOf("MSIE") != -1);
    boolean mnuChangeTemplate = userSession.checkPrivilege(AppObjInfo.composeCode(
            AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_HEADER_MODIF, AppObjInfo.G2_MENU_HEADER_MODIF_TEMPLATE, AppObjInfo.OBJ_MENU_CHANGE_MENU),
            AppObjInfo.COMMAND_VIEW));
    boolean mnuChangePictureCompany = userSession.checkPrivilege(AppObjInfo.composeCode(
            AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_HEADER_MODIF, AppObjInfo.G2_MENU_HEADER_MODIF_TEMPLATE, AppObjInfo.OBJ_MENU_CHANGE_IMAGE_COMPANY),
            AppObjInfo.COMMAND_VIEW));

    String menuChangeTemplate = "";
    if (mnuChangeTemplate) {
        menuChangeTemplate = "<a href=\"javascript:changePicture()\" title=\"change picture\"  style=\"color:" + warnaFont + "\">Change Picture</a> |";
    }
    String changePicture = "";
    if (mnuChangePictureCompany) {
        changePicture = "<a href=\"" + approot + "/styletemplate/chage_template.jsp\" title=\"modif template\"  style=\"color:\"" + warnaFont + "\">Modif Template</a> |";
    }
%>

<script>
     
    function showNotif(){
          var x = document.getElementById("notif");
          //alert(x.style.display);
            if (x.style.display == "none" || x.style.display == null || x.style.display == "" ) {
              x.style.display = "block";
            } else {
              x.style.display = "none";
            }
    }
    function changePicture() {
        //window.open("<//%=approot%>/styletemplate/picture_company.jsp? height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
        window.open("<%=approot%>/styletemplate/picture_company.jsp?oidCompanyPic=" + "<%=pictureCompany != null && pictureCompany.getOID() != 0 ? pictureCompany.getOID() : 0%>",
        "upload_Image", "height=550,width=500, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }
    function changePassword(){
        window.open("<%=approot%>/employee/databank/update_password.jsp",
        "update_pin", "height=550,width=500, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }
    
    function cmdGoToApproval(category, oidcshedule){
        document.frmNotif.action="<%=approot%>/employee/leave/cuti_approval.jsp";
        document.frmNotif.leaveCategory.value=category;
        document.frmNotif.schSymbol.value=oidcshedule;
        document.frmNotif.submit();
    }
    function cmdGoToApproveCancel(){
        document.frmNotif.action="<%=approot%>/employee/leave/cuti_cancel_approval.jsp";	
        document.frmNotif.submit();
    }
    function cmdGoToOvertime(oid){
            var oidStr = oid;
            var str = oidStr.replace(/-/g,',');
            document.frm.action="payroll/overtimeform/overtime_list.jsp";
            document.frm.FRM_FIELD_OV_NUMBER.value=str;
            document.frm.FRM_FIELD_STATUS_DOC.value="-1";
            document.frm.command.value=<%=Command.LIST%>;
            document.frm.submit();
        } 
    
    //start add by Eri Yudi 2020-06-24
    
        function cmdGoNotifDetail(userId, notifId){
        document.frmNotif.action="<%=approot%>/employee/databank/notification_detail.jsp";
        document.frmNotif.notifId.value=notifId;
        document.frmNotif.userid.value=userId;
        document.frmNotif.submit();
        }
    //end add by Eri
	function cmdGoToApprovalKpi(){
		document.frmNotif.action="<%=approot%>/masterdata/approval.jsp";
		document.frmNotif.submit();
	}
	
	function cmdGoToApprovalKpiAchiev(){
		document.frmNotif.action="<%=approot%>/masterdata/approval_achievment.jsp";
		document.frmNotif.submit();
	}
    
        function cmdGoToApprovalData(){
            document.frmNotif.action="<%=approot%>/system/user_activity_log/approval_view.jsp";
            document.frmNotif.submit();
        }
    function loadDoc() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var obj = JSON.parse(this.responseText);
                if (obj.total > 0) {
                    document.getElementById("dropbtn").className += "badge1";
                    document.getElementById("dropbtn").setAttribute("data-badge", obj.total);
                    document.getElementById("notif").innerHTML = obj.link;
                }
            }
        };
        xhttp.open("GET", "<%=approot%>/ajax/ajax_notif.jsp?approot=<%=approot%>&employeeId=<%=emplx.getOID()%>&divisionId=<%=emplx.getDivisionId()%>", true);
        xhttp.send();
    }
    
    loadDoc();
</script>

<link href="<%=approot%>/styles/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet"/> <!--load all styles -->
<style type="text/css">
    .header1{background-color: <%=header1%>;}
    /*14-12-1019 2017132*/
    .badge1 {
        position:relative;
    }

    .badge1[data-badge]:after {
        content:attr(data-badge);
        position:absolute;
        top:-10px;
        right:-10px;
        font-size:11px;
        background:red;
        color:white;
        width:18px;
        height:18px;
        text-align:center;
        line-height:18px;
        border-radius:50%;
        box-shadow:0 0 1px #333;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
    }

    .dropdown-content a {
        float: none;
        color: black;
        padding: 8px 12px;
        text-decoration: none;
        display: block;
        text-align: left;
        font-size:12px;
    }

    .dropdown-content a:hover {
        background-color: lightblue;
    }

/*    .dropdown:hover .dropdown-content {
        display: block;
    }*/
</style>

<tr class="header1"><!-- style="background-color: <//%=header1%>"-->
    <td colspan="5"   style="color: <%=warnaFont%>; border-bottom: 1px solid <%=garis1%> "><!-- garis border bawah-->
        <table align="right" height="<%=!strInformation.equals("stop")?"20px":"20px"%>">
            
            <tr> 
                <td style="width: 45%">
                    <% if (!strInformation.equals("stop")){ %>
                    <marquee><span style="font-size: 22px; color: red"><%=strInformation%></span></marquee>
                    <% } %>
                </td>
                <%  
                String machineLogin = "";
                if(session.getValue("machineLogin")!=null){
                    machineLogin = String.valueOf(session.getValue("machineLogin"));
                }
                %>
                <% if(machineLogin.equals("1")) { %>
                <td  style="color: <%=warnaFont%>" align="right">
                    <form name="frmNotif" method="post">
                        <input type="hidden" name="FRM_FIELD_OV_NUMBER" value="">
                        <input type="hidden" name="FRM_FIELD_STATUS_DOC" value="">
                        <input type="hidden" name="leaveCategory">
                        <input type="hidden" name="schSymbol">
                        <input type="hidden" name="userid">
                        <input type="hidden" name="notifId">
                        <input type="hidden" name="command" value="">
                    </form>
                    <span class="dropdown" id="notifBadge">
                        <a class="" id="dropbtn" data-badge="0"><i style="font-size: 16px" class="fa fa-bell" onclick="showNotif()"></i></a>
                        <div class="dropdown-content" id="notif"></div>
                    </span>&nbsp;&nbsp;
                    <%=Formater.formatDate(new Date(), "EE,dd-MM-yyyy HH:mm")%> |  <a href="#" title="user"  style="color: <%=warnaFont%>"><%=userIsLogin.toLowerCase()%></a> | <%=menuChangeTemplate%> <%=changePicture%>   <a href="<%=approot%>/logout.jsp" title="logout"  style="color: <%=warnaFont%>">Logout </a><a href="<%=approot%>/logout.jsp?cekOut=1" title="logout"  style="color: <%=warnaFont%>">CekOut </a></td>
                <%}else{%>
                <td  style="color: <%=warnaFont%>" align="right">
                    <form name="frmNotif" method="post">
                        <input type="hidden" name="FRM_FIELD_OV_NUMBER" value="">
                        <input type="hidden" name="FRM_FIELD_STATUS_DOC" value="">
                        <input type="hidden" name="leaveCategory">
                        <input type="hidden" name="schSymbol">
                        <input type="hidden" name="userid">
                        <input type="hidden" name="notifId">
                        <input type="hidden" name="command" value="">
                    </form>
                    <span class="dropdown" id="notifBadge">
                        <a class="" id="dropbtn" data-badge="0"><i style="font-size: 16px" class="fa fa-bell" onclick="showNotif()"></i></a>
                        <div class="dropdown-content" id="notif"></div>
                    </span>&nbsp;&nbsp;
                    <%=Formater.formatDate(new Date(), "EE,dd-MM-yyyy HH:mm")%> |  <a href="#" title="user"  style="color: <%=warnaFont%>"><%=userIsLogin.toLowerCase()%></a> | <%=menuChangeTemplate%> <%=changePicture%> <a href="javascript:changePassword()">Change Password</a>   <a href="<%=approot%>/logout.jsp" title="logout"  style="color: <%=warnaFont%>">Logout </a></td>
                <%}%>
            </tr>
        </table>    
    </td>
</tr>
<tr>
    <td valign="top" nowrap>
        <table cellspacing="1" cellpadding="0" style="background-color: <%=header2%>;" width="100%">
            <tr>
                <!--<td rowspan="2" height="70px" width="120px" >
            <center><img src="<//%=approot%>/imgstyle/logo.png" ></center>
                </td>-->
                <td rowspan="2"    width="160px" style="padding-bottom: 12px" >
                    <center>
                        <a href="<%=approot%>/home.jsp?menu=home.jsp"><img height="90" src="<%=approot%>/imgcompany/<%=pictureCompany == null || pictureCompany.getNamaPicture() == null ? "logo.png" : pictureCompany.getNamaPicture()%>"></a>
                    </center>
		</td>
                <!--<td>
                    <font color="black" size="6">
                    <!--<span style="color: blue;" id="neonlight0">S</span><span style="color: blueviolet;" id="neonlight1">e</span><span style="color: pink;" id="neonlight2">l</span><span style="color: violet;" id="neonlight3">a</span><span style="color: yellowgreen;" id="neonlight4">m</span><span style="color: gold;" id="neonlight5">a</span><span style="color: graytext;" id="neonlight6">t</span><span style="color: aqua;" id="neonlight7"> </span><span style="color: crimson;" id="neonlight8">D</span><span style="color: blue;" id="neonlight9">a</span><span style="color: red;" id="neonlight10">t</span><span style="color: red;" id="neonlight11">a</span><span style="color: red;" id="neonlight12">n</span><span style="color: black;" id="neonlight13">g</span><span style="color: black;" id="neonlight14"></span>     -->
                <!--</td>-->
            </tr>
            <tr>
                <td nowrap valign="middle" style="padding-bottom: 12px"><!-- fungsinya agar tidak scroll ke bawah-->
                   
                        <%
                        if (navigation != null && navigation.equalsIgnoreCase("menu_i") && !isMSIE) {
                        %>
                        <%@include file="../menumain/menu_i.jsp"%>  
                        <%} else if (isMSIE || navigation != null && navigation.equalsIgnoreCase("menu_iii")) {%>
                        <%@include file="../menumain/menu_3.jsp"%>
                        <%}%> 
                </td>
            </tr>
        </table>
    </td>
</tr>
<%
if(!strInformation.equals("stop")){
%>

<%}%>