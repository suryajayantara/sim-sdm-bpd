<%-- 
    Document   : division_ajax
    Created on : Jan 7, 2016, 1:44:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDivision"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String divisionName = FRMQueryString.requestString(request, "division_name");
    String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = PstDivision.fieldNames[PstDivision.FLD_DIVISION];
    Vector listDivision = new Vector();
    ChangeValue changeValue = new ChangeValue();
    CtrlDivision ctrlDivision = new CtrlDivision(request);
    
    int recordToGet = 10;
    int vectSize = 0;
    //String status = "";
    if ((valid_status_select.equals("0"))){
    valid_status_select="'0'" ;
    }else if((valid_status_select.equals("1"))) {
    valid_status_select="'1'" ;
    }else{
    valid_status_select="'1' OR '2'" ;   
    }

    if (!(divisionName.equals("0"))){
        whereClause = PstDivision.fieldNames[PstDivision.FLD_DIVISION]+" LIKE '%"+divisionName+"%' AND "+PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
    } else {
        whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
    }
    

    vectSize = PstDivision.getCount(whereClause);
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlDivision.actionList(iCommand, start, vectSize, recordToGet);
    }
    listDivision = PstDivision.list(start, recordToGet, whereClause, order);
    if (listDivision != null && listDivision.size()>0){
    %>
    <table class="tblStyle">
        <tr>
            <td class="title_tbl" style="background-color: #DDD;">No</td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.COMPANY)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DESCRIPTION)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.TYPE)%></td>
            <td class="title_tbl" style="background-color: #DDD;">Tanda Tangan oleh</td>
            <td class="title_tbl" style="background-color: #DDD;">Valid Status</td>
            <td class="title_tbl" style="background-color: #DDD;">Action</td>
        </tr>
        <%
        for (int i = 0; i < listDivision.size(); i++) {
            Division division = (Division) listDivision.get(i);
            Company company = new Company();
            try {
                company = PstCompany.fetchExc(division.getCompanyId());
            } catch (Exception e) {
                System.out.println("e=>"+e.toString());
            }
            DivisionType divType = new DivisionType();
            String divisionTypeName = "-";
            try {
                divType = PstDivisionType.fetchExc(division.getDivisionTypeId());
                divisionTypeName = divType.getTypeName();
            } catch (Exception e){
                //System.out.print("getDivisionType=>"+e.toString());//
            }
            %>
            <tr>
                <td><%=(i+1)+start%></td>
                <td><%=company.getCompany()%></td>
                <td><%=division.getDivision()%></td>
                <td><%=division.getDescription()%></td>
                <td><%=divisionTypeName%></td>
                <td><%= changeValue.getEmployeeName(division.getEmployeeId()) %></td>
                <td><%= PstDivision.validStatusValue[division.getValidStatus()] %></td>
                <td>
                    <% if(privUpdate){ %>
                    <a class="btn-small-e" style="color:#FFF" href="javascript:cmdEdit('<%=division.getOID()%>')">e</a>
                    <% } %>
                    &nbsp;
                    <% if(privDelete){ %>
                    <a class="btn-small-x" style="color:#FFF" href="javascript:cmdAsk('<%=division.getOID()%>')">&times;</a>
                    <% } %>
                </td>
            </tr>
            <%
        }
        %>
    </table>
        <div>&nbsp;</div>
        <div id="record_count">
            <%
            if (vectSize >= recordToGet){
                %>
                List : <%=(start+1)%> &HorizontalLine; <%= (start+listDivision.size()) %> | 
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
    <%
    }
%>