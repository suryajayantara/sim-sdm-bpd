<%@page import="com.dimata.harisma.entity.masterdata.PstWarning"%>
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

<%@ include file = "../../main/javainit.jsp" %>

<%-- YANG INI BELUM DIEDIT --%>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_REPRIMAND); %>
<%@ include file = "../../main/checkuser.jsp" %>

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
int appObjCodeWar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_WARNING);
boolean privViewWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_REPRIMAND = 9; */
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

    public String drawList(Vector objectClass ,  long empReprimandId, boolean privUpdate,String className)

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
		ctrlist.addHeader("DATE","");
		ctrlist.addHeader("CHAPTER","");
		ctrlist.addHeader("ARTICLE","");
		ctrlist.addHeader("PAGE","");
                ctrlist.addHeader("DESCRIPTION","");
                ctrlist.addHeader("VALID UNTIL","");
                ctrlist.addHeader("LEVEL","");
                /*Ari_20110909
                 *Menambah Point pada Reprimand { */
                ctrlist.addHeader("POINT","");
				ctrlist.addHeader("DETAIL","");

		Vector lstData = ctrlist.getData();
		ctrlist.reset();
		int index = -1;
                int recordNo = 1;

		for (int i = 0; i < objectClass.size(); i++) {
			EmpReprimand empReprimand = (EmpReprimand)objectClass.get(i);
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
                            comp = PstCompany.fetchExc(empReprimand.getCompanyId());   
                            compString = comp.getCompany();
                        }
                        catch(Exception e) {
                            comp = new Company();                    
                        }                        

                        try {
                            div = PstDivision.fetchExc(empReprimand.getDivisionId());   
                            divString = div.getDivision();
                        }
                        catch(Exception e) {
                            div = new Division();                    
                        }                        

                        try {
                            dep = PstDepartment.fetchExc(empReprimand.getDepartmentId());   
                            depString = dep.getDepartment();
                        }
                        catch(Exception e) {
                            dep = new Department();                    
                        }                        

                        try {
                            sec = PstSection.fetchExc(empReprimand.getSectionId());   
                            secString = sec.getSection();
                        }
                        catch(Exception e) {
                            sec = new Section();                    
                        }                        

                        try {
                            pos = PstPosition.fetchExc(empReprimand.getPositionId());   
                            posString = pos.getPosition();
                        }
                        catch(Exception e) {
                            pos = new Position();                    
                        }                        

                        try {
                            level = PstLevel.fetchExc(empReprimand.getLevelId());   
                            levelString = level.getLevel();
                        }
                        catch(Exception e) {
                            level = new Level();                    
                        }                        

                        try {
                            cat = PstEmpCategory.fetchExc(empReprimand.getEmpCategoryId());   
                            catString = cat.getEmpCategory();
                        }
                        catch(Exception e) {
                            cat = new EmpCategory();                    
                        }  
			 Vector rowx = new Vector();
			 if(empReprimandId == empReprimand.getOID())
				 index = i;

			Reprimand reprimand = new Reprimand();
			if(empReprimand.getReprimandLevelId() != -1){
				try{
					reprimand = PstReprimand.fetchExc(empReprimand.getReprimandLevelId());
				}catch(Exception exc){
					reprimand = new Reprimand();
				}
			}

			rowx.add(String.valueOf(recordNo++));
                        if (privUpdate == true){
                            rowx.add("<a href=\"javascript:cmdEdit('"+empReprimand.getOID()+"')\">"+compString+"</a>");
                        } else {
                            rowx.add(compString);
                        }
                        
                        rowx.add(divString);
                        rowx.add(depString);
                        rowx.add(secString);
                        rowx.add(posString);
                        rowx.add(levelString);
                        rowx.add(catString);
                        String dataDate = "";
                        dataDate = ""+Formater.formatDate(empReprimand.getReprimandDate(), "d-MMM-yyyy");
                        
                        rowx.add(dataDate);
                        String chapter = "";
                        try {
                            WarningReprimandBab bab = PstWarningReprimandBab.fetchExc(Long.valueOf(empReprimand.getChapter()));
                            chapter = bab.getBabTitle();
                        } catch(Exception e){
                            System.out.println("chapter"+e.toString());
                        }
                        String article = "";
                        try {
                            WarningReprimandPasal pasal = PstWarningReprimandPasal.fetchExc(Long.valueOf(empReprimand.getArticle()));
                            article = pasal.getPasalTitle();
                        } catch(Exception e){
                            System.out.println("article"+e.toString());
                        }
                        rowx.add(chapter);
                        rowx.add(article);
                        rowx.add(empReprimand.getPage());
                        rowx.add((empReprimand.getDescription().length() > 100) ? empReprimand.getDescription().substring(0, 100) + " ..." : empReprimand.getDescription());
                        rowx.add(Formater.formatDate(empReprimand.getValidityDate(), "d-MMM-yyyy"));
                        rowx.add(String.valueOf(reprimand.getReprimandDesc()));
                        rowx.add(String.valueOf(reprimand.getReprimandPoint()));
						rowx.add("<a href=\"javascript:cmdDetailUp('"+empReprimand.getOID()+"','"+className+"')\">Detail</a>");
                        lstData.add(rowx);

		}

		return ctrlist.draw(index);
	}

