/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.competency;

import com.dimata.harisma.entity.masterdata.Competency;
import com.dimata.harisma.entity.masterdata.PstCompetency;
import com.dimata.harisma.form.masterdata.FrmCompetencyLevel;
import com.dimata.qdep.form.FRMQueryString;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Utk
 */
public class AjaxCompetencyOption extends HttpServlet {

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
        
        long oidCompetencyGroup = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPETENCY_GROUP_ID]);
        long competencyIdSelected = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPENTENCY_ID]);
        int start = FRMQueryString.requestInt(request, "start");
        String selected="";
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
             out.println("<select id=\"competency_select\" name=\"competency_select\" style=\"padding:4px 6px\">");
             out.println("<option value=\"0\">-SELECT-</option>");
             Vector listCompetencySelect = PstCompetency.list(0, 0, ""+PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_GROUP_ID]+" = "+oidCompetencyGroup, PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_NAME]);
                if (listCompetencySelect != null && listCompetencySelect.size()>0){
                    for(int i=0; i<listCompetencySelect.size(); i++){
                        Competency competencySelect = (Competency)listCompetencySelect.get(i);
                        if(competencyIdSelected == competencySelect.getOID()){
                            
                        }
                         out.println("<option value=\""+competencySelect.getOID()+"\" "+selected+">"+competencySelect.getCompetencyName()+"</option>");
                    }
                }
              out.println("</select>"); 
              out.println("<a class=\"btn\" style=\"color:#FFF\" href=\"javascript:getListCompetenyLevel('"+start+"');\">Search</a>"); 
              
                
        }
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
