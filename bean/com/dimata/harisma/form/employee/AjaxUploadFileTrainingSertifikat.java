/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.employee.PstTrainingActivityActual;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.system.entity.PstSystemProperty;
import static com.sun.corba.se.spi.presentation.rmi.StubAdapter.request;
import java.awt.BorderLayout;
import java.awt.Image;
import java.io.*;
import java.util.*;
import javax.imageio.ImageIO;
 
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
 
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.*;



/**
 *
 * @author Utk
 */
public class AjaxUploadFileTrainingSertifikat  extends HttpServlet {
       
      private boolean isMultipart;
   private String filePath = "/";
   String prefix = "";
//   private int maxFileSize = 50 * 1024;
//   private int maxMemSize = 4 * 1024;
   private File file ;
   boolean uploadDone = false;

   
   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, java.io.IOException {
  
      // Check that we have a file upload request
      isMultipart = ServletFileUpload.isMultipartContent(request);
      response.setContentType("text/html");
      java.io.PrintWriter out = response.getWriter( );
   
      if( !isMultipart ) {
         
            out.println("Swal.fire({\n" +
                            "  icon: 'error',\n" +
                            "  title: 'Failed',\n" +
                            "  text: 'Upload Sertifikat Gagal'\n" +
                            "}).then((result) => {\n" +
                            "  // Reload the Page\n" +
                            "  location.reload();\n" +
                            "});");
         return;
      }
 
      DiskFileItemFactory factory = new DiskFileItemFactory();
   
      // maximum size that will be stored in memory
     // factory.setSizeThreshold(maxMemSize);
   
      // Location to save data that is larger than maxMemSize.
      //factory.setRepository(new File("C:\\Users\\Utk\\AppData\\Local\\Temp"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
   
      // maximum file size to be uploaded.
    //  upload.setSizeMax( maxFileSize );

      try { 
          filePath =  PstSystemProperty.getValueByName("IMGDOC");
          prefix = FRMQueryString.requestString(request, "prefix");
         // Parse the request to get file items.
         List fileItems = upload.parseRequest(request);
	
         // Process the uploaded file items
         Iterator i = fileItems.iterator();


         
         while ( i.hasNext () ) {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () ) {
                //jika form multipart
               // Get the uploaded file parameters
               String fieldName = fi.getFieldName();
               String fileName = fi.getName();
               String contentType = fi.getContentType();
               boolean isInMemory = fi.isInMemory();
               long sizeInBytes = fi.getSize();
               InputStream fileContent = fi.getInputStream();
               Image image = ImageIO.read(fileContent);
              
               // Write the file
               if( fileName.lastIndexOf("\\") >= 0 ) {
                  file = new File( filePath + fileName.substring( fileName.lastIndexOf("\\"))) ;
               } else {
                  file = new File( filePath + prefix+"_"+fileName.substring(fileName.lastIndexOf("\\")+1)) ;
               }
               PstTrainingActivityActual.updateSertifikatNameByOid(Long.valueOf(prefix),prefix+"_"+fileName.substring(fileName.lastIndexOf("\\")+1));
               fi.write( file ) ;
               uploadDone = true;
               
               out.println();
             
            }else{
                // jika bukan multipart
             
            }
         }
            if(uploadDone){
              out.println("Swal.fire({\n" +
                            "  icon: 'success',\n" +
                            "  title: 'Success',\n" +
                            "  text: 'Upload Sertifikat Berhasil'\n" +
                            "}).then((result) => {\n" +
                            "  // Reload the Page\n" +
                            " window.opener.location.href = window.opener.location; \n" +
                            "});");
            }else{
                      out.println("Swal.fire({\n" +
                            "  icon: 'error',\n" +
                            "  title: 'Failed',\n" +
                            "  text: 'Upload Sertifikat Gagal'\n" +
                            "}).then((result) => {\n" +
                            "  // Reload the Page\n" +
                            "  location.reload();\n" +
                            "});");
            }
           
         } catch(Exception ex) {
            System.out.println(ex);
                out.println("Swal.fire({\n" +
                            "  icon: 'error',\n" +
                            "  title: 'Failed',\n" +
                            "  text: 'Upload Sertifikat Gagal'\n" +
                            "}).then((result) => {\n" +
                            "  // Reload the Page\n" +
                            "  location.reload();\n" +
                            "});");
         }
      }
      
      public void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, java.io.IOException {
            
         throw new ServletException("GET method used with " +
            getClass( ).getName( )+": POST method required.");
      }
   }

