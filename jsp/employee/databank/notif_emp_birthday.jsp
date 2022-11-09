<%-- 
    Document   : notif_emp_birthday
    Created on : Jun 24, 2020, 4:14:15 PM
    Author     : Utk
--%>


<%@page import="com.dimata.harisma.report.EmployeeDetailPdf"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.entity.leave.PstMessageEmp"%>
<%@page import="com.dimata.harisma.entity.leave.MessageEmp"%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.session.leave.LeaveConfigBpd"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%//@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    Vector leaveAppList = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    int iCommand = FRMQueryString.requestCommand(request);
    int notiftype = FRMQueryString.requestInt(request, "notiftype");
    long userid = FRMQueryString.requestLong(request, "userid");
    String message = FRMQueryString.requestString(request, "message");

    int usiaPensiun = Integer.valueOf(String.valueOf(PstSystemProperty.getValueByName("UMUR_PENSIUN")));
    /* get data end contrct by lenght day from master notification */
    Vector listPensiun = new Vector();
    try{
     int lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN);
      
        //whereclause mencari list karyawan akan berulang tahun dengan interval lenght day dari hari ini
        String whereClausePensiun = " "+"STR_TO_DATE(CONCAT(YEAR(CURDATE()),'-',MONTH("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+"),'-',DAY("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+")),'%Y-%c-%e')"+
                                     " BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)" +
                                     " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
        listPensiun = (Vector) PstEmployee.list(0, 0, whereClausePensiun, "");
    }catch(Exception exc){
        System.out.println("err get List End birthday :"+exc);
    }  
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Notif Employee Birthday </title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #EEE; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleNoBorder {font-size: 12px; }
            .tblStyleNoBorder td {padding: 5px 7px; font-size: 12px; }
            
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}

            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
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

            .content {
                padding: 21px;
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
            
            .btn-green {
                background-color: #b0f991;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-green:hover {
                color: #FFF;
                background-color: #83ef53;
                text-decoration: none;
            }
            
            .btn-red {
                background-color: #ff9999;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-red:hover {
                color: #FFF;
                background-color: #ff6666;
                text-decoration: none;
            }
            
            .btn-grey {
                background-color: #C5C5C5;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-grey:hover {
                color: #FFF;
                background-color: #B7B7B7;
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
            h2 {
                padding: 0px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                font-size: 14px;
                font-weight: bold;
                color: #007fba;
                padding-bottom: 15px;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
            }
            
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            .item {
                background-color: #FFF;
                padding: 9px;
                margin: 9px 15px;
            }
            .box-message {
                background-color: #FFF;
                border: 1px solid #DDD;
                border-radius: 5px;
                padding: 21px;
                margin-bottom: 12px;
            }
        </style>
        <script type="text/javascript">
         function cmdDetail(oid){
		document.frm.employee_oid.value=oid;
		document.frm.command.value="<%=Command.EDIT%>";
		document.frm.prev_command.value="<%=Command.EDIT%>";
		document.frm.action="employee_edit.jsp";
		document.frm.submit();
	}
        </script>
    </head>
    <body>
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
        <div id="menu_utama">
            <span id="menu_title">Employee Birthday</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="">
                <input type="hidden" name="prev_command" value="">
                <input type="hidden" name="employee_oid" value="">
                <input type="hidden" name="employee_rep" value="">
                <input type="hidden" name="leave_id" value="">
                <input type="hidden" name="field_approval" value="">
                <input type="hidden" name="check_approval" value="">
                <input type="hidden" name="notiftype" value="<%=notiftype%>">
                <input type="hidden" name="userid" value="<%=userid%>">
            
                <% 
                    if (listPensiun != null && listPensiun.size()>0){
                %>
                <table class="tblStyle">
                    
                    <tr>
                        <!--<td class="title_tbl">&nbsp;</td>-->
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">Payroll Number</td>
                        <td class="title_tbl">Nama Lengkap</td>
                        <td class="title_tbl">Unit</td>
                        <td class="title_tbl">Kategori</td>
                        <td class="title_tbl">Jabatan</td>
                        <td class="title_tbl">Tgl Lahir</td>
                        <td class="title_tbl">Usia</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                      for (int i=0; i<listPensiun.size(); i++){
                          Employee employee = (Employee) listPensiun.get(i);
                          Department department = (Department) PstDepartment.fetchExc(employee.getDepartmentId());
                          EmpCategory empCatergory = (EmpCategory) PstEmpCategory.fetchExc(employee.getEmpCategoryId());
                          Position position = (Position) PstPosition.fetchExc(employee.getPositionId());
                          
                          int usia = EmployeeDetailPdf.getAge(Formater.formatDate(employee.getBirthDate(),"yyyy-MM-dd"));
                          int bedaHari = EmployeeDetailPdf.getBirthDayDiff(Formater.formatDate(employee.getBirthDate(),"yyyy-MM-dd"));
                          
                         
                  
                    %>    
                     
                                <tr>
                                    <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                    <td style="background-color: #FFF;"><%=i+1%></td>
                                    <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                    <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                    <td style="background-color: #FFF;"><%=department.getDepartment()%></td>
                                    <td style="background-color: #FFF;"><%=empCatergory.getEmpCategory()%></td>
                                    <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                    <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getBirthDate(),"dd MMM yyyy")%></td>
                                    <td style="background-color: #FFF;"><%=usia%></td>
                                    <td style="background-color: #FFF;">
                                        <a class="btn-red" style="color:#FFF" href="javascript:cmdDetail('<%=employee.getOID()%>')">Detail</a>
                                    </td>
                                </tr>
                                <%
                                    
                            }
                        
                    %>
                </table>
                    <%
                        } else {
                    %>
                    <h5><strong>No Data Available</strong></h5>
                    <%
                        }
                    %>
            </form>
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
    </body>
</html>