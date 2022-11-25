/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpisetting;

import com.dimata.harisma.entity.masterdata.KPI_Group;
import com.dimata.harisma.entity.masterdata.KpiSettingType;
import com.dimata.harisma.entity.masterdata.PstKPI_Group;
import com.dimata.harisma.entity.masterdata.PstKpiSetting;
import com.dimata.harisma.entity.masterdata.PstKpiSettingGroup;
import com.dimata.harisma.entity.masterdata.PstKpiSettingType;
import com.dimata.harisma.form.masterdata.FrmKPI_Type;
import com.dimata.harisma.form.masterdata.FrmKpiSetting;
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
 * @author Utk
 */
public class AjaxDeleteKpiSettingType extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int isFormKpiSettingType = FRMQueryString.requestInt(request, "isFormKpiSettingType");
        long oidKpiSettingType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]);
        long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
        long oidKpiType = FRMQueryString.requestLong(request, FrmKPI_Type.fieldNames[FrmKPI_Type.FRM_FIELD_KPI_TYPE_ID]);
        int iCommand = FRMQueryString.requestCommand(request);

        try {
            if(iCommand == Command.DELETE){
                if((oidKpiSettingType != 0) && (isFormKpiSettingType == 1)){
                    String whereClause = "KPI_TYPE_ID = '"+ oidKpiType +"' AND KPI_SETTING_ID ='"+ oidKpiSetting +"'";
                    Vector vKpiList = PstKpiSettingType.list(0, 0, whereClause, "");
                    for(int i = 0; i < vKpiList.size(); i++){
                        KpiSettingType objKpiSettingType = (KpiSettingType) vKpiList.get(i);
                        PstKpiSettingType.deleteExc(objKpiSettingType.getKpiSettingTypeId());
                    }
                     
                    String kpiGroupQuery = "hr_kpi_setting.`KPI_SETTING_ID`='"+ oidKpiSetting +"' AND hr_kpi_setting_type.`KPI_TYPE_ID`='"+ oidKpiType +"'";
                    Vector vKpiGroup = PstKPI_Group.listWithJoinSettingAndType(kpiGroupQuery);
                    if(vKpiGroup.size() > 0){
                        for(int j = 0; j < vKpiGroup.size(); j++){
                            KPI_Group objKpiGroup = (KPI_Group) vKpiGroup.get(j);
                            PstKpiSettingGroup.deleteByKpiGroup(objKpiGroup.getOID());
                        }
                    }
                }
            }
        } catch (Exception e) {
            
        }
    }
    
    public static String tes(){
        String data = "tes";
        return data;
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
