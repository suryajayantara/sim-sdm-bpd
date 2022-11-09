<%--
    Document   : overtime_list
    Created on : Nov 13, 2011, 4:43:29 PM
    Author     : Wiweka
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@ page language = "java" %>

<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.entity.payroll.*" %>
<%@ page import = "com.dimata.harisma.entity.overtime.*" %>
<%@ page import = "com.dimata.harisma.form.overtime.*" %>
<%@ page import = "com.dimata.harisma.session.payroll.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.harisma.entity.leave.I_Leave" %>

<%@ include file = "../../main/javainit.jsp" %>
<%  int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_OVERTIME, AppObjInfo.OBJ_PAYROLL_OVERTIME_FORM); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!
I_Leave leaveConfig = null; 
public void jspInit(){
    try{
    leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
    }catch (Exception e){
    System.out.println("Exception : " + e.getMessage());
    }
    }

public Date getMaxOvtDate(long overtimeId){
        Date dt = null;
        
        DBResultSet dbrs = null;
        try{
            String sql = "SELECT MAX("+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]+") AS "+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]+
                         " FROM " +PstOvertimeDetail.TBL_OVERTIME_DETAIL +
                         " WHERE " +PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_OVERTIME_ID]+" = "+ overtimeId;

            //System.out.println("sqlgetOvtDuration   "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
           // System.out.println("sql   "+sql);
            while(rs.next()) { 
                dt = DBHandler.convertDate(rs.getDate(PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]), rs.getTime(PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]));
            }
            rs.close();
	        
        }catch(Exception e){
            System.out.println("Error");
        }
        
        return dt;
    }

