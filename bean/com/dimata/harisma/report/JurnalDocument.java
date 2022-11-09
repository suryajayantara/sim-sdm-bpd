/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.report;

import com.dimata.aiso.entity.masterdata.Perkiraan;
import com.dimata.aiso.entity.masterdata.PstPerkiraan;
import com.dimata.harisma.entity.attendance.AlStockManagement;
import com.dimata.harisma.entity.attendance.AlStockTaken;
import com.dimata.harisma.entity.attendance.LLStockManagement;
import com.dimata.harisma.entity.attendance.LlStockTaken;
import com.dimata.harisma.entity.attendance.PstAlStockManagement;
import com.dimata.harisma.entity.attendance.PstAlStockTaken;
import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.attendance.PstLLStockManagement;
import com.dimata.harisma.entity.attendance.PstLlStockTaken;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.log.ChangeValue;
import com.dimata.harisma.entity.masterdata.ComponentCoaMap;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.DepartmentType;
import com.dimata.harisma.entity.masterdata.EmpDoc;
import com.dimata.harisma.entity.masterdata.EmpDocField;
import com.dimata.harisma.entity.masterdata.EmpDocList;
import com.dimata.harisma.entity.masterdata.EmpDocListExpense;
import com.dimata.harisma.entity.masterdata.GradeLevel;
import com.dimata.harisma.entity.masterdata.PstComponentCoaMap;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDepartmentType;
import com.dimata.harisma.entity.masterdata.PstEmpDoc;
import com.dimata.harisma.entity.masterdata.PstEmpDocField;
import com.dimata.harisma.entity.masterdata.PstEmpDocList;
import com.dimata.harisma.entity.masterdata.PstEmpDocListExpense;
import com.dimata.harisma.entity.masterdata.PstGradeLevel;
import com.dimata.harisma.entity.masterdata.PstScheduleSymbol;
import com.dimata.harisma.entity.payroll.PayComponent;
import com.dimata.harisma.entity.payroll.PayPeriod;
import com.dimata.harisma.entity.payroll.PstPayComponent;
import com.dimata.harisma.entity.payroll.PstPayPeriod;
import com.dimata.harisma.entity.payroll.PstPaySlip;
import static com.dimata.harisma.report.leave.LeaveFormPdf.convertInteger;
import com.dimata.harisma.session.attendance.SessEmpSchedule;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.system.entity.system.PstSystemProperty;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class JurnalDocument {

    public static String getPeriodName(long oid) {
        String str = "-";
        try {
            PayPeriod payPeriod = PstPayPeriod.fetchExc(oid);
            str = payPeriod.getPeriod();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return str;
    }

    public static String listJurnal(long oidPeriod, long companyId, String[] divisionSelect) {
        String valueReturn = "";

        Vector listPerkiraan = new Vector(1, 1);
        Vector listDebet = new Vector(1, 1);
        Vector listKredit = new Vector(1, 1);
        listPerkiraan = PstPerkiraan.list(0, 0, "", "");
        listDebet = PstPerkiraan.list(0, 0, "" + PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 0", "");
        listKredit = PstPerkiraan.list(0, 0, "" + PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 1", "");
        long divisionId = 0;
        ChangeValue changeValue = new ChangeValue();
        DBResultSet dbrs = null;
        try {
            valueReturn = "<table>"
                    + "<tr>"
                    + "<td valign=\"top\" style=\"padding-left: 32px\">";
            double[][] dataCoaDebet = null;
            String[][] dataAccountDebet = null;
            int n = 0;
            if (divisionSelect != null && divisionSelect.length > 0) {
                if (listDebet != null && listDebet.size() > 0) {
                    for (int i = 0; i < divisionSelect.length; i++) {
                        valueReturn += "<div class=\"content-list\">"
                                + "<div>&nbsp;</div>"
                                + "<table>"
                                + "<tr>"
                                + "<td class=\"td_title\" valign=\"top\"><strong>DEBET</strong></td>"
                                + "</tr>"
                                + "</table>"
                                + "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">";;
                        double total = 0;
                        double debitTotal = 0;
                        double creditTotal = 0;
                        double debitSum = 0;
                        double creditSum = 0;
                        int no = 0;
                        /* inisialisasi arr 2 dimenesi */
                        if (dataCoaDebet == null) {
                            for (int p = 0; p < listDebet.size(); p++) {
                                Perkiraan perkiraan = (Perkiraan) listDebet.get(p);
                                divisionId = Long.valueOf(divisionSelect[i]);
                                boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                if (check) {
                                    n++;
                                }
                            }
                            dataCoaDebet = new double[n][2];
                            dataAccountDebet = new String[n][2];
                        }


                        for (int p = 0; p < listDebet.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) listDebet.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                                dataAccountDebet[no][0] = perkiraan.getNoPerkiraan();
                                dataAccountDebet[no][1] = perkiraan.getNama();
                                if (perkiraan.getTandaDebetKredit() == 0) {
                                    debitTotal = total;
                                    creditTotal = 0;
                                    dataCoaDebet[no][0] = dataCoaDebet[no][0] + total;
                                    debitSum = debitSum + debitTotal;
                                } else {
                                    debitTotal = 0;
                                    creditTotal = total;
                                    dataCoaDebet[no][1] = dataCoaDebet[no][1] + total;
                                    creditSum = creditSum + creditTotal;
                                }

                                no++;
                                valueReturn += "<tr>"
                                        + "<td style=\"background-color: #FFF; width:5%\">" + no + "</td>"
                                        + "<td style=\"background-color: #FFF; width:45%\">" + perkiraan.getNama() + "</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + perkiraan.getNoPerkiraan() + "</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(debitTotal, "Rp") + " </td>"
                                        + "</tr>";
                            }
                        }
                        valueReturn += "<tr>"
                                + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                                + "<td style=\"background-color: #EEE;\">"
                                + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                                + "</td>"
                                + "</tr>"
                                + "</table>"
                                + "</div>";

                    }
                }
            }

            double[][] dataCoaKredit = null;
            String[][] dataAccountKredit = null;
            int x = 0;
            if (divisionSelect != null && divisionSelect.length > 0) {
                if (listKredit != null && listKredit.size() > 0) {
                    for (int i = 0; i < divisionSelect.length; i++) {
                        valueReturn += "<div class=\"content-list\">"
                                + "<div>&nbsp;</div>"
                                + "<table>"
                                + "<tr>"
                                + "<td class=\"td_title\" valign=\"top\"><strong>KREDIT</strong></td>"
                                + "</tr>"
                                + "</table>"
                                + "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">";;
                        double total = 0;
                        double debitTotal = 0;
                        double creditTotal = 0;
                        double debitSum = 0;
                        double creditSum = 0;
                        int no = 0;
                        /* inisialisasi arr 2 dimenesi */
                        if (dataCoaKredit == null) {
                            for (int p = 0; p < listKredit.size(); p++) {
                                Perkiraan perkiraan = (Perkiraan) listKredit.get(p);
                                divisionId = Long.valueOf(divisionSelect[i]);
                                boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                if (check) {
                                    x++;
                                }
                            }
                            dataCoaKredit = new double[n][2];
                            dataAccountKredit = new String[n][2];
                        }


                        for (int p = 0; p < listKredit.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) listKredit.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                                dataAccountKredit[no][0] = perkiraan.getNoPerkiraan();
                                dataAccountKredit[no][1] = perkiraan.getNama();
                                if (perkiraan.getTandaDebetKredit() == 0) {
                                    debitTotal = total;
                                    creditTotal = 0;
                                    dataCoaKredit[no][0] = dataCoaKredit[no][0] + total;
                                    debitSum = debitSum + debitTotal;
                                } else {
                                    debitTotal = 0;
                                    creditTotal = total;
                                    dataCoaKredit[no][1] = dataCoaKredit[no][1] + total;
                                    creditSum = creditSum + creditTotal;
                                }

                                no++;
                                valueReturn += "<tr>"
                                        + "<td style=\"background-color: #FFF; width:5%\">" + no + "</td>"
                                        + "<td style=\"background-color: #FFF; width:45%\">" + perkiraan.getNama() + "</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + perkiraan.getNoPerkiraan() + "</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                                        + "</tr>";
                            }
                        }
                        valueReturn += "<tr>"
                                + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                                + "<td style=\"background-color: #EEE;\">"
                                + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                                + "</td>"
                                + "</tr>"
                                + "</table>"
                                + "</div>";

                    }
                }
            }

            valueReturn += "</td>"
                    + "</tr>"
                    + "</table>";

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return valueReturn;
    }

    public static String listJurnalAllDiv(long oidPeriod, long companyId, String[] divisionSelect) {
        String valueReturn = "";

        Vector listPerkiraan = new Vector(1, 1);
        Vector listDebet = new Vector(1, 1);
        Vector listKredit = new Vector(1, 1);
        listPerkiraan = PstPerkiraan.list(0, 0, "", "");
        listDebet = PstPerkiraan.list(0, 0, "" + PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 0", "");
        listKredit = PstPerkiraan.list(0, 0, "" + PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + " = 1", "");
        long divisionId = 0;
        DBResultSet dbrs = null;
        try {
            valueReturn = "<table>"
            + "<tr>"
            + "<td valign=\"top\" style=\"padding-left: 32px\">";
            //Start Debet
            double[][] dataCoaDebet = null;
            String[][] dataAccountDebet = null;
            int n = 0;
            if (divisionSelect != null && divisionSelect.length > 0) {
                if (listDebet != null && listDebet.size() > 0) {

                    for (int i = 0; i < divisionSelect.length; i++) {

                        double total = 0;
                        double debitTotal = 0;
                        double creditTotal = 0;
                        double debitSum = 0;
                        double creditSum = 0;
                        int no = 0;
                        /* inisialisasi arr 2 dimenesi */
                        if (dataCoaDebet == null) {
                            for (int p = 0; p < listDebet.size(); p++) {
                                Perkiraan perkiraan = (Perkiraan) listDebet.get(p);
                                divisionId = Long.valueOf(divisionSelect[i]);
                                boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                if (check) {
                                    n++;
                                }
                            }
                            dataCoaDebet = new double[n][2];
                            dataAccountDebet = new String[n][2];
                        }


                        for (int p = 0; p < listDebet.size(); p++) {
                            Perkiraan perkiraan = new Perkiraan();
                            perkiraan = (Perkiraan) listDebet.get(p);
                            if (perkiraan.getOID() == 0) {
                                continue;
                            }
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                                try {
                                    dataAccountDebet[no][0] = perkiraan.getNoPerkiraan();
                                    dataAccountDebet[no][1] = perkiraan.getNama();
                                    if (perkiraan.getTandaDebetKredit() == 0) {
                                        debitTotal = total;
                                        creditTotal = 0;
                                        dataCoaDebet[no][0] = dataCoaDebet[no][0] + total;
                                        debitSum = debitSum + debitTotal;
                                    } else {
                                        debitTotal = 0;
                                        creditTotal = total;
                                        dataCoaDebet[no][1] = dataCoaDebet[no][1] + total;
                                        creditSum = creditSum + creditTotal;
                                    }
                                } catch (Exception e) {
                                }
                                no++;

                            }
                        }

                    }
                }
            }
            if (divisionSelect != null && divisionSelect.length > 1) {
                double dataDebitSum = 0;
                double dataCreditSum = 0;
                if (dataCoaDebet != null) {
                    valueReturn += "<div>&nbsp;</div>"
                            + "<div class=\"content-list\">"
                            + "<strong style=\"color:#575757\">DEBET</strong>"
                            + "<div>&nbsp;</div>"
                            + "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">";
                    for (int i = 0; i < n; i++) {
                        dataDebitSum = dataDebitSum + dataCoaDebet[i][0];
                        dataCreditSum = dataCreditSum + dataCoaDebet[i][1];
                        valueReturn += "<tr>"
                                + "<td>" + (i + 1) + "</td>"
                                + "<td>" + dataAccountDebet[i][1] + "</td>"
                                + "<td>" + dataAccountDebet[i][0] + "</td>"
                                + "<td>" + Formater.formatNumberMataUang(dataCoaDebet[i][0], "Rp") + ""
                                + "</tr>";
                    }
                    valueReturn += " <tr>"
                            + "<td colspan=\"3\"><strong>Total</strong></td>"
                            + "<td><strong>" + Formater.formatNumberMataUang(dataDebitSum, "Rp") + "</strong></td>"
                            + "</tr>"
                            + "</table>"
                            + "</div>";
                }
            }
//End Debet
//Start Kredit
            double[][] dataCoaKredit = null;
            String[][] dataAccountKredit = null;
            int x = 0;
            if (divisionSelect != null && divisionSelect.length > 0) {
                if (listKredit != null && listKredit.size() > 0) {

                    for (int i = 0; i < divisionSelect.length; i++) {

                        double total = 0;
                        double debitTotal = 0;
                        double creditTotal = 0;
                        double debitSum = 0;
                        double creditSum = 0;
                        int no = 0;
                        /* inisialisasi arr 2 dimenesi */
                        if (dataCoaKredit == null) {
                            for (int p = 0; p < listKredit.size(); p++) {
                                Perkiraan perkiraan = (Perkiraan) listKredit.get(p);
                                divisionId = Long.valueOf(divisionSelect[i]);
                                boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                                if (check) {
                                    x++;
                                }
                            }
                            dataCoaKredit = new double[n][2];
                            dataAccountKredit = new String[n][2];
                        }


                        for (int p = 0; p < listKredit.size(); p++) {
                            Perkiraan perkiraan = new Perkiraan();
                            perkiraan = (Perkiraan) listKredit.get(p);
                            if (perkiraan.getOID() == 0) {
                                continue;
                            }
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                                try {
                                    dataAccountKredit[no][0] = perkiraan.getNoPerkiraan();
                                    dataAccountKredit[no][1] = perkiraan.getNama();
                                    if (perkiraan.getTandaDebetKredit() == 0) {
                                        debitTotal = total;
                                        creditTotal = 0;
                                        dataCoaKredit[no][0] = dataCoaKredit[no][0] + total;
                                        debitSum = debitSum + debitTotal;
                                    } else {
                                        debitTotal = 0;
                                        creditTotal = total;
                                        dataCoaKredit[no][1] = dataCoaKredit[no][1] + total;
                                        creditSum = creditSum + creditTotal;
                                    }
                                } catch (Exception e) {
                                }
                                no++;

                            }
                        }


                    }
                }
            }
            if (divisionSelect != null && divisionSelect.length > 1) {
                double dataDebitSum = 0;
                double dataCreditSum = 0;
                if (dataCoaKredit != null) {
                    valueReturn += "<div>&nbsp;</div>"
                            + "<div class=\"content-list\">"
                            + "<strong style=\"color:#575757\">KREDIT</strong>"
                            + "<div>&nbsp;</div>"
                            + "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\">";
                    for (int i = 0; i < x; i++) {
                        dataDebitSum = dataDebitSum + dataCoaKredit[i][0];
                        dataCreditSum = dataCreditSum + dataCoaKredit[i][1];
                        valueReturn += "<tr>"
                                + "<td>" + (i + 1) + "</td>"
                                + "<td>" + dataAccountKredit[i][1] + "</td>"
                                + "<td>" + dataAccountKredit[i][0] + "</td>"
                                + "<td>" + Formater.formatNumberMataUang(dataCoaKredit[i][1], "Rp") + ""
                                + "</tr>";
                    }
                    valueReturn += " <tr>"
                            + "<td colspan=\"3\"><strong>Total</strong></td>"
                            + "<td><strong>" + Formater.formatNumberMataUang(dataCreditSum, "Rp") + "</strong></td>"
                            + "</tr>"
                            + "</table>"
                            + "</div>";
                }
            }
//End Kredit
            valueReturn += "</td>"
                    + "</tr>"
                    + "</table>";

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return valueReturn;
    }
    /*
     * Document : function print jurnal
     * author : Hendra Putu
     * Date : 2016-12-18
     */
    public static String printJurnal(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        ChangeValue changeValue = new ChangeValue();
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        int n = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>DEBET</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanDebetList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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

                            /* print debet output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(debitTotal, "Rp") + " </td>"
                            + "</tr>";
          
                            no++;    
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
                }
            }
            
            
            
            dataCoa = null;
            dataAccount = null;
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>CREDIT</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanCreditList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                            + "</tr>";        
                            
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                }
            }
        }
        return htmlOutput;
    }
    
    public static String printJurnalWithTotal(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        ChangeValue changeValue = new ChangeValue();
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        int n = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>DEBET</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanDebetList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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

                            /* print debet output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\"></td>"
                            + "<td style=\"background-color: #FFF; width:25%\"></td>"
                            + "</tr>";
          
                            no++;    
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                            
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\"></td>"
                            + "<td style=\"background-color: #FFF; width:45%\"></td>"
                            + "<td style=\"background-color: #FFF; width:25%\"><b>TOTAL</b></td>"
                            + "<td style=\"background-color: #FFF; width:25%\"><b>" + Formater.formatNumberMataUang(debitTotal, "Rp") + " </b></td>"
                            + "</tr>";
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
                }
            }
            
            
            
            dataCoa = null;
            dataAccount = null;
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>CREDIT</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanCreditList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                            + "</tr>";        
                            
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) -  PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                }
            }
        }
        return htmlOutput;
    }
	
    public static String printJurnalMapping(long oidPeriod, String[] componentSelect) {
        String htmlOutput = "";
        
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        int n = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i < componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT]+"=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT]+"=1";
        }
        
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (perkiraanDebetList != null && perkiraanDebetList.size() > 0){
            htmlOutput += "<div>&nbsp;</div>";
            htmlOutput += "<div>DEBET</div>";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double total = 0;
            double debitTotal = 0;
            double creditTotal = 0;
            double debitSum = 0;
            double creditSum = 0;
            int no = 0;
            
            dataCoa = new double[n][2];
            dataAccount = new String[n][2];
            
            for (int p = 0; p < perkiraanDebetList.size(); p++){
                Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                total = PstComponentCoaMap.getCoA(perkiraan.getOID(), oidPeriod);
                if (perkiraan.getTandaDebetKredit() == 0) {
                    debitTotal = total;
                    creditTotal = 0;
                    debitSum = debitSum + debitTotal;
                } else {
                    debitTotal = 0;
                    creditTotal = total;
                    creditSum = creditSum + creditTotal;
                }
                
                htmlOutput += "<tr>"
                + "<td style=\"background-color: #FFF; width:5%\">"+(no+1)+"</td>"
                + "<td style=\"background-color: #FFF; width:45%\">"+perkiraan.getNama() +"</td>"
                + "<td style=\"background-color: #FFF; width:25%\">"+perkiraan.getNoPerkiraan()+"</td>"
                + "<td style=\"background-color: #FFF; width:25%\">" + (perkiraan.getPostable() == 1 ? Formater.formatNumberMataUang(total, "Rp") : "") + " </td>"
                + "</tr>";
                no++;
                String whereChild = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+"="+perkiraan.getOID();
                Vector listPerkiraanChild = PstPerkiraan.list(0, 0, whereChild, "");
                for (int c = 0; c < listPerkiraanChild.size(); c++){
                    Perkiraan perkiraanChild = (Perkiraan) listPerkiraanChild.get(c);
                    total = PstComponentCoaMap.getCoA(perkiraanChild.getOID(), oidPeriod);
                    if (perkiraan.getTandaDebetKredit() == 0) {
                        debitTotal = total;
                        creditTotal = 0;
                        debitSum = debitSum + debitTotal;
                    } else {
                        debitTotal = 0;
                        creditTotal = total;
                        creditSum = creditSum + creditTotal;
                    }

                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #FFF; width:5%\"></td>"
                    + "<td style=\"background-color: #FFF; width:45%\">"+perkiraanChild.getNama() +"</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">"+perkiraanChild.getNoPerkiraan()+"</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(total, "Rp") + " </td>"
                    + "</tr>";
                }
                
            }
             htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
            
        }
        
        if (perkiraanCreditList != null && perkiraanCreditList.size() > 0){
            htmlOutput += "<div>&nbsp;</div>";
            htmlOutput += "<div>CREDIT</div>";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double total = 0;
            double debitTotal = 0;
            double creditTotal = 0;
            double debitSum = 0;
            double creditSum = 0;
            int no = 0;
            
            dataCoa = new double[n][2];
            dataAccount = new String[n][2];
            
            for (int p = 0; p < perkiraanCreditList.size(); p++){
                Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                total = PstComponentCoaMap.getCoA(perkiraan.getOID(), oidPeriod);
                if (perkiraan.getTandaDebetKredit() == 0) {
                    debitTotal = total;
                    creditTotal = 0;
                    debitSum = debitSum + debitTotal;
                } else {
                    debitTotal = 0;
                    creditTotal = total;
                    creditSum = creditSum + creditTotal;
                }
                
                htmlOutput += "<tr>"
                + "<td style=\"background-color: #FFF; width:5%\">"+(no+1)+"</td>"
                + "<td style=\"background-color: #FFF; width:45%\">"+perkiraan.getNama() +"</td>"
                + "<td style=\"background-color: #FFF; width:25%\">"+perkiraan.getNoPerkiraan()+"</td>"
                + "<td style=\"background-color: #FFF; width:25%\">" + (perkiraan.getPostable() == 1 ? Formater.formatNumberMataUang(total, "Rp") : "") + " </td>"
                + "</tr>";
                no++;
                String whereChild = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+"="+perkiraan.getOID();
                Vector listPerkiraanChild = PstPerkiraan.list(0, 0, whereChild, "");
                for (int c = 0; c < listPerkiraanChild.size(); c++){
                    Perkiraan perkiraanChild = (Perkiraan) listPerkiraanChild.get(c);
                    total = PstComponentCoaMap.getCoA(perkiraanChild.getOID(), oidPeriod);
                    if (perkiraan.getTandaDebetKredit() == 0) {
                        debitTotal = total;
                        creditTotal = 0;
                        debitSum = debitSum + debitTotal;
                    } else {
                        debitTotal = 0;
                        creditTotal = total;
                        creditSum = creditSum + creditTotal;
                    }

                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #FFF; width:5%\"></td>"
                    + "<td style=\"background-color: #FFF; width:45%\">"+perkiraanChild.getNama() +"</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">"+perkiraanChild.getNoPerkiraan()+"</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(total, "Rp") + " </td>"
                    + "</tr>";
                }
                
            }
             htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
            
        }
        
        return htmlOutput;
    }
    
	public static String printJurnalSummary(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        ChangeValue changeValue = new ChangeValue();
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        int n = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
		
		long oidDepartmentTypeParent = 0;
		try {
			oidDepartmentTypeParent = Long.valueOf(PstSystemProperty.getValueByName("DEPARTMENT_TYPE_ID_PARENT"));
		} catch (Exception exc){}
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>DEBET</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanDebetList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

					int noDebet = 0;
                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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

                            /* get department by division id */
                            String whereDept = "COA."+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND COA."+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
							whereDept += " AND DEP."+PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_TYPE_ID]+"="+oidDepartmentTypeParent;
							
							Vector listDept = PstComponentCoaMap.listJoinDepartment(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
									debitTotal += totalDepart;
									htmlOutput += "<tr>"
									+ "<td style=\"background-color: #FFF; width:5%\">"+(no+1)+"</td>"
									+ "<td style=\"background-color: #FFF; width:45%\">"+dataAccount[no][1] +"</td>"
									+ "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
									+ "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
									+ "</tr>";
									
                                    
                                }
                            }
							noDebet++;
                            no++;    
                        }
                    }
					
					String whereDepartment = "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID]+"="+divisionId
							+ " AND hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_TYPE_ID]+"!="+oidDepartmentTypeParent;
					Vector listDepartment = PstDepartment.list(0, 0, whereDepartment, "");
					if (listDepartment != null && listDepartment.size()>0){
						for(int d=0; d<listDepartment.size(); d++){
							Department dept = (Department) listDepartment.get(d);
							double totalDeptOther = 0;
							String noRek = "";
							for (int p = 0; p < perkiraanDebetList.size(); p++) {
								Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
								divisionId = Long.valueOf(divisionSelect[i]);
								boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
								if (check) {

									
									String whereDeptOther = "COA."+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
									whereDeptOther += " AND COA."+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
									whereDeptOther += " AND COA."+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DEPARTMENT_ID]+"="+dept.getOID();
									Vector listDeptOther = PstComponentCoaMap.listJoinDepartment(0, 0, whereDeptOther, "");
									if (listDeptOther != null && listDeptOther.size()>0){
										for(int x=0; x<listDeptOther.size(); x++){
											ComponentCoaMap coaMap = (ComponentCoaMap)listDeptOther.get(x);
											double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, dept.getOID()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, dept.getOID());
											/* print debet depart output */
											totalDeptOther += totalDepart;
											noRek = coaMap.getNoRekening();
										}
									}
								}
							}
							
							
							//debitTotal += totalDeptOther;
							htmlOutput += "<tr>"
									+ "<td style=\"background-color: #FFF; width:5%\">"+(no+1)+"</td>"
									+ "<td style=\"background-color: #FFF; width:45%\">R/K "+changeValue.getDepartmentName(dept.getOID()) +"</td>"
									+ "<td style=\"background-color: #FFF; width:25%\">"+noRek+"</td>"
									+ "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDeptOther, "Rp") + " </td>"
									+ "</tr>";
							no++;
						}
					}
					
					
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
                }
            }
            
            
            
            dataCoa = null;
            dataAccount = null;
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>CREDIT</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanCreditList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                            + "</tr>";        
                            
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                }
            }
        }
        return htmlOutput;
    }
    
    public static String printJurnalVersi1(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        ChangeValue changeValue = new ChangeValue();
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        int n = 0;
        int m = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        String[][] storeDepart = null;
        String[] dataDepart = new String[3];
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>DEBET</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    int mo = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanDebetList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    if (coaMap.getDepartmentId() != 0){
                                        m++;
                                    }
                                }
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                        storeDepart = new String[m][3];
                    }

                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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

                            /* print debet output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(debitTotal, "Rp") + " </td>"
                            + "</tr>";
          
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    storeDepart[mo][0] = ""+coaMap.getDepartmentId();
                                    storeDepart[mo][1] = coaMap.getNoRekening();
                                    storeDepart[mo][2] = ""+totalDepart;
                                    mo++;
                                }
                            }
                        }
                    }
                    
                    if (storeDepart != null && m>0){
                        for (int t=0; t<m; t++){
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(Long.valueOf(storeDepart[t][0])) +"</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">"+storeDepart[t][1]+"</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(Double.valueOf(storeDepart[t][2]), "Rp") + " </td>"
                            + "</tr>";
                        }
                    }
                    
                    
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
                    storeDepart = null;
                    dataDepart = new String[3];
                }
            }
            
            
            
            dataCoa = null;
            dataAccount = null;
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>CREDIT</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanCreditList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                            + "</tr>";        
                            
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                }
            }
        }
        return htmlOutput;
    }
    
    /*
     * Document : function print jurnal untuk kantor pusat BPD
     * author : Hendra Putu
     * Date : 2017-01-02
     */
    public static String printJurnalForPusat(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        double[] dataCoa = null;
        String[][] dataAccount = null;
        
        int n = 0;
        int no = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
}
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                dataCoa = new double[100];
                dataAccount = new String[100][2];
                htmlOutput += "<div>&nbsp;</div>";
                htmlOutput += "<div>DEBET</div>";
                htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                for (int i = 0; i < divisionSelect.length; i++) {
                    double total = 0;
                    no = 0;

                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            dataCoa[no] = dataCoa[no] + total;
                            no++;    
                        }
                    }                   
                    
                }
                double debitTotal = 0;
                for (int p = 0; p < no; p++) {
                    /* print debet output */
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #FFF; width:5%\">" + (p+1) + "</td>"
                    + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[p][1] + "</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[p][0] + "</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(dataCoa[p], "Rp") + " </td>"
                    + "</tr>";
                    debitTotal = debitTotal + dataCoa[p];
                }
                htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitTotal, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                htmlOutput += "</table>";
            }
            
            dataCoa = new double[100];
            dataAccount = new String[100][2];
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                htmlOutput += "<div>&nbsp;</div>";
                htmlOutput += "<div>CREDIT</div>";
                htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                for (int i = 0; i < divisionSelect.length; i++) {
                    double total = 0;
                    no = 0;

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            dataCoa[no] = dataCoa[no] + total;
                            no++;
                        }
                    }
                }
                double creditTotal = 0;
                for (int p = 0; p < no; p++) {
                    /* print credit output */
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #FFF; width:5%\">" + (p+1) + "</td>"
                    + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[p][1] + "</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[p][0] + "</td>"
                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(dataCoa[p], "Rp") + " </td>"
                    + "</tr>";  
                    creditTotal = creditTotal + dataCoa[p];
                }
                
                htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditTotal, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                htmlOutput += "</table>";
            }
        }
        return htmlOutput;
    }
	
	public static String printJurnalBeritaAcara(long oidPeriod, String[] divisionSelect
			, String[] componentSelect, long employeeId, String component, long leaveId
			, long empDocId, Hashtable hlistEmpDocField, boolean view) {
        String htmlOutput = "";
        double[] dataCoa = null;
        String[][] dataAccount = null;
        
		Employee emp = new Employee();
		try {
			emp = PstEmployee.fetchExc(employeeId);
		} catch (Exception exc){}
		
		PayPeriod payPeriod = new PayPeriod();
		try {
			payPeriod = PstPayPeriod.fetchExc(oidPeriod);
		} catch (Exception exc){}
		
		LeaveApplication leaveApplication = new LeaveApplication();
		try {
			leaveApplication = PstLeaveApplication.fetchExc(leaveId);
		} catch (Exception exc){}
		
		String noRek = "";
		if (leaveApplication.getTypeLeaveCategory() == 3){
			noRek = PstSystemProperty.getValueByNameWithStringNull("NO_REK_CUTI_TAHUNAN");
		} else if (leaveApplication.getTypeLeaveCategory() == 4){
			noRek = PstSystemProperty.getValueByNameWithStringNull("NO_REK_CUTI_BESAR");
		}
		
        int n = 0;
        int no = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
		
        double compValue = PstPaySlip.getCompValue(employeeId, payPeriod, component);
		htmlOutput += "<div>&nbsp;</div>";
		htmlOutput += "<div>DEBET</div>";
		htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
			/* print debet output */
		if (view){
			htmlOutput += "<tr>"
				+ "<td style=\"background-color: #FFF; width:5%\">1</td>"
				+ "<td style=\"background-color: #FFF; width:25%\">"
					+ (hlistEmpDocField.get("DEBETNOREKBACUTI") != null ? (String) hlistEmpDocField.get("DEBETNOREKBACUTI") : "-")
				+ "</td>"
				+ "<td style=\"background-color: #FFF; width:45%\">"
					+ (hlistEmpDocField.get("DEBETCOABACUTI") != null ? (String) hlistEmpDocField.get("DEBETCOABACUTI") : "-")
				+ "</td>"
				+ "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + " </td>"
				+ "</tr>";
		} else {
			htmlOutput += "<tr>"
				+ "<td style=\"background-color: #FFF; width:5%\">1</td>"
				+ "<td style=\"background-color: #FFF; width:25%\">"
					+ "<a href=\"javascript:cmdAddText('"+empDocId+"','DEBETNOREKBACUTI','FIELD','ALLFIELD','TEXT')\">"
						+ (hlistEmpDocField.get("DEBETNOREKBACUTI") != null ? (String) hlistEmpDocField.get("DEBETNOREKBACUTI") : "NEW TEXT")
					+ "</a>"
				+ "</td>"
				+ "<td style=\"background-color: #FFF; width:45%\">"
					+ "<a href=\"javascript:cmdAddText('"+empDocId+"','DEBETCOABACUTI','FIELD','ALLFIELD','TEXT')\">"
						+ (hlistEmpDocField.get("DEBETCOABACUTI") != null ? (String) hlistEmpDocField.get("DEBETCOABACUTI") : "NEW TEXT")
					+ "</a>"
				+ "</td>"
				+ "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + " </td>"
				+ "</tr>";
		}
		
		htmlOutput += "<tr>"
			+ "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
			+ "<td style=\"background-color: #EEE;\">"
			+ "<strong>" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + "</strong>"
			+ "</td>"
			+ "</tr>";
		htmlOutput += "</table>";

		
		htmlOutput += "<div>&nbsp;</div>";
		htmlOutput += "<div>CREDIT</div>";
		htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
		double creditTotal = 0;
			/* print credit output */
			htmlOutput += "<tr>"
			+ "<td style=\"background-color: #FFF; width:5%\">1</td>"
			+ "<td style=\"background-color: #FFF; width:25%\">" + emp.getNoRekening() + "</td>"
			+ "<td style=\"background-color: #FFF; width:45%\">Tabungan a/n " + emp.getFullName() + "</td>"
			+ "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + " </td>"
			+ "</tr>";  


		htmlOutput += "<tr>"
			+ "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
			+ "<td style=\"background-color: #EEE;\">"
			+ "<strong>" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + "</strong>"
			+ "</td>"
			+ "</tr>";
		htmlOutput += "</table>";
            
        return htmlOutput;
    }
        
    public static String printJurnalBeritaAcaraCuti(long empDocId, Hashtable hlistEmpDocField, boolean view) {
        String htmlOutput = "";

        Vector vEmpDocList = PstEmpDocList.list(0, 0, PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID]+"="+empDocId, "");
		
        htmlOutput += "<div>&nbsp;</div>";
        htmlOutput += "<div>DEBET</div>";
        htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                /* print debet output */
        if (view){
                htmlOutput += "<tr>"
                        + "<td style=\"background-color: #FFF; width:5%\">1</td>"
                        + "<td style=\"background-color: #FFF; width:25%\">"
                                + (hlistEmpDocField.get("DEBETNOREKBACUTI") != null ? (String) hlistEmpDocField.get("DEBETNOREKBACUTI") : "-")
                        + "</td>"
                        + "<td style=\"background-color: #FFF; width:45%\">"
                                + (hlistEmpDocField.get("DEBETCOABACUTI") != null ? (String) hlistEmpDocField.get("DEBETCOABACUTI") : "-")
                        + "</td>"
                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + " </td>"
                        + "</tr>";
        } else {
                htmlOutput += "<tr>"
                        + "<td style=\"background-color: #FFF; width:5%\">1</td>"
                        + "<td style=\"background-color: #FFF; width:25%\">"
                                + "<a href=\"javascript:cmdAddText('"+empDocId+"','DEBETNOREKBACUTI','FIELD','ALLFIELD','TEXT')\">"
                                        + (hlistEmpDocField.get("DEBETNOREKBACUTI") != null ? (String) hlistEmpDocField.get("DEBETNOREKBACUTI") : "NEW TEXT")
                                + "</a>"
                        + "</td>"
                        + "<td style=\"background-color: #FFF; width:45%\">"
                                + "<a href=\"javascript:cmdAddText('"+empDocId+"','DEBETCOABACUTI','FIELD','ALLFIELD','TEXT')\">"
                                        + (hlistEmpDocField.get("DEBETCOABACUTI") != null ? (String) hlistEmpDocField.get("DEBETCOABACUTI") : "NEW TEXT")
                                + "</a>"
                        + "</td>"
                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + " </td>"
                        + "</tr>";
        }

        htmlOutput += "<tr>"
                + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                + "<td style=\"background-color: #EEE;\">"
                + "<strong>" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + "</strong>"
                + "</td>"
                + "</tr>";
        htmlOutput += "</table>";


        htmlOutput += "<div>&nbsp;</div>";
        htmlOutput += "<div>CREDIT</div>";
        htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                if (vEmpDocList.size()>0){
                    for (int i=0; i < vEmpDocList.size();i++){
                        EmpDocList empDocList = (EmpDocList) vEmpDocList.get(i);
                        try {
                            Employee emp = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">"+(i+1)+"</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + emp.getNoRekening() + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">Tabungan a/n " + emp.getFullName() + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValueByEmployee(empDocId, emp.getOID()), "Rp") + " </td>"
                            + "</tr>";  
                        } catch (Exception exc){}
                    }
                }

        htmlOutput += "<tr>"
                + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                + "<td style=\"background-color: #EEE;\">"
                + "<strong>" + Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(empDocId), "Rp") + "</strong>"
                + "</td>"
                + "</tr>";
        htmlOutput += "</table>";
            
        return htmlOutput;
    }
    
        /*
     * Document : function print jurnal untuk yang memiliki banyak capem
     * author : Gunadi Wirawan
     * Date : 2017-11-21
     */
    public static String printJurnalV3(long oidPeriod, String[] divisionSelect, String[] componentSelect) {
        String htmlOutput = "";
        ChangeValue changeValue = new ChangeValue();
        double[][] dataCoa = null;
        String[][] dataAccount = null;
        double[] totDeptComp = null;
        HashMap mapDepartment = new HashMap<String, Double>();
        int n = 0;
        long divisionId = 0;
        String perkiraanIds = "";
        String whereDebet = "";
        String whereCredit = "";
        if (componentSelect != null && componentSelect.length > 0){
            for (int i=0; i<componentSelect.length; i++){
                perkiraanIds = perkiraanIds + componentSelect[i]+",";
            }
            perkiraanIds = perkiraanIds.substring(0, (perkiraanIds.length()-1));
            whereDebet = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereDebet += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=0";
            whereCredit = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN]+" IN("+perkiraanIds+")";
            whereCredit += " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT] + "=1";
        }
        
        Vector perkiraanDebetList = PstPerkiraan.list(0, 0, whereDebet, "");
        Vector perkiraanCreditList = PstPerkiraan.list(0, 0, whereCredit, "");
        if (divisionSelect != null && divisionSelect.length > 0) {
            if (perkiraanDebetList != null && perkiraanDebetList.size() > 0) {
                
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>DEBET</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanDebetList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }
                    
                    String departmentType = PstSystemProperty.getValueByName("KANTOR_CABANG_DEPARTMENT_TYPE");
                    
                    /* cek yang kantor cabang */
                    String[] department = PstComponentCoaMap.getDepartmentbyDeptType(divisionId, departmentType).split(",");
                    for (int p = 0; p < perkiraanDebetList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                        if (department != null){
                            if (department.length>0){
                                for (int d=0; d < department.length; d++){
                                    total = total + PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, Long.valueOf(department[d])) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, Long.valueOf(department[d]));
                                }
                                dataAccount[no][0] = perkiraan.getNoPerkiraan();
                                dataAccount[no][1] = perkiraan.getNama();
                                if (perkiraan.getTandaDebetKredit() == 0) {
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
                                /* print debet output */
                                htmlOutput += "<tr>"
                                + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                                + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                                + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                                + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(debitTotal, "Rp") + " </td>"
                                + "</tr>";

                                no++;
                                total = 0;
                                
                                for (int d=0; d < department.length; d++){
                                    String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DEPARTMENT_ID]+"="+department[d];
                                    whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                                    whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                                    Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                                    if (listDept != null && listDept.size()>0){
                                        ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(0);
                                        double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                        htmlOutput += "<tr>"
                                        + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                        + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                        + "</tr>";
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    String whereDeptType = PstDepartmentType.fieldNames[PstDepartmentType.FLD_DEPARTMENT_TYPE_ID] 
                                           + " NOT IN ("+departmentType+")";
                    Vector listDeptType = PstDepartmentType.list(0, 0, whereDeptType, "");
                    String inNotInDeptType = "";
                    if (listDeptType.size() > 0){
                        for (int dept=0; dept < listDeptType.size(); dept++){
                            DepartmentType deptType = (DepartmentType) listDeptType.get(dept);
                            inNotInDeptType = inNotInDeptType + "," + deptType.getOID();
                        }
                        if (!inNotInDeptType.equals("")){
                            inNotInDeptType = inNotInDeptType.substring(1);
                        }
                    }
                    String[] capem = PstComponentCoaMap.getDepartmentbyDeptType(divisionId, inNotInDeptType).split(",");
                    if (capem != null){
                        if (capem.length > 0){
                            for (int cp=0; cp<capem.length;cp++){
                                for (int p = 0; p < perkiraanDebetList.size(); p++) {
                                    Perkiraan perkiraan = (Perkiraan) perkiraanDebetList.get(p);
                                    total = total + PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, Long.valueOf(capem[cp])) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, Long.valueOf(capem[cp]));
                                }
                                String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DEPARTMENT_ID]+"="+capem[cp];
                                whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                                whereDept += " AND NO_REKENING IS NOT NULL";
                                Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                                if (listDept != null && listDept.size()>0){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(0);
                                    String noRek =  "-";
                                    try {
                                        noRek = coaMap.getNoRekening().replaceAll("\\(.*?\\) ?", "");
                                    } catch (Exception exc){
                                        
                                    }
                                    htmlOutput += "<tr>"
                                        + "<td style=\"background-color: #FFF; width:5%\">"+ (no+1) +"</td>"
                                        + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">"+noRek+"</td>"
                                        + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(total, "Rp") + " </td>"
                                        + "</tr>";
                                    no++;
                                    debitSum = debitSum + total;
                                    total = 0;
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(debitSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                    dataCoa = null;
                    dataAccount = null;
                }
            }
            
            
            
            dataCoa = null;
            dataAccount = null;
        
            if (perkiraanCreditList != null && perkiraanCreditList.size() > 0) {
                for (int i = 0; i < divisionSelect.length; i++) {
                    htmlOutput += "<div>&nbsp;</div>";
                    htmlOutput += "<div>CREDIT</div>";
                    htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                    double total = 0;
                    double debitTotal = 0;
                    double creditTotal = 0;
                    double debitSum = 0;
                    double creditSum = 0;
                    int no = 0;
                    /* inisialisasi arr 2 dimenesi */
                    if (dataCoa == null) {
                        for (int p = 0; p < perkiraanCreditList.size(); p++) {
                            Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                            divisionId = Long.valueOf(divisionSelect[i]);
                            boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                            if (check) {
                                n++;
                            }
                        }
                        dataCoa = new double[n][2];
                        dataAccount = new String[n][2];
                    }

                    for (int p = 0; p < perkiraanCreditList.size(); p++) {
                        Perkiraan perkiraan = (Perkiraan) perkiraanCreditList.get(p);
                        divisionId = Long.valueOf(divisionSelect[i]);
                        boolean check = PstComponentCoaMap.isCoaMapping(perkiraan.getOID(), divisionId);
                        if (check) {
                            total = PstComponentCoaMap.getValueCoa(perkiraan.getOID(), oidPeriod, divisionId) - PstComponentCoaMap.getValueCoaPengurang(perkiraan.getOID(), oidPeriod, divisionId);
                            dataAccount[no][0] = perkiraan.getNoPerkiraan();
                            dataAccount[no][1] = perkiraan.getNama();
                            if (perkiraan.getTandaDebetKredit() == 0) {
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
                            /* print credit output */
                            htmlOutput += "<tr>"
                            + "<td style=\"background-color: #FFF; width:5%\">" + (no+1) + "</td>"
                            + "<td style=\"background-color: #FFF; width:45%\">" + dataAccount[no][1] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + dataAccount[no][0] + "</td>"
                            + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(creditTotal, "Rp") + " </td>"
                            + "</tr>";        
                            
                            no++;
                            
                            /* get department by division id */
                            String whereDept = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_DIVISION_ID]+"="+divisionId;
                            whereDept += " AND "+PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraan.getOID();
                            Vector listDept = PstComponentCoaMap.list(0, 0, whereDept, "");
                            if (listDept != null && listDept.size()>0){
                                for(int d=0; d<listDept.size(); d++){
                                    ComponentCoaMap coaMap = (ComponentCoaMap)listDept.get(d);
                                    double totalDepart = PstComponentCoaMap.getValueCoaDepartment(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId()) - PstComponentCoaMap.getValueCoaDepartmentPengurang(perkiraan.getOID(), oidPeriod, coaMap.getDepartmentId());
                                    /* print debet depart output */
                                    htmlOutput += "<tr>"
                                    + "<td style=\"background-color: #FFF; width:5%\">&nbsp;</td>"
                                    + "<td style=\"background-color: #FFF; width:45%\">"+changeValue.getDepartmentName(coaMap.getDepartmentId()) +"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">"+coaMap.getNoRekening()+"</td>"
                                    + "<td style=\"background-color: #FFF; width:25%\">" + Formater.formatNumberMataUang(totalDepart, "Rp") + " </td>"
                                    + "</tr>";
                                }
                            }
                        }
                    }
                    htmlOutput += "<tr>"
                    + "<td style=\"background-color: #EEE;\" colspan=\"3\"><strong>Total</strong></td>"
                    + "<td style=\"background-color: #EEE;\">"
                    + "<strong>" + Formater.formatNumberMataUang(creditSum, "Rp") + "</strong>"
                    + "</td>"
                    + "</tr>";
                    htmlOutput += "</table>";
                }
            }
        }
        return htmlOutput;
    }
	
	public static String drawLampiranBAUangMakan(long periodId, long employeeId, long leaveId, long oidDoc, boolean view){
		PayPeriod prevPeriod = PstPayPeriod.getPreviousPayPeriod(periodId);
		//String compCode = PstSystemProperty.getValueByName("LEAVE_ALLOWANCE_COMP_CODE");
		
		PayPeriod payPeriod = new PayPeriod();
		try {
			payPeriod = PstPayPeriod.fetchExc(periodId);
		} catch (Exception exc){}
		
		Employee emp = new Employee();
		try {
			emp = PstEmployee.fetchExc(employeeId);
		} catch (Exception exc){}
		
		GradeLevel gradeLevel = new GradeLevel();
		try {
			gradeLevel = PstGradeLevel.fetchExc(emp.getGradeLevelId());
		} catch (Exception exc){}
		
		LeaveApplication leaveApplication = new LeaveApplication();
		try {
			leaveApplication = PstLeaveApplication.fetchExc(leaveId);
		} catch (Exception exc){}
		
		float qty = 0;
		Date toDate = new Date();
		if (leaveApplication.getTypeLeaveCategory() == 3){
			String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveId;
			Vector listAl = PstAlStockTaken.list(0, 0, where, "");
			if (listAl.size()>0){
				AlStockTaken alStockTaken = (AlStockTaken) listAl.get(0);
				qty = alStockTaken.getTakenQty();
				toDate = alStockTaken.getTakenDate();
			}
		} else if (leaveApplication.getTypeLeaveCategory() == 4){
			String where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveId;
			Vector listLl = PstLlStockTaken.list(0, 0, where, "");
			if (listLl.size()>0){
				LlStockTaken llStockTaken = (LlStockTaken) listLl.get(0);
				qty = llStockTaken.getTakenQty();
				toDate = llStockTaken.getTakenDate();
			}
		}
		
		String strDateFrom = (payPeriod.getStartDate().getYear()+1900)+"-01-01";
		Date dtFrom = new Date();
		try {
			dtFrom = new SimpleDateFormat("yyyy-MM-dd").parse(strDateFrom);
		} catch (Exception exc){}
		String inS = PstSystemProperty.getValueByNameWithStringNull("IN_OID_S_BA_CUTI");
		int countS = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employeeId, "", 0, inS);
                
		String inI = PstSystemProperty.getValueByNameWithStringNull("IN_OID_I_BA_CUTI");
		int countI = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employeeId, "", 0, inI);
		int countA = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employeeId, "", 2, "");
		
		String whereExpense = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+employeeId
				+ " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
				+ " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='PREVIOUS_BENEFIT'";
		Vector listExpense = PstEmpDocListExpense.list(0, 0, whereExpense, "");
		double compValue = 0.0;
		int pengali = 0;
		if (listExpense.size()>0){
			for (int i=0; i < listExpense.size(); i++){
				EmpDocListExpense empDocListExpense = (EmpDocListExpense) listExpense.get(i);
				pengali = empDocListExpense.getDayLength();
                                    try {
					PayComponent payComponent = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
					compValue = PstPaySlip.getCompValue(employeeId, prevPeriod, payComponent.getCompCode());
				} catch (Exception exc){}
			}
		}
		String htmlOutput = "<table border='1' cellpadding='0' cellspacing='0' style='width:100%'>"
								+ "<tbody>"
									+ "<tr>"
										+ "<td colspan='1' rowspan='2' style='text-align:center; width:3%'>No</td>"
										+ "<td colspan='1' rowspan='2' style='height:50px; text-align:center'>Nama</td>"
										+ "<td colspan='1' rowspan='2' style='text-align:center'>Jabatan</td>"
										+ "<td colspan='1' rowspan='2' style='text-align: center; width: 8%;'>Grade</td>"
										+ "<td colspan='3' rowspan='1' style='height:25px; text-align:center'>Jumlah Absensi</td>"
										+ "<td colspan='1' rowspan='2' style='text-align:center; width:10%'>Lamanya Cuti</td>"
										+ "<td colspan='1' rowspan='2' style='text-align:center; width:15%'>Jumlah<br>Gaji Periode "
											+prevPeriod.getPeriod()+
											"<br>"
											+ (view ? "" : "<a href=\"javascript:cmdAddComp('PREVIOUS_BENEFIT','" + oidDoc + "','" + employeeId + "' )\">add component</a></br>")
										+ "</td>"
										+ "<td colspan='1' rowspan='2' style='text-align:center; width:15%'>Jumlah Uang Cuti Diterima<br>"
											+ pengali + " x G.bl."+prevPeriod.getPeriod()
										+ "</td>"
									+ "</tr>"
									+ "<tr>"
										+ "<td style='text-align:center; width:3%'>S</td>"
										+ "<td style='text-align:center; width:3%'>I</td>"
										+ "<td style='text-align:center; width:3%'>A</td>"
									+ "</tr>"
									+ "<tr>"
										+ "<td style=\"text-align: center; vertical-align: top;\">1</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+emp.getFullName()+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+PstEmployee.getPositionName(emp.getPositionId())+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+gradeLevel.getCodeLevel()+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+countS+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+countI+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+countA+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+qty+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+Formater.formatNumberMataUang(compValue, "Rp")+"</td>"
										+ "<td style=\"text-align: center; vertical-align: top;\">"+Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValue(oidDoc), "Rp")+"</td>"
									+ "</tr>"
								+ "</tbody>"
							+ "</table>"
										+ ""
										+ "";
		
		return htmlOutput;
	}
	
	public static String drawKeteranganCuti(long employeeId, Hashtable hlistEmpDocField, long empDocId,
			long leaveApplicationId){
		
 		AlStockManagement alStockManagement = new AlStockManagement();
		LLStockManagement llStockManagement = new LLStockManagement();
		
		Vector alStockTaken = new Vector();
		Vector llStockTaken = new Vector();
		Vector alStockQty = new Vector();
		Vector llStockQty = new Vector();
		String whereEmployee = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "=" + employeeId;
		alStockQty = PstAlStockManagement.list(0, 0, whereEmployee + " AND " + PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS] + " = 0 ", "");
		llStockQty = PstLLStockManagement.list(0, 0, whereEmployee + " AND " + PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS] + " = 0 ", "");
		
		String whereAl = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplicationId;
		String whereLl = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplicationId;
		alStockTaken = PstAlStockTaken.list(0, 0, whereAl, null);
		llStockTaken = PstLlStockTaken.list(0, 0, whereLl, null);
		
                AlStockTaken alStock = new AlStockTaken();
                LlStockTaken llStock = new LlStockTaken();
                
		int leaveQty = 0;
                Date dtCuti = new Date();
		if (alStockTaken.size() > 0){
			for (int i=0; i < alStockTaken.size(); i++){
				alStock = (AlStockTaken) alStockTaken.get(i);
				leaveQty = convertInteger(alStock.getTakenQty());
                                dtCuti = alStock.getTakenDate();
			}
		} else if (llStockTaken.size() > 0){
			for (int i=0; i < llStockTaken.size(); i++){
				llStock = (LlStockTaken) llStockTaken.get(i);
				leaveQty = convertInteger(llStock.getTakenQty());
                                dtCuti = llStock.getTakenDate();
			}
		}

		for (int i=0; i < alStockQty.size(); i++){
			AlStockManagement al = (AlStockManagement) alStockQty.get(i); 
			try {
				alStockManagement = PstAlStockManagement.fetchExc(al.getOID());
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
		}
		for (int i=0; i < llStockQty.size(); i++){
			LLStockManagement ll = (LLStockManagement) llStockQty.get(i); 
			try {
				llStockManagement = PstLLStockManagement.fetchExc(ll.getOID());
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
		}
		
		Date dtNow = new Date();
		Calendar dt = Calendar.getInstance();
		dt.setTime(dtCuti);
		
		int currYear = dt.getWeekYear();
		int prevYear = dt.getWeekYear()-1;
		
		int prevQty = 0;
		int qty = 0;
		int usedQty = 0;
		if (alStockManagement.getAlQty() > 0){
			prevQty = convertInteger(alStockManagement.getPrevBalance());
			qty = convertInteger(alStockManagement.getEntitled());
			usedQty = convertInteger(PstAlStockTaken.getPreviousLeaveQty(alStockManagement.getOID(), alStock.getTakenDate()));
		} else {
			prevQty = convertInteger(llStockManagement.getPrevBalance());
			qty = convertInteger(llStockManagement.getEntitled());
			usedQty = convertInteger(PstLlStockTaken.getPreviousLeaveQty(llStockManagement.getOID(), llStock.getTakenDate()));
		}
		
		//ini klo gak ada di hashtable langsung insert stok sekarang
		if (hlistEmpDocField.get("TAHUNSEBELUM") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("TAHUNSEBELUM");
			empDocField.setObject_type(0);
			empDocField.setValue(""+prevYear);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("TAHUNSEBELUM") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("TAHUN");
			empDocField.setObject_type(0);
			empDocField.setValue(""+currYear);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("CUTISEBELUMNYA") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("CUTISEBELUMNYA");
			empDocField.setObject_type(0);
			empDocField.setValue(""+prevQty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("HAKCUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("HAKCUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+qty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("CUTIDIGUNAKAN") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("CUTIDIGUNAKAN");
			empDocField.setObject_type(0);
			empDocField.setValue(""+(usedQty));
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("LAMACUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("LAMACUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+leaveQty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("SISACUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("SISACUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+(qty + prevQty - usedQty - leaveQty));
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		
		String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + empDocId + "\"";
		hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
		
		String htmlOutput = "<table border='0' cellpadding='0' cellspacing='0' style='width:100%'>"
					+ "<tbody>"
						+ "<tr>"
							+ "<td colspan='5' rowspan='1' style='text-align:left;'>Keterangan :</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Sisa Cuti tahun sebelumnya</td>"
							+ "<td style='text-align:right; width:10%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','TAHUNSEBELUM','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("TAHUNSEBELUM") != null ? (String) hlistEmpDocField.get("TAHUNSEBELUM") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','CUTISEBELUMNYA','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("CUTISEBELUMNYA") != null ? (String) hlistEmpDocField.get("CUTISEBELUMNYA") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Hak Cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','TAHUN','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','HAKCUTI','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("HAKCUTI") != null ? (String) hlistEmpDocField.get("HAKCUTI") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Cuti yang telah dipergunakan</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','TAHUN','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','CUTIDIGUNAKAN','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("CUTIDIGUNAKAN") != null ? (String) hlistEmpDocField.get("CUTIDIGUNAKAN") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>lamanya cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','TAHUN','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','LAMACUTI','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("LAMACUTI") != null ? (String) hlistEmpDocField.get("LAMACUTI") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Sisa cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','TAHUN','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ "<a href=\"javascript:cmdAddText('"+empDocId+"','SISACUTI','FIELD','ALLFIELD','TEXT')\">"
									+ (hlistEmpDocField.get("SISACUTI") != null ? (String) hlistEmpDocField.get("SISACUTI") : "NEW TEXT")
								+ "</a>"
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
					+ "</tbody>"
				+ "</table>";
		
		return htmlOutput;
	}
	
	public static String drawKeteranganCutiView(long employeeId, Hashtable hlistEmpDocField, long empDocId,
			long leaveApplicationId){
		
		AlStockManagement alStockManagement = new AlStockManagement();
		LLStockManagement llStockManagement = new LLStockManagement();
		
		Vector alStockTaken = new Vector();
		Vector llStockTaken = new Vector();
		Vector alStockQty = new Vector();
		Vector llStockQty = new Vector();
		String whereEmployee = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "=" + employeeId;
		alStockQty = PstAlStockManagement.list(0, 0, whereEmployee + " AND " + PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS] + " = 0 ", "");
		llStockQty = PstLLStockManagement.list(0, 0, whereEmployee + " AND " + PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS] + " = 0 ", "");
		
		String whereAl = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplicationId;
		String whereLl = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID] + "=" + leaveApplicationId;
		alStockTaken = PstAlStockTaken.list(0, 0, whereAl, null);
		llStockTaken = PstLlStockTaken.list(0, 0, whereLl, null);
		
		int leaveQty = 0;
		if (alStockTaken.size() > 0){
			for (int i=0; i < alStockTaken.size(); i++){
				AlStockTaken alStock = (AlStockTaken) alStockTaken.get(i);
				leaveQty = convertInteger(alStock.getTakenQty());
			}
		} else if (llStockTaken.size() > 0){
			for (int i=0; i < llStockTaken.size(); i++){
				LlStockTaken llStock = (LlStockTaken) llStockTaken.get(i);
				leaveQty = convertInteger(llStock.getTakenQty());
			}
		}

		for (int i=0; i < alStockQty.size(); i++){
			AlStockManagement al = (AlStockManagement) alStockQty.get(i); 
			try {
				alStockManagement = PstAlStockManagement.fetchExc(al.getOID());
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
		}
		for (int i=0; i < llStockQty.size(); i++){
			LLStockManagement ll = (LLStockManagement) llStockQty.get(i); 
			try {
				llStockManagement = PstLLStockManagement.fetchExc(ll.getOID());
			} catch (Exception e) {
				System.out.println("EXCEPTION " + e.toString());
			}
		}
		
		Date dtNow = new Date();
		Calendar dt = Calendar.getInstance();
		dt.setTime(dtNow);
		
		int currYear = dt.getWeekYear();
		int prevYear = dt.getWeekYear()-1;
		
		int prevQty = 0;
		int qty = 0;
		int usedQty = 0;
		if (alStockManagement.getAlQty() > 0){
			prevQty = convertInteger(alStockManagement.getPrevBalance());
			qty = convertInteger(alStockManagement.getEntitled());
			usedQty = convertInteger(alStockManagement.getQtyUsed());
		} else {
			prevQty = convertInteger(llStockManagement.getPrevBalance());
			qty = convertInteger(llStockManagement.getEntitled());
			usedQty = convertInteger(llStockManagement.getQtyUsed());
		}
		
		//ini klo gak ada di hashtable langsung insert stok sekarang
		if (hlistEmpDocField.get("TAHUNSEBELUM") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("TAHUNSEBELUM");
			empDocField.setObject_type(0);
			empDocField.setValue(""+prevYear);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("TAHUNSEBELUM") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("TAHUN");
			empDocField.setObject_type(0);
			empDocField.setValue(""+currYear);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("CUTISEBELUMNYA") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("CUTISEBELUMNYA");
			empDocField.setObject_type(0);
			empDocField.setValue(""+prevQty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("HAKCUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("HAKCUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+qty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("CUTIDIGUNAKAN") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("CUTIDIGUNAKAN");
			empDocField.setObject_type(0);
			empDocField.setValue(""+(usedQty-leaveQty));
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("LAMACUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("LAMACUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+leaveQty);
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		if (hlistEmpDocField.get("SISACUTI") == null){
			EmpDocField empDocField = new EmpDocField();
			empDocField.setClassName("ALLFIELD");
			empDocField.setEmp_doc_id(empDocId);
			empDocField.setObject_name("SISACUTI");
			empDocField.setObject_type(0);
			empDocField.setValue(""+(qty + prevQty - usedQty));
			try {
				PstEmpDocField.insertExc(empDocField);
			} catch (Exception exc){}
		}
		
		String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + empDocId + "\"";
		hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
		
		String htmlOutput = "<table border='0' cellpadding='0' cellspacing='0' style='width:100%'>"
					+ "<tbody>"
						+ "<tr>"
							+ "<td colspan='5' rowspan='1' style='text-align:left;'>Keterangan :</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Sisa Cuti tahun sebelumnya</td>"
							+ "<td style='text-align:right; width:10%;'>"
								+ (hlistEmpDocField.get("TAHUNSEBELUM") != null ? (String) hlistEmpDocField.get("TAHUNSEBELUM") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ (hlistEmpDocField.get("CUTISEBELUMNYA") != null ? (String) hlistEmpDocField.get("CUTISEBELUMNYA") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Hak Cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ (hlistEmpDocField.get("HAKCUTI") != null ? (String) hlistEmpDocField.get("HAKCUTI") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Cuti yang telah dipergunakan</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ (hlistEmpDocField.get("CUTIDIGUNAKAN") != null ? (String) hlistEmpDocField.get("CUTIDIGUNAKAN") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>lamanya cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ (hlistEmpDocField.get("LAMACUTI") != null ? (String) hlistEmpDocField.get("LAMACUTI") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
						+ "<tr>"
							+ "<td style='text-align:left; width:75%;'>Sisa cuti</td>"	
							+ "<td style='text-align:right; width:10%;'>"
								+ (hlistEmpDocField.get("TAHUN") != null ? (String) hlistEmpDocField.get("TAHUN") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>:</td>"
							+ "<td style='text-align:center; width:5%;'>"
								+ (hlistEmpDocField.get("SISACUTI") != null ? (String) hlistEmpDocField.get("SISACUTI") : "NEW TEXT")
							+ "</td>"
							+ "<td style='text-align:center; width:5%;'>hari</td>"
						+ "</tr>"
					+ "</tbody>"
				+ "</table>";
		
		return htmlOutput;
	}
        
        public static String drawLampiranBAUangMakanMulti(long oidDoc, boolean view, String objectName){
                Vector vEmpDocList = PstEmpDocList.list(0, 0, PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID]+"="+oidDoc, "");
                
                EmpDoc empDoc = new EmpDoc();
                try {
                    empDoc = PstEmpDoc.fetchExc(oidDoc);
                } catch (Exception exc){}
                
                String whereExpenseAll = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                                + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='PREVIOUS_BENEFIT'";
                Vector listExpenseAll = PstEmpDocListExpense.list(0, 0, whereExpenseAll, "");
                int pengali = 0;
                String periode = "-";
                PayPeriod payPeriod = new PayPeriod();
                if (listExpenseAll.size()>0){
                    EmpDocListExpense expns = (EmpDocListExpense) listExpenseAll.get(0);
                    pengali = expns.getDayLength();
                    try {
                        payPeriod = PstPayPeriod.fetchExc(expns.getPeriodeId());
                        periode = payPeriod.getPeriod();
                    } catch (Exception exc){}
                }
                
                String inEmployee = "";
                String htmlEmp = "";
                if (vEmpDocList.size()>0){
                    for (int i=0; i < vEmpDocList.size();i++){
                        EmpDocList empDocList = (EmpDocList) vEmpDocList.get(i);
                        try {

                            Employee emp = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            
                            if (inEmployee.length()>0){
                                inEmployee += ",";
                            }
                            
                            inEmployee += ""+emp.getOID();
                            
                            GradeLevel gradeLevel = new GradeLevel();
                            try {
                                    gradeLevel = PstGradeLevel.fetchExc(emp.getGradeLevelId());
                            } catch (Exception exc){}
                            String year = Formater.formatDate(empDoc.getDate_of_issue(), "yyyy");
                            Employee employee = PstEmployee.fetchExc(empDocList.getEmployee_id());
                            String whereLeave = "(DATE_FORMAT(tk.`TAKEN_DATE`,'%Y') = '"+year+"' OR DATE_FORMAT(tk.`TAKEN_FINNISH_DATE`,\"%Y\") = '"+year+"' "
                                    + "OR DATE_FORMAT(ll.`TAKEN_DATE`,\"%Y\") = '"+year+"' OR DATE_FORMAT(ll.`TAKEN_FINNISH_DATE`,\"%Y\") = '"+year+"') "
                                    + " AND emp.EMPLOYEE_ID = "+employee.getOID()
                                    + " AND lv.TYPE_LEAVE_CATEGORY IN (3,4)";
                            Vector listLeave = PstLeaveApplication.listJoin(0, 0, whereLeave, "");
                            float qty = 0;
                            Date toDate = new Date();
                            LeaveApplication leaveApplication = new LeaveApplication();
                            if (listLeave.size()>0){
                                leaveApplication = (LeaveApplication) listLeave.get(0);
                                if (leaveApplication.getTypeLeaveCategory() == 3){
                                        String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveApplication.getOID();
                                        Vector listAl = PstAlStockTaken.list(0, 0, where, "");
                                        if (listAl.size()>0){
                                                AlStockTaken alStockTaken = (AlStockTaken) listAl.get(0);
                                                qty = alStockTaken.getTakenQty();
                                                toDate = alStockTaken.getTakenDate();
                                        }
                                } else if (leaveApplication.getTypeLeaveCategory() == 4){
                                        String where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveApplication.getOID();
                                        Vector listLl = PstLlStockTaken.list(0, 0, where, "");
                                        if (listLl.size()>0){
                                                LlStockTaken llStockTaken = (LlStockTaken) listLl.get(0);
                                                qty = llStockTaken.getTakenQty();
                                                toDate = llStockTaken.getTakenDate();
                                        }
                                }
                            }

                            String strDateFrom = (empDoc.getDate_of_issue().getYear()+1900)+"-01-01";
                            Date dtFrom = new Date();
                            try {
                                    dtFrom = new SimpleDateFormat("yyyy-MM-dd").parse(strDateFrom);
                            } catch (Exception exc){}
                            String inS = PstSystemProperty.getValueByNameWithStringNull("IN_OID_S_BA_CUTI");
                            int countS = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employee.getEmployeeNum(), "", 0, inS);

                            String inI = PstSystemProperty.getValueByNameWithStringNull("IN_OID_I_BA_CUTI");
                            int countI = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employee.getEmployeeNum(), "", 0, inI);
                            int countA = SessEmpSchedule.countEmpPresence(dtFrom, toDate, ""+employee.getEmployeeNum(), "", 2, "");


                            String whereExpense = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]+"="+employee.getOID()
                                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='PREVIOUS_BENEFIT'";
                            Vector listExpense = PstEmpDocListExpense.list(0, 0, whereExpense, "");
                            double compValue = 0.0;
                            if (listExpense.size()>0){
                                    for (int x=0; x < listExpense.size(); x++){
                                            EmpDocListExpense empDocListExpense = (EmpDocListExpense) listExpense.get(x);
                                            pengali = empDocListExpense.getDayLength();
                                            try {
                                                    PayComponent payComponent = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                                                    compValue = PstPaySlip.getCompValue(employee.getOID(), payPeriod, payComponent.getCompCode());
                                            } catch (Exception exc){}
                                    }
                            }

                            htmlEmp +=  "<tr>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+(i+1)+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+emp.getFullName()+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+PstEmployee.getPositionName(emp.getPositionId())+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+gradeLevel.getCodeLevel()+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+countS+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+countI+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+countA+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+qty+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+Formater.formatNumberMataUang(compValue, "Rp")+"</td>"
                                + "<td style=\"text-align: center; vertical-align: top;\">"+Formater.formatNumberMataUang(PstEmpDocListExpense.getTotalCompValueByEmployee(oidDoc, emp.getOID()), "Rp")+"</td>"
                        + "</tr>";
                        } catch (Exception exc){}
                    }
                } else {
                    htmlEmp += "<tr>"
                                + "<td colspan='10'>-</td>"
                            + "</tr>";
                }
                
                String htmlOutput = "";
                
                if (!view){
                    htmlOutput += "<a href=\"javascript:cmdAddLeave('" + objectName + "','" + oidDoc + "')\">add employee</a></br>";
                }
                
		htmlOutput +=  "<table border='1' cellpadding='0' cellspacing='0' style='width:100%'>"
                                    + "<tbody>"
                                            + "<tr>"
                                                    + "<td colspan='1' rowspan='2' style='text-align:center; width:3%'>No</td>"
                                                    + "<td colspan='1' rowspan='2' style='height:50px; text-align:center'>Nama</td>"
                                                    + "<td colspan='1' rowspan='2' style='text-align:center'>Jabatan</td>"
                                                    + "<td colspan='1' rowspan='2' style='text-align: center; width: 8%;'>Grade</td>"
                                                    + "<td colspan='3' rowspan='1' style='height:25px; text-align:center'>Jumlah Absensi</td>"
                                                    + "<td colspan='1' rowspan='2' style='text-align:center; width:10%'>Lamanya Cuti</td>"
                                                    + "<td colspan='1' rowspan='2' style='text-align:center; width:15%'>Jumlah<br>Gaji Periode "
                                                            +periode+
                                                            "<br>"
                                                            + (view ? "" : "<a href=\"javascript:cmdAddComp('PREVIOUS_BENEFIT','" + oidDoc + "','" + inEmployee + "' )\">add component</a></br>")
                                                    + "</td>"
                                                    + "<td colspan='1' rowspan='2' style='text-align:center; width:15%'>Jumlah Uang Cuti Diterima<br>"
                                                            + pengali + " x G.bl." + periode
                                                    + "</td>"
                                            + "</tr>"
                                            + "<tr>"
                                                    + "<td style='text-align:center; width:3%'>S</td>"
                                                    + "<td style='text-align:center; width:3%'>I</td>"
                                                    + "<td style='text-align:center; width:3%'>A</td>"
                                            + "</tr>"
                                            + htmlEmp +
                                    "</tbody>"
                            + "</table>"
                                                    + ""
                                                    + "";
		
		return htmlOutput;
	}
        
        
    public static String drawBAAdjustment(long oidDoc, String objectStatusField){
        String htmlOutput = "";
        
        if (objectStatusField.equals("KELEBIHAN")){
            htmlOutput += "<a href=\"javascript:cmdAddEmpAdjustment('" + oidDoc + "','"+objectStatusField+"')\">tambah karyawan</a></br>";
            String whereDebet = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='DEBET'";
                
            Vector listDebet = PstEmpDocListExpense.list(0, 0, whereDebet, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            htmlOutput += "DEBET";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double totalDebet = 0;
            if (listDebet.size()>0){
                for (int i=0; i < listDebet.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listDebet.get(i);
                    Employee employee = new Employee();
                    try {
                        employee = PstEmployee.fetchExc(empDocListExpense.getEmployeeId());
                    } catch (Exception exc){}

                    PayComponent payComp = new PayComponent();
                    try {
                        payComp = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + employee.getFullName() 
                            + " <a href=\"javascript:cmdDeleteEmpComp('" +empDocListExpense.getEmpDocId()+ "','"+empDocListExpense.getEmployeeId()+"')\">x</a></td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + employee.getNoRekening() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\"> " + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalDebet += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'> <b>TOTAL</b></td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\"> <b>" + Formater.formatNumberMataUang(totalDebet, "Rp")+ "</b></td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
            
            htmlOutput += "</br><a href=\"javascript:cmdAddDataKomponen('" + oidDoc + "','"+objectStatusField+"')\">tambah data</a><br>";
            htmlOutput += "KREDIT";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            String whereKredit = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+" != 'DEBET'";
            Vector listKredit = PstEmpDocListExpense.list(0, 0, whereKredit, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            double totalKredit = 0;
            if (listKredit.size()>0){
                for (int i=0; i < listKredit.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listKredit.get(i);
                    String text1 = "";
                    String text2 = "";
                    try {
                        String[] arrTxt = empDocListExpense.getObjectName().split(";");
                        for (int x = 0; x < arrTxt.length; x++){
                            if (x==0){ text1 = arrTxt[x];}
                            if (x==1){ text2 = arrTxt[x];}
                        }
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + text1+ "</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + text2+"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\"> " + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalKredit += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'> <b>TOTAL</b></td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\"> <b>" + Formater.formatNumberMataUang(totalKredit, "Rp")+ "</b></td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
        } else if (objectStatusField.equals("KEKURANGAN")){
            htmlOutput += "<a href=\"javascript:cmdAddDataKomponen('" + oidDoc + "','"+objectStatusField+"')\">tambah data</a><br>";
            htmlOutput += "DEBET";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            String whereDebet = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+" != 'KREDIT'";
            Vector listDebet = PstEmpDocListExpense.list(0, 0, whereDebet, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            double totalDebet = 0;
            if (listDebet.size()>0){
                for (int i=0; i < listDebet.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listDebet.get(i);
                    String text1 = "";
                    String text2 = "";
                    try {
                        String[] arrTxt = empDocListExpense.getObjectName().split(";");
                        for (int x = 0; x < arrTxt.length; x++){
                            if (x==0){ text1 = arrTxt[x];}
                            if (x==1){ text2 = arrTxt[x];}
                        }
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + text1+ "</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + text2+"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\"> " + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalDebet += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'> <b>TOTAL</b></td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\"> <b>" + Formater.formatNumberMataUang(totalDebet, "Rp")+ "</b></td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
            
            htmlOutput += "<br><a href=\"javascript:cmdAddEmpAdjustment('" + oidDoc + "','"+objectStatusField+"')\">tambah karyawan</a></br>";
            String whereKredit = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='KREDIT'";
                
            Vector listKredit = PstEmpDocListExpense.list(0, 0, whereKredit, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            htmlOutput += "KREDIT";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double totalKredit = 0;
            if (listKredit.size()>0){
                for (int i=0; i < listKredit.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listKredit.get(i);
                    Employee employee = new Employee();
                    try {
                        employee = PstEmployee.fetchExc(empDocListExpense.getEmployeeId());
                    } catch (Exception exc){}

                    PayComponent payComp = new PayComponent();
                    try {
                        payComp = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + employee.getFullName() 
                            + " <a href=\"javascript:cmdDeleteEmpComp('" +empDocListExpense.getEmpDocId()+ "','"+empDocListExpense.getEmployeeId()+"')\">x</a></td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\"> " + employee.getNoRekening() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\"> " + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalKredit += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'> <b>TOTAL</b></td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\"> <b>" + Formater.formatNumberMataUang(totalKredit, "Rp")+ "</b></td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
        }
        
        
        return htmlOutput;
    }
    
    public static String drawBAAdjustmentView(long oidDoc, String objectStatusField){
        String htmlOutput = "";
        
        if (objectStatusField.equals("KELEBIHAN")){
            String whereDebet = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='DEBET'";
                
            Vector listDebet = PstEmpDocListExpense.list(0, 0, whereDebet, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            htmlOutput += "DEBET";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double totalDebet = 0;
            if (listDebet.size()>0){
                for (int i=0; i < listDebet.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listDebet.get(i);
                    Employee employee = new Employee();
                    try {
                        employee = PstEmployee.fetchExc(empDocListExpense.getEmployeeId());
                    } catch (Exception exc){}

                    PayComponent payComp = new PayComponent();
                    try {
                        payComp = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + employee.getFullName() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + employee.getNoRekening() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\">&nbsp;" + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalDebet += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'>&nbsp;<b>TOTAL</b>&nbsp;</td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\">&nbsp;<b>" + Formater.formatNumberMataUang(totalDebet, "Rp")+ "</b>&nbsp;</td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
            
            htmlOutput += "</br>";
            htmlOutput += "KREDIT";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            String whereKredit = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+" != 'DEBET'";
            Vector listKredit = PstEmpDocListExpense.list(0, 0, whereKredit, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            double totalKredit = 0;
            if (listKredit.size()>0){
                for (int i=0; i < listKredit.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listKredit.get(i);
                    String text1 = "";
                    String text2 = "";
                    try {
                        String[] arrTxt = empDocListExpense.getObjectName().split(";");
                        for (int x = 0; x < arrTxt.length; x++){
                            if (x==0){ text1 = arrTxt[x];}
                            if (x==1){ text2 = arrTxt[x];}
                        }
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + text1+ "</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + text2+"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\">&nbsp;" + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalKredit += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'>&nbsp;<b>TOTAL</b>&nbsp;</td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\">&nbsp;<b>" + Formater.formatNumberMataUang(totalKredit, "Rp")+ "</b>&nbsp;</td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
        } else if (objectStatusField.equals("KEKURANGAN")){
            htmlOutput += "";
            htmlOutput += "DEBET";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            String whereDebet = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+" != 'KREDIT'";
            Vector listDebet = PstEmpDocListExpense.list(0, 0, whereDebet, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            double totalDebet = 0;
            if (listDebet.size()>0){
                for (int i=0; i < listDebet.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listDebet.get(i);
                    String text1 = "";
                    String text2 = "";
                    try {
                        String[] arrTxt = empDocListExpense.getObjectName().split(";");
                        for (int x = 0; x < arrTxt.length; x++){
                            if (x==0){ text1 = arrTxt[x];}
                            if (x==1){ text2 = arrTxt[x];}
                        }
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + text1+ "</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + text2+"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\">&nbsp;" + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalDebet += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'>&nbsp;<b>TOTAL</b>&nbsp;</td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\">&nbsp;<b>" + Formater.formatNumberMataUang(totalDebet, "Rp")+ "</b>&nbsp;</td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
            
            htmlOutput += "<br>";
            String whereKredit = PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMP_DOC_ID]+" = "+oidDoc
                            + " AND " + PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_OBJECT_NAME]+"='KREDIT'";
                
            Vector listKredit = PstEmpDocListExpense.list(0, 0, whereKredit, PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_EMPLOYEE_ID]);
            htmlOutput += "KREDIT";
            htmlOutput += "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
            double totalKredit = 0;
            if (listKredit.size()>0){
                for (int i=0; i < listKredit.size();i++){
                    EmpDocListExpense empDocListExpense = (EmpDocListExpense) listKredit.get(i);
                    Employee employee = new Employee();
                    try {
                        employee = PstEmployee.fetchExc(empDocListExpense.getEmployeeId());
                    } catch (Exception exc){}

                    PayComponent payComp = new PayComponent();
                    try {
                        payComp = PstPayComponent.fetchExc(empDocListExpense.getComponentId());
                    } catch (Exception exc){}
                    htmlOutput += "<tr>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + employee.getFullName() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:35%\">&nbsp;" + employee.getNoRekening() +"</td>";
                    htmlOutput += "<td style=\"background-color: #FFF; width:30%\">&nbsp;" + Formater.formatNumberMataUang(empDocListExpense.getCompValue(), "Rp")+ "</td>";
                    htmlOutput += "</tr>";
                    totalKredit += empDocListExpense.getCompValue();
                }
                htmlOutput += "<tr>";
                htmlOutput += "<td style=\"background-color: #FFF; width:70%; text-align: right;\" colspan='2'>&nbsp;<b>TOTAL</b>&nbsp;</td>";
                htmlOutput += "<td style=\"background-color: #FFF; width:30%;\">&nbsp;<b>" + Formater.formatNumberMataUang(totalKredit, "Rp")+ "</b>&nbsp;</td>";
                htmlOutput += "</td>";
                htmlOutput += "</tr>";
                htmlOutput += "</table>";
            }
        }
        
        
        return htmlOutput;
    }
}
