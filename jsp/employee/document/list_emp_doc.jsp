<%-- 
    Document   : list_emp_doc
    Created on : Jun 10, 2016, 3:53:22 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDoc"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %> 
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_EMP_DOCUMENT, AppObjInfo.OBJ_EMP_DOCUMENT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    long docMasterId = FRMQueryString.requestLong(request, "doc_master");
    String docTitle = FRMQueryString.requestString(request, "doc_title");
    String docNum = FRMQueryString.requestString(request, "doc_num");
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
	String dateFrom = FRMQueryString.requestString(request, "date_from");
	String dateTo = FRMQueryString.requestString(request, "date_to");
    ChangeValue changeValue = new ChangeValue();
    if (docTitle.equals("0")){
        docTitle = "";
    }
    if (docNum.equals("0")){
        docNum = "";
    }

    String whereClause = "";
    Vector<String> whereCollect = new Vector<String>();
    String order = FRMQueryString.requestString(request, "sort_by");//PstEmpDoc.fieldNames[PstEmpDoc.FLD_REQUEST_DATE];
    Vector listEmpDoc = new Vector();
    
    CtrlEmpDoc ctrlEmpDoc = new CtrlEmpDoc(request);
    
    int recordToGet = 10;
    int vectSize = 0;
    vectSize = PstEmpDoc.getCount("");
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlEmpDoc.actionList(iCommand, start, vectSize, recordToGet);
    }

    if (docMasterId != 0){
        whereClause = " "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID]+"="+docMasterId+" ";
        whereCollect.add(whereClause);    
    }
    if (!docTitle.equals("")){
        whereClause = " "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_TITLE]+" LIKE '%"+docTitle+"%' ";
        whereCollect.add(whereClause);
    }
    if (!docNum.equals("")){
        whereClause = " "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER]+" LIKE '%"+docNum+"%' ";
        whereCollect.add(whereClause);
    }
	
	if (!dateFrom.equals("") && !dateTo.equals("")){
        whereClause = " "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_REQUEST_DATE]+" BETWEEN '"+dateFrom+"' AND '"+dateTo+"'";
        whereCollect.add(whereClause);
    }
	
    if (divisionId != 0){
        whereClause = " "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_DIVISION_ID]+"="+divisionId+" ";
        whereCollect.add(whereClause);
    }
    if (whereCollect != null && whereCollect.size()>0){
        whereClause = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClause += where;
            if (i < (whereCollect.size()-1)){
                 whereClause += " AND ";
            }
        }
    }
    if (whereClause.length() > 0) {
        vectSize = PstEmpDoc.getCount(whereClause);
        listEmpDoc = PstEmpDoc.list(0, 0, whereClause, order);
    } else {
        vectSize = PstEmpDoc.getCount("");
        listEmpDoc = PstEmpDoc.list(start, recordToGet, "", order);
    }

         
    if (listEmpDoc != null && listEmpDoc.size()>0){
    %>
    <table class="tblStyle" id="tblDoc">
        <tr>
            <td class="title_tbl" style="background-color: #DDD;">No</td>
            <td class="title_tbl" style="background-color: #DDD;">Master Dokumen</td>
            <td class="title_tbl" style="background-color: #DDD;">Judul Dokumen</td>
            <td class="title_tbl" style="background-color: #DDD;">Nomor Dokumen</td>
            <td class="title_tbl" style="background-color: #DDD;">Tanggal Dokumen</td>
            <td class="title_tbl" style="background-color: #DDD;">Tanggal Berlaku</td>
            <td class="title_tbl" style="background-color: #DDD;">Status</td>
            <td class="title_tbl" style="background-color: #DDD;">Satuan Kerja</td>
            <td class="title_tbl" style="background-color: #DDD;">Action</td>
        </tr>
        <%
        String bgColor = "#FFF;";
        for(int i=0; i<listEmpDoc.size(); i++){
            EmpDoc empDoc = (EmpDoc)listEmpDoc.get(i);
            String docMasterName = "-";
            try {
                DocMaster docMaster = PstDocMaster.fetchExc(empDoc.getDoc_master_id());
                docMasterName = docMaster.getDoc_title();
            } catch(Exception ex){
                System.out.println("emp doc=>"+ex.toString());
            }
            if (i % 2 == 0){
                bgColor = "#FFF;";
            } else {
                bgColor = "#EEE;";
            }
            %>
            <tr>
                <td style="background-color: <%= bgColor %>"><%= (i+1) %></td>
                <td style="background-color: <%= bgColor %>"><%= docMasterName %></td>
                <td style="background-color: <%= bgColor %>"><%= empDoc.getDoc_title() %></td>
                <td style="background-color: <%= bgColor %>"><%= empDoc.getDoc_number() %></td>
                <td style="background-color: <%= bgColor %>"><%= empDoc.getRequest_date() %></td>
                <td style="background-color: <%= bgColor %>"><%= empDoc.getDate_of_issue() %></td>
                <%
                     //add by Eri Yudi 2020-09-28 for show status
                    
                    boolean privCancel = false;
                    boolean isSPPD = false;
                    String status = "-";
                    //check priv doc 
                    try{
                    String whereUG = PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID]+"="+appUserSess.getOID();
                    Vector userGroupList = PstUserGroup.list(0, 0, whereUG, "");
                    if (userGroupList != null && userGroupList.size() > 0) {
                         for (int z = 0; z < userGroupList.size(); z++) {
                             UserGroup userGroup = (UserGroup) userGroupList.get(z);
                             String whereG = PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID] + "=" + userGroup.getGroupID();
                             Vector groupList = PstAppGroup.list(0, 0, whereG, "");
                             if (groupList != null && groupList.size() > 0) {
                                 AppGroup appGroup = (AppGroup) groupList.get(0);
                                 if (appGroup.getGroupName().equals("Head")){
                                     privCancel = true;
                                 }
                                
                             }
                         }      
                     }
                    // check priv superuser
                    if(appUserSess.getAdminStatus() == 1){
                          privCancel = true;
                    }
                    //check priv SDM
                    long sdmDivisionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_SDM_DIVISION)));
                     boolean isHRDLogin = sdmDivisionOid == departmentOid ? true : false;
                     if(isHRDLogin){
                         privCancel = true;
                     }
                    
                    
                    //check doctype sppd 
                    long oidDocTypeSPPD = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName("DOC_TYPE_SPPD")));
                    DocMaster docM = (DocMaster) PstDocMaster.fetchExc(empDoc.getDoc_master_id());
                    isSPPD = oidDocTypeSPPD == docM.getDoc_type_id() ? true : false;   
                   }catch(Exception exc){
                       System.out.println("Exc :"+ exc);
                   }
                    
                    //show string status
                    try{
                    status = PstLeaveApplication.fieldStatusApplication[empDoc.getDocStatus()];
                    }catch(Exception exc){
                        status = "Draft";
                    }
                %>
                <td style="background-color: <%= bgColor %>"><%= status%></td>
                <td style="background-color: <%= bgColor %>"><%= changeValue.getDivisionName(empDoc.getDivisionId()) %></td>
                <td style="background-color: <%= bgColor %>">
                    <a href="javascript:cmdDetail('<%= empDoc.getOID() %>')">Detail</a>
                  
                    
                    <% if (privUpdate && !(empDoc.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED || empDoc.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_CANCELED)  ){ %>
                    | <a href="javascript:cmdEdit('<%= empDoc.getOID() %>')">Edit</a> |
                    <a href="javascript:cmdAsk('<%= empDoc.getOID() %>')">Delete</a>
                    <% } %>
                    <% if (privCancel && empDoc.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED && isSPPD){ %>
                    | <a href="javascript:cmdAskCancelApprove('<%= empDoc.getOID() %>')">Cancel</a>
                    <% } %>
                  
                </td>
            </tr>
            <%
        }
        %>
    </table>
<%
    if (whereClause.length() == 0) {
%>  
    
    
    <div>&nbsp;</div>
    <div id="record_count">
        <%
        if (vectSize >= recordToGet){
            %>
            List : <%=start%> &HorizontalLine; <%= (start+recordToGet) %> | 
            <%
        }
        %>
        Total : <%= vectSize %>
    </div>
    <div class="pagging">
        <a style="color:#F5F5F5" href="javascript:cmdListFirst('<%=start%>')" class="btn-small">First</a>
        <a style="color:#F5F5F5" href="javascript:cmdListPrev('<%=start%>')" class="btn-small">Previous</a>
        <a style="color:#F5F5F5" href="javascript:cmdListNext('<%=start%>')" class="btn-small">Next</a>
        <a style="color:#F5F5F5" href="javascript:cmdListLast('<%=start%>')" class="btn-small">Last</a>
    </div>
    <%} } else { %>
    No Data
    <% } %>
    
