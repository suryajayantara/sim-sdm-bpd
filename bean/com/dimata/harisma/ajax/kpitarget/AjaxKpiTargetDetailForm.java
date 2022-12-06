/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpitarget;

import com.dimata.harisma.entity.masterdata.KpiTarget;
import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiTarget;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetail;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;
import java.util.Calendar;
import java.util.Date;
import org.jfree.data.time.Month;

/**
 *
 * @author Utk
 */
public class AjaxKpiTargetDetailForm extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        response.getWriter().print("Hellow GET");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        
        try{
            long oidKpiTargetDetail = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID]);
            int period = FRMQueryString.requestInt(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD]);
            int periodIndex = FRMQueryString.requestInt(request, "FRM_FIELD_PERIOD_INDEX");
            long amount = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]);
            double weightValue = FRMQueryString.requestDouble(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_WEIGHT_VALUE]);
            Date startDate = null;
            Date endDate = null;
            int startMonth = 0;
            int endMonth = 0;
            Calendar calendarStart = Calendar.getInstance();
            
            // ambil data kpi target & target detail
            KpiTargetDetail entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
            KpiTarget entKpiTarget = PstKpiTarget.fetchExc(entKpiTargetDetail.getKpiTargetId());
            int tahun = entKpiTarget.getTahun();
            
            // hitung date from & date to periode bulanan
            if(period == PstKpiTargetDetail.PERIOD_BULAN){
                int currentMonth = calendarStart.get(Calendar.MONTH);
                startMonth = currentMonth;
                endMonth = currentMonth;
            }
            
            // hitung date from & date to periode tahunan
            if(period == PstKpiTargetDetail.PERIOD_TAHUN){
                startMonth = 0;
                endMonth = 11;
            }
            
            // hitung date from & date to periode semester
            if(period == PstKpiTargetDetail.PERIOD_SEMESTER){                
                switch (periodIndex) {
                    case 1:
                        startMonth = 0;
                        endMonth = 5;
                    case 2:
                        startMonth = 6;
                        endMonth = 1;
                }
            }
            
            // hitung date from & date to periode triwulan
            if(period == PstKpiTargetDetail.PERIOD_TRIWULAN){
                switch (periodIndex) {
                    case 1:
                        startMonth = 0;
                        endMonth = 2;
                    case 2:
                        startMonth = 3;
                        endMonth = 5;
                    case 3:
                        startMonth = 6;
                        endMonth = 8;
                    case 4:
                        startMonth = 9;
                        endMonth = 11;
                }
            }
            
            // hitung date from & date to periode caturwulan
            if(period == PstKpiTargetDetail.PERIOD_CATURWULAN){
                switch (periodIndex) {
                    case 1:
                        startMonth = 0;
                        endMonth = 3;
                    case 2:
                        startMonth = 4;
                        endMonth = 7;
                    case 3:
                        startMonth = 8;
                        endMonth = 11;
                }
            }
            
            // membuat object tanggal berdasarkan filter periode & periode index
            calendarStart.set(Calendar.YEAR, tahun);
            calendarStart.set(Calendar.MONTH, startMonth);
            calendarStart.set(Calendar.DAY_OF_MONTH, 1);

            // returning the first date
            startDate = calendarStart.getTime();

            Calendar calendarEnd = Calendar.getInstance();
            calendarEnd.set(Calendar.YEAR, tahun);
            calendarEnd.set(Calendar.MONTH, endMonth);
            calendarEnd.set(Calendar.DAY_OF_MONTH, 31);

            // returning the last date
            endDate = calendarEnd.getTime();
            
            entKpiTargetDetail.setPeriod(period);
            entKpiTargetDetail.setAmount(amount);
            entKpiTargetDetail.setWeightValue(weightValue);
            entKpiTargetDetail.setDateFrom(startDate);
            entKpiTargetDetail.setDateTo(endDate);
            PstKpiTargetDetail.updateExc(entKpiTargetDetail);
        } catch(Exception error){}
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
