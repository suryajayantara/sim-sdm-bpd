/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.log;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstMessageLog extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_MESSAGE_LOG = "hr_message_log";
    public static final int FLD_MESSAGE_LOG_ID = 0;
    public static final int FLD_ENTITY_NAME = 1;
    public static final int FLD_ENTITY_ID = 2;
    public static final int FLD_USER_ID = 3;
    public static final int FLD_LOG_ID = 4;
    public static final int FLD_STATUS_LOG = 5;
    public static String[] fieldNames = {
        "MESSAGE_LOG_ID",
        "ENTITY_NAME",
        "ENTITY_ID",
        "USER_ID",
        "LOG_ID",
        "STATUS_LOG"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };

    public PstMessageLog() {
    }

    public PstMessageLog(int i) throws DBException {
        super(new PstMessageLog());
    }

    public PstMessageLog(String sOid) throws DBException {
        super(new PstMessageLog(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstMessageLog(long lOid) throws DBException {
        super(new PstMessageLog(0));
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
        return TBL_MESSAGE_LOG;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMessageLog().getClass().getName();
    }

    public static MessageLog fetchExc(long oid) throws DBException {
        try {
            MessageLog entMessageLog = new MessageLog();
            PstMessageLog pstMessageLog = new PstMessageLog(oid);
            entMessageLog.setOID(oid);
            entMessageLog.setEntityName(pstMessageLog.getString(FLD_ENTITY_NAME));
            entMessageLog.setEntityId(pstMessageLog.getLong(FLD_ENTITY_ID));
            entMessageLog.setUserId(pstMessageLog.getLong(FLD_USER_ID));
            entMessageLog.setLogId(pstMessageLog.getLong(FLD_LOG_ID));
            entMessageLog.setStatusLog(pstMessageLog.getInt(FLD_STATUS_LOG));
            return entMessageLog;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageLog(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        MessageLog entMessageLog = fetchExc(entity.getOID());
        entity = (Entity) entMessageLog;
        return entMessageLog.getOID();
    }

    public static synchronized long updateExc(MessageLog entMessageLog) throws DBException {
        try {
            if (entMessageLog.getOID() != 0) {
                PstMessageLog pstMessageLog = new PstMessageLog(entMessageLog.getOID());
                pstMessageLog.setString(FLD_ENTITY_NAME, entMessageLog.getEntityName());
                pstMessageLog.setLong(FLD_ENTITY_ID, entMessageLog.getEntityId());
                pstMessageLog.setLong(FLD_USER_ID, entMessageLog.getUserId());
                pstMessageLog.setLong(FLD_LOG_ID, entMessageLog.getLogId());
                pstMessageLog.setInt(FLD_STATUS_LOG, entMessageLog.getStatusLog());
                pstMessageLog.update();
                return entMessageLog.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageLog(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((MessageLog) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstMessageLog pstMessageLog = new PstMessageLog(oid);
            pstMessageLog.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageLog(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(MessageLog entMessageLog) throws DBException {
        try {
            PstMessageLog pstMessageLog = new PstMessageLog(0);
            pstMessageLog.setString(FLD_ENTITY_NAME, entMessageLog.getEntityName());
            pstMessageLog.setLong(FLD_ENTITY_ID, entMessageLog.getEntityId());
            pstMessageLog.setLong(FLD_USER_ID, entMessageLog.getUserId());
            pstMessageLog.setLong(FLD_LOG_ID, entMessageLog.getLogId());
            pstMessageLog.setInt(FLD_STATUS_LOG, entMessageLog.getStatusLog());
            pstMessageLog.insert();
            entMessageLog.setOID(pstMessageLog.getLong(FLD_MESSAGE_LOG_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageLog(0), DBException.UNKNOWN);
        }
        return entMessageLog.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((MessageLog) entity);
    }

    public static void resultToObject(ResultSet rs, MessageLog entMessageLog) {
        try {
            entMessageLog.setOID(rs.getLong(PstMessageLog.fieldNames[PstMessageLog.FLD_MESSAGE_LOG_ID]));
            entMessageLog.setEntityName(rs.getString(PstMessageLog.fieldNames[PstMessageLog.FLD_ENTITY_NAME]));
            entMessageLog.setEntityId(rs.getLong(PstMessageLog.fieldNames[PstMessageLog.FLD_ENTITY_ID]));
            entMessageLog.setUserId(rs.getLong(PstMessageLog.fieldNames[PstMessageLog.FLD_USER_ID]));
            entMessageLog.setLogId(rs.getLong(PstMessageLog.fieldNames[PstMessageLog.FLD_LOG_ID]));
            entMessageLog.setStatusLog(rs.getInt(PstMessageLog.fieldNames[PstMessageLog.FLD_STATUS_LOG]));
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
            String sql = "SELECT * FROM " + TBL_MESSAGE_LOG;
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
                MessageLog entMessageLog = new MessageLog();
                resultToObject(rs, entMessageLog);
                lists.add(entMessageLog);
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

    public static boolean checkOID(long entMessageLogId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_MESSAGE_LOG + " WHERE "
                    + PstMessageLog.fieldNames[PstMessageLog.FLD_MESSAGE_LOG_ID] + " = " + entMessageLogId;
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
            String sql = "SELECT COUNT(" + PstMessageLog.fieldNames[PstMessageLog.FLD_MESSAGE_LOG_ID] + ") FROM " + TBL_MESSAGE_LOG;
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
                    MessageLog entMessageLog = (MessageLog) list.get(ls);
                    if (oid == entMessageLog.getOID()) {
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
}
