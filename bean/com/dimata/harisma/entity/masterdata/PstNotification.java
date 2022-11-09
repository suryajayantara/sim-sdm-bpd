/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Utk
 */
import com.dimata.harisma.entity.employee.EmpReprimand;
import com.dimata.harisma.entity.employee.EmpWarning;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmpReprimand;
import com.dimata.harisma.entity.employee.PstEmpWarning;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.Notification;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

public class PstNotification extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_NOTIFICATION = "hr_master_notification";
    public static final int FLD_NOTIFICATION_ID = 0;
    public static final int FLD_NOTIFICATION_TYPE = 1;
    public static final int FLD_NOTIFICATION_DAYS = 2;
    public static final int FLD_NOTIFICATION_STATUS = 3;
    public static final int FLD_SPECIAL_CASE = 4;

    public static final int STATUS_ACTIVE = 0;
    public static final int STATUS_NON_ACTIVE = 1;

    public static final String[] StatusValue = {
        "Aktif", "Non Aktif"
    };

    public static final int NOTIF_KARYAWAN_HABIS_KONTRAK = 0;
    public static final int NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR = 1;
    public static final int NOTIF_PENGHARAGAAN_KARYAWAN = 2;
    public static final int NOTIF_KARYAWAN_MBT = 3;
    public static final int NOTIF_KARYAWAN_PENSIUN = 4;
    public static final int NOTIF_KARYAWAN_PEJABAT_SEMENTARA = 5;
    public static final int NOTIF_ULANG_TAHUN_KARYAWAN = 6;
    public static final int NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU = 7;
    public static final int NOTIF_BEARKHIRNYA_SERTIFIKASI = 8;
    public static final int NOTIF_STOK_CUTI_MINUS = 9;
    public static final int NOTIF_VALID_UNTIL_WARNING = 10;
    public static final int NOTIF_VALID_UNTIL_REPRIMAND =11;

    public static final String[] NotificationType = {
        "Notifikasi Karyawan yang akan habis kontrak", //1
        "Notifikasi Pembayaran Cuti Tahunan/Cuti Besar", //2
        "Notifikasi Penghargaan Karyawan (15 Tahun, 25 Tahun, 30 Tahun dan 35 Tahun)", //3
        "Notifikasi Karyawan yang akan Memasuki masa MBT", //4
        "Notifikasi Karyawan yang akan memasuki masa Pensiun", //5
        "Notifikasi Karyawan Pejabat Sementara", //6
        "Notifikasi Ulang Tahun Karyawan", //7
        "Notifikasi Lama Jabatan", //8
        "Notifikasi Berakhirnya Sertifikasi tertentu", //9
        "Notifikasi Stok Cuti Minus",
        "Notifikasi Valid Until Peringatan Karyawan",
        "Notifikasi Valid Untul Teguran Karyawan"

    };

    public static String[] fieldNames = {
        "NOTIFICATION_ID",
        "NOTIFICATION_TYPE",
        "NOTIFICATION_DAYS",
        "NOTIFICATION_STATUS",
        "SPECIAL_CASE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public PstNotification() {
    }

    public PstNotification(int i) throws DBException {
        super(new PstNotification());
    }

    public PstNotification(String sOid) throws DBException {
        super(new PstNotification(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstNotification(long lOid) throws DBException {
        super(new PstNotification(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_NOTIFICATION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstNotification().getClass().getName();
    }

    public static Notification fetchExc(long oid) throws DBException {
        try {
            Notification entNotification = new Notification();
            PstNotification pstNotification = new PstNotification(oid);
            entNotification.setOID(oid);
            entNotification.setNotificationType(pstNotification.getInt(FLD_NOTIFICATION_TYPE));
            entNotification.setNotificationDays(pstNotification.getInt(FLD_NOTIFICATION_DAYS));
            entNotification.setNotificationStatus(pstNotification.getInt(FLD_NOTIFICATION_STATUS));
            entNotification.setSpecialCase(pstNotification.getInt(FLD_SPECIAL_CASE));
            return entNotification;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotification(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Notification entNotification = fetchExc(entity.getOID());
        entity = (Entity) entNotification;
        return entNotification.getOID();
    }

    public static synchronized long updateExc(Notification entNotification) throws DBException {
        try {
            if (entNotification.getOID() != 0) {
                PstNotification pstNotification = new PstNotification(entNotification.getOID());
                pstNotification.setInt(FLD_NOTIFICATION_TYPE, entNotification.getNotificationType());
                pstNotification.setInt(FLD_NOTIFICATION_DAYS, entNotification.getNotificationDays());
                pstNotification.setInt(FLD_NOTIFICATION_STATUS, entNotification.getNotificationStatus());
                pstNotification.setInt(FLD_SPECIAL_CASE, entNotification.getSpecialCase());
                pstNotification.update();
                return entNotification.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotification(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Notification) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstNotification pstNotification = new PstNotification(oid);
            pstNotification.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotification(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Notification entNotification) throws DBException {
        try {
            PstNotification pstNotification = new PstNotification(0);
            pstNotification.setInt(FLD_NOTIFICATION_TYPE, entNotification.getNotificationType());
            pstNotification.setInt(FLD_NOTIFICATION_DAYS, entNotification.getNotificationDays());
            pstNotification.setInt(FLD_NOTIFICATION_STATUS, entNotification.getNotificationStatus());
            pstNotification.setInt(FLD_SPECIAL_CASE, entNotification.getSpecialCase());
            pstNotification.insert();
            entNotification.setOID(pstNotification.getlong(FLD_NOTIFICATION_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstNotification(0), DBException.UNKNOWN);
        }
        return entNotification.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Notification) entity);
    }

    public static void resultToObject(ResultSet rs, Notification entNotification) {
        try {
            entNotification.setOID(rs.getLong(PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID]));
            entNotification.setNotificationType(rs.getInt(PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_TYPE]));
            entNotification.setNotificationDays(rs.getInt(PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_DAYS]));
            entNotification.setNotificationStatus(rs.getInt(PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_STATUS]));
            entNotification.setSpecialCase(rs.getInt(PstNotification.fieldNames[PstNotification.FLD_SPECIAL_CASE]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_NOTIFICATION;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Notification entNotification = new Notification();
                resultToObject(rs, entNotification);
                lists.add(entNotification);
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

    public static Vector listJoin(long userId) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_NOTIFICATION + " AS nf INNER JOIN "
                    + PstNotificationMapping.TBL_NOTIFICATIONMAPPING + " AS map ON nf.NOTIFICATION_ID = map.NOTIFICATION_ID AND map.USER_ID=" + userId + " AND nf.NOTIFICATION_STATUS = 0";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Notification entNotification = new Notification();
                resultToObject(rs, entNotification);
                lists.add(entNotification);
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

    public static boolean checkPrivNotification(long userId, int notificationType) {
        boolean status = false;
        // 1 = oke, 0 = don't have priv  
        try {
            String whereClauseNotifMapping = " " + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_USER_ID] + " = " + userId;
            Vector listNotifMapping = (Vector) PstNotificationMapping.list(0, 0, whereClauseNotifMapping, "");

            for (int x = 0; x < listNotifMapping.size(); x++) {
                NotificationMapping notificationMapping = (NotificationMapping) listNotifMapping.get(x);
                String whereClauseNotif = " " + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID] + " = " + notificationMapping.getNotificationId();
                Vector listNotif = (Vector) PstNotification.list(0, 0, whereClauseNotif, "");
                for (int y = 0; y < listNotif.size(); y++) {
                    Notification notification = (Notification) listNotif.get(y);
                    if (notification.getNotificationStatus() == PstNotification.STATUS_ACTIVE && notification.getNotificationType() == notificationType) {
                        status = true;
                    }
                }
            }
        } catch (Exception exc) {
            System.out.println("Error Check Priv Notification :" + exc);
            status = false;
        }
        return status;

    }

    public static int checkLenghtNotifByUser(long userId, int notificationType, long notificationId) {
        int day = 0;
        // 1 = oke, 0 = don't have priv  
        try {
            String whereClauseNotifMapping = " " + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_USER_ID] + " = " + userId + " AND "
                    + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID] + " = " + notificationId;
            Vector listNotifMapping = (Vector) PstNotificationMapping.list(0, 0, whereClauseNotifMapping, "");

            for (int x = 0; x < listNotifMapping.size(); x++) {
                NotificationMapping notificationMapping = (NotificationMapping) listNotifMapping.get(x);
                String whereClauseNotif = " " + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID] + " = " + notificationMapping.getNotificationId();
                Vector listNotif = (Vector) PstNotification.list(0, 0, whereClauseNotif, "");
                for (int y = 0; y < listNotif.size(); y++) {
                    Notification notification = (Notification) listNotif.get(y);
                    if (notification.getNotificationStatus() == PstNotification.STATUS_ACTIVE && notification.getNotificationType() == notificationType) {
                        day = notification.getNotificationDays();
                    }
                }
            }
        } catch (Exception exc) {
            System.out.println("Error Check Priv Notification :" + exc);
            day = 0;
        }
        return day;

    }

    public static String getUserDivisionMap(int notificationType, long notificationId) {
        String inDivision = "";
        // 1 = oke, 0 = don't have priv  
        try {
            String whereClauseNotifMappingDivision = PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID] + " = " + notificationId;
            Vector listNotifMapping = (Vector) PstNotificationMappingDivision.list(0, 0, whereClauseNotifMappingDivision, "");

            for (int x = 0; x < listNotifMapping.size(); x++) {
                NotificationMappingDivision notificationMapping = (NotificationMappingDivision) listNotifMapping.get(x);
                if (inDivision.length() > 0) {
                    inDivision += ",";
                }
                inDivision += "" + notificationMapping.getDivisionId();

            }
        } catch (Exception exc) {
            System.out.println("Error Check Priv Notification :" + exc);
        }
        return inDivision;

    }

    public static int checkSpecialCaseNotifByUser(long userId, int notificationType, long notificationId) {
        int day = 0;
        // 1 = oke, 0 = don't have priv  
        try {
            String whereClauseNotifMapping = " " + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_USER_ID] + " = " + userId + " AND "
                    + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID] + " = " + notificationId;
            Vector listNotifMapping = (Vector) PstNotificationMapping.list(0, 0, whereClauseNotifMapping, "");

            for (int x = 0; x < listNotifMapping.size(); x++) {
                NotificationMapping notificationMapping = (NotificationMapping) listNotifMapping.get(x);
                String whereClauseNotif = " " + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID] + " = " + notificationMapping.getNotificationId();
                Vector listNotif = (Vector) PstNotification.list(0, 0, whereClauseNotif, "");
                for (int y = 0; y < listNotif.size(); y++) {
                    Notification notification = (Notification) listNotif.get(y);
                    if (notification.getNotificationStatus() == PstNotification.STATUS_ACTIVE && notification.getNotificationType() == notificationType) {
                        day = notification.getSpecialCase();
                    }
                }
            }
        } catch (Exception exc) {
            System.out.println("Error Check Priv Notification :" + exc);
            day = 0;
        }
        return day;

    }

    public static int checkSpecialCase(long userId, int notificationType) {
        int day = 0;
        // 1 = oke, 0 = don't have priv  
        try {
            String whereClauseNotifMapping = " " + PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_USER_ID] + " = " + userId;
            Vector listNotifMapping = (Vector) PstNotificationMapping.list(0, 0, whereClauseNotifMapping, "");

            for (int x = 0; x < listNotifMapping.size(); x++) {
                NotificationMapping notificationMapping = (NotificationMapping) listNotifMapping.get(x);
                String whereClauseNotif = " " + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID] + " = " + notificationMapping.getNotificationId();
                Vector listNotif = (Vector) PstNotification.list(0, 0, whereClauseNotif, "");
                for (int y = 0; y < listNotif.size(); y++) {
                    Notification notification = (Notification) listNotif.get(y);
                    if (notification.getNotificationStatus() == PstNotification.STATUS_ACTIVE && notification.getNotificationType() == notificationType) {
                        day = notification.getNotificationDays();
                    }
                }
            }
        } catch (Exception exc) {
            System.out.println("Error Check Priv Notification :" + exc);
            day = 0;
        }
        return day;

    }

    public static boolean checkOID(long entNotificationId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_NOTIFICATION + " WHERE "
                    + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_TYPE] + " = " + entNotificationId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_TYPE] + ") FROM " + TBL_NOTIFICATION;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Notification entNotification = (Notification) list.get(ls);
                    if (oid == entNotification.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }
        return start;
    }

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
    
    public static int countEmpLeaveMinus(String where){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                        + "COUNT(emp.EMPLOYEE_ID) "
                    + "FROM "
                        + "(SELECT "
                            + "EMPLOYEE_ID, "
                            + "(AL_QTY - QTY_USED) AS STOK "
                        + "FROM "
                            + "hr_al_stock_management "
                            + "WHERE AL_STATUS = 0 "
                        + "UNION "
                        + "SELECT "
                            + "EMPLOYEE_ID, "
                            + "(LL_QTY - QTY_USED) AS STOK "
                        + "FROM "
                            + "hr_ll_stock_management "
                            + "WHERE LL_STATUS = 0) AS dt "
                    + "INNER JOIN hr_employee as emp "
                    + "ON dt.EMPLOYEE_ID = emp.EMPLOYEE_ID "
                    + "WHERE emp.RESIGNED = 0 AND STOK < 0 "+where;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static int countEmpWarningNotif(String where){
        DBResultSet dbrs = null;
        try {
             String sql = "SELECT count(warn.WARNING_ID) FROM `hr_warning` warn " +
                            "INNER JOIN hr_employee emp " +
                            "ON warn.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` " +
                            "WHERE emp.RESIGNED = 0 AND "+where;
            sql += " ORDER BY warn.`VALID_UNTIL` ASC ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    
      public static Vector listEmpWarningNotif(String where){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT warn.* FROM `hr_warning` warn " +
                            "INNER JOIN hr_employee emp " +
                            "ON warn.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` " +
                            "WHERE emp.RESIGNED = 0 AND "+where;
            sql += " ORDER BY warn.`VALID_UNTIL` ASC ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector lists = new Vector();
            while (rs.next()) {
                EmpWarning empWarn = new EmpWarning();
                PstEmpWarning.resultToObject(rs, empWarn);
                lists.add(empWarn);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            return new Vector();
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static int countEmpReprimandNotif(String where){
        DBResultSet dbrs = null;
        try {
             String sql = "SELECT count(reprimand.REPRIMAND_ID) FROM `hr_reprimand` reprimand " +
                            "INNER JOIN hr_employee emp " +
                            "ON reprimand.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` " +
                            "WHERE emp.RESIGNED = 0 AND "+where;
            sql += " ORDER BY reprimand.`VALID_UNTIL` ASC ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    
      public static Vector listEmpReprimandNotif(String where){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT reprimand.* FROM `hr_reprimand` reprimand " +
                            "INNER JOIN hr_employee emp " +
                            "ON reprimand.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` " +
                            "WHERE emp.RESIGNED = 0 AND "+where;
            sql += " ORDER BY reprimand.`VALID_UNTIL` ASC ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector lists = new Vector();
            while (rs.next()) {
                EmpReprimand empReprimand = new EmpReprimand();
                PstEmpReprimand.resultToObject(rs, empReprimand);
                lists.add(empReprimand);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            return new Vector();
        } finally {
            DBResultSet.close(dbrs);
        }
    }
      
    public static Vector listEmpStockMinus(String where){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                        + "emp.*,"
                        + "ROUND(STOK,0) AS STOK "
                    + "FROM "
                        + "(SELECT "
                            + "EMPLOYEE_ID, "
                            + "(AL_QTY - QTY_USED) AS STOK "
                        + "FROM "
                            + "hr_al_stock_management "
                            + "WHERE AL_STATUS = 0 "
                        + "UNION "
                        + "SELECT "
                            + "EMPLOYEE_ID, "
                            + "(LL_QTY - QTY_USED) AS STOK "
                        + "FROM "
                            + "hr_ll_stock_management "
                            + "WHERE LL_STATUS = 0) AS dt "
                    + "INNER JOIN hr_employee as emp "
                    + "ON dt.EMPLOYEE_ID = emp.EMPLOYEE_ID "
                    + "WHERE emp.RESIGNED = 0 AND STOK < 0 "+where;
            sql += " ORDER BY STOK ASC";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector lists = new Vector();
            while (rs.next()) {
                Vector temp = new Vector();
                Employee emp = new Employee();
                PstEmployee.resultToObject(rs, emp);
                temp.add(emp);
                
                String stok = rs.getString("STOK");
                temp.add(stok);
                lists.add(temp);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            return new Vector();
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
}
