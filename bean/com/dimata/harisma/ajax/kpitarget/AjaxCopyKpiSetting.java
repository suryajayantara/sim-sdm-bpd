/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpitarget;

import com.dimata.harisma.ajax.kpisetting.*;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.KPI_Group;
import com.dimata.harisma.entity.masterdata.KpiSetting;
import com.dimata.harisma.entity.masterdata.KpiSettingGroup;
import com.dimata.harisma.entity.masterdata.KpiSettingList;
import com.dimata.harisma.entity.masterdata.KpiSettingPosition;
import com.dimata.harisma.entity.masterdata.KpiSettingType;
import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee;
import com.dimata.harisma.entity.masterdata.PstKPI_Group;
import com.dimata.harisma.entity.masterdata.PstKpiSetting;
import com.dimata.harisma.entity.masterdata.PstKpiSettingGroup;
import com.dimata.harisma.entity.masterdata.PstKpiSettingList;
import com.dimata.harisma.entity.masterdata.PstKpiSettingPosition;
import com.dimata.harisma.entity.masterdata.PstKpiSettingType;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiTargetDetailEmployee;
import com.dimata.harisma.form.masterdata.CtrlKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmKPI_Type;
import com.dimata.harisma.form.masterdata.FrmKpiSetting;
import com.dimata.harisma.form.masterdata.FrmKpiSettingType;
import com.dimata.harisma.form.masterdata.FrmKpiTarget;
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
public class AjaxCopyKpiSetting extends HttpServlet {

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
        // fungsi untuk copy kpi setting ke target detail by agus 29/11/2022
        long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
        long oidKpiTarget = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_KPI_TARGET_ID]);
        if(oidKpiSetting != 0){
            try {
                // ambil data kpi setting
                KpiSetting entKpiSetting = PstKpiSetting.fetchExc(oidKpiSetting);
                // ambil data kpi setting position
                Vector vKpiSettingPosition = PstKpiSettingPosition.list(0, 0, "KPI_SETTING_ID = " + entKpiSetting.getOID(), "");
                // membuat object kpi target detail
                KpiTargetDetail entKpiTargetDetail = new KpiTargetDetail();
                // ambil data kpi setting list
                Vector vKpiSettingList = PstKpiSettingList.list(0, 0, "KPI_SETTING_ID = '"+entKpiSetting.getOID()+"'", "KPI_SETTING_ID");

                for(int i = 0; i < vKpiSettingList.size(); i++){
                    // prepare data untuk insert ke kpi target detail
                    KpiSettingList entKpiSettingList = (KpiSettingList) vKpiSettingList.get(i);                    
                    entKpiTargetDetail.setKpiTargetId(oidKpiTarget);
                    entKpiTargetDetail.setKpiId(entKpiSettingList.getKpiListId());
                    entKpiTargetDetail.setPeriod(0);
                    entKpiTargetDetail.setDateFrom(entKpiSetting.getStartDate());
                    entKpiTargetDetail.setDateTo(entKpiSetting.getValidDate());
                    entKpiTargetDetail.setAmount(0);
                    entKpiTargetDetail.setKpiGroupId(0);
                    entKpiTargetDetail.setWeightValue(0);
                    entKpiTargetDetail.setKpiSettingListId(entKpiSettingList.getOID());
                    // insert ke tabel kpi target detail
                    long oidKpiTargetDetail = PstKpiTargetDetail.insertExc(entKpiTargetDetail);
                    
                    // prepare insert data untuk tabel kpi target detail employe
                    for(int j = 0; j < vKpiSettingPosition.size(); j++){
                        KpiSettingPosition entKpiSettingPosition = (KpiSettingPosition) vKpiSettingPosition.get(j);
                        
                        Vector vEmploye = PstEmployee.list(0, 0, "POSITION_ID = " + entKpiSettingPosition.getPositionId(), "");
                        for(int k = 0; k < vEmploye.size(); k++){
                            Employee entEmploye = (Employee) vEmploye.get(k);
                            
                            KpiTargetDetailEmployee entKpiTargetDetailEmployee = new KpiTargetDetailEmployee();
                            entKpiTargetDetailEmployee.setEmployeeId(entEmploye.getOID());
                            entKpiTargetDetailEmployee.setKpiTargetDetailId(oidKpiTargetDetail);
                            // insert ke tabel target detail employe
                            PstKpiTargetDetailEmployee.insertExc(entKpiTargetDetailEmployee);
                        }
                    }
                }
            } catch (Exception exc) {}
            // end
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
