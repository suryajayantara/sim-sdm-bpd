/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.kpisetting;

import com.dimata.harisma.entity.masterdata.KpiSetting;
import com.dimata.harisma.entity.masterdata.KpiSettingList;
import com.dimata.harisma.entity.masterdata.KpiTarget;
import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.harisma.entity.masterdata.PstKpiSetting;
import com.dimata.harisma.entity.masterdata.PstKpiSettingList;
import com.dimata.harisma.form.masterdata.FrmDepartment;
import com.dimata.harisma.form.masterdata.FrmDivision;
import com.dimata.harisma.form.masterdata.FrmKPI_Type;
import com.dimata.harisma.form.masterdata.FrmKpiSetting;
import com.dimata.harisma.form.masterdata.FrmKpiSettingList;
import com.dimata.harisma.form.masterdata.FrmKpiSettingType;
import com.dimata.harisma.form.masterdata.FrmKpiTarget;
import com.dimata.harisma.form.masterdata.FrmKpiTargetDetail;
import com.dimata.harisma.form.masterdata.FrmSection;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Utk
 */
public class AjaxTargetPerKpi extends HttpServlet {

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
        response.getWriter().print("Hellot Get");
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
        try {
            long kpiSettingListOID = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_ID]);
            String targetTitle = FRMQueryString.requestString(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TITLE]);
            int docStatus = FRMQueryString.requestInt(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_STATUS_DOC]);
            int tahun = FRMQueryString.requestInt(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TAHUN]);
            int periode = FRMQueryString.requestInt(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD]);
            int periodeIndex = FRMQueryString.requestInt(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_INDEX_PERIOD]);
            String dateFrom = FRMQueryString.requestString(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_FROM]);
            String dateTo = FRMQueryString.requestString(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_TO]);
            long divisionOID = FRMQueryString.requestLong(request, FrmDivision.fieldNames[FrmDivision.FRM_FIELD_DIVISION_ID]);
            long departementOID = FRMQueryString.requestLong(request, FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT_ID]);
            long sectionOID = FRMQueryString.requestLong(request, FrmSection.fieldNames[FrmSection.FRM_FIELD_SECTION_ID]);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date newDateFrom = formatter.parse(dateFrom);
            Date newDateTo = formatter.parse(dateTo);
            
            KpiSettingList entKpiSettingList = PstKpiSettingList.fetchExc(kpiSettingListOID);
            KpiSetting entKpiSetting = PstKpiSetting.fetchExc(entKpiSettingList.getKpiSettingId());
            
            // insert ke tabel target
            KpiTarget entKpiTarget = new KpiTarget();
            entKpiTarget.setTitle(targetTitle);
            entKpiTarget.setTahun(tahun);
            entKpiTarget.setDivisionId(divisionOID);
            entKpiTarget.setDepartmentId(departementOID);
            entKpiTarget.setSectionId(sectionOID);
            entKpiTarget.setStatusDoc(docStatus);
            entKpiTarget.setCompanyId(entKpiSetting.getCompanyId());
            entKpiTarget.setCreateDate(new Date());
            
            // insert ke target detail
            KpiTargetDetail entKpiTargetDetail = new KpiTargetDetail();
            entKpiTargetDetail.setPeriod(periode);
            entKpiTargetDetail.setIndexPeriod(periodeIndex);
            entKpiTargetDetail.setDateFrom(newDateFrom);
            entKpiTargetDetail.setDateTo(newDateTo);
            entKpiTargetDetail.setKpiId(entKpiSettingList.getKpiListId());
            entKpiTargetDetail.setKpiSettingListId(entKpiSettingList.getOID());
            
            // insert ke tabel
            
            
        } catch (ParseException ex) {
            Logger.getLogger(AjaxTargetPerKpi.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DBException ex) {
            Logger.getLogger(AjaxTargetPerKpi.class.getName()).log(Level.SEVERE, null, ex);
        }
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