public String drawList(int start, Vector objectClass, /*int st*/ long overtimeId, Employee emplx){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader("No.","2%");
	ctrlist.addHeader("Ov. Number","6%");
	ctrlist.addHeader("Request Date","15%");
	ctrlist.addHeader("Company","15%");
	ctrlist.addHeader("Division","15%");
	ctrlist.addHeader("Department","15%");
	ctrlist.addHeader("Section","5%");
        ctrlist.addHeader("Objective","10%");
        ctrlist.addHeader("#Pax","5%");
        ctrlist.addHeader("Start~End ","15%");
        ctrlist.addHeader("Status","10%");
        ctrlist.addHeader("Requested by","10%");
        ctrlist.addHeader("Approve","5%");
        //ctrlist.addHeader("Final Approve","5%");


	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();        
        int index = -1;                

	for (int i = 0; i < objectClass.size(); i++) {
		Vector temp = (Vector)objectClass.get(i);
                Overtime overtime = (Overtime)temp.get(0);
                Company company = (Company)temp.get(1);
		Division division = (Division)temp.get(2);
		Department department = (Department)temp.get(3);
		Section section = (Section)temp.get(4);
                Employee employee = (Employee)temp.get(5);


		Vector rowx = new Vector();
		//rowx.add(String.valueOf(st + 1 + i));
                if (overtimeId == overtime.getOID()) {
                    index = i;
                }
                OvertimeDetail ovDetail = new OvertimeDetail();
                int numPax =0;
                try{
                    String whereClauseOv = PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_OVERTIME_ID]+"='"+overtime.getOID()+"'";
                    Vector lst = PstOvertimeDetail.list(0, 1, whereClauseOv, "");
                    if(lst!=null && lst.size()>0){
                        ovDetail = (OvertimeDetail) lst.get(0);
                    }
                    numPax = PstOvertimeDetail.getCount(whereClauseOv);
                }catch(Exception exc){
                    
                }
                int idxNo=start;
                rowx.add(""+(idxNo+i+1));
		rowx.add(""+ /*overtime.getCountIdx()*/ overtime.getOvertimeNum()==null || overtime.getOvertimeNum().length()<1 ? "-no number-" : overtime.getOvertimeNum() );
		rowx.add(""+ Formater.formatDate(overtime.getRequestDate(), "dd MMMM yyyy"));
		rowx.add(""+company.getCompany());
		rowx.add(""+division.getDivision());
		rowx.add(""+department.getDepartment());                
		rowx.add(""+section.getSection());
                rowx.add(""+overtime.getObjective());
                rowx.add(""+numPax);                
                rowx.add(""+ (ovDetail.getOID() ==0 ? "" : (Formater.formatDate(ovDetail.getDateFrom(), " dd-MMM-yyyy") + "<br>"+
                  Formater.formatDate(ovDetail.getDateFrom(), "HH:mm")+" ~ "+Formater.formatDate(ovDetail.getDateTo(), "HH:mm"))));
                rowx.add(""+I_DocStatus.fieldDocumentStatus[overtime.getStatusDoc()]);
                rowx.add(""+employee.getFullName());
                
                /*if(overtime.getRequestId()!=0){
                Vector app_value = new Vector(1, 1);
                Vector app_key = new Vector(1, 1);
                Vector listApp =leaveConfig.overtimeApprover(overtime.getOID());
                boolean canApprove = false;
                String approvedBy ="";
                for (int ie = 0; ie < listApp.size(); ie++) { 
                        Employee app = (Employee) listApp.get(ie);                        
                        if( app.getOID()==overtime.getApprovalId()){
                          approvedBy =""+app.getFullName();  
                        }
                        if(app.getOID()==emplx.getOID() ){
                            canApprove=true;                            
                        }
                }                                
                rowx.add( ( canApprove && overtime.getApprovalId()==0 )  ? ( "<input type=\"checkbox\" name=\"approveform\" value=\""+overtime.getOID()+"\""+
                        ( overtime.getApprovalId()== emplx.getOID()? "checked" : ""  ) 
                        +" >")  : ( (overtime.getApprovalId()!=0) ? (""+approvedBy):"-")) ;
                } else{
                    rowx.add("waiting");
                }*/
                
               /* if(overtime.getApprovalId()!=0){
                Vector fapp_value = new Vector(1, 1);
                Vector fapp_key = new Vector(1, 1);
                Vector listFApp =leaveConfig.overtimeFinalApprover(overtime.getOID());
                boolean canFApprove = false;
                String fApprovedBy ="";
                for (int ie = 0; ie < listFApp.size(); ie++) { 
                        Employee app = (Employee) listFApp.get(ie);                        
                        if( app.getOID()==overtime.getAckId()){
                          fApprovedBy =""+app.getFullName();  
                        }
                        if(app.getOID()==emplx.getOID() ){
                            canFApprove=true;                            
                        }
                }                                
                rowx.add( ( canFApprove && overtime.getAckId()==0 )  ? ( "<input type=\"checkbox\" name=\"finalapp\" value=\""+overtime.getOID()+"\""+
                        ( overtime.getAckId()== emplx.getOID()? "checked" : ""  ) 
                        +" >")  : ( (overtime.getAckId()!=0) ? (""+fApprovedBy):"-")) ;
                } else{
                    rowx.add("waiting");
                }*/
                
                boolean checkApproval = false;
                int incIndexApp = 0;
                boolean indexComplete = false;
                if (overtime.getRequestId() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 11);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkRequest(overtime.getOID(), leaveConfig, emplx.getOID());
                    }
                } else if (overtime.getApproval1Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 1);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getRequestId() );
                    }
                } else if (overtime.getApproval2Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 2);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getApproval1Id() );
                    }
                } else if (overtime.getApproval3Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 3);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getApproval2Id() );
                    }
                } else if (overtime.getApproval4Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 4);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getApproval3Id() );
                    }
                } else if (overtime.getApproval5Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 5);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getApproval4Id() );
                    }
                } else if (overtime.getApproval6Id() == 0){
                    indexComplete = PstOvertime.cekApproval(overtime, 6);
                    if(!indexComplete){
                        checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, emplx.getOID(), overtime.getRequestId(), overtime.getApproval5Id() );
                    }
                }
                String viewApproval = "<a href=\"javascript:cmdViewApproval('" + overtime.getOID() + "')\">View Approver</a>";
                
                int limitDayApproval = 0;
                String strlimitDayApproval = PstSystemProperty.getValueByName("OVERTIME_APPROVAL_LIMIT_DAY");
                try {
                    limitDayApproval = Integer.valueOf(strlimitDayApproval);
                } catch (Exception exc){}

                Date dtMax = getMaxOvtDate(overtime.getOID());

                boolean approval = true;
                if (dtMax != null && limitDayApproval > 0 && (overtime.getStatusDoc() == 0 || overtime.getStatusDoc() == 1)){
                    int diff = PstOvertime.getOvertimeApprovalDayDiff(emplx.getOID(), dtMax);
                    long maxTime = dtMax.getTime();
                    long nowTime = new Date().getTime();
                    long diffTime = nowTime - maxTime;
                    long diffDays = diffTime / (1000 * 60 * 60 * 24);
                    if (diff > (limitDayApproval)){
                        approval = false;
                    }
                }
                if (approval){
                    if (checkApproval && (overtime.getStatusDoc() == 0 || overtime.getStatusDoc() == 1)){
                        rowx.add("<center>"+viewApproval+"<input type=\"checkbox\" name='ovt_array' value="+overtime.getOID()+" id='chkapp'></center>");
                    } else {
                        rowx.add("<center>"+viewApproval+"<input type=\"checkbox\" name=\"data_is_process"+i+"\" value=\"0\" disabled=\"true\" id='chkapp'></center>");
                    }
                } else {
                    rowx.add("<center>"+viewApproval+"</center>");
                }

		lstData.add(rowx);
		lstLinkData.add(String.valueOf(overtime.getOID()));
	}        
	return ctrlist.draw(index);
}
%>

