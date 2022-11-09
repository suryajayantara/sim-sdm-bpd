/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.competency;

import com.dimata.gui.jsp.ControlCombo;
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
public class AjaxComptencyListByGroup extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            long competencyGroupId = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPETENCY_GROUP_ID]);
            long competencyIdSelected = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPENTENCY_ID]);
            
            String CtrOrderClause = PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_ID];
            String whereClause = PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_GROUP_ID]+" = "+competencyGroupId;
            Vector vectListComp = PstCompetency.list(0, 0, whereClause, CtrOrderClause);
            Vector valComp = new Vector(1, 1); //hidden values that will be deliver on request (oids) 
            Vector keyComp = new Vector(1, 1); //texts that displayed on combo box
             for (int c = 0; c < vectListComp.size(); c++) {
                Competency comp = (Competency) vectListComp.get(c);
                valComp.add("" + comp.getOID());
                keyComp.add(comp.getCompetencyName());
            }
            
            out.println("<div id=\"caption\">Competency</div>");
            out.println("<div id=\"div_input\">"+ControlCombo.draw(FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPENTENCY_ID], null, String.valueOf(competencyIdSelected), valComp, keyComp, "", "cbComp")+"</div>");
            
        }catch(Exception exc){
            
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
