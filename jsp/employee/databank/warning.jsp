<%@ page language = "java" %>

<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.form.employee.*" %>
<%@ page import = "com.dimata.harisma.session.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ include file = "../../main/javainit.jsp" %>

<%-- YANG INI BELUM DIEDIT --%>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_WARNING); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Ari_20110909
    Menambah Warning Point { -->
<!-- Jsp Block -->
<%
/* OBJ_DATABANK_PERSONAL_DATA = 1; */
int appObjCodePer = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PERSONAL_DATA);
boolean privViewPer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_FAMILY_MEMBER = 2; */
int appObjCodeFam = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_FAMILY_MEMBER);
boolean privViewFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_VIEW));
boolean privUpdateFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_LANG_N_COMPETENCE = 3; */
int appObjCodeLang = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_LANG_N_COMPETENCE);
boolean privViewLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_VIEW));
boolean privUpdateLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EDUCATION = 4; */
int appObjCodeEdu = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EDUCATION);
boolean privViewEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_VIEW));
boolean privUpdateEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EXPERIENCE = 5; */
int appObjCodeExp = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EXPERIENCE);
boolean privViewExp = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeExp, AppObjInfo.COMMAND_VIEW));
boolean privUpdateExp = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeExp, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_CAREERPATH = 6; */
int appObjCodeCar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_CAREERPATH);
boolean privViewCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_UPDATE));
/* On The Top */
/* OBJ_DATABANK_TRAINING = 7; */
int appObjCodeTra = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_TRAINING);
boolean privViewTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_VIEW));
boolean privUpdateTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_WARNING = 8; */
/* OBJ_DATABANK_REPRIMAND = 9; */
int appObjCodeRep = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_REPRIMAND);
boolean privViewRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_AWARD = 10; */
int appObjCodeAwr = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_AWARD);
boolean privViewAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_VIEW));
boolean privUpdateAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_PICTURE = 11; */
int appObjCodePic = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PICTURE);
boolean privViewPic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_RELEVANT_DOC = 12; */
int appObjCodeRel = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_RELEVANT_DOC);
boolean privViewRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_UPDATE));
/////
%>
<%!

	public String drawList(Vector objectClass ,  long empWarningId, boolean privUpdate, String className)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
                ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
		ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
		ctrlist.addHeader("NO.","","align='center'");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.COMPANY),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DIVISION),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DEPARTMENT),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.SECTION),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.POSITION),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.LEVEL),"");
                ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.CATEGORY),"");
		ctrlist.addHeader("BREAK DATE","");
		ctrlist.addHeader("BREAK FACT","");
		ctrlist.addHeader("WARNING DATE","");
		ctrlist.addHeader("WARNING BY","");
                ctrlist.addHeader("VALID UNTIL","");
                ctrlist.addHeader("LEVEL","");
                ctrlist.addHeader("POINT","","align='center'");
				ctrlist.addHeader("Document","","align='center'");

		Vector lstData = ctrlist.getData();

		ctrlist.reset();
		int index = -1;
                int recordNo = 1;

		for (int i = 0; i < objectClass.size(); i++) {
			EmpWarning empWarning = (EmpWarning)objectClass.get(i);
                        Company comp = new Company();
                        Division div = new Division();
                        Department dep = new Department();
                        Section sec = new Section();
                        Position pos = new Position();
                        Level level = new Level();
                        EmpCategory cat = new EmpCategory();
                        
                        String compString = "-";
                        String divString = "-";
                        String depString = "-";
                        String secString = "-";
                        String posString = "-";
                        String levelString = "-";
                        String catString = "-";

                        try {
                            comp = PstCompany.fetchExc(empWarning.getCompanyId());   
                            compString = comp.getCompany();
                        }
                        catch(Exception e) {
                            comp = new Company();                    
                        }                        

                        try {
                            div = PstDivision.fetchExc(empWarning.getDivisionId());   
                            divString = div.getDivision();
                        }
                        catch(Exception e) {
                            div = new Division();                    
                        }                        

                        try {
                            dep = PstDepartment.fetchExc(empWarning.getDepartmentId());   
                            depString = dep.getDepartment();
                        }
                        catch(Exception e) {
                            dep = new Department();                    
                        }                        

                        try {
                            sec = PstSection.fetchExc(empWarning.getSectionId());   
                            secString = sec.getSection();
                        }
                        catch(Exception e) {
                            sec = new Section();                    
                        }                        

                        try {
                            pos = PstPosition.fetchExc(empWarning.getPositionId());   
                            posString = pos.getPosition();
                        }
                        catch(Exception e) {
                            pos = new Position();                    
                        }                        

                        try {
                            level = PstLevel.fetchExc(empWarning.getLevelId());   
                            levelString = level.getLevel();
                        }
                        catch(Exception e) {
                            level = new Level();                    
                        }                        

                        try {
                            cat = PstEmpCategory.fetchExc(empWarning.getEmpCategoryId());   
                            catString = cat.getEmpCategory();
                        }
                        catch(Exception e) {
                            cat = new EmpCategory();                    
                        }                          

			 Vector rowx = new Vector();
			 if(empWarningId == empWarning.getOID())
				 index = i;

			Warning warning = new Warning();
			if(empWarning.getWarnLevelId() != -1){
				try{
					warning = PstWarning.fetchExc(empWarning.getWarnLevelId());
				}catch(Exception exc){
					warning = new Warning();
				}
			}

			rowx.add(String.valueOf(recordNo++));
                        if (privUpdate == true){
                            rowx.add("<a href=\"javascript:cmdEdit('"+empWarning.getOID()+"')\">"+compString+"</a>");
                        } else {
                            rowx.add(compString);
                        }
                        
                        rowx.add(divString);
                        rowx.add(depString);
                        rowx.add(secString);
                        rowx.add(posString);
                        rowx.add(levelString);
                        rowx.add(catString);
                        String breakDate = "";
                        breakDate = Formater.formatDate(empWarning.getBreakDate(), "MMM d, yyyy");
                        
                        rowx.add(breakDate);
                        rowx.add(empWarning.getBreakFact());
                        rowx.add(Formater.formatDate(empWarning.getWarningDate(), "MMM d, yyyy"));
                        rowx.add(empWarning.getWarningBy());
                        rowx.add(Formater.formatDate(empWarning.getValidityDate(), "MMM d, yyyy"));
                        rowx.add(String.valueOf(warning.getWarnDesc()));
                        rowx.add(String.valueOf(warning.getWarnPoint()));
						rowx.add("<a href=\"javascript:cmdDetailUp('"+empWarning.getOID()+"','"+className+"')\">Detail</a>");
                        lstData.add(rowx);

		}

		return ctrlist.draw(index);
	}

