/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.log;

import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.harisma.entity.admin.AppGroup;
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppGroup;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.CareerPath;
import com.dimata.harisma.entity.employee.EmpAssessment;
import com.dimata.harisma.entity.employee.EmpEducation;
import com.dimata.harisma.entity.employee.EmpLanguage;
import com.dimata.harisma.entity.employee.EmpPowerCharacter;
import com.dimata.harisma.entity.employee.EmpReprimand;
import com.dimata.harisma.entity.employee.EmpWarning;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.Experience;
import com.dimata.harisma.entity.employee.FamilyMember;
import com.dimata.harisma.entity.employee.PstCareerPath;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.PstFamilyMember;
import com.dimata.harisma.entity.employee.TrainingHistory;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.payroll.PaySlipGroup;
import com.dimata.harisma.entity.payroll.PstPaySlipGroup;
import com.dimata.util.Formater;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class SessHistoryLog {
    
    public static int STATUS_FAILED   = 0;
    public static int STATUS_SUCCESS  = 1;
    
    public static int insertNDeleteEmployee (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      Employee newEmployee = (Employee) req.getAttribute("InsertEmployee");
      Employee delEmployee = (Employee) req.getAttribute("DeleteEmployee");
      String query = (String) req.getAttribute("query");
      if(newEmployee == null){
          newEmployee = delEmployee;
      }
        String reqUrl = req.getRequestURI().toString() + "?employee_oid=" + newEmployee.getOID();
        String className = newEmployee.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Personal Data");
        if(delEmployee == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newEmployee.getOID());
        logSysHistory.setLogEditedUserId(newEmployee.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newEmployee != null) {
             
             jsonString += "{\"Penggajian\" : \""+newEmployee.getEmployeeNum()+"\"}, ";
             jsonString += "{\"Nama Lengkap\" : \""+newEmployee.getFullName()+"\"}, ";
             jsonString += "{\"Nama Pada KTP\" : \""+newEmployee.getNameCard()+"\"}, ";
             jsonString += "{\"Alamat Sementara\" : \""+newEmployee.getAddress()+"\"}, ";
             jsonString += "{\"Alamat Tetap\" : \""+newEmployee.getAddressPermanent()+"\"}, ";
             jsonString += "{\"Kode Pos\" : \""+newEmployee.getPostalCode()+"\"}, ";
             jsonString += "{\"Telephone\" : \""+newEmployee.getPhone()+"\"}, ";
             jsonString += "{\"HP\" : \""+newEmployee.getHandphone()+"\"}, ";
             jsonString += "{\"Nomor Darurat\" : \""+newEmployee.getPhoneEmergency()+"\"}, ";
             jsonString += "{\"Nama Darurat\" : \""+newEmployee.getNameEmg()+"\"}, ";
             jsonString += "{\"Alamat Darurat\" : \""+newEmployee.getAddressEmg()+"\"}, ";
             jsonString += "{\"Jenis Kelamin\" : \""+(newEmployee.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
             jsonString += "{\"Tempat Lahir\" : \""+newEmployee.getBirthPlace()+"\"}, ";
             jsonString += "{\"Tanggal Lahir\" : \""+f2DateStr(newEmployee.getBirthDate())+"\"}, ";
             jsonString += "{\"Agama\" : \""+getReligionName(newEmployee.getReligionId())+"\"}, ";
             jsonString += "{\"Status Perkawinan\" : \""+getMaritalName(newEmployee.getMaritalId())+"\"}, ";
             jsonString += "{\"Status Perkawinan Untuk Pajak\" : \""+getMaritalName(newEmployee.getTaxMaritalId())+"\"}, ";
             jsonString += "{\"Golongan Darah\" : \""+newEmployee.getBloodType()+"\"}, ";
             jsonString += "{\"Suku\" : \""+getRaceName(newEmployee.getRace())+"\"}, ";
             jsonString += "{\"Nationality\" : \""+getNationality(newEmployee.getNationalityId())+"\"}, ";
             jsonString += "{\"Nomor Barcode\" : \""+newEmployee.getBarcodeNumber()+"\"}, ";
             jsonString += "{\"Nomor Kartu Identitas\" : \""+newEmployee.getIndentCardNr()+"\"}, ";
             jsonString += "{\"Jenis Kartu Identitas\" : \""+newEmployee.getIdcardtype()+"\"}, ";
             jsonString += "{\"Kartu Identitas Berlaku Sampai\" : \""+f2DateStr(newEmployee.getIndentCardValidTo())+"\"}, ";
             jsonString += "{\"Email\" : \""+newEmployee.getEmailAddress()+"\"}, ";
             jsonString += "{\"IQ\" : \""+newEmployee.getIq()+"\"}, ";
             jsonString += "{\"EQ\" : \""+newEmployee.getEq()+"\"}, ";
             jsonString += "{\"Nomor Rekening\" : \""+newEmployee.getNoRekening()+"\"}, ";
             jsonString += "{\"NPWP\" : \""+newEmployee.getNpwp()+"\"}, ";
             jsonString += "{\"Nama Ayah\" : \""+newEmployee.getFather()+"\"}, ";
             jsonString += "{\"Nama Ibu\" : \""+newEmployee.getMother()+"\"}, ";
             jsonString += "{\"Alamat Orang Tua\" : \""+newEmployee.getParentsAddress()+"\"}, ";
             jsonString += "{\"Perusahaan\" : \""+getCompanyName(newEmployee.getCompanyId())+"\"}, ";
             jsonString += "{\"Satuan Kerja\" : \""+getDivisionName(newEmployee.getDivisionId())+"\"}, ";
             jsonString += "{\"Unit\" : \""+getDepartmentName(newEmployee.getDepartmentId())+"\"}, ";
             jsonString += "{\"Sub Unit\" : \""+getSectionName(newEmployee.getSectionId())+"\"}, ";
             jsonString += "{\"Karyawan Kategori\" : \""+getEmpCategoryName(newEmployee.getEmpCategoryId())+"\"}, ";
             jsonString += "{\"Level\" : \""+getLevelName(newEmployee.getLevelId())+"\"}, ";
             jsonString += "{\"Grade\" : \""+getGrade(newEmployee.getGradeLevelId())+"\"}, ";
             jsonString += "{\"Jabatan\" : \""+getPositionName(newEmployee.getPositionId())+"\"}, ";
             jsonString += "{\"Tipe Karir\" : \""+PstCareerPath.historyType[newEmployee.getHistoryType()]+"\"}, ";
             jsonString += "{\"Group Karir\" : \""+PstCareerPath.historyGroup[newEmployee.getHistoryGroup()]+"\"}, ";
             jsonString += "{\"W.A. Perusahaan\" : \""+getCompanyName(newEmployee.getWorkassigncompanyId())+"\"}, ";
             jsonString += "{\"W.A. Satuan Kerja\" : \""+getDivisionName(newEmployee.getWorkassigndivisionId())+"\"}, ";
             jsonString += "{\"W.A. Unit\" : \""+getDepartmentName(newEmployee.getWorkassigndepartmentId())+"\"}, ";
             jsonString += "{\"W.A. Sub Unit\" : \""+getSectionName(newEmployee.getWorkassignsectionId())+"\"}, ";
             jsonString += "{\"W.A. Jabatan\" : \""+getPositionName(newEmployee.getWorkassignpositionId())+"\"}, ";
             jsonString += "{\"W.A. Penyedia\" : \""+getContactName(newEmployee.getProviderID())+"\"}, ";
             jsonString += "{\"Mulai Bekerja\" : \""+f2DateStr(newEmployee.getCommencingDate())+"\"}, ";
             jsonString += "{\"Akhir Masa Percobaan\" : \""+f2DateStr(newEmployee.getProbationEndDate())+"\"}, ";
             jsonString += "{\"No BPJS Ketenaga Kerjaan\" : \""+newEmployee.getAstekNum()+"\"}, ";
             jsonString += "{\"Tanggal BPJS Ketenaga Kerjaan\" : \""+f2DateStr(newEmployee.getAstekDate())+"\"}, ";
             jsonString += "{\"No BPJS Kesehatan\" : \""+newEmployee.getBpjs_no()+"\"}, ";
             jsonString += "{\"Tanggal BPJS Kesehatan\" : \""+f2DateStr(newEmployee.getBpjs_date())+"\"}, ";
             jsonString += "{\"Member BPJS Kesehatan\" : \""+(newEmployee.getMemOfBpjsKesahatan()==0?"Tidak":"Ya")+"\"}, ";
             jsonString += "{\"Member BPJS Ketenagakerjaan\" : \""+(newEmployee.getMemOfBpjsKetenagaKerjaan()==0?"Tidak":"Ya")+"\"}, ";
             jsonString += "{\"Status Pensiun Program\" : \""+(newEmployee.getStatusPensiunProgram()==0?"Tidak":"Ya")+"\"}, ";
             jsonString += "{\"Tanggal Pensiun\" : \""+f2DateStr(newEmployee.getStartDatePensiun())+"\"}, ";
             jsonString += "{\"Dana Pendidikan\" : \""+(newEmployee.getDanaPendidikan()==0?"Tidak":"Ya")+"\"}, ";
             jsonString += "{\"Akhir Kontrak\" : \""+f2DateStr(newEmployee.getEnd_contract())+"\"}, ";
             jsonString += "{\"Status Berhenti\" : \""+(newEmployee.getResigned()==0?"Tidak":"Ya")+"\"}, ";
             jsonString += "{\"Tanggal Berhenti\" : \""+f2DateStr(newEmployee.getResignedDate())+"\"}, ";
             jsonString += "{\"Alasan Berhenti Kerja\" : \""+getResignReason(newEmployee.getResignedReasonId())+"\"}, ";
             jsonString += "{\"Keterangan Berhenti\" : \""+newEmployee.getResignedDesc()+"\"}, ";
             jsonString += "{\"NKK\" : \""+newEmployee.getNkk()+"\"}, ";
             jsonString += "{\"Nomor SK Jabatan\" : \""+newEmployee.getSkNomor()+"\"}, ";
             jsonString += "{\"Tanggal SK Jabatan\" : \""+f2DateStr(newEmployee.getSkTanggal())+"\"}, ";
             jsonString += "{\"Nomor SK Grade\" : \""+newEmployee.getSkNomorGrade()+"\"}, ";
             jsonString += "{\"Tanggal SK Grade\" : \""+f2DateStr(newEmployee.getSkTanggalGrade())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateEmployee (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      
        try{
            Employee currData = (Employee) req.getAttribute("currData");
            System.out.println("1");
            Employee prevData = (Employee) req.getAttribute("prevData");
            System.out.println("2");
            String query = (String) req.getAttribute("query");
            System.out.println("3");
              String reqUrl = req.getRequestURI().toString() + "?employee_oid=" + currData.getOID();
              System.out.println("4");
              String className = currData.getClass().getName();
              System.out.println("5");

              LogSysHistory logSysHistory = new LogSysHistory();
              System.out.println("6");
              logSysHistory = setLogConfig(req,logSysHistory);
              logSysHistory.setLogModule("Personal Data");
              logSysHistory.setLogUserAction("EDIT");
              logSysHistory.setLogDocumentId(currData.getOID());
              logSysHistory.setQuery(query);
              logSysHistory.setLogDocumentType(className); //entity
              logSysHistory.setLogEditedUserId(currData.getOID());
              logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
              String jsonStringCurr = "{ \"items\" : [";
              String jsonStringPrev = "{ \"items\" : [";
              System.out.println("7");
         if(currData != null && prevData != null) {
             System.out.println("8");
             if (!currData.getEmployeeNum().equals(prevData.getEmployeeNum())){
                 jsonStringCurr += "{\"Penggajian\" : \""+currData.getEmployeeNum()+"\"}, ";
                 jsonStringPrev += "{\"Penggajian\" : \""+prevData.getEmployeeNum()+"\"}, ";
             }
             System.out.println("9");
             if (!currData.getFullName().equals(prevData.getFullName())){
                 jsonStringCurr += "{\"Nama Lengkap\" : \""+currData.getFullName()+"\"}, ";
                 jsonStringPrev += "{\"Nama Lengkap\" : \""+prevData.getFullName()+"\"}, ";
             }
             System.out.println("10");
             if (!currData.getNameCard().equals(prevData.getNameCard())){
                 jsonStringCurr += "{\"Nama Pada KTP\" : \""+currData.getNameCard()+"\"}, ";
                 jsonStringPrev += "{\"Nama Pada KTP\" : \""+prevData.getNameCard()+"\"}, ";
             }
             System.out.println("11");
             if (!currData.getAddress().equals(prevData.getAddress())){
                 jsonStringCurr += "{\"Alamat Sementara\" : \""+currData.getAddress()+"\"}, ";
                 jsonStringPrev += "{\"Alamat Sementara\" : \""+prevData.getAddress()+"\"}, ";
             }
             System.out.println("12");
             if (!currData.getAddressPermanent().equals(prevData.getAddressPermanent())){
                 jsonStringCurr += "{\"Alamat Tetap\" : \""+currData.getAddressPermanent()+"\"}, ";
                 jsonStringPrev += "{\"Alamat Tetap\" : \""+prevData.getAddressPermanent()+"\"}, ";
             }
             if (currData.getPostalCode() != prevData.getPostalCode()){
                 jsonStringCurr += "{\"Kode Pos\" : \""+currData.getPostalCode()+"\"}, ";
                 jsonStringPrev += "{\"Kode Pos\" : \""+prevData.getPostalCode()+"\"}, ";
             }
             if (!currData.getPhone().equals(prevData.getPhone())){
                 jsonStringCurr += "{\"Telephone\" : \""+currData.getPhone()+"\"}, ";
                 jsonStringPrev += "{\"Telephone\" : \""+prevData.getPhone()+"\"}, ";
             }
             if (!currData.getHandphone().equals(prevData.getHandphone())){
                 jsonStringCurr += "{\"HP\" : \""+currData.getHandphone()+"\"}, ";
                 jsonStringPrev += "{\"HP\" : \""+prevData.getHandphone()+"\"}, ";
             }
             if (!currData.getPhoneEmergency().equals(prevData.getPhoneEmergency())){
                 jsonStringCurr += "{\"Nomor Darurat\" : \""+currData.getPhoneEmergency()+"\"}, ";
                 jsonStringPrev += "{\"Nomor Darurat\" : \""+prevData.getPhoneEmergency()+"\"}, ";
             }
             if (!currData.getNameEmg().equals(prevData.getNameEmg())){
                 jsonStringCurr += "{\"Nama Darurat\" : \""+currData.getNameEmg()+"\"}, ";
                 jsonStringPrev += "{\"Nama Darurat\" : \""+prevData.getNameEmg()+"\"}, ";
             }
             if (!currData.getAddressEmg().equals(prevData.getAddressEmg())){
                 jsonStringCurr += "{\"Alamat Darurat\" : \""+currData.getAddressEmg()+"\"}, ";
                 jsonStringPrev += "{\"Alamat Darurat\" : \""+prevData.getAddressEmg()+"\"}, ";
             }
             if (currData.getSex() != prevData.getSex()){
                 jsonStringCurr += "{\"Jenis Kelamin\" : \""+(currData.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
                 jsonStringPrev += "{\"Jenis Kelamin\" : \""+(prevData.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
             }
             if (!currData.getBirthPlace().equals(prevData.getBirthPlace())){
                 jsonStringCurr += "{\"Tempat Lahir\" : \""+currData.getBirthPlace()+"\"}, ";
                 jsonStringPrev += "{\"Tempat Lahir\" : \""+prevData.getBirthPlace()+"\"}, ";
             }
             if (!f2DateStr(currData.getBirthDate()).equals(f2DateStr(prevData.getBirthDate()))){
                 jsonStringCurr += "{\"Tanggal Lahir\" : \""+f2DateStr(currData.getBirthDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Lahir\" : \""+f2DateStr(prevData.getBirthDate())+"\"}, ";
             }
             if (!currData.getBirthPlace().equals(prevData.getBirthPlace())){
                 jsonStringCurr += "{\"Tempat Lahir\" : \""+currData.getBirthPlace()+"\"}, ";
                 jsonStringPrev += "{\"Tempat Lahir\" : \""+prevData.getBirthPlace()+"\"}, ";
             }
             if (currData.getReligionId()!= prevData.getReligionId()){
                 jsonStringCurr += "{\"Agama\" : \""+getReligionName(currData.getReligionId())+"\"}, ";
                 jsonStringPrev += "{\"Agama\" : \""+getReligionName(prevData.getReligionId())+"\"}, ";
             }
             if (currData.getMaritalId()!= prevData.getMaritalId()){
                 jsonStringCurr += "{\"Status Perkawinan\" : \""+getMaritalName(currData.getMaritalId())+"\"}, ";
                 jsonStringPrev += "{\"Status Perkawinan\" : \""+getMaritalName(prevData.getMaritalId())+"\"}, ";
             }
             if (currData.getMaritalId()!= prevData.getMaritalId()){
                 jsonStringCurr += "{\"Status Perkawinan\" : \""+getMaritalName(currData.getMaritalId())+"\"}, ";
                 jsonStringPrev += "{\"Status Perkawinan\" : \""+getMaritalName(prevData.getMaritalId())+"\"}, ";
             }
             if (currData.getTaxMaritalId()!= prevData.getTaxMaritalId()){
                 jsonStringCurr += "{\"Status Perkawinan Untuk Pajak\" : \""+getMaritalName(currData.getTaxMaritalId())+"\"}, ";
                 jsonStringPrev += "{\"Status Perkawinan Untuk Pajak\" : \""+getMaritalName(prevData.getTaxMaritalId())+"\"}, ";
             }
             if (!currData.getBloodType().equals(prevData.getBloodType())){
                 jsonStringCurr += "{\"Golongan Darah\" : \""+currData.getBloodType()+"\"}, ";
                 jsonStringPrev += "{\"Golongan Darah\" : \""+prevData.getBloodType()+"\"}, ";
             }
             if (currData.getRace()!= prevData.getRace()){
                 jsonStringCurr += "{\"Suku\" : \""+getRaceName(currData.getRace())+"\"}, ";
                 jsonStringPrev += "{\"Suku\" : \""+getRaceName(prevData.getRace())+"\"}, ";
             }
             if (currData.getNationalityId()!= prevData.getNationalityId()){
                 jsonStringCurr += "{\"Nationality\" : \""+getNationality(currData.getNationalityId())+"\"}, ";
                 jsonStringPrev += "{\"Nationality\" : \""+getNationality(prevData.getNationalityId())+"\"}, ";
             }
             if (!currData.getBarcodeNumber().equals(prevData.getBarcodeNumber())){
                 jsonStringCurr += "{\"Nomor Barcode\" : \""+currData.getBarcodeNumber()+"\"}, ";
                 jsonStringPrev += "{\"Nomor Barcode\" : \""+prevData.getBarcodeNumber()+"\"}, ";
             }
             if (!currData.getIndentCardNr().equals(prevData.getIndentCardNr())){
                 jsonStringCurr += "{\"Nomor Kartu Identitas\" : \""+currData.getIndentCardNr()+"\"}, ";
                 jsonStringPrev += "{\"Nomor Kartu Identitas\" : \""+prevData.getIndentCardNr()+"\"}, ";
             }
             if (!currData.getIdcardtype().equals(prevData.getIdcardtype())){
                 jsonStringCurr += "{\"Jenis Kartu Identitas\" : \""+currData.getIdcardtype()+"\"}, ";
                 jsonStringPrev += "{\"Jenis Kartu Identitas\" : \""+prevData.getIdcardtype()+"\"}, ";
             }
             if (!f2DateStr(currData.getIndentCardValidTo()).equals(f2DateStr(prevData.getIndentCardValidTo()))){
                 jsonStringCurr += "{\"Kartu Identitas Berlaku Sampai\" : \""+f2DateStr(currData.getIndentCardValidTo())+"\"}, ";
                 jsonStringPrev += "{\"Kartu Identitas Berlaku Sampai\" : \""+f2DateStr(prevData.getIndentCardValidTo())+"\"}, ";
             }
             if (!currData.getEmailAddress().equals(prevData.getEmailAddress())){
                 jsonStringCurr += "{\"Email\" : \""+currData.getEmailAddress()+"\"}, ";
                 jsonStringPrev += "{\"Email\" : \""+prevData.getEmailAddress()+"\"}, ";
             }
             if (!currData.getIq().equals(prevData.getIq())){
                 jsonStringCurr += "{\"IQ\" : \""+currData.getIq()+"\"}, ";
                 jsonStringPrev += "{\"IQ\" : \""+prevData.getIq()+"\"}, ";
             }
             if (!currData.getEq().equals(prevData.getEq())){
                 jsonStringCurr += "{\"EQ\" : \""+currData.getEq()+"\"}, ";
                 jsonStringPrev += "{\"EQ\" : \""+prevData.getEq()+"\"}, ";
             }
             if (!currData.getNoRekening().equals(prevData.getNoRekening())){
                 jsonStringCurr += "{\"Nomor Rekening\" : \""+currData.getNoRekening()+"\"}, ";
                 jsonStringPrev += "{\"Nomor Rekening\" : \""+prevData.getNoRekening()+"\"}, ";
             }
             if (!currData.getNpwp().equals(prevData.getNpwp())){
                 jsonStringCurr += "{\"NPWP\" : \""+currData.getNpwp()+"\"}, ";
                 jsonStringPrev += "{\"NPWP\" : \""+prevData.getNpwp()+"\"}, ";
             }
             if (!currData.getFather().equals(prevData.getFather())){
                 jsonStringCurr += "{\"Nama Ayah\" : \""+currData.getFather()+"\"}, ";
                 jsonStringPrev += "{\"Nama Ayah\" : \""+prevData.getFather()+"\"}, ";
             }
             if (!currData.getMother().equals(prevData.getMother())){
                 jsonStringCurr += "{\"Nama Ibu\" : \""+currData.getMother()+"\"}, ";
                 jsonStringPrev += "{\"Nama Ibu\" : \""+prevData.getMother()+"\"}, ";
             }
             if (!currData.getParentsAddress().equals(prevData.getParentsAddress())){
                 jsonStringCurr += "{\"Alamat Orang Tua\" : \""+currData.getParentsAddress()+"\"}, ";
                 jsonStringPrev += "{\"Alamat Orang Tua\" : \""+prevData.getParentsAddress()+"\"}, ";
             }
             if (currData.getCompanyId()!= prevData.getCompanyId()){
                 jsonStringCurr += "{\"Perusahaan\" : \""+getCompanyName(currData.getCompanyId())+"\"}, ";
                 jsonStringPrev += "{\"Perusahaan\" : \""+getCompanyName(prevData.getCompanyId())+"\"}, ";
             }
             if (currData.getDivisionId()!= prevData.getDivisionId()){
                 jsonStringCurr += "{\"Satuan Kerja\" : \""+getDivisionName(currData.getDivisionId())+"\"}, ";
                 jsonStringPrev += "{\"Satuan Kerja\" : \""+getDivisionName(prevData.getDivisionId())+"\"}, ";
             }
             if (currData.getDivisionId()!= prevData.getDivisionId()){
                 jsonStringCurr += "{\"Unit\" : \""+getDepartmentName(currData.getDepartmentId())+"\"}, ";
                 jsonStringPrev += "{\"Unit\" : \""+getDepartmentName(prevData.getDepartmentId())+"\"}, ";
             }
             if (currData.getSectionId()!= prevData.getSectionId()){
                 jsonStringCurr += "{\"Sub Unit\" : \""+getSectionName(currData.getSectionId())+"\"}, ";
                 jsonStringPrev += "{\"Sub Unit\" : \""+getSectionName(prevData.getSectionId())+"\"}, ";
             }
             if (currData.getEmpCategoryId()!= prevData.getEmpCategoryId()){
                 jsonStringCurr += "{\"Karyawan Kategori\" : \""+getEmpCategoryName(currData.getEmpCategoryId())+"\"}, ";
                 jsonStringPrev += "{\"Karyawan Kategori\" : \""+getEmpCategoryName(prevData.getEmpCategoryId())+"\"}, ";
             }
             if (currData.getLevelId()!= prevData.getLevelId()){
                 jsonStringCurr += "{\"Level\" : \""+getLevelName(currData.getLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Level\" : \""+getLevelName(prevData.getLevelId())+"\"}, ";
             }
             if (currData.getGradeLevelId()!= prevData.getGradeLevelId()){
                 jsonStringCurr += "{\"Grade\" : \""+getGrade(currData.getGradeLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Grade\" : \""+getGrade(prevData.getGradeLevelId())+"\"}, ";
             }
             if (currData.getPositionId()!= prevData.getPositionId()){
                 jsonStringCurr += "{\"Jabatan\" : \""+getPositionName(currData.getPositionId())+"\"}, ";
                 jsonStringPrev += "{\"Jabatan\" : \""+getPositionName(prevData.getPositionId())+"\"}, ";
             }
             if (currData.getHistoryType()!= prevData.getHistoryType()){
                 jsonStringCurr += "{\"Tipe Karir\" : \""+PstCareerPath.historyType[currData.getHistoryType()]+"\"}, ";
                 jsonStringPrev += "{\"Tipe Karir\" : \""+PstCareerPath.historyType[prevData.getHistoryType()]+"\"}, ";
             }
             if (currData.getHistoryGroup()!= prevData.getHistoryGroup()){
                 jsonStringCurr += "{\"Tipe Karir\" : \""+PstCareerPath.historyGroup[currData.getHistoryGroup()]+"\"}, ";
                 jsonStringPrev += "{\"Tipe Karir\" : \""+PstCareerPath.historyGroup[prevData.getHistoryGroup()]+"\"}, ";
             }
             if (currData.getWorkassigncompanyId()!= prevData.getWorkassigncompanyId()){
                 jsonStringCurr += "{\"W.A. Perusahaan\" : \""+getCompanyName(currData.getWorkassigncompanyId())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Perusahaan\" : \""+getCompanyName(prevData.getWorkassigncompanyId())+"\"}, ";
             }
             if (currData.getWorkassigndivisionId()!= prevData.getWorkassigndivisionId()){
                 jsonStringCurr += "{\"W.A. Satuan Kerja\" : \""+getDivisionName(currData.getWorkassigndivisionId())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Satuan Kerja\" : \""+getDivisionName(prevData.getWorkassigndivisionId())+"\"}, ";
             }
             if (currData.getWorkassigndepartmentId()!= prevData.getWorkassigndepartmentId()){
                 jsonStringCurr += "{\"W.A. Unit\" : \""+getDepartmentName(currData.getWorkassigndepartmentId())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Unit\" : \""+getDepartmentName(prevData.getWorkassigndepartmentId())+"\"}, ";
             }
             if (currData.getWorkassignsectionId()!= prevData.getWorkassignsectionId()){
                 jsonStringCurr += "{\"W.A. Sub Unit\" : \""+getSectionName(currData.getWorkassignsectionId())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Sub Unit\" : \""+getSectionName(prevData.getWorkassignsectionId())+"\"}, ";
             }
             if (currData.getWorkassignpositionId()!= prevData.getWorkassignpositionId()){
                 jsonStringCurr += "{\"W.A. Jabatan\" : \""+getPositionName(currData.getWorkassignpositionId())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Jabatan\" : \""+getPositionName(prevData.getWorkassignpositionId())+"\"}, ";
             }
             if (currData.getProviderID()!= prevData.getProviderID()){
                 jsonStringCurr += "{\"W.A. Penyedia\" : \""+getPositionName(currData.getProviderID())+"\"}, ";
                 jsonStringPrev += "{\"W.A. Penyedia\" : \""+getPositionName(prevData.getProviderID())+"\"}, ";
             }
             if (!f2DateStr(currData.getCommencingDate()).equals(f2DateStr(prevData.getCommencingDate()))){
                 jsonStringCurr += "{\"Mulai Bekerja\" : \""+f2DateStr(currData.getCommencingDate())+"\"}, ";
                 jsonStringPrev += "{\"Mulai Bekerja\" : \""+f2DateStr(prevData.getCommencingDate())+"\"}, ";
             }
             if (!f2DateStr(currData.getProbationEndDate()).equals(f2DateStr(prevData.getProbationEndDate()))){
                 jsonStringCurr += "{\"Akhir Masa Percobaan\" : \""+f2DateStr(currData.getProbationEndDate())+"\"}, ";
                 jsonStringPrev += "{\"Akhir Masa Percobaan\" : \""+f2DateStr(prevData.getProbationEndDate())+"\"}, ";
             }
             if (!currData.getAstekNum().equals(prevData.getAstekNum())){
                 jsonStringCurr += "{\"No BPJS Ketenaga Kerjaan\" : \""+currData.getAstekNum()+"\"}, ";
                 jsonStringPrev += "{\"No BPJS Ketenaga Kerjaan\" : \""+prevData.getAstekNum()+"\"}, ";
             }
             if (!f2DateStr(currData.getAstekDate()).equals(f2DateStr(prevData.getAstekDate()))){
                 jsonStringCurr += "{\"Tanggal BPJS Ketenaga Kerjaan\" : \""+f2DateStr(currData.getAstekDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal BPJS Ketenaga Kerjaan\" : \""+f2DateStr(prevData.getAstekDate())+"\"}, ";
             }
             if (!currData.getBpjs_no().equals(prevData.getBpjs_no())){
                 jsonStringCurr += "{\"No BPJS Kesehatan\" : \""+currData.getBpjs_no()+"\"}, ";
                 jsonStringPrev += "{\"No BPJS Kesehatan\" : \""+prevData.getBpjs_no()+"\"}, ";
             }
             if (!f2DateStr(currData.getBpjs_date()).equals(f2DateStr(prevData.getBpjs_date()))){
                 jsonStringCurr += "{\"Tanggal BPJS Kesehatan\" : \""+f2DateStr(currData.getBpjs_date())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal BPJS Kesehatan\" : \""+f2DateStr(prevData.getBpjs_date())+"\"}, ";
             }
             if (currData.getMemOfBpjsKesahatan()!= prevData.getMemOfBpjsKesahatan()){
                 jsonStringCurr += "{\"Member BPJS Kesehatan\" : \""+(currData.getMemOfBpjsKesahatan()==0?"Tidak":"Ya")+"\"}, ";
                 jsonStringPrev += "{\"Member BPJS Kesehatan\" : \""+(prevData.getMemOfBpjsKesahatan()==0?"Tidak":"Ya")+"\"}, ";
             }
             if (currData.getMemOfBpjsKetenagaKerjaan()!= prevData.getMemOfBpjsKetenagaKerjaan()){
                 jsonStringCurr += "{\"Member BPJS Ketenagakerjaan\" : \""+(currData.getMemOfBpjsKetenagaKerjaan()==0?"Tidak":"Ya")+"\"}, ";
                 jsonStringPrev += "{\"Member BPJS Ketenagakerjaan\" : \""+(prevData.getMemOfBpjsKetenagaKerjaan()==0?"Tidak":"Ya")+"\"}, ";
             }
             if (currData.getStatusPensiunProgram()!= prevData.getStatusPensiunProgram()){
                 jsonStringCurr += "{\"Status Pensiun Program\" : \""+(currData.getStatusPensiunProgram()==0?"Tidak":"Ya")+"\"}, ";
                 jsonStringPrev += "{\"Status Pensiun Program\" : \""+(prevData.getStatusPensiunProgram()==0?"Tidak":"Ya")+"\"}, ";
             }
             if (!f2DateStr(currData.getStartDatePensiun()).equals(f2DateStr(prevData.getStartDatePensiun()))){
                 jsonStringCurr += "{\"Tanggal Pensiun\" : \""+f2DateStr(currData.getStartDatePensiun())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Pensiun\" : \""+f2DateStr(prevData.getStartDatePensiun())+"\"}, ";
             }
             if (currData.getDanaPendidikan()!= prevData.getDanaPendidikan()){
                 jsonStringCurr += "{\"Dana Pendidikan\" : \""+(currData.getDanaPendidikan()==0?"Tidak":"Ya")+"\"}, ";
                 jsonStringPrev += "{\"Dana Pendidikan\" : \""+(prevData.getDanaPendidikan()==0?"Tidak":"Ya")+"\"}, ";
             }
             if (!f2DateStr(currData.getEnd_contract()).equals(f2DateStr(prevData.getEnd_contract()))){
                 jsonStringCurr += "{\"Akhir Kontrak\" : \""+f2DateStr(currData.getEnd_contract())+"\"}, ";
                 jsonStringPrev += "{\"Akhir Kontrak\" : \""+f2DateStr(prevData.getEnd_contract())+"\"}, ";
             }
             if (currData.getResigned()!= prevData.getResigned()){
                 jsonStringCurr += "{\"Status Berhenti\" : \""+(currData.getResigned()==0?"Tidak":"Ya")+"\"}, ";
                 jsonStringPrev += "{\"Status Berhenti\" : \""+(prevData.getResigned()==0?"Tidak":"Ya")+"\"}, ";
             }
             if (!f2DateStr(currData.getResignedDate()).equals(f2DateStr(prevData.getResignedDate()))){
                 jsonStringCurr += "{\"Tanggal Berhenti\" : \""+f2DateStr(currData.getResignedDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Berhenti\" : \""+f2DateStr(prevData.getResignedDate())+"\"}, ";
             }
             if (currData.getResignedReasonId()!= prevData.getResignedReasonId()){
                 jsonStringCurr += "{\"Alasan Berhenti Kerja\" : \""+getResignReason(currData.getResignedReasonId())+"\"}, ";
                 jsonStringPrev += "{\"Alasan Berhenti Kerja\" : \""+getResignReason(prevData.getResignedReasonId())+"\"}, ";
             }
             if (!currData.getResignedDesc().equals(prevData.getResignedDesc())){
                 jsonStringCurr += "{\"Keterangan Berhenti\" : \""+currData.getResignedDesc()+"\"}, ";
                 jsonStringPrev += "{\"Keterangan Berhenti\" : \""+prevData.getResignedDesc()+"\"}, ";
             }
             if (!currData.getNkk().equals(prevData.getNkk())){
                 jsonStringCurr += "{\"NKK\" : \""+currData.getNkk()+"\"}, ";
                 jsonStringPrev += "{\"NKK\" : \""+prevData.getNkk()+"\"}, ";
             }
             if (!currData.getSkNomor().equals(prevData.getSkNomor())){
                 jsonStringCurr += "{\"Nomor SK Jabatan\" : \""+currData.getSkNomor()+"\"}, ";
                 jsonStringPrev += "{\"Nomor SK Jabatan\" : \""+prevData.getSkNomor()+"\"}, ";
             }
             if (!f2DateStr(currData.getSkTanggal()).equals(f2DateStr(prevData.getSkTanggal()))){
                 jsonStringCurr += "{\"Tanggal SK Jabatan\" : \""+f2DateStr(currData.getSkTanggal())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal SK Jabatan\" : \""+f2DateStr(prevData.getSkTanggal())+"\"}, ";
             }
             if (!currData.getSkNomorGrade().equals(prevData.getSkNomorGrade())){
                 jsonStringCurr += "{\"Nomor SK Grade\" : \""+currData.getSkNomorGrade()+"\"}, ";
                 jsonStringPrev += "{\"Nomor SK Grade\" : \""+prevData.getSkNomorGrade()+"\"}, ";
             }
             if (!f2DateStr(currData.getSkTanggalGrade()).equals(f2DateStr(prevData.getSkTanggalGrade()))){
                 jsonStringCurr += "{\"Tanggal SK Grade\" : \""+f2DateStr(currData.getSkTanggalGrade())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal SK Grade\" : \""+f2DateStr(prevData.getSkTanggalGrade())+"\"}, ";
             }
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteFamily (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        FamilyMember newFamily = (FamilyMember) req.getAttribute("insert");
      FamilyMember delFamily = (FamilyMember) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newFamily == null){
          newFamily = delFamily;
      }
        String reqUrl = req.getRequestURI().toString() + "?employee_oid=" + newFamily.getOID();
        String className = newFamily.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Anggota Keluarga");
        if(delFamily == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newFamily.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newFamily.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newFamily != null) {
             jsonString += "{\"Karyawan\" : \""+getEmployeeFullName(newFamily.getEmployeeId())+"\"}, ";
             jsonString += "{\"Nama Lengkap\" : \""+newFamily.getFullName()+"\"}, ";
             jsonString += "{\"Jenis Kelamin\" : \""+(newFamily.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
             jsonString += "{\"Hubungan\" : \""+getFamilyRelation(newFamily.getRelationship())+"\"}, ";
             jsonString += "{\"Jaminan BPJS\" : \""+(newFamily.getGuaranteed()?"Ya":"Tidak")+"\"}, ";
             jsonString += "{\"No BPJS\" : \""+newFamily.getBpjsNum()+"\"}, ";
             jsonString += "{\"Tempat Lahir\" : \""+newFamily.getBirtPlace()+"\"}, ";
             jsonString += "{\"Tanggal Lahir\" : \""+(newFamily.getIgnoreBirth() ? "-" : f2DateStr(newFamily.getBirthDate()))+"\"}, ";
             jsonString += "{\"Pekerjaan\" : \""+newFamily.getJob()+"\"}, ";
             jsonString += "{\"Alamat Kerja\" : \""+newFamily.getJobPlace()+"\"}, ";
             jsonString += "{\"No KTP\" : \""+newFamily.getCardId()+"\"}, ";
             jsonString += "{\"Pendidikan\" : \""+getEducation(newFamily.getEducationId())+"\"}, ";
             jsonString += "{\"Agama\" : \""+getReligionName(newFamily.getReligionId())+"\"}, ";
             jsonString += "{\"No Telp\" : \""+newFamily.getNoTelp()+"\"}, ";
             jsonString += "] }";
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateFamily (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      FamilyMember currData = (FamilyMember) req.getAttribute("currData");
      FamilyMember prevData = (FamilyMember) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?employee_oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Anggota Keluarga");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className);
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());//entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (!currData.getFullName().equals(prevData.getFullName())){
                 jsonStringCurr += "{\"Nama Lengkap\" : \""+currData.getFullName()+"\"}, ";
                 jsonStringPrev += "{\"Nama Lengkap\" : \""+prevData.getFullName()+"\"}, ";
             }
             if (currData.getSex() != prevData.getSex()){
                 jsonStringCurr += "{\"Jenis Kelamin\" : \""+(currData.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
                 jsonStringPrev += "{\"Jenis Kelamin\" : \""+(prevData.getSex()==0?"Laki-Laki":"Perempuan")+"\"}, ";
             }
             if (!currData.getRelationship().equals(prevData.getRelationship())){
                 jsonStringCurr += "{\"Hubungan\" : \""+getFamilyRelation(currData.getRelationship())+"\"}, ";
                 jsonStringPrev += "{\"Hubungan\" : \""+getFamilyRelation(prevData.getRelationship())+"\"}, ";
             }
             if (currData.getGuaranteed() != prevData.getGuaranteed()){
                 jsonStringCurr += "{\"Jaminan BPJS\" : \""+(currData.getGuaranteed()?"Ya":"Tidak")+"\"}, ";
                 jsonStringPrev += "{\"Jaminan BPJS\" : \""+(prevData.getGuaranteed()?"Ya":"Tidak")+"\"}, ";
             }
             if (!currData.getBpjsNum().equals(prevData.getBpjsNum())){
                 jsonStringCurr += "{\"No BPJS\" : \""+currData.getBpjsNum()+"\"}, ";
                 jsonStringPrev += "{\"No BPJS\" : \""+prevData.getBpjsNum()+"\"}, ";
             }
             if (!currData.getBirtPlace().equals(prevData.getBirtPlace())){
                 jsonStringCurr += "{\"Tempat Lahir\" : \""+currData.getBirtPlace()+"\"}, ";
                 jsonStringPrev += "{\"Tempat Lahir\" : \""+prevData.getBirtPlace()+"\"}, ";
             }
             if (!f2DateStr(currData.getBirthDate()).equals(f2DateStr(prevData.getBirthDate()))){
                 jsonStringCurr += "{\"Tanggal Lahir\" : \""+f2DateStr(currData.getBirthDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Lahir\" : \""+f2DateStr(prevData.getBirthDate())+"\"}, ";
             }
             if (!currData.getJob().equals(prevData.getJob())){
                 jsonStringCurr += "{\"Pekerjaan\" : \""+currData.getJob()+"\"}, ";
                 jsonStringPrev += "{\"Pekerjaan\" : \""+prevData.getJob()+"\"}, ";
             }
             if (!currData.getJobPlace().equals(prevData.getJobPlace())){
                 jsonStringCurr += "{\"Alamat Kerja\" : \""+currData.getJobPlace()+"\"}, ";
                 jsonStringPrev += "{\"Alamat Kerja\" : \""+prevData.getJobPlace()+"\"}, ";
             }
             if (!currData.getCardId().equals(prevData.getCardId())){
                 jsonStringCurr += "{\"No KTP\" : \""+currData.getCardId()+"\"}, ";
                 jsonStringPrev += "{\"No KTP\" : \""+prevData.getCardId()+"\"}, ";
             }
             if (currData.getEducationId()!= prevData.getEducationId()){
                 jsonStringCurr += "{\"Pendidikan\" : \""+getEducation(currData.getEducationId())+"\"}, ";
                 jsonStringPrev += "{\"Pendidikan\" : \""+getEducation(prevData.getEducationId())+"\"}, ";
             }
             if (currData.getReligionId()!= prevData.getReligionId()){
                 jsonStringCurr += "{\"Agama\" : \""+getReligionName(currData.getReligionId())+"\"}, ";
                 jsonStringPrev += "{\"Agama\" : \""+getReligionName(prevData.getReligionId())+"\"}, ";
             }
             if (currData.getNoTelp()!=prevData.getNoTelp()){
                 jsonStringCurr += "{\"No Telp\" : \""+currData.getNoTelp()+"\"}, ";
                 jsonStringPrev += "{\"No Telp\" : \""+prevData.getNoTelp()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteCompetency (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmployeeCompetency newData = (EmployeeCompetency) req.getAttribute("insert");
      EmployeeCompetency delData = (EmployeeCompetency) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Kompetensi Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Kompetensi\" : \""+getCompetency(newData.getCompetencyId())+"\"}, ";
             jsonString += "{\"Nilai\" : \""+newData.getLevelValue()+"\"}, ";
             jsonString += "{\"Tanggal\" : \""+f2DateStr(newData.getDateOfAchvmt())+"\"}, ";
             jsonString += "{\"Prestasi\" : \""+newData.getSpecialAchievement()+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateCompetency (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmployeeCompetency currData = (EmployeeCompetency) req.getAttribute("currData");
      EmployeeCompetency prevData = (EmployeeCompetency) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Kompetensi Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if ( currData.getCompetencyId() != prevData.getCompetencyId()){
                 jsonStringCurr += "{\"Kompetensi\" : \""+getCompetency(currData.getCompetencyId())+"\"}, ";
                 jsonStringPrev += "{\"Kompetensi\" : \""+getCompetency(prevData.getCompetencyId())+"\"}, ";
             }
             if (currData.getLevelValue() != prevData.getLevelValue()){
                 jsonStringCurr += "{\"Nilai\" : \""+currData.getLevelValue()+"\"}, ";
                 jsonStringPrev += "{\"Nilai\" : \""+prevData.getLevelValue()+"\"}, ";
             }
             if (!f2DateStr(currData.getDateOfAchvmt()).equals(f2DateStr(prevData.getDateOfAchvmt()))){
                 jsonStringCurr += "{\"Tanggal\" : \""+f2DateStr(currData.getDateOfAchvmt())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal\" : \""+f2DateStr(prevData.getDateOfAchvmt())+"\"}, ";
             }
             if (!currData.getSpecialAchievement().equals(prevData.getSpecialAchievement())){
                 jsonStringCurr += "{\"Prestasi\" : \""+currData.getSpecialAchievement()+"\"}, ";
                 jsonStringPrev += "{\"Prestasi\" : \""+prevData.getSpecialAchievement()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteAssessment (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpAssessment newData = (EmpAssessment) req.getAttribute("insert");
      EmpAssessment delData = (EmpAssessment) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Assessment Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Assessment\" : \""+getAssessment(newData.getAssessmentId())+"\"}, ";
             jsonString += "{\"Nilai\" : \""+newData.getScore()+"\"}, ";
             jsonString += "{\"Tanggal\" : \""+f2DateStr(newData.getDateOfAssessment())+"\"}, ";
             jsonString += "{\"Remark\" : \""+newData.getRemark()+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateAssessment (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpAssessment currData = (EmpAssessment) req.getAttribute("currData");
      EmpAssessment prevData = (EmpAssessment) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Assessment Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if ( currData.getAssessmentId()!= prevData.getAssessmentId()){
                 jsonStringCurr += "{\"Assessment\" : \""+getAssessment(currData.getAssessmentId())+"\"}, ";
                 jsonStringPrev += "{\"Assessment\" : \""+getAssessment(prevData.getAssessmentId())+"\"}, ";
             }
             if (currData.getScore()!= prevData.getScore()){
                 jsonStringCurr += "{\"Nilai\" : \""+currData.getScore()+"\"}, ";
                 jsonStringPrev += "{\"Nilai\" : \""+prevData.getScore()+"\"}, ";
             }
             if (!f2DateStr(currData.getDateOfAssessment()).equals(f2DateStr(prevData.getDateOfAssessment()))){
                 jsonStringCurr += "{\"Tanggal\" : \""+f2DateStr(currData.getDateOfAssessment())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal\" : \""+f2DateStr(prevData.getDateOfAssessment())+"\"}, ";
             }
             if (!currData.getRemark().equals(prevData.getRemark())){
                 jsonStringCurr += "{\"Remark\" : \""+currData.getRemark()+"\"}, ";
                 jsonStringPrev += "{\"Remark\" : \""+prevData.getRemark()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    
    public static int insertNDeletePower (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpPowerCharacter newData = (EmpPowerCharacter) req.getAttribute("insert");
      EmpPowerCharacter delData = (EmpPowerCharacter) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Power Character");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Warna Pertama\" : \""+getColor(newData.getPowerCharacterId())+"\"}, ";
             jsonString += "{\"Warna Kedua\" : \""+getColor(newData.getSecondCharacterId())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updatePower (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpPowerCharacter currData = (EmpPowerCharacter) req.getAttribute("currData");
      EmpPowerCharacter prevData = (EmpPowerCharacter) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Power Character");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if ( currData.getPowerCharacterId()!= prevData.getPowerCharacterId()){
                 jsonStringCurr += "{\"Warna Pertama\" : \""+getColor(currData.getPowerCharacterId())+"\"}, ";
                 jsonStringPrev += "{\"Warna Pertama\" : \""+getColor(prevData.getPowerCharacterId())+"\"}, ";
             }
             if (currData.getSecondCharacterId()!= prevData.getSecondCharacterId()){
                 jsonStringCurr += "{\"Warna Kedua\" : \""+getColor(currData.getSecondCharacterId())+"\"}, ";
                 jsonStringPrev += "{\"Warna Kedua\" : \""+getColor(prevData.getSecondCharacterId())+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    
    public static int insertNDeleteLanguage (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpLanguage newData = (EmpLanguage) req.getAttribute("insert");
      EmpLanguage delData = (EmpLanguage) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Emp Language");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Bahasa\" : \""+getLanguage(newData.getLanguageId())+"\"}, ";
             jsonString += "{\"Oral\" : \""+PstLanguage.langName[newData.getOral()]+"\"}, ";
             jsonString += "{\"Written\" : \""+PstLanguage.langName[newData.getOral()]+"\"}, ";
             jsonString += "{\"Deskripsi\" : \""+newData.getDescription()+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateLanguage (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpLanguage currData = (EmpLanguage) req.getAttribute("currData");
      EmpLanguage prevData = (EmpLanguage) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Emp Language");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if ( currData.getLanguageId()!= prevData.getLanguageId()){
                 jsonStringCurr += "{\"Bahasa\" : \""+getLanguage(currData.getLanguageId())+"\"}, ";
                 jsonStringPrev += "{\"Bahasa\" : \""+getLanguage(prevData.getLanguageId())+"\"}, ";
             }
             if (currData.getOral()!= prevData.getOral()){
                 jsonStringCurr += "{\"Oral\" : \""+PstLanguage.langName[currData.getOral()]+"\"}, ";
                 jsonStringPrev += "{\"Oral\" : \""+PstLanguage.langName[prevData.getOral()]+"\"}, ";
             }
             if (currData.getWritten()!= prevData.getWritten()){
                 jsonStringCurr += "{\"Written\" : \""+PstLanguage.langName[currData.getWritten()]+"\"}, ";
                 jsonStringPrev += "{\"Written\" : \""+PstLanguage.langName[prevData.getWritten()]+"\"}, ";
             }
             if (!currData.getDescription().equals(prevData.getDescription())){
                 jsonStringCurr += "{\"Deskripsi\" : \""+currData.getDescription()+"\"}, ";
                 jsonStringPrev += "{\"Deskripsi\" : \""+prevData.getDescription()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteEducation (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpEducation newData = (EmpEducation) req.getAttribute("insert");
      EmpEducation delData = (EmpEducation) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Emp Education");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Pendidikan\" : \""+getEducation(newData.getEducationId())+"\"}, ";
             jsonString += "{\"Tahun\" : \""+newData.getStartDate()+" - "+newData.getEndDate()+"\"}, ";
             jsonString += "{\"Universitas/Institusi\" : \""+getContactName(newData.getInstitutionId())+"\"}, ";
             jsonString += "{\"Detail\" : \""+newData.getGraduation()+"\"}, ";
             jsonString += "{\"Poin\" : \""+newData.getPoint()+"\"}, ";
             jsonString += "{\"Deskripsi\" : \""+newData.getEducationDesc()+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateEducation (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpEducation currData = (EmpEducation) req.getAttribute("currData");
      EmpEducation prevData = (EmpEducation) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Emp Education");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if ( currData.getEducationId()!= prevData.getEducationId()){
                 jsonStringCurr += "{\"Pendidikan\" : \""+getEducation(currData.getEducationId())+"\"}, ";
                 jsonStringPrev += "{\"Pendidikan\" : \""+getEducation(prevData.getEducationId())+"\"}, ";
             }
             if (currData.getStartDate()!= prevData.getStartDate()){
                 jsonStringCurr += "{\"Tahun Mulai\" : \""+currData.getStartDate()+"\"}, ";
                 jsonStringPrev += "{\"Tahun Mulai\" : \""+prevData.getStartDate()+"\"}, ";
             }
             if (currData.getEndDate()!= prevData.getEndDate()){
                 jsonStringCurr += "{\"Tahun Selesai\" : \""+currData.getEndDate()+"\"}, ";
                 jsonStringPrev += "{\"Tahun Selesai\" : \""+prevData.getEndDate()+"\"}, ";
             }
             if (currData.getInstitutionId()!= prevData.getInstitutionId()){
                 jsonStringCurr += "{\"Universitas/Institusi\" : \""+getContactName(currData.getInstitutionId())+"\"}, ";
                 jsonStringPrev += "{\"Universitas/Institusi\" : \""+getContactName(prevData.getInstitutionId())+"\"}, ";
             }
             if (!currData.getGraduation().equals(prevData.getGraduation())){
                 jsonStringCurr += "{\"Detail\" : \""+currData.getGraduation()+"\"}, ";
                 jsonStringPrev += "{\"Detail\" : \""+prevData.getGraduation()+"\"}, ";
             }
             if (!currData.getEducationDesc().equals(prevData.getEducationDesc())){
                 jsonStringCurr += "{\"Deskripsi\" : \""+currData.getEducationDesc()+"\"}, ";
                 jsonStringPrev += "{\"Deskripsi\" : \""+prevData.getEducationDesc()+"\"}, ";
             }
              if (currData.getPoint()!= prevData.getPoint()){
                 jsonStringCurr += "{\"Poin\" : \""+currData.getPoint()+"\"}, ";
                 jsonStringPrev += "{\"Poin\" : \""+prevData.getPoint()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteWorkHistory (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        Experience newData = (Experience) req.getAttribute("insert");
      Experience delData = (Experience) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Pengalaman Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Nama Perusahaan\" : \""+newData.getCompanyName()+"\"}, ";
             jsonString += "{\"Tahun\" : \""+newData.getStartDate()+" - "+newData.getEndDate()+"\"}, ";
             jsonString += "{\"Jabatan\" : \""+newData.getPosition()+"\"}, ";
             jsonString += "{\"Alasan Pindah\" : \""+newData.getMoveReason()+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateWorkHistory (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      Experience currData = (Experience) req.getAttribute("currData");
      Experience prevData = (Experience) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Pengalaman Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (!currData.getCompanyName().equals(prevData.getCompanyName())){
                 jsonStringCurr += "{\"Nama Perusahaan\" : \""+currData.getCompanyName()+"\"}, ";
                 jsonStringPrev += "{\"Nama Perusahaan\" : \""+prevData.getCompanyName()+"\"}, ";
             }
             if (currData.getStartDate()!= prevData.getStartDate()){
                 jsonStringCurr += "{\"Tahun Mulai\" : \""+currData.getStartDate()+"\"}, ";
                 jsonStringPrev += "{\"Tahun Mulai\" : \""+prevData.getStartDate()+"\"}, ";
             }
             if (currData.getEndDate()!= prevData.getEndDate()){
                 jsonStringCurr += "{\"Tahun Selesai\" : \""+currData.getEndDate()+"\"}, ";
                 jsonStringPrev += "{\"Tahun Selesai\" : \""+prevData.getEndDate()+"\"}, ";
             }
             if (!currData.getPosition().equals(prevData.getPosition())){
                 jsonStringCurr += "{\"Jabatan\" : \""+currData.getPosition()+"\"}, ";
                 jsonStringPrev += "{\"Jabatan\" : \""+prevData.getPosition()+"\"}, ";
             }
             if (!currData.getMoveReason().equals(prevData.getMoveReason())){
                 jsonStringCurr += "{\"Alasan Pindah\" : \""+currData.getMoveReason()+"\"}, ";
                 jsonStringPrev += "{\"Alasan Pindah\" : \""+prevData.getMoveReason()+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
     public static int insertNDeleteCareerPath (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        CareerPath newData = (CareerPath) req.getAttribute("insert");
      CareerPath delData = (CareerPath) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Riwayat Jabatan Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Perusahaan\" : \""+getCompanyName(newData.getCompanyId())+"\"}, ";
             jsonString += "{\"Satuan Kerja\" : \""+getDivisionName(newData.getDivisionId())+"\"}, ";
             jsonString += "{\"Unit\" : \""+getDepartmentName(newData.getDepartmentId())+"\"}, ";
             jsonString += "{\"Sub Unit\" : \""+getSectionName(newData.getSectionId())+"\"}, ";
             jsonString += "{\"Jabatan\" : \""+getPositionName(newData.getPositionId())+"\"}, ";
             jsonString += "{\"Level\" : \""+getLevelName(newData.getLevelId())+"\"}, ";
             jsonString += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(newData.getEmpCategoryId())+"\"}, ";
             jsonString += "{\"W. A. Penyedia\" : \""+getContactName(newData.getProviderID())+"\"}, ";
             jsonString += "{\"Deskripsi\" : \""+newData.getDescription()+"\"}, ";
             jsonString += "{\"Tipe Riwayat\" : \""+PstCareerPath.historyType[newData.getHistoryType()]+"\"}, ";
             jsonString += "{\"Kelompok Riwayat\" : \""+PstCareerPath.historyGroup[newData.getHistoryGroup()]+"\"}, ";
             jsonString += "{\"Bekerja Sejak\" : \""+f2DateStr(newData.getWorkFrom())+" - "+f2DateStr(newData.getWorkTo())+"\"}, ";
             jsonString += "{\"Nomor SK\" : \""+newData.getNomorSk()+"\"}, ";
             jsonString += "{\"Tanggal SK\" : \""+f2DateStr(newData.getTanggalSk())+"\"}, ";
             jsonString += "{\"Tingkat\" : \""+getGrade(newData.getGradeLevelId())+"\"}, ";
             jsonString += "{\"Kontrak Dari\" : \""+f2DateStr(newData.getContractFrom())+" - "+f2DateStr(newData.getContractTo())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateCareerPath (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      CareerPath currData = (CareerPath) req.getAttribute("currData");
      CareerPath prevData = (CareerPath) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Riwayat Jabatan Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (currData.getCompanyId()!= prevData.getCompanyId()){
                 jsonStringCurr += "{\"Perusahaan\" : \""+getCompanyName(currData.getCompanyId())+"\"}, ";
                 jsonStringPrev += "{\"Perusahaan\" : \""+getCompanyName(prevData.getCompanyId())+"\"}, ";
             }
             if (currData.getDivisionId()!= prevData.getDivisionId()){
                 jsonStringCurr += "{\"Satuan Kerja\" : \""+getDivisionName(currData.getDivisionId())+"\"}, ";
                 jsonStringPrev += "{\"Satuan Kerja\" : \""+getDivisionName(prevData.getDivisionId())+"\"}, ";
             }
             if (currData.getDepartmentId()!= prevData.getDepartmentId()){
                 jsonStringCurr += "{\"Unit\" : \""+getDepartmentName(currData.getDepartmentId())+"\"}, ";
                 jsonStringPrev += "{\"Unit\" : \""+getDepartmentName(prevData.getDepartmentId())+"\"}, ";
             }
             if (currData.getSectionId()!= prevData.getSectionId()){
                 jsonStringCurr += "{\"Sub Unit\" : \""+getSectionName(currData.getSectionId())+"\"}, ";
                 jsonStringPrev += "{\"Sub Unit\" : \""+getSectionName(prevData.getSectionId())+"\"}, ";
             }
             if (currData.getPositionId()!= prevData.getPositionId()){
                 jsonStringCurr += "{\"Jabatan\" : \""+getPositionName(currData.getPositionId())+"\"}, ";
                 jsonStringPrev += "{\"Jabatan\" : \""+getPositionName(prevData.getPositionId())+"\"}, ";
             }
             if (currData.getLevelId()!= prevData.getLevelId()){
                 jsonStringCurr += "{\"Level\" : \""+getLevelName(currData.getLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Level\" : \""+getLevelName(prevData.getLevelId())+"\"}, ";
             }
             if (currData.getEmpCategoryId()!= prevData.getEmpCategoryId()){
                 jsonStringCurr += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(currData.getEmpCategoryId())+"\"}, ";
                 jsonStringPrev += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(prevData.getEmpCategoryId())+"\"}, ";
             }
             if (currData.getProviderID()!= prevData.getProviderID()){
                 jsonStringCurr += "{\"W. A. Penyedia\" : \""+getContactName(currData.getProviderID())+"\"}, ";
                 jsonStringPrev += "{\"W. A. Penyedia\" : \""+getContactName(prevData.getProviderID())+"\"}, ";
             }
             if (!currData.getDescription().equals(prevData.getDescription())){
                 jsonStringCurr += "{\"Deskripsi\" : \""+currData.getDescription()+"\"}, ";
                 jsonStringPrev += "{\"Deskripsi\" : \""+prevData.getDescription()+"\"}, ";
             }
             if (currData.getHistoryType()!= prevData.getHistoryType()){
                 jsonStringCurr += "{\"Tipe Riwayat\" : \""+PstCareerPath.historyType[currData.getHistoryType()]+"\"}, ";
                 jsonStringPrev += "{\"Tipe Riwayat\" : \""+PstCareerPath.historyType[prevData.getHistoryType()]+"\"}, ";
             }
             if (currData.getHistoryGroup()!= prevData.getHistoryGroup()){
                 jsonStringCurr += "{\"Kelompok Riwayat\" : \""+PstCareerPath.historyGroup[currData.getHistoryGroup()]+"\"}, ";
                 jsonStringPrev += "{\"Kelompok Riwayat\" : \""+PstCareerPath.historyGroup[prevData.getHistoryGroup()]+"\"}, ";
             }
             if (!f2DateStr(currData.getWorkFrom()).equals(f2DateStr(prevData.getWorkFrom()))){
                 jsonStringCurr += "{\"Bekerja Sejak\" : \""+f2DateStr(currData.getWorkFrom())+"\"}, ";
                 jsonStringPrev += "{\"Bekerja Sejak\" : \""+f2DateStr(prevData.getWorkFrom())+"\"}, ";
             }
             if (!f2DateStr(currData.getWorkTo()).equals(f2DateStr(prevData.getWorkTo()))){
                 jsonStringCurr += "{\"Bekerja Hingga\" : \""+f2DateStr(currData.getWorkTo())+"\"}, ";
                 jsonStringPrev += "{\"Bekerja Hingga\" : \""+f2DateStr(prevData.getWorkTo())+"\"}, ";
             }
             if (!currData.getNomorSk().equals(prevData.getNomorSk())){
                 jsonStringCurr += "{\"Nomor SK\" : \""+currData.getNomorSk()+"\"}, ";
                 jsonStringPrev += "{\"Nomor SK\" : \""+prevData.getNomorSk()+"\"}, ";
             }
             if (!f2DateStr(currData.getTanggalSk()).equals(f2DateStr(prevData.getTanggalSk()))){
                 jsonStringCurr += "{\"Tanggal SK\" : \""+f2DateStr(currData.getTanggalSk())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal SK\" : \""+f2DateStr(prevData.getTanggalSk())+"\"}, ";
             }
             if (currData.getGradeLevelId()!= prevData.getGradeLevelId()){
                 jsonStringCurr += "{\"Tingkat\" : \""+getGrade(currData.getGradeLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Tingkat\" : \""+getGrade(prevData.getGradeLevelId())+"\"}, ";
             }
             if (!f2DateStr(currData.getContractFrom()).equals(f2DateStr(prevData.getContractFrom()))){
                 jsonStringCurr += "{\"Kontrak Dari\" : \""+f2DateStr(currData.getContractFrom())+"\"}, ";
                 jsonStringPrev += "{\"Kontrak Dari\" : \""+f2DateStr(prevData.getContractFrom())+"\"}, ";
             }
             if (!f2DateStr(currData.getContractTo()).equals(f2DateStr(prevData.getContractTo()))){
                 jsonStringCurr += "{\"Kontrak Hingga\" : \""+f2DateStr(currData.getContractTo())+"\"}, ";
                 jsonStringPrev += "{\"Kontrak Hingga\" : \""+f2DateStr(prevData.getContractTo())+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteTraining (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        TrainingHistory newData = (TrainingHistory) req.getAttribute("insert");
      TrainingHistory delData = (TrainingHistory) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Diklat Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Judul Pelatihan\" : \""+newData.getTrainingTitle()+"\"}, ";
             jsonString += "{\"Program Pelatihan\" : \""+getTrainingProgram(newData.getTrainingId())+"\"}, ";
             jsonString += "{\"Trainer\" : \""+newData.getTrainer()+"\"}, ";
             jsonString += "{\"Tanggal Pelatihan\" : \""+f2DateStr(newData.getStartDate()) +" "+f2TimeStr(newData.getStartTime())
                     +" - "+f2DateStr(newData.getEndDate())+" "+f2TimeStr(newData.getEndTime())+"\"}, ";
             jsonString += "{\"Durasi\" : \""+newData.getDuration()+"\"}, ";
             jsonString += "{\"Keterangan\" : \""+newData.getRemark()+"\"}, ";
             jsonString += "{\"Poin\" : \""+newData.getPoint()+"\"}, ";
             jsonString += "{\"Nomor SK\" : \""+newData.getNomorSk()+"\"}, ";
             jsonString += "{\"Tanggal SK\" : \""+f2DateStr(newData.getTanggalSk())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateTraining (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      TrainingHistory currData = (TrainingHistory) req.getAttribute("currData");
      TrainingHistory prevData = (TrainingHistory) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Diklat Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (!currData.getTrainingTitle().equals(prevData.getTrainingTitle())){
                 jsonStringCurr += "{\"Judul Pelatihan\" : \""+currData.getTrainingTitle()+"\"}, ";
                 jsonStringPrev += "{\"Judul Pelatihan\" : \""+prevData.getTrainingTitle()+"\"}, ";
             }
             if (currData.getTrainingId()!= prevData.getTrainingId()){
                 jsonStringCurr += "{\"Program Pelatihan\" : \""+getTrainingProgram(currData.getTrainingId())+"\"}, ";
                 jsonStringPrev += "{\"Program Pelatihan\" : \""+getTrainingProgram(prevData.getTrainingId())+"\"}, ";
             }
             if (!currData.getTrainer().equals(prevData.getTrainer())){
                 jsonStringCurr += "{\"Trainer\" : \""+currData.getTrainer()+"\"}, ";
                 jsonStringPrev += "{\"Trainer\" : \""+prevData.getTrainer()+"\"}, ";
             }
             if (!f2DateStr(currData.getStartDate()).equals(f2DateStr(prevData.getStartDate()))){
                 jsonStringCurr += "{\"Tanggal Mulai\" : \""+f2DateStr(currData.getStartDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Mulai\" : \""+f2DateStr(prevData.getStartDate())+"\"}, ";
             }
             if (!f2DateStr(currData.getEndDate()).equals(f2DateStr(prevData.getEndDate()))){
                 jsonStringCurr += "{\"Tanggal Berakhir\" : \""+f2DateStr(currData.getEndDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Berakhir\" : \""+f2DateStr(prevData.getEndDate())+"\"}, ";
             }
             if (!f2TimeStr(currData.getStartTime()).equals(f2TimeStr(prevData.getStartTime()))){
                 jsonStringCurr += "{\"Jam Mulai\" : \""+f2TimeStr(currData.getStartTime())+"\"}, ";
                 jsonStringPrev += "{\"Jam Mulai\" : \""+f2TimeStr(prevData.getStartTime())+"\"}, ";
             }
             if (!f2TimeStr(currData.getEndTime()).equals(f2TimeStr(prevData.getEndTime()))){
                 jsonStringCurr += "{\"Jam Berakhir\" : \""+f2TimeStr(currData.getEndTime())+"\"}, ";
                 jsonStringPrev += "{\"Jam Berakhir\" : \""+f2TimeStr(prevData.getEndTime())+"\"}, ";
             }
             if (currData.getDuration()!= prevData.getDuration()){
                 jsonStringCurr += "{\"Durasi\" : \""+getDepartmentName(currData.getDuration())+"\"}, ";
                 jsonStringPrev += "{\"Durasi\" : \""+getDepartmentName(prevData.getDuration())+"\"}, ";
             }
             if (!currData.getRemark().equals(prevData.getRemark())){
                 jsonStringCurr += "{\"Keterangan\" : \""+currData.getRemark()+"\"}, ";
                 jsonStringPrev += "{\"Keterangan\" : \""+prevData.getRemark()+"\"}, ";
             }
             if (currData.getPoint()!= prevData.getPoint()){
                 jsonStringCurr += "{\"Poin\" : \""+currData.getPoint()+"\"}, ";
                 jsonStringPrev += "{\"Poin\" : \""+prevData.getPoint()+"\"}, ";
             }
             if (!currData.getNomorSk().equals(prevData.getNomorSk())){
                 jsonStringCurr += "{\"Nomor SK\" : \""+currData.getNomorSk()+"\"}, ";
                 jsonStringPrev += "{\"Nomor SK\" : \""+prevData.getNomorSk()+"\"}, ";
             }
             if (!f2DateStr(currData.getTanggalSk()).equals(f2DateStr(prevData.getTanggalSk()))){
                 jsonStringCurr += "{\"Tanggal SK\" : \""+f2DateStr(currData.getTanggalSk())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal SK\" : \""+f2DateStr(prevData.getTanggalSk())+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int insertNDeleteWarning (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpWarning newData = (EmpWarning) req.getAttribute("insert");
      EmpWarning delData = (EmpWarning) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Peringatan Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Perusahaan\" : \""+getCompanyName(newData.getCompanyId())+"\"}, ";
             jsonString += "{\"Satuan Kerja\" : \""+getDivisionName(newData.getDivisionId())+"\"}, ";
             jsonString += "{\"Unit\" : \""+getDepartmentName(newData.getDepartmentId())+"\"}, ";
             jsonString += "{\"Sub Unit\" : \""+getSectionName(newData.getSectionId())+"\"}, ";
             jsonString += "{\"Jabatan\" : \""+getPositionName(newData.getPositionId())+"\"}, ";
             jsonString += "{\"Level\" : \""+getLevelName(newData.getLevelId())+"\"}, ";
             jsonString += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(newData.getEmpCategoryId())+"\"}, ";
             jsonString += "{\"Tanggal Pelanggaran\" : \""+f2DateStr(newData.getBreakDate())+"\"}, ";
             jsonString += "{\"Pelanggaran\" : \""+newData.getBreakFact()+"\"}, ";
             jsonString += "{\"Tanggal Peringatan\" : \""+f2DateStr(newData.getWarningDate())+"\"}, ";
             jsonString += "{\"Peringatan Level\" : \""+getWarningLevel(newData.getWarnLevelId())+"\"}, ";
             jsonString += "{\"Peringatan Dari\" : \""+newData.getWarningBy()+"\"}, ";
             jsonString += "{\"Berlaku Hingga\" : \""+f2DateStr(newData.getValidityDate())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateWarning (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpWarning currData = (EmpWarning) req.getAttribute("currData");
      EmpWarning prevData = (EmpWarning) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Peringatan Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(currData.getEmployeeId());
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (currData.getCompanyId()!= prevData.getCompanyId()){
                 jsonStringCurr += "{\"Perusahaan\" : \""+getCompanyName(currData.getCompanyId())+"\"}, ";
                 jsonStringPrev += "{\"Perusahaan\" : \""+getCompanyName(prevData.getCompanyId())+"\"}, ";
             }
             if (currData.getDivisionId()!= prevData.getDivisionId()){
                 jsonStringCurr += "{\"Satuan Kerja\" : \""+getDivisionName(currData.getDivisionId())+"\"}, ";
                 jsonStringPrev += "{\"Satuan Kerja\" : \""+getDivisionName(prevData.getDivisionId())+"\"}, ";
             }
             if (currData.getDepartmentId()!= prevData.getDepartmentId()){
                 jsonStringCurr += "{\"Unit\" : \""+getDepartmentName(currData.getDepartmentId())+"\"}, ";
                 jsonStringPrev += "{\"Unit\" : \""+getDepartmentName(prevData.getDepartmentId())+"\"}, ";
             }
             if (currData.getSectionId()!= prevData.getSectionId()){
                 jsonStringCurr += "{\"Sub Unit\" : \""+getSectionName(currData.getSectionId())+"\"}, ";
                 jsonStringPrev += "{\"Sub Unit\" : \""+getSectionName(prevData.getSectionId())+"\"}, ";
             }
             if (currData.getPositionId()!= prevData.getPositionId()){
                 jsonStringCurr += "{\"Jabatan\" : \""+getPositionName(currData.getPositionId())+"\"}, ";
                 jsonStringPrev += "{\"Jabatan\" : \""+getPositionName(prevData.getPositionId())+"\"}, ";
             }
             if (currData.getLevelId()!= prevData.getLevelId()){
                 jsonStringCurr += "{\"Level\" : \""+getLevelName(currData.getLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Level\" : \""+getLevelName(prevData.getLevelId())+"\"}, ";
             }
             if (currData.getEmpCategoryId()!= prevData.getEmpCategoryId()){
                 jsonStringCurr += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(currData.getEmpCategoryId())+"\"}, ";
                 jsonStringPrev += "{\"Kategori Karyawan\" : \""+getEmpCategoryName(prevData.getEmpCategoryId())+"\"}, ";
             }
             if (!currData.getBreakFact().equals(prevData.getBreakFact())){
                 jsonStringCurr += "{\"Pelanggaran\" : \""+currData.getBreakFact()+"\"}, ";
                 jsonStringPrev += "{\"Pelanggaran\" : \""+prevData.getBreakFact()+"\"}, ";
             }
             if (!f2DateStr(currData.getBreakDate()).equals(f2DateStr(prevData.getBreakDate()))){
                 jsonStringCurr += "{\"Tanggal Peringatan\" : \""+f2DateStr(currData.getBreakDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Peringatan\" : \""+f2DateStr(prevData.getBreakDate())+"\"}, ";
             }
             if (currData.getWarnLevelId()!= prevData.getWarnLevelId()){
                 jsonStringCurr += "{\"Peringatan Level\" : \""+getWarningLevel(currData.getWarnLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Peringatan Level\" : \""+getWarningLevel(prevData.getWarnLevelId())+"\"}, ";
             }
             if (!currData.getWarningBy().equals(prevData.getWarningBy())){
                 jsonStringCurr += "{\"Peringatan Dari\" : \""+currData.getWarningBy()+"\"}, ";
                 jsonStringPrev += "{\"Peringatan Dari\" : \""+prevData.getWarningBy()+"\"}, ";
             }
             if (!f2DateStr(currData.getValidityDate()).equals(f2DateStr(prevData.getValidityDate()))){
                 jsonStringCurr += "{\"Berlaku Hingga\" : \""+f2DateStr(currData.getValidityDate())+"\"}, ";
                 jsonStringPrev += "{\"Berlaku Hingga\" : \""+f2DateStr(prevData.getValidityDate())+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    
    public static int insertNDeleteReprimand (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
        EmpReprimand newData = (EmpReprimand) req.getAttribute("insert");
      EmpReprimand delData = (EmpReprimand) req.getAttribute("delete");
      String query = (String) req.getAttribute("query");
      if(newData == null){
          newData = delData;
      }
        String reqUrl = req.getRequestURI().toString() + "?oid=" + newData.getOID();
        String className = newData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Teguran Karyawan");
        if(delData == null){
        logSysHistory.setLogUserAction("ADD");
        }else{
        logSysHistory.setLogUserAction("DELETE");    
        }
        logSysHistory.setLogDocumentId(newData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        logSysHistory.setLogEditedUserId(newData.getEmployeeId());
        String jsonString = "{ \"items\" : [";
        try{
         if(newData != null) {
             
             jsonString += "{\"Karyawan\" : \""+getEmployee(newData.getEmployeeId())+"\"}, ";
             jsonString += "{\"Perusahaan\" : \""+getCompanyName(newData.getCompanyId())+"\"}, ";
             jsonString += "{\"Satuan Kerja\" : \""+getDivisionName(newData.getDivisionId())+"\"}, ";
             jsonString += "{\"Unit\" : \""+getDepartmentName(newData.getDepartmentId())+"\"}, ";
             jsonString += "{\"Sub Unit\" : \""+getSectionName(newData.getSectionId())+"\"}, ";
             jsonString += "{\"Jabatan\" : \""+getPositionName(newData.getPositionId())+"\"}, ";
             jsonString += "{\"Level\" : \""+getLevelName(newData.getLevelId())+"\"}, ";
             jsonString += "{\"Tanggal Teguran\" : \""+f2DateStr(newData.getReprimandDate())+"\"}, ";
             jsonString += "{\"Reprimand Level\" : \""+getReprimandLevel(newData.getReprimandLevelId())+"\"}, ";
             jsonString += "{\"Deskripsi\" : \""+newData.getDescription()+"\"}, ";
             jsonString += "{\"Berlaku Hingga\" : \""+f2DateStr(newData.getValidityDate())+"\"}, ";
             jsonString += "] }";
             
             
         }
            logSysHistory.setLogDetail(jsonString);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static int updateReprimand (HttpServletRequest req) {
      int status           = STATUS_SUCCESS;
      EmpReprimand currData = (EmpReprimand) req.getAttribute("currData");
      EmpReprimand prevData = (EmpReprimand) req.getAttribute("prevData");
      String query = (String) req.getAttribute("query");
        String reqUrl = req.getRequestURI().toString() + "?oid=" + currData.getOID();
        String className = currData.getClass().getName();
        
        LogSysHistory logSysHistory = new LogSysHistory();
        logSysHistory = setLogConfig(req,logSysHistory);
        logSysHistory.setLogModule("Teguran Karyawan");
        logSysHistory.setLogUserAction("EDIT");
        logSysHistory.setLogDocumentId(currData.getOID());
        logSysHistory.setQuery(query);
        logSysHistory.setLogDocumentType(className); //entity
        logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
        String jsonStringCurr = "{ \"items\" : [";
        String jsonStringPrev = "{ \"items\" : [";
        try{
         if(currData != null && prevData != null) {
             if (currData.getCompanyId()!= prevData.getCompanyId()){
                 jsonStringCurr += "{\"Perusahaan\" : \""+getCompanyName(currData.getCompanyId())+"\"}, ";
                 jsonStringPrev += "{\"Perusahaan\" : \""+getCompanyName(prevData.getCompanyId())+"\"}, ";
             }
             if (currData.getDivisionId()!= prevData.getDivisionId()){
                 jsonStringCurr += "{\"Satuan Kerja\" : \""+getDivisionName(currData.getDivisionId())+"\"}, ";
                 jsonStringPrev += "{\"Satuan Kerja\" : \""+getDivisionName(prevData.getDivisionId())+"\"}, ";
             }
             if (currData.getDepartmentId()!= prevData.getDepartmentId()){
                 jsonStringCurr += "{\"Unit\" : \""+getDepartmentName(currData.getDepartmentId())+"\"}, ";
                 jsonStringPrev += "{\"Unit\" : \""+getDepartmentName(prevData.getDepartmentId())+"\"}, ";
             }
             if (currData.getSectionId()!= prevData.getSectionId()){
                 jsonStringCurr += "{\"Sub Unit\" : \""+getSectionName(currData.getSectionId())+"\"}, ";
                 jsonStringPrev += "{\"Sub Unit\" : \""+getSectionName(prevData.getSectionId())+"\"}, ";
             }
             if (currData.getPositionId()!= prevData.getPositionId()){
                 jsonStringCurr += "{\"Jabatan\" : \""+getPositionName(currData.getPositionId())+"\"}, ";
                 jsonStringPrev += "{\"Jabatan\" : \""+getPositionName(prevData.getPositionId())+"\"}, ";
             }
             if (currData.getLevelId()!= prevData.getLevelId()){
                 jsonStringCurr += "{\"Level\" : \""+getLevelName(currData.getLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Level\" : \""+getLevelName(prevData.getLevelId())+"\"}, ";
             }
             if (!f2DateStr(currData.getReprimandDate()).equals(f2DateStr(prevData.getReprimandDate()))){
                 jsonStringCurr += "{\"Tanggal Teguran\" : \""+f2DateStr(currData.getReprimandDate())+"\"}, ";
                 jsonStringPrev += "{\"Tanggal Teguran\" : \""+f2DateStr(prevData.getReprimandDate())+"\"}, ";
             }
             if (currData.getReprimandLevelId()!= prevData.getReprimandLevelId()){
                 jsonStringCurr += "{\"Level Teguran\" : \""+getWarningLevel(currData.getReprimandLevelId())+"\"}, ";
                 jsonStringPrev += "{\"Level Teguran\" : \""+getWarningLevel(prevData.getReprimandLevelId())+"\"}, ";
             }
             if (!currData.getDescription().equals(prevData.getDescription())){
                 jsonStringCurr += "{\"Deskripsi\" : \""+currData.getDescription()+"\"}, ";
                 jsonStringPrev += "{\"Deskripsi\" : \""+prevData.getDescription()+"\"}, ";
             }
             if (!f2DateStr(currData.getValidityDate()).equals(f2DateStr(prevData.getValidityDate()))){
                 jsonStringCurr += "{\"Berlaku Hingga\" : \""+f2DateStr(currData.getValidityDate())+"\"}, ";
                 jsonStringPrev += "{\"Berlaku Hingga\" : \""+f2DateStr(prevData.getValidityDate())+"\"}, ";
             }
             
             jsonStringCurr += "] }";
             jsonStringPrev += "] }";
             
             
         }
            logSysHistory.setLogCurr(jsonStringCurr);
            logSysHistory.setLogPrev(jsonStringPrev);
            PstLogSysHistory.insertExc(logSysHistory);
        }catch(Exception exc){
            System.out.println("Exc"+exc);
            status = STATUS_FAILED;
        }
     return status;
    }
    
    public static String getEmployee (long oid){
        String result="";
            try{
                Employee obj = (Employee)PstEmployee.fetchExc(oid);
                result="["+obj.getEmployeeNum()+"] "+obj.getFullName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static LogSysHistory setLogConfig (HttpServletRequest req, LogSysHistory logSysHistory){
        Date dateNow        = new Date();
        System.out.println("1"+req.getAttribute("UserOID"));
        long userOID         = (Long) req.getAttribute("UserOID");
        System.out.println("1"+userOID);
        AppUser user         = PstAppUser.fetch(userOID);
        System.out.println("2"+userOID);
        /* Lakukan set data ke entity logSysHistory */
        logSysHistory.setLogDocumentId(0);
        System.out.println("3"+userOID);
        logSysHistory.setLogUserId(user.getOID());
        logSysHistory.setLogLoginName(user.getLoginId());
        System.out.println("7"+userOID);
        logSysHistory.setLogDocumentNumber("");
        System.out.println("8"+userOID);
         // command
        logSysHistory.setLogUpdateDate(dateNow);
        System.out.println("9"+userOID);
        logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]); // interface 
        System.out.println("10"+userOID);
        return logSysHistory ;
    }
    
    public static String getResignReason (long oid){
        String result="";
            try{
                ResignedReason res = (ResignedReason)PstResignedReason.fetchExc(oid);
                result=res.getResignedReason();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getNationality (long oid){
        String result="";
            try{
                Nationality nat = (Nationality)PstNationality.fetchExc(oid);
                result=nat.getNationalityName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getReligionName (long oid){
        String result="";
            try{
                Religion rel = (Religion)PstReligion.fetchExc(oid);
                result=rel.getReligion();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getFamilyRelationshipName(long oid){
        String result="";
            try{
                FamRelation rel = (FamRelation)PstFamRelation.fetchExc(oid);
                result=rel.getFamRelation();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getEducationName(long oid){
        String result="";
            try{
                Education rel = (Education)PstEducation.fetchExc(oid);
                result=rel.getEducation();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getCompanyName (long oid){
        String result="";
            try{
                Company obj = (Company)PstCompany.fetchExc(oid);
                result=obj.getCompany();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getEmployeeFullName (long oid){
        String result="";
            try{
                Employee obj = (Employee)PstEmployee.fetchExc(oid);
                result=obj.getFullName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getScheduleName (long oid){
        String result="";
            try{
                ScheduleSymbol obj = (ScheduleSymbol)PstScheduleSymbol.fetchExc(oid);
                result=obj.getSchedule();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getScheduleSymbol(long oid){
        String result="";
            try{
                ScheduleSymbol obj = (ScheduleSymbol)PstScheduleSymbol.fetchExc(oid);
                result=obj.getSchedule();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getCompetencyName (long oid){
        String result="";
            try{
                Competency obj = (Competency)PstCompetency.fetchExc(oid);
                result=obj.getCompetencyName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getLanguageName (long oid){
        String result="";
            try{
                Language obj = (Language)PstLanguage.fetchExc(oid);
                result=obj.getLanguage();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getDivisionName (long oid){
        String result="";
            try{
                Division obj = (Division)PstDivision.fetchExc(oid);
                result=obj.getDivision();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getPositionLevelName (int oid){
        String result="";
            try{
                result = (String)PstPosition.strPositionLevelNames[oid];
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getPositionHeadTitleName (int oid){
        String result="";
            try{
                result = (String)PstPosition.strHeadTitle[oid];
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getDepartmentName (long oid){
        String result="";
            try{
                Department obj = (Department)PstDepartment.fetchExc(oid);
                result=obj.getDepartment();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
     public static String getSectionName (long oid){
        String result="";
            try{
                Section obj = (Section)PstSection.fetchExc(oid);
                result=obj.getSection();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
     public static String getContactName (long oid){
        String result="";
            try{
                ContactList obj = (ContactList)PstContactList.fetchExc(oid);
                result=obj.getCompName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
     public static String getPositionName (long oid){
        String result="";
            try{
                Position obj = (Position)PstPosition.fetchExc(oid);
                result=obj.getPosition();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getGrade (long oid){
        String result="";
            try{
                GradeLevel obj = (GradeLevel)PstGradeLevel.fetchExc(oid);
                result=obj.getCodeLevel();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getLevelName (long oid){
        String result="";
            try{
                Level obj = (Level)PstLevel.fetchExc(oid);
                result=obj.getLevel();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getEmpCategoryName (long oid){
        String result="";
            try{
                EmpCategory obj = (EmpCategory)PstEmpCategory.fetchExc(oid);
                result=obj.getEmpCategory();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getRaceName (long oid){
        String result="";
            try{
                Race obj = (Race)PstRace.fetchExc(oid);
                result=obj.getRaceName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getNationalityName (long oid){
        String result="";
            try{
                Negara obj = (Negara)PstNegara.fetchExc(oid);
                result=obj.getNmNegara();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getMaritalName (long oid){
        String result="";
            try{
                Marital obj = (Marital)PstMarital.fetchExc(oid);
                result=obj.getMaritalStatus();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getPayrollGroupName (long oid){
        String result="";
            try{
                PayrollGroup obj = (PayrollGroup)PstPayrollGroup.fetchExc(oid);
                result=obj.getPayrollGroupName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getUserGroupName (long oid){
        String result="";
            try{
                AppGroup obj = (AppGroup)PstAppGroup.fetch(oid);
                result=obj.getGroupName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
     public static String getPaySlipGroupName (long oid){
        String result="";
            try{
                PaySlipGroup obj = (PaySlipGroup)PstPaySlipGroup.fetchExc(oid);
                result=obj.getGroupName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getResignReasonName (long oid){
        String result="";
            try{
                ResignedReason obj = (ResignedReason)PstResignedReason.fetchExc(oid);
                result=obj.getResignedReason();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getEmployeeNum(long oid){
        String result="";
            try{
                Employee obj = (Employee)PstEmployee.fetchExc(oid);
                result=obj.getEmployeeNum();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getSexName (int status){
        String result="";
            try{
                if(status == 0){
                 result = "Male";   
                }else if (status == 1){
                 result = "Female";   
                }
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    
      public static String getResignName (int status){
        String result="";
            try{
                if(status == 0){
                 result = "No";   
                }else if (status == 1){
                 result = "Yes";   
                }
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
      
      public static String getAwardTypeName (long oid){
        String result="";
            try{
                AwardType obj = (AwardType)PstAwardType.fetchExc(oid);
                result=obj.getAwardType();
                
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
      
    public static String getRelevantDocumentGroupName (long oid){
        String result="";
            try{
                EmpRelevantDocGroup obj = (EmpRelevantDocGroup)PstEmpRelevantDocGroup.fetchExc(oid);
                result=obj.getDocGroup();
                
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
      
      public static String getPublicHolidayEntitlementName (long status){
        String result="";
            try{
                if(status > -1 && status < PstPublicHolidays.stHolidaySts.length){
                   result =  PstPublicHolidays.stHolidaySts[Integer.valueOf(String.valueOf(status))];
                }
                if(status > -1 && status > PstPublicHolidays.stHolidaySts.length){
                    result = getReligionName(status);
                    if(result.equals("")&&result.isEmpty()){
                      result = getNationalityName(status);
                    }
                }
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
      
    public static String getFamilyRelation (String oid){
        String result="";
            try{
                FamRelation obj = (FamRelation)PstFamRelation.fetchExc(Long.valueOf(oid));
                result=obj.getFamRelation();
                
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getEducation(long oid){
        String result="";
            try{
                Education obj = (Education)PstEducation.fetchExc(oid);
                result=obj.getEducation();
                
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getCompetency (long oid){
        String result="";
            try{
                Competency obj = (Competency)PstCompetency.fetchExc(oid);
                result=obj.getCompetencyName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getAssessment (long oid){
        String result="";
            try{
                Assessment obj = (Assessment)PstAssessment.fetchExc(oid);
                result=obj.getAssessmentType();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getColor (long oid){
        String result="";
            try{
                PowerCharacterColor obj = (PowerCharacterColor)PstPowerCharacterColor.fetchExc(oid);
                result=obj.getColorName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    
    public static String getLanguage (long oid){
        String result="";
            try{
                Language obj = (Language)PstLanguage.fetchExc(oid);
                result=obj.getLanguage();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getTrainingProgram (long oid){
        String result="";
            try{
                Training obj = (Training)PstTraining.fetchExc(oid);
                result=obj.getName();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getWarningLevel (long oid){
        String result="";
            try{
                Warning obj = (Warning)PstWarning.fetchExc(oid);
                result=obj.getWarnDesc();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getReprimandLevel (long oid){
        String result="";
            try{
                Reprimand obj = (Reprimand)PstReprimand.fetchExc(oid);
                result=obj.getReprimandDesc();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    public static String getChapter (long oid){
        String result="";
            try{
                WarningReprimandBab obj = (WarningReprimandBab)PstWarningReprimandBab.fetchExc(oid);
                result=obj.getBabTitle();
            }catch(Exception exc){
                System.out.println("Exc"+exc);
            }
        return result;
    }
    private static String f2DateStr(Date date) {
        return (date != null) ? Formater.formatDate(date, "yyyy-MM-dd") : "-";
    }
    private static String f2TimeStr(Date date) {
        return (date != null) ? Formater.formatDate(date, "HH:mm:ss") : "-";
    }
    
}
