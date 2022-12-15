/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpitarget;

import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetailEmployee;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetailEmployee;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;

/**
 *
 * @author Utk
 */
public class AjaxUpdateTargetAmount extends HttpServlet {

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
            boolean isTarget = FRMQueryString.requestBoolean(request, "isTarget");
            long oidKpiTargetDetail = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID]);
            int amount = FRMQueryString.requestInt(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT]);
            long oidKpiTargetDetailEmploye = FRMQueryString.requestLong(request, FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID]);
            int bobot = FRMQueryString.requestInt(request, FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_BOBOT]);
            if(isTarget){
                if(oidKpiTargetDetail > 0){
                    KpiTargetDetail entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
                    entKpiTargetDetail.setAmount(amount);
                    PstKpiTargetDetail.updateExc(entKpiTargetDetail);
                }
            } else {
                if(oidKpiTargetDetailEmploye > 0){
                    KpiTargetDetailEmployee entKpiTargetDetailEmploye = PstKpiTargetDetailEmployee.fetchExc(oidKpiTargetDetailEmploye);
                    entKpiTargetDetailEmploye.setBobot(bobot);
                    PstKpiTargetDetailEmployee.updateExc(entKpiTargetDetailEmploye);
                }
            }
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
