/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.appraisal;

import com.dimata.gui.jsp.ControlDatePopup;
import com.dimata.harisma.entity.employee.assessment.AssessmentFormMain;
import com.dimata.harisma.entity.employee.assessment.PstAssessmentFormMain;
import com.dimata.harisma.form.employee.appraisal.FrmAppraisalMain;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

/**
 *
 * @author Utk
 */
public class AjaxGetAssMain extends HttpServlet {

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
        
        try {
            JSONObject obj = new JSONObject();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            long assMainId = FRMQueryString.requestLong(request, "assFormMainId");
            String datePeriodFrom = FRMQueryString.requestString(request, "datePeriodFrom");
            response.setContentType("text/html");
            
            AssessmentFormMain assessmentFormMain = PstAssessmentFormMain.fetchExc(assMainId);
            Date periodFrom = formatter.parse(datePeriodFrom);
            calendar.setTime(periodFrom);
            calendar.add(Calendar.MONTH, (assessmentFormMain.getPeriodeAppraisalMonth() - 1));
            Date periodTo = calendar.getTime();
            
            String dateHtml = ControlDatePopup.writeDate(FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_DATA_PERIOD_TO],periodTo);
            
            PrintWriter out = response.getWriter();
            out.println(dateHtml);
        } catch (Exception ex) {
            Logger.getLogger(AjaxGetAssMain.class.getName()).log(Level.SEVERE, null, ex);
        }
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
