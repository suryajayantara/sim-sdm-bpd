<%-- 
    Document   : appraisal_approval
    Created on : Sep 28, 2016, 6:46:53 PM
    Author     : Acer
--%>

<%@page import="com.dimata.harisma.form.employee.appraisal.FrmAppraisalMain"%>
<%@page import="com.dimata.harisma.form.*"%>
<%@page import="com.dimata.harisma.util.email"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@ page language="java" %>

<%@ include file = "../../main/javainit.jsp"%>
<%@ page import = "com.dimata.gui.jsp.*" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.Command" %>
<%@ page import = "com.dimata.harisma.session.admin.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");
long oidAppraisal = FRMQueryString.requestLong(request, FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APP_MAIN_ID]);
//update by satrya 2014-01-13
String source = FRMQueryString.requestString(request, "source");
long oidEmployee = FRMQueryString.requestLong(request, FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_EMPLOYEE_ID]);
long oidApprover = FRMQueryString.requestLong(request, "oidApprover");
int indexApproval = FRMQueryString.requestInt(request, "indexApproval");
boolean isApprove = FRMQueryString.requestBoolean(request, "isApprove");
Date Approvaldate = FRMQueryString.requestDate(request, "ApprovalDates");
long ApprovalDate_ms = (long) Approvaldate.getTime();
String strLoginId = FRMQueryString.requestString(request, "login_id");
String strPassword = FRMQueryString.requestString(request, "pass_wd");
I_Leave leaveConfig = null;
try{
      leaveConfig = (I_Leave)(Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());  
}catch(Exception exc){
    System.out.println("Exc Leave config in leave app approvall.jsp"+exc);
}
int machineLogin = 0;
machineLogin = FRMQueryString.requestInt(request, "machineLogin");
if (machineLogin==1){
    String empBarcodeFromMachine = "";
    empBarcodeFromMachine = FRMQueryString.requestString(request, "empBarcodeFromMachine");
    if (!empBarcodeFromMachine.equals("")){
        try{
            long empIdFromMachine = PstEmployee.getEmployeeByBarcode(empBarcodeFromMachine);
            AppUser newAppUser = PstAppUser.getByEmployeeId(""+empIdFromMachine); 
            strPassword = newAppUser.getPassword();
            iCommand = 11;
        }catch (Exception e){
        }
        
    } 
}

String userName = "";
AppUser objAppUser = new AppUser();
if(oidApprover!=0)
{
	try
	{
		objAppUser = PstAppUser.getByEmployeeId(""+oidApprover);
		userName = objAppUser.getLoginId();	
                strLoginId= userName;		
	}
	catch(Exception e)
	{
		System.out.println("Exc when fetch app user : " + e.toString());
	}
}

boolean loggedInSuccess = false;
if(iCommand == Command.SUBMIT)
{
	AppUser user = PstAppUser.getByLoginIDAndPassword(strLoginId, strPassword);
	if(user!=null && user.getEmployeeId()==oidApprover)
	{
		loggedInSuccess = true;
		isApprove = true;
	}
}

