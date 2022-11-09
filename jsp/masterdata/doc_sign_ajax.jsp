<%-- 
    Document   : doc_sign_ajax
    Created on : Sep 4, 2019, 4:51:20 PM
    Author     : IanRizky
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterSign"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_PERFORMANCE_APPRAISAL, AppObjInfo.OBJ_GROUP_RANK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String filterBy = FRMQueryString.requestString(request, "filter_by");
    
    /* value of structure */
   long docMasterSignId = FRMQueryString.requestLong(request, "oid");
    /* Name of form input */
    
    DocMasterSign docMasterSign = new DocMasterSign();       
    if (docMasterSignId > 0){
        try {
            docMasterSign = PstDocMasterSign.fetchExc(docMasterSignId);
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
    }       
    
    Employee emp = new Employee();
    try {
        emp = PstEmployee.fetchExc(docMasterSign.getEmployeeId());
    } catch (Exception exc){}
           
%>
<%
    if (filterBy.equals("1")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_POSITION_ID] %>" id="position" class="chosen-select" >
            <option value="0">-select-</option>
            <%
            Vector listPosition = PstPosition.list(0, 0, "" , "POSITION");
            if (listPosition != null && listPosition.size()>0){
                for(int i=0; i<listPosition.size(); i++){
                    Position position = (Position)listPosition.get(i);
                    if (docMasterSign.getPositionId()== position.getOID()){
                        %><option selected="selected" value="<%=position.getOID()%>"><%=position.getPosition()%></option><%
                    } else {
                        %><option value="<%=position.getOID()%>"><%=position.getPosition()%></option><%
                    }
                }
            }
            %>
        </select>
    </div>
<%     
   } if (filterBy.equals("2")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%>
    </div>
    <div id="divinput">
        <table>
            <tr>
                <td>
                    <input type="text" name="EMP_FULLNAME" value="<%= !(emp.getFullName().equals("")) ? emp.getFullName() : ""  %>"> <input type="hidden" name="<%=FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_EMPLOYEE_ID]%>" value="<%= docMasterSign.getEmployeeId()> 0 ? docMasterSign.getEmployeeId(): ""  %>>" class="formElemen">                    
                </td>
                <td>
                    <a href="javascript:cmdSearchEmp()" ><img name="Image10x" border="0" src="<%=approot%>/images/icon/folder.gif" width="24" height="24" alt="Search Employee"></a>
                </td>
            </tr>
        </table>
    </div>
<%
   }
%>

