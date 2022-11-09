<%-- 
    Document   : ajax_emp_doc
    Created on : Feb 2, 2021, 9:37:06 AM
    Author     : gndiw
--%>

<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.system.entity.PstSystemProperty"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
 
    String term = FRMQueryString.requestString(request, "search");
    long oid = FRMQueryString.requestLong(request, "oid");
    int start = FRMQueryString.requestInt(request, "page");
    String whereClauseDoc = "("+PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER]+" LIKE '%"+term+"%'"+" OR "+PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID]+" = "+oid+")";
    Vector listEmpDoc = PstEmpDoc.list(0, 0, whereClauseDoc, "");
    JSONArray array = new JSONArray();
    if (listEmpDoc != null && listEmpDoc.size()>0){
        for(int i=0; i<listEmpDoc.size(); i++){
            EmpDoc empDoc = (EmpDoc)listEmpDoc.get(i);
            JSONObject obj = new JSONObject();
            obj.put("itemName", empDoc.getDoc_number());
            obj.put("id", ""+empDoc.getOID());
            array.put(obj);
        }
    }
%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%=array%>