/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
//create by priska 20160411
package com.dimata.harisma.utility.notification;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.service.notification.Notification;
import com.dimata.harisma.entity.service.notification.NotificationRecipient;
import com.dimata.harisma.entity.service.notification.PstNotification;
import com.dimata.harisma.entity.service.notification.PstNotificationRecipient;
import com.dimata.harisma.util.email;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.util.Formater;
import com.dimata.util.net.MailProcess;
import com.dimata.util.net.MailSender;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class ProcessNotification implements Runnable {

    /**
     * @return the message
     */
    public static String getMessage() {
        return message;
    }

    /**
     * @param aMessage the message to set
     */
    public static void setMessage(String aMessage) {
        message = aMessage;
    }
    //update by satrya 2012-08-08

    /**
     * @return the messageCalculation
     */
    public static String getMessageCalculation() {
        return messageCalculation;
    }

    /**
     * @param aMessageCalculation the messageCalculation to set
     */
    public static void setMessageCalculation(String aMessageCalculation) {
        messageCalculation = aMessageCalculation;
    }

    /**
     * @return the messageProsessAbsence
     */
    public static String getMessageProsessAbsence() {
        return messageProsessAbsence;
    }

    /**
     * @param aMessageProsessAbsence the messageProsessAbsence to set
     */
    public static void setMessageProsessAbsence(String aMessageProsessAbsence) {
        messageProsessAbsence = aMessageProsessAbsence;
    }

    /**
     * @return the messageProsessLateness
     */
    public static String getMessageProsessLateness() {
        return messageProsessLateness;
    }

    /**
     * @param aMessageProsessLateness the messageProsessLateness to set
     */
    public static void setMessageProsessLateness(String aMessageProsessLateness) {
        messageProsessLateness = aMessageProsessLateness;
    }
    private boolean running = false;
    private long sleepMs = 50;
    private static String message = "";
    //update by satrya 2012-08-08
    private static String messageCalculation = "";
    //update by satrya 2012-09-04
    private static String messageProsessAbsence = "";
    private static String messageProsessLateness = "";
    //update by satrya 2013-07-25
    // private static String msgProsessAnalyze="";
    private int recordSize = 0;
    private int progressSize = 0;
    //update by satrya 2012-09-21
    private int recordSizeAbsence = 0;
    private int progressSizeAbsence = 0;
    //update by satrya 2013-07-25
    //private int recordSizeAnalyse=0;
    //private int progressSizeAnalyze=0;
    public static boolean CHECK_SWEEP_TIME = false;
    public static int IGNORE_TIME = 15 * 60 * 1000;          /* --- in milli seconds --- */
    //update by satrya 2012-08-01

    private Date fromDate = null;
    private Date toDate = null;
    private int limitList = 1000;

    public ProcessNotification() {
        initClass(10);
    }

    public ProcessNotification(Date fromDate, Date toDate, long oidDepartement, String fullName, long oidsection, String empCat) {
        // public ProcessNotification(Date fromDate, Date toDate, long oidDepartement, String fullName, long oidsection) {
        initClass(10);
    }

    public void initClass(long sleepMs) {
        this.sleepMs = sleepMs;
    }

    public void run() {
        this.setRunning(true);
        setMessage("TRANSMANAGER ASSISTANT : Process hr_machine_transaction >>> hr_presence");

        setMessageProsessAbsence("");
        setMessageCalculation(" START ANALIZING DATA HR_Presence >> " + recordSize + " DATA");
        String oidSPresence = "";
        int i = 0;

        Vector objectClass = MailSender.getvMailProcess();
        Hashtable hashRecipientSubject = new Hashtable();
        Hashtable hashCCSubject = new Hashtable();
        Hashtable hashBCCSubject = new Hashtable();
//        if (objectClass != null) {
//                for (int j = 0; j < objectClass.size(); j++) {
//                    MailProcess mail = (MailProcess) objectClass.get(j);
//                    hashRecipientSubject.put(""+mail.getStrRecTo()+mail.getSubject(), mail);
//                    hashCCSubject.put(""+mail.getStrRecCC()+mail.getSubject(), mail);
//                    hashBCCSubject.put(""+mail.getStrRecBCC()+mail.getSubject(), mail);
//                }
//        }
        while (this.running) {
            i++;
            //System.out.println("Ini angka " + i);

            Vector listService = PstNotification.list(0, 0, PstNotification.fieldNames[PstNotification.FLD_STATUS] + " = " + 1, "");
            if (listService.size() > 0) {
                for (int x = 0; x < listService.size(); x++) {
                    Notification notification = (Notification) listService.get(x);
                    notification.getModulName();
                    switch (x) {
                        //untuk end contract
                        case 0:
                            try {
                                long oid = EndContractNotification(notification);
                            } catch (Exception exc) {
                            }
                            break;

                        case 1:
                            try {
                                long oid = BirthDateNotification(notification);
                            } catch (Exception exc) {
                            }
                            break;
                        case 2:
                            try {
                                long oid = IdCardBirthdateNotification(notification);
                            } catch (Exception exc) {
                            }
                            break;
                        default:

                    }

                }
            }

            try {
                Thread.sleep(this.getSleepMs());
            } catch (Exception exc) {
                System.out.println(exc);
            } finally {
            }
        }

        this.running = false;


    }

    public static Vector RecipientCcBcc (int index, long notificationId){
        Vector rec = new Vector();
        Vector listNotificationRecipientBCC = PstNotificationRecipient.list(0, 0, PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_RECIPIENT_AS] + " = " + index + " AND " + PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_NOTIFICATION_ID] + " = \"" + notificationId + "\"", "");

        if (listNotificationRecipientBCC.size() > 0) {
            for (int ixBCC = 0; ixBCC < listNotificationRecipientBCC.size(); ixBCC++) {
                NotificationRecipient notificationRecipientBCC = (NotificationRecipient) listNotificationRecipientBCC.get(ixBCC);
                rec.add(notificationRecipientBCC.getRecipientsEmail());
            }
        }
        return rec ;
    }
    
    public static boolean CheckedToday (String subject, String email){
        boolean tidakada = true; 
        Date todayX = new Date();
        
        Vector list = PstLogSysHistory.list(0, 0, PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME] + " = \"" + email + "\" AND " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DETAIL] + " = \"" + subject + "\" AND " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_TYPE] + " = \"Notification Service\" AND " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE] + " LIKE \"%" + Formater.formatDate(todayX, "yyyy-MM-dd") + "%\" ", "");
        
        if (list.size() > 0){
            tidakada = false;
        }        
        return tidakada ;
    }
    public static long EndContractNotification(Notification notification) {
        long value = 0;

        String timeDistance = notification.getTimeDistance();
        String[] partsOftimeDistance = timeDistance.split("-");
        String timeDistance30 = partsOftimeDistance[0];
        String timeDistance7 = partsOftimeDistance[1];
        String timeDistance1 = partsOftimeDistance[2];

        Date dateSend = new Date();
        Vector listEmp30 = new Vector();
        Vector listEmp7 = new Vector();
        Vector listEmp = new Vector(); 

        String endContractList30 = "";
        String endContractList7 = "";
        String endContractList = "";
        
        if (timeDistance30.equals("1")) {
            listEmp30 = EndContractSend(30);
            endContractList30 = listEmployeeTable(listEmp30);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp30.size() > 0) {
                    for (int i = 0; i < listEmp30.size(); i++) {
                        Employee employee = (Employee) listEmp30.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            messageText.replace("${LIST_END_CONTRACT}", endContractList30);
                            messageText.replace("${TIME_DISTANCE}", "30");
                            
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());
                            
                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance7.equals("1")) {
            listEmp7 = EndContractSend(7);
            endContractList7 = listEmployeeTable(listEmp7);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp7.size() > 0) {
                    for (int i = 0; i < listEmp7.size(); i++) {
                        Employee employee = (Employee) listEmp7.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());

                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            messageText.replace("${LIST_END_CONTRACT}", endContractList7);
                            messageText.replace("${TIME_DISTANCE}", "7");
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());

                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance1.equals("1")) {
            listEmp = EndContractSend(1);
            endContractList = listEmployeeTable(listEmp);
            
            //bypriska
            if (notification.getTargetEmployee() == 1) {
                if (listEmp.size() > 0) {
                    for (int i = 0; i < listEmp.size(); i++) {
                        Employee employee = (Employee) listEmp.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            messageText =  messageText.replace("${LIST_END_CONTRACT}", endContractList);
                            messageText = messageText.replace("${TIME_DISTANCE}", "1");
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());


                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        Vector listNotificationRecipient = PstNotificationRecipient.list(0, 0, PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_RECIPIENT_AS] + " = " + 0 + " AND " + PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_NOTIFICATION_ID] + " = \"" + notification.getOID() + "\"", "");
        if (listNotificationRecipient.size() > 0) {
            for (int ix = 0; ix < listNotificationRecipient.size(); ix++) {
                NotificationRecipient notificationRecipient = (NotificationRecipient) listNotificationRecipient.get(ix);
                try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(notificationRecipient.getRecipientsEmail());
                    String messageText = notification.getText();

                    
                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());
                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    boolean ada = CheckedToday(notification.getSubject(), notificationRecipient.getRecipientsEmail());
                            if (ada){
                                
                            if (timeDistance30.equals("1")){
                            String messageText30 = "";
                            messageText30 = messageText;
                            messageText30 = messageText30.replace("${LIST_END_CONTRACT}", endContractList30);
                            messageText30 = messageText30.replace("${TIME_DISTANCE}", "30");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText30, null, null);
                            }
                            if (timeDistance7.equals("1")){
                            String messageText7 = "";
                            messageText7 = messageText;
                            messageText7 = messageText7.replace("${LIST_END_CONTRACT}", endContractList7);
                            messageText7 = messageText7.replace("${TIME_DISTANCE}", "7");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText7, null, null);
                            }
                            
                            if (timeDistance1.equals("1")){
                            String messageText1 = "";
                            messageText1 = messageText;
                            messageText1 = messageText1.replace("${LIST_END_CONTRACT}", endContractList);
                            messageText1 = messageText1.replace("${TIME_DISTANCE}", "1");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText1, null, null);
                            }
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(notificationRecipient.getRecipientsEmail());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                            
                } catch (Exception e) {
                }
            }
        }
        
        if (!notification.getRecipientAdd().equals("")){
            String []parts = notification.getRecipientAdd().split("-");
            if (parts.length > 0){
                for (int s = 0; s < parts.length; s++){
                    String emails = parts[s];
                    
                    
                    try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(emails);
                    String messageText = notification.getText();

                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());

                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    
                    boolean ada = CheckedToday(notification.getSubject(), emails);
                            if (ada){
                            if (timeDistance30.equals("1")){
                            String messageText30 = "";
                            messageText30 = messageText;
                            messageText30 = messageText30.replace("${LIST_END_CONTRACT}", endContractList30);
                            messageText30 = messageText30.replace("${TIME_DISTANCE}", "30");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText30, null, null);
                            }
                            if (timeDistance7.equals("1")){
                            String messageText7 = "";
                            messageText7 = messageText;
                            messageText7 = messageText7.replace("${LIST_END_CONTRACT}", endContractList7);
                            messageText7 = messageText7.replace("${TIME_DISTANCE}", "7");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText7, null, null);
                            }
                            
                            if (timeDistance1.equals("1")){
                            String messageText1 = "";
                            messageText1 = messageText;
                            messageText1 = messageText1.replace("${LIST_END_CONTRACT}", endContractList);
                            messageText1 = messageText1.replace("${TIME_DISTANCE}", "1");
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText1, null, null);
                            }
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(emails);
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                } catch (Exception e) {
                }
                    
                    
                    
                }
            }
        }
        
        
        return value;
    }

    
    public static long BirthDateNotification(Notification notification) {
        long value = 0;

        String timeDistance = notification.getTimeDistance();
        String[] partsOftimeDistance = timeDistance.split("-");
        String timeDistance30 = partsOftimeDistance[0];
        String timeDistance7 = partsOftimeDistance[1];
        String timeDistance1 = partsOftimeDistance[2];

        Date dateSend = new Date();


        if (timeDistance30.equals("1")) {
            Vector listEmp30 = BirthDaySend(30);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp30.size() > 0) {
                    for (int i = 0; i < listEmp30.size(); i++) {
                        Employee employee = (Employee) listEmp30.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());
                            
                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance7.equals("1")) {
            Vector listEmp7 = BirthDaySend(7);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp7.size() > 0) {
                    for (int i = 0; i < listEmp7.size(); i++) {
                        Employee employee = (Employee) listEmp7.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());

                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());

                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance1.equals("1")) {
            Vector listEmp = BirthDaySend(1);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp.size() > 0) {
                    for (int i = 0; i < listEmp.size(); i++) {
                        Employee employee = (Employee) listEmp.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());


                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        Vector listNotificationRecipient = PstNotificationRecipient.list(0, 0, PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_RECIPIENT_AS] + " = " + 0 + " AND " + PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_NOTIFICATION_ID] + " = \"" + notification.getOID() + "\"", "");
        if (listNotificationRecipient.size() > 0) {
            for (int ix = 0; ix < listNotificationRecipient.size(); ix++) {
                NotificationRecipient notificationRecipient = (NotificationRecipient) listNotificationRecipient.get(ix);
                try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(notificationRecipient.getRecipientsEmail());
                    String messageText = notification.getText();

                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());

                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    
                    boolean ada = CheckedToday(notification.getSubject(), notificationRecipient.getRecipientsEmail());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(notificationRecipient.getRecipientsEmail());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                } catch (Exception e) {
                }
            }
        }
        
        if (!notification.getRecipientAdd().equals("")){
            String []parts = notification.getRecipientAdd().split("-");
            if (parts.length > 0){
                for (int s = 0; s < parts.length; s++){
                    String emails = parts[s];
                    
                    
                    try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(emails);
                    String messageText = notification.getText();

                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());

                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    
                    boolean ada = CheckedToday(notification.getSubject(), emails);
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(emails);
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                } catch (Exception e) {
                }
                    
                    
                    
                }
            }
        }
        
        
        return value;
    }
    
        public static long IdCardBirthdateNotification(Notification notification) {
        long value = 0;

        String timeDistance = notification.getTimeDistance();
        String[] partsOftimeDistance = timeDistance.split("-");
        String timeDistance30 = partsOftimeDistance[0];
        String timeDistance7 = partsOftimeDistance[1];
        String timeDistance1 = partsOftimeDistance[2];

        Date dateSend = new Date();


        if (timeDistance30.equals("1")) {
            Vector listEmp30 = IdCardExpiredSend(30);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp30.size() > 0) {
                    for (int i = 0; i < listEmp30.size(); i++) {
                        Employee employee = (Employee) listEmp30.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());
                            
                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance7.equals("1")) {
            Vector listEmp7 = IdCardExpiredSend(7);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp7.size() > 0) {
                    for (int i = 0; i < listEmp7.size(); i++) {
                        Employee employee = (Employee) listEmp7.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());

                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());

                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        if (timeDistance1.equals("1")) {
            Vector listEmp = IdCardExpiredSend(1);
            if (notification.getTargetEmployee() == 1) {
                if (listEmp.size() > 0) {
                    for (int i = 0; i < listEmp.size(); i++) {
                        Employee employee = (Employee) listEmp.get(i);


                        try {

                            Vector listRecTo = new Vector();
                            Vector recipientsCC = new Vector();
                            Vector recipientsBCC = new Vector();
                            listRecTo.add(employee.getEmailAddress());
                            String messageText = notification.getText();
                            messageText = TextConverter(messageText, employee);
                            //add cc
                            recipientsCC = RecipientCcBcc(1, notification.getOID());

                            //add bcc
                            recipientsBCC = RecipientCcBcc(2, notification.getOID());


                            boolean ada = CheckedToday(notification.getSubject(), employee.getEmailAddress());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(employee.getEmailAddress());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }

                        } catch (Exception e) {
                        }




                    }
                }
            }
        }
        Vector listNotificationRecipient = PstNotificationRecipient.list(0, 0, PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_RECIPIENT_AS] + " = " + 0 + " AND " + PstNotificationRecipient.fieldNames[PstNotificationRecipient.FLD_NOTIFICATION_ID] + " = \"" + notification.getOID() + "\"", "");
        if (listNotificationRecipient.size() > 0) {
            for (int ix = 0; ix < listNotificationRecipient.size(); ix++) {
                NotificationRecipient notificationRecipient = (NotificationRecipient) listNotificationRecipient.get(ix);
                try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(notificationRecipient.getRecipientsEmail());
                    String messageText = notification.getText();

                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());

                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    
                    boolean ada = CheckedToday(notification.getSubject(), notificationRecipient.getRecipientsEmail());
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(notificationRecipient.getRecipientsEmail());
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                } catch (Exception e) {
                }
            }
        }
        
        if (!notification.getRecipientAdd().equals("")){
            String []parts = notification.getRecipientAdd().split("-");
            if (parts.length > 0){
                for (int s = 0; s < parts.length; s++){
                    String emails = parts[s];
                    
                    
                    try {

                    Vector listRecTo = new Vector();
                    Vector recipientsCC = new Vector();
                    Vector recipientsBCC = new Vector();
                    listRecTo.add(emails);
                    String messageText = notification.getText();

                    //add cc
                    recipientsCC = RecipientCcBcc(1, notification.getOID());

                    //add bcc
                    recipientsBCC = RecipientCcBcc(2, notification.getOID());

                    
                    boolean ada = CheckedToday(notification.getSubject(), emails);
                            if (ada){
                            email.sendEmail(listRecTo, recipientsCC, recipientsBCC, notification.getSubject(), messageText, null, null);
                            
                            try {
                                LogSysHistory logSysHistory = new LogSysHistory();


                                logSysHistory.setLogLoginName(emails);
                                logSysHistory.setLogDocumentType("Notification Service");
                                logSysHistory.setLogDetail(notification.getSubject());
                                logSysHistory.setLogUpdateDate(dateSend);
                                long oid = PstLogSysHistory.insertExc(logSysHistory);
                            } catch (Exception e) {
                            }
                            }
                } catch (Exception e) {
                }
                    
                    
                    
                }
            }
        }
        
        
        return value;
    }
    

    public static Vector EndContractSend(int value) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        Date today = new Date();
        try {
            String sql = "SELECT * FROM " + PstEmployee.TBL_HR_EMPLOYEE;

            sql += " WHERE \"" + Formater.formatDate(today, "yyyy-MM-dd") + "\" = (`hr_employee`.`END_CONTRACT` -  INTERVAL '" + value + "' DAY)   ;";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                lists.add(employee);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();

    }

    public static Vector BirthDaySend(int value) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        Date today = new Date();
        try {
            String sql = "SELECT * FROM " + PstEmployee.TBL_HR_EMPLOYEE;

            sql += " WHERE \"" + Formater.formatDate(today, "yyyy-MM-dd") + "\" = (" + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + " -  INTERVAL '" + value + "' DAY)  ;";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                lists.add(employee);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();

    }

     public static Vector IdCardExpiredSend(int value) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        Date today = new Date();
        try {
            String sql = "SELECT * FROM " + PstEmployee.TBL_HR_EMPLOYEE;

            sql += " WHERE \"" + Formater.formatDate(today, "yyyy-MM-dd") + "\" = (" + PstEmployee.fieldNames[PstEmployee.FLD_ID_CARD_BIRTH_DATE] + " -  INTERVAL '" + value + "' DAY)  ;";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                lists.add(employee);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();

    }
    public static String TextConverter(String text, Employee employee) {
        String value = text;
        Hashtable HashtableEmp = new Hashtable();
        try {
            HashtableEmp = PstEmployee.fetchExcHashtable(employee.getOID());
        } catch (Exception ex) {
        }


        int startPositionOfFormula = 0;
        int endPositionOfFormula = 0;
        int x = 0;
        try {
            do {
                startPositionOfFormula = text.indexOf("${") + "${".length();
                endPositionOfFormula = text.indexOf("}", startPositionOfFormula);
                String subStringOfFormula = text.substring(startPositionOfFormula, endPositionOfFormula);

                String getString = (String) HashtableEmp.get(subStringOfFormula);

                value = value.replace("${" + subStringOfFormula + "}", getString);
                text = text.replace("${" + subStringOfFormula + "}", getString);

                startPositionOfFormula = text.indexOf("${") + "${".length();
                endPositionOfFormula = text.indexOf("}", startPositionOfFormula);
            } while (endPositionOfFormula > 0);
        } catch (Exception e) {
        }

        
        value = text;
        return value;
    }

    public static String listEmployeeTable(Vector listEmployee) {
        String headString = "<br><table border=\"1\" bordercolor=\"#333444\" style=\"width: 100%; background-color: #FFFFFF;\" cellpadding=\"1\" cellspacing=\"1\" > ";
               headString+= "<tr>";
               headString+= "<td bgcolor=\"#999999\" >Emp Num</td>";
               headString+= "<td bgcolor=\"#999999\" >Nama</td>";
               headString+= "<td bgcolor=\"#999999\" >Commencing Date</td>";
               headString+= "<tr>";
               
        try {
            if (listEmployee.size()>0){
                for (int xx = 0 ; xx < listEmployee.size(); xx++){
                    Employee employee = (Employee) listEmployee.get(xx);
                    headString+= "<tr><td>"+employee.getEmployeeNum()+"</td><td>"+employee.getFullName()+"</td><td>"+employee.getCommencingDate()+"</td><tr>";
               
                }
            }
        } catch (Exception e) {
        }
            headString+= "</table></br>";

        return headString ;
    }
    
    /**
     * @return the running
     */
    public boolean isRunning() {
        return running;
    }

    /**
     * @param running the running to set
     */
    public void setRunning(boolean running) {
        this.running = running;
        //update by satrya 2012-09-06
        // AbsenceAnalyser.setRunning(running);
    }

    /**
     * @return the progressSize
     */
    public int getProgressSize() {
        return progressSize > recordSize ? recordSize : progressSize;
    }

    /**
     * @return the recordSize
     */
    public int getRecordSize() {
        //System.out.println("=============================+++++++++======================");
        //System.out.println(recordSize);
        return recordSize;

    }

    /**
     * @return the sleepMs
     */
    public long getSleepMs() {
        return sleepMs;
    }

    /**
     * @param sleepMs the sleepMs to set
     */
    public void setSleepMs(long sleepMs) {
        this.sleepMs = sleepMs;
    }
    private javax.swing.JProgressBar jProgressBar = null;

    public void setProgressBar(javax.swing.JProgressBar jProgressBar) {
        this.jProgressBar = jProgressBar;
    }
    javax.swing.JTextArea jTextArea = null;

    public void setTextArea(javax.swing.JTextArea jTextAreaPar) {
        jTextArea = jTextAreaPar;
    }

    /**
     * @return the limitList
     */
    public int getLimitList() {
        return limitList;
    }

    /**
     * @param limitList the limitList to set
     */
    public void setLimitList(int limitList) {
        this.limitList = limitList;
    }

    /**
     * @return the fromDate
     */
    public Date getFromDate() {
        return fromDate;
    }

    /**
     * @param fromDate the fromDate to set
     */
    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    /**
     * @return the toDate
     */
    public Date getToDate() {
        return toDate;
    }

    /**
     * @param toDate the toDate to set
     */
    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    /**
     * @return the recordSizeAbsence
     */
    public int getRecordSizeAbsence() {
        return recordSizeAbsence;
    }

    /**
     * @param recordSizeAbsence the recordSizeAbsence to set
     */
    public void setRecordSizeAbsence(int recordSizeAbsence) {
        this.recordSizeAbsence = recordSizeAbsence;

    }

    /**
     * @return the progressSizeAbsence
     */
    public int getProgressSizeAbsence() {
        //return progressSizeAbsence;
        return progressSizeAbsence > recordSizeAbsence ? recordSizeAbsence : progressSizeAbsence;
    }

    /**
     * @param progressSizeAbsence the progressSizeAbsence to set
     */
    public void setProgressSizeAbsence(int progressSizeAbsence) {
        this.progressSizeAbsence = progressSizeAbsence;
    }
}