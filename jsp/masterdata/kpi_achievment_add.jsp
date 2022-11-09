
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.attendance.I_Atendance"%>
<%
            /*
             * Page Name  		:  achievment add.jsp
             * Created on 		:  20150917
             *
             * @author  		: priska
             * @version  		: -
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

<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_PERFORMANCE, AppObjInfo.OBJ_KPI_COMPANY_TARGET);%>
<%@ include file = "../main/checkuser.jsp" %>

<%!

	public String drawList(int iCommand,FrmKPI_Employee_Achiev frmObject, Vector objectClass,  long kpiEmployeeAchievId,  long empId,  long kpiListId, long targetId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("80%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");

		if ((objectClass.size() > 0) || (iCommand == Command.ADD)) {
			ctrlist.addHeader("No", "3%");
			//ctrlist.addHeader("Star Date", "20%");
			//ctrlist.addHeader("End Date", "20%");
			ctrlist.addHeader("Entry Date", "20%");
			ctrlist.addHeader("Achievment", "20%");
			ctrlist.addHeader("Achievment Type", "20%");
			ctrlist.addHeader("Note", "20%");
			ctrlist.addHeader("Attach File", "20%");
			ctrlist.addHeader("Score", "20%");
			ctrlist.addHeader("Status", "20%");
		}
		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1, 1);
		ctrlist.reset();
		int index = -1;

		Vector typeKey = new Vector();
		Vector typeValue = new Vector();

		for (int i = 0; i < PstKPI_Employee_Achiev.typeAchiev.length; i++){
			typeKey.add(PstKPI_Employee_Achiev.typeAchiev[i]);
			typeValue.add(""+i);
		}

		KPI_List kPI_List = new KPI_List();
		try {
			kPI_List = PstKPI_List.fetchExc(kpiListId);
		} catch (Exception exc){}

		for (int i = 0; i < objectClass.size(); i++) {
			KPI_Employee_Achiev kPI_Employee_Achiev = (KPI_Employee_Achiev) objectClass.get(i);
			rowx = new Vector();
			if (kpiEmployeeAchievId == kPI_Employee_Achiev.getOID()) {
				index = i;
			}


			if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
				rowx.add("+  <input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_EMPLOYEE_ID] + "\" value=\"" + empId + "\" class=\"elemenForm\">"
						+ "<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_LIST_ID] + "\" value=\"" + kpiListId + "\" class=\"elemenForm\">"
						+ "<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_TARGET_ID] + "\" value=\"" + targetId + "\" class=\"elemenForm\">");
				//rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_STARTDATE], kPI_Employee_Achiev.getStartDate(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_STARTDATE));
				//rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ENDDATE], kPI_Employee_Achiev.getEndDate(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ENDDATE));
				rowx.add(ControlDate.drawDateWithStyle("", kPI_Employee_Achiev.getEntryDate(), 20, -40, "formElemen", "disabled") 
						+ " " + ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ENTRYDATE], kPI_Employee_Achiev.getEntryDate(), 20, -40, "formElemen", " style='display:none;'")
						+ " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ENTRYDATE));
				if (kPI_List.getInputType() == PstKPI_List.TYPE_WAKTU){
					rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_DATE], kPI_Employee_Achiev.getAchievDate(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ACHIEV_DATE));
				} else {
					rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEVMENT] + "\" value=\"" + kPI_Employee_Achiev.getAchievement() + "\" class=\"elemenForm\"> ");
				}
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_TYPE], "formElemen", null, "" + kPI_Employee_Achiev.getAchievType(), typeValue, typeKey));
				rowx.add("<textarea name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_NOTE] + "\" class=\"elemenForm\"> "+kPI_Employee_Achiev.getAchievNote()+"</textarea>");
				rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_PROOF]+"\"  value=\""+kPI_Employee_Achiev.getAchievProof()+"\" class=\"formElemen\">"+
						"<input type=\"hidden\" name=\""+frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_STATUS]+"\"  value=\""+kPI_Employee_Achiev.getStatus()+"\" class=\"formElemen\">"+
                        "<img border=\"0\" src=\"../images/BtnNew.jpg\" width=\"20\" height=\"20\" ><div  valign =\"top\" align=\"center\"><a style=\"text-decoration:none\" href =\"javascript:cmdAttach('" + kPI_Employee_Achiev.getOID() + "')\"><font color=\"#30009D\">Attach File</font></a></div>");
				rowx.add("");
				rowx.add(I_DocStatus.fieldDocumentStatus[kPI_Employee_Achiev.getStatus()] );
				
			} else {
rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(kPI_Employee_Achiev.getOID()) + "')\">" + (i + 1) + "</a> <input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_EMPLOYEE_ID] + "\" value=\"" + empId + "\" class=\"elemenForm\"><input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_LIST_ID] + "\" value=\"" + kpiListId + "\" class=\"elemenForm\">");
				//rowx.add("" + kPI_Employee_Achiev.getStartDate());
				//rowx.add("" + kPI_Employee_Achiev.getEndDate());
				rowx.add("" + kPI_Employee_Achiev.getEntryDate());
				if (kPI_List.getInputType() == PstKPI_List.TYPE_WAKTU){
					rowx.add("" + kPI_Employee_Achiev.getAchievDate());
				} else {
					rowx.add("" + kPI_Employee_Achiev.getAchievement());
				}
				rowx.add(""+PstKPI_Employee_Achiev.typeAchiev[kPI_Employee_Achiev.getAchievType()]);
				rowx.add("" + kPI_Employee_Achiev.getAchievNote());
				if (kPI_Employee_Achiev.getAchievProof().length()>0){
					rowx.add("<a href=\"javascript:cmdOpen('" + kPI_Employee_Achiev.getAchievProof() + "')\">" + kPI_Employee_Achiev.getAchievProof() + "</a> ");
				} else {
					rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_PROOF]+"\"  value=\""+kPI_Employee_Achiev.getAchievProof()+"\" class=\"formElemen\">"+
                        "<img border=\"0\" src=\"../images/BtnNew.jpg\" width=\"20\" height=\"20\" ><div  valign =\"top\" align=\"center\"><a style=\"text-decoration:none\" href =\"javascript:cmdAttach('" + kPI_Employee_Achiev.getOID() + "')\"><font color=\"#30009D\">Attach File</font></a></div>");
				}
				if (kPI_Employee_Achiev.getAchievType() == PstKPI_Employee_Achiev.TYPE_FINISH){
					double score = PstKPI_Employee_Achiev.getScore(kPI_Employee_Achiev.getOID());
					rowx.add(""+score+" %");
				} else {
				rowx.add("");
				}
				rowx.add(I_DocStatus.fieldDocumentStatus[kPI_Employee_Achiev.getStatus()]+ " | <a href=\"javascript:cmdViewApproval('"+kPI_Employee_Achiev.getOID()+"')\">View Approval</a>" );
				

			}

			lstData.add(rowx);
		}

		rowx = new Vector();

		if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
			KPI_Employee_Achiev kPI_Employee_Achiev = new KPI_Employee_Achiev();
			rowx.add("+  <input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_EMPLOYEE_ID] + "\" value=\"" + empId + "\" class=\"elemenForm\">"
						+ "<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_LIST_ID] + "\" value=\"" + kpiListId + "\" class=\"elemenForm\">"
						+ "<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_TARGET_ID] + "\" value=\"" + targetId + "\" class=\"elemenForm\">");
			//rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_STARTDATE], new Date(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_STARTDATE));
			//rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ENDDATE], new Date(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ENDDATE));
			rowx.add(ControlDate.drawDateWithStyle("", new Date(), 20, -40, "formElemen", "disabled") +
				" " + ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ENTRYDATE], new Date(), 20, -40, "formElemen", "style='display:none;'") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ENTRYDATE) +
				"  "+frmObject.getErrorMsg(frmObject.FRM_FIELD_ENTRYDATE));
			if (kPI_List.getInputType() == PstKPI_List.TYPE_WAKTU){
				rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_DATE], new Date(), 20, -40, "formElemen") + " " + frmObject.getErrorMsg(frmObject.FRM_FIELD_ACHIEV_DATE));
			} else {
				rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEVMENT] + "\" value=\"" + kPI_Employee_Achiev.getAchievement() + "\" class=\"elemenForm\"> ");
			}
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_TYPE], "formElemen", null, "" + 0, typeValue, typeKey));
				rowx.add("<textarea name=\"" + frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_NOTE] + "\" class=\"elemenForm\"></textarea>");
			rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_STATUS]+"\"  value=\"0\" class=\"formElemen\">");
			rowx.add("");
			rowx.add("");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidKPI_Employee_Achiev = FRMQueryString.requestLong(request, "hidden_kPI_Employee_Achiev_id");

            long oidEmp = FRMQueryString.requestLong(request, "oidEmp");
            long kpiListId = FRMQueryString.requestLong(request, "kpiListId");
			long targetId = FRMQueryString.requestLong(request, "targetId");
            
               /*variable declaration*/
            int recordToGet = 50;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = ""+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID]+" = "+oidEmp+ " AND "+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_LIST_ID]+" = "+kpiListId
						+" AND "+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_TARGET_ID]+" = "+targetId;
            String orderClause = ""+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STARTDATE];

            CtrlKPI_Employee_Achiev ctrlKPI_Employee_Achiev = new CtrlKPI_Employee_Achiev(request);
            ControlLine ctrLine = new ControlLine();
            Vector listKPI_Employee_Achiev = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlKPI_Employee_Achiev.action(iCommand, oidKPI_Employee_Achiev);
            /* end switch*/
            FrmKPI_Employee_Achiev frmKPI_Employee_Achiev = ctrlKPI_Employee_Achiev.getForm();

            /*count list All Position*/
            int vectSize = PstKPI_Employee_Achiev.getCount(whereClause);

            KPI_Employee_Achiev kPI_Employee_Achiev = ctrlKPI_Employee_Achiev.getdKPI_Employee_Achiev();
            msgString = ctrlKPI_Employee_Achiev.getMessage();

			KPI_Employee_Target empTarget = new KPI_Employee_Target();
			try {
				empTarget = PstKPI_Employee_Target.fetchExc(targetId);
			} catch (Exception exc){}
			
            /*switch list KPI_Employee_Achiev*/
            if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
                //start = PstKPI_Employee_Achiev.findLimitStart(kPI_Employee_Achiev.getOID(),recordToGet, whereClause);
                oidKPI_Employee_Achiev = kPI_Employee_Achiev.getOID();
            }

            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                start = ctrlKPI_Employee_Achiev.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listKPI_Employee_Achiev = PstKPI_Employee_Achiev.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listKPI_Employee_Achiev.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;   //go to Command.PREV
                } else {
                    start = 0;
                    iCommand = Command.FIRST;
                    prevCommand = Command.FIRST; //go to Command.FIRST
                }
                listKPI_Employee_Achiev = PstKPI_Employee_Achiev.list(start, recordToGet, whereClause, orderClause);
            }

                
            
            String whereEmployeeID = " hket."+ PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_EMPLOYEE_ID] + " = " + oidEmp +" AND hket."+ PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = " + kpiListId  ;
            Vector listKpiTarget = PstKPI_List.listInnerJoinKPIEmpTarget(0, 0, whereEmployeeID, "") ; 
            KPI_List kPI_List = new KPI_List();
            double totalAchievment  = 0;
            double totalTarget = 0;
            try {
                kPI_List = (KPI_List) listKpiTarget.get(0);
                totalTarget = PstKPI_Employee_Target.getTotalTargetEmployee(oidEmp, kpiListId);//mencari total target
                totalAchievment = PstKPI_Employee_Achiev.getTotalAchievEmployee(oidEmp, kpiListId);//mencari total achievment
            } catch (Exception e){
                
            }
            
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Master Data KPI_Employee_Achiev</title>
        <script language="JavaScript">


            function cmdAdd(){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value="0";
                document.frmkPI_Employee_Achiev.command.value="<%=Command.ADD%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }
			
			function cmdViewApproval(achievId){
                newWindow=window.open("view_approval_achiev.jsp?achiev_id="+achievId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
            }

            function cmdAsk(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.ASK%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdConfirmDelete(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.DELETE%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }
            function cmdSave(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.SAVE%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdEdit(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.EDIT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdCancel(oidKPI_Employee_Achiev){
                document.frmkPI_Employee_Achiev.hidden_kPI_Employee_Achiev_id.value=oidKPI_Employee_Achiev;
                document.frmkPI_Employee_Achiev.command.value="<%=Command.EDIT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=prevCommand%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdBack(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.BACK%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListFirst(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.FIRST%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.FIRST%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListPrev(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.PREV%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.PREV%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListNext(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.NEXT%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.NEXT%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }

            function cmdListLast(){
                document.frmkPI_Employee_Achiev.command.value="<%=Command.LAST%>";
                document.frmkPI_Employee_Achiev.prev_command.value="<%=Command.LAST%>";
                document.frmkPI_Employee_Achiev.action="kpi_achievment_add.jsp";
                document.frmkPI_Employee_Achiev.submit();
            }
			
			function cmdAttach(oidAchiev){
                //document.frmleavestock.command.value="<!--%=Command.EDIT%-->";
                //document.frm_relevant_doc_pages.hidden_leave_stock_id.value = oid;
                //document.frmleavestock.note_type.value = type;
                //document.frmleavestock.action="leavestock_editor.jsp";
                //document.frmleavestock.submit();

                window.open("upload_achiev_proof.jsp?command="+<%=Command.EDIT%>+"&oid_emp_achiev=" + oidAchiev , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");

            }
			
			function cmdOpen(fileName){
		window.open("<%=approot%>/imgdoc/"+fileName , null);	
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

                //-------------- script control line -------------------
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

        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" -->
        <SCRIPT language=JavaScript>
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

        </SCRIPT>
        <!-- #EndEditable -->
    </head>

    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
             <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%//@include file="../styletemplate/template_header.jsp" %>
            <%}else{%>
            <tr>
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54">
                    <!-- #BeginEditable "header" -->
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable -->
                </td>
            </tr>
            <tr>
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" -->
                    <%@ include file = "../main/mnmain.jsp" %>
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
                                                    ADD ACHIEVMENT 
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
                                                                                <form name="frmkPI_Employee_Achiev" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="hidden_kPI_Employee_Achiev_id" value="<%=oidKPI_Employee_Achiev%>">
                                                                                    <input type="hidden" name="oidEmp" value="<%=oidEmp%>">
                                                                                    <input type="hidden" name="kpiListId" value="<%=kpiListId%>">
																					<input type="hidden" name="targetId" value="<%=targetId%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8"  colspan="3">
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="14" valign="middle" colspan="3" class="listtitle">TITLE : &nbsp;<%=kPI_List.getKpi_title() %> </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
																										<% switch(kPI_List.getInputType()){
																											case PstKPI_List.TYPE_WAKTU:
																												%>
																												<td height="14" >Target :&nbsp;<%= Formater.formatDate(empTarget.getStartDate(), "yyyy-MM-dd") + " - " + Formater.formatDate(empTarget.getEndDate(), "yyyy-MM-dd")  %> </td>
																												<%
																											break;
																											case PstKPI_List.TYPE_JUMLAH:
																												%>
																												<td height="14" >TOTAL TARGET :&nbsp;<%=empTarget.getTarget()%> </td>
																												<%
																											break;
																											case PstKPI_List.TYPE_PERSENTASE:
																												%>
																												<td height="14" >TOTAL TARGET :&nbsp;<%=empTarget.getTarget()%> </td>
																												<%
																											break;
																										}%>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="14" >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="14" >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="22" valign="middle" colspan="3">
                                                                                                            <%= drawList(iCommand, frmKPI_Employee_Achiev,listKPI_Employee_Achiev, oidKPI_Employee_Achiev, oidEmp, kpiListId, targetId) %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                               
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="8" align="left" colspan="3" class="command">
                                                                                                            <span class="command">
                                                                                                                <%
                                                                                                                            int cmd = 0;
                                                                                                                            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                                                                                                                                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                                                                                                                                cmd = iCommand;
                                                                                                                            } else {
                                                                                                                                if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                                                                                                                                    cmd = Command.FIRST;
                                                                                                                                } else {
                                                                                                                                    cmd = prevCommand;
                                                                                                                                }
                                                                                                                            }
                                                                                                                %>
                                                                                                                <% ctrLine.setLocationImg(approot + "/images");
                                                                                                                            ctrLine.initDefault();
                                                                                                                %>
                                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%>
                                                                                                            </span> </td>
                                                                                                    </tr>
                                                                                                  
                                                                                                       <%//if((iCommand == Command.NONE || iCommand == Command.DELETE || iCommand == Command.BACK || iCommand ==Command.SAVE)&& (frmKPI_Employee_Achiev.errorSize()<1)){
                                                                                                    if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmKPI_Employee_Achiev.errorSize() < 1)) {
                                                                                                        if (privAdd) {%>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                                    <td width="24"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                                                                                    <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                                    <td height="22" valign="middle" colspan="3" width="951">
                                                                                                                        <a href="javascript:cmdAdd()" class="command">Add
                                                                                                                            New </a> </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                                      }%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmKPI_Employee_Achiev.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    
                                                                                                    <tr>
                                                                                                        <td colspan="2">
                                                                                                            <%
                                                                                                                ctrLine.setLocationImg(approot + "/images");
                                                                                                                ctrLine.initDefault();
                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                String scomDel = "javascript:cmdAsk('" + oidKPI_Employee_Achiev + "')";
                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidKPI_Employee_Achiev + "')";
                                                                                                                String scancel = "javascript:cmdEdit('" + oidKPI_Employee_Achiev + "')";
                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                ctrLine.setCommandStyle("buttonlink");
                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                ctrLine.setSaveCaption("Save");
                                                                                                                ctrLine.setConfirmDelCaption("Yes Delete");
                                                                                                                ctrLine.setDeleteCaption("Delete");

                                                                                                                if (privDelete) {
                                                                                                                    ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                                                    ctrLine.setDeleteCommand(scomDel);
                                                                                                                    ctrLine.setEditCommand(scancel);
                                                                                                                } else {
                                                                                                                    ctrLine.setConfirmDelCaption("");
                                                                                                                    ctrLine.setDeleteCaption("");
                                                                                                                    ctrLine.setEditCaption("");
                                                                                                                }

                                                                                                                if (privAdd == false && privUpdate == false) {
                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                }

                                                                                                                if (privAdd == false) {
                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                }

                                                                                                                if (iCommand == Command.ASK) {
                                                                                                                    ctrLine.setDeleteQuestion(msgString);
                                                                                                                }
                                                                                                            %>
                                                                                                            <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <% } %>
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
                                <%@include file="../footer.jsp" %>
                            </td>
                            
            </tr>
            <%}else{%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
      <%@ include file = "../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" -->
    <script language="JavaScript">
                //var oBody = document.body;
                //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
    <!-- #EndEditable -->
    <!-- #EndTemplate --></html>