%>


<%
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request,"prev_command");
    long oidEmployee = FRMQueryString.requestLong(request,"employee_oid");
    long oidWarning = FRMQueryString.requestLong(request, "warning_id");
    int start = FRMQueryString.requestInt(request, "start");
    // data upload dedy 20160318
    String className = "";

    /*String[] listTitles =
    {
        "NO",
        "BREAK DATE",
        "BREAK FACT",
        "WARNING DATE",
        "WARNING BY",
        "VALID UNTIL",
        "WARNING_LEVEL"
    };*/

    int recordToGet = 10;
    //String errMsg = "";
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = PstEmpWarning.fieldNames[PstEmpWarning.FLD_EMPLOYEE_ID] + "=" + oidEmployee;
    String orderClause = PstEmpWarning.fieldNames[PstEmpWarning.FLD_BREAK_DATE];

    //int defaultWarnLevel = 0;

    Employee employee = new Employee();
    Department department = new Department();
    Section section = new Section();
    Position position = new Position();
    Level level = new Level();
    EmpCategory empCategory = new EmpCategory();

    // GET EMPLOYEE DATA TO DISPLAY
    try {
        employee = PstEmployee.fetchExc(oidEmployee);

        long oidDepartment = employee.getDepartmentId();
        department = PstDepartment.fetchExc(oidDepartment);

        long oidSection = employee.getSectionId();
        section = PstSection.fetchExc(oidSection);
    }
    catch(Exception e) {
        employee = new Employee();
        department = new Department();
        section = new Section();
    }

    CtrlEmpWarning ctrlWarning = new CtrlEmpWarning(request);
    ControlLine ctrLine = new ControlLine();
    Vector listWarning = new Vector(1,1);

    /* EXECUTE ACTION COMMAND */
    iErrCode = ctrlWarning.action(iCommand, oidWarning, request, emplx.getFullName(), appUserIdSess);
    //errMsg = ctrlWarning.getMessage();


    /*count list All EmpEducation*/



    msgString =  ctrlWarning.getMessage();

    EmpWarning empWarning = ctrlWarning.getEmpWarning();
    FrmEmpWarning frmEmpWarning = ctrlWarning.getForm();
    EmpWarning warning = ctrlWarning.getEmpWarning();
    // data upload dedy 20160318
    className = empWarning.getClass().getName();

    int vectSize = PstEmpWarning.getCount(whereClause);

