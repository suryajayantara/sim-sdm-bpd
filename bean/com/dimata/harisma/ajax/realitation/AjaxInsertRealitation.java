/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.realitation;

import com.dimata.harisma.ajax.kpitarget.*;
import com.dimata.harisma.entity.masterdata.KPI_Employee_Achiev;
import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee;
import com.dimata.harisma.entity.masterdata.PstKPI_Employee_Achiev;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetailEmployee;
import com.dimata.harisma.form.masterdata.FrmKPI_Employee_Achiev;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetailEmployee;
import com.dimata.harisma.form.masterdata.Frm_KPI_Employee_Achievement;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;
import java.util.Date;

/**
 *
 * @author Utk
 */
public class AjaxInsertRealitation extends HttpServlet {

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
            long kpiEmployeeAchievOID = FRMQueryString.requestLong(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_EMPLOYEE_ACHIEV_ID]);
            long kpiListOID = FRMQueryString.requestLong(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_KPI_LIST_ID]);
            long kpiTargetOID = FRMQueryString.requestLong(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_TARGET_ID]);
            long employeeOID = FRMQueryString.requestLong(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_EMPLOYEE_ID]);
            double achievement = FRMQueryString.requestDouble(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEVMENT]);
            int achievementType = FRMQueryString.requestInt(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_TYPE]);
            String achievementNote = FRMQueryString.requestString(request, FrmKPI_Employee_Achiev.fieldNames[FrmKPI_Employee_Achiev.FRM_FIELD_ACHIEV_NOTE]);
            
            if(kpiEmployeeAchievOID > 0){
                KPI_Employee_Achiev entKpiEmployeeAchiev = PstKPI_Employee_Achiev.fetchExc(kpiEmployeeAchievOID);
                entKpiEmployeeAchiev.setKpiListId(kpiListOID);
                entKpiEmployeeAchiev.setTargetId(kpiTargetOID);
                entKpiEmployeeAchiev.setEmployeeId(employeeOID);
                entKpiEmployeeAchiev.setAchievement(achievement);
                entKpiEmployeeAchiev.setAchievType(achievementType);
                entKpiEmployeeAchiev.setAchievNote(achievementNote);
                entKpiEmployeeAchiev.setEntryDate(new Date());

                PstKPI_Employee_Achiev.updateExc(entKpiEmployeeAchiev);
            } else {
                KPI_Employee_Achiev entKpiEmployeeAchiev = new KPI_Employee_Achiev();
                entKpiEmployeeAchiev.setKpiListId(kpiListOID);
                entKpiEmployeeAchiev.setTargetId(kpiTargetOID);
                entKpiEmployeeAchiev.setEmployeeId(employeeOID);
                entKpiEmployeeAchiev.setAchievement(achievement);
                entKpiEmployeeAchiev.setAchievType(achievementType);
                entKpiEmployeeAchiev.setAchievNote(achievementNote);
                entKpiEmployeeAchiev.setEntryDate(new Date());

                PstKPI_Employee_Achiev.insertExc(entKpiEmployeeAchiev);
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
