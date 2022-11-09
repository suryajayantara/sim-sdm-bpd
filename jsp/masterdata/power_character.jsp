<%-- 
    Document   : power_character
    Created on : Mar 13, 2020, 11:41:02 AM
    Author     : gndiw
--%>

<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPowerCharacterColor"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPowerCharacterColor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_RELIGION); %>
<%@ include file = "../main/checkuser.jsp" %>
<%!

	public String drawList(int iCommand,FrmPowerCharacterColor frmObject, PowerCharacterColor objEntity, Vector objectClass,  long powerColorId)

	{
		ControlList ctrlist = new ControlList(); 
		ctrlist.setAreaWidth("25%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Nama","50%");
                ctrlist.addHeader("Warna","50%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 PowerCharacterColor power = (PowerCharacterColor)objectClass.get(i);
			 rowx = new Vector();
			 if(powerColorId == power.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmPowerCharacterColor.FRM_FIELD_COLOR_NAME] +"\" value=\""+power.getColorName()+"\" class=\"formElemen\" size=\"30\">");
                                rowx.add("<input type=\"color\" name=\""+frmObject.fieldNames[FrmPowerCharacterColor.FRM_FIELD_COLOR_HEX] +"\" value=\""+power.getColorHex()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(power.getOID())+"')\">"+power.getColorName()+"</a>");
                                rowx.add("<div style=\"background-color : "+power.getColorHex()+"; width: 50%; height:15px;\">&nbsp;</div>");
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmPowerCharacterColor.FRM_FIELD_COLOR_NAME] +"\" value=\""+objEntity.getColorName()+"\" class=\"formElemen\" size=\"30\">");
                                rowx.add("<input type=\"color\" name=\""+frmObject.fieldNames[FrmPowerCharacterColor.FRM_FIELD_COLOR_HEX] +"\" value=\""+objEntity.getColorHex()+"\" class=\"formElemen\" size=\"30\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidPower = FRMQueryString.requestLong(request, "hidden_power_id");

int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlPowerCharacterColor ctrlPowerCharacterColor = new CtrlPowerCharacterColor(request);
ControlLine ctrLine = new ControlLine();
Vector listPower = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPowerCharacterColor.action(iCommand , oidPower, 0, "");
/* end switch*/
FrmPowerCharacterColor frmPower = ctrlPowerCharacterColor.getForm();
int vectSize = PstPowerCharacterColor.getCount(whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlPowerCharacterColor.actionList(iCommand, start, vectSize, recordToGet);
 }

PowerCharacterColor power = ctrlPowerCharacterColor.getPowerCharacterColor();
msgString =  ctrlPowerCharacterColor.getMessage();

listPower = PstPowerCharacterColor.list(start,recordToGet, whereClause , orderClause);
if (listPower.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listPower = PstPowerCharacterColor.list(start,recordToGet, whereClause , orderClause);
}
%>
<html>
    <head>
        <title>HARISMA - Master Data Power Character</title>
        <script language="JavaScript">
        <!--

        function cmdAdd(){
                document.frmpower.hidden_power_id.value="0";
                document.frmpower.command.value="<%=Command.ADD%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdAsk(oidPower){
                document.frmpower.hidden_power_id.value=oidPower;
                document.frmpower.command.value="<%=Command.ASK%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdConfirmDelete(oidPower){
                document.frmpower.hidden_power_id.value=oidPower;
                document.frmpower.command.value="<%=Command.DELETE%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdSave(){
                document.frmpower.command.value="<%=Command.SAVE%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdEdit(oidPower){
                document.frmpower.hidden_power_id.value=oidPower;
                document.frmpower.command.value="<%=Command.EDIT%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdCancel(oidPower){
                document.frmpower.hidden_power_id.value=oidPower;
                document.frmpower.command.value="<%=Command.EDIT%>";
                document.frmpower.prev_command.value="<%=prevCommand%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdBack(){
                document.frmpower.command.value="<%=Command.BACK%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdListFirst(){
                document.frmpower.command.value="<%=Command.FIRST%>";
                document.frmpower.prev_command.value="<%=Command.FIRST%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdListPrev(){
                document.frmpower.command.value="<%=Command.PREV%>";
                document.frmpower.prev_command.value="<%=Command.PREV%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdListNext(){
                document.frmpower.command.value="<%=Command.NEXT%>";
                document.frmpower.prev_command.value="<%=Command.NEXT%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        function cmdListLast(){
                document.frmpower.command.value="<%=Command.LAST%>";
                document.frmpower.prev_command.value="<%=Command.LAST%>";
                document.frmpower.action="power_character.jsp";
                document.frmpower.submit();
        }

        //-------------- script form image -------------------

        function cmdDelPict(oidPower){
                document.frmimage.hidden_power_id.value=oidPower;
                document.frmimage.command.value="<%=Command.POST%>";
                document.frmimage.action="power_character.jsp";
                document.frmimage.submit();
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
        //-->
        </script>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
<!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <SCRIPT language=JavaScript>
            <!--
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
            //-->
            </SCRIPT>
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
                          Master Data > Power<!-- #EndEditable --> 
                    </strong></font>
                      </td>
                </tr>
                <tr> 
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td  style="background-color:<%=bgColorContent%>; "> 
                          <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                            <tr> 
                              <td valign="top"> 
                                <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                  <tr> 
                                    <td valign="top">
                                                          <!-- #BeginEditable "content" --> 
                                            <form name="frmpower" method ="post" action="">
                                              <input type="hidden" name="command" value="<%=iCommand%>">
                                              <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                              <input type="hidden" name="start" value="<%=start%>">
                                              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                              <input type="hidden" name="hidden_power_id" value="<%=oidPower%>">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr align="left" valign="top"> 
                                                  <td height="8"  colspan="3"> 
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr align="left" valign="top"> 
                                                        <td height="8" valign="middle" colspan="3">&nbsp; 
                                                        </td>
                                                      </tr>
                                                      <tr align="left" valign="top"> 
                                                        <td height="14" valign="middle" colspan="3" class="listtitle">&nbsp;Power 
                                                          List </td>
                                                      </tr>
                                                      <%
                                                                try{
                                                                if((listPower == null || listPower.size()<1)&&(iCommand == Command.NONE))
                                                                                iCommand = Command.ADD;  
                                                                %>
                                                      <tr align="left" valign="top"> 
                                                        <td height="22" valign="middle" colspan="3"> 
                                                          <%= drawList(iCommand,frmPower, power,listPower,oidPower)%> 
                                                        </td>
                                                      </tr>
                                                      <% 
                                                          }catch(Exception exc){ 
                                                          }%>
                                                      <tr align="left" valign="top"> 
                                                        <td height="8" align="left" colspan="3" class="command"> 
                                                          <span class="command"> 
                                                          <% 
                                                                           int cmd = 0;
                                                                                   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
                                                                                        (iCommand == Command.NEXT || iCommand == Command.LAST))
                                                                                                cmd =iCommand; 
                                                                           else{
                                                                                  if(iCommand == Command.NONE || prevCommand == Command.NONE)
                                                                                        cmd = Command.FIRST;
                                                                                  else 
                                                                                        cmd =prevCommand; 
                                                                           } 
                                                                    %>
                                                          <% ctrLine.setLocationImg(approot+"/images");
                                                                        ctrLine.initDefault();
                                                                         %>
                                                          <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                          </span> </td>
                                                      </tr>

                                                        <%//if((iCommand == Command.NONE || iCommand== Command.BACK)&& (privAdd)){
                                                         if((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT)&& (frmPower.errorSize()<1)){
                                                        if(privAdd){%>
                                                      <tr align="left" valign="top"> 
                                                        <td height="22" valign="middle" colspan="3">
                                                          <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr> 
                                                              <td>&nbsp;</td>
                                                            </tr>
                                                            <tr> 
                                                              <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                              <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                              <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                              <td height="22" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command">Add 
                                                                New Power</a></td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                        <%}}%>
                                                    </table> 
                                                  </td>
                                                </tr>
                                                <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmPower.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                                <tr align="left" valign="top"> 
                                                  <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                  <td height="8" colspan="2" width="83%">&nbsp; 
                                                  </td>
                                                </tr>
                                                <tr align="left" valign="top" > 
                                                  <td colspan="3" class="command"> 
                                                    <%
                                                                                ctrLine.setLocationImg(approot+"/images");
                                                                                ctrLine.initDefault();
                                                                                ctrLine.setTableWidth("80%");
                                                                                String scomDel = "javascript:cmdAsk('"+oidPower+"')";
                                                                                String sconDelCom = "javascript:cmdConfirmDelete('"+oidPower+"')";
                                                                                String scancel = "javascript:cmdEdit('"+oidPower+"')";
                                                                                ctrLine.setBackCaption("Back to List Power");
                                                                                ctrLine.setCommandStyle("buttonlink");
                                                                                ctrLine.setAddCaption("Add Power");
                                                                                ctrLine.setSaveCaption("Save Power");
                                                                                ctrLine.setDeleteCaption("Delete Power");
                                                                                ctrLine.setConfirmDelCaption("Yes Delete Power");

                                                                                if (privDelete){
                                                                                        ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                        ctrLine.setDeleteCommand(scomDel);
                                                                                        ctrLine.setEditCommand(scancel);
                                                                                }else{ 
                                                                                        ctrLine.setConfirmDelCaption("");
                                                                                        ctrLine.setDeleteCaption("");
                                                                                        ctrLine.setEditCaption("");
                                                                                }

                                                                                if(privAdd == false  && privUpdate == false){
                                                                                        ctrLine.setSaveCaption("");
                                                                                }

                                                                                if (privAdd == false){
                                                                                        ctrLine.setAddCaption("");
                                                                                }

                                                                                if(iCommand == Command.ASK)
                                                                                        ctrLine.setDeleteQuestion(msgString);
                                                                                %>
                                                    <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                                  </td>
                                                </tr>
                                                                                        <%}%>
                                              </table>
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
        <!-- #BeginEditable "script" -->
        <script language="JavaScript">
                //var oBody = document.body;
                //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
        </script>
        <!-- #EndEditable -->
        <!-- #EndTemplate --></html>
