<%-- 
    Document   : assessment_search
    Created on : Mar 11, 2020, 4:22:16 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_POSITION);%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>

<%!
	public String drawList(Vector objectClass ,  long assessmentId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
                ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
                ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
		ctrlist.addHeader("Assessment","");                
                ctrlist.addHeader("Description", "");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdChoose('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Assessment assessment = (Assessment)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(assessmentId == assessment.getOID())
				 index = i;

			rowx.add(assessment.getAssessmentType());
                        rowx.add(""+assessment.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(assessment.getOID()));
		}

		return ctrlist.draw(index);
	}

    public String drawData(Vector objectClass) {
        String str = "";
            for (int i = 0; i < objectClass.size(); i++) {
                //
                Assessment assessment = (Assessment)objectClass.get(i);
                
                str += "<div id='divComp'><a href=\"javascript:cmdChoose('"+assessment.getOID()+"')\">"+assessment.getAssessmentType()+"</a></div>";
            }
        
        return str;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidAssessment = 0;

    String comm = request.getParameter("comm");
    Vector listAssessment = PstAssessment.list(0, 0, "", "");

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assessment</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
            }
            #title {
                padding: 5px 7px;
                border-bottom: 1px solid #0099FF;
                background-color: #EEE;
                font-size: 24px;
                color: #333;
            }
            #content {
                background-color: #F7F7F7;
                padding: 5px 7px;
                margin-top: 7px;
            }
            #btn-sc {
                padding: 3px 7px;
                border: 1px solid #CCC;
                background-color: #EEE;
                color: #333;
            }
            #btn-sc:hover {
                background-color: #999;
                color: #FFF;
            }
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
        </style>
        <script language="javascript">
            function cmdChoose(assessmentId) {
                self.opener.document.frmposition.assessment_id.value = assessmentId;
                self.opener.document.frmposition.command.value = "<%=comm%>";                 
                //self.close();
                self.opener.document.frmposition.submit();
            }
            function cmdSearch(){
                document.frmsrcassessment.command.value="<%=Command.LIST%>";
                document.frmsrcassessment.action="assessment_search.jsp";
                document.frmsrcassessment.submit();
            }
        </script>
    </head>
    <body>
        <div id="title">Training Search</div>
        <div id="content">

            <%if (listAssessment != null && listAssessment.size() > 0) {%>
            <%=drawList(listAssessment, oidAssessment)%>
            <%}else{%>
            <div>no record</div>
            <%}%>
        </div>
    </body>
</html>
