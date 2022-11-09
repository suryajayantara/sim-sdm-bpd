/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.utility.service.message;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Collections;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.common.io.Files;


/**
 *
 * @author Gunadi
 */
public class GoogleService {
    
    private static final String APPLICATION_NAME = "ServiceCalendar";
    
    /** E-mail address of the service account. */
    private static final String SERVICE_ACCOUNT_EMAIL = "admin-38@dimatahr-194008.iam.gserviceaccount.com";
  
    /** Global instance of the HTTP transport. */
    private static HttpTransport httpTransport;

    /** Global instance of the JSON factory. */
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    
    public  Calendar configure() {
        try {
          try {
            httpTransport = new NetHttpTransport();
            // check for valid setup
            if (SERVICE_ACCOUNT_EMAIL.startsWith("Enter ")) {
              System.err.println(SERVICE_ACCOUNT_EMAIL);
              System.exit(1);
            }
            URL loc = this.getClass().getResource("/DimataHR-9540f1211abb.p12"); 
            String path = loc.getPath(); 
            path = path.replaceAll("%20", " ");
            File file = new File(path);
            String p12Content = Files.readFirstLine(file, Charset.defaultCharset());
            if (p12Content.startsWith("Please")) {
              System.err.println(p12Content);
              System.exit(1);
            }
            // service account credential (uncomment setServiceAccountUser for domain-wide delegation)
            GoogleCredential credential = new GoogleCredential.Builder()
                .setTransport(httpTransport)
                .setJsonFactory(JSON_FACTORY)
                .setServiceAccountId(SERVICE_ACCOUNT_EMAIL)
                .setServiceAccountScopes(Collections.singleton(CalendarScopes.CALENDAR))
                .setServiceAccountPrivateKeyFromP12File(file)
                .build();
         Calendar   client = new com.google.api.services.calendar.Calendar.Builder(
                 httpTransport, JSON_FACTORY, credential)
                    .setApplicationName(APPLICATION_NAME).build();
         System.out.println("Client : "+client);
         return client;

          } catch (IOException e) {
            System.err.println(e.getMessage());
          }
        } catch (Throwable t) {
          t.printStackTrace();
        }
        System.exit(1);
        return null;
      }
}
