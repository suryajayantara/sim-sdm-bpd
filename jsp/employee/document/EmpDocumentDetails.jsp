<%-- 
    Document   : EmpDocumentDetails
    Created on : 29-Dec-2015, 12:02:57
    Author     : GUSWIK
--%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.recruitment.PstRecrApplication"%>
<%@page import="com.dimata.harisma.entity.recruitment.RecrApplication"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.report.JurnalDocument"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocListMutation"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterAction"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterAction"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocFlow"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterFlow"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterFlow"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocFlow"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocField"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocList"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocList"%>
<%@page import="org.omg.CORBA.OBJECT_NOT_EXIST"%>
<%@page import="com.dimata.harisma.entity.masterdata.ObjectDocumentDetail"%>
<%@page import="com.dimata.harisma.entity.masterdata.StringHelper"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterTemplate"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterTemplate"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKecamatan"%>
<%@page import="com.dimata.gui.jsp.ControlDate"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMaster"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDoc"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDoc"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<% 
/* 
 * Page Name  		:  EmpDoc.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: priska
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
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_EMP_DOCUMENT, AppObjInfo.OBJ_EMP_DOCUMENT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!    public String drawList(Vector objectClass, long oidEmpDoc) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader("NAMA", "35%");
        ctrlist.addHeader("FLOW TITLE", "20%");
        ctrlist.addHeader("POSITION INDEX", "15%");
        ctrlist.addHeader("APPROVE", "10%");
        ctrlist.addHeader("APPROVE DATE", "30%");

        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.reset();
        int index = -1;

        String where1 = " "+PstEmpDocFlow.fieldNames[PstEmpDocFlow.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc+"\"";
        Hashtable hashtableEmpDocFlow = PstEmpDocFlow.HlistFlow(0, 0, where1, "FLOW_INDEX");                                       
        
        for (int i = 0; i < objectClass.size(); i++) {
            DocMasterFlow docMasterFlow = (DocMasterFlow) objectClass.get(i);
            EmpDocFlow empDocFlow = new EmpDocFlow();
            
			if (hashtableEmpDocFlow.get(""+docMasterFlow.getFlow_index()) != null){
				empDocFlow = (EmpDocFlow) hashtableEmpDocFlow.get(""+docMasterFlow.getFlow_index());
			}

            
            //tampilkan employee berdasarkan mapping
            Vector appKey = new Vector(1,1);
            Vector appVal = new Vector(1,1);
            appKey.add("Select");
            appVal.add("0");
            try{
                String whereClause = " 1=1 ";
                        if (docMasterFlow.getCompany_id() != 0 && docMasterFlow.getCompany_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] +" = "+ docMasterFlow.getCompany_id() ;
            }
                        if (docMasterFlow.getDivision_id() != 0 && docMasterFlow.getDivision_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] +" = "+ docMasterFlow.getDivision_id() ;
                        }
                        if (docMasterFlow.getDepartment_id() != 0 && docMasterFlow.getDepartment_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] +" = "+ docMasterFlow.getDepartment_id() ;
                        }
                        if (docMasterFlow.getLevel_id() != 0 && docMasterFlow.getLevel_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] +" = "+ docMasterFlow.getLevel_id() ;
                            if(docMasterFlow.getFilter_for_division_id() > 0){
                                whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] +" = "+ docMasterFlow.getFilter_for_division_id() ;                            
                            }
                        }
                        if (docMasterFlow.getPosition_id() != 0 && docMasterFlow.getPosition_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] +" = "+ docMasterFlow.getPosition_id() ;
                            if(docMasterFlow.getFilter_for_division_id() > 0){
                                whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] +" = "+ docMasterFlow.getFilter_for_division_id() ;                            
                            }
                        }
                        if (docMasterFlow.getEmployee_id() != 0 && docMasterFlow.getEmployee_id() > 0) {
                            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +" = "+ docMasterFlow.getEmployee_id() ;
                        }
                        Vector listEmp = PstEmployee.list(0, 0, whereClause, "");
                        
                        if (listEmp.size() > 0){
                            for (int x=0;x<listEmp.size();x++){
                                Employee employee = (Employee) listEmp.get(x);
                                appKey.add(""+employee.getFullName());
                                appVal.add(""+employee.getOID());
                                
                            }
                        }
            }catch (Exception e ){}
            
            
            
            String statusAp = "Be Approve";
            boolean statusBoolean = false;
            if (empDocFlow.getOID() != 0){
                statusAp = "Approve";
                statusBoolean = true;
            }
            Employee employee = new Employee();
            try{
                employee = PstEmployee.fetchExc(empDocFlow.getSignedBy());
            } catch (Exception e){}
            Vector rowx = new Vector();
            //EmpDocumentDetails.jsp
            if (statusBoolean){
                rowx.add(""+employee.getFullName()+"");
            } else {
                //rowx.add("<a href=\"javascript:cmdApproval1('"+docMasterFlow.getEmployee_id()+"','"+oidEmpDoc+"','"+docMasterFlow.getFlow_title()+"','"+docMasterFlow.getFlow_index()+"')\">"+employee.getFullName()+"</a>");
                String strAttribute = "class=\"formElemen\" onChange=\"javascript:cmdApproval1('"+employee.getOID()+"','"+oidEmpDoc+"','"+docMasterFlow.getFlow_title()+"','"+docMasterFlow.getFlow_index()+"','"+i+"')\"";
                //rowx.add(""+ControlCombo.draw("app", null, "", appVal, appKey, strAttribute));
                rowx.add(ControlCombo.draw("FRM_APP"+i, "formElemen", null, String.valueOf(employee.getOID()), appVal, appKey, strAttribute));
                                
            }
            rowx.add(""+docMasterFlow.getFlow_title());
            rowx.add(""+docMasterFlow.getFlow_index());
            rowx.add(""+statusAp);
            rowx.add(""+Formater.formatDate(empDocFlow.getSignedDate(),"dd MMMM yyyy"));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(docMasterFlow.getOID()));
        }
        return ctrlist.draw(index);
    }

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidEmpDoc = FRMQueryString.requestLong(request, "EmpDocument_oid");
long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
long oidList = FRMQueryString.requestLong(request, "listLineId");
String cmdFor = FRMQueryString.requestString(request, "cmdFor");
String objName = FRMQueryString.requestString(request, "objectName");
SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
/* add field by hendra putu | 2016-11-13 */
int typeAction = 0;
int typeExpense = 0;
/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

EmpDoc empDoc1 = new EmpDoc();
DocMaster empDocMaster1 = new DocMaster();
DocMasterTemplate empDocMasterTemplate = new DocMasterTemplate();

CtrlEmpDoc ctrlEmpDoc = new CtrlEmpDoc(request);
ControlLine ctrLine = new ControlLine();

iErrCode = ctrlEmpDoc.action(iCommand , oidEmpDoc);
/* end switch*/
FrmEmpDoc frmEmpDoc = ctrlEmpDoc.getForm();

String empDocMasterTemplateText = "";

try {
    empDoc1 = PstEmpDoc.fetchExc(oidEmpDoc); 
} catch (Exception e){ }
if (empDoc1 != null){
try {
    empDocMaster1 = PstDocMaster.fetchExc(empDoc1.getDoc_master_id());
} catch (Exception e){ }
try {
    empDocMasterTemplateText = PstDocMasterTemplate.getTemplateText(empDoc1.getDoc_master_id());
} catch (Exception e){ }
}



String whereDocMasterFlow = " "+PstDocMasterFlow.fieldNames[PstDocMasterFlow.FLD_DOC_MASTER_ID] + " = \"" + empDoc1.getDoc_master_id() +"\""
                 + " AND (" +PstDocMasterFlow.fieldNames[PstDocMasterFlow.FLD_FILTER_FOR_DIVISION_ID]+ " = " + empDoc1.getDivisionId() +""
                 + " OR " +PstDocMasterFlow.fieldNames[PstDocMasterFlow.FLD_FILTER_FOR_DIVISION_ID]+ " = 0)" ;                                 
