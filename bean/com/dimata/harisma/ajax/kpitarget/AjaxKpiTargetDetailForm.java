/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpitarget;

import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetail;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;
import java.util.Vector;

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
            long amount = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]);
            double weightValue = FRMQueryString.requestDouble(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_WEIGHT_VALUE]);
            
            KpiTargetDetail entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
            entKpiTargetDetail.setPeriod(period);
            entKpiTargetDetail.setAmount(amount);
            entKpiTargetDetail.setWeightValue(weightValue);
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