<%
long oidOvertime = FRMQueryString.requestLong(request, "overtime_oid");
long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
int iCommand = FRMQueryString.requestCommand(request);
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int start = FRMQueryString.requestInt(request, "start");
String[] arrayOid = FRMQueryString.requestStringValues(request, "ovt_array");
String ovtNum = FRMQueryString.requestString(request, "FRM_FIELD_OV_NUMBER");
int iErrCode = FRMMessage.ERR_NONE;

String msgStr = "";
int recordToGet = 20;
int vectSize = 0;
String orderClause = "";
String whereClause = "";

ControlLine ctrLine = new ControlLine();
SrcOvertime srcOvertime = new SrcOvertime();
CtrlOvertime ctrlOvertime = new CtrlOvertime(request);
FrmSrcOvertime frmSrcOvertime = new FrmSrcOvertime(request, srcOvertime);

if(iCommand == Command.LIST || iCommand==Command.APPROVE)
{
 frmSrcOvertime.requestEntityObject(srcOvertime);
}

String approvalMsg=""; 
String inOid = "";
if(iCommand==Command.APPROVE){
    
    if (arrayOid != null){
		
            for (int i=0; i < arrayOid.length; i++){
				
				if (i==0){
					inOid += arrayOid[i];
				} else {
					inOid += ","+ arrayOid[i];
				}
				
                Overtime ovt = new Overtime();
                long dateNw = System.currentTimeMillis();
                try{
                    ovt = PstOvertime.fetchExc(Long.valueOf(arrayOid[i]));
                } catch (Exception exc){}

                if (ovt != null){
                    if (ovt.getRequestId() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,11);
                    } else if (ovt.getApproval1Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,1);
                    } else if (ovt.getApproval2Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,2);
                    } else if (ovt.getApproval3Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,3);
                    } else if (ovt.getApproval4Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,4);
                    } else if (ovt.getApproval5Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,5);
                    } else if (ovt.getApproval6Id() == 0){
                        PstOvertime.setApproval(Long.valueOf(arrayOid[i]),leaveConfig,emplx.getOID(),dateNw,6);
                    }
                }

            }
			
			
       }
        
    
//        String leaveFormId[] = request.getParameterValues("approveform");
//        Vector<Long> leaveToBeAppr = new Vector();
//        if(leaveFormId!=null && leaveFormId.length > 0 && emplx.getOID() !=0){ 
//            for(int i=0; i< leaveFormId.length;i++ ){
//             try{
//                 leaveToBeAppr.add( Long.parseLong(leaveFormId[i]));
//             } catch(Exception exc){
//                 System.out.println(exc);                 
//             }
//            }            
//        }        
//        String finalApprId[] = request.getParameterValues("finalapp");
//        Vector<Long> leaveToBeFinalAppr = new Vector();
//        if(finalApprId!=null && finalApprId.length > 0 && emplx.getOID() !=0){ 
//            for(int i=0; i< finalApprId.length;i++ ){
//             try{
//                 leaveToBeFinalAppr.add( Long.parseLong(finalApprId[i]));
//             } catch(Exception exc){
//                 System.out.println(exc);                 
//             }
//            }            
//        }
//
//        com.dimata.harisma.form.overtime.CtrlOvertime ctrlOv = new com.dimata.harisma.form.overtime.CtrlOvertime(request); 
//        approvalMsg = ctrlOv.approveMultipleBy(emplx.getOID(), leaveToBeAppr, leaveToBeFinalAppr);         
// iCommand=Command.NEXT;
}