Vector listMasterDocFlow = PstDocMasterFlow.list(0,0, whereDocMasterFlow, "FLOW_INDEX");
String whereList = " "+PstEmpDocFlow.fieldNames[PstEmpDocFlow.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc+"\"";
Hashtable hashtableEmpDocFlow = PstEmpDocFlow.HlistFlow(0, 0, whereList, "FLOW_INDEX");  

    //ADD by Eri Yudi 2020-07-10 for approval
    EmpDoc empDoc = new EmpDoc();
    boolean isApproved = false;
    try{
         empDoc = (EmpDoc) PstEmpDoc.fetchExc(oidEmpDoc);
        if(empDoc.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED){
            isApproved = true ;
        }
        if(empDoc.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_CANCELED){
            isApproved = true ;
        }
    }catch(Exception exc){
        System.out.println("Eror :"+exc);
    }
// cek komplit untuk approval
boolean nstatus = true;
for (int x = 0; x < listMasterDocFlow.size(); x++){
     DocMasterFlow docMasterFlow = (DocMasterFlow) listMasterDocFlow.get(x);
     EmpDocFlow empDocFlow = new EmpDocFlow();
            if (hashtableEmpDocFlow.get(""+docMasterFlow.getFlow_index()) != null){
                empDocFlow = (EmpDocFlow) hashtableEmpDocFlow.get(""+docMasterFlow.getFlow_index());
            }
     if (empDocFlow.getOID() == 0){
         nstatus = false;
     }
}
 nstatus = true;
int show = 1;
String strYear = "";
String strMonth = "";
String strDay = "";

if (cmdFor.equals("deleteListLine")){
    try {
        long oid = PstEmpDocList.deleteExc(oidList);
    } catch (Exception exc){}
}

if (cmdFor.equals("deleteEmpComp")){
    try {
        String whereDocExps = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+"="+oidEmpDoc
                +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+oidEmployee;
        Vector listEmployee = PstEmpDocListExpense.list(0, 0, whereDocExps, "");
        for (int x=0;x < listEmployee.size();x++){
            EmpDocListExpense exps = (EmpDocListExpense) listEmployee.get(x);
            PstEmpDocListExpense.deleteExc(exps.getOID());
        }
    } catch (Exception exc){}
}

if (cmdFor.equals("deleteEmpBASPJ")){
	try {
		String whereListLine = PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMPLOYEE_ID]+"="+oidEmployee
				+ " AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME]+" = '"+objName+"'"
				+ " AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID]+" = "+oidEmpDoc;
		
		Vector listLine = PstEmpDocList.list(0, 0, whereListLine, "");
		if (listLine.size()>0){
			EmpDocList list = (EmpDocList) listLine.get(0);
			long oid = PstEmpDocList.deleteExc(list.getOID());
			String whereExpense = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+oidEmployee
				+ " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidEmpDoc;
			Vector listExpense = PstEmpDocListExpense.list(0, 0, whereExpense, "");
			if (listExpense.size()>0){
				for (int i = 0; i < listExpense.size(); i++){
					EmpDocListExpense expense = (EmpDocListExpense) listExpense.get(i);
					PstEmpDocListExpense.deleteExc(expense.getOID());
				}
			}
		}
	} catch (Exception exc){}
}
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
    <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleDoc {border-collapse: collapse; font-size: 12px; text-align: center;}
            .tblStyleDoc td {padding: 5px 7px; font-size: 12px; background-color: #FFF;}
            
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
                padding: 9px 11px;
                margin: 5px 11px 5px 0px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
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
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
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
            
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
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
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
        </style>
<script language="JavaScript">

function hide()
{
    document.getElementById("formula").style.display="none";
    document.getElementById("showB").style.display="block"; 
    document.getElementById("hideB").style.display="none";  
}
function show()
{
    document.getElementById("formula").style.display="block";
    document.getElementById("showB").style.display="none";
    document.getElementById("hideB").style.display="block";  
}


function cmdApproval(empId,oidEmpDoc,title,flowIndex){
            alert(""+empId);
        window.open("documentApproval.jsp?oidApprover="+empId+"&oidEmpDoc="+oidEmpDoc+"&flowTitle="+title+"&flowIndex="+flowIndex, null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdApproval1(empId,oidEmpDoc,title,flowIndex,index){
        
        var empIdX = 0;
        if(index==0){
            empIdX = document.frmEmpDoc.<%="FRM_APP0"%>.value;
        }
        if(index==1){
            empIdX = document.frmEmpDoc.<%="FRM_APP1"%>.value;
        }
        if(index==2){
            empIdX = document.frmEmpDoc.<%="FRM_APP2"%>.value;
        }
        if(index==3){
            empIdX = document.frmEmpDoc.<%="FRM_APP3"%>.value;
        }
        if(index==4){
            empIdX = document.frmEmpDoc.<%="FRM_APP4"%>.value;
        }
	document.frmEmpDoc.action="documentApproval.jsp?oidApprover="+empIdX+"&oidEmpDoc="+oidEmpDoc+"&flowTitle="+title+"&flowIndex="+flowIndex;
	document.frmEmpDoc.submit(); 
}
function cmdopen(){
	window.open("EmpDocTesting.jsp", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
} 
 
function cmdSearchEmp(value){
        window.open("<%=approot%>/employee/search/SearchDocumentDetails.jsp?value="+value+"&formName=frmEmpDoc&empPathId=<%=frmEmpDoc.fieldNames[frmEmpDoc.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdAddEmp(objectName,oidEmpDoc){
    window.open("<%=approot%>/employee/document/document_emp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc, null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");        
}
function cmdAddComp(objectName, oidEmpDoc, oidEmp){
        window.open("<%=approot%>/employee/document/document_comp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc+"&oid_emp="+oidEmp+"&command=<%=Command.LIST%>", null, "height=600,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdAddCompMulti(objectName, oidEmpDoc, empObjectName){
        window.open("<%=approot%>/employee/document/document_comp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc+"&emp_object_name="+empObjectName+"&command=<%=Command.LIST%>", null, "height=600,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdAddEmpAdjustment(oidEmpDoc,objectName){
        window.open("<%=approot%>/employee/document/document_emp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc+"&search_type=1", null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdAddDataKomponen(oidEmpDoc, objectName){
        window.open("<%=approot%>/employee/document/document_custom_exps_add.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc, null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}

function cmdAddEmpNew(objectName, oidEmpDoc){
        window.open("<%=approot%>/employee/document/document_emp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc, null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}

function cmdAddEmpNewDocExpense(objectName, oidEmpDoc){
        window.open("<%=approot%>/employee/document/document_emp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc+"&is_emp_doc_expense=TRUE", null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}

function cmdAddLeave(objectName, oidEmpDoc){
        window.open("<%=approot%>/employee/document/doc_leave_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc, null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdEditDay(oidComp){
        window.open("<%=approot%>/employee/document/edit_comp_day.jsp?oid_comp="+oidComp, null, "height=600,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}

function cmdAddPenerimaan(objectName, oidEmpDoc){
    window.open("<%=approot%>/employee/document/search_app_letter.jsp?oid_emp_doc="+oidEmpDoc+"&object_name="+objectName, null, "height=500,width=500, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
}
function cmdAddEmpSingle(objectName,oidEmpDoc){
    window.open("<%=approot%>/employee/document/document_emp_search.jsp?object_name="+objectName+"&oid_emp_doc="+oidEmpDoc+"&is_data_single=TRUE", null, "height=600,width=900, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");             
}
function cmdAddText(oidEmpDoc,ObjectName,ObjectType,ObjectClass,ObjectStatusfield){
        window.open("EmpDocumentDetailObject.jsp?oidEmpDoc="+oidEmpDoc+"&ObjectName="+ObjectName+"&ObjectType="+ObjectType+"&ObjectClass="+ObjectClass+"&ObjectStatusfield="+ObjectStatusfield+"&formName=frmEmpDoc&empPathId=<%=frmEmpDoc.fieldNames[frmEmpDoc.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdSelectPos(empDocId,ObjectName,ObjectType,ObjectClass,ObjectStatusfield,empId){
        window.open("EmpDocListMutation.jsp?empDocId="+empDocId+"&ObjectName="+ObjectName+"&ObjectType="+ObjectType+"&ObjectClass="+ObjectClass+"&ObjectStatusfield="+ObjectStatusfield+"&formName=frmEmpDoc&empPathId=<%=frmEmpDoc.fieldNames[frmEmpDoc.FRM_FIELD_EMPLOYEE_ID]%>"+"&employeeId="+empId, null, "height=600,width=650, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdDeleteEmployee(empDocId, empId, ObjName){
	var result = confirm("Hapus Data?");
     if (result){
        document.frmEmpDoc.employee_oid.value=empId;
        document.frmEmpDoc.EmpDocument_oid.value=empDocId;
        document.frmEmpDoc.objectName.value=ObjName;
        document.frmEmpDoc.cmdFor.value="deleteEmpBASPJ";
        document.frmEmpDoc.action="EmpDocumentDetails.jsp";
        document.frmEmpDoc.submit();
    }
}
function cmdPrintPDF(oidEmpDoc){
                window.open("<%=approot%>/servlet/com.dimata.harisma.report.EmpDocumentPDF?oid="+oidEmpDoc);
            }
  function cmdImport(oidEmpDoc){
                window.open("document_import.jsp?doc_id="+oidEmpDoc);      
            }           
 function cmdExpense(oidEmpDoc){
                window.open("EmpDocumentExpense.jsp?oidEmpDoc="+oidEmpDoc);      
            }           
 function cmdAction(oidEmpDoc,oidDocAction,typeAction){
                window.open("EmpDocumentDetailAction.jsp?oidEmpDoc="+oidEmpDoc+"&oidDocAction="+oidDocAction+"&type_action="+typeAction); 
            }
 function cmdRun(oidEmpDoc,typeExpense){
                window.location="doc_expense_process.jsp?doc_id="+oidEmpDoc+"&expense_type="+typeExpense; 
            }            
 function cmdPrint(oidEmpDoc){
                window.open("EmpDocumentDetailsEditor.jsp?EmpDocument_oid="+oidEmpDoc, null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes"); 
            }
            
            function cmdImport(oidEmpDoc){
                window.open("document_import.jsp?doc_id="+oidEmpDoc);      
            }
 function cmdDeleteListLine(oidList,oidEmp,ObjName){
     var result = confirm("Hapus Data?");
     if (result){
        document.frmEmpDoc.listLineId.value=oidList;
        document.frmEmpDoc.listLineEmpId.value=oidEmp;
        document.frmEmpDoc.objectName.value=ObjName;
        document.frmEmpDoc.cmdFor.value="deleteListLine";
        document.frmEmpDoc.action="EmpDocumentDetails.jsp";
        document.frmEmpDoc.submit();
    }
 }
 
 function cmdDeleteEmpComp(oidDoc, oidEmp){
    var result = confirm("Hapus Data?");
    if (result){
        document.frmEmpDoc.EmpDocument_oid.value=oidDoc;
        document.frmEmpDoc.employee_oid.value=oidEmp;
        document.frmEmpDoc.cmdFor.value="deleteEmpComp";
        document.frmEmpDoc.action="EmpDocumentDetails.jsp";
        document.frmEmpDoc.submit();
    }
 }
 
 function cmdBack(){
	window.open("emp_document.jsp", "_self");       
} 

</script>
<script src="../../styles/ckeditor/ckeditor.js"></script>
</head> 

<body>
<div id="menu_utama">
            <span id="menu_title">Document <strong style="color:#333;"> / </strong> <a href="emp_document.jsp"> Employee Document</a></span>
        </div>
    <div class="content-main">
        <!-- #BeginEditable "content" --> 
        <form name="frmEmpDoc" method ="post" action="" >
            <input type="hidden" name="command" value="<%=iCommand%>">
                
            <input type="hidden" name="start" value="<%=start%>">
            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
            <input type="hidden" name="EmpDocument_oid" value="<%=oidEmpDoc%>">
            <input type="hidden" name="listLineEmpId">
            <input type="hidden" name="listLineId">
			<input type="hidden" name="employee_oid">
            <input type="hidden" name="objectName">
            <input type="hidden" name="cmdFor">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                              
                            <tr align="left" valign="top"> 
                                <td colspan="3" >
                                    <div>&nbsp;</div>
                                </td>
                            </tr>
                                
                                
                            <%//=ControlDate.drawDateWithStyle(frmEmployee.fieldNames[FrmEmployee.FRM_FIELD_BIRTH_DATE], employee.getBirthDate() == null ? new Date() : employee.getBirthDate(), 0, -150, "formElemen")%>    
                                
                            <%
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");
                                    
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("<;", "<");
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");
                                String tanpaeditor = empDocMasterTemplateText;
                                String subString = "";
                                String stringResidual = empDocMasterTemplateText;
                                Vector vNewString = new Vector();
                                    
                                Hashtable empDOcFecthH = new Hashtable();
                                    
                                try {
                                    empDOcFecthH = PstEmpDoc.fetchExcHashtable(oidEmpDoc);
                                } catch (Exception e) {
                                }
                                    
                                String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                Hashtable hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
                                    
                                int startPosition = 0;
                                int endPosition = 0;
                                try {
                                    do {
                                        
                                        ObjectDocumentDetail objectDocumentDetail = new ObjectDocumentDetail();
                                        startPosition = stringResidual.indexOf("${") + "${".length();
                                        endPosition = stringResidual.indexOf("}", startPosition);
                                        subString = stringResidual.substring(startPosition, endPosition);
                                            
                                            
                                        //cek substring
                                            
                                            
                                        String[] parts = subString.split("-");
                                        String objectName = "";
                                        String objectType = "";
                                        String objectClass = "";
                                        String objectStatusField = "";
                                        try {
                                            objectName = parts[0];
                                            objectType = parts[1];
                                            objectClass = parts[2];
                                            objectStatusField = parts[3];
                                        } catch (Exception e) {
                                            System.out.printf("pastikan 4 parameter");
                                        }
                                            
                                            
                                        //cek dulu apakah hanya object name atau tidak
                                        if (!objectName.equals("") && !objectType.equals("") && !objectClass.equals("") && !objectStatusField.equals("")) {
                                            
                                            
                                            //jika list maka akan mencari penutupnya..
                                            if (objectType.equals("SINGLE") && objectStatusField.equals("START")) {
                                              //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                add = "<a href=\"javascript:cmdAddEmpSingle('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                add = "";
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                EmpDocList empDocList = new EmpDocList();
                                                Employee employeeFetch = new Employee();
                                                Hashtable HashtableEmp = new Hashtable();
                                                if (listEmp.size() > 0) {
                                                    try {
                                                        empDocList = (EmpDocList) listEmp.get(listEmp.size() - 1);
                                                        employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                        HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                    } catch (Exception e) {
                                                    }
                                                        
                                                }
                                                    
                                                int xx = 2;
                                                int startPositionOfFormula = 0;
                                                int endPositionOfFormula = 0;
                                                String subStringOfFormula = "";
                                                String residuOfsubStringOfTd = textString;
                                                do {
                                                    
                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                    subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                        
                                                        
                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                    String objectNameFormula = partsOfFormula[0];
                                                    String objectTypeFormula = partsOfFormula[1];
                                                    String objectTableFormula = partsOfFormula[2];
                                                    String objectStatusFormula = partsOfFormula[3];
                                                    String value = "";
                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                        value = (String) HashtableEmp.get(objectStatusFormula);
                                                        if (value == null) {
                                                            value = "-";
                                                        }
                                                            
                                                    } else {
                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusFormula + "}", value);
                                                        
                                                    tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusFormula + "}", value);
                                                    residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                        
                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                } while (endPositionOfFormula > 0);
                                                    
                                                    
                                                    
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                    
                                            } else if (objectType.equals("LIST") && objectStatusField.equals("START")) {
                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                add = "<a href=\"javascript:cmdAddEmp('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                add = "";
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                    
                                                    
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                do {
                                                    //cari tag table pembuka
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
                                                    //mencari body 
                                                    int startPositionOfBody = subStringOfTable.indexOf("<tbody>") + "<tbody>".length();
                                                    int endPositionOfBody = subStringOfTable.indexOf("</tbody>", startPositionOfBody);
                                                    String subStringOfBody = subStringOfTable.substring(startPositionOfBody, endPositionOfBody);//isi body
                                                        
                                                    //mencari tr pertama pada table
                                                    int startPositionOfTr1 = subStringOfBody.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr1 = subStringOfBody.indexOf("</tr>", startPositionOfTr1);
                                                    String subStringOfTr1 = subStringOfBody.substring(startPositionOfTr1, endPositionOfTr1);
                                                        
                                                    String subStringOfBody2 = subStringOfBody.substring(endPositionOfTr1, subStringOfBody.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr2 = subStringOfBody2.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr2 = subStringOfBody2.indexOf("</tr>", startPositionOfTr2);
                                                    String subStringOfTr2 = subStringOfBody2.substring(startPositionOfTr2, endPositionOfTr2);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "";
                                                    if (listEmp.size() > 0) {
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                                
                                                                
                                                                
                                                            stringTrReplace = stringTrReplace + "<tr>";
                                                                
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTr2 = subStringOfTr2;
                                                            int jumlahtd = 0;
                                                                
                                                                
                                                                
                                                            do {
                                                                
                                                                stringTrReplace = stringTrReplace + "<td>";
                                                                    
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                subStringOfTd = residuOfsubStringOfTr2.substring(startPositionOfTd, endPositionOfTd);//isi table 
                                                                    
                                                                int startPositionOfFormula = 0;
                                                                int endPositionOfFormula = 0;
                                                                String subStringOfFormula = "";
                                                                String residuOfsubStringOfTd = subStringOfTd;
                                                                do {
                                                                    
                                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                                        
                                                                        
                                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                                    String objectNameFormula = partsOfFormula[0];
                                                                    String objectTypeFormula = partsOfFormula[1];
                                                                    String objectTableFormula = partsOfFormula[2];
                                                                    String objectStatusFormula = partsOfFormula[3];
                                                                    String value = "";
                                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                                        value = (String) HashtableEmp.get(objectStatusFormula);
                                                                            
                                                                    } else {
                                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                    }
                                                                        
                                                                    stringTrReplace = stringTrReplace + value;
                                                                        
                                                                    residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                } while (endPositionOfFormula > 0);
                                                                    
                                                                    
                                                                    
                                                                residuOfsubStringOfTr2 = residuOfsubStringOfTr2.substring(endPositionOfTd, residuOfsubStringOfTr2.length());
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                jumlahtd = jumlahtd + 1;
                                                                    
                                                                stringTrReplace = stringTrReplace + "</td>";
                                                            } while (endPositionOfTd > 0);
                                                                
                                                        }
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("<tr>" + subStringOfTr2 + "</tr>", stringTrReplace);
                                                    tanpaeditor = tanpaeditor.replace("<tr>" + subStringOfTr2 + "</tr>", stringTrReplace);
                                                    //tutup perulanganya
                                                        
                                                    //setelah baca td maka akan membuat td baru... disini
                                                        
                                                    residueOfTextString = residueOfTextString.substring(endPositionOfTable, residueOfTextString.length());
                                                        
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                        
                                                } while (endPositionOfTable > 0);
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                    
                                            } else if (objectType.equals("LISTMUTATION") && objectStatusField.equals("START")) {
                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                add = "<a href=\"javascript:cmdAddEmpNew('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                 add = "";   
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                    
                                                    
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                do {
                                                    //cari tag table pembuka
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
                                                    //mencari body 
                                                    int startPositionOfBody = subStringOfTable.indexOf("<tbody>") + "<tbody>".length();
                                                    int endPositionOfBody = subStringOfTable.indexOf("</tbody>", startPositionOfBody);
                                                    String subStringOfBody = subStringOfTable.substring(startPositionOfBody, endPositionOfBody);//isi body
                                                        
                                                    //mencari tr pertama pada table
                                                    int startPositionOfTr1 = subStringOfBody.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr1 = subStringOfBody.indexOf("</tr>", startPositionOfTr1);
                                                    String subStringOfTr1 = subStringOfBody.substring(startPositionOfTr1, endPositionOfTr1);
                                                        
                                                    String subStringOfBody2 = subStringOfBody.substring(endPositionOfTr1, subStringOfBody.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr2 = subStringOfBody2.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr2 = subStringOfBody2.indexOf("</tr>", startPositionOfTr2);
                                                    String subStringOfTr2 = subStringOfBody2.substring(startPositionOfTr2, endPositionOfTr2);
                                                        
                                                    String subStringOfBody3 = subStringOfBody2.substring(endPositionOfTr2, subStringOfBody2.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr3 = subStringOfBody3.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr3 = subStringOfBody3.indexOf("</tr>", startPositionOfTr3);
                                                    String subStringOfTr3 = subStringOfBody3.substring(startPositionOfTr3, endPositionOfTr3);
                                                        
                                                    String subStringOfBody4 = subStringOfBody3.substring(endPositionOfTr3, subStringOfBody3.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr4 = subStringOfBody4.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr4 = subStringOfBody4.indexOf("</tr>", startPositionOfTr4);
                                                    String subStringOfTr4 = subStringOfBody4.substring(startPositionOfTr4, endPositionOfTr4);
                                                        
                                                    String subStringOfBody5 = subStringOfBody4.substring(endPositionOfTr4, subStringOfBody4.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr5 = subStringOfBody5.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr5 = subStringOfBody5.indexOf("</tr>", startPositionOfTr5);
                                                    String subStringOfTr5 = subStringOfBody5.substring(startPositionOfTr5, endPositionOfTr5);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "";
                                                    if (listEmp.size() > 0) {
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                                
                                                            //cek nilai ada object atau tidak
                                                            stringTrReplace = stringTrReplace + "<tr>";
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTr2 = subStringOfTr5;
                                                            int jumlahtd = 0;
                                                            do {
                                                                stringTrReplace = stringTrReplace + "<td>";
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                subStringOfTd = residuOfsubStringOfTr2.substring(startPositionOfTd, endPositionOfTd);//isi table 
                                                                    
                                                                int startPositionOfFormula = 0;
                                                                int endPositionOfFormula = 0;
                                                                String subStringOfFormula = "";
                                                                String residuOfsubStringOfTd = subStringOfTd;
                                                                do {
                                                                    try {
                                                                        startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                        endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                        subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                                        String[] partsOfFormula = subStringOfFormula.split("-");
                                                                        String objectNameFormula = partsOfFormula[0];
                                                                        String objectTypeFormula = partsOfFormula[1];
                                                                        String objectTableFormula = partsOfFormula[2];
                                                                        String objectStatusFormula = partsOfFormula[3];
                                                                        String value = "";
                                                                        if (objectTableFormula.equals("EMPLOYEE")) {
                                                                            if (objectStatusFormula.equals("NEW_POSITION")) {
                                                                                 //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                                String select = "";
                                                                                if(isApproved == false){
                                                                                     select = "<a href=\"javascript:cmdSelectPos('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "','" + employeeFetch.getOID() + "')\">SELECT</a></br>";
                                                                                }else{
                                                                                    select = ""; 
                                                                                }   
                                                                                String newposition = PstEmpDocListMutation.getNewPosition(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "-" + select;
                                                                                value = "-" + newposition;
                                                                            } else {
                                                                                if (objectStatusFormula.equals("NEW_GRADE_LEVEL_ID")) {
                                                                                    String newGrade = PstEmpDocListMutation.getNewGradeLevel(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                    value = "-" + newGrade;
                                                                                } else if (objectStatusFormula.equals("NEW_HISTORY_TYPE")) {
                                                                                    String newHistoryType = PstEmpDocListMutation.getNewHistoryType(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                    value = "-" + newHistoryType;
                                                                                } else {
                                                                                    value = (String) HashtableEmp.get(objectStatusFormula);
                                                                                }
                                                                                    
                                                                            }
                                                                        } else {
                                                                            System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                        }
                                                                            
                                                                        stringTrReplace = stringTrReplace + value;
                                                                            
                                                                        residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                                        endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    } catch (Exception e) {
                                                                        System.out.printf(e + "");
                                                                    }
                                                                } while (endPositionOfFormula > 0);
                                                                residuOfsubStringOfTr2 = residuOfsubStringOfTr2.substring(endPositionOfTd, residuOfsubStringOfTr2.length());
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                jumlahtd = jumlahtd + 1;
                                                                stringTrReplace = stringTrReplace + "</td>";
                                                            } while (endPositionOfTd > 0);
                                                        }
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("<tr>" + subStringOfTr5 + "</tr>", stringTrReplace);
                                                    tanpaeditor = tanpaeditor.replace("<tr>" + subStringOfTr5 + "</tr>", stringTrReplace);
                                                    //tutup perulanganya
                                                        
                                                    //setelah baca td maka akan membuat td baru... disini
                                                        
                                                    residueOfTextString = residueOfTextString.substring(endPositionOfTable, residueOfTextString.length());
                                                        
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                        
                                                } while (endPositionOfTable > 0);
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                    
                                            } else if (objectType.equals("LISTEMPLOYEE") && objectStatusField.equals("START")) {
                                                 //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                    add = "<a href=\"javascript:cmdAddEmpNew('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                    add = "";   
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                    
                                                    
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                
                                                    //cari tag table pembuka
                                                    
                                                        
                                                    //mencari body 
                                                    String table = "<table id=\"0\">";
                                                    startPositionOfTable = residueOfTextString.indexOf(table) + table.length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
//                                                    String subStringOfBody5 = subStringOfBody4.substring(endPositionOfTr4, subStringOfBody4.length());//isi body setelah dipotong tr pertama
//                                                    int startPositionOfTr5 = subStringOfBody5.indexOf("<tr>") + "<tr>".length();
//                                                    int endPositionOfTr5 = subStringOfBody5.indexOf("</tr>", startPositionOfTr5);
//                                                    String subStringOfTr5 = subStringOfBody5.substring(startPositionOfTr5, endPositionOfTr5);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "";
                                                    double grandTotal = 0;
                                                    if (listEmp.size() > 0) {
                                                        String empList = "";
                                                        for (int idx=0; idx < listEmp.size(); idx++){
                                                            EmpDocList emp = (EmpDocList) listEmp.get(idx);
                                                            empList = empList + "," + emp.getEmployee_id();
                                                        }
                                                        empList = empList.substring(1);
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                            
                                                            
                                                            //cek nilai ada object atau tidak
                                                            stringTrReplace = stringTrReplace + "<table id=\""+list+"\">";
                                                            stringTrReplace = stringTrReplace + subStringOfTable +"</table>";
                                                            
                                                            //cari tag table pembuka hasil looping
                                                            String tagTable = "<table id=\""+list+"\">";
                                                            int startPositionOfTableLoop = stringTrReplace.indexOf(tagTable) + tagTable.length();
                                                            int endPositionOfTableLoop = stringTrReplace.indexOf("</table>", startPositionOfTableLoop);
                                                            String subStringOfTableLoop = stringTrReplace.substring(startPositionOfTableLoop, endPositionOfTableLoop);//isi table 

                                                            //mencari body 
                                                            int startPositionOfBody = subStringOfTableLoop.indexOf("<tbody>") + "<tbody>".length();
                                                            int endPositionOfBody = subStringOfTableLoop.indexOf("</tbody>", startPositionOfBody);
                                                            String subStringOfBody = subStringOfTableLoop.substring(startPositionOfBody, endPositionOfBody);//isi body

                                                            
                                                            int startPositionOfTable1 = stringTrReplace.indexOf(tagTable) + tagTable.length();
                                                            int endPositionOfTable1 = stringTrReplace.indexOf("</table>", startPositionOfTable1);
                                                            String subStringOfTable1 = stringTrReplace.substring(startPositionOfTable1, endPositionOfTable1);//isi table 

                                                            
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTd = subStringOfTable1;
                                                            int jumlahtd = 0;
                                                            int startPositionOfFormula = 0;
                                                            int endPositionOfFormula = 0;
                                                            String subStringOfFormula = "";
                                                            do {
                                                                try {
                                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                                    
                                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                                    String objectNameFormula = partsOfFormula[0];
                                                                    String objectTypeFormula = partsOfFormula[1];
                                                                    String objectTableFormula = partsOfFormula[2];
                                                                    String objectStatusFormula = partsOfFormula[3];
                                                                    String value = "";
                                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                                        if (objectStatusFormula.equals("NEW_POSITION")) {
                                                                            //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                            String select = "";
                                                                            if(isApproved == false){
                                                                                 select = "<a href=\"javascript:cmdSelectPos('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "','" + employeeFetch.getOID() + "')\">SELECT</a></br>";
                                                                            }else{
                                                                                 select = "";
                                                                            }
                                                                            String newposition = PstEmpDocListMutation.getNewPosition(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "-" + select;
                                                                            value = "-" + newposition;
                                                                        } else {
                                                                            if (objectStatusFormula.equals("NEW_GRADE_LEVEL_ID")) {
                                                                                String newGrade = PstEmpDocListMutation.getNewGradeLevel(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newGrade;
                                                                            } else if (objectStatusFormula.equals("NEW_HISTORY_TYPE")) {
                                                                                String newHistoryType = PstEmpDocListMutation.getNewHistoryType(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newHistoryType;
                                                                            } else  {
                                                                                value = (String) HashtableEmp.get(objectStatusFormula);
                                                                            }

                                                                        }
                                                                    } else if (objectTableFormula.equals("NUMBER")) { 
                                                                        if (objectStatusFormula.equals("NO")) {
                                                                            value = ""+(list+1);
                                                                        }
                                                                    } else {
                                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                    }

                                                                    stringTrReplace = stringTrReplace.replace("${" + objectNameFormula + "-" + objectTypeFormula + "-" + objectTableFormula + "-" + objectStatusFormula + "}", value);

                                                                    residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    
                                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                } catch (Exception e) {
                                                                    System.out.printf(e + "");
                                                                }
                                                            } while (endPositionOfFormula > 0);
                                                        }
                                                    }
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace(subStringOfTable, stringTrReplace);
                                                tanpaeditor = tanpaeditor.replace(subStringOfTable, stringTrReplace);    
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("<table id=\"0\"><table id=\"0\">", "<table id=\"0\">");
                                                tanpaeditor = tanpaeditor.replace("<table id=\"0\"><table id=\"0\">", "<table id=\"0\">");
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("</table></table>", "</table>");
                                                tanpaeditor = tanpaeditor.replace("</table></table>", "</table>"); 
                                            }
                                                else if (objectType.equals("LISTDOCEXPENSEBA") && objectStatusField.equals("START")) {
                                              
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "");
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                
                                                String noRek = PstSystemProperty.getValueByName("NO_REKENING_SPJ");
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${TRAINNER2-LISTDOCEXPENSEBA-EMPLOYEE-NO_REK_DEBET_SPJ}", noRek);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${TRAINNER2-LISTDOCEXPENSEBA-COMPONENT-GRAND_TOTAL}", Formater.formatNumber(PstEmpDocListExpense.getTotal(oidEmpDoc), ""));                                                   
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                do {
                                                    //cari tag table pembuka
                                                    String table = "<table id=\"kredit\">";
                                                    startPositionOfTable = residueOfTextString.indexOf(table) + table.length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
                                                    //mencari body 
                                                    int startPositionOfBody = subStringOfTable.indexOf("<tbody>") + "<tbody>".length();
                                                    int endPositionOfBody = subStringOfTable.indexOf("</tbody>", startPositionOfBody);
                                                    String subStringOfBody = subStringOfTable.substring(startPositionOfBody, endPositionOfBody);//isi body
                                                        
                                                    //mencari tr pertama pada table
                                                    int startPositionOfTr1 = subStringOfBody.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr1 = subStringOfBody.indexOf("</tr>", startPositionOfTr1);
                                                    String subStringOfTr1 = subStringOfBody.substring(startPositionOfTr1, endPositionOfTr1);
                                                        
                                                    String subStringOfBody2 = subStringOfBody.substring(endPositionOfTr1, subStringOfBody.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr2 = subStringOfBody2.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr2 = subStringOfBody2.indexOf("</tr>", startPositionOfTr2);
                                                    String subStringOfTr2 = subStringOfBody2.substring(startPositionOfTr2, endPositionOfTr2);
                                                        
                                                    String subStringOfBody3 = subStringOfBody2.substring(endPositionOfTr2, subStringOfBody2.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr3 = subStringOfBody3.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr3 = subStringOfBody3.indexOf("</tr>", startPositionOfTr3);
                                                    String subStringOfTr3 = subStringOfBody3.substring(startPositionOfTr3, endPositionOfTr3);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "<tr>";
                                                    stringTrReplace = stringTrReplace + subStringOfTr1 + "</tr>";
                                                    if (listEmp.size() > 0) {
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                                
                                                            
                                                            //cek nilai ada object atau tidak
                                                            stringTrReplace = stringTrReplace + "<tr>";
                                                            stringTrReplace = stringTrReplace + subStringOfTr2 + "</tr>";
                                                            stringTrReplace = stringTrReplace + "<tr>";
                                                            stringTrReplace = stringTrReplace + subStringOfTr3 + "</tr>";                                                            
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTr = subStringOfTr2+subStringOfTr3;
                                                            int startPositionOfFormula = 0;
                                                            int endPositionOfFormula = 0;
                                                            String subStringOfFormula = "";
                                                            int jumlahtd = 0;
                                                            do {
                                                                try {
                                                                    startPositionOfFormula = residuOfsubStringOfTr.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTr.indexOf("}", startPositionOfFormula);
                                                                    subStringOfFormula = residuOfsubStringOfTr.substring(startPositionOfFormula, endPositionOfFormula);//isi table 

                                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                                    String objectNameFormula = partsOfFormula[0];
                                                                    String objectTypeFormula = partsOfFormula[1];
                                                                    String objectTableFormula = partsOfFormula[2];
                                                                    String objectStatusFormula = partsOfFormula[3];
                                                                    String value = "";
                                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                                        if (objectStatusFormula.equals("NEW_POSITION")) {
                                                                            //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                            String select = "";
                                                                            if(isApproved == false){
                                                                                select = "<a href=\"javascript:cmdSelectPos('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "','" + employeeFetch.getOID() + "')\">SELECT</a></br>";
                                                                            }else{
                                                                                select = "";
                                                                            }
                                                                            String newposition = PstEmpDocListMutation.getNewPosition(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "-" + select;
                                                                            value = "-" + newposition;
                                                                        } else {
                                                                            if (objectStatusFormula.equals("NEW_GRADE_LEVEL_ID")) {
                                                                                String newGrade = PstEmpDocListMutation.getNewGradeLevel(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newGrade;
                                                                            } else if (objectStatusFormula.equals("NEW_HISTORY_TYPE")) {
                                                                                String newHistoryType = PstEmpDocListMutation.getNewHistoryType(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newHistoryType;
                                                                            } else  {
                                                                                value = (String) HashtableEmp.get(objectStatusFormula);
                                                                            }

                                                                        }
                                                                    } else if (objectTableFormula.equals("COMPONENT")) {
                                                                        if (objectStatusFormula.equals("COMP_TOTAL_ALL")){
                                                                                value = Formater.formatNumber(PstEmpDocListExpense.getTotalPerEmployee(empDocList.getEmployee_id(), oidEmpDoc), "");
                                                                            } else if (objectStatusFormula.equals("GRAND_TOTAL")){
                                                                                value = Formater.formatNumber(PstEmpDocListExpense.getTotal(oidEmpDoc), "");
                                                                            } else  {
                                                                            value = "-";
                                                                            }
                                                                    } else {
                                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                    }


//                                                                 
                                                                    stringTrReplace = stringTrReplace.replace("${" + objectNameFormula + "-" + objectTypeFormula + "-" + objectTableFormula + "-" + objectStatusFormula + "}", value);
//                                                                  
                                                                    residuOfsubStringOfTr = residuOfsubStringOfTr.substring(endPositionOfFormula, residuOfsubStringOfTr.length());
                                                                    endPositionOfFormula = residuOfsubStringOfTr.indexOf("}", startPositionOfFormula);

                                                                    startPositionOfFormula = residuOfsubStringOfTr.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTr.indexOf("}", startPositionOfFormula);

                                                                } catch (Exception e) {
                                                                    System.out.printf(e + "");
                                                                }
                                                            } while (endPositionOfFormula > 0);
                                                        }
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace(subStringOfBody, stringTrReplace);
                                                    tanpaeditor = tanpaeditor.replace(subStringOfBody, stringTrReplace);
                                                    //tutup perulanganya
                                                        
                                                    //setelah baca td maka akan membuat td baru... disini
                                                        
                                                    residueOfTextString = residueOfTextString.substring(endPositionOfTable, residueOfTextString.length());
                                                        
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                        
                                                } while (endPositionOfTable > 0);
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                                                                
                                            } else if (objectType.equals("LISTDOCEXPENSE") && objectStatusField.equals("START")) {
                                                typeAction= 4;
												typeExpense = 1;
                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                     add = "<a href=\"javascript:cmdAddEmpNewDocExpense('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                     add = "";
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                    
                                                    
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                
                                                    //cari tag table pembuka
                                                    
                                                        
                                                    //mencari body 
                                                    String table = "<table id=\"0\">";
                                                    startPositionOfTable = residueOfTextString.indexOf(table) + table.length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
//                                                    String subStringOfBody5 = subStringOfBody4.substring(endPositionOfTr4, subStringOfBody4.length());//isi body setelah dipotong tr pertama
//                                                    int startPositionOfTr5 = subStringOfBody5.indexOf("<tr>") + "<tr>".length();
//                                                    int endPositionOfTr5 = subStringOfBody5.indexOf("</tr>", startPositionOfTr5);
//                                                    String subStringOfTr5 = subStringOfBody5.substring(startPositionOfTr5, endPositionOfTr5);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "";
                                                    double grandTotal = 0;
                                                    if (listEmp.size() > 0) {
                                                        String empList = "";
                                                        for (int idx=0; idx < listEmp.size(); idx++){
                                                            EmpDocList emp = (EmpDocList) listEmp.get(idx);
                                                            empList = empList + "," + emp.getEmployee_id();
                                                        }
                                                        empList = empList.substring(1);
                                                        //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                        String addcomp = "";
                                                        if(isApproved == false){
                                                            addcomp = "<a href=\"javascript:cmdAddComp('" + objectName + "','" + oidEmpDoc + "','" + empList + "' )\">add component</a></br>";
                                                        }else{
                                                            addcomp = "";
                                                        }
                                                        
                                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${TRAINNER2-LISTDOCEXPENSE-COMPONENT-ADD}", addcomp);
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                            Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                            
                                                            
                                                            //cek nilai ada object atau tidak
                                                            stringTrReplace = stringTrReplace + "<table id=\""+list+"\">";
                                                            stringTrReplace = stringTrReplace + subStringOfTable +"</table>";
                                                            
                                                            //cari tag table pembuka hasil looping
                                                            String tagTable = "<table id=\""+list+"\">";
                                                            int startPositionOfTableLoop = stringTrReplace.indexOf(tagTable) + tagTable.length();
                                                            int endPositionOfTableLoop = stringTrReplace.indexOf("</table>", startPositionOfTableLoop);
                                                            String subStringOfTableLoop = stringTrReplace.substring(startPositionOfTableLoop, endPositionOfTableLoop);//isi table 

                                                            //mencari body 
                                                            int startPositionOfBody = subStringOfTableLoop.indexOf("<tbody>") + "<tbody>".length();
                                                            int endPositionOfBody = subStringOfTableLoop.indexOf("</tbody>", startPositionOfBody);
                                                            String subStringOfBody = subStringOfTableLoop.substring(startPositionOfBody, endPositionOfBody);//isi body

                                                            //mencari tr pertama pada table
                                                            int startPositionOfTr1 = subStringOfBody.indexOf("<tr>") + "<tr>".length();
                                                            int endPositionOfTr1 = subStringOfBody.indexOf("</tr>", startPositionOfTr1);
                                                            String subStringOfTr1 = subStringOfBody.substring(startPositionOfTr1, endPositionOfTr1);

                                                            String subStringOfBody2 = subStringOfBody.substring(endPositionOfTr1, subStringOfBody.length());//isi body setelah dipotong tr pertama
                                                            int startPositionOfTr2 = subStringOfBody2.indexOf("<tr>") + "<tr>".length();
                                                            int endPositionOfTr2 = subStringOfBody2.indexOf("</tr>", startPositionOfTr2);
                                                            String subStringOfTr2 = subStringOfBody2.substring(startPositionOfTr2, endPositionOfTr2);

                                                            String subStringOfBody3 = subStringOfBody2.substring(endPositionOfTr2, subStringOfBody2.length());//isi body setelah dipotong tr pertama
                                                            int startPositionOfTr3 = subStringOfBody3.indexOf("<tr>") + "<tr>".length();
                                                            int endPositionOfTr3 = subStringOfBody3.indexOf("</tr>", startPositionOfTr3);
                                                            String subStringOfTr3 = subStringOfBody3.substring(startPositionOfTr3, endPositionOfTr3);

                                                            //mengisi componen
                                                            String whereComp = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID] + " = " + empDocList.getEmployee_id() + ""
                                                                                + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID] + " = " + oidEmpDoc;
                                                            Vector listComponent = PstEmpDocListExpense.list(0, 0, whereComp, "");
                                                            
                                                            String stringCompReplace = "";
                                                            double jumlahComp = 0;
                                                            if (listComponent.size() > 0) {
                                                                for (int idx = 0; idx < listComponent.size(); idx++){
                                                                    
                                                                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listComponent.get(idx);
                                                                    PayComponent compFetch = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                                                                    Hashtable HashtableComp = PstEmpDoc.fetchExcHashtableComponent(empDocListExpense.getOID());
                                                                    
                                                                    stringCompReplace = stringCompReplace + "<tr>";
                                                                    stringCompReplace = stringCompReplace + subStringOfTr3 +"</tr>";
                                                                    
                                                                    int startPositionOfCompTd = 0;
                                                                    int endPositionofCompTd = 0;
                                                                    String subStringOfComTd = "";
                                                                    String residuOfsubStringOfCompTr3 = subStringOfTr3;
                                                                    int jumlahtd = 0;
                                                                    int startPositionOfFormula = 0;
                                                                    int endPositionOfFormula = 0;
                                                                    String subStringOfFormula = "";
                                                                    int day = 0;
                                                                    double compValue = 0;
                                                                    do {
                                                                        try {
                                                                            startPositionOfFormula = residuOfsubStringOfCompTr3.indexOf("${") + "${".length();
                                                                            endPositionOfFormula = residuOfsubStringOfCompTr3.indexOf("}", startPositionOfFormula);
                                                                            subStringOfFormula = residuOfsubStringOfCompTr3.substring(startPositionOfFormula, endPositionOfFormula);//isi table 

                                                                            String[] partsOfFormula = subStringOfFormula.split("-");
                                                                            String objectNameFormula = partsOfFormula[0];
                                                                            String objectTypeFormula = partsOfFormula[1];
                                                                            String objectTableFormula = partsOfFormula[2];
                                                                            String objectStatusFormula = partsOfFormula[3];
                                                                            String value = "";
                                                                            if (objectTableFormula.equals("COMPONENT")) {
                                                                                if (objectStatusFormula.equals("COMP_NAME")) {
                                                                                    value = (String) HashtableComp.get(objectStatusFormula);
                                                                                } else if (objectStatusFormula.equals("DAY_LENGTH")) {
                                                                                    //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                                    String editDay = "";
                                                                                    if(isApproved == false){
                                                                                        editDay = "<a href=\"javascript:cmdEditDay('" + empDocListExpense.getOID() + "' )\">edit</a></br>";
                                                                                    }else{
                                                                                        editDay = "";
                                                                                    }
                                                                                    value = (String) HashtableComp.get(objectStatusFormula);
                                                                                    day = Integer.valueOf(value);
                                                                                    value = value + " " + editDay;
                                                                                } else if (objectStatusFormula.equals("COMP_VALUE")){
                                                                                    value = (String) HashtableComp.get(objectStatusFormula);
                                                                                    compValue = Double.valueOf(value);
                                                                                    value = Formater.formatNumber(compValue, "");
                                                                                    
                                                                                } else if (objectStatusFormula.equals("COMP_TOTAL_VALUE")){
                                                                                    double total = day * compValue;
                                                                                    value = Formater.formatNumber(total, "");
                                                                                    jumlahComp = jumlahComp + total;
                                                                                    grandTotal = grandTotal + total;
                                                                                }
                                                                            } else {
                                                                                System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                            }
                                                                            

                                                                            if (objectTableFormula.equals("COMPONENT")){
                                                                                stringCompReplace = stringCompReplace.replace("${" + objectNameFormula + "-" + objectTypeFormula + "-" + objectTableFormula + "-" + objectStatusFormula + "}", value);
                                                                            }
                                                                            residuOfsubStringOfCompTr3 = residuOfsubStringOfCompTr3.substring(endPositionOfFormula, residuOfsubStringOfCompTr3.length());
                                                                            endPositionOfFormula = residuOfsubStringOfCompTr3.indexOf("}", startPositionOfFormula);

                                                                            startPositionOfFormula = residuOfsubStringOfCompTr3.indexOf("${") + "${".length();
                                                                            endPositionOfFormula = residuOfsubStringOfCompTr3.indexOf("}", startPositionOfFormula);
                                                                            
                                                                        } catch (Exception e) {
                                                                            System.out.printf(e + "");
                                                                        }
                                                                    } while (endPositionOfFormula > 0);
                                                                    
                                                                }
                                                            }
                                                            
                                                            stringTrReplace = stringTrReplace.replace(subStringOfTr3, stringCompReplace);
                                                            
                                                            int startPositionOfTable1 = stringTrReplace.indexOf(tagTable) + tagTable.length();
                                                            int endPositionOfTable1 = stringTrReplace.indexOf("</table>", startPositionOfTable1);
                                                            String subStringOfTable1 = stringTrReplace.substring(startPositionOfTable1, endPositionOfTable1);//isi table 

                                                            
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTd = subStringOfTable1;
                                                            int jumlahtd = 0;
                                                            int startPositionOfFormula = 0;
                                                            int endPositionOfFormula = 0;
                                                            String subStringOfFormula = "";
                                                            do {
                                                                try {
                                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                                    
                                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                                    String objectNameFormula = partsOfFormula[0];
                                                                    String objectTypeFormula = partsOfFormula[1];
                                                                    String objectTableFormula = partsOfFormula[2];
                                                                    String objectStatusFormula = partsOfFormula[3];
                                                                    String value = "";
                                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                                        if (objectStatusFormula.equals("NEW_POSITION")) {
                                                                            //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                            String select = "";
                                                                            if(isApproved == false){
                                                                                 select = "<a href=\"javascript:cmdSelectPos('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "','" + employeeFetch.getOID() + "')\">SELECT</a></br>";
                                                                            }else{
                                                                                 select = "";
                                                                            }
                                                                            String newposition = PstEmpDocListMutation.getNewPosition(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "-" + select;
                                                                            value = "-" + newposition;
                                                                        } else {
                                                                            if (objectStatusFormula.equals("NEW_GRADE_LEVEL_ID")) {
                                                                                String newGrade = PstEmpDocListMutation.getNewGradeLevel(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newGrade;
                                                                            } else if (objectStatusFormula.equals("NEW_HISTORY_TYPE")) {
                                                                                String newHistoryType = PstEmpDocListMutation.getNewHistoryType(oidEmpDoc, employeeFetch.getOID(), objectNameFormula) + "";
                                                                                value = "-" + newHistoryType;
                                                                            } else  {
                                                                                value = (String) HashtableEmp.get(objectStatusFormula);
                                                                            }

                                                                        }
                                                                    } else if (objectTableFormula.equals("COMPONENT")) {
                                                                        if (objectStatusFormula.equals("COMP_TOTAL_ALL")){
                                                                                value = Formater.formatNumber(jumlahComp, "");
                                                                            } else {
                                                                            value = "-";
                                                                            }
                                                                    } else if (objectTableFormula.equals("BUTTON")) {
                                                                            if (objectStatusFormula.equals("DELETE")){
                                                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                                if(isApproved == false){
                                                                                    value = "<a href=\"javascript:cmdDeleteEmployee('" + oidEmpDoc + "','" + employeeFetch.getOID() + "','" + objectNameFormula + "' )\">delete</a></br>";
                                                                                }else{
                                                                                    value = "";
                                                                            }
                                                                            }
                                                                    } else {
                                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                    }

                                                                    stringTrReplace = stringTrReplace.replace("${" + objectNameFormula + "-" + objectTypeFormula + "-" + objectTableFormula + "-" + objectStatusFormula + "}", value);

                                                                    residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    
                                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                } catch (Exception e) {
                                                                    System.out.printf(e + "");
                                                                }
                                                            } while (endPositionOfFormula > 0);
                                                        }
                                                    }
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${TRAINNER2-LISTDOCEXPENSE-COMPONENT-ADD}", "");
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${TRAINNER2-LISTDOCEXPENSE-COMPONENT-GRAND_TOTAL}", ""+Formater.formatNumber(grandTotal,""));
                                                       
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace(subStringOfTable, stringTrReplace);
                                                tanpaeditor = tanpaeditor.replace(subStringOfTable, stringTrReplace);    
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("<table id=\"0\"><table id=\"0\">", "<table id=\"0\">");
                                                tanpaeditor = tanpaeditor.replace("<table id=\"0\"><table id=\"0\">", "<table id=\"0\">");
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("</table></table>", "</table>");
                                                tanpaeditor = tanpaeditor.replace("</table></table>", "</table>");    
                                                
                                            }  else if (objectType.equals("LISTPENERIMAAN") && objectStatusField.equals("START")) {
                                                typeAction = 1;
                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                    add = "<a href=\"javascript:cmdAddPenerimaan('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                    add = "";
                                                }
                                                
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                //mencari jumlah table table
                                                int startPositionOfTable = 0;
                                                int endPositionOfTable = 0;
                                                String subStringOfTable = "";
                                                String residueOfTextString = textString;
                                                do {
                                                    //cari tag table pembuka
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    //int tt = textString.indexOf("&lttable") + ((textString.indexOf("&gt") + 3)-textString.indexOf("&lttable"));
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                    subStringOfTable = residueOfTextString.substring(startPositionOfTable, endPositionOfTable);//isi table 
                                                        
                                                    //mencari body 
                                                    int startPositionOfBody = subStringOfTable.indexOf("<tbody>") + "<tbody>".length();
                                                    int endPositionOfBody = subStringOfTable.indexOf("</tbody>", startPositionOfBody);
                                                    String subStringOfBody = subStringOfTable.substring(startPositionOfBody, endPositionOfBody);//isi body
                                                        
                                                    //mencari tr pertama pada table
                                                    int startPositionOfTr1 = subStringOfBody.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr1 = subStringOfBody.indexOf("</tr>", startPositionOfTr1);
                                                    String subStringOfTr1 = subStringOfBody.substring(startPositionOfTr1, endPositionOfTr1);
                                                        
                                                    String subStringOfBody2 = subStringOfBody.substring(endPositionOfTr1, subStringOfBody.length());//isi body setelah dipotong tr pertama
                                                    int startPositionOfTr2 = subStringOfBody2.indexOf("<tr>") + "<tr>".length();
                                                    int endPositionOfTr2 = subStringOfBody2.indexOf("</tr>", startPositionOfTr2);
                                                    String subStringOfTr2 = subStringOfBody2.substring(startPositionOfTr2, endPositionOfTr2);
                                                        
                                                    //disini diisi perulanganya
                                                        
                                                    String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                        
                                                    //baca table dibawahnya
                                                        
                                                    String stringTrReplace = "";
                                                    if (listEmp != null && listEmp.size() > 0) {
                                                        for (int list = 0; list < listEmp.size(); list++) {
                                                            EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                            RecrApplication appLetter = PstRecrApplication.fetchExc(empDocList.getEmployee_id());
                                                            //cek nilai ada object atau tidak
                                                            stringTrReplace = stringTrReplace + "<tr>";
                                                            //menghitung jumlah td html
                                                            int startPositionOfTd = 0;
                                                            int endPositionOfTd = 0;
                                                            String subStringOfTd = "";
                                                            String residuOfsubStringOfTr2 = subStringOfTr2;
                                                            int jumlahtd = 0;
                                                            do {
                                                                stringTrReplace = stringTrReplace + "<td>";
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                subStringOfTd = residuOfsubStringOfTr2.substring(startPositionOfTd, endPositionOfTd);//isi table 

                                                                int startPositionOfFormula = 0;
                                                                int endPositionOfFormula = 0;
                                                                String subStringOfFormula = "";
                                                                String residuOfsubStringOfTd = subStringOfTd;
                                                                do {
                                                                    try {
                                                                        startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                                        endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                        subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                                        String[] partsOfFormula = subStringOfFormula.split("-");
                                                                        String objectNameFormula = partsOfFormula[0];
                                                                        String objectTypeFormula = partsOfFormula[1];
                                                                        String objectTableFormula = partsOfFormula[2];
                                                                        String objectStatusFormula = partsOfFormula[3];
                                                                        String value = "";
                                                                        if (objectTableFormula.equals("EMPLOYEE")) {
                                                                            if (objectStatusFormula.equals("NOMOR")) {
                                                                                value = String.valueOf(list+1);
                                                                            } else if (objectStatusFormula.equals("FULL_NAME")) {
                                                                                value = appLetter.getFullName();
                                                                            } else if (objectStatusFormula.equals("POSITION")) {
                                                                                //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                                                String select = "";
                                                                                if(isApproved == false){
                                                                                    select = "<a href=\"javascript:cmdSelectPos('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "','" + empDocList.getEmployee_id() + "')\">SELECT</a>";
                                                                                }else{
                                                                                    select = "";
                                                                                }
                                                                                value = appLetter.getPosition()+" ("+select+")";
                                                                            }
                                                                        } else {
                                                                            System.out.print("Selain Object Employee belum bisa dipanggil");
                                                                        }

                                                                        stringTrReplace = stringTrReplace + value;

                                                                        residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                                        endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                                    } catch (Exception e) {
                                                                        System.out.printf(e + "");
                                                                    }
                                                                } while (endPositionOfFormula > 0);
                                                                residuOfsubStringOfTr2 = residuOfsubStringOfTr2.substring(endPositionOfTd, residuOfsubStringOfTr2.length());
                                                                startPositionOfTd = residuOfsubStringOfTr2.indexOf("<td>") + "<td>".length();
                                                                endPositionOfTd = residuOfsubStringOfTr2.indexOf("</td>", startPositionOfTd);
                                                                jumlahtd = jumlahtd + 1;
                                                                stringTrReplace = stringTrReplace + "</td>";
                                                            } while (endPositionOfTd > 0);
                                                        }
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("<tr>" + subStringOfTr2 + "</tr>", stringTrReplace);
                                                    tanpaeditor = tanpaeditor.replace("<tr>" + subStringOfTr2 + "</tr>", stringTrReplace);
                                                    //tutup perulanganya
                                                        
                                                    //setelah baca td maka akan membuat td baru... disini
                                                        
                                                    residueOfTextString = residueOfTextString.substring(endPositionOfTable, residueOfTextString.length());
                                                        
                                                    startPositionOfTable = residueOfTextString.indexOf("<table") + "<table".length();
                                                    endPositionOfTable = residueOfTextString.indexOf("</table>", startPositionOfTable);
                                                        
                                                } while (endPositionOfTable > 0);
                                                    
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                            } else if (objectType.equals("REPORT_JV")) {
                                             
                                              long oidPeriod = 0;
                                              long oidDiv = 0;
                                              long companyId = 504404575327187914l;
                                              
                                              String[] divisionSelect = null;
                                              String[] componentSelect = null;
                                                   
                                              oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                              
                                              if (!objectClass.equals("")){
                                                  whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                  Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                  if (divCodeJvList != null && divCodeJvList.size()>0){
                                                      DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                      whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                      Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                      if (divMapList != null && divMapList.size()>0){
                                                          divisionSelect = new String[divMapList.size()];
                                                          for (int i=0; i<divMapList.size(); i++){
                                                              DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                              divisionSelect[i] = ""+divMap.getDivisionId();
                                                          }
                                                      }
                                                  }
                                              }
                                              if (objectStatusField.length()>0){
                                                  whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                  Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                  if (compCodeJvList != null && compCodeJvList.size()>0){
                                                      ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                      whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                      Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                      if (compMapList != null && compMapList.size()>0){
                                                          componentSelect = new String[compMapList.size()];
                                                          for (int i=0; i<compMapList.size(); i++){
                                                              ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                              componentSelect[i] = ""+compMap.getComponentId();
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              String nilaiVal = "";
                                              nilaiVal = JurnalDocument.printJurnal(oidPeriod, divisionSelect, componentSelect);
                                              empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                              tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("REPORT_JV1")) {
                                                /* report dg format berbeda */   
                                                String outString = "";
                                                String[] divisionSelect = null;
                                                String[] componentSelect = null;
                                                long oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                                if (!objectClass.equals("")){
                                                    whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                    Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                    if (divCodeJvList != null && divCodeJvList.size()>0){
                                                        DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                        whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                        Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                        if (divMapList != null && divMapList.size()>0){
                                                            divisionSelect = new String[divMapList.size()];
                                                            for (int i=0; i<divMapList.size(); i++){
                                                                DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                                divisionSelect[i] = ""+divMap.getDivisionId();
                                                            }
                                                        }
                                                    }
                                                }
                                                if (objectStatusField.length()>0){
                                                    whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                    Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                    if (compCodeJvList != null && compCodeJvList.size()>0){
                                                        ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                        whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                        Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                        if (compMapList != null && compMapList.size()>0){
                                                            componentSelect = new String[compMapList.size()];
                                                            for (int i=0; i<compMapList.size(); i++){
                                                                ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                                componentSelect[i] = ""+compMap.getComponentId();
                                                            }
                                                        }
                                                    }
                                                }
                                                /*  printJurnalVersi1 */
                                                outString = JurnalDocument.printJurnalVersi1(oidPeriod, divisionSelect, componentSelect);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                            } else if (objectType.equals("REPORT_JV2")) {
                                                /* report dg format berbeda */   
                                                String outString = "";
                                                String[] divisionSelect = null;
                                                String[] componentSelect = null;
                                                long oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                                if (!objectClass.equals("")){
                                                    whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                    Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                    if (divCodeJvList != null && divCodeJvList.size()>0){
                                                        DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                        whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                        Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                        if (divMapList != null && divMapList.size()>0){
                                                            divisionSelect = new String[divMapList.size()];
                                                            for (int i=0; i<divMapList.size(); i++){
                                                                DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                                divisionSelect[i] = ""+divMap.getDivisionId();
                                                            }
                                                        }
                                                    }
                                                }
                                                if (objectStatusField.length()>0){
                                                    whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                    Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                    if (compCodeJvList != null && compCodeJvList.size()>0){
                                                        ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                        whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                        Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                        if (compMapList != null && compMapList.size()>0){
                                                            componentSelect = new String[compMapList.size()];
                                                            for (int i=0; i<compMapList.size(); i++){
                                                                ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                                componentSelect[i] = ""+compMap.getComponentId();
                                                            }
                                                        }
                                                    }
                                                }
                                                /*  printJurnalVersi1 */
                                                outString = JurnalDocument.printJurnalForPusat(oidPeriod, divisionSelect, componentSelect);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                            } else if (objectType.equals("REPORT_JV3")) {
                                             
                                              long oidPeriod = 0;
                                              long oidDiv = 0;
                                              long companyId = 504404575327187914l;
                                              
                                              String[] divisionSelect = null;
                                              String[] componentSelect = null;
                                                   
                                              oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                              
                                              if (!objectClass.equals("")){
                                                  whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                  Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                  if (divCodeJvList != null && divCodeJvList.size()>0){
                                                      DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                      whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                      Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                      if (divMapList != null && divMapList.size()>0){
                                                          divisionSelect = new String[divMapList.size()];
                                                          for (int i=0; i<divMapList.size(); i++){
                                                              DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                              divisionSelect[i] = ""+divMap.getDivisionId();
                                                          }
                                                      }
                                                  }
                                              }
                                              if (objectStatusField.length()>0){
                                                  whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                  Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                  if (compCodeJvList != null && compCodeJvList.size()>0){
                                                      ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                      whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                      Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                      if (compMapList != null && compMapList.size()>0){
                                                          componentSelect = new String[compMapList.size()];
                                                          for (int i=0; i<compMapList.size(); i++){
                                                              ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                              componentSelect[i] = ""+compMap.getComponentId();
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              String nilaiVal = "";
                                              nilaiVal = JurnalDocument.printJurnalV3(oidPeriod, divisionSelect, componentSelect);
                                              empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                              tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("REPORT_JV4")) {
                                                /* report dg format berbeda */   
                                                String outString = "";
                                                String[] divisionSelect = null;
                                                String[] componentSelect = null;
												
                                                LeaveApplication leaveApplication = new LeaveApplication();
                                                try {
                                                        leaveApplication = PstLeaveApplication.fetchExc(empDoc1.getLeaveId());
                                                } catch (Exception exc){}
												
                                                long oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                                if (!objectClass.equals("")){
                                                    whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                    Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                    if (divCodeJvList != null && divCodeJvList.size()>0){
                                                        DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                        whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                        Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                        if (divMapList != null && divMapList.size()>0){
                                                            divisionSelect = new String[divMapList.size()];
                                                            for (int i=0; i<divMapList.size(); i++){
                                                                DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                                divisionSelect[i] = ""+divMap.getDivisionId();
                                                            }
                                                        }
                                                    }
                                                }
                                                if (objectStatusField.length()>0){
                                                    whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                    Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                    if (compCodeJvList != null && compCodeJvList.size()>0){
                                                        ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                        whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                        Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                        if (compMapList != null && compMapList.size()>0){
                                                            componentSelect = new String[compMapList.size()];
                                                            for (int i=0; i<compMapList.size(); i++){
                                                                ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                                componentSelect[i] = ""+compMap.getComponentId();
                                                            }
                                                        }
                                                    }
                                                }
                                                /*  printJurnalVersi1 */
                                                outString = JurnalDocument.printJurnalBeritaAcara(oidPeriod, divisionSelect, componentSelect, leaveApplication.getEmployeeId(), objectStatusField, empDoc1.getLeaveId(), empDoc1.getOID(), hlistEmpDocField, false);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                            } else if (objectType.equals("JVLEAVE_MULTI")) {
                                                String outString = JurnalDocument.printJurnalBeritaAcaraCuti(empDoc1.getOID(), hlistEmpDocField, false);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", outString);
                                            } else if (objectType.equals("REPORT_JVADJ")) { 
                                                String nilaiVal = "";
                                                nilaiVal = JurnalDocument.drawBAAdjustment(empDoc1.getOID(), objectStatusField);
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("REPORT_JVTOTAL")) {
                                             
                                              long oidPeriod = 0;
                                              long oidDiv = 0;
                                              long companyId = 504404575327187914l;
                                              
                                              String[] divisionSelect = null;
                                              String[] componentSelect = null;
                                                   
                                              oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                              
                                              if (!objectClass.equals("")){
                                                  whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                  Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                  if (divCodeJvList != null && divCodeJvList.size()>0){
                                                      DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                      whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                      Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                      if (divMapList != null && divMapList.size()>0){
                                                          divisionSelect = new String[divMapList.size()];
                                                          for (int i=0; i<divMapList.size(); i++){
                                                              DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                              divisionSelect[i] = ""+divMap.getDivisionId();
                                                          }
                                                      }
                                                  }
                                              }
                                              if (objectStatusField.length()>0){
                                                  whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                  Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                  if (compCodeJvList != null && compCodeJvList.size()>0){
                                                      ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                      whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                      Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                      if (compMapList != null && compMapList.size()>0){
                                                          componentSelect = new String[compMapList.size()];
                                                          for (int i=0; i<compMapList.size(); i++){
                                                              ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                              componentSelect[i] = ""+compMap.getComponentId();
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              String nilaiVal = "";
                                              nilaiVal = JurnalDocument.printJurnalWithTotal(oidPeriod, divisionSelect, componentSelect);
                                              empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                              tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("REPORT_JVSENTRAL")) {
                                                long oidPeriod = 0;
                                                String[] componentSelect = null;
                                                
                                                oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                                if (objectStatusField.length()>0){
                                                  whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                  Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                  if (compCodeJvList != null && compCodeJvList.size()>0){
                                                      ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                      whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                      Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                      if (compMapList != null && compMapList.size()>0){
                                                          componentSelect = new String[compMapList.size()];
                                                          for (int i=0; i<compMapList.size(); i++){
                                                              ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                              componentSelect[i] = ""+compMap.getComponentId();
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              String nilaiVal = "";
                                              nilaiVal = JurnalDocument.printJurnalMapping(oidPeriod, componentSelect);
                                              empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                              tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("REPORT_JVSUMMARY")) {
                                             
                                              long oidPeriod = 0;
                                              long oidDiv = 0;
                                              long companyId = 504404575327187914l;
                                              
                                              String[] divisionSelect = null;
                                              String[] componentSelect = null;
                                                   
                                              oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(empDoc1.getRequest_date());
                                              
                                              if (!objectClass.equals("")){
                                                  whereClause = PstDivisionCodeJv.fieldNames[PstDivisionCodeJv.FLD_DIVISION_CODE]+"='"+objectClass+"'";
                                                  Vector divCodeJvList = PstDivisionCodeJv.list(0, 0, whereClause, "");
                                                  if (divCodeJvList != null && divCodeJvList.size()>0){
                                                      DivisionCodeJv divCodeObj = (DivisionCodeJv)divCodeJvList.get(0);
                                                      whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCodeObj.getOID();
                                                      Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                                      if (divMapList != null && divMapList.size()>0){
                                                          divisionSelect = new String[divMapList.size()];
                                                          for (int i=0; i<divMapList.size(); i++){
                                                              DivisionMapJv divMap = (DivisionMapJv)divMapList.get(i);
                                                              divisionSelect[i] = ""+divMap.getDivisionId();
                                                          }
                                                      }
                                                  }
                                              }
                                              if (objectStatusField.length()>0){
                                                  whereClause = PstComponentCodeJv.fieldNames[PstComponentCodeJv.FLD_COMP_CODE]+"='"+objectStatusField+"'";
                                                  Vector compCodeJvList = PstComponentCodeJv.list(0, 0, whereClause, "");
                                                  if (compCodeJvList != null && compCodeJvList.size()>0){
                                                      ComponentCodeJv compCodeObj = (ComponentCodeJv)compCodeJvList.get(0);
                                                      whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCodeObj.getOID();
                                                      Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                                      if (compMapList != null && compMapList.size()>0){
                                                          componentSelect = new String[compMapList.size()];
                                                          for (int i=0; i<compMapList.size(); i++){
                                                              ComponentMapJv compMap = (ComponentMapJv)compMapList.get(i);
                                                              componentSelect[i] = ""+compMap.getComponentId();
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              String nilaiVal = "";
                                              nilaiVal = JurnalDocument.printJurnalSummary(oidPeriod, divisionSelect, componentSelect);
                                              empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                              tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", nilaiVal);
                                            } else if (objectType.equals("LISTLINE") && objectStatusField.equals("START")) {
                                            //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                add = "<a href=\"javascript:cmdAddEmp('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                add = "";
                                                }
                                                
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                //menghapus tutup formula 
                                                String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                String subListLine = "";
                                                if (listEmp.size() > 0) {
                                                    for (int list = 0; list < listEmp.size(); list++) {
                                                        EmpDocList empDocList = (EmpDocList) listEmp.get(list);
                                                        Employee employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                        Hashtable HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                         //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                        String delete = "";
                                                        if(isApproved == false){
                                                        delete =" <a href=\"javascript:cmdDeleteListLine('" +empDocList.getOID() + "','"+empDocList.getEmployee_id()+"','TRAINNERLISTLINE')\">x</a> ";
                                                        }else{
                                                        delete ="";
                                                        }
                                                        String value = (String) HashtableEmp.get("FULL_NAME");
                                                        if ((listEmp.size() - 2) == list) {
                                                            subListLine = subListLine + value + delete + " dan ";
                                                        } else {
                                                            subListLine = subListLine + value + delete + ", ";
                                                        }
                                                    }
                                                }
                                                //subListLine = subListLine.substring(0,subListLine.length()-1);
                                                add = add + subListLine;
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", subListLine);
                                                    
                                            } else if (objectType.equals("FIELD") && objectStatusField.equals("AUTO")) {
                                                //String field = "<input type=\"text\" name=\""+ subString +"\" value=\"\">";
                                                Date newd = new Date();
                                                String field = "04/KEP/BPD-PMT/" + newd.getMonth() + "/" + newd.getYear();
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", field);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", field);
                                                    
                                            } else if (objectType.equals("FIELD")) {
                                                
                                                if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("TEXT"))) {
                                                    //String add = "<a href=\"javascript:cmdAddText('"+objectName+"','"+oidEmpDoc+"','"+objectStatusField+"')\">"+(hlistEmpDocField.get(objectName) != null?(String)hlistEmpDocField.get(objectName):"add")+"</a></br>";
                                                    //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                    String add = "";
                                                    if(isApproved == false){
                                                     add = "<a href=\"javascript:cmdAddText('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "')\">" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "NEW TEXT") + "</a>";
                                                    }else{
                                                     add = "" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-") + "";  
                                                    }
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                    tanpaeditor = tanpaeditor.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : " "));
                                                } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("DATE"))) {
                                                    String dateShow = "";
                                                    if (hlistEmpDocField.get(objectName) != null) {
                                                        SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                                        String dateInString = (String) hlistEmpDocField.get(objectName);
                                                            
                                                        SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                                        try {
                                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                            Date dateX = formatterDateSql.parse(dateInString);
                                                            String strDate = sdf.format(dateX);
                                                            strYear = strDate.substring(0, 4);
                                                            strMonth = strDate.substring(5, 7);
                                                            if (strMonth.length() > 0){
                                                                switch(Integer.valueOf(strMonth)){
                                                                    case 1: strMonth = "Januari"; break;
                                                                    case 2: strMonth = "Februari"; break;
                                                                    case 3: strMonth = "Maret"; break;
                                                                    case 4: strMonth = "April"; break;
                                                                    case 5: strMonth = "Mei"; break;
                                                                    case 6: strMonth = "Juni"; break;
                                                                    case 7: strMonth = "Juli"; break;
                                                                    case 8: strMonth = "Agustus"; break;
                                                                    case 9: strMonth = "September"; break;
                                                                    case 10: strMonth = "Oktober"; break;
                                                                    case 11: strMonth = "November"; break;
                                                                    case 12: strMonth = "Desember"; break;
                                                                }
                                                            }
                                                            strDay = strDate.substring(8, 10);
                                                            dateShow = strDay + " "+ strMonth + " " + strYear;  ////formatterDate.format(dateX);
                                                                
                                                        } catch (Exception e) {
                                                            e.printStackTrace();
                                                        }
                                                    }
                                                      //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                    String add = "";
                                                    if(isApproved == false){
                                                    add = "<a href=\"javascript:cmdAddText('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "')\">" + (hlistEmpDocField.get(objectName) != null ? dateShow : "NEW DATE") + "</a>";
                                                    }else{
                                                    add = "" + (hlistEmpDocField.get(objectName) != null ? dateShow : "-") + "";
                                                    }
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                    tanpaeditor = tanpaeditor.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? dateShow : " "));
                                                } else if ((objectClass.equals("CLASSFIELD"))) {
                                                    //cari tahu ini untuk perubahan apa Divisi
                                                    String getNama = "";
                                                    if (hlistEmpDocField.get(objectName) != null) {
                                                        getNama = PstDocMasterTemplate.getNama((String) hlistEmpDocField.get(objectName), objectStatusField);
                                                    }
                                                    //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                    String add = "";
                                                    if(isApproved == false){    
                                                         add = "<a href=\"javascript:cmdAddText('" + oidEmpDoc + "','" + objectName + "','" + objectType + "','" + objectClass + "','" + objectStatusField + "')\">" + (hlistEmpDocField.get(objectName) != null ? getNama : "ADD") + "</a>";
                                                    }else{
                                                        add = "" + (hlistEmpDocField.get(objectName) != null ? getNama : "") + "";
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                    tanpaeditor = tanpaeditor.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : " "));
                                                        
                                                } else if ((objectClass.equals("EMPDOCFIELD"))) {
                                                    //String add = "<a href=\"javascript:cmdAddText('"+objectName+"','"+oidEmpDoc+"','"+objectStatusField+"')\">"+(empDOcFecthH.get(objectName) != null?(String)empDOcFecthH.get(objectName):"add")+"</a></br>";
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + empDOcFecthH.get(objectStatusField));
                                                    tanpaeditor = tanpaeditor.replace("${" + subString + "}", "" + empDOcFecthH.get(objectStatusField));
                                                }
                                                    
                                            } if (objectType.equals("SINGLESIGN") && objectStatusField.equals("START")) {
                                            //ADD IF BY ERI YUDI FOR DISABLE EDIT WHEN DOCUMENT ADPPROVED
                                                String add = "";
                                                if(isApproved == false){
                                                add = "<a href=\"javascript:cmdAddEmpSingle('" + objectName + "','" + oidEmpDoc + "')\">add employee</a></br>";
                                                }else{
                                                add = "";
                                                }
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", " ");
                                                int endPnutup = stringResidual.indexOf("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", endPosition);
                                                //ambil stringnya //end position adalah penutup formula dan end penutup adalah penutup isi dari end formula nya
                                                String textString = stringResidual.substring(endPosition, endPnutup);//berisi dialam string yang ada di dalam formulanya
                                                //menghapus tutup formula 
                                                String whereC = " " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                Vector listEmp = PstEmpDocList.list(0, 0, whereC, "");
                                                EmpDocList empDocList = new EmpDocList();
                                                Employee employeeFetch = new Employee();
                                                Hashtable HashtableEmp = new Hashtable();
                                                if (listEmp.size() > 0) {
                                                    try {
                                                        empDocList = (EmpDocList) listEmp.get(listEmp.size() - 1);
                                                        employeeFetch = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                        HashtableEmp = PstEmployee.fetchExcHashtable(empDocList.getEmployee_id());
                                                    } catch (Exception e) {
                                                    }
                                                        
                                                } else {
													String whereDocMasterSign = " "+PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_ID] + " = \"" + empDoc1.getDoc_master_id() +"\""
																	+ " AND " +PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_SIGN_INDEX]+" = "+objectName
																	+ " AND (" +PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_SIGN_FOR_DIVISION_ID]+ " = " + empDoc1.getDivisionId() +""
																	+ " OR " +PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_SIGN_FOR_DIVISION_ID]+ " = 0)" ;                                 
												   Vector listMasterDocSign = PstDocMasterSign.list(0,0, whereDocMasterSign, "SIGN_INDEX");
												   
													for (int xx = 0; xx < listMasterDocSign.size(); xx++){
														DocMasterSign docMasterSign = (DocMasterSign) listMasterDocSign.get(xx);
														 try {
															  String whereSign = "1=1";
															  if (docMasterSign.getPositionId()!= 0 && docMasterSign.getPositionId() > 0) {
																  whereSign = whereSign + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] +" = "+ docMasterSign.getPositionId() ;
																  if(docMasterSign.getSignForDivisionId()> 0){
																	  whereSign = whereSign + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] +" = "+ docMasterSign.getSignForDivisionId() ;                            
																  } else if (empDoc1.getDivisionId()>0){
																	  whereSign = whereSign + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] +" = "+ empDoc1.getDivisionId() ;
																  }
															  }
															  if (docMasterSign.getEmployeeId()!= 0 && docMasterSign.getEmployeeId() > 0) {
																  whereSign = whereSign + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +" = "+ docMasterSign.getEmployeeId() ;
															  }
															  Vector listEmpSign = PstEmployee.list(0, 0, whereSign, "");
															  if (listEmpSign.size()>0){
																  employeeFetch = (Employee) listEmpSign.get(0);
																  HashtableEmp = PstEmployee.fetchExcHashtable(employeeFetch.getOID());
															  }
														  } catch (Exception e) {
														  }
													}
												}
                                                    
                                                int xx = 2;
                                                int startPositionOfFormula = 0;
                                                int endPositionOfFormula = 0;
                                                String subStringOfFormula = "";
                                                String residuOfsubStringOfTd = textString;
                                                do {
                                                    
                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                    subStringOfFormula = residuOfsubStringOfTd.substring(startPositionOfFormula, endPositionOfFormula);//isi table 
                                                        
                                                        
                                                    String[] partsOfFormula = subStringOfFormula.split("-");
                                                    String objectNameFormula = partsOfFormula[0];
                                                    String objectTypeFormula = partsOfFormula[1];
                                                    String objectTableFormula = partsOfFormula[2];
                                                    String objectStatusFormula = partsOfFormula[3];
                                                    String value = "";
                                                    if (objectTableFormula.equals("EMPLOYEE")) {
                                                        value = (String) HashtableEmp.get(objectStatusFormula);
                                                        if (value == null) {
                                                            value = "-";
                                                        }
                                                            
                                                    } else {
                                                        System.out.print("Selain Object Employee belum bisa dipanggil");
                                                    }
                                                        
                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusFormula + "}", value);
                                                        
                                                    tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusFormula + "}", value);
                                                    residuOfsubStringOfTd = residuOfsubStringOfTd.substring(endPositionOfFormula, residuOfsubStringOfTd.length());
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                        
                                                    startPositionOfFormula = residuOfsubStringOfTd.indexOf("${") + "${".length();
                                                    endPositionOfFormula = residuOfsubStringOfTd.indexOf("}", startPositionOfFormula);
                                                } while (endPositionOfFormula > 0);

												empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-END" + "}", " ");
                                                    
                                            } else if (objectType.equals("LEAVE")) {
                                        try {
                                                LeaveApplication leave = PstLeaveApplication.fetchExc(empDoc1.getLeaveId());
                                                if (objectStatusField.equals("LAMPIRAN")){
                                                        try {
                                                            typeAction= 4;
                                                            typeExpense = 2;
                                                            long oidPeriod = 0;
                                                            Vector listAl = PstAlStockTaken.getAlTaken(empDoc1.getLeaveId(), leave.getEmployeeId());
                                                            Vector listLl = PstLlStockTaken.getLlTaken(empDoc1.getLeaveId(), leave.getEmployeeId());
                                                            if (listAl.size()>0){
                                                                AlStockTaken alStockTaken = (AlStockTaken) listAl.get(0);
                                                                oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(alStockTaken.getTakenDate());
                                                            }
                                                            if (listLl.size()>0){
                                                                LlStockTaken llStockTaken = (LlStockTaken) listLl.get(0);
                                                                oidPeriod = PstPayPeriod.getPayPeriodIdBySelectedDate(llStockTaken.getTakenDate());
                                                            }
                                                            String val = JurnalDocument.drawLampiranBAUangMakan(oidPeriod, leave.getEmployeeId(), leave.getOID(), empDoc1.getOID(), false);
                                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                            tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                        } catch (Exception exc){}
                                                } else if (objectStatusField.equals("LAMPIRANMULTI")){
                                                        typeAction= 4;
                                                        typeExpense = 3;
                                                        String val = JurnalDocument.drawLampiranBAUangMakanMulti(empDoc1.getOID(), false, objectName);
                                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                        tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                } else if (objectStatusField.equals("KETERANGAN")){
                                                        try {
                                                        String val = JurnalDocument.drawKeteranganCuti(leave.getEmployeeId(), hlistEmpDocField, empDoc1.getOID(), leave.getOID());
                                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                        tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                        } catch (Exception exc){}
                                                }
                                                else if (objectStatusField.equals("JENIS_CUTI")){
                                                        String val = "";
                                                        if (leave.getTypeLeaveCategory()== 3){
                                                                val = "Tahunan";
                                                        } else if (leave.getTypeLeaveCategory() == 4) {
                                                                val = "Besar";
                                                        }
                                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                        tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", val);
                                                } else if (objectStatusField.equals("LEAVE_DATE")){
                                                        String startCuti = "";
                                                        String endCuti = "";
                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                        String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                                        Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                                                        if (listALStockTaken != null && listALStockTaken.size()>0){
                                                                AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                                                startCuti = sdf.format(alStockTaken.getTakenDate());
                                                                endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                                        } else {
                                                                where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                                                Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                                                if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                                                        LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                                                        startCuti = sdf.format(llStockTaken.getTakenDate());
                                                                        endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                                                } else {
                                                                        where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leave.getOID();
                                                                        Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                                                        if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                                                                SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                                                                startCuti = sdf.format(slStockTaken.getTakenDate());
                                                                                endCuti = sdf.format(slStockTaken.getTakenFinnishDate());
                                                                        }
                                                                }
                                                        }
                                                        String dateShow = "";
                                                        try {
                                                            String strYearStart = startCuti.substring(0, 4);
                                                            String strMonthStart = startCuti.substring(5, 7);
                                                            if (strMonthStart.length() > 0){
                                                                switch(Integer.valueOf(strMonthStart)){
                                                                    case 1: strMonthStart = "Januari"; break;
                                                                    case 2: strMonthStart = "Februari"; break;
                                                                    case 3: strMonthStart = "Maret"; break;
                                                                    case 4: strMonthStart = "April"; break;
                                                                    case 5: strMonthStart = "Mei"; break;
                                                                    case 6: strMonthStart = "Juni"; break;
                                                                    case 7: strMonthStart = "Juli"; break;
                                                                    case 8: strMonthStart = "Agustus"; break;
                                                                    case 9: strMonthStart = "September"; break;
                                                                    case 10: strMonthStart = "Oktober"; break;
                                                                    case 11: strMonthStart = "November"; break;
                                                                    case 12: strMonthStart = "Desember"; break;
                                                                }
                                                            }
                                                            String strDayStart = startCuti.substring(8, 10);
															String strYearEnd = endCuti.substring(0, 4);
                                                            String strMonthEnd = endCuti.substring(5, 7);
                                                            if (strMonthEnd.length() > 0){
                                                                switch(Integer.valueOf(strMonthEnd)){
                                                                    case 1: strMonthEnd = "Januari"; break;
                                                                    case 2: strMonthEnd = "Februari"; break;
                                                                    case 3: strMonthEnd = "Maret"; break;
                                                                    case 4: strMonthEnd = "April"; break;
                                                                    case 5: strMonthEnd = "Mei"; break;
                                                                    case 6: strMonthEnd = "Juni"; break;
                                                                    case 7: strMonthEnd = "Juli"; break;
                                                                    case 8: strMonthEnd = "Agustus"; break;
                                                                    case 9: strMonthEnd = "September"; break;
                                                                    case 10: strMonthEnd = "Oktober"; break;
                                                                    case 11: strMonthEnd = "November"; break;
                                                                    case 12: strMonthEnd = "Desember"; break;
                                                                }
                                                            }
                                                            String strDayEnd = endCuti.substring(8, 10);
                                                            dateShow += strDayStart + " "+ strMonthStart + " " + strYearStart+" - "+strDayEnd+" "+strMonthEnd+" "+strYearEnd;  ////formatterDate.format(dateX);
                                                                
                                                        } catch (Exception e) {
                                                            e.printStackTrace();
                                                        }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", dateShow);
                                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", dateShow);
                                                        } else if (objectClass.equals("EMPLOYEE")){
                                                                Hashtable HashtableEmp = new Hashtable();
                                                                String value = "";
                                                                try {
                                                                        HashtableEmp = PstEmployee.fetchExcHashtable(leave.getEmployeeId());
                                                                        value = (String) HashtableEmp.get(objectStatusField);
                                                                        if (value == null) {
                                                                                value = "-";
                                                                        }
                                                                } catch (Exception e) {
                                                                }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", value);
                                                                tanpaeditor = tanpaeditor.replace("${" + objectName + "-" + objectType + "-" + objectClass + "-" + objectStatusField + "}", value);
                                                        }
                                                } catch (Exception exc){
                                                        System.out.println("leave exc : "+exc.toString());
                                                }

                                        }
                                                
                                        } else if (!objectName.equals("") && objectType.equals("") && objectClass.equals("") && objectStatusField.equals("")) {
                                            String obj = "" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-");
                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + objectName + "}", obj);
                                            tanpaeditor = tanpaeditor.replace("${" + objectName + "}", obj);
                                        }
                                        stringResidual = stringResidual.substring(endPosition, stringResidual.length());
                                        objectDocumentDetail.setStartPosition(startPosition);
                                        objectDocumentDetail.setEndPosition(endPosition);
                                        objectDocumentDetail.setText(subString);
                                        vNewString.add(objectDocumentDetail);
                                            
                                            
                                        //mengecek apakah masih ada sisa
                                        startPosition = stringResidual.indexOf("${") + "${".length();
                                        endPosition = stringResidual.indexOf("}", startPosition);
                                    } while (endPosition > 0);
                                } catch (Exception e) {
                                }
                                    
                            %>
                            <%
                                
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");
                                    
                            %>
                                
                                
                            <tr align="left" valign="top" > 
                                <td colspan="3">
                                    <div>&nbsp;</div>
                                </td>
                            </tr>
                                
                            <tr valign="top" > 
                                <td colspan="3" align="center">
                                    <table width="90%" class="tblStyleDoc">
                                        <tr>
                                            <td><%=empDocMasterTemplateText%></td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                                
                                
                            <% if (nstatus) {%>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr align="left" valign="top" > 
                                <td colspan="3" align="center">
                                    <table width="90%">
                                        <tr>
                                            <td>
                                                <% if (appUserSess.getAdminStatus() == 1) { %> 
                                                <a class="btn" style="color:#FFF;" href="javascript:cmdImport('<%=oidEmpDoc%>')">Import</a>
                                                <%}%>
                                                &nbsp;<a class="btn" style="color:#FFF;" href="javascript:cmdPrint('<%=oidEmpDoc%>')">Editor & Print</a>
                                                <% if (appUserSess.getAdminStatus() == 1) { %> 
                                                &nbsp;<a class="btn" style="color:#FFF;" href="javascript:cmdExpense('<%=oidEmpDoc%>')">Expense</a>&nbsp;
                                                <%}%>
                                                <%
                                                    String whereClause1 = PstDocMasterAction.fieldNames[PstDocMasterAction.FLD_DOC_MASTER_ID] + " = " + empDoc1.getDoc_master_id();
                                                    Vector listDocMasterAction = PstDocMasterAction.list(0, 0, whereClause1, "");
                                                    if (listDocMasterAction.size() > 0) {
                                                        for (int i = 0; i < listDocMasterAction.size(); i++) {
                                                            DocMasterAction docMasterAction1 = (DocMasterAction) listDocMasterAction.get(i);
                                                            if(typeAction == 4){
                                                %>  
                                                            <a class="btn" style="color:#FFF;" href="javascript:cmdRun('<%=oidEmpDoc%>','<%=typeExpense%>')">Run <%=docMasterAction1.getActionTitle()%></a>             
                                                <%                                                                
                                                            } else {
                                                %>  
                                                            <a class="btn" style="color:#FFF;" href="javascript:cmdAction('<%=oidEmpDoc%>','<%=docMasterAction1.getOID()%>', '<%= typeAction %>')">Action <%=docMasterAction1.getActionTitle()%></a>             
                                                <%
                                                            }
                                                        }
                                                    }
                                                %> 
                                                 &nbsp;&nbsp;<a class="btn" style="color:#FFF;" href="javascript:cmdBack()">Kembali</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr align="left" valign="top" > 
                                <td colspan="3"cen >
                                    <table width="80%" align="center" border="0"  cellspacing="0" cellpadding="0" style="margin-top: 10 ; margin-bottom: 10 ;">
                                        <tr>
                                            <td width="37%">
                                                tombol editor, expense maupun action hanya akan muncul jika document sudah di approve
                                            </td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                            <%}%>
                             <tr align="left" valign="top" > 
                                <td colspan="3"cen >
                                    - 
                                </td>
                            </tr>   
                            <% 
                                // add By Eri 2021-12-02 for disable approve when tgl berlaku dokumen sudah lewat period
                                 String dateStartPeriodS =  Formater.formatDate(new Date(), "yyyy-MM-dd");
                                 Date dateStartPeriod =  Formater.formatDate(dateStartPeriodS, "yyyy-MM-dd");
                                try{
                                    dateStartPeriod.setDate(1);
                                }catch (Exception exc){
                                    System.out.println("Exc :"+exc);
                                }
                                boolean enableApprove = !empDoc.getDate_of_issue().before(dateStartPeriod) ;
                                
                                if (listMasterDocFlow.size() > 0 && enableApprove == false && isApproved == false) {%>
                                <tr align="left" valign="top"> 
                                    <td colspan="3" align="center">
                                        <table width="90%">
                                            <tr>
                                                <td>
                                                    <div>&nbsp;</div>
                                                    <div style="background-color:#CAEEFA; color:#3D7587; padding: 7px 9px;">
                                                        Approval Dokumen tidak bisa dilakukan - Tanggal berlaku dokumen sudah lewat periode
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                
                           
                            <% }else if (listMasterDocFlow.size() > 0 ){ %>
                             <tr align="left" valign="top"> 
                                <td colspan="3">
                                    <table width="80%" align="center" border="1"  cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="37%"><%= drawList(listMasterDocFlow, oidEmpDoc)%></td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                                
                            
                            <% }else {%>
                            <tr align="left" valign="top"> 
                                <td colspan="3" align="center">
                                    <table width="90%">
                                        <tr>
                                            <td>
                                                <div>&nbsp;</div>
                                                <div style="background-color:#CAEEFA; color:#3D7587; padding: 7px 9px;">
                                                    Doc Flow belum di set (tidak ada approver)
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <% }%>
                            <!-- <textarea class="ckeditor"  class="elemenForm" cols="70" rows="40"></textarea> -->
                                
                                
                        </table>
                    </td>										  
                </tr>
                    
            </table>
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
