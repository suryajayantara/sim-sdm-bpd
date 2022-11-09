/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.webservices;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.masterdata.jobdesc.JobDesc;
import com.dimata.harisma.entity.masterdata.jobdesc.PstJobDesc;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import com.dimata.util.EncryptMD5;
import com.dimata.util.Formater;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;
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
public class AjaxJobDesc extends HttpServlet {

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
        if(dataFor.equals("getList")){
            getList(request);
        } 
    }
    
    public void commandSave(HttpServletRequest request){
	
    }
    
    public void commandDeleteAll(HttpServletRequest request){
	
    }
    
    public void commandList(HttpServletRequest request, HttpServletResponse response){
	
    }
    
    private void getList(HttpServletRequest request){
        String selectedDate = FRMQueryString.requestString(request, "selecteddate");
        
        //CHECK ACCOUNT
        Vector vListData = PstJobDesc.list(0,0,"'"+selectedDate+"' BETWEEN "+PstJobDesc.fieldNames[PstJobDesc.FLD_START_DATETIME]
                + " AND "+PstJobDesc.fieldNames[PstJobDesc.FLD_REPEAT_UNTIL_DATE],"");
        if(vListData.size() > 0){
            for (int i=0; i < vListData.size();i++){
                dataContent = new JSONObject();
                JobDesc jobDesc = (JobDesc) vListData.get(i);
                
                try {
                    jobDesc = PstJobDesc.fetchExc(jobDesc.getOID());
                } catch (Exception exc){}
                
                if (jobDesc.getRepeatType() == 1){
                    
                    
                    try {
                        dataContent.put("JOB_TITLE", jobDesc.getJobTitle());
                        dataContent.put("START_DATETIME", Formater.formatDate(jobDesc.getStartDatetime(), "HH:mm"));
                        dataContent.put("END_DATETIME", Formater.formatDate(jobDesc.getEndDatetime(), "HH:mm"));
                    } catch(JSONException ex){
                        ex.printStackTrace();
                    }
                    jSONArray.put(dataContent);
                } else {
                
                    do {

                        Date selDate = new Date();
                        Date dtLoop = new Date();
                        DateFormat dateFormat = new SimpleDateFormat("HH:mm");

                        try {
                            selDate = new SimpleDateFormat("yyyy-MM-dd").parse(selectedDate);
                            String dtLoopStr = new SimpleDateFormat("yyyy-MM-dd").format(jobDesc.getStartDatetime());
                            dtLoop = new SimpleDateFormat("yyyy-MM-dd").parse(dtLoopStr);
                        } catch (Exception exc){
                            System.out.println(exc.toString());
                        }

                        try {
                            String dtLoopStr = new SimpleDateFormat("yyyy-MM-dd").format(jobDesc.getStartDatetime());
                            dtLoop = new SimpleDateFormat("yyyy-MM-dd").parse(dtLoopStr);
                        } catch (Exception exc){
                            System.out.println(exc.toString());
                        }


                        if (selDate.compareTo(dtLoop) == 0){
                            try {
                                dataContent.put("JOB_TITLE", jobDesc.getJobTitle());
                                dataContent.put("START_DATETIME", Formater.formatDate(jobDesc.getStartDatetime(), "HH:mm"));
                                dataContent.put("END_DATETIME", Formater.formatDate(jobDesc.getEndDatetime(), "HH:mm"));
                            } catch(JSONException ex){
                                ex.printStackTrace();
                            }
                            jSONArray.put(dataContent);
                            break;
                        }


                         if (jobDesc.getRepeatType() == 2){
                            jobDesc.setStartDatetime(addDate(jobDesc.getStartDatetime(), 7));
                            jobDesc.setEndDatetime(addDate(jobDesc.getEndDatetime(), 7));
                        } else if (jobDesc.getRepeatType() == 3){
                            jobDesc.setStartDatetime(addMonth(jobDesc.getStartDatetime(), 1));
                            jobDesc.setEndDatetime(addMonth(jobDesc.getEndDatetime(), 1));
                        } else if (jobDesc.getRepeatType() == 4){
                            jobDesc.setStartDatetime(addYear(jobDesc.getStartDatetime(), 1));
                            jobDesc.setEndDatetime(addYear(jobDesc.getEndDatetime(), 1));
                        }
                         System.out.println(jobDesc.getEndDatetime());
                    } while (jobDesc.getRepeatUntilDate().compareTo(jobDesc.getStartDatetime()) >= 0);
                }
            }
        }
    }    
    
    public static java.util.Date addDate(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.DATE, increment);
        dt = c.getTime();
        return dt;
    }
    
    public static java.util.Date addMonth(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.MONTH, increment);
        dt = c.getTime();
        return dt;
    }
    
    public static java.util.Date addYear(java.util.Date dt, int increment){
        Calendar c = Calendar.getInstance(); 
        c.setTime(dt); 
        c.add(Calendar.YEAR, increment);
        dt = c.getTime();
        return dt;
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