if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)||
		(iCommand==Command.LAST)||(iCommand == Command.BACK)||iCommand==Command.APPROVE)
{
 try
 {
	srcOvertime = (SrcOvertime)session.getValue(SessOvertime.SESS_SRC_OVERTIME);
			if (srcOvertime == null) {
				srcOvertime = new SrcOvertime();
			}
 }
 catch(Exception e)
 {
	srcOvertime = new SrcOvertime();
 }
}

SessOvertime sessOvertime = new SessOvertime();
srcOvertime.setNotIn(inOid);
session.putValue(SessOvertime.SESS_SRC_OVERTIME, srcOvertime);

if(iCommand == Command.SAVE )//&& prevCommand == Command.ADD)
{
	start = PstOvertime.findLimitStart(oidOvertime,recordToGet, whereClause,orderClause);
	//vectSize = PstOvertime.getCount(whereClause);
}
//else
{
	vectSize = sessOvertime.countOvertime(srcOvertime);
}

if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||
(iCommand==Command.LAST)||(iCommand==Command.LIST) || iCommand==Command.BACK)
		start = ctrlOvertime.actionList(iCommand, start, vectSize, recordToGet);


Vector listOvertime = new Vector(1,1);
if(iCommand == Command.SAVE && prevCommand==Command.ADD)
{
	listOvertime = sessOvertime.searchOvertime(new SrcOvertime(), start, recordToGet);
}
else
{
    try{
	listOvertime = sessOvertime.searchOvertime(srcOvertime, start, recordToGet);
        }catch(Exception ex){

        }
}
%>

<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>HARISMA - Overtime List</title>

<script language="JavaScript">