if(loggedInSuccess)
{
    Employee employeeForm = new Employee();
    try{
        employeeForm = PstEmployee.fetchExc(oidEmployee);
    }catch (Exception e ){}
    
    Employee employeeApproval = new Employee();
    try{
        employeeApproval = PstEmployee.fetchExc(oidApprover);
    }catch (Exception e ){}
     
    try{
    Vector<String> listRec = new Vector();
    listRec.add("" + employeeForm.getEmailAddress());
    //email.sendEmail(listRec, null, null, " Form anda telah di approve oleh "+employeeApproval.getFullName(), "approval", null, null);
    } catch (Exception e) {}
    
    switch(indexApproval){
        case 1: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="1" />
                <jsp:param name="approvalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>	
            <%
            break;
        case 2: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="2" />
                <jsp:param name="ApprovalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>	 
            <%
            break;    
        case 3: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="3" />
                <jsp:param name="ApprovalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>
            <%
            break; 
        case 4: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="4" />
                <jsp:param name="ApprovalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>
            <%
            break;   
        case 5: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="5" />
                <jsp:param name="ApprovalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>
            <%
            break; 
         case 6: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="6" />
                <jsp:param name="ApprovalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>
            <%
            break; 
        case 11: 
            %>
                <jsp:forward page="approvalForm.jsp"> 
                <jsp:param name="command" value="<%=Command.EDIT%>" />	
                <jsp:param name="start" value="<%=start%>" />
                <jsp:param name="employee_appraisal_oid" value="<%=oidAppraisal%>" />
                <jsp:param name="oidApprover" value="<%=oidApprover%>" />
                <jsp:param name="indexApproval" value="11" />
                <jsp:param name="approvalDate" value="<%=ApprovalDate_ms%>" />
                <jsp:param name="saved" value="<%=1%>" />
                <jsp:param name="indexMain" value="<%=1%>" />  
                <jsp:param name="source" value="<%=source%>" />
                </jsp:forward>	 
            <%
            break;
    }
}
%>
 
<html>
<head> 
<title>Harisma - Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<link rel="stylesheet" href="<%=approot%>/styles/calendar.css" type="text/css">
<script language="JavaScript">
window.status="";

function fnTrapKD(){
   if (event.keyCode == 13) 
   {
        document.all.aSearch.focus();
        cmdLogin();
   }
}
	
function cmdLogin()	
{
  //getApprovalDate();
  document.frm_appraisal.command.value="<%=String.valueOf(Command.SUBMIT)%>"; 
  document.frm_appraisal.action = "appraisal_approval.jsp";
  document.frm_appraisal.submit();
}


function cmdBackToEditor(oidOvertime, oidEmployee, depHeadAuthorize, managerOid)	
{
  document.frm_appraisal.command.value="<%=String.valueOf(Command.EDIT)%>"; 
  document.frm_appraisal.<%=FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APP_MAIN_ID]%>.value=oidOvertime; 
  document.frm_appraisal.<%=FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_EMPLOYEE_ID]%>.value=oidEmployee; 
  document.frm_appraisal.hidden_dep_head_authorize.value=depHeadAuthorize;      
  document.frm_appraisal.action = "approvalForm.jsp";
  document.frm_appraisal.submit();
}

function getApprovalDate(){    
     <%=ControlDatePopup.writeDateCaller("frm_appraisal","ApprovalDates")%>
}

