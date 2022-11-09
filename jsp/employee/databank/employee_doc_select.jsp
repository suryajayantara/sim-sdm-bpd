<%-- 
    Document   : employee_doc_select
    Created on : May 28, 2018, 2:09:19 PM
    Author     : dimata005
--%>

<%@page import="com.dimata.harisma.form.employee.FrmEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int skType = FRMQueryString.requestInt(request, "jenisSK");
    String sDocNo = FRMQueryString.requestString(request, "doc_num");
    Vector docList = new Vector();
    
    if (iCommand == Command.LIST){
        String where = PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER]+" LIKE '%"+sDocNo+"%'";
        docList = PstEmpDoc.list(0, 0, where, "");
    }
    
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style type="text/css">
            body {
                background-color: #EEE;
                font-family: sans-serif;
                color: #575757;
                padding: 21px;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 9px 7px 9px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            input {
                padding: 5px 7px;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
        </style>
        <script type="text/javascript">
            function cmdSearch(){
                document.frm.command.value="<%=Command.LIST%>";
                document.frm.action="employee_doc_select.jsp";
                document.frm.submit();
            }
            function cmdGetJabatan(docNum, docDate, docId) {
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_SK_NOMOR]%>.value = docNum;
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_SK_TANGGAL]%>.value = docDate;
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_EMP_DOC_ID]%>.value = docId;
                self.close();
            }
            function cmdGetGrade(docNum, docDate, docId) {
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_SK_NOMOR_GRADE]%>.value = docNum;
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_SK_TANGGAL_GRADE]%>.value = docDate;
                self.opener.document.frm_employee.<%=FrmEmployee.fieldNames[FrmEmployee.FRM_FIELD_EMP_DOC_ID_GRADE]%>.value = docId;
                self.close();
            }
        </script>
    </head>
    <body>
        <h1>Pencarian Surat</h1>
        <form name="frm" action="" method="post">
            <input type="hidden" name="command"/>
            <input type="hidden" name="jenisSK" value="<%=skType%>"/>
            <input type="text" name="doc_num" placeholder="nomor dokumen..." size="40" />
            <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Cari</a>
        </form>
        <div>&nbsp;</div>
        <%
            if (iCommand == Command.LIST){
        %>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl">Master Dokumen</td>
                <td class="title_tbl">Judul Dokumen</td>
                <td class="title_tbl">Tanggal Dokumen</td>
                <td class="title_tbl">Aksi</td>
            </tr>
            <%
                if (docList != null && docList.size()>0){
                    for(int i=0; i<docList.size(); i++){
                        EmpDoc doc = (EmpDoc)docList.get(i);
                        String docMasterName = "-";
                        try {
                            DocMaster docMaster = PstDocMaster.fetchExc(doc.getDoc_master_id());
                            docMasterName = docMaster.getDoc_title();
                        } catch(Exception ex){
                            System.out.println("emp doc=>"+ex.toString());
                        }
                        
                        %>
                        <tr>
                            <td><%= docMasterName %></td>
                            <td><%= doc.getDoc_number() %></td>
                            <td><%= doc.getDate_of_issue() %></td>
                            <% if (skType == 1) {%>
                                <td><a href="javascript:cmdGetJabatan('<%= doc.getDoc_number() %>', '<%= doc.getDate_of_issue() %>', '<%= doc.getOID() %>')">Pilih</a></td>
                            <% } else { %>
                                <td><a href="javascript:cmdGetGrade('<%= doc.getDoc_number() %>', '<%= doc.getDate_of_issue() %>', '<%= doc.getOID() %>')">Pilih</a></td>
                            <% } %>
                        </tr>
                        <%
                    }
                }
            %>
        </table>
        <%
            }
        %>
    </body>
</html>
