/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.ajax.competency;

import com.dimata.harisma.entity.masterdata.Competency;
import com.dimata.harisma.entity.masterdata.CompetencyGroup;
import com.dimata.harisma.entity.masterdata.CompetencyLevel;
import com.dimata.harisma.entity.masterdata.PstCompetency;
import com.dimata.harisma.entity.masterdata.PstCompetencyGroup;
import com.dimata.harisma.entity.masterdata.PstCompetencyLevel;
import com.dimata.harisma.form.masterdata.CtrlCompetencyLevel;
import com.dimata.harisma.form.masterdata.FrmCompetencyLevel;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import java.util.Vector;
/**
 *
 * @author Utk
 */
public class AjaxCompetencyLevelList extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
     public String getCompetencyName(long comId){
            String str = "";
            try {
                Competency compe = PstCompetency.fetchExc(comId);
                str = compe.getCompetencyName();
            } catch (Exception e) {
                System.out.println("getCompetencyName=>"+e.toString());
            }
            return str;
        }

       public String getCompetencyGroupNameByCompId(long comGroupId){
            String str = "";
            try {
                CompetencyGroup compGroup = PstCompetencyGroup.fetchExc(comGroupId);
                str = compGroup.getGroupName();
            } catch (Exception e) {
                System.out.println("getCompetencyName=>"+e.toString());
            }
            return str;
        }
                       
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
                CtrlCompetencyLevel ctrlCompetencyLevel= new CtrlCompetencyLevel(request);
                long oidCompetencyGroup = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPETENCY_GROUP_ID]);
                long oidCompetency = FRMQueryString.requestLong(request, FrmCompetencyLevel.fieldNames[FrmCompetencyLevel.FRM_FIELD_COMPENTENCY_ID]);
                
               
                int recordToGet = 10;
                int vectSize = 0;
                int iCommand = FRMQueryString.requestInt(request, "command");
                int start = FRMQueryString.requestInt(request, "start");
                
                
                String whereClause = "";
                if(oidCompetencyGroup != 0){
                    if(whereClause.length()>0){
                        whereClause+=" AND ";
                    }
                    whereClause+=PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_GROUP_ID]+" = "+ oidCompetencyGroup;
                }
                
                if(oidCompetency != 0){
                    if(whereClause.length()>0){
                        whereClause+=" AND ";
                    }
                    whereClause+=PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_ID]+" = "+ oidCompetency;
                }
                
                String order =  ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_GROUP_ID];
                
                vectSize = PstCompetencyLevel.getCount(whereClause);
                
                if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                        || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                    start = ctrlCompetencyLevel.actionList(iCommand, start, vectSize, recordToGet);
                }
                
    
                    /* assign query */
               
                   
   
                Vector listCompetencyLevel = new Vector();
                listCompetencyLevel = PstCompetencyLevel.list(start,recordToGet,whereClause,order);
                out.print(" <table class=\"tblStyle\">\n" +
                            "   <tr >\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center\">No</td>\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center\">Competency Group</td>\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center\">Competency</td>\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center\">Level Name</td>\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center\">Score Valuce</td>\n" +
                            "      <td class=\"title_tbl\" style=\"text-align: center; max-width:250px;\">Description</td>\n" +
                            "      <td class=\"title_tbl\">&nbsp;</td>\n" +
                            "   </tr>");
                try{
                    if(listCompetencyLevel.size() > 0){
                        int no = 0;
                        for(int xy =0; xy < listCompetencyLevel.size();xy++ ){
                            no++;
                            CompetencyLevel compotenLevel = (CompetencyLevel) listCompetencyLevel.get(xy);
                        out.println(" <tr>\n" +
                                    "   <td>"+no+"</td>\n" +
                                    "   <td>"+getCompetencyGroupNameByCompId(compotenLevel.getCompetencyGroupId())+"</td>\n" +
                                    "   <td>"+getCompetencyName(compotenLevel.getCompetencyId())+"</td>\n" +
                                    "   <td>"+compotenLevel.getLevelName()+"</td>\n" +
                                    "   <td>"+compotenLevel.getScoreValue()+"</td>\n" +
                                    "   <td style=\"max-width:250px; word-wrap: break-word;\">"+compotenLevel.getDescription()+"</td>\n" +
                                    "   <td><button id=\"btnX\" onclick=\"cmdEdit('"+compotenLevel.getOID()+"')\">Edit</button>&nbsp;<button id=\"btnX\" onclick=\"cmdAsk('"+compotenLevel.getOID()+"')\">Delete</button></td>\n" +
                                    "</tr>");
                        }
                    }else{
                         out.println(" <tr>\n" +
                                    "   <td colspan='7'>No Data Found</td>\n" +  
                                    " <tr>\n" );
                    }
                }catch(Exception exc){
                    
                }
                out.println("</table>");
                
                out.println("<div>&nbsp;</div>\n" +
                            "        <div id=\"record_count\">\n");
                                        if (vectSize >= recordToGet){
                                           
                out.println("                List : "+start+" &HorizontalLine; "+(start+listCompetencyLevel.size())+" | \n" );
                            
                                        }
                out.println("            Total : "+vectSize+""+
                            "<br>        </div>\n" +
                            "        <div class=\"pagging\">\n" +
                            "            <a style=\"color:#F5F5F5\" href=\"javascript:cmdListFirst('"+start+"')\" class=\"btn-small\">First</a>\n" +
                            "            <a style=\"color:#F5F5F5\" href=\"javascript:cmdListPrev('"+start+"')\" class=\"btn-small\">Previous</a>\n" +
                            "            <a style=\"color:#F5F5F5\" href=\"javascript:cmdListNext('"+start+"')\" class=\"btn-small\">Next</a>\n" +
                            "            <a style=\"color:#F5F5F5\" href=\"javascript:cmdListLast('"+start+"')\" class=\"btn-small\">Last</a>\n" +
                            "        </div>"
                );
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
