<%-- 
    Document   : document_comp_search
    Created on : 17-Feb-2017, 09:02:02
    Author     : Gunadi
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDocCompMap"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDocCompMap"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDocListExpense"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    long oidDocMaster = FRMQueryString.requestLong(request,FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_MASTER_ID]);
    String empId = FRMQueryString.requestString(request, "oid_emp");
    long oidDocCompMap = FRMQueryString.requestLong(request, FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]);
    String empObjectName = FRMQueryString.requestString(request,"emp_object_name");
    long periodId = FRMQueryString.requestLong(request, "period");
    String[] employee = empId.split(",");
    int iCommand = FRMQueryString.requestCommand(request);
    
    long componentId = FRMQueryString.requestLong(request, "comp");
    int dayLength = FRMQueryString.requestInt(request, "day");
    
    EmpDocCompMap empDocCompMap = new EmpDocCompMap();
    CtrlEmpDocCompMap ctrlEmpDocCompMap = new CtrlEmpDocCompMap(request);
    int iErrCode = FRMMessage.NONE;
    iErrCode = ctrlEmpDocCompMap.action(iCommand , oidDocCompMap);
    
     if(iCommand == Command.EDIT){
           empDocCompMap = ctrlEmpDocCompMap.getEmpDocCompMap(); empDocCompMap = PstEmpDocCompMap.fetchExc(oidDocCompMap);
     }
     
     
    long oidInsert = 0;
//    if (componentId > 0){
//        for(int i=0; i<employee.length; i++){
//            EmpDocListExpense empDocListExpense = new EmpDocListExpense();
//            String whereDoc = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+employee[i]
//                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+"="+oidEmpDoc
//                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_PERIOD_ID]+"="+periodId
//                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMPONENT_ID]+"="+componentId
//                    +" AND "+PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='"+objectName+"'";
//            Vector listExps = PstEmpDocListExpense.list(0, 0, whereDoc, "");
//            if (listExps.size()>0){
//                empDocListExpense = (EmpDocListExpense) listExps.get(0);
//            }
//            empDocListExpense.setEmpDocId(oidEmpDoc);
//            empDocListExpense.setEmployeeId(Long.valueOf(employee[i]));
//            empDocListExpense.setComponentId(componentId);
//            empDocListExpense.setDayLength(dayLength);
//            empDocListExpense.setObjectName(objectName);
//            empDocListExpense.setPeriodeId(periodId);
//            try {
//                if (listExps.size()>0){
//                    oidInsert = PstEmpDocListExpense.updateExc(empDocListExpense);
//                } else {
//                    oidInsert = PstEmpDocListExpense.insertExc(empDocListExpense);
//                }
//            } catch(Exception e){
//                System.out.println(e.toString());
//            }
//        }
//    }
    
    Vector listEmpDocCompMap = new Vector();
        String where = PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
        String order = PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_COMPONENT_ID];
        listEmpDocCompMap = PstEmpDocCompMap.list(0, 0, where, order);
               
    
       
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
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
            
            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            
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
        </style>
<script type="text/javascript">

//function check() {
//    document.getElementsByClassName("myC").checked = true;
//}
//
//function uncheck() {
//    document.getElementById("myCheck").checked = false;
//}
function cmdAdd(){
    document.frm.action="pay_component_mapping.jsp";
    document.frm.command.value="<%=Command.SAVE%>";
    document.frm.submit();
}



//function cmdGoToSurat(oidEmpDoc, objectName){
//    document.frm.action="search_app_letter.jsp?oid_emp_doc="+oidEmpDoc+"&object_name="+objectName;
//    document.frm.submit();
//}

function cmdEdit(oid){
    document.frm.<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]%>.value=oid;
    document.frm.command.value="<%=Command.EDIT%>";
    document.frm.action="pay_component_mapping.jsp";
    document.frm.submit();
}

function cmdAskDelete(oid){
    document.frm.<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]%>.value=oid;
    document.frm.command.value="<%=Command.ASK%>";
    document.frm.action="pay_component_mapping.jsp";
    document.frm.submit();
}

function cmdNoDelete(oid){
    document.frm.<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]%>.value=oid;
    document.frm.command.value="<%=Command.NONE%>";
    document.frm.action="pay_component_mapping.jsp";
    document.frm.submit();
}

function cmdCancel(){
    document.frm.command.value="<%=Command.NONE%>";
    document.frm.action="pay_component_mapping.jsp";
    document.frm.submit();
}

function cmdDelete(oid){
    document.frm.<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]%>.value=oid;
    document.frm.command.value="<%=Command.DELETE%>";
    document.frm.action="pay_component_mapping.jsp";
    document.frm.submit();
}

