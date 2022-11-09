/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.leave;

/**
 *
 * @author mchen
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

public class PstMessageEmp extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_MESSAGE_EMP = "hr_message_emp";
    public static final int FLD_MESSAGE_EMP_ID = 0;
    public static final int FLD_MESSAGE = 1;
    public static final int FLD_MESSAGE_DATE = 2;
    public static final int FLD_EMPLOYEE_ID = 3;
    public static final int FLD_LEAVE_APPLICATION_ID = 4;

    public static String[] fieldNames = {
        "MESSAGE_EMP_ID",
        "MESSAGE",
        "MESSAGE_DATE",
        "EMPLOYEE_ID",
        "LEAVE_APPLICATION_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstMessageEmp() {
    }

    public PstMessageEmp(int i) throws DBException {
        super(new PstMessageEmp());
    }

    public PstMessageEmp(String sOid) throws DBException {
        super(new PstMessageEmp(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstMessageEmp(long lOid) throws DBException {
        super(new PstMessageEmp(0));
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
        return TBL_MESSAGE_EMP;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMessageEmp().getClass().getName();
    }

    public static MessageEmp fetchExc(long oid) throws DBException {
        try {
            MessageEmp entMessageEmp = new MessageEmp();
            PstMessageEmp pstMessageEmp = new PstMessageEmp(oid);
            entMessageEmp.setOID(oid);
            entMessageEmp.setMessage(pstMessageEmp.getString(FLD_MESSAGE));
            entMessageEmp.setMessageDate(pstMessageEmp.getDate(FLD_MESSAGE_DATE));
            entMessageEmp.setEmployeeId(pstMessageEmp.getLong(FLD_EMPLOYEE_ID));
            entMessageEmp.setLeaveId(pstMessageEmp.getLong(FLD_LEAVE_APPLICATION_ID));
            return entMessageEmp;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageEmp(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        MessageEmp entMessageEmp = fetchExc(entity.getOID());
        entity = (Entity) entMessageEmp;
        return entMessageEmp.getOID();
    }

    public static synchronized long updateExc(MessageEmp entMessageEmp) throws DBException {
        try {
            if (entMessageEmp.getOID() != 0) {
                PstMessageEmp pstMessageEmp = new PstMessageEmp(entMessageEmp.getOID());
                pstMessageEmp.setString(FLD_MESSAGE, entMessageEmp.getMessage());
                pstMessageEmp.setDate(FLD_MESSAGE_DATE, entMessageEmp.getMessageDate());
                pstMessageEmp.setLong(FLD_EMPLOYEE_ID, entMessageEmp.getEmployeeId());
                pstMessageEmp.setLong(FLD_LEAVE_APPLICATION_ID, entMessageEmp.getLeaveId());
                pstMessageEmp.update();
                return entMessageEmp.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageEmp(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((MessageEmp) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstMessageEmp pstMessageEmp = new PstMessageEmp(oid);
            pstMessageEmp.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageEmp(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(MessageEmp entMessageEmp) throws DBException {
        try {
            PstMessageEmp pstMessageEmp = new PstMessageEmp(0);
            pstMessageEmp.setString(FLD_MESSAGE, entMessageEmp.getMessage());
            pstMessageEmp.setDate(FLD_MESSAGE_DATE, entMessageEmp.getMessageDate());
            pstMessageEmp.setLong(FLD_EMPLOYEE_ID, entMessageEmp.getEmployeeId());
            pstMessageEmp.setLong(FLD_LEAVE_APPLICATION_ID, entMessageEmp.getLeaveId());
            pstMessageEmp.insert();
            entMessageEmp.setOID(pstMessageEmp.getLong(FLD_MESSAGE_EMP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMessageEmp(0), DBException.UNKNOWN);
        }
        return entMessageEmp.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((MessageEmp) entity);
    }

    public static void resultToObject(ResultSet rs, MessageEmp entMessageEmp) {
        try {
            entMessageEmp.setOID(rs.getLong(PstMessageEmp.fieldNames[PstMessageEmp.FLD_MESSAGE_EMP_ID]));
            entMessageEmp.setMessage(rs.getString(PstMessageEmp.fieldNames[PstMessageEmp.FLD_MESSAGE]));
            entMessageEmp.setMessageDate(rs.getDate(PstMessageEmp.fieldNames[PstMessageEmp.FLD_MESSAGE_DATE]));
            entMessageEmp.setEmployeeId(rs.getLong(PstMessageEmp.fieldNames[PstMessageEmp.FLD_EMPLOYEE_ID]));
            entMessageEmp.setLeaveId(rs.getLong(PstMessageEmp.fieldNames[PstMessageEmp.FLD_LEAVE_APPLICATION_ID]));
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
            String sql = "SELECT * FROM " + TBL_MESSAGE_EMP;
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
                MessageEmp entMessageEmp = new MessageEmp();
                resultToObject(rs, entMessageEmp);
                lists.add(entMessageEmp);
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

    public static boolean checkOID(long entMessageEmpId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_MESSAGE_EMP + " WHERE "
                    + PstMessageEmp.fieldNames[PstMessageEmp.FLD_MESSAGE_EMP_ID] + " = " + entMessageEmpId;
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
            String sql = "SELECT COUNT(" + PstMessageEmp.fieldNames[PstMessageEmp.FLD_MESSAGE_EMP_ID] + ") FROM " + TBL_MESSAGE_EMP;
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
                    MessageEmp entMessageEmp = (MessageEmp) list.get(ls);
                    if (oid == entMessageEmp.getOID()) {
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
