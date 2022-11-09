<%-- 
    Document   : search_training_history
    Created on : Aug 15, 2016, 1:58:06 PM
    Author     : Dimata 007
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_TRAINING, AppObjInfo.OBJ_TRAINING_SEARCH); %>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String startDate = FRMQueryString.requestString(request, "start_date");
    String endDate = FRMQueryString.requestString(request, "end_date");
    Date today = new Date();
    String sToday = Formater.formatDate(today,"yyyy-MM-dd");
    if(!(startDate.length() > 0)){
        startDate = sToday;
    }
    if(!(endDate.length() > 0)){
        endDate = sToday;
    }
   
/* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
    
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Riwayat Pelatihan / Sertifikasi</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold; background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
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
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
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
            #title-box {
                color: #007fba;
                border-bottom: 1px solid #DDD; 
                font-weight: bold; 
                font-size: 14px;
                padding-bottom: 9px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 15px 17px;
                margin: 5px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .formstyle {
                background-color: #FFF;
                padding: 21px;
                border-radius: 3px;
                margin: 3px 0px;
            }
            .form-title {
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 13px 17px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                visibility: hidden;
            }
            #btn-confirm {
                padding: 4px 9px; border-radius: 3px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px; 
            }
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            td:before {
                content: "'";
                position: absolute;
                top: 0;
                left: 0;
                background-color: white;
                color: white;
            }
        </style>
<script type="text/javascript">
 

function cmdSearch() {
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            document.getElementById("list-result").innerHTML = xmlhttp.responseText;
            loadDataTable();
            $(document).ready(function() {
                document.getElementById("resutdata_wrapper").className = "no-footer";
                
            } );
        } else {
            document.getElementById("list-result").innerHTML = "loading...";
        }
    };
    var strUrl = "list_data_riwayat_pelatihan.jsp";
    strUrl += "?company_id="+document.getElementById("company").value;
    strUrl += "&division_id="+document.getElementById("division").value;
    strUrl += "&department_id="+document.getElementById("department").value;
    strUrl += "&section_id="+document.getElementById("section").value;
    strUrl += "&emp_name="+document.getElementById("emp_name").value;
    strUrl += "&emp_num="+document.getElementById("emp_num").value;
    strUrl += "&start_date="+document.getElementById("start_date").value;
    strUrl += "&end_date="+document.getElementById("end_date").value;
    xmlhttp.open("GET", strUrl, true);
    xmlhttp.send();
   
     
}
function loadCompany(
    pCompanyId, pDivisionId, pDepartmentId, pSectionId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (pCompanyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
        strUrl += "?p_company_id="+pCompanyId;
        strUrl += "&p_division_id="+pDivisionId;
        strUrl += "&p_department_id="+pDepartmentId;
        strUrl += "&p_section_id="+pSectionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadDivision(
    companyId, frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (companyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";

        strUrl += "?company_id="+companyId;

        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);

        xmlhttp.send();
    }
}
    
function loadDepartment(
    companyId, divisionId, frmCompany, 
    frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadSection(
    companyId, divisionId, departmentId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)&&(departmentId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        strUrl += "&department_id="+departmentId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}

function pageLoad(){ 
    loadCompany(<%=strUrl%>);

} 



function loadDataTable(){
   var buttonCommon = {
        exportOptions: {
            format: {
                body: function ( data, row, column, node ) {
                    // Strip $ from salary column to make it numeric
                    if(column === 2){
                         return data = data;
                    }else if(column === 5 ){
                       return data;
                      
                    }else{
                       return data ;
                    }
                    
                        
                }
            }
        }
    };
    

    
         $('#resutdata').DataTable( {
                      "paging":   false,
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                      dom: 'frtip',
                      buttons: [
                        $.extend( true, {}, buttonCommon, {
                            extend: 'copyHtml5'
                        } ),
                        $.extend( true, {}, buttonCommon, {
                            extend: 'excelHtml5',
                             customizeData: function(data) {
                            for(var i = 0; i < data.body.length; i++) {
                              for(var j = 0; j < data.body[i].length; j++) {
                                data.body[i][j] = '\u200C' + data.body[i][j];
                              }
                            }
                          }
                               ,
                         customize: function ( xlsx ){
                                                var sheet = xlsx.xl.worksheets['sheet1.xml'];
                                               var table = $('#resutdata').DataTable();
                                               var data_size = 0;
                                               if(table.data().count() > 0){
                                                    var data_size = table.data().count() / 10;
                                                    data_size = data_size + 3
                                                    
                                                }
                                           
//                                                 jQuery selector to add a border
//                                                 
//                                                 $('row c[r="A1"]', sheet).attr( 's', '7' );
                                                for(var x = 0 ; x < data_size ; x++){
                                                 if(x!=1){
                                                 $('row c[r="A'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="B'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="C'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="D'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="E'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="F'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="G'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="H'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="I'+x+'"]', sheet).attr( 's', '25' );
                                                 $('row c[r="J'+x+'"]', sheet).attr( 's', '25' );
                                                 }
                                                 }
                                               
                                            }
                        } ),
                        $.extend( true, {}, buttonCommon, {
                            extend: 'pdfHtml5'
                        } )
                    ]
                  } );
              }
             
function cmdPrint(){
             
                  
          var table = $('#resutdata').DataTable();
           table.button( '1' ).trigger();
           


}

</script>        
    </head>
    <body onload="pageLoad()">
        
        <link href="../../styles/datatable/jquery.dataTables.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/datatable/buttons.dataTables.min.css" rel="stylesheet" type="text/css"/>
<!--    <link  rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" >-->
<!--     <link  rel="stylesheet" href="https://cdn.datatables.net/buttons/1.6.4/css/buttons.dataTables.min.css" >-->
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
            <span id="menu_title">Pelatihan <strong style="color:#333;"> / </strong>Data Riwayat Pelatihan</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                 <div class="formstyle">
                <table width="100%">
                    <tr>
                        <td valign="top">
                            <div class="caption">Nama Karyawan</div>
                            <div class="divinput">
                                <input type="text" name="emp_name" id="emp_name" value="" size="50" />
                            </div>
                            <div class="caption">NRK</div>
                            <div class="divinput">
                                <input type="text" name="emp_num" id="emp_num" value="" />
                            </div>
                            <div id="div_result"></div>
                            <div class="caption">Start Date / End Date</div>
                            <div class="divinput">
                                <input type="date" name="start_date" required="required" id="start_date" value="" />
                                <input type="date" name="end_date" required="required" id="end_date" value="" />
                            </div>
                          
                            <div>&nbsp;</div>
                            <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
<!--                            <a href="javascript:cmdPrint()" class="btn" style="color:#FFF;">Print Excel</a>-->
                            <div>&nbsp;</div>
                        </td>
                       
                    </tr>
                </table>
                 </div>
                 <div class="formstyle">
                      <td valign="top" >
                           
                            <div id="list-result"></div>
                        </td>
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
<!--            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
            <script src="../../javascripts/jquery.table2excel.js"></script>-->
<script src="../../javascripts/jquery-3.5.1.js" type="text/javascript"></script>
<script src="../../styles/datatable/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/dataTables.buttons.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/buttons.flash.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/jszip.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/pdfmake.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/vfs_fonts.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/buttons.html5.min.js" type="text/javascript"></script>
<script src="../../javascripts/datatables/buttons.print.min.js" type="text/javascript"></script>
<!--             <script src="https://code.jquery.com/jquery-3.5.1.js"></script>-->
<!--             <script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>-->
<!--             <script src="https://cdn.datatables.net/buttons/1.6.4/js/dataTables.buttons.min.js"></script>-->
<!--             <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.flash.min.js"></script>-->
<!--             <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>-->
<!--             <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>-->
<!--             <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>-->
<!--             <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.html5.min.js"></script>-->
<!--             <script src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.print.min.js"></script>-->
    
    
    
    
    
    
    
    

            <script>
         document.getElementById("start_date").value = "<%=startDate%>";
         document.getElementById("end_date").value = "<%=endDate%>";
        </script>
    </body>
   
</html>