function MM_swapImgRestore() 
{ //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() 
{ //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) 
{ //v4.0
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
</head>
<body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/login_images/button_f2.jpg');window.status=''">
    <!-- Untuk Calender-->
<%=(ControlDatePopup.writeTable(approot))%>
<!-- End Calender-->
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#FFFFFF">
  <tr>
    <td  bgcolor="#9BC1FF" height="20" ID="MAINMENU" valign="middle">
	<table width="100%" border="0">
  <tr>
    <td  bgcolor="#BBDDFF">
      <div align="center"><font color="#0000FF">&nbsp;</font></div>
	</td>
  </tr>
</table>
	</td>
  </tr>
  <tr>
    <td valign="middle" align="left">
      <form name="frm_appraisal" action="" onsubmit="window.status=''">
        <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">  
        <input type="hidden" name="<%=FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APP_MAIN_ID]%>" value="<%=String.valueOf(oidAppraisal)%>">
        <input type="hidden" name="<%=FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_EMPLOYEE_ID]%>" value="<%=oidEmployee%>">
        <input type="hidden" name="oidApprover" value="<%=String.valueOf(oidApprover)%>">
        <input type="hidden" name="indexApproval" value="<%=String.valueOf(indexApproval)%>">
        <input type="hidden" name="isApprove" value="<%=String.valueOf(isApprove)%>">
        <input type="hidden" name="start" value="<%=String.valueOf(start)%>">
        
        <input type="hidden" name="approvedId1" value="0">
        <input type="hidden" name="approvedId2" value="0">
        <input type="hidden" name="approvedId3" value="0">
        <input type="hidden" name="isApprove1" value="false">
        <input type="hidden" name="isApprove2" value="false">
        <input type="hidden" name="isApprove3" value="false">
        <!-- update by satrya 2014-1-013-->
        <input type="hidden" name="source" value="<%=source%>">
             
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="100%"> 
              <div align="center"><img src="../../images/harismaFlatWhite.gif"  width="364" height="177"> 
              </div>
            </td>
          </tr>
          <tr>
            <td width="100%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="100%" align="center"><font color="#FF0000" size="4"><b><font face="Verdana, Arial, Helvetica, sans-serif">.:: 
              MANAGER AUTHORIZATION ::.</font></b></font></td>
          </tr>
          <tr> 
            <td width="100%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="100%" valign="middle" align="center"> 
              <table width="339" border="0" cellpadding="0" cellspacing="0" align="center">
                <tr> 
                  <td colspan="3" height="28" valign="top"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="296" height="28" valign="top" background="../../images/login_images/uppmidd.jpg"><img src="../../images/login_images/uper_login.jpg" width="253" height="28"></td>
                        <td width="43" valign="top" align="right" background="../../images/login_images/uppmidd.jpg"><img src="../../images/login_images/upcorner.jpg" width="12" height="28"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="12" valign="top" background="../../images/login_images/left.jpg"><img src="../../images/login_images/left.jpg" width="12" height="17"> 
                  </td>
                  <td width="315" valign="top"> 
                    <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#52BAFF">
                      <tr valign="middle"> 
                        <td width="89" height="15">&nbsp;</td>
                        <td width="222"><%//=ControlDatePopup.writeDate("ApprovalDates",new Date(),"getApprovalDate()")%></td>
                      </tr>
                      <tr valign="middle"> 
                        <td nowrap height="15" width="89">Login Name</td>
                        <td width="222"> 
                          <input type="text" name="login_id" size="20" value="<%=userName%>" readOnly>
                        </td>
                      </tr>
                      <tr valign="middle"> 
                        <td height="15" nowrap width="89">Password</td>
                        <td width="222"> 
                          <input type="password" name="pass_wd" size="15" onKeyDown="javascript:fnTrapKD()">
                          <input type="submit" value="Submit" style="width: 0; height: 0">
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td width="12" valign="top" background="../../images/login_images/right.jpg"><img src="../../images/login_images/right.jpg" width="12" height="17"></td>
                </tr>
                <tr> 
                  <td colspan="3" height="42" valign="top"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="105" height="42" valign="top" background="../../images/login_images/bottom_middle.jpg"><img src="../../images/login_images/bottom_left_corner.jpg" width="9" height="42"></td>
                        <td width="195" valign="top" background="../../images/login_images/bottom_middle.jpg" align="right"><a href="javascript:cmdLogin()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','../../images/login_images/button_f2.jpg',1)"><img name="Image7" border="0" src="../../images/login_images/button.jpg" width="102" height="42" alt="Click to login"  id="aSearch"></a></td>
                        <td width="27" valign="top" background="../../images/login_images/bottom_middle.jpg">&nbsp;</td>
                        <td width="12" valign="top" align="right" background="../../images/login_images/bottom_middle.jpg"><img src="../../images/login_images/bottom_right_corner.jpg" width="12" height="42"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
		  <%
		  if(iCommand==Command.SUBMIT && !loggedInSuccess)
		  {
		  %>
          <tr> 
            <td height="26" valign="bottom"> 
              <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td valign="middle" height="38" align="right" class="text" colspan="2"> 
                    <div align="center"> 
					<font size="+1" color="#FF0000" >User or password invalid ...</font> 
					</div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
		  <%
		  }
		  %>
        </table>
		  </form>
    </td>
  </tr>
  <tr>
    <td colspan="2" height="20" <%=bgFooterLama%>>
      <%@ include file = "../../main/footer.jsp" %>
      </td>
  </tr>
</table>
<script language="JavaScript">
 document.frm_appraisal.pass_wd.focus();
</script>
</body>
</html>