if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)&& (oidWarning == 0))
            start = PstEmpWarning.findLimitStart(empWarning.getOID(),recordToGet, whereClause, orderClause);

    /* CASE NAVIGATION COMMAND */
    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
       (iCommand == Command.NEXT || iCommand == Command.LAST)){

        start = ctrlWarning.actionList(iCommand, start, vectSize, recordToGet);
    }

/* test */
    /* GET WARNING DATA TO DISPLAY */
    listWarning = PstEmpWarning.list(start, recordToGet, whereClause, orderClause);


    // design vector that handle data to store in session
    Vector warningReport = new Vector();

    warningReport.add(warning);
    warningReport.add(employee);

    session.putValue("LETTER_OF_WARNING", warningReport);


%>
<!-- End of Jsp Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>HARISMA - Warning</title>
<script language="JavaScript">

    function cmdBackToList(){
        document.fredit.start.value="0";
        document.fredit.command.value="<%=Command.BACK%>";
        document.fredit.action="../warning/warning_list.jsp";
        document.fredit.submit();
    }

    function cmdBackEmp(oid){
	document.fredit.employee_oid.value=oid;
	document.fredit.command.value="<%=Command.EDIT%>";
	document.fredit.action="employee_edit.jsp";
	document.fredit.submit();
    }

    function cmdBack(){
	document.fredit.command.value="<%=Command.BACK%>";
	document.fredit.action="warning.jsp";
	document.fredit.submit();
    }

    function cmdAdd(){
        document.fredit.warning_id.value="0";
        document.fredit.command.value="<%=Command.ADD%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdEdit(oid){
        document.fredit.warning_id.value=oid;
        document.fredit.command.value="<%=Command.EDIT%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdSave(){
        document.fredit.warning_id.value="<%= oidWarning %>";
	document.fredit.command.value="<%=Command.SAVE%>";
	document.fredit.prev_command.value="<%=iCommand%>";    /* edit atau add */
	document.fredit.action="warning.jsp";
	document.fredit.submit();
    }

    function cmdCancel(){
        document.fredit.command.value="<%=Command.CANCEL%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdAsk(oid){
        document.fredit.command.value="<%=Command.ASK%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdDelete(oidWarning){
        document.fredit.command.value="<%=Command.DELETE%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdPrint(){
	var rptSource = "<%=printroot%>.report.employee.EmployeeWarningPdf";
	window.open(rptSource);
    }


    function cmdListFirst(){
        document.fredit.command.value="<%=Command.FIRST%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdListPrev(){
        document.fredit.command.value="<%=Command.PREV%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdListNext(){
        document.fredit.command.value="<%=Command.NEXT%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdListLast(){
        document.fredit.command.value="<%=Command.LAST%>";
        document.fredit.action="warning.jsp";
        document.fredit.submit();
    }

    function cmdListEmployee(){
        document.fredit.command.value="<%=iCommand%>";
        win = window.open("<%=approot%>/employee/warning/src_emp.jsp?formName=fredit&empPathId=<%= FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");

    }
    
    // data upload dedy 20160318
    function cmdDetailUp(oidEmpWarning, className){
        window.open("<%=approot%>/system/dataupload/data_upload.jsp?object_id="+oidEmpWarning+"&classname="+className, null, "height=800,width=800,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
    }

</script>

<script type="text/javascript">

    function loadCompany(oid) {
        if (oid.length == 0) { 
            document.getElementById("txtHint").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax.jsp?warning_id=" + oid, true);
            xmlhttp.send();
        }
    }
    
    function loadDivision(str) {
        if (str.length == 0) { 
            document.getElementById("txtHint").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax.jsp?company_id=" + str, true);
            xmlhttp.send();
        }
    }
    
    function loadDepartment(comp_id, divisi_id) {
        if ((comp_id.length == 0)&&(divisi_id.length == 0)) { 
            document.getElementById("txtHint").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax.jsp?company_id="+comp_id+"&division_id=" + divisi_id, true);
            xmlhttp.send();
        }
    }
    
    function loadSection(comp_id, divisi_id, depart_id) {
        if ((comp_id.length == 0)&&(divisi_id.length == 0)&&(depart_id.length == 0)) { 
            document.getElementById("txtHint").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax.jsp?company_id="+comp_id+"&division_id=" + divisi_id +"&department_id="+depart_id, true);
            xmlhttp.send();
        }
    }
    
     
    function loadValidUntil(iCommand) {
        var year =   document.fredit.WARN_DATE_yr.value;
        var month =   document.fredit.WARN_DATE_mn.value;
        if(month.length == 1){
            month = "0"+month;
        }
        var date =   document.fredit.WARN_DATE_dy.value;
        if(date.length == 1){
            date = "0"+date;
        }
        
        var oidWarningLevel = document.fredit.WARNING_LEVEL_ID.value;
        var oidWarning = document.fredit.warning_id.value;
        var warnDate = year+"-"+month+"-"+date;
        
       
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtValidUntil").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax_valid_until.jsp?oidWarningLevel=\""+oidWarningLevel+"\"&warningDate=" + warnDate+"&iCommand="+iCommand+"&oidWarning="+oidWarning+"&type=load" , true);
            xmlhttp.send();
    }
    
        function changeValidUntil(iCommand) {
        var year =   document.fredit.WARN_DATE_yr.value;
        var month =   document.fredit.WARN_DATE_mn.value;
        if(month.length == 1){
            month = "0"+month;
        }
        var date =   document.fredit.WARN_DATE_dy.value;
        if(date.length == 1){
            date = "0"+date;
        }
        
        var oidWarningLevel = document.fredit.WARNING_LEVEL_ID.value;
        var oidWarning = document.fredit.warning_id.value;
        var warnDate = year+"-"+month+"-"+date;
        
       
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtValidUntil").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "warning_ajax_valid_until.jsp?oidWarningLevel=\""+oidWarningLevel+"\"&warningDate=" + warnDate+"&iCommand="+iCommand+"&oidWarning="+oidWarning+"&type=change" , true);
            xmlhttp.send();
    }
    
    
