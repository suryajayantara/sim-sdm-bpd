/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.webservices;

import com.dimata.harisma.entity.attendance.PstAlStockTaken;
import com.dimata.harisma.entity.attendance.PstLlStockTaken;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Formater;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author gndiw
 */
public class service extends HttpServlet {

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
        response.setContentType("application/json;charset=UTF-8");
        
        JSONArray arr = new JSONArray();
        
        int type = FRMQueryString.requestInt(request, "TYPE");
        
        switch (type){
            case 0:
                getEmpData(request, arr);
                break;
            case 1:
                getJabatanTertinggi(arr);
                break;
        }
                
        response.getWriter().print(arr);
    }
    
    private synchronized void getEmpData(HttpServletRequest request, JSONArray arr){
        DBResultSet dbrs = null;
        try {
            
            String sql = "SELECT "
                    + "emp.EMPLOYEE_NUM"
                    + ",emp.EMPLOYEE_ID"
                    + ",emp.FULL_NAME"
                    + ",dv.DIVISION"
                    + ",dep.DEPARTMENT"
                    + ",pos.POSITION"
                    + ",sec.SECTION"
                    + ",emp.EMAIL_ADDRESS"
                    + ",cat.EMP_CATEGORY"
                    + " FROM hr_employee AS emp "
                    + "INNER JOIN hr_division dv ON emp.DIVISION_ID = dv.DIVISION_ID "
                    + "INNER JOIN hr_department dep ON emp.DEPARTMENT_ID = dep.DEPARTMENT_ID "
                    + "INNER JOIN hr_section sec ON emp.SECTION_ID = sec.SECTION_ID "
                    + "INNER JOIN hr_position pos ON emp.POSITION_ID = pos.POSITION_ID "
                    + "INNER JOIN hr_emp_category cat ON emp.EMP_CATEGORY_ID = cat.EMP_CATEGORY_ID "
                    + "WHERE emp.RESIGNED = 0 "
                    + " ORDER BY dv.DIVISION, dep.DEPARTMENT";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                
                long employeeId = rs.getLong("EMPLOYEE_ID");
                
                String whereAL = "'"+ Formater.formatDate(new Date(), "yyyy-MM-dd") +"' BETWEEN DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                        + " AND DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                        + ""+ PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";
                String whereLL = "'"+ Formater.formatDate(new Date(), "yyyy-MM-dd") +"' BETWEEN DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                                + " AND DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                                + ""+ PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";
                String whereSL = "'"+ Formater.formatDate(new Date(), "yyyy-MM-dd") +"' BETWEEN DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                                + " AND DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                                + ""+ PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";

                boolean existAl = PstAlStockTaken.existAlStockTakenByLeaveStatus(employeeId, new Date());
                boolean existLl = PstLlStockTaken.existLlStockTakenByLeaveStatus(employeeId, new Date());
                boolean existSl = PstSpecialUnpaidLeaveTaken.getHaveTakenExecuteForm(new Date(), employeeId);

                
                //if (listEmpLeaveAL.size() > 0 || listEmpLeaveLL.size() > 0 || listEmpLeaveSL.size() > 0){
                boolean statusCuti = false;
                if (existAl || existLl || existSl){
                    statusCuti = true;
                }
                
                JSONObject obj = new JSONObject();
                obj.put("NRK", rs.getString("EMPLOYEE_NUM"));
                obj.put("NAMA", rs.getString("FULL_NAME"));
                obj.put("SATUAN_KERJA", rs.getString("DIVISION"));
                obj.put("UNIT", rs.getString("DEPARTMENT"));
                obj.put("SUB_UNIT", rs.getString("SECTION") != null ? rs.getString("SECTION") : "-");
                obj.put("JABATAN", rs.getString("POSITION"));
                obj.put("EMAIL", rs.getString("EMAIL_ADDRESS") != null ? rs.getString("EMAIL_ADDRESS") : "-");
                obj.put("STATUS_CUTI", statusCuti);
                obj.put("KATEGORI", rs.getString("EMP_CATEGORY"));
                arr.put(obj);
            }
        } catch (Exception exc){
        
        } finally{
            DBResultSet.close(dbrs);
        }
    }
    
    private synchronized void getJabatanTertinggi(JSONArray arr){
        try {
            Vector listDivision = PstDivision.list(0, 0, "VALID_STATUS = 1", "DIVISION");
            for (int i = 0; i < listDivision.size(); i++){
                Division division = (Division) listDivision.get(i);
                JSONObject obj = new JSONObject();
                obj.put("SATUAN_KERJA", division.getDivision());
                DBResultSet dbrs = null;
                try {
                    String sql = "SELECT "
                    + "emp.EMPLOYEE_NUM"
                    + " FROM hr_employee AS emp "
                    + "INNER JOIN hr_level lvl ON emp.LEVEL_ID = lvl.LEVEL_ID "
                    + " WHERE emp.DIVISION_ID = "+division.getOID()
                    + " AND emp.RESIGNED = 0 "
                    + " ORDER BY lvl.`LEVEL_RANK` DESC LIMIT 1";
                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while (rs.next()) {
                        obj.put("NRK", rs.getString("EMPLOYEE_NUM"));
                    }
                } catch (Exception exc){
                    
                } finally {
                    
                }
                arr.put(obj);
            }
        } catch (Exception exc){}
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
