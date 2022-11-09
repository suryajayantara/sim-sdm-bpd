/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.webservices;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.form.admin.FrmAppUser;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import com.dimata.util.EncryptMD5;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Gunadi
 */
public class Login extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    private JSONObject dataCostum = null;
    private JSONObject dataContent = null;
    private boolean success = false;
    private String message = "";
    
    //LONG
    private long oid = 0;
    
    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String dataReturn = "";
    
    
    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.setContentType("text/html;charset=UTF-8");
	
	//LONG
	this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
	
	//STRING
	this.dataFor = FRMQueryString.requestString(request, "datafor");
	this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
	this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
	this.dataReturn = "";
        this.message = "";
	
	//INT
	this.iCommand = FRMQueryString.requestCommand(request);
	this.iErrCode = 0;
	
	//BOOLEAN
        this.success = false;
	
	//OBJECT
	this.jSONObject = new JSONObject();
        this.jSONArray = new JSONArray();
        this.dataCostum = null;
	this.dataContent = null;
        
	switch(this.iCommand){
	    case Command.SAVE :
		commandSave(request);
	    break;
		
	    case Command.LIST :
		commandList(request, response);
	    break;
	    default : commandNone(request);
	}
        
        try{
            jSONObject.put("success", success);
            jSONObject.put("message", message);
            if(dataCostum!=null){
                jSONObject.put("data", dataCostum);
            }
            
            
            
        }catch(JSONException ex){
            ex.printStackTrace();
        }
	if (dataContent!= null){
            response.getWriter().print(this.jSONArray);
        } else {
        	response.getWriter().print(this.jSONObject);
        }
	
    }
    
    public void commandNone(HttpServletRequest request){
             userLogin(request);
    }
    
    public void commandSave(HttpServletRequest request){
	
    }
    
    public void commandDeleteAll(HttpServletRequest request){
	
    }
    
    public void commandList(HttpServletRequest request, HttpServletResponse response){
	
    }
    
    private void userLogin(HttpServletRequest request){
        String username = FRMQueryString.requestString(request, FrmAppUser.fieldNames[FrmAppUser.FRM_LOGIN_ID]);
        String password = FRMQueryString.requestString(request, FrmAppUser.fieldNames[FrmAppUser.FRM_PASSWORD]);
        try{
            //CHECK ACCOUNT
            jSONArray = new JSONArray();
            Vector isExist = PstAppUser.listFullObj(0,0,PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID]+"='"+username+"' "
                    + "AND "+PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD]+"='"+EncryptMD5.getMD5(password)+"'","");
            if(isExist.size() > 0){
                AppUser appUser = (AppUser) isExist.get(0);
                JSONObject jSONObjectArray = new JSONObject();
                jSONObjectArray.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], appUser.getOID());
                jSONObjectArray.put(PstAppUser.fieldNames[PstAppUser.FLD_EMPLOYEE_ID], appUser.getEmployeeId());
                jSONObjectArray.put(PstAppUser.fieldNames[PstAppUser.FLD_ADMIN_STATUS], appUser.getAdminStatus());
                jSONObjectArray.put(PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID], appUser.getLoginId());
                jSONObjectArray.put(PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD], appUser.getPassword());
            }
        } catch (Exception exc){
            
        }
    }    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
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