%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request,"prev_command");
    int number = FRMQueryString.requestInt(request, "number");
    long oidEmployee = FRMQueryString.requestLong(request,"employee_oid");
    long oid = FRMQueryString.requestLong(request, "reprimand_id");
    int start = FRMQueryString.requestInt(request, "start");
    // mchen
    long oidBab = FRMQueryString.requestLong(request, FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_CHAPTER]);
    long oidPasal = FRMQueryString.requestLong(request, FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_ARTICLE]);
    long oidAyat = FRMQueryString.requestLong(request, FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VERSE]);
    
    // data upload dedy 20160318
    String className = "";
    /*String[] listTitles =
    {
        "NO",
        "DATE",
        "CHAPTER",
        "ARTICLE",
        "PAGE",
        "DESCRIPTION",
        "VALID UNTIL",
        "LEVEL"
    };*/

    int recordToGet = 10;
    //int iErrCode = FRMMessage.ERR_NONE;
    //String errMsg = "";
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = PstEmpReprimand.fieldNames[PstEmpReprimand.FLD_EMPLOYEE_ID] + "=" + oidEmployee;
    String orderClause = PstEmpReprimand.fieldNames[PstEmpReprimand.FLD_REP_DATE];
    
    Employee employee = new Employee();
    Department department = new Department();
    Section section = new Section();

    int defaultReprimandLevelId = 0;

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

    CtrlEmpReprimand ctrlReprimand = new CtrlEmpReprimand(request);
    ControlLine ctrLine = new ControlLine();
    Vector listReprimand = new Vector();

    /* EXECUTE ACTION COMMAND */
    iErrCode = ctrlReprimand.action(iCommand, oid, request, emplx.getFullName(), appUserIdSess);
     msgString =  ctrlReprimand.getMessage();
    //errMsg = ctrlReprimand.getMessage();

    EmpReprimand empReprimand = ctrlReprimand.getEmpReprimand();
    FrmEmpReprimand frmEmpReprimand = ctrlReprimand.getForm();
    EmpReprimand reprimand = ctrlReprimand.getEmpReprimand();
    
    // data upload dedy 20160318
    className = reprimand.getClass().getName();

    int vectSize = PstEmpReprimand.getCount(whereClause);

    if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)&& (oid == 0))
            start = PstEmpReprimand.findLimitStart(empReprimand.getOID(),recordToGet, whereClause, orderClause);

    /* CASE NAVIGATION COMMAND */
    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
       (iCommand == Command.NEXT || iCommand == Command.LAST)){

        start = ctrlReprimand.actionList(iCommand, start, vectSize, recordToGet);
    }


    /* GET WARNING DATA TO DISPLAY */
    listReprimand = PstEmpReprimand.list(start, recordToGet, whereClause, orderClause);


    // design vector that handle data to store in session
    Vector reprimandReport = new Vector();

    reprimandReport.add(reprimand);
    reprimandReport.add(employee);
    reprimandReport.add(new Integer(number));

    session.putValue("REPRIMAND_LETTER", reprimandReport);

