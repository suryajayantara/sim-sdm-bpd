<%-- 
    Document   : xxxx
    Created on : 01-Oct-2016, 11:47:25
    Author     : GUSWIK
--%>

<%@page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@page import="com.dimata.harisma.entity.payroll.*"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@page import="com.dimata.util.*"%>
<%@page import="java.util.*"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.entity.log.*"%>
<%@page import="com.dimata.qdep.form.*"%>
<%@page import="com.dimata.util.Formater"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int iCommand = 8;
    long oidPeriod = 504404627441165355l;
    long companyId = 504404575327187914l;
    long divisionId = 2014l;
    String[] divisionSelect = {""+2014};
    ChangeValue changeValue = new ChangeValue();
   
    Vector listDebet = new Vector(1,1);
    Vector listKredit = new Vector(1,1);
    if (iCommand == Command.VIEW){
        listDebet = PstPerkiraan.list(0, 0, ""+ PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 0", "");
        listKredit = PstPerkiraan.list(0, 0, ""+ PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 1", "");        
    }
   
%>
<%!
    public String getPeriodName(long oid){
        String str = "-";
        try {
            PayPeriod payPeriod = PstPayPeriod.fetchExc(oid);
            str = payPeriod.getPeriod();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return str;
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table>
                    <tr>
                        <td valign="top" style="padding-left: 32px">
                            <%
                            double[][] dataCoa = null;
                            String [][] dataAccount = null;
                            int n = 0;
                            if (divisionSelect != null && divisionSelect.length > 0){
                                if (listDebet != null && listDebet.size()>0){
                                %>
                                <div>&nbsp;</div>
                                    <%
                                    for (int i=0; i<divisionSelect.length; i++){
                                        %>
                                        <div class="content-list">
                                            <table>
                                                <tr>
                                                    <td class="td_title" valign="top"><strong>DEBET</strong></td>
                                                    
                                                </tr>
                                            </table>
                                            <div>&nbsp;</div>
                                            <table class="tblStyle" border="1" >
                                                <%
                                                double total = 0;
                                                double debitTotal = 0;
                                                double creditTotal = 0;
                                                double debitSum = 0;
                                                double creditSum = 0;
                                                int no = 0;
                                                /* inisialisasi arr 2 dimenesi */
                                                if (dataCoa == null){
                                                    for(int p=0; p < listDebet.size(); p++){
                                                        Perkiraan perkiraan = (Perkiraan)listDebet.get(p); 
                                                        divisionId = Long.valueOf(divisionSelect[i]);
                                                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                        if (check){
                                                            n++;
                                                        }
                                                    }
                                                    dataCoa = new double[n][2];
                                                    dataAccount = new String[n][2];
                                                }
                                                
                                                
                                                for(int p=0; p < listDebet.size(); p++){
                                                    Perkiraan perkiraan = (Perkiraan)listDebet.get(p); 
                                                    divisionId = Long.valueOf(divisionSelect[i]);
                                                    boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                    if (check){
                                                        total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId);
                                                        dataAccount[no][0] = perkiraan.getNoPerkiraan();
                                                        dataAccount[no][1] = perkiraan.getNama();
                                                        if (perkiraan.getTandaDebetKredit()==0){
                                                            debitTotal = total;
                                                            creditTotal = 0;
                                                            dataCoa[no][0] = dataCoa[no][0] + total;
                                                            debitSum = debitSum + debitTotal;
                                                        } else {
                                                            debitTotal = 0;
                                                            creditTotal = total;
                                                            dataCoa[no][1] = dataCoa[no][1] + total;
                                                            creditSum = creditSum + creditTotal;
                                                        }
                                                        
                                                        no++;
                                                    %>
                                                    <tr>
                                                        <td style="background-color: #FFF"><%= no %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNama() %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNoPerkiraan() %></td>
                                                        <td style="background-color: #FFF"><%= Formater.formatNumberMataUang(debitTotal, "Rp") %></td>
                                                    </tr>
                                                <% 
                                                    }
                                                }
                                                %>
                                                <tr>
                                                    <td style="background-color: #EEE;" colspan="3"><strong>Total</strong></td>
                                                    <td style="background-color: #EEE;">
                                                        <strong><%= Formater.formatNumberMataUang(debitSum, "Rp")  %></strong>
                                                    </td>
                                                    
                                                </tr>
                                            </table>
                                            
                                        </div>
                                            
                                        <%
                                    }
                                }
                            }
                            %>
                            
                            <%
                            double[][] dataCoaKredit = null;
                            String [][] dataAccountKredit = null;
                            int x = 0;
                            if (divisionSelect != null && divisionSelect.length > 0){
                                if (listKredit != null && listKredit.size()>0){
                                %>
                                <div>&nbsp;</div>
                                    <%
                                    for (int i=0; i<divisionSelect.length; i++){
                                        %>
                                        <div class="content-list">
                                            <table>
                                                <tr>
                                                    <td class="td_title" valign="top"><strong>KREDIT</strong></td>
                                                    
                                                </tr>
                                            </table>
                                            <div>&nbsp;</div>
                                            <table class="tblStyle" border="1" >
                                                <%
                                                double total = 0;
                                                double debitTotal = 0;
                                                double creditTotal = 0;
                                                double debitSum = 0;
                                                double creditSum = 0;
                                                int no = 0;
                                                /* inisialisasi arr 2 dimenesi */
                                                if (dataCoaKredit == null){
                                                    for(int p=0; p < listKredit.size(); p++){
                                                        Perkiraan perkiraan = (Perkiraan)listKredit.get(p); 
                                                        divisionId = Long.valueOf(divisionSelect[i]);
                                                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                        if (check){
                                                            x++;
                                                        }
                                                    }
                                                    dataCoaKredit = new double[n][2];
                                                    dataAccountKredit = new String[n][2];
                                                }
                                                
                                                
                                                for(int p=0; p < listKredit.size(); p++){
                                                    Perkiraan perkiraan = (Perkiraan)listKredit.get(p); 
                                                    divisionId = Long.valueOf(divisionSelect[i]);
                                                    boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                                    if (check){
                                                        total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId);
                                                        dataAccountKredit[no][0] = perkiraan.getNoPerkiraan();
                                                        dataAccountKredit[no][1] = perkiraan.getNama();
                                                        if (perkiraan.getTandaDebetKredit()==0){
                                                            debitTotal = total;
                                                            creditTotal = 0;
                                                            dataCoaKredit[no][0] = dataCoa[no][0] + total;
                                                            debitSum = debitSum + debitTotal;
                                                        } else {
                                                            debitTotal = 0;
                                                            creditTotal = total;
                                                            dataCoaKredit[no][1] = dataCoa[no][1] + total;
                                                            creditSum = creditSum + creditTotal;
                                                        }
                                                        
                                                        no++;
                                                    %>
                                                    <tr>
                                                        <td style="background-color: #FFF"><%= no %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNama() %></td>
                                                        <td style="background-color: #FFF"><%= perkiraan.getNoPerkiraan() %></td>
                                                        <td style="background-color: #FFF"><%= Formater.formatNumberMataUang(creditTotal, "Rp") %></td>
                                                    </tr>
                                                <% 
                                                    }
                                                }
                                                %>
                                                <tr>
                                                    <td style="background-color: #EEE;" colspan="3"><strong>Total</strong></td>
                                                    <td style="background-color: #EEE;">
                                                        <strong><%= Formater.formatNumberMataUang(creditSum, "Rp")  %></strong>
                                                    </td>
                                                    
                                                </tr>
                                            </table>
                                            
                                        </div>
                                            
                                        <%
                                    }
                                }
                            }
                            %>
                            
                            <%
                            if (divisionSelect != null && divisionSelect.length > 1){
                                double dataDebitSum = 0;
                                double dataCreditSum = 0;
                                if (dataCoa != null){
                                    %>
                                    <div>&nbsp;</div>
                                    <div class="content-list">
                                        <strong style="color:#575757">Gabungan dari Satuan Kerja</strong>
                                        <div>&nbsp;</div>
                                        <table class="tblStyle">
                                            <tr>
                                                <td class="title_tbl">No</td>
                                                <td class="title_tbl">Account</td>
                                                <td class="title_tbl">Description</td>
                                                <td class="title_tbl">Debit</td>
                                                <td class="title_tbl">Credit</td>
                                            </tr>
                                            <%
                                            for (int i=0; i<n; i++){
                                                dataDebitSum = dataDebitSum + dataCoa[i][0];
                                                dataCreditSum = dataCreditSum + dataCoa[i][1];
                                            %>
                                            <tr>
                                                <td><%= (i+1) %></td>
                                                <td><%= dataAccount[i][0] %></td>
                                                <td><%= dataAccount[i][1] %></td>
                                                <td><%= Formater.formatNumberMataUang(dataCoa[i][0], "Rp")  %>
                                                <td><%= Formater.formatNumberMataUang(dataCoa[i][1], "Rp")  %>
                                            </tr>
                                            <% } %>
                                            <tr>
                                                <td colspan="3"><strong>Total</strong></td>
                                                <td><strong><%= Formater.formatNumberMataUang(dataDebitSum, "Rp")  %></strong></td>
                                                <td><strong><%= Formater.formatNumberMataUang(dataCreditSum, "Rp")  %></strong></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <%
                                }
                            }
                            %>
                            
                        </td>
                    </tr>
                </table>
    </body>
</html>