</script>

<style type="text/css">
    .tblStyle {border-collapse: collapse;font-size: 11px;}
    .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
    .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
    .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

    body {color:#373737;}
    #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
    #menu_title {color:#0099FF; font-size: 14px; font-weight: bold;}
    #menu_teks {color:#CCC;}
    #box_title {padding:9px; background-color: #D5D5D5; font-weight: bold; color:#575757; margin-bottom: 7px; }
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
    .breadcrumb {
        background-color: #EEE;
        color:#0099FF;
        padding: 7px 9px;
    }
    .navbar {
        font-family: sans-serif;
        font-size: 12px;
        background-color: #0084ff;
        padding: 7px 9px;
        color : #FFF;
        border-top:1px solid #0084ff;
        border-bottom: 1px solid #0084ff;
    }
    .navbar ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
    }

    .navbar li {
        padding: 7px 9px;
        display: inline;
        cursor: pointer;
    }

    .navbar li:hover {
        background-color: #0b71d0;
        border-bottom: 1px solid #033a6d;
    }

    .active {
        background-color: #0b71d0;
        border-bottom: 1px solid #033a6d;
    }
    .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
</style>
        <style type="text/css">
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                background-color: #FFF;
                margin: 25px 23px 59px 23px;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
                background-color: #EEE;
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
            .btn {
                background: #ebebeb;
                background-image: -webkit-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -moz-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -ms-linear-gradient(top, #ebebeb, #dddddd);
                background-image: -o-linear-gradient(top, #ebebeb, #dddddd);
                background-image: linear-gradient(to bottom, #ebebeb, #dddddd);
                -webkit-border-radius: 5;
                -moz-border-radius: 5;
                border-radius: 3px;
                font-family: Arial;
                color: #7a7a7a;
                font-size: 12px;
                padding: 5px 11px 5px 11px;
                border: solid #d9d9d9 1px;
                text-decoration: none;
            }

            .btn:hover {
                color: #474747;
                background: #ddd;
                background-image: -webkit-linear-gradient(top, #ddd, #CCC);
                background-image: -moz-linear-gradient(top, #ddd, #CCC);
                background-image: -ms-linear-gradient(top, #ddd, #CCC);
                background-image: -o-linear-gradient(top, #ddd, #CCC);
                background-image: linear-gradient(to bottom, #ddd, #CCC);
                text-decoration: none;
                border: 1px solid #C5C5C5;
            }
            
            .btn-small {
                padding: 3px; border: 1px solid #CCC; 
                background-color: #EEE; color: #777777; 
                font-size: 11px; cursor: pointer;
            }
            .btn-small:hover {border: 1px solid #999; background-color: #CCC; color: #FFF;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {padding: 7px 0px 2px 0px; font-size: 12px; font-weight: bold; color: #575757;}
            #div_input {}
            
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                margin-bottom: 2px;
                border-bottom: 1px solid #DDD;
                background-color: #EEE;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                padding: 21px;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                margin-top: 2px;
                background-color: #EEE;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 18px 21px;
                background-color: #FF6666;
                color: #FFF;
                border: 1px solid #CF5353;
            }
            #btn-confirm {
                padding: 3px; border: 1px solid #CF5353; 
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                
            }
            #box_delete {visibility: hidden;}
            #txtHint {

            }
            .caption {font-weight: bold;}
            .divinput {margin-bottom: 5px;}
            #req {background-color: #FF6666; color:#FFF; padding: 5px; border-radius: 2px;}
            
        </style>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "styles" -->
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
<script>

   function pageLoad(){ 
       loadCompany('<%=oidWarning%>'); 
       loadValidUntil('<%=iCommand%>');
    }  
</script>
</head>
<body onload="pageLoad()">
    <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
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
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title"><%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%> <strong style="color:#333;"> / </strong> <%=dictionaryD.getWord(I_Dictionary.WARNING) %></span>
        </div>
        
        <% if (oidEmployee != 0) {%>
        <div class="navbar">

            <ul style="margin-left: 97px">
                    <% if (privViewPer == true){ 
                            if (privUpdatePer){
                    %>
                                <li class=""> <a href="employee_edit.jsp?employee_oid=<%=oidEmployee%>&prev_command=<%=Command.EDIT%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="employee_view_new.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } 
                       }
                    %>
                    <% if (privViewFam == true){ 
                            if (privUpdateFam){
                    %>
                                <li class=""> <a href="familymember.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="familymember_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewLang == true){ 
                            if (privUpdateLang){
                    %>
                                <li class=""> <a href="emplanguage.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="emplanguage_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewEdu == true){ 
                            if (privUpdateEdu){
                    %>
                                <li class=""> <a href="empeducation.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="empeducation_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewExp == true){ 
                            if (privUpdateExp){
                    %>
                                <li class=""> <a href="experience.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="experience_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewCar == true){ 
                            if (privUpdateCar){
                    %>
                                <li class=""> <a href="careerpath.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="careerpath_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewTra == true){ 
                            if (privUpdateTra){
                    %>
                                <li class=""> <a href="training.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } else { %>
                                <li class=""> <a href="training_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } 
                        }
                    %>
                    <li class="active"> <%=dictionaryD.getWord(I_Dictionary.WARNING) %> </li>
                    <% if (privViewRep == true){ 
                            if (privUpdateRep){
                    %>
                                <li class=""> <a href="reprimand.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="reprimand_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewAwr == true){ 
                            if (privUpdateAwr){
                    %>
                                <li class=""> <a href="award.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="award_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewPic == true){ %>
                                <li class=""> <a href="picture.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PICTURE) %></a> </li>
                    <% } %>
                    <% if (privViewRel == true){ 
                            if (privUpdateRel){
                    %>
                                <li class=""> <a href="doc_relevant.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="doc_relevant_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } 
                        }
                    %>
            </ul>
         </div>
        <%}%>
        
        <div class="content-main">
            <form name="fredit" method="post" action="">
                <input type="hidden" name="command" value="">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="employee_oid" value="<%=oidEmployee%>">
                <input type="hidden" name="<%= FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_EMPLOYEE_ID]%>" value="<%=oidEmployee%>">
                <input type="hidden" name="warning_id" value="<%=oidWarning%>">

                <div class="content-info">
                    <% if(oidEmployee != 0){
                        employee = new Employee();
                        try{
                                 employee = PstEmployee.fetchExc(oidEmployee);
                        }catch(Exception exc){
                                 employee = new Employee();
                        }
                    
                    %>
                        <table border="0" cellspacing="0" cellpadding="0" style="color: #575757">
                        <tr> 
                                <td valign="top" style="padding-right: 11px;"><strong>Payroll Number</strong></td>
                              <td valign="top"><%=employee.getEmployeeNum()%></td>
                        </tr>
                        <tr> 
                              <td valign="top" style="padding-right: 11px;"><strong>Name</strong></td>
                              <td valign="top"><%=employee.getFullName()%></td>
                        </tr>
                        <% department = new Department();
                            try{
                                         department = PstDepartment.fetchExc(employee.getDepartmentId());
                            }catch(Exception exc){
                                         department = new Department();
                            }
                         %>
                        <tr> 
                              <td valign="top" style="padding-right: 11px;"><strong><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT) %></strong></td>
                              <td valign="top"><%=department.getDepartment()%></td>
                        </tr>
                        <tr> 
                                <td valign="top" style="padding-right: 11px;"><strong>Address</strong></td>
                              <td valign="top"><%=employee.getAddress()%></td>
                        </tr>
                        </table>
                    <% } %>
                </div>
                <div class="content-title">
                    <div id="title-large"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></div>
                    <div id="title-small">Daftar <%=dictionaryD.getWord(I_Dictionary.WARNING) %> karyawan.</div>
                </div>
                <%
                    if (ctrlWarning.getMessage().length() > 0){
                        %>
                        <div class="alert-box notice-success">
                            <%=ctrlWarning.getMessage()%>
                        </div>
                        <%
                    }
                    %>
                <div class="content">
                    <div><%=drawList(listWarning, oidWarning, privUpdate,className)%></div>
                    <div><%
                        ctrLine.setLocationImg(approot+"/images");
                        ctrLine.initDefault();
                    %>
                    <%= ctrLine.drawImageListLimit(iCommand, vectSize, start, recordToGet) %>
                    </div>
                    <div>
                        <table cellpadding="0" cellspacing="0" border="0" width="25%">
                        <tr>
                          <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                          <td width="10"><a href="javascript:cmdBackToList()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','<%=approot%>/images/BtnBackOn.jpg',1)"><img name="Image101" border="0" src="<%=approot%>/images/BtnBack.jpg" width="24" height="24" alt="Back to List"></a></td>
                          <td width="6"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                          <td class="command" nowrap width="180">
                              <div align="left"><a href="javascript:cmdBackToList()">Back to
                              Warning List</a></div>
                          </td>
                          <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                          <td width="10"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','<%=approot%>/images/BtnSearchOn.jpg',1)"><img name="Image102" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search Schedule"></a></td>
                          <td width="6"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                          <td class="command" nowrap width="180">
                              <%
                              if (privAdd == true){
                                  %>
                                  <div align="left"><a href="javascript:cmdAdd()">Add New Warning</a></div>
                                  <%
                              }
                              %>
                          </td>
                        </tr>
                      </table>
                    </div>
                </div>
                  <%-- DISPLAY MESSAGE --%>
                  <%--
                     if(iCommand==Command.ADD) {
                        int warnLevel = SessEmpWarning.chekcActiveWarning(new Date(), oidEmployee);

                        if(warnLevel != -1) {
                            defaultWarnLevel = warnLevel + 1;
                 --%>
                                <%-- if(warnLevel < PstEmpWarning.levelNames.length - 1) {%>
                                  <p class="warningmsg">Note: This band member is still in effective warning period (<%=PstEmpWarning.levelNames[warnLevel]%>) !</p>
                                <% } else {%>
                                  <p class="warningmsg">Note: This band member has received "Warning Level 3", use reprimand instead !</p>
                                <% } --%>
                            
                      <%-- } %>
                  <% } --%>

                  <%-- FOR EDITING STATE --%>
                  <%if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand==Command.ASK ||
                      (iCommand==Command.SAVE && iErrCode!=FRMMessage.NONE)){ %>
                  <div class="content">
                  <table width="100%" border="0" cellspacing="2" cellpadding="2">
                  <tr>
                    <td colspan="2">
                        <b>WARNING RECORD EDITOR</b>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2" class="comment">*)
                      entry required</td>
                  </tr>
                  <tr>
                    <td width="100%" colspan="2">
                 <table>
                        <tr>
                            <td colspan="2">
                                <div id="txtHint"></div>
                            </td>
                        </tr>
                   <tr>
                        <td colspan="2">
                            <div class="caption">
                                <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
                            </div>
                            <div class="divinput">
                                <% Vector position_value = new Vector(1, 1);
                                Vector position_key = new Vector(1, 1);
                                Vector listPosition = PstPosition.list(0, 0, "", "POSITION");
                                position_value.add("0");
                                position_key.add("-select-");
                                for (int i = 0; i < listPosition.size(); i++) {
                                    position = (Position) listPosition.get(i);
                                    position_value.add("" + position.getOID());
                                    position_key.add(position.getPosition());
                                }
                            if(empWarning.getPositionId() != 0){
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_POSITION_ID], "formElemen", null, "" + empWarning.getPositionId(), position_value, position_key)%> <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_POSITION_ID)%>
                            <%  }
                                else{
                                position = new Position();
                                try{
                                    position = PstPosition.fetchExc(employee.getPositionId());
                                }catch(Exception exc){
                                    position = new Position();
                                }
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_POSITION_ID], "formElemen", null, "" + position.getOID(), position_value, position_key)%> <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_POSITION_ID)%>
                            <%
                                }
                            %>    
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="caption">
                                <%=dictionaryD.getWord(I_Dictionary.LEVEL)%>
                            </div>
                            <div class="divinput">
                                <%   Vector level_value = new Vector(1, 1);
                                Vector level_key = new Vector(1, 1);
                                Vector listLevel = PstLevel.list(0, 0, "", "LEVEL");
                                level_value.add("0");
                                level_key.add("-select-");
                                for (int i = 0; i < listLevel.size(); i++) {
                                    level = (Level) listLevel.get(i);
                                    level_value.add("" + level.getOID());
                                    level_key.add(level.getLevel());
                                }
                            if(empWarning.getLevelId() != 0){
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_LEVEL_ID], "formElemen", null, "" + empWarning.getLevelId(), level_value, level_key)%>  <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_LEVEL_ID)%>
                            <%  }
                                else{
                                level = new Level();
                                try{
                                    level = PstLevel.fetchExc(employee.getLevelId());
                                }catch(Exception exc){
                                    level = new Level();
                                }
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_LEVEL_ID], "formElemen", null, "" + level.getOID(), level_value, level_key)%>  <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_LEVEL_ID)%>
                            <%
                                }
                            %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="caption">
                                <%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%> <%=dictionaryD.getWord("CATEGORY")%>
                            </div>
                            <div class="divinput">
                                <%   Vector empCategory_value = new Vector(1, 1);
                                Vector empCategory_key = new Vector(1, 1);
                                Vector listEmpCategory = PstEmpCategory.list(0, 0, "", "EMP_CATEGORY");
                                empCategory_value.add("0");
                                empCategory_key.add("-select-");
                                for (int i = 0; i < listEmpCategory.size(); i++) {
                                    empCategory = (EmpCategory) listEmpCategory.get(i);
                                    empCategory_value.add("" + empCategory.getOID());
                                    empCategory_key.add(empCategory.getEmpCategory());
                                }
                            if(empWarning.getEmpCategoryId() != 0){
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_EMP_CATEGORY_ID], "formElemen", null, "" + empWarning.getEmpCategoryId(), empCategory_value, empCategory_key)%>  <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_EMP_CATEGORY_ID)%>
                            <%  }
                                else{
                                empCategory = new EmpCategory();
                                try{
                                    empCategory = PstEmpCategory.fetchExc(employee.getEmpCategoryId());
                                }catch(Exception exc){
                                    empCategory = new EmpCategory();
                                }
                            %>
                            <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_EMP_CATEGORY_ID], "formElemen", null, "" + empCategory.getOID(), empCategory_value, empCategory_key)%>  <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_EMP_CATEGORY_ID)%>
                            <%
                                }
                            %>
                            </div>
                        </td>
                    </tr>
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                        Break Date
                    </div>
                    <div class="divinput">
                        <%=ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_BREAK_DATE], warning.getBreakDate(), 2, -30, "formElemen", "")%>
                    </div>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                        Break Fact
                    </div>
                    <div class ="divinput">
                        <textarea cols="22" rows="5" name="<%= FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_BREAK_FACT] %>"><%= warning.getBreakFact() %></textarea> * <%=frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_BREAK_FACT)%>
                    </div>
                    </td>                  
                  </tr>
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                      Warning Date
                    </div>
                    <div class = "divinput">
                        <%=ControlDate.drawDateWithStyle(FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_WARN_DATE], warning.getWarningDate(), 2, -30, "formElemen", "onchange=javascript:changeValidUntil("+iCommand+")")%>
                    </div>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                      Warning Level ( Point )
                    </div>
                    <div class ="divinput">
                         <%    Vector warning_value = new Vector(1,1);
                                  Vector warning_key = new Vector(1,1);
                                  Vector listWarn = PstWarning.listAll();
                                  for(int i=0;i<listWarn.size();i++){
                                      Warning warn = (Warning) listWarn.get(i);
                                      warning_value.add(""+warn.getOID());
                                      warning_key.add(""+warn.getWarnDesc()+ "   ("+""+warn.getWarnPoint()+")");
                                  }
                              %>
                                  <% if((listWarn != null) && (listWarn.size() > 0)){%>
                                  <%= ControlCombo.draw(frmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_WARN_LEVEL_ID],"formElemen",null, ""+empWarning.getWarnLevelId(), warning_value, warning_key, "onchange=javascript:changeValidUntil("+iCommand+")") %>
                                  <% }else {%>
                                  <font class="comment">No
                                  Warning available</font>
                                  <% }%>
                                  * <%= frmEmpWarning.getErrorMsg(FrmEmpWarning.FRM_FIELD_WARN_LEVEL_ID) %>
                    </div>
                    </td>
                  </tr>
                  <% Warning wrn = new Warning();
                                         try{
                                                      wrn = PstWarning.fetchExc(empWarning.getWarnLevelId());
                                         }catch(Exception exc){
                                                      wrn = new Warning();
                                         }
                                      %>

                  <!-- } -->
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                        Warning By
                    </div>
                    <div class ="divinput">
                      <table width="30%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                          <td>
                              <input type="text" readonly size="33" name="<%=FrmEmpWarning.fieldNames[FrmEmpWarning.FRM_FIELD_WARN_BY]%>" value="<%=warning.getWarningBy()%>" class="formElemen" maxlength="50">
                          </td>
                          <td>
                          <td>
                              <a href="javascript:cmdListEmployee()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10x','','<%=approot%>/images/icon/folderopen.gif',1)"><img name="Image10x" border="0" src="<%=approot%>/images/icon/folder.gif" width="24" height="24" alt="Search Employee"></a>
                          </td>
                          <td>
                              <a href="javascript:cmdListEmployee()">Search Employee</a>
                          </td>
                      </table>
                    </div>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                        <div class ="caption">
                            Valid Until
                        </div>
                        
                        <div class ="divinput" id="txtValidUntil"></div>
                    </td>
                  </tr>
                  <%
                    if(iCommand == Command.EDIT){
                  %>
                  <tr>
                    <td colspan="2">
                    <div class ="caption">
                            Upload Data
                    </div>
                    <div class ="divinput">
                        <a href="javascript:cmdDetailUp('<%=warning.getOID()%>','<%=className%>')">Detail</a>
                    </div></td>
                  </tr>
                  <%}%>
                  <tr>
                    <td width="1%"  valign="top" align="left"  >&nbsp;</td>
                    <td width="11%"  valign="top" align="left"  >&nbsp;</td>
                    <td  width="88%"  valign="top" align="left">&nbsp;</td>
                  </tr>
                  <tr align="left">
                    <td colspan="4">
                      <%
                          ctrLine.setLocationImg(approot+"/images");
                          ctrLine.initDefault();
                          ctrLine.setTableWidth("90");
                          ctrLine.setCommandStyle("buttonlink");

                          String scomDel = "javascript:cmdDelete('"+oidWarning+"')";
                          String scomAsk = "javascript:cmdAsk('"+oidWarning+"')";
                          String scomEdit = "javascript:cmdEdit('"+oidWarning+"')";

                          ctrLine.setBackCaption("Back To List");
                          ctrLine.setDeleteCaption("Delete Warning Record");
                          ctrLine.setSaveCaption("Save Warning Record");
                          ctrLine.setConfirmDelCaption("Yes, Delete Warning Record");
                          ctrLine.setAddCaption("Add New Data");

                          if(privDelete) {
                              ctrLine.setConfirmDelCommand(scomDel);
                              ctrLine.setDeleteCommand(scomAsk);
                              ctrLine.setEditCommand(scomEdit);
                          }
                          else{
                              ctrLine.setConfirmDelCaption("");
                              ctrLine.setDeleteCaption("");
                              ctrLine.setEditCaption("");
                          }

                          if(!privAdd){
                              ctrLine.setAddCaption("");
                          }

                          if(!privAdd  && !privUpdate){
                              ctrLine.setSaveCaption("");
                          }

                      %>
                      <%= ctrLine.drawImage(iCommand, iErrCode,  msgString)%>

                  </td>
                </tr>
                    <% if((iCommand != Command.ASK) && (iCommand == Command.EDIT) && privPrint) { %>
                    <tr>
                       <td>
                           <a href="javascript:cmdPrint()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch">
                           <img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Warning Report"></a>
                       </td>

                       <td>
                          <a href="javascript:cmdPrint()">Print Report</a>
                       </td>
                    </tr>
                    <% } %>
                <% } %>
                  </table>
                    </td>
                  </tr>
                  </table>
                  </div>
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