%>

<!-- End of Jsp Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>HARISMA - Reprimand</title>
<script language="JavaScript">

    function cmdBackToList(){
        document.fredit.start.value="0";
        document.fredit.command.value="<%=Command.BACK%>";
        document.fredit.action="../warning/reprimand_list.jsp";
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
	document.fredit.action="reprimand.jsp";
	document.fredit.submit();
    }

    function cmdAdd(){
        document.fredit.reprimand_id.value="0";
        document.fredit.command.value="<%=Command.ADD%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

     function cmdEdit(oid){
        document.fredit.reprimand_id.value=oid;
        document.fredit.command.value="<%=Command.EDIT%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdSave(){
        document.fredit.reprimand_id.value="<%= oid %>";
	document.fredit.command.value="<%=Command.SAVE%>";
	document.fredit.prev_command.value="<%=iCommand%>";    /* edit atau add */
	document.fredit.action="reprimand.jsp";
	document.fredit.submit();
    }

    function cmdCancel(){
        document.fredit.command.value="<%=Command.CANCEL%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdAsk(oid){
        document.fredit.command.value="<%=Command.ASK%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdDelete(oid){
        document.fredit.command.value="<%=Command.DELETE%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdPrint(){
	var rptSource = "<%=printroot%>.report.employee.EmployeeReprimandPdf";
	window.open(rptSource);
    }


    function cmdListFirst(){
        document.fredit.command.value="<%=Command.FIRST%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdListPrev(){
        document.fredit.command.value="<%=Command.PREV%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdListNext(){
        document.fredit.command.value="<%=Command.NEXT%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdListLast(){
        document.fredit.command.value="<%=Command.LAST%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }

    function cmdListEmployee(){
        document.fredit.command.value="<%=iCommand%>";
        win = window.open("<%=approot%>/employee/reprimand/src_emp.jsp?formName=fredit&empPathId=<%= FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }
    
    // mchen
    function cmdUpdatePasal(){
        document.fredit.command.value="<%=Command.ADD%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }
    
    function cmdUpdateAyat(){
        document.fredit.command.value="<%=Command.ADD%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }
    
    function cmdUpdatePage(){
        document.fredit.command.value="<%=Command.ADD%>";
        document.fredit.action="reprimand.jsp";
        document.fredit.submit();
    }
    
    // data upload dedy 20160318
    function cmdDetailUp(oidEmpReprimant, className){
        window.open("<%=approot%>/system/dataupload/data_upload.jsp?object_id="+oidEmpReprimant+"&classname="+className, null, "height=800,width=800,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
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
<script type="text/javascript">
        
    function loadCompany(oid) {
        if (oid.length == 0) { 
            document.getElementById("company").innerHTML = "";
            loadValidUntil();
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("company").innerHTML = xmlhttp.responseText;
                    loadValidUntil();
                }
            };
            xmlhttp.open("GET", "reprimand_ajax.jsp?reprimand_id=" + oid, true);
            xmlhttp.send();
        }
    }
    
    function loadDivision(str) {
        if (str.length == 0) { 
            document.getElementById("company").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("company").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax.jsp?company_id=" + str, true);
            xmlhttp.send();
        }
    }
    
    function loadDepartment(comp_id, divisi_id) {
        if ((comp_id.length == 0)&&(divisi_id.length == 0)) { 
            document.getElementById("company").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("company").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax.jsp?company_id="+comp_id+"&division_id=" + divisi_id, true);
            xmlhttp.send();
        }
    }
    
    function loadSection(comp_id, divisi_id, depart_id) {
        if ((comp_id.length == 0)&&(divisi_id.length == 0)&&(depart_id.length == 0)) { 
            document.getElementById("company").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("company").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax.jsp?company_id="+comp_id+"&division_id=" + divisi_id +"&department_id="+depart_id, true);
            xmlhttp.send();
        }
    }    
     
    function loadRepLevel(oid) {
        if (oid.length == 0) { 
            document.getElementById("company").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("company").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax.jsp?reprimand_id=" + oid, true);
            xmlhttp.send();
        }

    }
    
    function loadBab(oid) {
        if (oid.length == 0) { 
            document.getElementById("responHTML").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("responHTML").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_bab_ajax.jsp?reprimand_id=" + oid, true);
            xmlhttp.send();
        }
    }
    function loadPasal(str,comp_id, divisi_id, depart_id, section_id) {
        if (str.length == 0) { 
            document.getElementById("responHTML").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("responHTML").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_bab_ajax.jsp?bab_id=" + str, true);
            xmlhttp.send();
        }
    }
    function loadAyat(bab_id, pasal_id) {
        if ((bab_id.length == 0)&&(pasal_id.length == 0)) { 
            document.getElementById("responHTML").innerHTML = "";
            return;
        } else {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("responHTML").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_bab_ajax.jsp?bab_id=" + bab_id + "&pasal_id=" + pasal_id, true);
            xmlhttp.send();
        }
    }
    function cmdAttach(reprimandId, empDocId){
        window.open("upload_pict_pages.jsp?command="+<%=Command.EDIT%>+"&relevant_doc_pages_oid=" + empDocPagesId + "&emp_relevant_doc_id=" + empDocId , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
    }
    
    function Prepare(){
        loadCompany('<%=oid%>');
        loadBab('<%=oid%>');
                          
        
       
        
      
    }
    
  
     function loadValidUntil() {
        var iCommand =  <%=iCommand%>;
        var year =   document.fredit.FRM_REP_DATE_yr.value;
        var month =   document.fredit.FRM_REP_DATE_mn.value;
        if(month.length == 1){
            month = "0"+month;
        }
        var date =   document.fredit.FRM_REP_DATE_dy.value;
        if(date.length == 1){
            date = "0"+date;
        }
        
        var oidReprimandLevel = document.fredit.FRM_REPRIMAND_LEVEL_ID.value;
       
        var oidReprimand = document.fredit.reprimand_id.value;
        var reprimandDate = year+"-"+month+"-"+date;
        
       
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtValidUntil").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax_valid_until.jsp?oidReprimandLevel=\""+oidReprimandLevel+"\"&reprimandDate=" + reprimandDate+"&iCommand="+iCommand+"&oidReprimand="+oidReprimand+"&type=load" , true);
            xmlhttp.send();
    }
    
       function changeValidUntil() {
        var iCommand =  <%=iCommand%>;
        var year =   document.fredit.FRM_REP_DATE_yr.value;
        var month =   document.fredit.FRM_REP_DATE_mn.value;
        if(month.length == 1){
            month = "0"+month;
        }
        var date =   document.fredit.FRM_REP_DATE_dy.value;
        if(date.length == 1){
            date = "0"+date;
        }
        
        var oidReprimandLevel = document.fredit.FRM_REPRIMAND_LEVEL_ID.value;
       
        var oidReprimand = document.fredit.reprimand_id.value;
        var reprimandDate = year+"-"+month+"-"+date;
        
       
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("txtValidUntil").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "reprimand_ajax_valid_until.jsp?oidReprimandLevel=\""+oidReprimandLevel+"\"&reprimandDate=" + reprimandDate+"&iCommand="+iCommand+"&oidReprimand="+oidReprimand+"&type=change" , true);
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
            
            .caption {
                font-size: 11px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
            }
            
        </style>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "styles" -->
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
</head>
<body onload="Prepare()">
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
            <span id="menu_title"><%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%> <strong style="color:#333;"> / </strong> <%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></span>
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
                <% if (privViewWar == true){ 
                        if (privUpdateWar){
                %>
                            <li class=""> <a href="warning.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                <%      } else { %>            
                            <li class=""> <a href="warning_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                <%      }
                    } 
                %>
                <li class="active"> <%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></li>
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
                <input type="hidden" name="command" value=<%=iCommand%>"">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="number" value="<%=number%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="employee_oid" value="<%=oidEmployee%>">
                <input type="hidden" name="<%= FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_EMPLOYEE_ID]%>" value="<%=oidEmployee%>">
                <input type="hidden" name="reprimand_id" value="<%=oid%>">
                
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
                    <div id="title-large"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></div>
                    <div id="title-small">Daftar <%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %> karyawan.</div>
                </div>
                <div class="content">
                    <%
                    if (ctrlReprimand.getMessage().length() > 0){
                        %>
                        <div class="alert-box notice-success">
                            <%=ctrlReprimand.getMessage()%>
                        </div>
                        <%
                    }
                    %>
                    <table width="100%" cellspacing="2" cellpadding="1" >
                                        <tr>

                                          
                                          <td colspan="3"  valign="top" align="left"  >
                                            <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                              <tr>
                                                <td colspan="5" nowrap>&nbsp;</td>
                                              </tr>
                                              <tr>
                                                <td colspan="5" nowrap>
                                                  <div align="center"><font size="3"><b>RIWAYAT
                                                    PEMBINAAN</b></font></div>
                                                </td>
                                              </tr>
                                              <tr>
                                                <td width="1%" nowrap>&nbsp;</td>
                                                <td width="18%" nowrap>&nbsp;</td>
                                                <td width="4%" nowrap>&nbsp;</td>
                                                <td width="46%" nowrap>&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                              </tr>
                                              <% if(oidEmployee != 0){
                                                                employee = new Employee();
                                                                try{
                                                                         employee = PstEmployee.fetchExc(oidEmployee);
                                                                }catch(Exception exc){
                                                                         employee = new Employee();
                                                                }
                                                    }
                                                  %>
                                              <tr>

                                                <%-- EMPLOYEE MAIN DATA --%>
                                                <td width="1%" nowrap>&nbsp;</td>
                                                <td width="18%" nowrap>
                                                  <div align="left">Employee
                                                              Number</div>
                                                </td>
                                                <td width="4%">:</td>
                                                <td width="46%" nowrap> <%= employee.getEmployeeNum() %> </td>
                                              </tr>
                                              <tr>
                                                <td width="1%" nowrap>&nbsp;</td>
                                                <td width="18%" nowrap>
                                                  <div align="left">Employee Name</div>
                                                </td>
                                                <td width="4%">:</td>
                                                <td width="46%" nowrap> <%= employee.getFullName() %> </td>
                                              </tr>
                                              <% department = new Department();
                                                               try{
                                                                            department = PstDepartment.fetchExc(employee.getDepartmentId());
                                                               }catch(Exception exc){
                                                                            department = new Department();
                                                               }
                                                            %>
                                              <tr>
                                                <td width="1%" nowrap>&nbsp;</td>
                                                <td width="18%" nowrap>
                                                  <div align="left"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT) %></div>
                                                </td>
                                                <td width="4%">:</td>
                                                <td width="46%" nowrap>  <%=department.getDepartment()%> </td>
                                                <td width="13%" nowrap>
                                                  <div align="left"></div>
                                                </td>
                                                <td width="18%">&nbsp; </td>
                                              </tr>
                                               <% section = new Section();
                                                               try{
                                                                            section = PstSection.fetchExc(employee.getSectionId());
                                                               }catch(Exception exc){
                                                                            section = new Section();
                                                               }
                                                            %>
                                              <tr>
                                                 <td width="1%" nowrap>&nbsp;</td>
                                                 <td width="18%"><%=dictionaryD.getWord(I_Dictionary.SECTION) %></td>
                                                 <td width="4%">:</td>
                                                 <td width="46%"><%=section.getSection()!=null && section.getSection().length()>0?section.getSection():"-"%></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr>
                                          <td colspan="3"  valign="top" align="left"  >
                                            <hr>
                                          </td>
                                        </tr>
                                        <tr>
                                          <td colspan="3" align="left" nowrap valign="top"  >

                                            <%-- EMPLOYEE REPRIMAND TABLE DATA --%>
                                            <%=drawList(listReprimand, oid, privUpdate, className)%>
                                          </td>
                                        </tr>
                                        <tr>

                                          <%-- DRAW RECORDS INFORMATION --%>
                                          
                                          <td colspan="3" align="left" nowrap valign="top"  >
                                          <%
                                              ctrLine.setLocationImg(approot+"/images");
                                              ctrLine.initDefault();
                                          %>
                                          <%= ctrLine.drawImageListLimit(iCommand, vectSize, start, recordToGet) %>
                                          </td>
                                        </tr>
                                        <tr>

                                          <%-- DRAW BUTTON --%>
                                          
                                          <td colspan="3" align="left" nowrap valign="top"  >
                                            <table cellpadding="0" cellspacing="0" border="0" width="25%">
                                              <tr>
                                                <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td width="10"><a href="javascript:cmdBackToList()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','<%=approot%>/images/BtnBackOn.jpg',1)"><img name="Image101" border="0" src="<%=approot%>/images/BtnBack.jpg" width="24" height="24" alt="Back to List"></a></td>
                                                <td width="6"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td class="command" nowrap width="180">
                                                    <div align="left"><a href="javascript:cmdBackToList()">Back to
                                                    Reprimand List</a></div>
                                                </td>
                                                <td width="4"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td width="10"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','<%=approot%>/images/BtnSearchOn.jpg',1)"><img name="Image102" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search Schedule"></a></td>
                                                <td width="6"><img src="<%=approot%>/images/spacer.gif" width="4" height="4"></td>
                                                <td class="command" nowrap width="180">
                                                    <div align="left"><a href="javascript:cmdAdd()">Add New Reprimand</a></div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr>
                                          <td width="1%"  valign="top" align="left"  >&nbsp;</td>
                                          <td width="15%" align="left" nowrap valign="top"  >&nbsp;</td>
                                          <td  width="83%"  valign="top" align="left" class="comment">&nbsp;</td>
                                        </tr>
                                        <%-- DISPLAY MESSAGE --%>
                                        <%--if(iCommand==Command.ADD) {
                                              int rpmLevelId = SessEmpWarning.chekcActiveReprimand(new Date(), oidEmployee);

                                              if(rpmLevelId != 0) {
                                                  defaultReprimandLevelId = rpmLevelId;

                                        --%>
                                        <tr>
                                              <td width="1%"  valign="top" align="left">&nbsp;</td>
                                              <td width="15%" align="left" nowrap valign="top" colspan="2">
                                                  <span class="warningmsg">
                                                      <%-- if(rpmLevelId < empReprimand.getReprimandLevelId()) {%>
                                                        <p class="warningmsg">Note: This band member is still in effective reprimand period (<%=PstEmpReprimand.levelNames[rpmLevel]%>) !</p>
                                                      <% } else {%>
                                                        <p class="warningmsg">Note: This band member has been SUSPENDED !</p>
                                                      <% } --%>
                                                      
                                                  </span>
                                              </td>
                                            </tr>
                                            <tr>
                                              <td width="1%"  valign="top" align="left"  >&nbsp;</td>
                                              <td width="15%" align="left" nowrap valign="top"  >&nbsp;</td>
                                              <td  width="83%"  valign="top" align="left" class="comment">&nbsp;</td>
                                            </tr>
                                            <%-- } %>
                                        <% } --%>

                                        <%-- FOR EDITING STATE --%>
                                        <%if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand==Command.ASK || (iCommand==Command.SAVE && iErrCode!=FRMMessage.NONE)){ %>

                                        <tr>
                                          <td colspan="3"><strong>REPRIMAND RECORD EDITOR</strong></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3"  style="color: #FF6666">*entry required</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Date/Tanggal
                                                </div>
                                                <div class="divinput">
                                                    <%=ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_REP_DATE], reprimand.getReprimandDate(), 2, -30, "formElemen", "onchange=javascript:changeValidUntil()")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <%--
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Reprimand Level (Point)
                                                </div>
                                                <div class="divinput">
                                                    <%    Vector reprimand_value = new Vector(1,1);
                                                        Vector reprimand_key = new Vector(1,1);
                                                        Vector listRep = PstReprimand.listAll();
                                                        for(int i=0;i<listRep.size();i++){
                                                            Reprimand rep = (Reprimand) listRep.get(i);
                                                            reprimand_value.add(""+rep.getOID());
                                                            reprimand_key.add(""+rep.getReprimandDesc() + "   ("+""+rep.getReprimandPoint()+")");
                                                            

                                                        }
                                                    %>
                                                        <% if((listRep != null) && (listRep.size() > 0)){%>
                                                        <%= ControlCombo.draw(frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_REPRIMAND_LEVEL_ID],"formElemen",null, ""+empReprimand.getReprimandLevelId(), reprimand_value, reprimand_key)%>
                                                        <%--= ControlCombo.draw(frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_REPRIMAND_LEVEL_ID],"formElemen",null, ""+empReprimand.getReprimandLevelId(), reprimand_value, reprimand_key2)--%>
                                                     <%--   
                                                       <% }else {%>
                                                        <font class="comment">No
                                                        Reprimand available</font>
                                                        <% }%>
                                                        * <%= frmEmpReprimand.getErrorMsg(FrmEmpReprimand.FRM_FIELD_REPRIMAND_LEVEL_ID) %>
                                                </div>
                                            </td>
                                        </tr>
                                        --%>
                                        <tr>
                                            <td colspan="3"><div id="company"></div></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3"><div id="responHTML"></div></td>
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
                                                        Position position = (Position) listPosition.get(i);
                                                        position_value.add("" + position.getOID());
                                                        position_key.add(position.getPosition());
                                                    }
                                                if(empReprimand.getPositionId() != 0){
                                                %>
                                                <%= ControlCombo.draw(frmEmpReprimand.fieldNames[frmEmpReprimand.FRM_FIELD_POSITION_ID], "formElemen", null, "" + empReprimand.getPositionId(), position_value, position_key)%> <%= frmEmpReprimand.getErrorMsg(FrmEmpReprimand.FRM_FIELD_POSITION_ID)%>
                                                <%  }
                                                    else{
                                                    Position position = new Position();
                                                    try{
                                                        position = PstPosition.fetchExc(employee.getPositionId());
                                                    }catch(Exception exc){
                                                        position = new Position();
                                                    }
                                                %>
                                                <%= ControlCombo.draw(frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_POSITION_ID], "formElemen", null, "" + position.getOID(), position_value, position_key)%> <%= frmEmpReprimand.getErrorMsg(FrmEmpReprimand.FRM_FIELD_POSITION_ID)%>
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
                                                        Level level = (Level) listLevel.get(i);
                                                        level_value.add("" + level.getOID());
                                                        level_key.add(level.getLevel());
                                                    }
                                                if(empReprimand.getLevelId() != 0){
                                                %>
                                                <%= ControlCombo.draw(frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_LEVEL_ID], "formElemen", null, "" + empReprimand.getLevelId(), level_value, level_key)%>  <%= frmEmpReprimand.getErrorMsg(FrmEmpReprimand.FRM_FIELD_LEVEL_ID)%>
                                                <%  }
                                                    else{
                                                    Level level = new Level();
                                                    try{
                                                        level = PstLevel.fetchExc(employee.getLevelId());
                                                    }catch(Exception exc){
                                                        level = new Level();
                                                    }
                                                %>
                                                <%= ControlCombo.draw(frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_LEVEL_ID], "formElemen", null, "" + level.getOID(), level_value, level_key)%>  <%= frmEmpReprimand.getErrorMsg(FrmEmpReprimand.FRM_FIELD_LEVEL_ID)%>
                                                <%
                                                    }
                                                %>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Page/Halaman
                                                </div>
                                                <div class="divinput">
                                                    <input type="text" name="<%= frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_PAGE] %>" value="<%= reprimand.getPage() %>" class="formElemen" maxlength="10">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Description/Uraian
                                                </div>
                                                <div class="divinput">
                                                    <textarea cols="22" rows="5" name="<%= frmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_DESCRIPTION] %>"><%= reprimand.getDescription() %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Valid Until
                                                </div>
                                                <div class="divinput" id="txtValidUntil">
                                                    <%
