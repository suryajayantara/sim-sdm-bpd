<%-- 
    Document   : mapping_type_select
    Created on : Apr 29, 2020, 11:20:54 AM
    Author     : gndiw
--%>


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
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%!
	public String drawList(Vector objectClass ,  long positionTypeId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
                ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
                ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
		ctrlist.addHeader("Klasifikasi","");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdChoose('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			PositionType positionType = (PositionType)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(positionTypeId == positionType.getOID())
				 index = i;

			rowx.add(positionType.getType());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(positionType.getOID()));
		}

		return ctrlist.draw(index);
	}

    public String drawData(Vector objectClass) {
        String str = "";
            for (int i = 0; i < objectClass.size(); i++) {
                //
                Training training = (Training)objectClass.get(i);
                
                str += "<div id='divComp'><a href=\"javascript:cmdChoose('"+training.getOID()+"')\">"+training.getName()+"</a></div>";
            }
        
        return str;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidTraining = 0;

    String comm = request.getParameter("comm");
    Vector listPosType = PstPositionType.list(0, 0, "", "");

%>
<html>
<head>
    <title>Klaisifikasi Form</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
        function cmdChoose(trainingId) {
            self.opener.document.frmlevel.klasifikasi_id.value = trainingId;
            self.opener.document.frmlevel.command.value = "<%=comm%>";                 
            //self.close();
            self.opener.document.frmlevel.submit();
        }
    </script>
</head>
<body>
    <div id="content">
       
        <%if (listPosType != null && listPosType.size() > 0) {%>
        <%=drawList(listPosType, oidTraining)%>
        <%}else{%>
        <div>no record</div>
        <%}%>
        <!--
        <form name="frmsrctraining" action="" method="post">
            <input type="hidden" name="comman" value="" />
        <table>
            <tr>
                <td>
                    Name
                </td>
                <td>
                    <input type="text" name="training_name" id="" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    Description
                </td>
                <td>
                    <input type="text" name="training_description" id="" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    Department
                </td>
                <td>
                    <input type="text" name="training_department" id="" value="" />
                </td>
            </tr>
            <tr><td><button id="btn-sc" onclick="cmdSearch()">Search</button></td></tr>
        </table>
        </form>
        -->
    </div>
</body>
</html>
