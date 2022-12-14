<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<% 
/* 
 * Page Name  		:  experience.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: lkarunia 
 * @version  		: 01 
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
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.form.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EXPERIENCE); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* OBJ_DATABANK_PERSONAL_DATA = 1; */
int appObjCodePer = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PERSONAL_DATA);
boolean privViewPer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_FAMILY_MEMBER = 2; */
int appObjCodeFam = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_FAMILY_MEMBER);
boolean privViewFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_VIEW));
boolean privUpdateFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_LANG_N_COMPETENCE = 3; */
int appObjCodeLang = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_LANG_N_COMPETENCE);
boolean privViewLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_VIEW));
boolean privUpdateLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EDUCATION = 4; */
int appObjCodeEdu = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EDUCATION);
boolean privViewEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_VIEW));
boolean privUpdateEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EXPERIENCE = 5; */
/* OBJ_DATABANK_CAREERPATH = 6; */
int appObjCodeCar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_CAREERPATH);
boolean privViewCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_UPDATE));
/* On The Top */
/* OBJ_DATABANK_TRAINING = 7; */
int appObjCodeTra = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_TRAINING);
boolean privViewTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_VIEW));
boolean privUpdateTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_WARNING = 8; */
int appObjCodeWar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_WARNING);
boolean privViewWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_REPRIMAND = 9; */
int appObjCodeRep = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_REPRIMAND);
boolean privViewRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_AWARD = 10; */
int appObjCodeAwr = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_AWARD);
boolean privViewAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_VIEW));
boolean privUpdateAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_PICTURE = 11; */
int appObjCodePic = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PICTURE);
boolean privViewPic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_RELEVANT_DOC = 12; */
int appObjCodeRel = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_RELEVANT_DOC);
boolean privViewRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_UPDATE));
/////
%>
<!-- Jsp Block -->