//                                                        if(iCommand == Command.ADD) {
//                                                            Calendar cal = new GregorianCalendar();
//                                                            cal.add(Calendar.MONTH, 6);
//
//                                                            Date date = new Date(cal.get(Calendar.YEAR) - 1900, cal.get(Calendar.MONTH), cal.get(Calendar.DATE));
//                                                            out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], date, 2, -30, "formElemen", ""));
//                                                        }
//                                                        else {
//                                                            out.println(ControlDate.drawDateWithStyle(FrmEmpReprimand.fieldNames[FrmEmpReprimand.FRM_FIELD_VALID_UNTIL], reprimand.getReprimandDate(), 2, -30, "formElemen", ""));
//                                                        }
                                                    %>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                            if(iCommand == Command.EDIT){
                                          %>
                                        <tr>
                                            <td colspan="3">
                                                <div class="caption">
                                                    Upload Data
                                                </div>
                                                <div class="divinput">
                                                    <a href="javascript:cmdDetailUp('<%=reprimand.getOID()%>','<%=className%>')">Detail</a>
                                                </div>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                          <td width="1%"  valign="top" align="left"  >&nbsp;</td>
                                          <td width="15%"  valign="top" align="left"  >&nbsp;</td>
                                          <td  width="83%"  valign="top" align="left">&nbsp;</td>
                                        </tr>
                                        <tr align="left">
                                          <td colspan="4">
                                            <%
                                                ctrLine.setLocationImg(approot+"/images");
                                                ctrLine.initDefault();
                                                ctrLine.setTableWidth("90");
                                                ctrLine.setCommandStyle("buttonlink");

                                                String scomDel = "javascript:cmdDelete('"+oid+"')";
                                                String scomAsk = "javascript:cmdAsk('"+oid+"')";
                                                String scomEdit = "javascript:cmdEdit('"+oid+"')";

                                                ctrLine.setBackCaption("Back To List");
                                                ctrLine.setDeleteCaption("Delete Reprimand Record");
                                                ctrLine.setSaveCaption("Save Reprimand Record");
                                                ctrLine.setConfirmDelCaption("Yes, Delete Reprimand Record");
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
                                            <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%>

                                        </td>
                                      </tr>
                                          <% if((iCommand != Command.ASK)  && (iCommand == Command.EDIT) && privPrint) { %>
                                          <tr>
                                             <td>
                                                 <a href="javascript:cmdPrint()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch">
                                                 <img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Reprimand Report"></a>
                                             </td>

                                             <td>
                                                <a href="javascript:cmdPrint()">Print Report</a>
                                             </td>
                                          </tr>
                                          <% } %>
                                      <% } %>
                                      <%-- END EDITING STATE --%>


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