function cmdDoApproval(){
                document.frm_overtime.command.value="<%=Command.APPROVE %>";
	          document.frm_overtime.FRM_FIELD_STATUS_DOC.value="-1";
                document.frm_overtime.action="overtime_list.jsp";
		document.frm_overtime.submit();    
}

	function cmdAdd(){
		document.frm_overtime.command.value="<%=Command.ADD%>";
		//document.frm_overtime.prev_command.value="<%//=Command.ADD%>";
                document.frm_overtime.overtime_oid.value="0";
		document.frm_overtime.action="overtime.jsp";
		document.frm_overtime.submit();
	}

	function cmdEdit(oid){
		document.frm_overtime.overtime_oid.value=oid;
		document.frm_overtime.command.value="<%=Command.EDIT%>";
		//document.frm_overtime.prev_command.value="<%//=Command.EDIT%>";
		document.frm_overtime.action="overtime.jsp";
		document.frm_overtime.submit();
	}

	function cmdListFirst(){
		document.frm_overtime.command.value="<%=Command.FIRST%>";
		document.frm_overtime.action="overtime_list.jsp";
		document.frm_overtime.submit();
	}

	function cmdListPrev(){
		document.frm_overtime.command.value="<%=Command.PREV%>";
		document.frm_overtime.action="overtime_list.jsp";
		document.frm_overtime.submit();
	}

	function cmdListNext(){
		document.frm_overtime.command.value="<%=Command.NEXT%>";
		document.frm_overtime.action="overtime_list.jsp";
		document.frm_overtime.submit();
	}

	function cmdListLast(){
		document.frm_overtime.command.value="<%=Command.LAST%>";
		document.frm_overtime.action="overtime_list.jsp";
		document.frm_overtime.submit();
	}

	function cmdBack(){
		document.frm_overtime.command.value="<%=Command.BACK%>";
		document.frm_overtime.action="src_overtime.jsp";
                document.frm_overtime.submit();
	}
        
        function cmdImportFile(){
            document.frm_overtime.action="overtime_import_form.jsp";
            document.frm_overtime.submit();
        }

    function cmdViewApproval(overtimeId){
        newWindow=window.open("view_overtime_approval.jsp?overtime_id="+overtimeId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
        newWindow.focus();
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

<body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnBackOn.jpg','<%=approot%>/images/BtnNewOn.jpg')">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
     <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%@include file="../../styletemplate/template_header.jsp" %>
            <%}else{%>
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
                  Overtime &gt; Overtime Search Result<!-- #EndEditable -->
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
                                    <form name="frm_overtime" method="post" action="">
                                      <input type="hidden" name="command" value="<%=iCommand%>">
                                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                      <input type="hidden" name="start" value="<%=start%>">
                                      <input type="hidden" name="employee_oid" value="<%=oidEmployee%>">
                                      <input type="hidden" name="overtime_oid" value="<%=oidOvertime%>">
                                      <input type="hidden" name="ovtoid_array" value="">
                                      <input type="hidden" name="FRM_FIELD_STATUS_DOC" value="">
                                      <input type="hidden" name="FRM_FIELD_OV_NUMBER" value="<%=ovtNum%>"
                                      <%
                                                AppUser appUser = new AppUser();
                                                Employee emp = new Employee();
                                                try {
                                                    appUser = PstAppUser.fetch(appUserIdSess);
                                                    emp = PstEmployee.fetchExc(appUser.getEmployeeId());
                                                } catch(Exception e){
                                                    System.out.println("Get AppUser: userId");
                                                }

                                                long divisionId = 0;
                                                if (appUser.getAdminStatus() != 1){
                                                    divisionId = emp.getDivisionId();
                                                }
                                                if (appUser.getAdminStatus() != 1){
                                      %>
                                      <input type="hidden" name="FRM_FIELD_DIVISION_ID" value="<%=emplx.getDivisionId()%>"
                                             <%
                                                }
                                             %>
                                        <table border="0" width="100%">
                                        <tr>
                                          <td height="8" width="100%" class="listtitle"><span class="listtitle">Overtime List</span>
                                          </td>
                                        </tr>
                                        <%if((listOvertime!=null)&&(listOvertime.size()>0)){%>
                                        <tr>
                                          <td height="8" width="100%"><%=drawList(start,listOvertime, oidOvertime, emplx)%></td>
                                        </tr>
                                        <tr>
                                          <td height="8" width="100%">
                                              <table><tr>
                                                     <td width="30%" >&nbsp;</td>
                                                     <td width="60%" align="right" >&nbsp;<img  onClick="javascript:cmdDoApproval()" src="<%=approot%>/images/BtnSave.jpg" /></td>
                                                     <td width="30%" nowrap >&nbsp;<a href="javascript:cmdDoApproval()">Do Approval / Final Approval</a> 
                                                         &nbsp;<%=approvalMsg %>
                                                     </td>
                                              </tr>
                                          </table>
                                          </td>
                                        </tr>                                        
                                        <%}else{%>
                                        <tr>
                                          <td height="8" width="100%" class="comment"><span class="comment"><br>
                                            &nbsp;No Overtime available</span>
                                          </td>
                                        </tr>
                                        <%}%>
                                        
                                      </table>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td>
                                            <% ctrLine.setLocationImg(approot+"/images");
						ctrLine.initDefault();
						%>
                                            <%=ctrLine.drawImageListLimit(iCommand,vectSize,start,recordToGet)%>
                                          </td>
                                        </tr>
                                        <tr>
                                          <td nowrap align="left" class="command">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td nowrap align="left" class="command">
                                            <table border="0" cellspacing="0" cellpadding="0" align="left">
                                              <tr>
                                                <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td width="24"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image300','','<%=approot%>/images/BtnBackOn.jpg',1)"><img name="Image300" border="0" src="<%=approot%>/images/BtnBack.jpg" width="24" height="24" alt="Back To List"></a></td>
                                                <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td nowrap> <a href="javascript:cmdBack()" class="command">Back To SearchOvertime</a></td>
												<%
												if(privAdd)
												{
												%>
                                                <td width="8"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image100" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add New"></a></td>
                                                <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td nowrap><b><a href="javascript:cmdAdd()" class="command">Add New Overtime</a></b></td>
												<%
												}
												%>
												
											  </tr>
                                            </table>
                                          </td>
                                        </tr>
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
                                <%@include file="../../footer.jsp" %>
                            </td>
                            
            </tr>
            <%}else{%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
      <%@ include file = "../../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
            <%}%>
</table>
</body>
<!-- #BeginEditable "script" -->
<script language="JavaScript">
	var oBody = document.body;
	var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
</script>
<!-- #EndEditable -->
<!-- #EndTemplate --></html>


