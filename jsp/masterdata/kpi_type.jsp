<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKPI_Type"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKPI_Type"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Type"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.sun.org.apache.xalan.internal.xsltc.runtime.Hashtable"%>
<%@page import="com.dimata.harisma.entity.masterdata.KPITypeCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKPITypeCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTypeDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.KpiTypeDivision"%>
<%
    /* s
 * Page Name  		:  kpi_type.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: priska
 * @version  		: 01 
     */

    /**
     * *****************************************************************
     * Page Description : [project description ... ] Imput Parameters : [input
     * parameter ...] Output : [output ...]
     * *****************************************************************
     */
%>

<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    
    
    
    int iCommand = FRMQueryString.requestCommand(request);
    long OidKpiType = FRMQueryString.requestLong(request, FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]);

    Vector listKpiType = new Vector();
    boolean selectDiv = true;

    CtrlKPI_Type ctrlKPI_Type = new CtrlKPI_Type(request);
    boolean IsReindex = FRMQueryString.requestBoolean(request, "isReindex");
    
    String oid_division[] = FRMQueryString.requestStringValues(request, "division");
    String oid_company[] = FRMQueryString.requestStringValues(request, "company");
    String typeName = FRMQueryString.requestString(request, FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_TYPE_NAME]);
    String typeDesc = FRMQueryString.requestString(request, FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_DESCRIPTION]);
    int Indexing = FRMQueryString.requestInt(request, FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_INDEXING]);
    long iErrCode = ctrlKPI_Type.action(iCommand, OidKpiType, request);

    KPI_Type objKpiTypeCtrl = ctrlKPI_Type.getdKPI_Type();
    if (iCommand == Command.EDIT) {
        typeName = objKpiTypeCtrl.getType_name();
        typeDesc = objKpiTypeCtrl.getDescription();
        Indexing = objKpiTypeCtrl.getIndexing();
        int countTotalMappedDivision = 0;
        Vector listMappedCompanyDb = PstKPITypeCompany.listKPITypeCompany(OidKpiType);
        if (listMappedCompanyDb.size() > 0) {
            oid_company = new String[listMappedCompanyDb.size()];
            for (int xyu = 0; xyu < listMappedCompanyDb.size(); xyu++) {
                Company companyInDb = (Company) listMappedCompanyDb.get(xyu);
                oid_company[xyu] = "" + companyInDb.getOID();
                Vector listMappedDivision = PstKpiTypeDivision.listKpiTypeDivision(OidKpiType, companyInDb.getOID());
                countTotalMappedDivision += listMappedDivision.size();
            }


            if (countTotalMappedDivision > 0) {
                oid_division = new String[countTotalMappedDivision];
                for (int xxx = 0; xxx < listMappedCompanyDb.size(); xxx++) {
                    Company companyInDb2 = (Company) listMappedCompanyDb.get(xxx);
                    Vector listMappedDivision2 = PstKpiTypeDivision.listKpiTypeDivision(OidKpiType, companyInDb2.getOID());
                    for (int yyy = 0; yyy < listMappedDivision2.size(); yyy++) {
                        Division divisionInDb = (Division) listMappedDivision2.get(yyy);
                        oid_division[yyy] = "" + divisionInDb.getOID();
                    }
                }
            }
        }
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Master KPI Type</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../stylesheets/custom.css" >
        <link href="../styles/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
        <link href="../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link href="../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">


        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css" >
        <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
        <script src="<%=approot%>/javascripts/sweetalert2.all.min.js"></script>


        <script type="text/javascript">
            function cmdEdit(oid) {
                document.frm.<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }
            function cmdAdd() {
                document.frm.<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.ADD%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }

            function cmdSave() {
                document.frm.command.value = "<%= Command.SAVE%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }

            function cmdList() {
                document.frm.command.value = "<%= Command.LIST%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }

            function cmdUpdateDivision() {
                document.frm.command.value = "<%= Command.ADD%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }

            function cmdDelete(oid) {
                document.frm.<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.DELETE%>";
                document.frm.action = "kpi_type.jsp";
                document.frm.submit();
            }

            function cmdDeleteConfirmation(oid) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Yes, delete data!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        cmdDelete(oid);
                    }
                })
            }

            <% if (iCommand == Command.DELETE) {%>
            $(document).ready(function () {
                Swal.fire({
                    title: 'Deleted',
                    text: "Your data has been deleted!",
                    icon: 'success'
                })
            });
            <%}%>

            <% if (iCommand == Command.SAVE || iCommand == Command.UPDATE) {%>
            $(document).ready(function () {
                Swal.fire({
                    title: 'Saved',
                    text: "Your data has been saved!",
                    icon: 'success'
                })
            });
            <%}%>
        </script>

    </head>
    <body>
        <div class="header">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
                <%@include file="../styletemplate/template_header.jsp" %>
                <%} else {%>
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
                        <table width="100%" bo
                               rder="0" cellspacing="0" cellpadding="0">
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
            <span id="menu_title">Master KPI Type</span>
        </div>
        <form name="frm" method="post" action="">
            <input type="hidden" name="command" value="<%= iCommand%>"> 
            <input type="hidden" name="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]%>" value="<%=OidKpiType%>">

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>   
            <div class="box">
                <div id="box-title">Form Master KPI Type</div>
                <div id="box-content">
                    <table>
                        <tr>
                            <td><strong>Type Name</strong></td>
                            <td>
                                <input type="text"  value="<%=typeName%>" name="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_TYPE_NAME]%>" id="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_TYPE_NAME]%>" size="57" value="">
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Deskripsi</strong></td>
                            <td>
                                <textarea style="width: 97%;"   name="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_DESCRIPTION]%>" id="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_DESCRIPTION]%>"><%=(typeDesc == null )? " " : typeDesc%></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Perusahaan</strong></td>
                            <td>
                                <select name="company" id="company" style="width: 100%;"  multiple="multiple" class="chosen-select"  class="select2" onchange="cmdUpdateDivision();">
                                    <%
                                        Vector listPerusahaan = PstCompany.list(0, 0, "", "");
                                        for (int xy = 0; xy < listPerusahaan.size(); xy++) {
                                            Company objCompany = (Company) listPerusahaan.get(xy);
                                            String selected = "";
                                            if (oid_company != null) {
                                                for (int uu = 0; uu < oid_company.length; uu++) {
                                                    String oidCompany = "" + objCompany.getOID();
                                                    if (oidCompany.equals("" + oid_company[uu])) {
                                                        selected = "selected";
                                                    }
                                                }
                                            }

                                    %>

                                    <option value="<%=objCompany.getOID()%>" <%=selected%>><%=objCompany.getCompany()%></option>
                                    <%
                                        }
                                    %>


                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Divisi</strong></td>
                            <td>
                                <select name="division" id="division" class="chosen-select" style="width: 100%;" multiple="multiple"  class="select2">

                                    <%
                                        String whereDiv = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + "=1";
                                        if (oid_company != null) {
                                            String companySelected = "";
                                            for (int wu = 0; wu < oid_company.length; wu++) {
                                                if (companySelected.length() > 0) {
                                                    companySelected += ",";
                                                }
                                                companySelected += "" + oid_company[wu];
                                            }

                                            whereDiv += " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " IN (" + companySelected + ")";
                                        } else {
                                            whereDiv = " 0 = 1 ";
                                        }
                                        if (appUserSess.getAdminStatus() == 0) {
                                            whereDiv += " AND " + PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + emplx.getDivisionId();
                                            selectDiv = false;
                                        }
                                        Vector divisionList = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                        if (divisionList != null && divisionList.size() > 0) {
                                            for (int i = 0; i < divisionList.size(); i++) {
                                                Division divisi = (Division) divisionList.get(i);
                                                String selected = "";
                                                if (oid_division != null) {
                                                    for (int uu = 0; uu < oid_division.length; uu++) {
                                                        String oidDivision = "" + divisi.getOID();
                                                        if (oidDivision.equals("" + oid_division[uu])) {
                                                            selected = "selected";
                                                        }
                                                    }
                                                }
                                    %>
                                    <option <%=selected%> value="<%= divisi.getOID()%>"><%= divisi.getDivision()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr >
                            <td><strong>Indeks Prioritas</strong></td>
                            <td>
                                <input type="number"  value="<%= PstKPI_Type.getLatestIndexing("") %>" name="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_INDEXING]%>" id="<%=FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_INDEXING]%>" size="20" value="">
                            
                            <input type="checkbox" id="reindex" name="reindex" value="" checked>
                                <label for="reindex"> Urutkan Ulang Data ?  </label>
                            </td>
                           
                        </tr>


                    </table>
                    <div>&nbsp;</div>
                    <div>
                        <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan</a>
                        <a href="javascript:cmdList()" style="color:#FFF;" class="btn">Back</a>
                    </div>
                </div>
            </div>

            <%}%>   




            <div class="content-main">
                <%if (!(iCommand == Command.ADD || iCommand == Command.EDIT)) {%>   
                <div>
                    <a href="javascript:cmdAdd()" style="color:#FFF; " class="btn">Add KPI Type</a>
                </div>
                <%}%>   

                
                <!--Disini dia fetch data kpi nya wkwkw-->
                <%
                    listKpiType = PstKPI_Type.list(0, 0, "", "`NUMBER_INDEX` ASC ");
                    //listKpiType = PstKPI_Type.list(0, 0, "", "");
                    
                    if (listKpiType.size() > 0) {
                %>

                <table class="tblStyle" style=" margin-top: 50px;">
                    <tr>
                        <td class="title_tbl" colspan="7" style="text-align: center; font-size: 18px;">Daftar KPI Type</td>
                    </tr>
                    <tr>
                        <td class="title_tbl text-center" style="text-align: center;">No</td>
                        <td class="title_tbl text-center" style="text-align: center;">KPI Type Name</td>
                        <td class="title_tbl text-center" style="text-align: center;">Index</td>
                        <td class="title_tbl text-center" style="text-align: center;">Description</td>
                        <td class="title_tbl text-center" style="text-align: center;">Company | Division</td>
                        <td class="title_tbl text-center" style="text-align: center;">Action</td>
                    </tr>
                    <%
                        if (listKpiType != null && listKpiType.size() > 0) {
                            for (int i = 0; i < listKpiType.size(); i++) {
                                KPI_Type objKpiType = (KPI_Type) listKpiType.get(i);

                    %>
                    <tr>
                        <td style="background-color: #FFF;"><%= (i + 1)%></td>
                        <td style="background-color: #FFF;"><%= objKpiType.getType_name()%></td>
                        <td style="background-color: #FFF;"><%= objKpiType.getIndexing()%></td>
                        <td style="background-color: #FFF;"><%=  (objKpiType.getDescription() == null) ? "-" : objKpiType.getDescription()%></td>
                        <td style="background-color: #FFF;">
                            <table style="border:1px none; border: none" cellspacing="0" cellpadding="0">
                                <tbody  style="border: none !important;">
                                    
                                    <%
                                        int countCompany = 0;
                                        Vector listMappedCompany = PstKPITypeCompany.listKPITypeCompany(objKpiType.getOID());
                                        if(listMappedCompany.size() > 0) {
                                            for (int ww = 0; ww < listMappedCompany.size(); ww++) {
                                                Company objListCompany = (Company) listMappedCompany.get(ww);
                                                countCompany++;
                                                Vector listMappedDivision = PstKpiTypeDivision.listKpiTypeDivision(objKpiType.getOID(), objListCompany.getOID());

                                    %>
                                    <tr>
                                        <td rowspan="<%=listMappedDivision.size() == 0 ? "" : listMappedDivision.size()%>"><%=objListCompany.getCompany()%></td>
                                        <%if (listMappedDivision.size() > 0) {
                                                Division objListDivision = (Division) listMappedDivision.get(0);
                                        %>
                                        <td><%=objListDivision.getDivision()%></td>
                                        <%} else {%>
                                        <td>-</td>
                                        <%}%>
                                    </tr>

                                    <%if (listMappedDivision.size() > 1) {

                                            for (int yy = 1; yy < listMappedDivision.size(); yy++) {
                                                Division objListDivision = (Division) listMappedDivision.get(yy);
                                    %>
                                    <tr>
                                        <td><%=objListDivision.getDivision()%></td>
                                    </tr>
                                    <%}%>
                                    <%}%>

                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="3" style="text-align: center;"> - </td>
                                    </tr>

                                    <%}%>


                                </tbody>
                            </table>
                        </td>
                        <td style="background-color: #FFF;">
                            <a  class="btn btn-primary"  style="color: white; margin: 3px,3px,3px,3px;" href="javascript:cmdEdit('<%=objKpiType.getOID()%>')">Edit</a>
                            <a class="btn btn-primary"   style="color: white;  margin: 3px,3px,3px,3px;" href="javascript:cmdDeleteConfirmation('<%=objKpiType.getOID()%>')">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>

                </table>
                <% }%>
                <div>&nbsp;</div>

        </form>
    </div>
    <div class="footer-page">
        <table>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom"><%@include file="../footer.jsp" %></td>
            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
            </tr>
            <%}%>
        </table>
    </div>
    <script type="text/javascript">
        var config = {
            '.chosen-select': {},
            '.chosen-select-deselect': {allow_single_deselect: true},
            '.chosen-select-no-single': {disable_search_threshold: 10},
            '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
            '.chosen-select-width': {width: "100%"}
        }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }


    </script>    
    <script src="../javascripts/jquery.min.js" type="text/javascript"></script>
    <script src="../styles/select2/js/select2.full.min.js" type="text/javascript"></script>
    <script src="../javascripts/bootstrap.bundle.min.js" type="text/javascript"></script>
    <script language="JavaScript">
        //var oBody = document.body;
        //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);

        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2()

            //Initialize Select2 Elements

            $('.select2bs4').select2({
                theme: 'bootstrap4'
            })
        })
    </script>


</body>

</html>

