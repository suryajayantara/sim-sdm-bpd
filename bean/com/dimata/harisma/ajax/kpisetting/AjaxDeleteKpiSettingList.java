/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpisetting;

import com.dimata.harisma.entity.masterdata.KPI_Group;
import com.dimata.harisma.entity.masterdata.KPI_List;
import com.dimata.harisma.entity.masterdata.KpiSettingGroup;
import com.dimata.harisma.entity.masterdata.KpiSettingList;
import com.dimata.harisma.entity.masterdata.KpiSettingType;
import com.dimata.harisma.entity.masterdata.PstKPI_Group;
import com.dimata.harisma.entity.masterdata.PstKPI_List;
import com.dimata.harisma.entity.masterdata.PstKpiSetting;
import com.dimata.harisma.entity.masterdata.PstKpiSettingGroup;
import com.dimata.harisma.entity.masterdata.PstKpiSettingList;
import com.dimata.harisma.entity.masterdata.PstKpiSettingType;
import com.dimata.harisma.form.masterdata.FrmKPI_Type;
import com.dimata.harisma.form.masterdata.FrmKPI_List;
import com.dimata.harisma.form.masterdata.FrmKpiSetting;
import com.dimata.harisma.form.masterdata.FrmKpiSettingGroup;
import com.dimata.harisma.form.masterdata.FrmKpiSettingType;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 *
 * @author suryawan
 */
public class AjaxDeleteKpiSettingList extends HttpServlet{
    
 protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int isFormKpiSettingList = FRMQueryString.requestInt(request, "isFormKpiSettingList");
        long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
        long oidKpiList = FRMQueryString.requestLong(request, FrmKPI_List.fieldNames[FrmKPI_List.FRM_FIELD_KPI_LIST_ID]);
        int iCommand = FRMQueryString.requestCommand(request);
 
        try {
            if(iCommand == Command.DELETE){
                if(isFormKpiSettingList != 0){
                    // untuk menghapus KPI Setting List
                    String whereClause = "KPI_LIST_ID = '"+ oidKpiList +"' AND KPI_SETTING_ID ='"+ oidKpiSetting +"'";
                    Vector vKpiSettingList = PstKpiSettingList.list(0, 0, whereClause, "");
                    for(int i = 0; i < vKpiSettingList.size(); i++){
                        KpiSettingList objKpiSettingList = (KpiSettingList) vKpiSettingList.get(i);
                        PstKpiSettingList.deleteExc(objKpiSettingList.getOID());
                    }
                }
            }
        } catch (Exception e) {
            
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