</script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h2 style="color:#999"><%= iCommand == Command.EDIT ? "Edit Komponen" : "Tambah Komponen"%></h2>
            <%
            if (oidInsert != 0){
                %>
                <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
                <%
            }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_MASTER_ID]%>" value="<%= oidDocMaster %>" />
                <input type="hidden" name="oid_emp" value="<%= empId %>"/>
                <input type="hidden" name="command" value="<%= Command.SAVE %>"/>
                <input type="hidden" name="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID]%>" value="<%= empDocCompMap.getOID()%>"/>
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
<!--                            <div id="caption">Periode</div>-->
                            <!--<div id="divinput">-->
                                <select id="period"  hidden name="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_PERIOD_ID]%>" >
                                    <option value="0">-select-</option>
                                    <%
                                    String orderPeriod = PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE]+" DESC";
                                    Vector listPeriod = PstPayPeriod.list(0, 0, "", orderPeriod);
                                    if (listPeriod != null && listPeriod.size()>0){
                                        for(int i=0; i<listPeriod.size(); i++){
                                            PayPeriod period = (PayPeriod)listPeriod.get(i);
                                            String selected = "";
                                            if(empDocCompMap.getPeriodId() == period.getOID()){
                                                selected = "selected";
                                            }
                                            %>
<!--                                            <option value="<%= period.getOID() %>" <%=selected%>><%= period.getPeriod()%></option>-->
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            <!--</div>-->
                            <div id="caption">Komponen</div>
                            <div id="divinput">
                                <select id="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_COMPONENT_ID]%>" name="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_COMPONENT_ID]%>" class="chosen-select">
                                    <%
                                    order = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME];
                                    Vector listComponent = PstPayComponent.list(0, 0, "", order);
                                    if (listComponent != null && listComponent.size()>0){
                                        for(int i=0; i<listComponent.size(); i++){
                                            PayComponent payComp = (PayComponent)listComponent.get(i);
                                            String selected = "";
                                            if(empDocCompMap.getComponentId()== payComp.getOID()){
                                                selected = "selected";
                                            }
                                            %>
                                            <option value="<%= payComp.getOID() %>" <%=selected%>><%= payComp.getCompName() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <div id="caption"><%= "Jumlah Pengali" %></div>
                            <div id="divinput">
                                <input type="text" name="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DAY_LENGTH]%>" id="<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DAY_LENGTH]%>" value="<%=empDocCompMap.getDayLength()%>"/>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdAdd()"><%= iCommand == Command.EDIT ? "Simpan" : "Tambah"%></a>
                            <% if(iCommand == Command.EDIT ){%>
                                <a class="btn" style="color:#FFF" href="javascript:cmdCancel()"> Cancel </a>
                            <%}%>
                            <div>&nbsp;</div>
                            <% if (iCommand == Command.ASK){ %>
                            <div id="confirm">
                                Are you sure? 
                                <a href="javascript:cmdDelete('<%= oidDocCompMap %>')" id="btn-confirm">Yes</a> | 
                                <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                            </div>
                            <% } %>
                            <%
                                    if (listEmpDocCompMap.size() >0) {
                            %>
                            <table class="tblStyle">
                                <tr>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
<!--                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Periode</td>-->
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Komponen</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jumlah Hari</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Action</td>
                                </tr>
                                <%
                                    PayComponent payCom = new PayComponent();
                                    PayPeriod period = new PayPeriod();
                                    for (int i=0;i < listEmpDocCompMap.size(); i++){
                                    EmpDocCompMap docCompMap = (EmpDocCompMap) listEmpDocCompMap.get(i);
                                   
                                    try {
                                        payCom = PstPayComponent.fetchExc(docCompMap.getComponentId());
                                    } catch (Exception exc){
                                        
                                    
                                    }
                                    try {
                                        period = PstPayPeriod.fetchExc(docCompMap.getPeriodId());
                                    } catch (Exception exc){}
                                %>
                                    <tr>
                                        <td style="background-color: #FFF;"><%=i+1%></td>
<!--                                        <td style="background-color: #FFF;"><%=period.getPeriod()%></td>-->
                                        <td style="background-color: #FFF;"><%=payCom.getCompName()%></td>
                                        <td style="background-color: #FFF;"><%=docCompMap.getDayLength()%></td>
                                        <td style="background-color: #FFF;">
                                            <div>
                                                <div >
                                                     <a class="btn-small" href="javascript:cmdEdit('<%=docCompMap.getOID()%>')" style="color: #575757;">Edit</a>
                                                </div>
                                                <div style="margin-top: 12px;">
                                                    <a class="btn-small" href="javascript:cmdAskDelete('<%=docCompMap.getOID()%>')" style="color: #575757;">Delete</a>
                                                </div>
                                            </div> 
                                            
                                            
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                            </table>
                            <%      } else { %>
                            
                            <table class="tblStyle">
                                <tr>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
<!--                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Periode</td>-->
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Komponen</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jumlah Hari</td>
                                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Action</td>
                                </tr>
                                <tr>
                                    <td style="background-color: #FFF; text-align:center; vertical-align:middle" colspan="5">No Component Avaliable</td>
                                </tr>
                            </table>
                            <%
                                        
                                    }
                            %>
                        </td>
                    </tr>
                </table>
            </form>
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