<%!

	public String drawList(Vector objectClass ,  long workHistoryPastId, boolean privUpdate, boolean privDelete)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("90%");
		ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
                ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
		ctrlist.addHeader("Company Name","");
		ctrlist.addHeader("Start Date","");
		ctrlist.addHeader("End Date","");
		ctrlist.addHeader("Position","");
		ctrlist.addHeader("Move Reason","");
                ctrlist.addHeader("Provider","");
                ctrlist.addHeader("&nbsp;");

		Vector lstData = ctrlist.getData();
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Experience experience = (Experience)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(workHistoryPastId == experience.getOID()){
				 index = i;
                         }
                         String provider = "-";
			rowx.add(experience.getCompanyName());
			rowx.add(String.valueOf(experience.getStartDate()));			
			rowx.add(String.valueOf(experience.getEndDate()));
			rowx.add(experience.getPosition());
			rowx.add(experience.getMoveReason());
                        try {
                            ContactList contList = PstContactList.fetchExc(experience.getProviderID());
                            provider = contList.getCompName();
                        } catch(Exception e){
                            System.out.println("provider=>"+e.toString());
                        }
                        rowx.add(provider);
                        String btnEdit = "";
                        String btnDel = "";
                        if (privUpdate == true){
                            btnEdit = "<button class=\"btn-small\" onclick=\"cmdEdit('"+experience.getOID()+"')\">e</button>";
                        }
                        if (privDelete == true){
                            btnDel = "<button class=\"btn-small\" onclick=\"cmdAsk('"+experience.getOID()+"')\">&times;</button>";
                        }
                        rowx.add(btnEdit+"&nbsp;"+btnDel);

			lstData.add(rowx);
		}		

		return ctrlist.draw(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
long oidExperience = FRMQueryString.requestLong(request, "experience_oid");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstExperience.fieldNames[PstExperience.FLD_EMPLOYEE_ID]+ " = "+oidEmployee;
String orderClause = PstExperience.fieldNames[PstExperience.FLD_START_DATE];

CtrlExperience ctrlExperience = new CtrlExperience(request);
ControlLine ctrLine = new ControlLine();
Vector listExperience = new Vector(1,1);

/*switch statement */
iErrCode = ctrlExperience.action(iCommand , oidExperience, oidEmployee, request, emplx.getFullName(), appUserIdSess);
/* end switch*/
FrmExperience frmExperience = ctrlExperience.getForm();

Experience experience = ctrlExperience.getExperience();
msgString =  ctrlExperience.getMessage();

/*switch list Experience*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidExperience == 0))
	start = PstExperience.findLimitStart(experience.getOID(),recordToGet, whereClause, orderClause);

/*count list All Experience*/
int vectSize = PstExperience.getCount(whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlExperience.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listExperience = PstExperience.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listExperience.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listExperience = PstExperience.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/maintab.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></title>
<script language="JavaScript">


function cmdAdd(){
	document.frmexperience.experience_oid.value="0";
	document.frmexperience.command.value="<%=Command.ADD%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}

function cmdAsk(oidExperience){
	document.frmexperience.experience_oid.value=oidExperience;
	document.frmexperience.command.value="<%=Command.ASK%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}

function cmdConfirmDelete(oidExperience){
	document.frmexperience.experience_oid.value=oidExperience;
	document.frmexperience.command.value="<%=Command.DELETE%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}
function cmdSave(){
	document.frmexperience.command.value="<%=Command.SAVE%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
	}

function cmdEdit(oidExperience){
	document.frmexperience.experience_oid.value=oidExperience;
	document.frmexperience.command.value="<%=Command.EDIT%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
	}

function cmdCancel(oidExperience){
	document.frmexperience.experience_oid.value=oidExperience;
	document.frmexperience.command.value="<%=Command.EDIT%>";
	document.frmexperience.prev_command.value="<%=prevCommand%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}

function cmdBack(){
	document.frmexperience.command.value="<%=Command.BACK%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
	}
	
	
function cmdBackEmp(empOID){
	document.frmexperience.employee_oid.value=empOID;
	document.frmexperience.command.value="<%=Command.EDIT%>";	
	document.frmexperience.action="employee_edit.jsp";
	document.frmexperience.submit();
	}

function cmdListFirst(){
	document.frmexperience.command.value="<%=Command.FIRST%>";
	document.frmexperience.prev_command.value="<%=Command.FIRST%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}

function cmdListPrev(){
	document.frmexperience.command.value="<%=Command.PREV%>";
	document.frmexperience.prev_command.value="<%=Command.PREV%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
	}

function cmdListNext(){
	document.frmexperience.command.value="<%=Command.NEXT%>";
	document.frmexperience.prev_command.value="<%=Command.NEXT%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
}

function cmdListLast(){
	document.frmexperience.command.value="<%=Command.LAST%>";
	document.frmexperience.prev_command.value="<%=Command.LAST%>";
	document.frmexperience.action="experience.jsp";
	document.frmexperience.submit();
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
</script>
<style type="text/css">
    .tblStyle {border-collapse: collapse;font-size: 11px;}
    .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
    .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
    .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

    body {color:#373737;}
    #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
    #menu_title {color:#0099FF; font-size: 14px; font-weight: bold;}
    #menu_teks {color:#CCC;}
    #box_title {padding:9px; background-color: #D5D5D5; font-weight: bold; color:#575757; margin-bottom: 7px; }
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
    
    .btn {
        background: #ebebeb;
        background-image: -webkit-linear-gradient(top, #ebebeb, #dddddd);
        background-image: -moz-linear-gradient(top, #ebebeb, #dddddd);
        background-image: -ms-linear-gradient(top, #ebebeb, #dddddd);
        background-image: -o-linear-gradient(top, #ebebeb, #dddddd);
        background-image: linear-gradient(to bottom, #ebebeb, #dddddd);
        -webkit-border-radius: 5;
        -moz-border-radius: 5;
        border-radius: 3px;
        font-family: Arial;
        color: #7a7a7a;
        font-size: 12px;
        padding: 5px 11px 5px 11px;
        border: solid #d9d9d9 1px;
        text-decoration: none;
    }

    .btn:hover {
        color: #474747;
        background: #ddd;
        background-image: -webkit-linear-gradient(top, #ddd, #CCC);
        background-image: -moz-linear-gradient(top, #ddd, #CCC);
        background-image: -ms-linear-gradient(top, #ddd, #CCC);
        background-image: -o-linear-gradient(top, #ddd, #CCC);
        background-image: linear-gradient(to bottom, #ddd, #CCC);
        text-decoration: none;
        border: 1px solid #C5C5C5;
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

    .navbar li:hover {
        background-color: #0b71d0;
        border-bottom: 1px solid #033a6d;
    }

    .active {
        background-color: #0b71d0;
        border-bottom: 1px solid #033a6d;
    }
    .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
    .btn-small {
        padding: 3px; border: 1px solid #CCC; 
        background-color: #EEE; color: #777777; 
        font-size: 11px; cursor: pointer;
    }
    .btn-small:hover {border: 1px solid #999; background-color: #CCC; color: #FFF;}
    #confirm {
        padding: 18px 21px;
        background-color: #FF6666;
        color: #FFF;
        border: 1px solid #CF5353;
    }
    #btn-confirm {
        padding: 3px; border: 1px solid #CF5353; 
        background-color: #CF5353; color: #FFF; 
        font-size: 11px; cursor: pointer;
    }
</style>
        <style type="text/css">
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                background-color: #FFF;
                margin: 25px 23px 59px 23px;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
                background-color: #EEE;
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
            .btn {
                background: #ebebeb;
                background-image: -webkit-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -moz-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -ms-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -o-linear-gradient(top, #ebebeb, #dddddd);
                background-image: linear-gradient(to bottom, #ebebeb, #dddddd);
                -webkit-border-radius: 5;
                -moz-border-radius: 5;
                border-radius: 3px;
                font-family: Arial;
                color: #7a7a7a;
                font-size: 12px;
                padding: 5px 11px 5px 11px;
                border: solid #d9d9d9 1px;
                text-decoration: none;
            }

            .btn:hover {
                color: #474747;
                background: #ddd;
                background-image: -webkit-linear-gradient(top, #ddd, #CCC);
                background-image: -moz-linear-gradient(top, #ddd, #CCC);
                background-image: -ms-linear-gradient(top, #ddd, #CCC);
                background-image: -o-linear-gradient(top, #ddd, #CCC);
                background-image: linear-gradient(to bottom, #ddd, #CCC);
                text-decoration: none;
                border: 1px solid #C5C5C5;
            }
            
            .btn-small {
                padding: 3px; border: 1px solid #CCC; 
                background-color: #EEE; color: #777777; 
                font-size: 11px; cursor: pointer;
            }
            .btn-small:hover {border: 1px solid #999; background-color: #CCC; color: #FFF;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {padding: 7px 0px 2px 0px; font-size: 12px; font-weight: bold; color: #575757;}
            #div_input {}
            
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                margin-bottom: 2px;
                border-bottom: 1px solid #DDD;
                background-color: #EEE;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                padding: 21px;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                margin-top: 2px;
                background-color: #EEE;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 18px 21px;
                background-color: #FF6666;
                color: #FFF;
                border: 1px solid #CF5353;
            }
            #btn-confirm {
                padding: 3px; border: 1px solid #CF5353; 
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                
            }
            
        </style>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
<!-- #BeginEditable "styles" --> 
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
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

<!-- #EndEditable -->
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
            <span id="menu_title"><%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%> <strong style="color:#333;"> / </strong> <%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></span>
        </div>
        
        <% if (oidEmployee != 0) {%>
            <div class="navbar">
                <ul style="margin-left: 97px">
                    <% if (privViewPer == true){ 
                            if (privUpdatePer){
                    %>
                                <li class=""> <a href="employee_edit.jsp?employee_oid=<%=oidEmployee%>&prev_command=<%=Command.EDIT%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="employee_view_new.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } 
                       }
                    %>
                    <% if (privViewFam == true){ 
                            if (privUpdateFam){
                    %>
                                <li class=""> <a href="familymember.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="familymember_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewLang == true){ 
                            if (privUpdateLang){
                    %>
                                <li class=""> <a href="emplanguage.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="emplanguage_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewEdu == true){ 
                            if (privUpdateEdu){
                    %>
                                <li class=""> <a href="empeducation.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="empeducation_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <li class="active"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></li>
                    <% if (privViewCar == true){ 
                            if (privUpdateCar){
                    %>
                                <li class=""> <a href="careerpath.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="careerpath_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewTra == true){ 
                            if (privUpdateTra){
                    %>
                                <li class=""> <a href="training.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } else { %>
                                <li class=""> <a href="training_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } 
                        }
                    %>
                    <% if (privViewWar == true){ 
                            if (privUpdateWar){
                    %>
                                <li class=""> <a href="warning.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                    <%      } else { %>            
                                <li class=""> <a href="warning_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                    <%      }
                        } 
                    %>
                    <% if (privViewRep == true){ 
                            if (privUpdateRep){
                    %>
                                <li class=""> <a href="reprimand.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="reprimand_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewAwr == true){ 
                            if (privUpdateAwr){
                    %>
                                <li class=""> <a href="award.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="award_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewPic == true){ 
                            if (privUpdatePic){
                    %>
                                <li class=""> <a href="picture.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PICTURE) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="picture_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PICTURE) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewRel == true){ 
                            if (privUpdateRel){
                    %>
                                <li class=""> <a href="doc_relevant.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="doc_relevant_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } 
                        }
                    %>
                </ul>
            </div>
        <%}%>
        <div class="content-main">
            <form name="frmexperience" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="employee_oid" value="<%=oidEmployee%>">
                <input type="hidden" name="experience_oid" value="<%=oidExperience%>">

                <div class="content-info">
                    <% 
                        if(oidEmployee != 0){
                        Employee employee = new Employee();
                        try{
                                employee = PstEmployee.fetchExc(oidEmployee);
                        }catch(Exception exc){
                                employee = new Employee();
                        }
                    %>
                        <table border="0" cellspacing="0" cellpadding="0" style="color: #575757">
                        <tr> 
                                <td valign="top" style="padding-right: 11px;"><strong><%=dictionaryD.getWord(I_Dictionary.PAYROLL_NUMBER)%></strong></td>
                              <td valign="top"><%=employee.getEmployeeNum()%></td>
                        </tr>
                        <tr> 
                              <td valign="top" style="padding-right: 11px;"><strong><%=dictionaryD.getWord(I_Dictionary.NAME)%></strong></td>
                              <td valign="top"><%=employee.getFullName()%></td>
                        </tr>
                        <% Department department = new Department();
                              try{
                                department = PstDepartment.fetchExc(employee.getDepartmentId());
                              }catch(Exception exc){
                                department = new Department();
                              }
                        %>
                        <tr> 
                              <td valign="top" style="padding-right: 11px;"><strong><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT) %></strong></td>
                              <td valign="top"><%=department.getDepartment()%></td>
                        </tr>
                        <tr> 
                                <td valign="top" style="padding-right: 11px;"><strong><%=dictionaryD.getWord(I_Dictionary.ADDRESS)%></strong></td>
                              <td valign="top"><%=employee.getAddress()%></td>
                        </tr>
                        </table>
                    <% } %>
                </div>
                <div class="content-title">
                    <div id="title-large"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %> <%=dictionaryD.getWord(I_Dictionary.LIST) %></div>
                    <div id="title-small"><%=dictionaryD.getWord(I_Dictionary.LIST) %> <%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %> <%=dictionaryD.getWord(I_Dictionary.EMPLOYEE) %>.</div>
                </div>
                
                <div class="content">
                <%
                if (iCommand == Command.ASK){
                %>
                <table>
                    <tr>
                        <td valign="top">
                            <div id="confirm">
                                <strong><%=dictionaryD.getWord(I_Dictionary.ARE_YOU_SURE_TO_DELETE_ITEM) %> ?</strong> &nbsp;
                                <button id="btn-confirm" onclick="javascript:cmdConfirmDelete('<%=oidExperience%>')"><%=dictionaryD.getWord(I_Dictionary.YES) %></button>
                                &nbsp;<button id="btn-confirm" onclick="javascript:cmdBack()"><%=dictionaryD.getWord(I_Dictionary.NO) %></button>
                            </div>
                        </td>
                    </tr>
                </table>
                <%
                    }
                    if (ctrlExperience.getMessage().length() > 0){
                        %>
                        <div class="alert-box notice-success">
                            <%=ctrlExperience.getMessage()%>
                        </div>
                        <%
                    }
                    %>
                
                
                <table>
                                    <%
                                    try{
                                        if (listExperience.size()>0){
                                    %>
                                    
                                    <tr align="left" valign="top"> 
                                      <td height="22" valign="middle" colspan="3"> 
                                        <%= drawList(listExperience,iCommand == Command.SAVE?experience.getOID():oidExperience, privUpdate, privDelete)%> 
                                      </td>
                                    </tr>
                                    <%  } else {%>
                                    <tr align="left" valign="top"> 
                                      <td height="22" valign="middle" colspan="3">&nbsp; 
                                      </td>
                                    </tr>
                                    <tr align="left" valign="top"> 
                                      <td height="22" valign="middle" colspan="3" class="comment"> 
                                        <%=dictionaryD.getWord(I_Dictionary.NO_RECORD_AVAILABLE) %> <%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %>
                                      </td>
                                    </tr>
                                    <% } 
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
                                               else{ 
                                                     if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidExperience == 0))
                                                             cmd = PstEducation.findLimitCommand(start,recordToGet,vectSize); 
                                                 else
                                                             cmd = prevCommand; 
                                               }
                                        } 
                                        %>
                                        <% ctrLine.setLocationImg(approot+"/images");
                                        ctrLine.initDefault();
                                        %>
                                        <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                    </tr>
                                    <% if(iCommand == Command.NONE || (iCommand == Command.SAVE && frmExperience.errorSize() < 1)|| iCommand == Command.DELETE || iCommand == Command.BACK ||
                                                                                                  iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST ){%>
                                    <%if(privAdd){%>
                                    <tr align="left" valign="top"> 
                                      <td> 
                                        <table cellpadding="0" cellspacing="0" border="0">
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                            <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                            <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                            <td height="22" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command"><%=dictionaryD.getWord(I_Dictionary.ADD) %> 
                                            <%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></a> 
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <% }
                                                                                        }%>
                                  </table>
                               
                                  <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmExperience.errorSize()>0)||(iCommand==Command.EDIT)){%>
                                  <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                    <tr> 
                                      <td colspan="2" class="listtitle">
                                          <%=dictionaryD.getWord(I_Dictionary.EDIT) %>
                                          <%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %> 
                                        </td>
                                    </tr>
                                    <tr> 
                                      <td width="100%" colspan="2"> 
                                        <table border="0" cellspacing="2" cellpadding="2" width="100%">
                                          <tr align="left" valign="top"> 
                                            <td valign="top" width="17%">
                                                <%=dictionaryD.getWord(I_Dictionary.COMPANY_NAME) %> 
                                             </td>
                                            <td width="83%"> 
                                              <input type="text" name="<%=frmExperience.fieldNames[FrmExperience.FRM_FIELD_COMPANY_NAME] %>"  value="<%= experience.getCompanyName() %>" class="elemenForm" size="35">
                                              * <%= frmExperience.getErrorMsg(FrmExperience.FRM_FIELD_COMPANY_NAME) %> </td>
                                          </tr>
                                          <tr align="left" valign="top"> 
                                            <td valign="top" width="17%"> <%=dictionaryD.getWord(I_Dictionary.START_YEAR)%> </td>
                                            <td width="83%"> <%=	ControlDate.drawDateYear(frmExperience.fieldNames[FrmExperience.FRM_FIELD_START_DATE], experience.getStartDate(),"formElemen", -35,0) %> to 
                                              <%=	ControlDate.drawDateYear(frmExperience.fieldNames[FrmExperience.FRM_FIELD_END_DATE], experience.getEndDate(),"formElemen", -35,0) %> * 
                                              <% String strStart = frmExperience.getErrorMsg(FrmExperience.FRM_FIELD_START_DATE);
                                                                                                                 String strEnd = frmExperience.getErrorMsg(FrmExperience.FRM_FIELD_END_DATE);
                                                                                                                 System.out.println("strStart "+strStart);
                                                                                                                 System.out.println("strEnd "+strEnd);
                                                                                                                 if((strStart.length()>0)&&(strEnd.length()>0)){
                                                                                                                        %>
                                              <%= strStart %> 
                                              <%}else{
                                                                                                                        if((strStart.length()>0)||(strEnd.length()>0)){%>
                                              <%= strStart.length()>0?strStart:strEnd %> 
                                              <% }
                                                                                                                }%>
                                            </td>
                                          </tr>
                                          <tr align="left" valign="top"> 
                                            <td valign="top" width="17%"><%=dictionaryD.getWord(I_Dictionary.POSITION) %></td>
                                            <td width="83%"> 
                                              <input type="text" name="<%=frmExperience.fieldNames[FrmExperience.FRM_FIELD_POSITION] %>"  value="<%= experience.getPosition() %>" class="elemenForm" size="30">
                                              * <%= frmExperience.getErrorMsg(FrmExperience.FRM_FIELD_POSITION) %> </td>
                                          </tr>
                                          <tr align="left" valign="top"> 
                                            <td valign="top" width="17%"> <%=dictionaryD.getWord(I_Dictionary.MOVE_REASON) %> </td>
                                            <td width="83%"> 
                                              <textarea name="<%=frmExperience.fieldNames[FrmExperience.FRM_FIELD_MOVE_REASON] %>" class="elemenForm" cols="30" rows="3"><%= experience.getMoveReason() %></textarea>
                                              * <%= frmExperience.getErrorMsg(FrmExperience.FRM_FIELD_MOVE_REASON) %> </td>
                                          </tr>
                                          <tr>
                                              <td valign="top"><%=dictionaryD.getWord(I_Dictionary.PROVIDER) %></td>
                                              <td valign="top">
                                                  <select name="<%=frmExperience.fieldNames[FrmExperience.FRM_FIELD_PROVIDER_ID] %>">
                                                      <option value="0">-SELECT-</option>
                                                      <%
                                                      Vector listProvider = PstContactList.list(0, 0, "", "");
                                                      if (listProvider != null && listProvider.size()>0){
                                                          for (int i=0; i<listProvider.size(); i++){
                                                              ContactList contact = (ContactList)listProvider.get(i);
                                                              %>
                                                              <option value="<%=contact.getOID()%>"><%=contact.getCompName()%></option>
                                                              <%
                                                          }
                                                      }
                                                      %>
                                                  </select>
                                              </td>
                                          </tr>
                                          <tr>
                                              <td colspan="2"><button class="btn" onclick="javascript:cmdSave()">
                                                       <%=dictionaryD.getWord(I_Dictionary.SAVE_EMPLOYEE)%></button>&nbsp;<button class="btn" onclick="javascript:cmdBack()"> 
                                                       <%=dictionaryD.getWord(I_Dictionary.CLOSE) %></button></td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="13%">&nbsp;</td>
                                      <td width="87%">&nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="top" > 
                                      <td colspan="3"> 
                                        <div align="left"></div>
                                      </td>
                                    </tr>
                                  </table>
                                  <%}%>
                </div>
                               
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