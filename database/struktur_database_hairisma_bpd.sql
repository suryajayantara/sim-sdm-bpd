/*
SQLyog Ultimate v12.5.1 (64 bit)
MySQL - 10.4.20-MariaDB : Database - hairisma_bpd
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `aiso_perkiraan` */

DROP TABLE IF EXISTS `aiso_perkiraan`;

CREATE TABLE `aiso_perkiraan` (
  `nomor_perkiraan` text DEFAULT NULL,
  `id_perkiraan` bigint(20) NOT NULL DEFAULT 0,
  `level` int(11) DEFAULT 0,
  `nama` text DEFAULT NULL,
  `tanda_debet_kredit` smallint(6) DEFAULT 0,
  `postable` smallint(6) DEFAULT 0,
  `id_parent` bigint(20) DEFAULT 0,
  `department_id` bigint(20) DEFAULT 0,
  `account_name_english` text DEFAULT NULL,
  `weight` double DEFAULT 0,
  `general_account_link` bigint(20) DEFAULT 0,
  `account_group` int(11) DEFAULT 0,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `company_id` bigint(20) unsigned zerofill NOT NULL DEFAULT 00000000000000000000,
  `arap_account` smallint(6) NOT NULL DEFAULT 0,
  `expense_type` smallint(6) DEFAULT NULL,
  `expense_fixed_variable` smallint(6) DEFAULT NULL,
  `kode_perkiraan` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_perkiraan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `anak` */

DROP TABLE IF EXISTS `anak`;

CREATE TABLE `anak` (
  `FAMILY_MEMBER_ID` varchar(255) DEFAULT NULL,
  `EMPLOYEE_ID` varchar(255) DEFAULT NULL,
  `FULL_NAME` varchar(255) DEFAULT NULL,
  `RELATIONSHIP` varchar(255) DEFAULT NULL,
  `BIRTH_DATE` timestamp NULL DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `ADDRESS` varchar(255) DEFAULT NULL,
  `GUARANTEED` varchar(255) DEFAULT NULL,
  `IGNORE_DATE` varchar(255) DEFAULT NULL,
  `IGNORE_BIRTH` varchar(255) DEFAULT NULL,
  `RELIGION_ID` varchar(255) DEFAULT NULL,
  `EDUCATION_ID` varchar(255) DEFAULT NULL,
  `SEX` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `app_group_org` */

DROP TABLE IF EXISTS `app_group_org`;

CREATE TABLE `app_group_org` (
  `GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_NAME` varchar(64) DEFAULT NULL,
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `STATUS` int(11) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`),
  UNIQUE KEY `XPKAPP_GROUP` (`GROUP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `app_privilege_obj_org` */

DROP TABLE IF EXISTS `app_privilege_obj_org`;

CREATE TABLE `app_privilege_obj_org` (
  `PRIV_OBJ_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0,
  `CODE` int(11) DEFAULT NULL,
  PRIMARY KEY (`PRIV_OBJ_ID`),
  UNIQUE KEY `XPKAPP_PRIVILEGE_OBJ` (`PRIV_OBJ_ID`),
  UNIQUE KEY `CODE` (`CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `app_privilege_org` */

DROP TABLE IF EXISTS `app_privilege_org`;

CREATE TABLE `app_privilege_org` (
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_NAME` varchar(64) DEFAULT NULL,
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`PRIV_ID`),
  UNIQUE KEY `PRIV_NAME` (`PRIV_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `back_up_conf` */

DROP TABLE IF EXISTS `back_up_conf`;

CREATE TABLE `back_up_conf` (
  `BACK_UP_CONF_ID` bigint(20) NOT NULL DEFAULT 0,
  `START_TIME` datetime DEFAULT NULL,
  `PERIODE` int(11) DEFAULT NULL,
  `TARGET1` char(128) DEFAULT NULL,
  `TARGET2` char(128) DEFAULT NULL,
  `TARGET3` char(128) DEFAULT NULL,
  `SOURCE_PATH` char(128) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `com_logger` */

DROP TABLE IF EXISTS `com_logger`;

CREATE TABLE `com_logger` (
  `LOGGER_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOGIN_ID` bigint(20) DEFAULT NULL,
  `LOGIN_NAME` varchar(30) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `NOTES` text DEFAULT NULL,
  PRIMARY KEY (`LOGGER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `contact_class` */

DROP TABLE IF EXISTS `contact_class`;

CREATE TABLE `contact_class` (
  `CONTACT_CLASS_ID` bigint(20) NOT NULL DEFAULT 0,
  `CLASS_NAME` varchar(64) DEFAULT NULL,
  `CLASS_DESCRIPTION` text DEFAULT NULL,
  `CLASS_TYPE` int(11) NOT NULL DEFAULT 0,
  `SERIES_NUM` varchar(20) DEFAULT NULL,
  `LAST_UPDATE` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`CONTACT_CLASS_ID`),
  UNIQUE KEY `XPKCONTACT_CLASS` (`CONTACT_CLASS_ID`),
  UNIQUE KEY `CLASS_NAME` (`CLASS_NAME`),
  UNIQUE KEY `SERIES_NUM_KEY` (`SERIES_NUM`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `contact_class_assign` */

DROP TABLE IF EXISTS `contact_class_assign`;

CREATE TABLE `contact_class_assign` (
  `CONTACT_CLASS_ID` bigint(20) NOT NULL DEFAULT 0,
  `CONTACT_ID` bigint(20) NOT NULL DEFAULT 0,
  `LAST_UPDATE` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `contact_list` */

DROP TABLE IF EXISTS `contact_list`;

CREATE TABLE `contact_list` (
  `CONTACT_ID` bigint(20) NOT NULL DEFAULT 0,
  `CONTACT_CODE` varchar(20) NOT NULL DEFAULT '*',
  `CONTACT_TYPE` int(11) DEFAULT 0,
  `CIN` varchar(8) DEFAULT '',
  `CIN_COUNTER` int(11) DEFAULT 0,
  `REG_DATE` datetime DEFAULT '2010-11-11 00:00:00',
  `SALUTATION` varchar(5) DEFAULT '',
  `DATE_OF_BIRTH` datetime DEFAULT '2010-11-11 00:00:00',
  `PERSON_NAME` varchar(64) DEFAULT '',
  `PERSON_LASTNAME` varchar(64) DEFAULT '',
  `MOTHER_NAME` varchar(64) DEFAULT '',
  `NATIONALITY` varchar(64) DEFAULT '',
  `OCCUPATION` varchar(64) DEFAULT '',
  `IGNORE_BIRTH_DATE` int(4) DEFAULT 0,
  `DRIVING_LICENCE_NO` varchar(30) DEFAULT '',
  `PASSPORT_NO` varchar(64) DEFAULT '',
  `KTP_NO` varchar(30) DEFAULT '',
  `HOME_ADDRESS` text DEFAULT NULL,
  `HOME_CITY` varchar(64) DEFAULT '',
  `HOME_STATE` varchar(64) DEFAULT '',
  `HOME_PO_BOX` varchar(20) DEFAULT '',
  `HOME_COUNTRY` varchar(64) DEFAULT '',
  `HOME_PH_NUMBER` varchar(60) DEFAULT '',
  `HOME_MOBILE_PHONE` varchar(60) DEFAULT '',
  `HOME_EMAIL` varchar(64) DEFAULT '',
  `HOME_FAX` varchar(100) DEFAULT '',
  `HOME_WEBSITE` varchar(64) DEFAULT '',
  `HOME_PROVINCE` varchar(20) DEFAULT '',
  `HOME_ZIP_CODE` varchar(20) DEFAULT '',
  `COMP_NAME` varchar(64) DEFAULT '',
  `COMP_ADDRESS` text DEFAULT NULL,
  `COMP_CITY` varchar(64) DEFAULT '',
  `COMP_STATE` varchar(64) DEFAULT '',
  `COMP_ZIP_CODE` varchar(20) DEFAULT '',
  `COMP_PO_BOX` varchar(20) DEFAULT '',
  `COMP_COUNTRY` varchar(100) DEFAULT '',
  `COMP_PROVINCE` varchar(100) DEFAULT NULL,
  `COMP_REGENCY` varchar(100) DEFAULT NULL,
  `COMP_PH_NUMBER1` varchar(60) DEFAULT '',
  `COMP_PH_NUMBER2` varchar(60) DEFAULT '',
  `COMP_FAX` varchar(60) DEFAULT '',
  `COMP_EMAIL` varchar(64) DEFAULT '',
  `COMP_WEBSITE` varchar(64) DEFAULT '',
  `REFERENCE` varchar(64) DEFAULT '',
  `MESSAGE` text DEFAULT NULL,
  `NOTES` text DEFAULT NULL,
  `BANK_ACC` varchar(20) DEFAULT '',
  `BANK_ACC2` varchar(20) DEFAULT '',
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `PARENT_ID` bigint(20) DEFAULT 0,
  `COUNTRY_ID` bigint(20) DEFAULT 0,
  `PROCESS_STATUS` int(11) DEFAULT 0,
  `HOME_ADDR` text DEFAULT NULL,
  `HOME_TELP` text DEFAULT NULL,
  `HOME_TOWN` text DEFAULT NULL,
  `MEMBER_BARCODE` varchar(100) DEFAULT '',
  `MEMBER_BIRTH_DATE` datetime DEFAULT '2010-11-11 00:00:00',
  `MEMBER_COUNTER` int(11) DEFAULT 0,
  `MEMBER_GROUP_ID` bigint(20) DEFAULT 0,
  `MEMBER_ID_CARD_NUMBER` varchar(100) DEFAULT '',
  `MEMBER_LAST_UPDATE` datetime DEFAULT '2010-11-11 00:00:00',
  `CONSIGMENT_LIMIT` double DEFAULT NULL,
  `CREDIT_LIMIT` double DEFAULT NULL,
  `MEMBER_USER_ID` varchar(100) DEFAULT NULL,
  `MEMBER_PASSWORD_ID` varchar(20) DEFAULT NULL,
  `CURRENCY_TYPE_ID_CONSIGMENT_LIMIT` bigint(20) DEFAULT NULL,
  `CURRENCY_TYPE_ID_CREDIT_LIMIT` bigint(20) DEFAULT NULL,
  `EMAIL1` varchar(120) DEFAULT NULL,
  `LAST_UPDATE` timestamp NULL DEFAULT current_timestamp(),
  `MEMBER_RELIGION_ID` bigint(20) DEFAULT 0,
  `MEMBER_SEX` int(11) DEFAULT 0,
  `MEMBER_STATUS` int(11) DEFAULT 0,
  `BUSS_ADDRESS` text DEFAULT NULL,
  `REGDATE` datetime DEFAULT '2010-11-11 00:00:00',
  `TOWN` varchar(100) DEFAULT '',
  `PROVINCE` varchar(100) DEFAULT '',
  `COUNTRY` varchar(100) DEFAULT '',
  `TELP_NR` varchar(100) DEFAULT '',
  `TELP_MOBILE` varchar(100) DEFAULT '',
  `FAX` varchar(100) DEFAULT '',
  `DIRECTIONS` varchar(100) DEFAULT '',
  `EMAIL` varchar(100) DEFAULT '',
  `COMPANY_BANK_ACC` varchar(100) DEFAULT NULL,
  `POSITION_PERSON` varchar(100) DEFAULT NULL,
  `POSTAL_CODE_COMPANY` varchar(100) DEFAULT NULL,
  `WEBSITE_COMPANY` varchar(100) DEFAULT NULL,
  `EMAIL_COMPANY` varchar(100) DEFAULT NULL,
  `POSTAL_CODE_HOME` varchar(100) DEFAULT NULL,
  `DIRECTION` text DEFAULT NULL,
  `FULL_NAME` varchar(128) NOT NULL DEFAULT '*',
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `TERM_OF_PAYMENT` int(2) DEFAULT NULL,
  `DAYS_TERM_OF_PAYMENT` int(11) DEFAULT NULL,
  `SISTEM_OF_PAYMENT` bigint(20) DEFAULT NULL,
  `WEEK_DAY_OF_PAYMENT` varchar(100) DEFAULT NULL,
  `WEEK_DAY_OF_SALES_VISIT` varchar(100) DEFAULT NULL,
  `TERM_OF_DELIVERY` int(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_ID`),
  UNIQUE KEY `Index_unique_name` (`PERSON_NAME`,`PERSON_LASTNAME`,`MOTHER_NAME`,`COMP_NAME`,`CONTACT_CODE`),
  KEY `Index_contact_name1` (`SALUTATION`,`PERSON_NAME`,`PERSON_LASTNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `ct_data_custom` */

DROP TABLE IF EXISTS `ct_data_custom`;

CREATE TABLE `ct_data_custom` (
  `DATA_CUSTOM_ID` bigint(20) NOT NULL DEFAULT 0,
  `OWNER_ID` bigint(20) DEFAULT NULL,
  `DATA_NAME` varchar(128) DEFAULT NULL,
  `LINK` varchar(128) DEFAULT NULL,
  `DATA_VALUE` text DEFAULT NULL,
  PRIMARY KEY (`DATA_CUSTOM_ID`),
  UNIQUE KEY `XPKCT_DATA_CUSTOM` (`DATA_CUSTOM_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `currency_rate` */

DROP TABLE IF EXISTS `currency_rate`;

CREATE TABLE `currency_rate` (
  `CURR_RATE_ID` bigint(20) NOT NULL DEFAULT 0,
  `CURR_CODE` varchar(20) DEFAULT NULL,
  `RATE_BANK` float DEFAULT NULL,
  `RATE_COMPANY` float DEFAULT NULL,
  `RATE_TAX` float DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `STATUS` smallint(6) DEFAULT NULL,
  UNIQUE KEY `XPKCURRENCY_RATE` (`CURR_RATE_ID`),
  KEY `XIF1CURRENCY_RATE` (`CURR_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `currency_type` */

DROP TABLE IF EXISTS `currency_type`;

CREATE TABLE `currency_type` (
  `CODE` varchar(20) DEFAULT NULL,
  `CURRENCY_TYPE_ID` bigint(20) DEFAULT NULL,
  `NAME` varchar(20) DEFAULT NULL,
  `TAB_INDEX` smallint(6) DEFAULT NULL,
  `INCLUDE_INF_PROCESS` smallint(6) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `FORMAT_CURRENCY` text DEFAULT NULL,
  UNIQUE KEY `XPKCURRENCY_TYPE` (`CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `dataempl` */

DROP TABLE IF EXISTS `dataempl`;

CREATE TABLE `dataempl` (
  `empl_id` bigint(20) NOT NULL,
  `NIP` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `EntryDate` date DEFAULT NULL,
  `EntryDateDW` date DEFAULT NULL,
  `PermanentDate` date DEFAULT NULL,
  `ContractDate` date DEFAULT NULL,
  `Commencing` date DEFAULT NULL,
  `category_id` bigint(255) DEFAULT NULL,
  `company_id` bigint(20) DEFAULT NULL,
  `dep_id` bigint(20) DEFAULT NULL,
  `div_id` bigint(20) DEFAULT NULL,
  `position_id` bigint(20) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `Sex` int(11) DEFAULT NULL,
  `marital_status_id` bigint(20) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `kecamatan_id` bigint(20) DEFAULT NULL,
  `kabupaten_id` bigint(20) DEFAULT NULL,
  `propinsi_id` bigint(20) DEFAULT NULL,
  `Phone` varchar(255) DEFAULT NULL,
  `SelularPhone` varchar(255) DEFAULT NULL,
  `EmailAddress` varchar(255) DEFAULT NULL,
  `PermanentAddress` varchar(255) DEFAULT NULL,
  `kecamatan_id2` bigint(20) DEFAULT NULL,
  `kabupaten_id2` bigint(20) DEFAULT NULL,
  `propinsi_id2` bigint(20) DEFAULT NULL,
  `IDReligion` bigint(20) DEFAULT NULL,
  `education_id` bigint(20) DEFAULT NULL,
  `EducationDetail` varchar(255) DEFAULT NULL,
  `Reference` varchar(255) DEFAULT NULL,
  `JamsostekNo` varchar(255) DEFAULT NULL,
  `TimeInBoxNo` varchar(255) DEFAULT NULL,
  `NPWP` varchar(255) DEFAULT NULL,
  `ResignDate` date DEFAULT NULL,
  `ResignStatus` int(11) DEFAULT NULL,
  `KTP` varchar(255) DEFAULT NULL,
  `DateOfBirthKTP` date DEFAULT NULL,
  `IssuedByKTP` varchar(255) DEFAULT NULL,
  `ExpiredDateKTP` date DEFAULT NULL,
  `Expired KTP` date DEFAULT NULL,
  `Vehicle` varchar(255) DEFAULT NULL,
  `Parent01` varchar(255) DEFAULT NULL,
  `Parent02` varchar(255) DEFAULT NULL,
  `EmergencyName` varchar(255) DEFAULT NULL,
  `EmergencyCall` varchar(255) DEFAULT NULL,
  `SpecialEmployee` int(1) NOT NULL,
  PRIMARY KEY (`empl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `doc_log_history` */

DROP TABLE IF EXISTS `doc_log_history`;

CREATE TABLE `doc_log_history` (
  `LOG_ID` bigint(20) NOT NULL,
  `LOG_DOCUMENT_ID` bigint(20) DEFAULT NULL,
  `LOG_USER_ID` bigint(20) DEFAULT NULL,
  `LOG_LOGIN_NAME` varchar(64) DEFAULT NULL,
  `LOG_DOCUMENT_NUMBER` varchar(64) DEFAULT NULL,
  `LOG_DOCUMENT_TYPE` varchar(128) DEFAULT NULL,
  `LOG_USER_ACTION` varchar(128) DEFAULT NULL,
  `LOG_OPEN_URL` varchar(255) DEFAULT NULL,
  `LOG_UPDATE_DATE` datetime DEFAULT NULL,
  `LOG_APPLICATION` varchar(45) DEFAULT NULL,
  `LOG_DETAIL` text DEFAULT NULL,
  `LOG_STATUS` int(4) DEFAULT NULL,
  `APPROVER_ID` bigint(20) DEFAULT NULL,
  `APPROVE_DATE` datetime DEFAULT NULL,
  `APPROVER_NOTE` varchar(255) DEFAULT NULL,
  `LOG_PREV` text DEFAULT NULL,
  `LOG_CURR` text DEFAULT NULL,
  `LOG_MODULE` varchar(128) DEFAULT NULL,
  `LOG_EDITED_EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `COMPANY_ID` bigint(20) NOT NULL DEFAULT 0,
  `DIVISION_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `SECTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `APPROVER_1` bigint(20) DEFAULT NULL,
  `APPROVER_2` bigint(20) DEFAULT NULL,
  `APPROVER_3` bigint(20) DEFAULT NULL,
  `APPROVER_4` bigint(20) DEFAULT NULL,
  `APPROVER_5` bigint(20) DEFAULT NULL,
  `APPROVER_6` bigint(20) DEFAULT NULL,
  `APPROVER_1_DATE` date DEFAULT NULL,
  `APPROVER_2_DATE` date DEFAULT NULL,
  `APPROVER_3_DATE` date DEFAULT NULL,
  `APPROVER_4_DATE` date DEFAULT NULL,
  `APPROVER_5_DATE` date DEFAULT NULL,
  `APPROVER_6_DATE` date DEFAULT NULL,
  `QUERY` text DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`),
  KEY `fk_doc_log_history_hr_app_user1_idx` (`LOG_USER_ID`),
  KEY `fk_doc_log_history_hr_app_user2_idx` (`APPROVER_ID`),
  CONSTRAINT `fk_doc_log_history_hr_app_user1` FOREIGN KEY (`LOG_USER_ID`) REFERENCES `hr_app_user` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `dsj_data_detail` */

DROP TABLE IF EXISTS `dsj_data_detail`;

CREATE TABLE `dsj_data_detail` (
  `DATA_DETAIL_ID` bigint(20) NOT NULL,
  `DATA_DETAIL_TITLE` varchar(128) DEFAULT NULL,
  `DATA_DETAIL_DESC` text DEFAULT NULL,
  `DATA_MAIN_ID` bigint(20) DEFAULT NULL,
  `FILENAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DATA_DETAIL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `dsj_data_group` */

DROP TABLE IF EXISTS `dsj_data_group`;

CREATE TABLE `dsj_data_group` (
  `DATA_GROUP_ID` bigint(20) NOT NULL,
  `DATA_GROUP_TITLE` varchar(128) DEFAULT NULL,
  `DATA_GROUP_DESC` text DEFAULT NULL,
  `DATA_GROUP_TIPE` int(3) DEFAULT 0 COMMENT '0 = non icon, 1 = icon',
  `SYSTEM_NAME` int(3) DEFAULT NULL,
  `MODUL` int(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_GROUP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `dsj_data_main` */

DROP TABLE IF EXISTS `dsj_data_main`;

CREATE TABLE `dsj_data_main` (
  `DATA_MAIN_ID` bigint(20) NOT NULL,
  `OBJECT_ID` bigint(20) DEFAULT NULL,
  `OBJECT_CLASS` varchar(128) DEFAULT NULL,
  `DATA_MAIN_TITLE` varchar(128) DEFAULT NULL,
  `DATA_MAIN_DESC` text DEFAULT NULL,
  `DATA_GROUP_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DATA_MAIN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `dummy` */

DROP TABLE IF EXISTS `dummy`;

CREATE TABLE `dummy` (
  `a_long` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `emp_carrier` */

DROP TABLE IF EXISTS `emp_carrier`;

CREATE TABLE `emp_carrier` (
  `ID` double DEFAULT NULL,
  `NIP` varchar(255) DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `DateCarrier` date DEFAULT NULL,
  `DateCarrierEnd` date DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  `Company` varchar(255) DEFAULT NULL,
  `company_id` bigint(20) DEFAULT NULL,
  `Department` varchar(255) DEFAULT NULL,
  `comp_dep` varchar(255) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `Position` varchar(255) DEFAULT NULL,
  `position_id` bigint(20) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `emp_edu` */

DROP TABLE IF EXISTS `emp_edu`;

CREATE TABLE `emp_edu` (
  `employee_id` double DEFAULT NULL,
  `education_id` double DEFAULT NULL,
  `EducationDetail` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `emp_fam` */

DROP TABLE IF EXISTS `emp_fam`;

CREATE TABLE `emp_fam` (
  `ID` bigint(20) DEFAULT NULL,
  `NIP` varchar(255) DEFAULT NULL,
  `FamilyName` varchar(255) DEFAULT NULL,
  `Gender` varchar(255) DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `IDReligion` bigint(20) DEFAULT NULL,
  `Education` varchar(255) DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `education_id` bigint(20) DEFAULT NULL,
  `emp_sex` int(11) DEFAULT NULL,
  `fam_sex` int(11) DEFAULT NULL,
  `fam_rel` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `emp_fam$` */

DROP TABLE IF EXISTS `emp_fam$`;

CREATE TABLE `emp_fam$` (
  `ID` bigint(20) DEFAULT NULL,
  `FamilyName` varchar(255) DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `IDReligion` bigint(20) DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `education_id` bigint(20) DEFAULT NULL,
  `fam_sex` int(2) DEFAULT NULL,
  `fam_rel` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `employee_comp` */

DROP TABLE IF EXISTS `employee_comp`;

CREATE TABLE `employee_comp` (
  `Company` varchar(255) DEFAULT NULL,
  `Division` varchar(255) DEFAULT NULL,
  `Department Name` varchar(255) DEFAULT NULL,
  `Payroll` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `employee_id` varchar(255) DEFAULT NULL,
  `company_id` varchar(255) DEFAULT NULL,
  `company_id_division` varchar(255) DEFAULT NULL,
  `division_id` varchar(255) DEFAULT NULL,
  `division_id_department` varchar(255) DEFAULT NULL,
  `department_id` varchar(255) DEFAULT NULL,
  `level_id` varchar(255) DEFAULT NULL,
  `comm_date` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `employee_start` */

DROP TABLE IF EXISTS `employee_start`;

CREATE TABLE `employee_start` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `REG` text DEFAULT NULL,
  `NIK` text DEFAULT NULL,
  `NAME` text DEFAULT NULL,
  `ADDRESS1` text DEFAULT NULL,
  `ADDRESS2` text DEFAULT NULL,
  `CITY` text DEFAULT NULL,
  `PHONE` varchar(50) DEFAULT NULL,
  `SEX` text DEFAULT NULL,
  `RELIGION` text DEFAULT NULL,
  `DIVITION` double DEFAULT NULL,
  `DEP` text DEFAULT NULL,
  `LOCATION` text DEFAULT NULL,
  `STATUS` text DEFAULT NULL,
  `POSITION` text DEFAULT NULL,
  `CHILD` double DEFAULT NULL,
  `DOB` text DEFAULT NULL,
  `START` datetime DEFAULT NULL,
  `LEVEL` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `group_priv_org` */

DROP TABLE IF EXISTS `group_priv_org`;

CREATE TABLE `group_priv_org` (
  `GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`GROUP_ID`,`PRIV_ID`),
  UNIQUE KEY `XPKGROUP_PRIV` (`GROUP_ID`,`PRIV_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hotel_profile` */

DROP TABLE IF EXISTS `hotel_profile`;

CREATE TABLE `hotel_profile` (
  `HOTEL_PROFILE_ID` bigint(20) NOT NULL DEFAULT 0,
  `HOTEL_NAME` varchar(64) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `CONTACT_PERSON` varchar(64) DEFAULT NULL,
  `EMAIL` varchar(64) DEFAULT NULL,
  `WEB_SITE` varchar(64) DEFAULT NULL,
  `ADDRESS_STREET` text DEFAULT NULL,
  `ADDRESS_CITY` varchar(64) DEFAULT NULL,
  `ADDRESS_PROPINCE` varchar(64) DEFAULT NULL,
  `ADDRESS_PO_BOX` varchar(20) DEFAULT NULL,
  `ADDRESS_ZIP` varchar(20) DEFAULT NULL,
  `ADDRESS_COUNTRY` varchar(64) DEFAULT NULL,
  `ADDRESS_TELP` varchar(20) DEFAULT NULL,
  `ADDRESS_FAX` varchar(20) DEFAULT NULL,
  `VALIDITY_RATE_FROM` date DEFAULT NULL,
  `VALIDITY_RATE_TO` date DEFAULT NULL,
  `CHECK_IN_TIME` datetime DEFAULT NULL,
  `CHECK_OUT_TIME` datetime DEFAULT NULL,
  `DELAYED_OUT_TIME` datetime DEFAULT NULL,
  `QUARTER_TIME` datetime DEFAULT NULL,
  `DAY_USE_TIME` datetime DEFAULT NULL,
  PRIMARY KEY (`HOTEL_PROFILE_ID`),
  UNIQUE KEY `PK_ORGANIZATION` (`HOTEL_PROFILE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_adjusment_working_day` */

DROP TABLE IF EXISTS `hr_adjusment_working_day`;

CREATE TABLE `hr_adjusment_working_day` (
  `ADJUSMENT_WORKING_DAY_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `SISTEM_WORK_HOURS` double DEFAULT NULL,
  `ADJUSMENT_WORKING_DAY` double DEFAULT NULL,
  PRIMARY KEY (`ADJUSMENT_WORKING_DAY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_expired` */

DROP TABLE IF EXISTS `hr_al_stock_expired`;

CREATE TABLE `hr_al_stock_expired` (
  `AL_STOCK_EXPIRED_ID` bigint(20) NOT NULL DEFAULT 0,
  `AL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `EXPIRED_DATE` date NOT NULL DEFAULT '0000-00-00',
  `EXPIRED_QTY` float(15,8) NOT NULL DEFAULT 0.00000000,
  `DECISION_DATE` date DEFAULT NULL,
  `EXPIRED_BY_PIC` varchar(60) DEFAULT NULL,
  `APPROVE_BY_PIC` varchar(60) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  PRIMARY KEY (`AL_STOCK_EXPIRED_ID`),
  KEY `FK_hr_al_stock_expired` (`AL_STOCK_ID`),
  CONSTRAINT `FK_hr_al_stock_expired` FOREIGN KEY (`AL_STOCK_ID`) REFERENCES `hr_al_stock_management` (`AL_STOCK_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_extended` */

DROP TABLE IF EXISTS `hr_al_stock_extended`;

CREATE TABLE `hr_al_stock_extended` (
  `AL_STOCK_EXTENDED_ID` bigint(20) NOT NULL,
  `AL_STOCK_ID` bigint(20) NOT NULL,
  `EXTENDED_DATE` date DEFAULT NULL,
  `EXTENDED_QTY` float(15,8) DEFAULT NULL,
  `DECISION_DATE` date DEFAULT NULL,
  `EXTENDED_BY_PIC` varchar(100) DEFAULT NULL,
  `APPROVE_BY_PIC` varchar(100) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  KEY `FK_hr_al_stock_extended` (`AL_STOCK_ID`),
  CONSTRAINT `FK_hr_al_stock_extended` FOREIGN KEY (`AL_STOCK_ID`) REFERENCES `hr_al_stock_management` (`AL_STOCK_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_management` */

DROP TABLE IF EXISTS `hr_al_stock_management`;

CREATE TABLE `hr_al_stock_management` (
  `AL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `OWNING_DATE` date DEFAULT NULL,
  `AL_QTY` float(15,8) DEFAULT NULL,
  `QTY_USED` float(15,8) DEFAULT NULL,
  `QTY_RESIDUE` float(15,8) DEFAULT NULL,
  `AL_STATUS` tinyint(3) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `ENTITLED` float(15,8) NOT NULL DEFAULT 0.00000000,
  `OPENING` float(15,8) DEFAULT NULL,
  `PREV_BALANCE` float(15,8) DEFAULT NULL,
  `RECORD_DATE` date DEFAULT NULL,
  `ENTITLE_DATE` date DEFAULT NULL,
  `COMMENCING_DATE_HAVE` date DEFAULT NULL,
  `EXPIRED_DATE` date DEFAULT NULL,
  `EXTRA_AL` float(15,8) DEFAULT 0.00000000,
  `EXTRA_AL_DATE` date DEFAULT NULL,
  PRIMARY KEY (`AL_STOCK_ID`),
  KEY `FK_hr_al_stock_management` (`EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_taken` */

DROP TABLE IF EXISTS `hr_al_stock_taken`;

CREATE TABLE `hr_al_stock_taken` (
  `AL_STOCK_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `AL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAKEN_DATE` datetime NOT NULL,
  `TAKEN_QTY` float(15,10) NOT NULL DEFAULT 0.0000000000,
  `PAID_DATE` date DEFAULT NULL,
  `TAKEN_FROM_STATUS` int(11) DEFAULT NULL,
  `LEAVE_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `TAKEN_FINNISH_DATE` datetime NOT NULL,
  PRIMARY KEY (`AL_STOCK_TAKEN_ID`),
  KEY `FK_hr_al_stock_taken_employee` (`EMPLOYEE_ID`),
  KEY `FK_hr_al_stock_taken` (`AL_STOCK_ID`),
  KEY `fk_idx_leave_app_id` (`LEAVE_APPLICATION_ID`),
  CONSTRAINT `FK_hr_al_stock_taken_al_stock_id` FOREIGN KEY (`AL_STOCK_ID`) REFERENCES `hr_al_stock_management` (`AL_STOCK_ID`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_al_stock_taken_app_id` FOREIGN KEY (`LEAVE_APPLICATION_ID`) REFERENCES `hr_leave_application` (`LEAVE_APPLICATION_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_al_stock_taken_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_temp` */

DROP TABLE IF EXISTS `hr_al_stock_temp`;

CREATE TABLE `hr_al_stock_temp` (
  `PAYROLL` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `TO_CLEAR_LAST_YEAR` float(15,8) NOT NULL DEFAULT 0.00000000,
  `ENT_CURR_YEAR` float(15,8) NOT NULL DEFAULT 0.00000000,
  `EARNED_YTD` float(15,8) NOT NULL DEFAULT 0.00000000,
  `TAKEN_MTD` float(15,8) NOT NULL DEFAULT 0.00000000,
  `TAKEN_YTD` float(15,8) NOT NULL DEFAULT 0.00000000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_stock_temp_prev` */

DROP TABLE IF EXISTS `hr_al_stock_temp_prev`;

CREATE TABLE `hr_al_stock_temp_prev` (
  `PAYROLL` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `EARNED` float(15,8) NOT NULL DEFAULT 0.00000000,
  `TAKEN` float(15,8) NOT NULL DEFAULT 0.00000000,
  `EXPIRED` float(15,8) NOT NULL DEFAULT 0.00000000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_al_upload` */

DROP TABLE IF EXISTS `hr_al_upload`;

CREATE TABLE `hr_al_upload` (
  `AL_UPLOAD_ID` bigint(20) NOT NULL DEFAULT 0,
  `OPNAME_DATE` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LAST_PER_TO_CLEAR` float(15,8) NOT NULL DEFAULT 0.00000000,
  `CURR_PERIOD_TAKEN` float(15,8) NOT NULL DEFAULT 0.00000000,
  `DATA_STATUS` int(11) NOT NULL DEFAULT 0,
  `NEW_AL` float(15,8) DEFAULT NULL,
  `STOCK_ID` bigint(20) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `NEW_QTY` float(15,8) DEFAULT NULL,
  UNIQUE KEY `XPKhr_al_upload` (`AL_UPLOAD_ID`),
  UNIQUE KEY `UNQ_AL_UPLOAD` (`OPNAME_DATE`,`EMPLOYEE_ID`),
  KEY `FK_hr_al_upload` (`EMPLOYEE_ID`),
  CONSTRAINT `FK_hr_al_upload` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_app_group` */

DROP TABLE IF EXISTS `hr_app_group`;

CREATE TABLE `hr_app_group` (
  `GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_NAME` varchar(64) DEFAULT NULL,
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `STATUS` int(11) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_app_main` */

DROP TABLE IF EXISTS `hr_app_main`;

CREATE TABLE `hr_app_main` (
  `HR_APP_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `EMP_POSITION_ID` bigint(20) DEFAULT NULL,
  `EMP_DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `DATE_ASSUMED_POSITION` date DEFAULT NULL,
  `DATE_JOINED_HOTEL` date DEFAULT NULL,
  `ASSESSOR_ID` bigint(20) DEFAULT NULL,
  `ASS_POSITION_ID` bigint(20) DEFAULT NULL,
  `DATE_OF_ASSESSMENT` date DEFAULT NULL,
  `DATE_OF_LAST_ASSESSMENT` date DEFAULT NULL,
  `DATE_OF_NEXT_ASSESSMENT` date DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `TOTAL_ASS` int(11) DEFAULT NULL,
  `TOTAL_SCORE` double DEFAULT NULL,
  `SCORE_AVERAGE` double DEFAULT NULL,
  `DIVISION_HEAD` bigint(20) DEFAULT NULL,
  `EMP_SIGN_DATE` date DEFAULT NULL,
  `ASS_SIGN_DATE` date DEFAULT NULL,
  `DIV_SIGN_DATE` date DEFAULT NULL,
  `APPROVAL_1_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_1` datetime DEFAULT NULL,
  `APPROVAL_2_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_2` datetime DEFAULT NULL,
  `APPROVAL_3_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_3` datetime DEFAULT NULL,
  `APPROVAL_4_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_4` datetime DEFAULT NULL,
  `APPROVAL_5_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_5` datetime DEFAULT NULL,
  `APPROVAL_6_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_6` datetime DEFAULT NULL,
  `DATA_PERIOD_FROM` date DEFAULT NULL,
  `DATA_PERIOD_TO` date DEFAULT NULL,
  PRIMARY KEY (`HR_APP_MAIN_ID`),
  UNIQUE KEY `XPKhr_app_main` (`HR_APP_MAIN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_app_privilege` */

DROP TABLE IF EXISTS `hr_app_privilege`;

CREATE TABLE `hr_app_privilege` (
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_NAME` varchar(64) DEFAULT NULL,
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`PRIV_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_app_privilege_obj` */

DROP TABLE IF EXISTS `hr_app_privilege_obj`;

CREATE TABLE `hr_app_privilege_obj` (
  `PRIV_OBJ_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0,
  `CODE` int(11) DEFAULT NULL,
  PRIMARY KEY (`PRIV_OBJ_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_app_user` */

DROP TABLE IF EXISTS `hr_app_user`;

CREATE TABLE `hr_app_user` (
  `USER_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOGIN_ID` varchar(20) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `FULL_NAME` varchar(32) DEFAULT NULL,
  `EMAIL` varchar(64) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `UPDATE_DATE` datetime DEFAULT NULL,
  `USER_STATUS` int(11) DEFAULT NULL,
  `LAST_LOGIN_DATE` datetime DEFAULT NULL,
  `LAST_LOGIN_IP` varchar(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `POSITION_LEVEL_ID` varchar(32) DEFAULT NULL,
  `EXCEL_IO` int(1) DEFAULT 1,
  `ADMIN_STATUS` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `XPKAPP_USER` (`USER_ID`),
  UNIQUE KEY `LOGIN_ID` (`LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_appraisal` */

DROP TABLE IF EXISTS `hr_appraisal`;

CREATE TABLE `hr_appraisal` (
  `HR_APPRAISAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMP_COMMENT` text COLLATE latin1_general_ci DEFAULT NULL,
  `ASS_COMMENT` text COLLATE latin1_general_ci DEFAULT NULL,
  `RATING` double DEFAULT NULL,
  `HR_APP_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `ASS_FORM_ITEM_ID` bigint(20) DEFAULT NULL,
  `ANSWER_1` text COLLATE latin1_general_ci NOT NULL,
  `ANSWER_2` text COLLATE latin1_general_ci NOT NULL,
  `ANSWER_3` text COLLATE latin1_general_ci NOT NULL,
  `ANSWER_4` text COLLATE latin1_general_ci NOT NULL,
  `ANSWER_5` text COLLATE latin1_general_ci NOT NULL,
  `ANSWER_6` text COLLATE latin1_general_ci NOT NULL,
  `REALIZATION` decimal(20,2) DEFAULT 0.00,
  `EVIDENCE` varchar(512) COLLATE latin1_general_ci DEFAULT NULL,
  `POINT` decimal(10,2) DEFAULT 0.00,
  `WEIGHT` double DEFAULT NULL,
  `KPI_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`HR_APPRAISAL_ID`),
  UNIQUE KEY `XPKhr_appraisal` (`HR_APPRAISAL_ID`,`HR_APP_MAIN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_arap_creditor` */

DROP TABLE IF EXISTS `hr_arap_creditor`;

CREATE TABLE `hr_arap_creditor` (
  `ARAP_CREDITOR_ID` bigint(20) DEFAULT NULL,
  `CREDITOR_NAME` varchar(100) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_arap_item` */

DROP TABLE IF EXISTS `hr_arap_item`;

CREATE TABLE `hr_arap_item` (
  `arap_item_id` bigint(20) NOT NULL DEFAULT 0,
  `arap_main_id` bigint(20) NOT NULL DEFAULT 0,
  `angsuran` double DEFAULT 0,
  `due_date` date DEFAULT NULL,
  `description` varchar(8190) DEFAULT NULL,
  `left_to_pay` double NOT NULL DEFAULT 0,
  `rate` double NOT NULL DEFAULT 0,
  `receive_aktiva_id` bigint(20) NOT NULL DEFAULT 0,
  `selling_aktiva_id` bigint(20) NOT NULL DEFAULT 0,
  `currency_id` bigint(20) NOT NULL DEFAULT 0,
  `arap_item_status` smallint(6) NOT NULL DEFAULT 0,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`arap_item_id`),
  KEY `fki_arap_dtl_currency` (`currency_id`),
  KEY `fki_arap_dtl_main` (`arap_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_arap_main` */

DROP TABLE IF EXISTS `hr_arap_main`;

CREATE TABLE `hr_arap_main` (
  `arap_main_id` bigint(20) NOT NULL DEFAULT 0,
  `voucher_no` varchar(10) DEFAULT NULL,
  `voucher_date` date DEFAULT NULL,
  `contact_id` bigint(20) NOT NULL DEFAULT 0,
  `number_of_payment` int(11) NOT NULL DEFAULT 0,
  `id_perkiraan_lawan` bigint(20) NOT NULL DEFAULT 0,
  `id_perkiraan` bigint(20) NOT NULL DEFAULT 0,
  `id_currency` bigint(20) NOT NULL DEFAULT 0,
  `counter` int(11) DEFAULT 0,
  `rate` double DEFAULT 0,
  `amount` double DEFAULT 0,
  `nota_no` varchar(50) DEFAULT NULL,
  `nota_date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `arap_type` smallint(6) NOT NULL DEFAULT 0,
  `arap_doc_status` smallint(6) NOT NULL DEFAULT 0,
  `arap_main_status` smallint(6) NOT NULL DEFAULT 0,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `jurnal_id` bigint(20) DEFAULT 0,
  `component_deduction_id` bigint(20) DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `entry_date` date DEFAULT NULL,
  `period_every` int(2) DEFAULT NULL,
  `period_every_dmy` int(2) DEFAULT NULL,
  `start_of_payment_date` date DEFAULT NULL,
  `payment_amount_plan` double DEFAULT NULL,
  `PERIOD_TYPE` int(2) DEFAULT NULL,
  `PERIOD_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`arap_main_id`),
  UNIQUE KEY `unq_arap_voucher` (`voucher_no`),
  KEY `fki_arap_coa_lawan` (`id_perkiraan`),
  KEY `fki_arap_contact` (`contact_id`),
  KEY `fki_arap_currency` (`id_currency`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_arap_payment` */

DROP TABLE IF EXISTS `hr_arap_payment`;

CREATE TABLE `hr_arap_payment` (
  `arap_payment_id` bigint(20) NOT NULL DEFAULT 0,
  `arap_main_id` bigint(20) NOT NULL DEFAULT 0,
  `payment_no` varchar(10) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `id_perkiraan_payment` bigint(20) NOT NULL DEFAULT 0,
  `id_currency` bigint(20) NOT NULL DEFAULT 0,
  `counter` int(11) NOT NULL DEFAULT 0,
  `rate` double DEFAULT 0,
  `amount` double DEFAULT 0,
  `selling_aktiva_id` bigint(20) NOT NULL DEFAULT 0,
  `receive_aktiva_id` bigint(20) NOT NULL DEFAULT 0,
  `arap_type` smallint(2) NOT NULL DEFAULT 0,
  `contact_id` bigint(20) NOT NULL DEFAULT 0,
  `left_to_pay` double DEFAULT 0,
  `payment_status` smallint(2) NOT NULL DEFAULT 0,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `jurnal_id` bigint(20) DEFAULT 0,
  `bo_payment_id` bigint(20) DEFAULT 0 COMMENT 'backoffice payment id',
  `employee_id` bigint(20) DEFAULT NULL,
  `payment_type` int(2) DEFAULT NULL,
  PRIMARY KEY (`arap_payment_id`),
  KEY `fki_arap_pay_coa` (`id_perkiraan_payment`),
  KEY `fki_arap_pay_main` (`arap_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ass_form_item` */

DROP TABLE IF EXISTS `hr_ass_form_item`;

CREATE TABLE `hr_ass_form_item` (
  `ASS_FORM_ITEM_ID` bigint(20) NOT NULL DEFAULT 0,
  `TITLE` varchar(256) COLLATE latin1_general_ci DEFAULT NULL,
  `TITLE_L2` varchar(256) COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_1` text COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_2` text COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_3` text COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_4` text COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_5` text COLLATE latin1_general_ci DEFAULT NULL,
  `ITEM_POIN_6` text COLLATE latin1_general_ci DEFAULT NULL,
  `TYPE` int(11) DEFAULT NULL,
  `ORDER_NUMBER` int(11) DEFAULT NULL,
  `NUMBER` int(11) DEFAULT NULL,
  `PAGE` int(11) NOT NULL DEFAULT 0,
  `HEIGHT` int(11) NOT NULL DEFAULT 0,
  `ASS_FORM_SECTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `KPI_LIST_ID` bigint(20) DEFAULT 0,
  `WEIGHT_POINT` decimal(10,2) DEFAULT 0.00,
  `KPI_TARGET` decimal(20,2) DEFAULT NULL,
  `KPI_UNIT` varchar(128) COLLATE latin1_general_ci DEFAULT NULL,
  `KPI_NOTE` varchar(256) COLLATE latin1_general_ci DEFAULT NULL,
  `FORMULA` text COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`ASS_FORM_ITEM_ID`),
  UNIQUE KEY `XPKhr_ass_form_item` (`ASS_FORM_ITEM_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_ass_form_main` */

DROP TABLE IF EXISTS `hr_ass_form_main`;

CREATE TABLE `hr_ass_form_main` (
  `ASS_FORM_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_RANK_ID` bigint(20) NOT NULL DEFAULT 0,
  `TITLE` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `SUBTITLE` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `TITLE_L2` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `SUBTITLE_L2` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `MAIN_DATA` varchar(20) COLLATE latin1_general_ci DEFAULT NULL,
  `NOTE` text COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`ASS_FORM_MAIN_ID`),
  UNIQUE KEY `XPKhr_ass_form_main` (`ASS_FORM_MAIN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_ass_form_main_detail` */

DROP TABLE IF EXISTS `hr_ass_form_main_detail`;

CREATE TABLE `hr_ass_form_main_detail` (
  `ASS_FORM_MAIN_ID` bigint(20) DEFAULT 0,
  `GROUP_RANK_ID` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ass_form_section` */

DROP TABLE IF EXISTS `hr_ass_form_section`;

CREATE TABLE `hr_ass_form_section` (
  `ASS_FORM_SECTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `SECTION` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `SECTION_L2` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `DESCRIPTION_L2` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `ASS_FORM_MAIN_ID` bigint(20) DEFAULT NULL,
  `ORDER_NUMBER` int(11) NOT NULL DEFAULT 0,
  `TYPE_SECTION` int(11) NOT NULL DEFAULT 0,
  `PAGE` int(11) NOT NULL DEFAULT 0,
  `WEIGHT_POINT` decimal(10,2) DEFAULT 0.00,
  `POINT_EVALUATION_ID` bigint(20) DEFAULT 0,
  `PREDICATE_EVALUATION_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`ASS_FORM_SECTION_ID`),
  UNIQUE KEY `XPKhr_ass_form_section` (`ASS_FORM_SECTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_assessment_type` */

DROP TABLE IF EXISTS `hr_assessment_type`;

CREATE TABLE `hr_assessment_type` (
  `ASSESSMENT_ID` bigint(25) NOT NULL,
  `ASSESSMENT_TYPE` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ASSESSMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_award` */

DROP TABLE IF EXISTS `hr_award`;

CREATE TABLE `hr_award` (
  `AWARD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMP_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPT_ID` bigint(20) NOT NULL DEFAULT 0,
  `SECT_ID` bigint(20) NOT NULL DEFAULT 0,
  `DATE` date DEFAULT NULL,
  `TYPE` bigint(20) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `PROVIDER_ID` bigint(20) DEFAULT NULL,
  `TITLE` varchar(64) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL DEFAULT 0,
  `COMPANY_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`AWARD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_award_type` */

DROP TABLE IF EXISTS `hr_award_type`;

CREATE TABLE `hr_award_type` (
  `AWARD_TYPE_ID` bigint(20) NOT NULL DEFAULT 0,
  `AWARD_TYPE` varchar(50) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`AWARD_TYPE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_barcode_logger` */

DROP TABLE IF EXISTS `hr_barcode_logger`;

CREATE TABLE `hr_barcode_logger` (
  `BARCODE_LOGGER_ID` bigint(20) NOT NULL DEFAULT 0,
  `CMD_TYPE` varchar(30) NOT NULL DEFAULT '',
  `DATE` datetime DEFAULT NULL,
  `NOTES` text DEFAULT NULL,
  PRIMARY KEY (`BARCODE_LOGGER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_cafe_checklist` */

DROP TABLE IF EXISTS `hr_cafe_checklist`;

CREATE TABLE `hr_cafe_checklist` (
  `CAFE_CHECKLIST_ID` bigint(20) NOT NULL DEFAULT 0,
  `MEAL_TIME_ID` bigint(20) DEFAULT NULL,
  `CHECK_DATE` date DEFAULT NULL,
  `CHECKED_BY` bigint(20) DEFAULT NULL,
  `APPROVED_BY` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CAFE_CHECKLIST_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_cafe_evaluation` */

DROP TABLE IF EXISTS `hr_cafe_evaluation`;

CREATE TABLE `hr_cafe_evaluation` (
  `CAFE_EVALUATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECKLIST_MARK_ID` bigint(20) DEFAULT NULL,
  `CAFE_CHECKLIST_ID` bigint(20) DEFAULT NULL,
  `CHECKLIST_ITEM_ID` bigint(20) DEFAULT NULL,
  `REMARK` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`CAFE_EVALUATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_grade_level` */

DROP TABLE IF EXISTS `hr_candidate_grade_level`;

CREATE TABLE `hr_candidate_grade_level` (
  `CANDIDATE_GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `MIN_GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `MAX_GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CANDIDATE_GRADE_LEVEL_ID`),
  KEY `fk_hr_candidate_grade_level_hr_candidate_main1_idx` (`CANDIDATE_MAIN_ID`),
  KEY `fk_hr_candidate_grade_level_hr_grade_level1_idx` (`MIN_GRADE_LEVEL_ID`),
  KEY `fk_hr_candidate_grade_level_hr_grade_level2_idx` (`MAX_GRADE_LEVEL_ID`),
  CONSTRAINT `fk_hr_candidate_grade_level_hr_candidate_main1` FOREIGN KEY (`CANDIDATE_MAIN_ID`) REFERENCES `hr_candidate_main` (`CANDIDATE_MAIN_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hr_candidate_grade_level_hr_grade_level1` FOREIGN KEY (`MIN_GRADE_LEVEL_ID`) REFERENCES `hr_grade_level` (`GRADE_LEVEL_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hr_candidate_grade_level_hr_grade_level2` FOREIGN KEY (`MAX_GRADE_LEVEL_ID`) REFERENCES `hr_grade_level` (`GRADE_LEVEL_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_location` */

DROP TABLE IF EXISTS `hr_candidate_location`;

CREATE TABLE `hr_candidate_location` (
  `CANDIDATE_LOC_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `CODE` int(2) NOT NULL,
  PRIMARY KEY (`CANDIDATE_LOC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_main` */

DROP TABLE IF EXISTS `hr_candidate_main`;

CREATE TABLE `hr_candidate_main` (
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `TITLE` varchar(128) NOT NULL,
  `OBJECTIVE` text NOT NULL,
  `DUE_DATE` date NOT NULL,
  `REQUESTED_BY` bigint(20) NOT NULL,
  `DATE_OF_REQUEST` date NOT NULL,
  `SCORE_TOLERANCE` double(4,0) NOT NULL,
  `CREATED_BY` bigint(20) NOT NULL,
  `CREATED_DATE` date NOT NULL,
  `STATUS_DOC` int(2) NOT NULL,
  `CANDIDATE_TYPE` int(2) NOT NULL,
  `APPROVE_BY_ID_1` bigint(20) NOT NULL,
  `APPROVE_BY_ID_2` bigint(20) NOT NULL,
  `APPROVE_BY_ID_3` bigint(20) NOT NULL,
  `APPROVE_BY_ID_4` bigint(20) NOT NULL,
  `APPROVE_DATE_1` date NOT NULL,
  `APPROVE_DATE_2` date NOT NULL,
  `APPROVE_DATE_3` date NOT NULL,
  `APPROVE_DATE_4` date NOT NULL,
  `STATUS_AKTIF` int(2) DEFAULT 0,
  `STATUS_MBT` int(2) DEFAULT 0,
  `STATUS_RESIGN` int(2) DEFAULT 0,
  PRIMARY KEY (`CANDIDATE_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_pos_expirience` */

DROP TABLE IF EXISTS `hr_candidate_pos_expirience`;

CREATE TABLE `hr_candidate_pos_expirience` (
  `CAND_POS_EXPIRIENCE_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `EXPERIENCE_ID` bigint(20) NOT NULL,
  `DURATION_MIN` int(2) NOT NULL,
  `DURATION_RECOMMENDED` int(2) DEFAULT NULL,
  `NOTE` varchar(128) DEFAULT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `TYPE` int(2) DEFAULT 0,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CAND_POS_EXPIRIENCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_position` */

DROP TABLE IF EXISTS `hr_candidate_position`;

CREATE TABLE `hr_candidate_position` (
  `CANDIDATE_POS_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `CANDIDATE_LOC_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `NUMBER_OF_CANDIDATE` int(8) NOT NULL,
  `DUE_DATE` date NOT NULL,
  `OBJECTIVES` varchar(256) NOT NULL,
  `CANDIDATE_TYPE` int(4) NOT NULL,
  PRIMARY KEY (`CANDIDATE_POS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_position_assessment` */

DROP TABLE IF EXISTS `hr_candidate_position_assessment`;

CREATE TABLE `hr_candidate_position_assessment` (
  `CAND_POS_ASS_ID` bigint(25) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(25) DEFAULT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  `ASSESSMENT_ID` bigint(25) DEFAULT NULL,
  `SCORE_MIN` int(2) DEFAULT NULL,
  `SCORE_MAX` int(2) DEFAULT NULL,
  `BOBOT` int(2) DEFAULT NULL,
  `TAHUN` int(2) DEFAULT NULL,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CAND_POS_ASS_ID`),
  KEY `ASSESSMENT_ID` (`ASSESSMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_candidate_position_competency` */

DROP TABLE IF EXISTS `hr_candidate_position_competency`;

CREATE TABLE `hr_candidate_position_competency` (
  `CAND_POS_COMP_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `SCORE_MIN` int(4) DEFAULT NULL,
  `SCORE_MAX` int(4) DEFAULT NULL,
  `BOBOT` int(4) DEFAULT NULL,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CAND_POS_COMP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_position_education` */

DROP TABLE IF EXISTS `hr_candidate_position_education`;

CREATE TABLE `hr_candidate_position_education` (
  `CAND_POS_EDU_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `SCORE_MIN` int(4) DEFAULT NULL,
  `SCORE_MAX` int(4) DEFAULT NULL,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CAND_POS_EDU_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_position_kpi` */

DROP TABLE IF EXISTS `hr_candidate_position_kpi`;

CREATE TABLE `hr_candidate_position_kpi` (
  `CAND_POS_KPI_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `KPI_ID` bigint(20) DEFAULT NULL,
  `SCORE_MIN` int(4) DEFAULT NULL,
  `SCORE_MAX` int(4) DEFAULT NULL,
  PRIMARY KEY (`CAND_POS_KPI_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_position_power` */

DROP TABLE IF EXISTS `hr_candidate_position_power`;

CREATE TABLE `hr_candidate_position_power` (
  `CANDIDATE_POSITION_POWER_ID` bigint(25) DEFAULT NULL,
  `CANDIDATE_MAIN_ID` bigint(25) DEFAULT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  `FIRST_POWER_CHARACTER_ID` bigint(25) DEFAULT NULL,
  `SECOND_POWER_CHARACTER_ID` bigint(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_candidate_position_training` */

DROP TABLE IF EXISTS `hr_candidate_position_training`;

CREATE TABLE `hr_candidate_position_training` (
  `CAND_POS_TRAINING_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `SCORE_MIN` int(4) DEFAULT NULL,
  `SCORE_MAX` int(4) DEFAULT NULL,
  `KONDISI` int(2) DEFAULT 0,
  PRIMARY KEY (`CAND_POS_TRAINING_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_result` */

DROP TABLE IF EXISTS `hr_candidate_result`;

CREATE TABLE `hr_candidate_result` (
  `CANDIDATE_RESULT_ID` bigint(25) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(25) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(25) DEFAULT NULL,
  `POSITION_TYPE_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`CANDIDATE_RESULT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_candidate_search_target` */

DROP TABLE IF EXISTS `hr_candidate_search_target`;

CREATE TABLE `hr_candidate_search_target` (
  `CANDIDATE_SEARCH_TARGET_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `COMPANY_IDS` varchar(255) NOT NULL,
  `DIVISION_IDS` varchar(255) NOT NULL,
  `DEPARTMENT_IDS` varchar(255) NOT NULL,
  `SECTION_IDS` varchar(255) NOT NULL,
  `POSITION_IDS` varchar(255) NOT NULL,
  `LEVEL_IDS` varchar(255) NOT NULL,
  `EMP_CATEGORY_IDS` varchar(255) NOT NULL,
  `SEX` int(2) NOT NULL,
  PRIMARY KEY (`CANDIDATE_SEARCH_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_candidate_selection` */

DROP TABLE IF EXISTS `hr_candidate_selection`;

CREATE TABLE `hr_candidate_selection` (
  `CANDIDATE_SELECTION_ID` bigint(20) NOT NULL,
  `CANDIDATE_MAIN_ID` bigint(20) NOT NULL,
  `CANDIDATE_EDUCATION_ID` bigint(20) NOT NULL,
  `CANDIDATE_TRAINING_ID` bigint(20) NOT NULL,
  `CANDIDATE_COMPETENCY_ID` bigint(20) NOT NULL,
  `CANDIDATE_KPI_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`CANDIDATE_SELECTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_canteen_detail_report` */

DROP TABLE IF EXISTS `hr_canteen_detail_report`;

CREATE TABLE `hr_canteen_detail_report` (
  `employee_payroll` char(63) NOT NULL DEFAULT '',
  `employee_name` char(255) NOT NULL DEFAULT '',
  `ma1` int(11) NOT NULL DEFAULT 0,
  `ma2` int(11) NOT NULL DEFAULT 0,
  `ma3` int(11) NOT NULL DEFAULT 0,
  `ma4` int(11) NOT NULL DEFAULT 0,
  `ma5` int(11) NOT NULL DEFAULT 0,
  `ma6` int(11) NOT NULL DEFAULT 0,
  `ma7` int(11) NOT NULL DEFAULT 0,
  `ma8` int(11) NOT NULL DEFAULT 0,
  `ma9` int(11) NOT NULL DEFAULT 0,
  `ma10` int(11) NOT NULL DEFAULT 0,
  `ma11` int(11) NOT NULL DEFAULT 0,
  `ma12` int(11) NOT NULL DEFAULT 0,
  `ma13` int(11) NOT NULL DEFAULT 0,
  `ma14` int(11) NOT NULL DEFAULT 0,
  `ma15` int(11) NOT NULL DEFAULT 0,
  `ma16` int(11) NOT NULL DEFAULT 0,
  `ma17` int(11) NOT NULL DEFAULT 0,
  `ma18` int(11) NOT NULL DEFAULT 0,
  `ma19` int(11) NOT NULL DEFAULT 0,
  `ma20` int(11) NOT NULL DEFAULT 0,
  `ma21` int(11) NOT NULL DEFAULT 0,
  `ma22` int(11) NOT NULL DEFAULT 0,
  `ma23` int(11) NOT NULL DEFAULT 0,
  `ma24` int(11) NOT NULL DEFAULT 0,
  `ma25` int(11) NOT NULL DEFAULT 0,
  `ma26` int(11) NOT NULL DEFAULT 0,
  `ma27` int(11) NOT NULL DEFAULT 0,
  `ma28` int(11) NOT NULL DEFAULT 0,
  `ma29` int(11) NOT NULL DEFAULT 0,
  `ma30` int(11) NOT NULL DEFAULT 0,
  `ma31` int(11) NOT NULL DEFAULT 0,
  `matotal` int(11) NOT NULL DEFAULT 0,
  `n1` int(11) NOT NULL DEFAULT 0,
  `n2` int(11) NOT NULL DEFAULT 0,
  `n3` int(11) NOT NULL DEFAULT 0,
  `n4` int(11) NOT NULL DEFAULT 0,
  `n5` int(11) NOT NULL DEFAULT 0,
  `n6` int(11) NOT NULL DEFAULT 0,
  `n7` int(11) NOT NULL DEFAULT 0,
  `n8` int(11) NOT NULL DEFAULT 0,
  `n9` int(11) NOT NULL DEFAULT 0,
  `n10` int(11) NOT NULL DEFAULT 0,
  `n11` int(11) NOT NULL DEFAULT 0,
  `n12` int(11) NOT NULL DEFAULT 0,
  `n13` int(11) NOT NULL DEFAULT 0,
  `n14` int(11) NOT NULL DEFAULT 0,
  `n15` int(11) NOT NULL DEFAULT 0,
  `n16` int(11) NOT NULL DEFAULT 0,
  `n17` int(11) NOT NULL DEFAULT 0,
  `n18` int(11) NOT NULL DEFAULT 0,
  `n19` int(11) NOT NULL DEFAULT 0,
  `n20` int(11) NOT NULL DEFAULT 0,
  `n21` int(11) NOT NULL DEFAULT 0,
  `n22` int(11) NOT NULL DEFAULT 0,
  `n23` int(11) NOT NULL DEFAULT 0,
  `n24` int(11) NOT NULL DEFAULT 0,
  `n25` int(11) NOT NULL DEFAULT 0,
  `n26` int(11) NOT NULL DEFAULT 0,
  `n27` int(11) NOT NULL DEFAULT 0,
  `n28` int(11) NOT NULL DEFAULT 0,
  `n29` int(11) NOT NULL DEFAULT 0,
  `n30` int(11) NOT NULL DEFAULT 0,
  `n31` int(11) NOT NULL DEFAULT 0,
  `ntotal` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_canteen_schedule` */

DROP TABLE IF EXISTS `hr_canteen_schedule`;

CREATE TABLE `hr_canteen_schedule` (
  `CANTEEN_SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `CODE` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `SCHEDULE_DATE` date NOT NULL DEFAULT '0000-00-00',
  `TIME_OPEN` time NOT NULL DEFAULT '00:00:00',
  `TIME_CLOSE` time NOT NULL DEFAULT '00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_canteen_summary_report` */

DROP TABLE IF EXISTS `hr_canteen_summary_report`;

CREATE TABLE `hr_canteen_summary_report` (
  `department_id` bigint(20) NOT NULL DEFAULT 0,
  `department_name` char(255) NOT NULL DEFAULT '',
  `section_id` bigint(20) NOT NULL DEFAULT 0,
  `section_name` char(255) NOT NULL DEFAULT '',
  `ma1` int(11) NOT NULL DEFAULT 0,
  `ma2` int(11) NOT NULL DEFAULT 0,
  `ma3` int(11) NOT NULL DEFAULT 0,
  `ma4` int(11) NOT NULL DEFAULT 0,
  `ma5` int(11) NOT NULL DEFAULT 0,
  `ma6` int(11) NOT NULL DEFAULT 0,
  `ma7` int(11) NOT NULL DEFAULT 0,
  `ma8` int(11) NOT NULL DEFAULT 0,
  `ma9` int(11) NOT NULL DEFAULT 0,
  `ma10` int(11) NOT NULL DEFAULT 0,
  `ma11` int(11) NOT NULL DEFAULT 0,
  `ma12` int(11) NOT NULL DEFAULT 0,
  `ma13` int(11) NOT NULL DEFAULT 0,
  `ma14` int(11) NOT NULL DEFAULT 0,
  `ma15` int(11) NOT NULL DEFAULT 0,
  `ma16` int(11) NOT NULL DEFAULT 0,
  `ma17` int(11) NOT NULL DEFAULT 0,
  `ma18` int(11) NOT NULL DEFAULT 0,
  `ma19` int(11) NOT NULL DEFAULT 0,
  `ma20` int(11) NOT NULL DEFAULT 0,
  `ma21` int(11) NOT NULL DEFAULT 0,
  `ma22` int(11) NOT NULL DEFAULT 0,
  `ma23` int(11) NOT NULL DEFAULT 0,
  `ma24` int(11) NOT NULL DEFAULT 0,
  `ma25` int(11) NOT NULL DEFAULT 0,
  `ma26` int(11) NOT NULL DEFAULT 0,
  `ma27` int(11) NOT NULL DEFAULT 0,
  `ma28` int(11) NOT NULL DEFAULT 0,
  `ma29` int(11) NOT NULL DEFAULT 0,
  `ma30` int(11) NOT NULL DEFAULT 0,
  `ma31` int(11) NOT NULL DEFAULT 0,
  `matotal` int(11) NOT NULL DEFAULT 0,
  `n1` int(11) NOT NULL DEFAULT 0,
  `n2` int(11) NOT NULL DEFAULT 0,
  `n3` int(11) NOT NULL DEFAULT 0,
  `n4` int(11) NOT NULL DEFAULT 0,
  `n5` int(11) NOT NULL DEFAULT 0,
  `n6` int(11) NOT NULL DEFAULT 0,
  `n7` int(11) NOT NULL DEFAULT 0,
  `n8` int(11) NOT NULL DEFAULT 0,
  `n9` int(11) NOT NULL DEFAULT 0,
  `n10` int(11) NOT NULL DEFAULT 0,
  `n11` int(11) NOT NULL DEFAULT 0,
  `n12` int(11) NOT NULL DEFAULT 0,
  `n13` int(11) NOT NULL DEFAULT 0,
  `n14` int(11) NOT NULL DEFAULT 0,
  `n15` int(11) NOT NULL DEFAULT 0,
  `n16` int(11) NOT NULL DEFAULT 0,
  `n17` int(11) NOT NULL DEFAULT 0,
  `n18` int(11) NOT NULL DEFAULT 0,
  `n19` int(11) NOT NULL DEFAULT 0,
  `n20` int(11) NOT NULL DEFAULT 0,
  `n21` int(11) NOT NULL DEFAULT 0,
  `n22` int(11) NOT NULL DEFAULT 0,
  `n23` int(11) NOT NULL DEFAULT 0,
  `n24` int(11) NOT NULL DEFAULT 0,
  `n25` int(11) NOT NULL DEFAULT 0,
  `n26` int(11) NOT NULL DEFAULT 0,
  `n27` int(11) NOT NULL DEFAULT 0,
  `n28` int(11) NOT NULL DEFAULT 0,
  `n29` int(11) NOT NULL DEFAULT 0,
  `n30` int(11) NOT NULL DEFAULT 0,
  `n31` int(11) NOT NULL DEFAULT 0,
  `ntotal` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_canteen_visitation` */

DROP TABLE IF EXISTS `hr_canteen_visitation`;

CREATE TABLE `hr_canteen_visitation` (
  `VISITATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `VISITATION_TIME` datetime DEFAULT NULL,
  `STATUS` tinyint(4) DEFAULT NULL,
  `ANALYZED` int(11) DEFAULT NULL,
  `TRANSFERRED` int(11) DEFAULT NULL,
  `NUM_OF_VISITATION` int(11) DEFAULT 1,
  PRIMARY KEY (`VISITATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_card_question` */

DROP TABLE IF EXISTS `hr_card_question`;

CREATE TABLE `hr_card_question` (
  `CARD_QUESTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `CARD_QUESTION_GROUP_ID` bigint(20) DEFAULT NULL,
  `QUESTION` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`CARD_QUESTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_card_question_group` */

DROP TABLE IF EXISTS `hr_card_question_group`;

CREATE TABLE `hr_card_question_group` (
  `CARD_QUESTION_GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CARD_QUESTION_GROUP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_category_appraisal` */

DROP TABLE IF EXISTS `hr_category_appraisal`;

CREATE TABLE `hr_category_appraisal` (
  `CATEGORY_APPRAISAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  `CATEGORY` varchar(100) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_APPRAISAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_category_criteria` */

DROP TABLE IF EXISTS `hr_category_criteria`;

CREATE TABLE `hr_category_criteria` (
  `CATEGORY_CRITERIA_ID` bigint(20) NOT NULL DEFAULT 0,
  `CATEGORY_APPRAISAL_ID` bigint(20) DEFAULT NULL,
  `CRITERIA` varchar(200) DEFAULT NULL,
  `DESC_1` text DEFAULT NULL,
  `DESC_2` text DEFAULT NULL,
  `DESC_3` text DEFAULT NULL,
  `DESC_4` text DEFAULT NULL,
  `DESC_5` text DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_CRITERIA_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_checklist_group` */

DROP TABLE IF EXISTS `hr_checklist_group`;

CREATE TABLE `hr_checklist_group` (
  `CHECKLIST_GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECKLIST_GROUP` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CHECKLIST_GROUP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_checklist_item` */

DROP TABLE IF EXISTS `hr_checklist_item`;

CREATE TABLE `hr_checklist_item` (
  `CHECKLIST_ITEM_ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECKLIST_GROUP_ID` bigint(20) DEFAULT NULL,
  `CHECKLIST_ITEM` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`CHECKLIST_ITEM_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_checklist_mark` */

DROP TABLE IF EXISTS `hr_checklist_mark`;

CREATE TABLE `hr_checklist_mark` (
  `CHECKLIST_MARK_ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECKLIST_MARK` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`CHECKLIST_MARK_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_comment_card` */

DROP TABLE IF EXISTS `hr_comment_card`;

CREATE TABLE `hr_comment_card` (
  `COMMENT_CARD_ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECKLIST_MARK_ID` bigint(20) DEFAULT NULL,
  `COMMENT_CARD_HEADER_ID` bigint(20) DEFAULT NULL,
  `CARD_QUESTION_ID` bigint(20) DEFAULT NULL,
  `REMARK` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COMMENT_CARD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_comment_card_header` */

DROP TABLE IF EXISTS `hr_comment_card_header`;

CREATE TABLE `hr_comment_card_header` (
  `COMMENT_CARD_HEADER_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `CARD_DATETIME` datetime DEFAULT NULL,
  PRIMARY KEY (`COMMENT_CARD_HEADER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_company` */

DROP TABLE IF EXISTS `hr_company`;

CREATE TABLE `hr_company` (
  `COMPANY_ID` bigint(20) NOT NULL,
  `COMPANY` varchar(50) NOT NULL,
  `DESCRIPTION` varchar(100) NOT NULL,
  PRIMARY KEY (`COMPANY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_competency` */

DROP TABLE IF EXISTS `hr_competency`;

CREATE TABLE `hr_competency` (
  `COMPETENCY_ID` bigint(20) NOT NULL,
  `COMPETENCY_GROUP_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_TYPE_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_NAME` varchar(128) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`COMPETENCY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_competency_detail` */

DROP TABLE IF EXISTS `hr_competency_detail`;

CREATE TABLE `hr_competency_detail` (
  `DETAIL_ID` bigint(20) NOT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`DETAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_competency_group` */

DROP TABLE IF EXISTS `hr_competency_group`;

CREATE TABLE `hr_competency_group` (
  `COMPETENCY_GROUP_ID` bigint(20) NOT NULL,
  `GROUP_NAME` varchar(128) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `COMPETENCY_TYPE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`COMPETENCY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_competency_level` */

DROP TABLE IF EXISTS `hr_competency_level`;

CREATE TABLE `hr_competency_level` (
  `COMPETENCY_LEVEL_ID` bigint(20) NOT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `SCORE_VALUE` double(15,2) NOT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `LEVEL_MIN` int(3) DEFAULT NULL,
  `LEVEL_MAX` int(3) DEFAULT NULL,
  `LEVEL_UNIT` varchar(128) DEFAULT NULL,
  `VALID_START` date NOT NULL,
  `VALID_END` date NOT NULL,
  `COMPETENCY_GROUP_ID` bigint(20) NOT NULL,
  `LEVEL_NAME` varchar(400) NOT NULL,
  PRIMARY KEY (`COMPETENCY_LEVEL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_competency_type` */

DROP TABLE IF EXISTS `hr_competency_type`;

CREATE TABLE `hr_competency_type` (
  `COMPETENCY_TYPE_ID` bigint(20) NOT NULL,
  `TYPE_NAME` varchar(128) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `ACCUMULATE_IN_ACHIEVMENT` int(2) DEFAULT NULL,
  PRIMARY KEY (`COMPETENCY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_competitor` */

DROP TABLE IF EXISTS `hr_competitor`;

CREATE TABLE `hr_competitor` (
  `COMPETITOR_ID` bigint(20) NOT NULL,
  `COMPANY_NAME` varchar(256) DEFAULT NULL,
  `ADDRESS` varchar(256) DEFAULT NULL,
  `WEBSITE` varchar(256) DEFAULT NULL,
  `EMAIL` varchar(256) DEFAULT NULL,
  `TELEPHONE` varchar(26) DEFAULT NULL,
  `FAX` varchar(26) DEFAULT NULL,
  `CONTACT_PERSON` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  `COUNTRY_ID` bigint(20) DEFAULT NULL,
  `PROVINCE_ID` bigint(20) DEFAULT NULL,
  `REGION_ID` bigint(20) DEFAULT NULL,
  `SUBREGION_ID` bigint(20) DEFAULT NULL,
  `GEO_ADDRESS` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_component_code_jv` */

DROP TABLE IF EXISTS `hr_component_code_jv`;

CREATE TABLE `hr_component_code_jv` (
  `COMP_CODE_ID` bigint(20) NOT NULL,
  `COMP_CODE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`COMP_CODE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_component_map_jv` */

DROP TABLE IF EXISTS `hr_component_map_jv`;

CREATE TABLE `hr_component_map_jv` (
  `COMPONENT_MAP_JV_ID` bigint(20) NOT NULL,
  `COMPONENT_ID` bigint(20) DEFAULT NULL,
  `COMPONENT_NAME` varchar(128) DEFAULT NULL,
  `COMP_CODE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`COMPONENT_MAP_JV_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_config_reward_and_punishment` */

DROP TABLE IF EXISTS `hr_config_reward_and_punishment`;

CREATE TABLE `hr_config_reward_and_punishment` (
  `CONFIG_ID` bigint(20) NOT NULL,
  `MAX_DEDUCTION` double DEFAULT 0 COMMENT 'nilai maximal potongan',
  `PRESENTASE_TO_SALES` double DEFAULT 0 COMMENT ' nilai presentase atau toleransi of net sales ',
  `PRESENTASE_TO_BOD` double DEFAULT 0 COMMENT 'nilai toleransi of BOD ',
  `DAY_NEW_EMPLOYEE_FREE` int(11) DEFAULT 0 COMMENT 'hari yang free untuk perhitungan reward and punishment ',
  PRIMARY KEY (`CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_custom_field_master` */

DROP TABLE IF EXISTS `hr_custom_field_master`;

CREATE TABLE `hr_custom_field_master` (
  `CUSTOM_FIELD_ID` bigint(20) NOT NULL,
  `FIELD_NAME` varchar(128) CHARACTER SET latin1 NOT NULL,
  `FIELD_TYPE` int(2) NOT NULL,
  `REQUIRED` int(2) NOT NULL,
  `DATA_LIST` text CHARACTER SET latin1 NOT NULL,
  `INPUT_TYPE` int(2) NOT NULL,
  `SHOW_FIELD` varchar(16) CHARACTER SET latin1 NOT NULL,
  `NOTE` text CHARACTER SET latin1 NOT NULL,
  `FULL_ACCESS` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`CUSTOM_FIELD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_custom_rpt_config` */

DROP TABLE IF EXISTS `hr_custom_rpt_config`;

CREATE TABLE `hr_custom_rpt_config` (
  `RPT_CONFIG_ID` bigint(20) NOT NULL,
  `RPT_CONFIG_SHOW_IDX` int(2) DEFAULT NULL,
  `RPT_CONFIG_DATA_TYPE` int(2) DEFAULT NULL,
  `RPT_CONFIG_DATA_GROUP` int(2) DEFAULT NULL,
  `RPT_CONFIG_TABLE_GROUP` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_CONFIG_TABLE_NAME` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_CONFIG_FIELD_NAME` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_CONFIG_FIELD_TYPE` int(2) DEFAULT NULL,
  `RPT_CONFIG_FIELD_HEADER` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_CONFIG_FIELD_COLOUR` varchar(64) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_CONFIG_TABLE_PRIORITY` int(2) DEFAULT NULL,
  `RPT_MAIN_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RPT_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_custom_rpt_main` */

DROP TABLE IF EXISTS `hr_custom_rpt_main`;

CREATE TABLE `hr_custom_rpt_main` (
  `RPT_MAIN_ID` bigint(20) NOT NULL,
  `RPT_MAIN_TITLE` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `RPT_MAIN_DESC` text CHARACTER SET latin1 DEFAULT NULL,
  `RPT_MAIN_DATE_CREATE` date DEFAULT NULL,
  `RPT_MAIN_CREATED_BY` bigint(20) DEFAULT NULL,
  `RPT_MAIN_PRIV_LEVEL` bigint(20) DEFAULT NULL,
  `RPT_MAIN_PRIV_POS` bigint(20) DEFAULT NULL,
  `RPT_MAIN_FULL_ACCESS` int(2) DEFAULT NULL,
  PRIMARY KEY (`RPT_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_day_of_payment` */

DROP TABLE IF EXISTS `hr_day_of_payment`;

CREATE TABLE `hr_day_of_payment` (
  `DAY_OF_PAYMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `DURATION` int(11) DEFAULT NULL,
  `DP_FROM` date DEFAULT NULL,
  `DP_TO` date DEFAULT NULL,
  `APR_DEPTHEAD_DATE` date DEFAULT NULL,
  `CONTACT_ADDRESS` text DEFAULT NULL,
  `REMARKS` text DEFAULT NULL,
  PRIMARY KEY (`DAY_OF_PAYMENT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_department` */

DROP TABLE IF EXISTS `hr_department`;

CREATE TABLE `hr_department` (
  `DEPARTMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `DIVISION_ID` bigint(20) DEFAULT 0,
  `DEPARTMENT` varchar(50) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `JOIN_TO_DEPARTMENT_ID` bigint(20) DEFAULT 0,
  `DEPARTMENT_TYPE_ID` bigint(20) DEFAULT NULL,
  `ADDRESS` varchar(128) DEFAULT NULL,
  `CITY` varchar(128) DEFAULT NULL,
  `NPWP` varchar(64) DEFAULT NULL,
  `PROVINCE` varchar(128) DEFAULT NULL,
  `REGION` varchar(128) DEFAULT NULL,
  `SUB_REGION` varchar(128) DEFAULT NULL,
  `VILLAGE` varchar(128) DEFAULT NULL,
  `AREA` varchar(128) DEFAULT NULL,
  `TELPHONE` varchar(20) DEFAULT NULL,
  `FAX_NUMBER` varchar(24) DEFAULT NULL,
  `VALID_STATUS` int(2) DEFAULT 1,
  `VALID_START` date DEFAULT NULL,
  `VALID_END` date DEFAULT NULL,
  `LEVEL` int(2) DEFAULT 0,
  PRIMARY KEY (`DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_department_type` */

DROP TABLE IF EXISTS `hr_department_type`;

CREATE TABLE `hr_department_type` (
  `DEPARTMENT_TYPE_ID` bigint(20) NOT NULL,
  `GROUP_TYPE` int(2) NOT NULL,
  `TYPE_NAME` varchar(46) NOT NULL,
  `DESCRIPTION` varchar(128) NOT NULL,
  `LEVEL` int(2) NOT NULL,
  PRIMARY KEY (`DEPARTMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dev_improvement` */

DROP TABLE IF EXISTS `hr_dev_improvement`;

CREATE TABLE `hr_dev_improvement` (
  `DEV_IMPROVEMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_APPRAISAL` bigint(20) DEFAULT NULL,
  `IMPROVEMENT` text DEFAULT NULL,
  PRIMARY KEY (`DEV_IMPROVEMENT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dev_improvement_plan` */

DROP TABLE IF EXISTS `hr_dev_improvement_plan`;

CREATE TABLE `hr_dev_improvement_plan` (
  `DEV_IMPROVEMENT_PLAN_ID` bigint(20) NOT NULL DEFAULT 0,
  `CATEGORY_APPRAISAL_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_APPRAISAL` bigint(20) DEFAULT NULL,
  `IMPROV_PLAN` text DEFAULT NULL,
  `RECOMMEND` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`DEV_IMPROVEMENT_PLAN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dflt_schedule` */

DROP TABLE IF EXISTS `hr_dflt_schedule`;

CREATE TABLE `hr_dflt_schedule` (
  `DFLT_SCHEDULE_ID` bigint(20) NOT NULL,
  `DAY_IDX` int(11) NOT NULL,
  `SCH_ID_1` bigint(20) NOT NULL,
  `SCH_ID_2` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DFLT_SCHEDULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_disease_type` */

DROP TABLE IF EXISTS `hr_disease_type`;

CREATE TABLE `hr_disease_type` (
  `DISEASE_TYPE_ID` bigint(20) NOT NULL DEFAULT 0,
  `DISEASE_TYPE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`DISEASE_TYPE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division` */

DROP TABLE IF EXISTS `hr_division`;

CREATE TABLE `hr_division` (
  `DIVISION_ID` bigint(20) NOT NULL DEFAULT 0,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION` varchar(50) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `DIVISION_TYPE_ID` bigint(20) DEFAULT NULL,
  `ADDRESS` varchar(128) DEFAULT NULL,
  `CITY` varchar(128) DEFAULT NULL,
  `NPWP` varchar(64) DEFAULT NULL,
  `PROVINCE` varchar(128) DEFAULT NULL,
  `REGION` varchar(128) DEFAULT NULL,
  `SUB_REGION` varchar(128) DEFAULT NULL,
  `VILLAGE` varchar(128) DEFAULT NULL,
  `AREA` varchar(128) DEFAULT NULL,
  `TELEPHONE` varchar(80) DEFAULT NULL,
  `FAX_NUMBER` varchar(64) DEFAULT NULL,
  `TYPE_OF_DIVISION` int(2) DEFAULT 0,
  `VALID_STATUS` int(2) DEFAULT 1,
  `VALID_START` date DEFAULT NULL,
  `VALID_END` date DEFAULT NULL,
  `PEMOTONG` varchar(50) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEVEL` int(2) DEFAULT 0,
  PRIMARY KEY (`DIVISION_ID`),
  KEY `fk_hr_division_hr_division_type1_idx` (`DIVISION_TYPE_ID`),
  KEY `fk_hr_division_pay_general1_idx` (`COMPANY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division_code_jv` */

DROP TABLE IF EXISTS `hr_division_code_jv`;

CREATE TABLE `hr_division_code_jv` (
  `DIVISION_CODE_ID` bigint(20) NOT NULL,
  `DIVISION_CODE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`DIVISION_CODE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division_group_jv` */

DROP TABLE IF EXISTS `hr_division_group_jv`;

CREATE TABLE `hr_division_group_jv` (
  `DIVISION_GROUP_ID` bigint(20) NOT NULL,
  `DIVISION_GROUP_CODE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`DIVISION_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division_group_map_jv` */

DROP TABLE IF EXISTS `hr_division_group_map_jv`;

CREATE TABLE `hr_division_group_map_jv` (
  `DIVISION_GROUP_MAP_ID` bigint(20) NOT NULL,
  `DIVISION_GROUP_ID` bigint(20) DEFAULT NULL,
  `DIVISION_CODE_ID` bigint(20) DEFAULT NULL,
  `ACCOUNT_NAME` varchar(200) DEFAULT NULL,
  `ACCOUNT_NUMBER` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`DIVISION_GROUP_MAP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division_map_jv` */

DROP TABLE IF EXISTS `hr_division_map_jv`;

CREATE TABLE `hr_division_map_jv` (
  `DIVISION_MAP_JV_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DIVISION_NAME` varchar(128) DEFAULT NULL,
  `DIVISION_CODE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DIVISION_MAP_JV_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_division_type` */

DROP TABLE IF EXISTS `hr_division_type`;

CREATE TABLE `hr_division_type` (
  `DIVISION_TYPE_ID` bigint(20) NOT NULL,
  `GROUP_TYPE` int(2) NOT NULL,
  `TYPE_NAME` varchar(46) NOT NULL,
  `DESCRIPTION` varchar(128) NOT NULL,
  `LEVEL` int(4) NOT NULL,
  PRIMARY KEY (`DIVISION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_doc_action` */

DROP TABLE IF EXISTS `hr_doc_action`;

CREATE TABLE `hr_doc_action` (
  `DOC_ACTION_ID` bigint(20) NOT NULL,
  `DOC_MASTER_ID` bigint(20) NOT NULL,
  `ACTION_NAME` varchar(128) NOT NULL COMMENT 'ini di hardcode/param system : - Mutasi Karyawan, Update databank, update salary emp setup, create/link training plan',
  `ACTION_TITLE` varchar(128) DEFAULT NULL COMMENT 'pembeda action  dengan name sama tapi object/paraameter beda'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_action_param` */

DROP TABLE IF EXISTS `hr_doc_action_param`;

CREATE TABLE `hr_doc_action_param` (
  `DOC_ACTION_PARAM_ID` bigint(20) NOT NULL,
  `ACTION_PARAMETER` varchar(128) NOT NULL COMMENT 'nama parameter dari action , contoh : Mutasi ( karyawan, jabatan baru )',
  `OBJ_NAME` varchar(128) NOT NULL COMMENT 'nama object yg di set sbg parameter',
  `OBJ_ATTRIBUTE` varchar(45) DEFAULT NULL COMMENT 'atribute nya contoh : mutasi karyawan . OID nya',
  `DOC_ACTION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DOC_ACTION_PARAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_expenses` */

DROP TABLE IF EXISTS `hr_doc_expenses`;

CREATE TABLE `hr_doc_expenses` (
  `DOC_EXPENSE_ID` bigint(20) NOT NULL,
  `EXPENSE_NAME` varchar(256) DEFAULT NULL,
  `PLAN_EXPENSE_VALUE` float(20,1) DEFAULT NULL,
  `NOTE` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`DOC_EXPENSE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_master` */

DROP TABLE IF EXISTS `hr_doc_master`;

CREATE TABLE `hr_doc_master` (
  `DOC_MASTER_ID` bigint(20) NOT NULL,
  `DOC_TYPE_ID` bigint(20) DEFAULT NULL,
  `DOC_TITLE` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  `DIVISION_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`DOC_MASTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_master_expense` */

DROP TABLE IF EXISTS `hr_doc_master_expense`;

CREATE TABLE `hr_doc_master_expense` (
  `DOC_MASTER_EXPENSE_ID` bigint(20) NOT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `BUDGET_MIN` float(24,2) DEFAULT NULL,
  `BUDGET_MAX` float(24,2) DEFAULT NULL,
  `UNIT_TYPE` tinyint(4) DEFAULT NULL,
  `UNIT_NAME` varchar(64) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  `DOC_EXPENSE_ID` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_master_flow` */

DROP TABLE IF EXISTS `hr_doc_master_flow`;

CREATE TABLE `hr_doc_master_flow` (
  `DOC_MASTER_FLOW_ID` bigint(20) DEFAULT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `FLOW_TITLE` varchar(30) DEFAULT NULL,
  `FLOW_INDEX` int(11) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `FILTER_FOR_DIVISION_ID` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_master_sign` */

DROP TABLE IF EXISTS `hr_doc_master_sign`;

CREATE TABLE `hr_doc_master_sign` (
  `DOC_MASTER_SIGN_ID` bigint(25) NOT NULL,
  `DOC_MASTER_ID` bigint(25) DEFAULT NULL,
  `SIGN_INDEX` int(2) DEFAULT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(25) DEFAULT NULL,
  `SIGN_FOR_DIVISION_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`DOC_MASTER_SIGN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_doc_master_template` */

DROP TABLE IF EXISTS `hr_doc_master_template`;

CREATE TABLE `hr_doc_master_template` (
  `DOC_MASTER_TEMPLATE_ID` bigint(20) NOT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `TEMPLATE_TITLE` varchar(512) DEFAULT NULL,
  `TEMPLATE_FILE_NAME` varchar(256) DEFAULT NULL,
  `TEXT_TEMPLATE` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_doc_master_user` */

DROP TABLE IF EXISTS `hr_doc_master_user`;

CREATE TABLE `hr_doc_master_user` (
  `DOC_MASTER_ID` bigint(25) NOT NULL,
  `USER_ID` bigint(25) NOT NULL,
  PRIMARY KEY (`DOC_MASTER_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_doc_type` */

DROP TABLE IF EXISTS `hr_doc_type`;

CREATE TABLE `hr_doc_type` (
  `doc_type_id` bigint(20) NOT NULL,
  `type_name` varchar(256) DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`doc_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_dp_app` */

DROP TABLE IF EXISTS `hr_dp_app`;

CREATE TABLE `hr_dp_app` (
  `DP_APP_ID` bigint(20) NOT NULL DEFAULT 0,
  `SUBMISSION_DATE` date DEFAULT NULL,
  `APPROVAL_ID` bigint(20) DEFAULT NULL,
  `APPROVAL2_ID` bigint(20) DEFAULT NULL,
  `APPROVAL3_ID` bigint(20) DEFAULT NULL,
  `APPROVAL_DATE` date DEFAULT NULL,
  `APPROVAL2_DATE` date DEFAULT NULL,
  `APPROVAL3_DATE` date DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `BALANCE` int(11) DEFAULT NULL,
  `DOC_STATUS` int(11) DEFAULT 0,
  PRIMARY KEY (`DP_APP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_app_detail` */

DROP TABLE IF EXISTS `hr_dp_app_detail`;

CREATE TABLE `hr_dp_app_detail` (
  `DP_APP_DETAIL_ID` bigint(20) NOT NULL DEFAULT 0,
  `DP_APP_ID` bigint(20) DEFAULT NULL,
  `DP_ID` bigint(20) DEFAULT NULL,
  `TAKEN_DATE` date DEFAULT NULL,
  `STATUS` int(11) DEFAULT 0,
  PRIMARY KEY (`DP_APP_DETAIL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_application` */

DROP TABLE IF EXISTS `hr_dp_application`;

CREATE TABLE `hr_dp_application` (
  `DP_APPLICATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `DP_ID` bigint(20) DEFAULT NULL,
  `SUBMISSION_DATE` date DEFAULT NULL,
  `TAKEN_DATE` date DEFAULT NULL,
  `APPROVAL_ID` bigint(20) DEFAULT NULL,
  `DOC_STATUS` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`DP_APPLICATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_stock_expired` */

DROP TABLE IF EXISTS `hr_dp_stock_expired`;

CREATE TABLE `hr_dp_stock_expired` (
  `DP_STOCK_EXPIRED_ID` bigint(20) NOT NULL DEFAULT 0,
  `DP_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `EXPIRED_DATE` date NOT NULL DEFAULT '0000-00-00',
  `EXPIRED_QTY` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`DP_STOCK_EXPIRED_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_stock_management` */

DROP TABLE IF EXISTS `hr_dp_stock_management`;

CREATE TABLE `hr_dp_stock_management` (
  `DP_STOCK_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `LEAVE_PERIODE_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `DP_QTY` float(15,8) unsigned NOT NULL DEFAULT 0.00000000,
  `OWNING_DATE` date NOT NULL DEFAULT '0000-00-00',
  `EXPIRED_DATE` date DEFAULT '0000-00-00',
  `EXCEPTION_FLAG` tinyint(3) unsigned DEFAULT 0,
  `EXPIRED_DATE_EXC` date DEFAULT '0000-00-00',
  `DP_STATUS` tinyint(4) DEFAULT 0,
  `NOTE` text DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `QTY_USED` float(15,8) NOT NULL DEFAULT 0.00000000,
  `QTY_RESIDUE` float(15,8) NOT NULL DEFAULT 0.00000000,
  `FLAG_STOCK` int(2) DEFAULT NULL COMMENT 'Ini fungsinya jika user menambahkan/ mengedit melalui dp_stock, sehingga ketika dia ada overtime dan user kembali melakukan generate, agar DP_QTY ini tidak berubah.',
  PRIMARY KEY (`DP_STOCK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_stock_taken` */

DROP TABLE IF EXISTS `hr_dp_stock_taken`;

CREATE TABLE `hr_dp_stock_taken` (
  `DP_STOCK_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `DP_STOCK_ID` bigint(20) NOT NULL,
  `TAKEN_DATE` datetime NOT NULL,
  `TAKEN_QTY` float(15,8) NOT NULL DEFAULT 0.00000000,
  `PAID_DATE` datetime DEFAULT NULL,
  `LEAVE_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `TAKEN_FINNISH_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`DP_STOCK_TAKEN_ID`),
  KEY `idx_hr_dp_st_taken_he_app_leave_id` (`LEAVE_APPLICATION_ID`),
  KEY `idx_hr_dp_stock_taken_stock_id` (`DP_STOCK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_stock_temp` */

DROP TABLE IF EXISTS `hr_dp_stock_temp`;

CREATE TABLE `hr_dp_stock_temp` (
  `PAYROLL` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `PREV_AMOUNT` int(11) NOT NULL DEFAULT 0,
  `EARNED` int(11) NOT NULL DEFAULT 0,
  `USED` int(11) NOT NULL DEFAULT 0,
  `EXPIRED` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_stock_temp_prev` */

DROP TABLE IF EXISTS `hr_dp_stock_temp_prev`;

CREATE TABLE `hr_dp_stock_temp_prev` (
  `PAYROLL` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `EARNED` int(11) NOT NULL DEFAULT 0,
  `USED` int(11) NOT NULL DEFAULT 0,
  `EXPIRED` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_dp_upload` */

DROP TABLE IF EXISTS `hr_dp_upload`;

CREATE TABLE `hr_dp_upload` (
  `DP_UPLOAD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `OPNAME_DATE` datetime DEFAULT NULL,
  `DP_AQ_DATE` datetime DEFAULT NULL,
  `DP_NUMBER` float(15,8) DEFAULT NULL,
  `DATA_STATUS` int(11) DEFAULT NULL,
  `DP_STOCK_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DP_UPLOAD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_education` */

DROP TABLE IF EXISTS `hr_education`;

CREATE TABLE `hr_education` (
  `EDUCATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `EDUCATION` varchar(64) DEFAULT NULL,
  `EDUCATION_DESC` varchar(124) DEFAULT NULL,
  `EDUCATION_LEVEL` int(10) DEFAULT NULL,
  `KATEGORI` varchar(50) DEFAULT NULL,
  `KODE` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`EDUCATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_education_score` */

DROP TABLE IF EXISTS `hr_education_score`;

CREATE TABLE `hr_education_score` (
  `EDUCATION_SCORE_ID` bigint(20) NOT NULL,
  `EDUCATION_ID` bigint(20) NOT NULL,
  `POINT_MIN` float(4,0) NOT NULL,
  `POINT_MAX` float(4,0) NOT NULL,
  `DURATION_MIN` float(4,0) NOT NULL,
  `DURATION_MAX` float(4,0) NOT NULL,
  `SCORE` float(4,0) NOT NULL,
  `VALID_START` date NOT NULL,
  `VALID_END` date NOT NULL,
  PRIMARY KEY (`EDUCATION_SCORE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_assessment` */

DROP TABLE IF EXISTS `hr_emp_assessment`;

CREATE TABLE `hr_emp_assessment` (
  `EMP_ASSESSMENT_ID` bigint(25) NOT NULL,
  `EMPLOYEE_ID` bigint(25) DEFAULT NULL,
  `ASSESSMENT_ID` bigint(25) DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `DATE_OF_ASSESSMENT` date DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`EMP_ASSESSMENT_ID`),
  KEY `SCORE` (`SCORE`),
  KEY `DATE` (`DATE_OF_ASSESSMENT`),
  KEY `ASSESSMENT` (`ASSESSMENT_ID`),
  KEY `EMPLOYEE_ID` (`EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_category` */

DROP TABLE IF EXISTS `hr_emp_category`;

CREATE TABLE `hr_emp_category` (
  `EMP_CATEGORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMP_CATEGORY` varchar(50) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `TYPE_FOR_TAX` int(11) DEFAULT 0,
  `ENTITLE_FOR_LEAVE` int(3) DEFAULT 0,
  `ENTITLE_FOR_INSENTIF` int(3) DEFAULT 0,
  `CODE` varchar(10) DEFAULT NULL,
  `CATEGORY_TYPE` tinyint(2) DEFAULT 0,
  `ENTITLE_DP` int(2) DEFAULT 0,
  PRIMARY KEY (`EMP_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_character_power` */

DROP TABLE IF EXISTS `hr_emp_character_power`;

CREATE TABLE `hr_emp_character_power` (
  `EMP_POWER_CHARACTER_ID` bigint(25) NOT NULL,
  `FIRST_POWER_CHARACTER_ID` bigint(25) DEFAULT NULL,
  `SECOND_POWER_CHARACTER_ID` bigint(25) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(25) DEFAULT NULL,
  `IDX` int(2) DEFAULT NULL,
  PRIMARY KEY (`EMP_POWER_CHARACTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_competency` */

DROP TABLE IF EXISTS `hr_emp_competency`;

CREATE TABLE `hr_emp_competency` (
  `EMPLOYEE_COMP_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `LEVEL_VALUE` float(4,2) NOT NULL,
  `SPECIAL_ACHIEVEMENT` text DEFAULT NULL,
  `DATE_OF_ACHVMT` date NOT NULL,
  `HISTORY` smallint(2) NOT NULL DEFAULT 0,
  `PROVIDER_ID` bigint(20) NOT NULL DEFAULT 0,
  `COMPETENCY_LEVEL_ID` bigint(20) DEFAULT NULL,
  `SCORE_VALUE` double(4,0) DEFAULT NULL,
  `TRAINING_ACTIVITY_ACTUAL_ID` bigint(20) DEFAULT NULL,
  `TRAINING_COMPETENCY_MAPPING_DETAIL_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEE_COMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_custom_field` */

DROP TABLE IF EXISTS `hr_emp_custom_field`;

CREATE TABLE `hr_emp_custom_field` (
  `EMP_CUSTOM_FIELD_ID` bigint(20) NOT NULL,
  `DATA_NUMBER` decimal(30,10) NOT NULL,
  `DATA_TEXT` varchar(512) CHARACTER SET latin1 NOT NULL,
  `DATA_DATE` datetime NOT NULL,
  `CUSTOM_FIELD_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`EMP_CUSTOM_FIELD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc` */

DROP TABLE IF EXISTS `hr_emp_doc`;

CREATE TABLE `hr_emp_doc` (
  `EMP_DOC_ID` bigint(20) NOT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `DOC_TITLE` varchar(256) DEFAULT NULL,
  `REQUEST_DATE` datetime DEFAULT NULL,
  `DOC_NUMBER` varchar(64) DEFAULT NULL,
  `DATE_OF_ISSUE` date DEFAULT NULL,
  `PLAN_DATE_FROM` datetime DEFAULT NULL,
  `PLAN_DATE_TO` datetime DEFAULT NULL,
  `REAL_DATE_FROM` datetime DEFAULT NULL,
  `REAL_DATE_TO` datetime DEFAULT NULL,
  `OBJECTIVES` varchar(512) DEFAULT NULL,
  `DETAILS` longtext DEFAULT NULL,
  `COUNTRY_ID` bigint(20) DEFAULT NULL,
  `PROVINCE_ID` bigint(20) DEFAULT NULL,
  `REGION_ID` bigint(20) DEFAULT NULL,
  `SUBREGION_ID` bigint(20) DEFAULT NULL,
  `GEO_ADDRESS` varchar(512) DEFAULT NULL,
  `DOC_STATUS` int(3) DEFAULT 0,
  `DOCH_ATTACH_FILE` mediumblob DEFAULT NULL,
  `FILE_NAME` varchar(100) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `EMP_DOC_SERIES_ID` bigint(20) DEFAULT NULL,
  `LEAVE_APPLICATION_ID` bigint(20) DEFAULT NULL,
  KEY `LEAVE` (`LEAVE_APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_action` */

DROP TABLE IF EXISTS `hr_emp_doc_action`;

CREATE TABLE `hr_emp_doc_action` (
  `EMP_DOC_ACTION_ID` bigint(20) NOT NULL,
  `ACTION_NAME` varchar(128) NOT NULL COMMENT 'ini di hardcode/param system : - Mutasi Karyawan, Update databank, update salary emp setup, create/link training plan',
  `ACTION_TITLE` varchar(128) DEFAULT NULL COMMENT 'pembeda action  dengan name sama tapi object/paraameter beda',
  `EMP_DOC_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`EMP_DOC_ACTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_action_param` */

DROP TABLE IF EXISTS `hr_emp_doc_action_param`;

CREATE TABLE `hr_emp_doc_action_param` (
  `EMP_DOC_ACTION_PARAM_ID` bigint(20) NOT NULL,
  `ACTION_NAME` varchar(128) NOT NULL,
  `ACTION_TITLE` varchar(128) DEFAULT NULL,
  `ACTION_PARAMETER` varchar(128) DEFAULT NULL,
  `OBJ_NAME` varchar(128) DEFAULT NULL,
  `OBJ_ATTRIBUTE` varchar(45) DEFAULT NULL,
  `OBJ_VALUE` varchar(128) DEFAULT NULL,
  `ACTION_OBJ_ID` bigint(20) DEFAULT NULL,
  `DOC_ACTION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`EMP_DOC_ACTION_PARAM_ID`),
  KEY `fk_hr_emp_doc_action_param_hr_emp_doc_action1_idx` (`DOC_ACTION_ID`),
  CONSTRAINT `fk_hr_emp_doc_action_param_hr_emp_doc_action1` FOREIGN KEY (`DOC_ACTION_ID`) REFERENCES `hr_emp_doc_action` (`EMP_DOC_ACTION_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_comp_map` */

DROP TABLE IF EXISTS `hr_emp_doc_comp_map`;

CREATE TABLE `hr_emp_doc_comp_map` (
  `DOC_COMP_MAP_ID` bigint(20) DEFAULT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `COMPONENT_ID` bigint(20) DEFAULT NULL,
  `DAY_LENGTH` int(2) DEFAULT NULL,
  `PERIOD_ID` bigint(25) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_doc_expense` */

DROP TABLE IF EXISTS `hr_emp_doc_expense`;

CREATE TABLE `hr_emp_doc_expense` (
  `EMP_DOC_EXPENSE_ID` bigint(20) DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `DOC_MASTER_EXPENSE_ID` bigint(20) DEFAULT NULL,
  `BUDGET_VALUE` float(30,2) DEFAULT NULL,
  `REAL_VALUE` float(30,2) DEFAULT NULL,
  `EXPENSE_UNIT` int(3) DEFAULT NULL,
  `TOTAL` double DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  `NOTE` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_field` */

DROP TABLE IF EXISTS `hr_emp_doc_field`;

CREATE TABLE `hr_emp_doc_field` (
  `EMP_DOC_FIELD_ID` bigint(20) NOT NULL,
  `OBJECT_NAME` varchar(45) NOT NULL,
  `OBJECT_TYPE` int(11) NOT NULL COMMENT '0=text\n1=number integer/bigint\n2=number decimal\n3=date\n',
  `VALUE` text NOT NULL,
  `EMP_DOC_ID` bigint(20) NOT NULL,
  `CLASS_NAME` varchar(30) DEFAULT NULL,
  KEY `IDX_1` (`EMP_DOC_ID`),
  KEY `IDX_2` (`OBJECT_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_flow` */

DROP TABLE IF EXISTS `hr_emp_doc_flow`;

CREATE TABLE `hr_emp_doc_flow` (
  `EMP_DOC_FLOW_ID` bigint(20) DEFAULT NULL,
  `FLOW_TITLE` varchar(128) DEFAULT NULL,
  `FLOW_INDEX` int(4) DEFAULT NULL,
  `SIGNED_BY` bigint(20) DEFAULT NULL,
  `SIGNED_DATE` datetime DEFAULT NULL,
  `NOTE` varchar(512) DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_list` */

DROP TABLE IF EXISTS `hr_emp_doc_list`;

CREATE TABLE `hr_emp_doc_list` (
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `ASSIGN_AS` varchar(256) DEFAULT NULL,
  `JOB_DESC` text DEFAULT NULL,
  `EMP_DOC_LIST_ID` bigint(20) DEFAULT NULL,
  `OBJECT_NAME` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_doc_list_expense` */

DROP TABLE IF EXISTS `hr_emp_doc_list_expense`;

CREATE TABLE `hr_emp_doc_list_expense` (
  `EMP_DOC_LIST_EXPENSE_ID` bigint(20) NOT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `COMPONENT_ID` bigint(20) DEFAULT NULL,
  `DAY_LENGTH` int(2) DEFAULT NULL,
  `COMP_VALUE` double DEFAULT NULL,
  `OBJECT_NAME` text DEFAULT NULL,
  `PERIOD_ID` bigint(25) DEFAULT 0,
  PRIMARY KEY (`EMP_DOC_LIST_EXPENSE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_doc_list_mutation` */

DROP TABLE IF EXISTS `hr_emp_doc_list_mutation`;

CREATE TABLE `hr_emp_doc_list_mutation` (
  `EMP_DOC_LIST_MUTATION_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `OBJECT_NAME` varchar(30) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EMP_CAT_ID` bigint(20) DEFAULT NULL,
  `WORK_FROM` date DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `GRADE_LEVEL_ID` bigint(20) DEFAULT NULL,
  `HISTORY_TYPE` int(4) DEFAULT NULL,
  `HISTORY_GROUP` int(4) DEFAULT NULL,
  `WORK_TO` date DEFAULT NULL,
  `TIPE_DOC` int(2) DEFAULT 0,
  `RESIGN_REASON` int(2) DEFAULT 0,
  `RESIGN_DESC` varchar(50) DEFAULT NULL,
  `EMP_NUM` varchar(20) DEFAULT NULL,
  `PAY_COMPONENT` text DEFAULT NULL,
  PRIMARY KEY (`EMP_DOC_LIST_MUTATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_document` */

DROP TABLE IF EXISTS `hr_emp_document`;

CREATE TABLE `hr_emp_document` (
  `EMP_DOC_ID` bigint(20) NOT NULL,
  `DOC_MASTER_ID` bigint(20) DEFAULT NULL,
  `DOC_TITLE` varchar(256) DEFAULT NULL,
  `REQUEST_DATE` datetime DEFAULT NULL,
  `DOC_NUMBER` varchar(64) DEFAULT NULL,
  `DATE_OF_ISSUE` date DEFAULT NULL,
  `PLAN_DATE_FROM` datetime DEFAULT NULL,
  `PLAN_DATE_TO` datetime DEFAULT NULL,
  `REAL_DATE_FROM` datetime DEFAULT NULL,
  `REAL_DATE_TO` datetime DEFAULT NULL,
  `OBJECTIVES` varchar(512) DEFAULT NULL,
  `DETAILS` text DEFAULT NULL,
  `COUNTRY_ID` bigint(20) DEFAULT NULL,
  `PROVINCE_ID` bigint(20) DEFAULT NULL,
  `REGION_ID` bigint(20) DEFAULT NULL,
  `SUBREGION_ID` bigint(20) DEFAULT NULL,
  `GEO_ADDRESS` varchar(512) DEFAULT NULL,
  `DOC_STATUS` int(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_education` */

DROP TABLE IF EXISTS `hr_emp_education`;

CREATE TABLE `hr_emp_education` (
  `EMP_EDUCATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_DESC` text DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `START_DATE` int(11) DEFAULT 0,
  `END_DATE` int(11) DEFAULT 0,
  `GRADUATION` varchar(100) DEFAULT NULL,
  `POINT` float(4,2) NOT NULL,
  `INSTITUTION_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EMP_EDUCATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_image_assign` */

DROP TABLE IF EXISTS `hr_emp_image_assign`;

CREATE TABLE `hr_emp_image_assign` (
  `IMG_ASSIGN_OID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_OID` bigint(20) NOT NULL DEFAULT 0,
  `PATH` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_language` */

DROP TABLE IF EXISTS `hr_emp_language`;

CREATE TABLE `hr_emp_language` (
  `EMP_LANGUAGE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LANGUAGE_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `ORAL` tinyint(4) DEFAULT NULL,
  `WRITTEN` tinyint(4) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`EMP_LANGUAGE_ID`),
  KEY `FK_hr_emp_language_employee` (`EMPLOYEE_ID`),
  KEY `FK_hr_emp_language_master` (`LANGUAGE_ID`),
  CONSTRAINT `FK_hr_emp_language_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_emp_language_master` FOREIGN KEY (`LANGUAGE_ID`) REFERENCES `hr_language` (`LANGUAGE_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_message` */

DROP TABLE IF EXISTS `hr_emp_message`;

CREATE TABLE `hr_emp_message` (
  `MESSAGE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `MESSAGE` text COLLATE latin1_general_ci NOT NULL,
  `START_ACTIVE` date NOT NULL DEFAULT '0000-00-00',
  `END_ACTIVE` date NOT NULL DEFAULT '0000-00-00',
  `SEND` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`MESSAGE_ID`),
  KEY `FK_hr_emp_message_employee` (`EMPLOYEE_ID`),
  CONSTRAINT `FK_hr_emp_message_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `hr_emp_outlet` */

DROP TABLE IF EXISTS `hr_emp_outlet`;

CREATE TABLE `hr_emp_outlet` (
  `OUTLET_EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  `DATE_FROM` datetime DEFAULT NULL,
  `DATE_TO` datetime DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `EMP_SCHEDULE_ID` bigint(20) DEFAULT 0,
  `EMP_SCHEDULE_ID_2ND` bigint(20) DEFAULT 0,
  `TYPE_SCHEDULE` int(20) DEFAULT NULL,
  PRIMARY KEY (`OUTLET_EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_picture` */

DROP TABLE IF EXISTS `hr_emp_picture`;

CREATE TABLE `hr_emp_picture` (
  `PIC_EMP_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `PIC` mediumblob DEFAULT NULL,
  PRIMARY KEY (`PIC_EMP_ID`),
  KEY `EMPLOYEE_ID` (`EMPLOYEE_ID`),
  CONSTRAINT `FK_hr_emp_picture_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_relevant_doc` */

DROP TABLE IF EXISTS `hr_emp_relevant_doc`;

CREATE TABLE `hr_emp_relevant_doc` (
  `DOC_RELEVANT_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `DOC_TITLE` varchar(100) DEFAULT '',
  `DOC_DESCRIPTION` varchar(100) DEFAULT '',
  `FILE_NAME` varchar(100) DEFAULT '',
  `DOC_ATTACH_FILE` mediumblob DEFAULT NULL,
  `EMP_RELVT_DOC_GRP_ID` bigint(20) DEFAULT NULL,
  KEY `FK_hr_emp_relevant_doc_employee` (`EMPLOYEE_ID`),
  CONSTRAINT `FK_hr_emp_relevant_doc_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_relevant_doc_pages` */

DROP TABLE IF EXISTS `hr_emp_relevant_doc_pages`;

CREATE TABLE `hr_emp_relevant_doc_pages` (
  `EMP_RELVT_DOC_PAGE_ID` bigint(20) NOT NULL,
  `PAGE_TITLE` varchar(64) NOT NULL,
  `PAGE_DESC` varchar(512) DEFAULT NULL,
  `DOC_RELEVANT_ID` bigint(20) NOT NULL,
  `FILE_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`EMP_RELVT_DOC_PAGE_ID`),
  KEY `fk_hr_emp_relevant_doc_pages_hr_emp_relevant_doc1_idx` (`DOC_RELEVANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_relvnt_doc_group` */

DROP TABLE IF EXISTS `hr_emp_relvnt_doc_group`;

CREATE TABLE `hr_emp_relvnt_doc_group` (
  `EMP_RELVT_DOC_GRP_ID` bigint(20) NOT NULL,
  `DOC_GROUP` varchar(128) DEFAULT NULL,
  `DOC_GROUP_DESC` text DEFAULT NULL,
  PRIMARY KEY (`EMP_RELVT_DOC_GRP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_salary` */

DROP TABLE IF EXISTS `hr_emp_salary`;

CREATE TABLE `hr_emp_salary` (
  `EMP_SALARY_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `LOS1` int(11) DEFAULT NULL,
  `LOS2` int(11) DEFAULT NULL,
  `CURR_BASIC` decimal(10,2) DEFAULT NULL,
  `CURR_TRANSPORT` decimal(10,2) DEFAULT NULL,
  `CURR_TOTAL` decimal(10,2) DEFAULT NULL,
  `NEW_BASIC` decimal(10,2) DEFAULT NULL,
  `NEW_TRANSPORT` decimal(10,2) DEFAULT NULL,
  `NEW_TOTAL` decimal(10,2) DEFAULT NULL,
  `INC_SALARY` decimal(10,2) DEFAULT NULL,
  `INC_TRANSPORT` decimal(10,2) DEFAULT NULL,
  `ADDITIONAL` decimal(10,2) DEFAULT NULL,
  `INC_TOTAL` decimal(10,2) DEFAULT NULL,
  `PERCENTAGE_BASIC` decimal(6,2) DEFAULT NULL,
  `PERCENT_TRANSPORT` decimal(6,2) DEFAULT NULL,
  `PERCENTAGE_TOTAL` decimal(6,2) DEFAULT NULL,
  `CURR_DATE` date DEFAULT NULL,
  PRIMARY KEY (`EMP_SALARY_ID`),
  KEY `FK_hr_emp_salary_employee` (`EMPLOYEE_ID`),
  CONSTRAINT `FK_hr_emp_salary_employee` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_schedule` */

DROP TABLE IF EXISTS `hr_emp_schedule`;

CREATE TABLE `hr_emp_schedule` (
  `EMP_SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `SCHEDULE_TYPE` tinyint(4) NOT NULL DEFAULT 0,
  `D1` bigint(20) DEFAULT 0,
  `D2` bigint(20) DEFAULT 0,
  `D3` bigint(20) DEFAULT 0,
  `D4` bigint(20) DEFAULT 0,
  `D5` bigint(20) DEFAULT 0,
  `D6` bigint(20) DEFAULT 0,
  `D7` bigint(20) DEFAULT 0,
  `D8` bigint(20) DEFAULT 0,
  `D9` bigint(20) DEFAULT 0,
  `D10` bigint(20) DEFAULT 0,
  `D11` bigint(20) DEFAULT 0,
  `D12` bigint(20) DEFAULT 0,
  `D13` bigint(20) DEFAULT 0,
  `D14` bigint(20) DEFAULT 0,
  `D15` bigint(20) DEFAULT 0,
  `D16` bigint(20) DEFAULT 0,
  `D17` bigint(20) DEFAULT 0,
  `D18` bigint(20) DEFAULT 0,
  `D19` bigint(20) DEFAULT 0,
  `D20` bigint(20) DEFAULT 0,
  `D21` bigint(20) DEFAULT 0,
  `D22` bigint(20) DEFAULT 0,
  `D23` bigint(20) DEFAULT 0,
  `D24` bigint(20) DEFAULT 0,
  `D25` bigint(20) DEFAULT 0,
  `D26` bigint(20) DEFAULT 0,
  `D27` bigint(20) DEFAULT 0,
  `D28` bigint(20) DEFAULT 0,
  `D29` bigint(20) DEFAULT 0,
  `D30` bigint(20) DEFAULT 0,
  `D31` bigint(20) DEFAULT 0,
  `D2ND1` bigint(20) DEFAULT 0,
  `D2ND2` bigint(20) DEFAULT 0,
  `D2ND3` bigint(20) DEFAULT 0,
  `D2ND4` bigint(20) DEFAULT 0,
  `D2ND5` bigint(20) DEFAULT 0,
  `D2ND6` bigint(20) DEFAULT 0,
  `D2ND7` bigint(20) DEFAULT 0,
  `D2ND8` bigint(20) DEFAULT 0,
  `D2ND9` bigint(20) DEFAULT 0,
  `D2ND10` bigint(20) DEFAULT 0,
  `D2ND11` bigint(20) DEFAULT 0,
  `D2ND12` bigint(20) DEFAULT 0,
  `D2ND13` bigint(20) DEFAULT 0,
  `D2ND14` bigint(20) DEFAULT 0,
  `D2ND15` bigint(20) DEFAULT 0,
  `D2ND16` bigint(20) DEFAULT 0,
  `D2ND17` bigint(20) DEFAULT 0,
  `D2ND18` bigint(20) DEFAULT 0,
  `D2ND19` bigint(20) DEFAULT 0,
  `D2ND20` bigint(20) DEFAULT 0,
  `D2ND21` bigint(20) DEFAULT 0,
  `D2ND22` bigint(20) DEFAULT 0,
  `D2ND23` bigint(20) DEFAULT 0,
  `D2ND24` bigint(20) DEFAULT 0,
  `D2ND25` bigint(20) DEFAULT 0,
  `D2ND26` bigint(20) DEFAULT 0,
  `D2ND27` bigint(20) DEFAULT 0,
  `D2ND28` bigint(20) DEFAULT 0,
  `D2ND29` bigint(20) DEFAULT 0,
  `D2ND30` bigint(20) DEFAULT 0,
  `D2ND31` bigint(20) DEFAULT 0,
  `STATUS1` int(11) DEFAULT -1,
  `STATUS2` int(11) DEFAULT -1,
  `STATUS3` int(11) DEFAULT -1,
  `STATUS4` int(11) DEFAULT -1,
  `STATUS5` int(11) DEFAULT -1,
  `STATUS6` int(11) DEFAULT -1,
  `STATUS7` int(11) DEFAULT -1,
  `STATUS8` int(11) DEFAULT -1,
  `STATUS9` int(11) DEFAULT -1,
  `STATUS10` int(11) DEFAULT -1,
  `STATUS11` int(11) DEFAULT -1,
  `STATUS12` int(11) DEFAULT -1,
  `STATUS13` int(11) DEFAULT -1,
  `STATUS14` int(11) DEFAULT -1,
  `STATUS15` int(11) DEFAULT -1,
  `STATUS16` int(11) DEFAULT -1,
  `STATUS17` int(11) DEFAULT -1,
  `STATUS18` int(11) DEFAULT -1,
  `STATUS19` int(11) DEFAULT -1,
  `STATUS20` int(11) DEFAULT -1,
  `STATUS21` int(11) DEFAULT -1,
  `STATUS22` int(11) DEFAULT -1,
  `STATUS23` int(11) DEFAULT -1,
  `STATUS24` int(11) DEFAULT -1,
  `STATUS25` int(11) DEFAULT -1,
  `STATUS26` int(11) DEFAULT -1,
  `STATUS27` int(11) DEFAULT -1,
  `STATUS28` int(11) DEFAULT -1,
  `STATUS29` int(11) DEFAULT -1,
  `STATUS30` int(11) DEFAULT -1,
  `STATUS31` int(11) DEFAULT -1,
  `STATUS2ND1` int(11) DEFAULT -1,
  `STATUS2ND2` int(11) DEFAULT -1,
  `STATUS2ND3` int(11) DEFAULT -1,
  `STATUS2ND4` int(11) DEFAULT -1,
  `STATUS2ND5` int(11) DEFAULT -1,
  `STATUS2ND6` int(11) DEFAULT -1,
  `STATUS2ND7` int(11) DEFAULT -1,
  `STATUS2ND8` int(11) DEFAULT -1,
  `STATUS2ND9` int(11) DEFAULT -1,
  `STATUS2ND10` int(11) DEFAULT -1,
  `STATUS2ND11` int(11) DEFAULT -1,
  `STATUS2ND12` int(11) DEFAULT -1,
  `STATUS2ND13` int(11) DEFAULT -1,
  `STATUS2ND14` int(11) DEFAULT -1,
  `STATUS2ND15` int(11) DEFAULT -1,
  `STATUS2ND16` int(11) DEFAULT -1,
  `STATUS2ND17` int(11) DEFAULT -1,
  `STATUS2ND18` int(11) DEFAULT -1,
  `STATUS2ND19` int(11) DEFAULT -1,
  `STATUS2ND20` int(11) DEFAULT -1,
  `STATUS2ND21` int(11) DEFAULT -1,
  `STATUS2ND22` int(11) DEFAULT -1,
  `STATUS2ND23` int(11) DEFAULT -1,
  `STATUS2ND24` int(11) DEFAULT -1,
  `STATUS2ND25` int(11) DEFAULT -1,
  `STATUS2ND26` int(11) DEFAULT -1,
  `STATUS2ND27` int(11) DEFAULT -1,
  `STATUS2ND28` int(11) DEFAULT -1,
  `STATUS2ND29` int(11) DEFAULT -1,
  `STATUS2ND30` int(11) DEFAULT -1,
  `STATUS2ND31` int(11) DEFAULT -1,
  `REASON1` int(11) DEFAULT 0,
  `REASON2` int(11) DEFAULT 0,
  `REASON3` int(11) DEFAULT 0,
  `REASON4` int(11) DEFAULT 0,
  `REASON5` int(11) DEFAULT 0,
  `REASON6` int(11) DEFAULT 0,
  `REASON7` int(11) DEFAULT 0,
  `REASON8` int(11) DEFAULT 0,
  `REASON9` int(11) DEFAULT 0,
  `REASON10` int(11) DEFAULT 0,
  `REASON11` int(11) DEFAULT 0,
  `REASON12` int(11) DEFAULT 0,
  `REASON13` int(11) DEFAULT 0,
  `REASON14` int(11) DEFAULT 0,
  `REASON15` int(11) DEFAULT 0,
  `REASON16` int(11) DEFAULT 0,
  `REASON17` int(11) DEFAULT 0,
  `REASON18` int(11) DEFAULT 0,
  `REASON19` int(11) DEFAULT 0,
  `REASON20` int(11) DEFAULT 0,
  `REASON21` int(11) DEFAULT 0,
  `REASON22` int(11) DEFAULT 0,
  `REASON23` int(11) DEFAULT 0,
  `REASON24` int(11) DEFAULT 0,
  `REASON25` int(11) DEFAULT 0,
  `REASON26` int(11) DEFAULT 0,
  `REASON27` int(11) DEFAULT 0,
  `REASON28` int(11) DEFAULT 0,
  `REASON29` int(11) DEFAULT 0,
  `REASON30` int(11) DEFAULT 0,
  `REASON31` int(11) DEFAULT 0,
  `REASON2ND1` int(11) DEFAULT 0,
  `REASON2ND2` int(11) DEFAULT 0,
  `REASON2ND3` int(11) DEFAULT 0,
  `REASON2ND4` int(11) DEFAULT 0,
  `REASON2ND5` int(11) DEFAULT 0,
  `REASON2ND6` int(11) DEFAULT 0,
  `REASON2ND7` int(11) DEFAULT 0,
  `REASON2ND8` int(11) DEFAULT 0,
  `REASON2ND9` int(11) DEFAULT 0,
  `REASON2ND10` int(11) DEFAULT 0,
  `REASON2ND11` int(11) DEFAULT 0,
  `REASON2ND12` int(11) DEFAULT 0,
  `REASON2ND13` int(11) DEFAULT 0,
  `REASON2ND14` int(11) DEFAULT 0,
  `REASON2ND15` int(11) DEFAULT 0,
  `REASON2ND16` int(11) DEFAULT 0,
  `REASON2ND17` int(11) DEFAULT 0,
  `REASON2ND18` int(11) DEFAULT 0,
  `REASON2ND19` int(11) DEFAULT 0,
  `REASON2ND20` int(11) DEFAULT 0,
  `REASON2ND21` int(11) DEFAULT 0,
  `REASON2ND22` int(11) DEFAULT 0,
  `REASON2ND23` int(11) DEFAULT 0,
  `REASON2ND24` int(11) DEFAULT 0,
  `REASON2ND25` int(11) DEFAULT 0,
  `REASON2ND26` int(11) DEFAULT 0,
  `REASON2ND27` int(11) DEFAULT 0,
  `REASON2ND28` int(11) DEFAULT 0,
  `REASON2ND29` int(11) DEFAULT 0,
  `REASON2ND30` int(11) DEFAULT 0,
  `REASON2ND31` int(11) DEFAULT 0,
  `NOTE1` text DEFAULT NULL,
  `NOTE2` text DEFAULT NULL,
  `NOTE3` text DEFAULT NULL,
  `NOTE4` text DEFAULT NULL,
  `NOTE5` text DEFAULT NULL,
  `NOTE6` text DEFAULT NULL,
  `NOTE7` text DEFAULT NULL,
  `NOTE8` text DEFAULT NULL,
  `NOTE9` text DEFAULT NULL,
  `NOTE10` text DEFAULT NULL,
  `NOTE11` text DEFAULT NULL,
  `NOTE12` text DEFAULT NULL,
  `NOTE13` text DEFAULT NULL,
  `NOTE14` text DEFAULT NULL,
  `NOTE15` text DEFAULT NULL,
  `NOTE16` text DEFAULT NULL,
  `NOTE17` text DEFAULT NULL,
  `NOTE18` text DEFAULT NULL,
  `NOTE19` text DEFAULT NULL,
  `NOTE20` text DEFAULT NULL,
  `NOTE21` text DEFAULT NULL,
  `NOTE22` text DEFAULT NULL,
  `NOTE23` text DEFAULT NULL,
  `NOTE24` text DEFAULT NULL,
  `NOTE25` text DEFAULT NULL,
  `NOTE26` text DEFAULT NULL,
  `NOTE27` text DEFAULT NULL,
  `NOTE28` text DEFAULT NULL,
  `NOTE29` text DEFAULT NULL,
  `NOTE30` text DEFAULT NULL,
  `NOTE31` text DEFAULT NULL,
  `NOTE2ND1` text DEFAULT NULL,
  `NOTE2ND2` text DEFAULT NULL,
  `NOTE2ND3` text DEFAULT NULL,
  `NOTE2ND4` text DEFAULT NULL,
  `NOTE2ND5` text DEFAULT NULL,
  `NOTE2ND6` text DEFAULT NULL,
  `NOTE2ND7` text DEFAULT NULL,
  `NOTE2ND8` text DEFAULT NULL,
  `NOTE2ND9` text DEFAULT NULL,
  `NOTE2ND10` text DEFAULT NULL,
  `NOTE2ND11` text DEFAULT NULL,
  `NOTE2ND12` text DEFAULT NULL,
  `NOTE2ND13` text DEFAULT NULL,
  `NOTE2ND14` text DEFAULT NULL,
  `NOTE2ND15` text DEFAULT NULL,
  `NOTE2ND16` text DEFAULT NULL,
  `NOTE2ND17` text DEFAULT NULL,
  `NOTE2ND18` text DEFAULT NULL,
  `NOTE2ND19` text DEFAULT NULL,
  `NOTE2ND20` text DEFAULT NULL,
  `NOTE2ND21` text DEFAULT NULL,
  `NOTE2ND22` text DEFAULT NULL,
  `NOTE2ND23` text DEFAULT NULL,
  `NOTE2ND24` text DEFAULT NULL,
  `NOTE2ND25` text DEFAULT NULL,
  `NOTE2ND26` text DEFAULT NULL,
  `NOTE2ND27` text DEFAULT NULL,
  `NOTE2ND28` text DEFAULT NULL,
  `NOTE2ND29` text DEFAULT NULL,
  `NOTE2ND30` text DEFAULT NULL,
  `NOTE2ND31` text DEFAULT NULL,
  `IN1` datetime DEFAULT NULL,
  `IN2` datetime DEFAULT NULL,
  `IN3` datetime DEFAULT NULL,
  `IN4` datetime DEFAULT NULL,
  `IN5` datetime DEFAULT NULL,
  `IN6` datetime DEFAULT NULL,
  `IN7` datetime DEFAULT NULL,
  `IN8` datetime DEFAULT NULL,
  `IN9` datetime DEFAULT NULL,
  `IN10` datetime DEFAULT NULL,
  `IN11` datetime DEFAULT NULL,
  `IN12` datetime DEFAULT NULL,
  `IN13` datetime DEFAULT NULL,
  `IN14` datetime DEFAULT NULL,
  `IN15` datetime DEFAULT NULL,
  `IN16` datetime DEFAULT NULL,
  `IN17` datetime DEFAULT NULL,
  `IN18` datetime DEFAULT NULL,
  `IN19` datetime DEFAULT NULL,
  `IN20` datetime DEFAULT NULL,
  `IN21` datetime DEFAULT NULL,
  `IN22` datetime DEFAULT NULL,
  `IN23` datetime DEFAULT NULL,
  `IN24` datetime DEFAULT NULL,
  `IN25` datetime DEFAULT NULL,
  `IN26` datetime DEFAULT NULL,
  `IN27` datetime DEFAULT NULL,
  `IN28` datetime DEFAULT NULL,
  `IN29` datetime DEFAULT NULL,
  `IN30` datetime DEFAULT NULL,
  `IN31` datetime DEFAULT NULL,
  `IN2ND1` datetime DEFAULT NULL,
  `IN2ND2` datetime DEFAULT NULL,
  `IN2ND3` datetime DEFAULT NULL,
  `IN2ND4` datetime DEFAULT NULL,
  `IN2ND5` datetime DEFAULT NULL,
  `IN2ND6` datetime DEFAULT NULL,
  `IN2ND7` datetime DEFAULT NULL,
  `IN2ND8` datetime DEFAULT NULL,
  `IN2ND9` datetime DEFAULT NULL,
  `IN2ND10` datetime DEFAULT NULL,
  `IN2ND11` datetime DEFAULT NULL,
  `IN2ND12` datetime DEFAULT NULL,
  `IN2ND13` datetime DEFAULT NULL,
  `IN2ND14` datetime DEFAULT NULL,
  `IN2ND15` datetime DEFAULT NULL,
  `IN2ND16` datetime DEFAULT NULL,
  `IN2ND17` datetime DEFAULT NULL,
  `IN2ND18` datetime DEFAULT NULL,
  `IN2ND19` datetime DEFAULT NULL,
  `IN2ND20` datetime DEFAULT NULL,
  `IN2ND21` datetime DEFAULT NULL,
  `IN2ND22` datetime DEFAULT NULL,
  `IN2ND23` datetime DEFAULT NULL,
  `IN2ND24` datetime DEFAULT NULL,
  `IN2ND25` datetime DEFAULT NULL,
  `IN2ND26` datetime DEFAULT NULL,
  `IN2ND27` datetime DEFAULT NULL,
  `IN2ND28` datetime DEFAULT NULL,
  `IN2ND29` datetime DEFAULT NULL,
  `IN2ND30` datetime DEFAULT NULL,
  `IN2ND31` datetime DEFAULT NULL,
  `OUT1` datetime DEFAULT NULL,
  `OUT2` datetime DEFAULT NULL,
  `OUT3` datetime DEFAULT NULL,
  `OUT4` datetime DEFAULT NULL,
  `OUT5` datetime DEFAULT NULL,
  `OUT6` datetime DEFAULT NULL,
  `OUT7` datetime DEFAULT NULL,
  `OUT8` datetime DEFAULT NULL,
  `OUT9` datetime DEFAULT NULL,
  `OUT10` datetime DEFAULT NULL,
  `OUT11` datetime DEFAULT NULL,
  `OUT12` datetime DEFAULT NULL,
  `OUT13` datetime DEFAULT NULL,
  `OUT14` datetime DEFAULT NULL,
  `OUT15` datetime DEFAULT NULL,
  `OUT16` datetime DEFAULT NULL,
  `OUT17` datetime DEFAULT NULL,
  `OUT18` datetime DEFAULT NULL,
  `OUT19` datetime DEFAULT NULL,
  `OUT20` datetime DEFAULT NULL,
  `OUT21` datetime DEFAULT NULL,
  `OUT22` datetime DEFAULT NULL,
  `OUT23` datetime DEFAULT NULL,
  `OUT24` datetime DEFAULT NULL,
  `OUT25` datetime DEFAULT NULL,
  `OUT26` datetime DEFAULT NULL,
  `OUT27` datetime DEFAULT NULL,
  `OUT28` datetime DEFAULT NULL,
  `OUT29` datetime DEFAULT NULL,
  `OUT30` datetime DEFAULT NULL,
  `OUT31` datetime DEFAULT NULL,
  `OUT2ND1` datetime DEFAULT NULL,
  `OUT2ND2` datetime DEFAULT NULL,
  `OUT2ND3` datetime DEFAULT NULL,
  `OUT2ND4` datetime DEFAULT NULL,
  `OUT2ND5` datetime DEFAULT NULL,
  `OUT2ND6` datetime DEFAULT NULL,
  `OUT2ND7` datetime DEFAULT NULL,
  `OUT2ND8` datetime DEFAULT NULL,
  `OUT2ND9` datetime DEFAULT NULL,
  `OUT2ND10` datetime DEFAULT NULL,
  `OUT2ND11` datetime DEFAULT NULL,
  `OUT2ND12` datetime DEFAULT NULL,
  `OUT2ND13` datetime DEFAULT NULL,
  `OUT2ND14` datetime DEFAULT NULL,
  `OUT2ND15` datetime DEFAULT NULL,
  `OUT2ND16` datetime DEFAULT NULL,
  `OUT2ND17` datetime DEFAULT NULL,
  `OUT2ND18` datetime DEFAULT NULL,
  `OUT2ND19` datetime DEFAULT NULL,
  `OUT2ND20` datetime DEFAULT NULL,
  `OUT2ND21` datetime DEFAULT NULL,
  `OUT2ND22` datetime DEFAULT NULL,
  `OUT2ND23` datetime DEFAULT NULL,
  `OUT2ND24` datetime DEFAULT NULL,
  `OUT2ND25` datetime DEFAULT NULL,
  `OUT2ND26` datetime DEFAULT NULL,
  `OUT2ND27` datetime DEFAULT NULL,
  `OUT2ND28` datetime DEFAULT NULL,
  `OUT2ND29` datetime DEFAULT NULL,
  `OUT2ND30` datetime DEFAULT NULL,
  `OUT2ND31` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_SCHEDULE_ID`),
  UNIQUE KEY `IDX_SCHE_PERIODE_ID_EMPL_ID` (`PERIOD_ID`,`EMPLOYEE_ID`),
  KEY `D1` (`D1`),
  KEY `D2` (`D2`),
  KEY `D3` (`D3`),
  KEY `D4` (`D4`),
  KEY `D5` (`D5`),
  KEY `D6` (`D6`),
  KEY `D7` (`D7`),
  KEY `D8` (`D8`),
  KEY `D9` (`D9`),
  KEY `D10` (`D10`),
  KEY `D11` (`D11`),
  KEY `D12` (`D12`),
  KEY `D13` (`D13`),
  KEY `D14` (`D14`),
  KEY `D15` (`D15`),
  KEY `D16` (`D16`),
  KEY `D17` (`D17`),
  KEY `D18` (`D18`),
  KEY `D19` (`D19`),
  KEY `D20` (`D20`),
  KEY `D21` (`D21`),
  KEY `D22` (`D22`),
  KEY `D23` (`D23`),
  KEY `D24` (`D24`),
  KEY `D25` (`D25`),
  KEY `D26` (`D26`),
  KEY `D27` (`D27`),
  KEY `D28` (`D28`),
  KEY `D29` (`D29`),
  KEY `D30` (`D30`),
  KEY `D31` (`D31`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_schedule1` */

DROP TABLE IF EXISTS `hr_emp_schedule1`;

CREATE TABLE `hr_emp_schedule1` (
  `EMP_SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `SCHEDULE_TYPE` tinyint(4) NOT NULL DEFAULT 0,
  `D1` bigint(20) DEFAULT 0,
  `D2` bigint(20) DEFAULT 0,
  `D3` bigint(20) DEFAULT 0,
  `D4` bigint(20) DEFAULT 0,
  `D5` bigint(20) DEFAULT 0,
  `D6` bigint(20) DEFAULT 0,
  `D7` bigint(20) DEFAULT 0,
  `D8` bigint(20) DEFAULT 0,
  `D9` bigint(20) DEFAULT 0,
  `D10` bigint(20) DEFAULT 0,
  `D11` bigint(20) DEFAULT 0,
  `D12` bigint(20) DEFAULT 0,
  `D13` bigint(20) DEFAULT 0,
  `D14` bigint(20) DEFAULT 0,
  `D15` bigint(20) DEFAULT 0,
  `D16` bigint(20) DEFAULT 0,
  `D17` bigint(20) DEFAULT 0,
  `D18` bigint(20) DEFAULT 0,
  `D19` bigint(20) DEFAULT 0,
  `D20` bigint(20) DEFAULT 0,
  `D21` bigint(20) DEFAULT 0,
  `D22` bigint(20) DEFAULT 0,
  `D23` bigint(20) DEFAULT 0,
  `D24` bigint(20) DEFAULT 0,
  `D25` bigint(20) DEFAULT 0,
  `D26` bigint(20) DEFAULT 0,
  `D27` bigint(20) DEFAULT 0,
  `D28` bigint(20) DEFAULT 0,
  `D29` bigint(20) DEFAULT 0,
  `D30` bigint(20) DEFAULT 0,
  `D31` bigint(20) DEFAULT 0,
  `D2ND1` bigint(20) DEFAULT 0,
  `D2ND2` bigint(20) DEFAULT 0,
  `D2ND3` bigint(20) DEFAULT 0,
  `D2ND4` bigint(20) DEFAULT 0,
  `D2ND5` bigint(20) DEFAULT 0,
  `D2ND6` bigint(20) DEFAULT 0,
  `D2ND7` bigint(20) DEFAULT 0,
  `D2ND8` bigint(20) DEFAULT 0,
  `D2ND9` bigint(20) DEFAULT 0,
  `D2ND10` bigint(20) DEFAULT 0,
  `D2ND11` bigint(20) DEFAULT 0,
  `D2ND12` bigint(20) DEFAULT 0,
  `D2ND13` bigint(20) DEFAULT 0,
  `D2ND14` bigint(20) DEFAULT 0,
  `D2ND15` bigint(20) DEFAULT 0,
  `D2ND16` bigint(20) DEFAULT 0,
  `D2ND17` bigint(20) DEFAULT 0,
  `D2ND18` bigint(20) DEFAULT 0,
  `D2ND19` bigint(20) DEFAULT 0,
  `D2ND20` bigint(20) DEFAULT 0,
  `D2ND21` bigint(20) DEFAULT 0,
  `D2ND22` bigint(20) DEFAULT 0,
  `D2ND23` bigint(20) DEFAULT 0,
  `D2ND24` bigint(20) DEFAULT 0,
  `D2ND25` bigint(20) DEFAULT 0,
  `D2ND26` bigint(20) DEFAULT 0,
  `D2ND27` bigint(20) DEFAULT 0,
  `D2ND28` bigint(20) DEFAULT 0,
  `D2ND29` bigint(20) DEFAULT 0,
  `D2ND30` bigint(20) DEFAULT 0,
  `D2ND31` bigint(20) DEFAULT 0,
  `STATUS1` int(11) DEFAULT 0,
  `STATUS2` int(11) DEFAULT 0,
  `STATUS3` int(11) DEFAULT 0,
  `STATUS4` int(11) DEFAULT 0,
  `STATUS5` int(11) DEFAULT 0,
  `STATUS6` int(11) DEFAULT 0,
  `STATUS7` int(11) DEFAULT 0,
  `STATUS8` int(11) DEFAULT 0,
  `STATUS9` int(11) DEFAULT 0,
  `STATUS10` int(11) DEFAULT 0,
  `STATUS11` int(11) DEFAULT 0,
  `STATUS12` int(11) DEFAULT 0,
  `STATUS13` int(11) DEFAULT 0,
  `STATUS14` int(11) DEFAULT 0,
  `STATUS15` int(11) DEFAULT 0,
  `STATUS16` int(11) DEFAULT 0,
  `STATUS17` int(11) DEFAULT 0,
  `STATUS18` int(11) DEFAULT 0,
  `STATUS19` int(11) DEFAULT 0,
  `STATUS20` int(11) DEFAULT 0,
  `STATUS21` int(11) DEFAULT 0,
  `STATUS22` int(11) DEFAULT 0,
  `STATUS23` int(11) DEFAULT 0,
  `STATUS24` int(11) DEFAULT 0,
  `STATUS25` int(11) DEFAULT 0,
  `STATUS26` int(11) DEFAULT 0,
  `STATUS27` int(11) DEFAULT 0,
  `STATUS28` int(11) DEFAULT 0,
  `STATUS29` int(11) DEFAULT 0,
  `STATUS30` int(11) DEFAULT 0,
  `STATUS31` int(11) DEFAULT 0,
  `STATUS2ND1` int(11) DEFAULT 0,
  `STATUS2ND2` int(11) DEFAULT 0,
  `STATUS2ND3` int(11) DEFAULT 0,
  `STATUS2ND4` int(11) DEFAULT 0,
  `STATUS2ND5` int(11) DEFAULT 0,
  `STATUS2ND6` int(11) DEFAULT 0,
  `STATUS2ND7` int(11) DEFAULT 0,
  `STATUS2ND8` int(11) DEFAULT 0,
  `STATUS2ND9` int(11) DEFAULT 0,
  `STATUS2ND10` int(11) DEFAULT 0,
  `STATUS2ND11` int(11) DEFAULT 0,
  `STATUS2ND12` int(11) DEFAULT 0,
  `STATUS2ND13` int(11) DEFAULT 0,
  `STATUS2ND14` int(11) DEFAULT 0,
  `STATUS2ND15` int(11) DEFAULT 0,
  `STATUS2ND16` int(11) DEFAULT 0,
  `STATUS2ND17` int(11) DEFAULT 0,
  `STATUS2ND18` int(11) DEFAULT 0,
  `STATUS2ND19` int(11) DEFAULT 0,
  `STATUS2ND20` int(11) DEFAULT 0,
  `STATUS2ND21` int(11) DEFAULT 0,
  `STATUS2ND22` int(11) DEFAULT 0,
  `STATUS2ND23` int(11) DEFAULT 0,
  `STATUS2ND24` int(11) DEFAULT 0,
  `STATUS2ND25` int(11) DEFAULT 0,
  `STATUS2ND26` int(11) DEFAULT 0,
  `STATUS2ND27` int(11) DEFAULT 0,
  `STATUS2ND28` int(11) DEFAULT 0,
  `STATUS2ND29` int(11) DEFAULT 0,
  `STATUS2ND30` int(11) DEFAULT 0,
  `STATUS2ND31` int(11) DEFAULT 0,
  `REASON1` int(11) DEFAULT 0,
  `REASON2` int(11) DEFAULT 0,
  `REASON3` int(11) DEFAULT 0,
  `REASON4` int(11) DEFAULT 0,
  `REASON5` int(11) DEFAULT 0,
  `REASON6` int(11) DEFAULT 0,
  `REASON7` int(11) DEFAULT 0,
  `REASON8` int(11) DEFAULT 0,
  `REASON9` int(11) DEFAULT 0,
  `REASON10` int(11) DEFAULT 0,
  `REASON11` int(11) DEFAULT 0,
  `REASON12` int(11) DEFAULT 0,
  `REASON13` int(11) DEFAULT 0,
  `REASON14` int(11) DEFAULT 0,
  `REASON15` int(11) DEFAULT 0,
  `REASON16` int(11) DEFAULT 0,
  `REASON17` int(11) DEFAULT 0,
  `REASON18` int(11) DEFAULT 0,
  `REASON19` int(11) DEFAULT 0,
  `REASON20` int(11) DEFAULT 0,
  `REASON21` int(11) DEFAULT 0,
  `REASON22` int(11) DEFAULT 0,
  `REASON23` int(11) DEFAULT 0,
  `REASON24` int(11) DEFAULT 0,
  `REASON25` int(11) DEFAULT 0,
  `REASON26` int(11) DEFAULT 0,
  `REASON27` int(11) DEFAULT 0,
  `REASON28` int(11) DEFAULT 0,
  `REASON29` int(11) DEFAULT 0,
  `REASON30` int(11) DEFAULT 0,
  `REASON31` int(11) DEFAULT 0,
  `REASON2ND1` int(11) DEFAULT 0,
  `REASON2ND2` int(11) DEFAULT 0,
  `REASON2ND3` int(11) DEFAULT 0,
  `REASON2ND4` int(11) DEFAULT 0,
  `REASON2ND5` int(11) DEFAULT 0,
  `REASON2ND6` int(11) DEFAULT 0,
  `REASON2ND7` int(11) DEFAULT 0,
  `REASON2ND8` int(11) DEFAULT 0,
  `REASON2ND9` int(11) DEFAULT 0,
  `REASON2ND10` int(11) DEFAULT 0,
  `REASON2ND11` int(11) DEFAULT 0,
  `REASON2ND12` int(11) DEFAULT 0,
  `REASON2ND13` int(11) DEFAULT 0,
  `REASON2ND14` int(11) DEFAULT 0,
  `REASON2ND15` int(11) DEFAULT 0,
  `REASON2ND16` int(11) DEFAULT 0,
  `REASON2ND17` int(11) DEFAULT 0,
  `REASON2ND18` int(11) DEFAULT 0,
  `REASON2ND19` int(11) DEFAULT 0,
  `REASON2ND20` int(11) DEFAULT 0,
  `REASON2ND21` int(11) DEFAULT 0,
  `REASON2ND22` int(11) DEFAULT 0,
  `REASON2ND23` int(11) DEFAULT 0,
  `REASON2ND24` int(11) DEFAULT 0,
  `REASON2ND25` int(11) DEFAULT 0,
  `REASON2ND26` int(11) DEFAULT 0,
  `REASON2ND27` int(11) DEFAULT 0,
  `REASON2ND28` int(11) DEFAULT 0,
  `REASON2ND29` int(11) DEFAULT 0,
  `REASON2ND30` int(11) DEFAULT 0,
  `REASON2ND31` int(11) DEFAULT 0,
  `NOTE1` text DEFAULT NULL,
  `NOTE2` text DEFAULT NULL,
  `NOTE3` text DEFAULT NULL,
  `NOTE4` text DEFAULT NULL,
  `NOTE5` text DEFAULT NULL,
  `NOTE6` text DEFAULT NULL,
  `NOTE7` text DEFAULT NULL,
  `NOTE8` text DEFAULT NULL,
  `NOTE9` text DEFAULT NULL,
  `NOTE10` text DEFAULT NULL,
  `NOTE11` text DEFAULT NULL,
  `NOTE12` text DEFAULT NULL,
  `NOTE13` text DEFAULT NULL,
  `NOTE14` text DEFAULT NULL,
  `NOTE15` text DEFAULT NULL,
  `NOTE16` text DEFAULT NULL,
  `NOTE17` text DEFAULT NULL,
  `NOTE18` text DEFAULT NULL,
  `NOTE19` text DEFAULT NULL,
  `NOTE20` text DEFAULT NULL,
  `NOTE21` text DEFAULT NULL,
  `NOTE22` text DEFAULT NULL,
  `NOTE23` text DEFAULT NULL,
  `NOTE24` text DEFAULT NULL,
  `NOTE25` text DEFAULT NULL,
  `NOTE26` text DEFAULT NULL,
  `NOTE27` text DEFAULT NULL,
  `NOTE28` text DEFAULT NULL,
  `NOTE29` text DEFAULT NULL,
  `NOTE30` text DEFAULT NULL,
  `NOTE31` text DEFAULT NULL,
  `NOTE2ND1` text DEFAULT NULL,
  `NOTE2ND2` text DEFAULT NULL,
  `NOTE2ND3` text DEFAULT NULL,
  `NOTE2ND4` text DEFAULT NULL,
  `NOTE2ND5` text DEFAULT NULL,
  `NOTE2ND6` text DEFAULT NULL,
  `NOTE2ND7` text DEFAULT NULL,
  `NOTE2ND8` text DEFAULT NULL,
  `NOTE2ND9` text DEFAULT NULL,
  `NOTE2ND10` text DEFAULT NULL,
  `NOTE2ND11` text DEFAULT NULL,
  `NOTE2ND12` text DEFAULT NULL,
  `NOTE2ND13` text DEFAULT NULL,
  `NOTE2ND14` text DEFAULT NULL,
  `NOTE2ND15` text DEFAULT NULL,
  `NOTE2ND16` text DEFAULT NULL,
  `NOTE2ND17` text DEFAULT NULL,
  `NOTE2ND18` text DEFAULT NULL,
  `NOTE2ND19` text DEFAULT NULL,
  `NOTE2ND20` text DEFAULT NULL,
  `NOTE2ND21` text DEFAULT NULL,
  `NOTE2ND22` text DEFAULT NULL,
  `NOTE2ND23` text DEFAULT NULL,
  `NOTE2ND24` text DEFAULT NULL,
  `NOTE2ND25` text DEFAULT NULL,
  `NOTE2ND26` text DEFAULT NULL,
  `NOTE2ND27` text DEFAULT NULL,
  `NOTE2ND28` text DEFAULT NULL,
  `NOTE2ND29` text DEFAULT NULL,
  `NOTE2ND30` text DEFAULT NULL,
  `NOTE2ND31` text DEFAULT NULL,
  `IN1` datetime DEFAULT NULL,
  `IN2` datetime DEFAULT NULL,
  `IN3` datetime DEFAULT NULL,
  `IN4` datetime DEFAULT NULL,
  `IN5` datetime DEFAULT NULL,
  `IN6` datetime DEFAULT NULL,
  `IN7` datetime DEFAULT NULL,
  `IN8` datetime DEFAULT NULL,
  `IN9` datetime DEFAULT NULL,
  `IN10` datetime DEFAULT NULL,
  `IN11` datetime DEFAULT NULL,
  `IN12` datetime DEFAULT NULL,
  `IN13` datetime DEFAULT NULL,
  `IN14` datetime DEFAULT NULL,
  `IN15` datetime DEFAULT NULL,
  `IN16` datetime DEFAULT NULL,
  `IN17` datetime DEFAULT NULL,
  `IN18` datetime DEFAULT NULL,
  `IN19` datetime DEFAULT NULL,
  `IN20` datetime DEFAULT NULL,
  `IN21` datetime DEFAULT NULL,
  `IN22` datetime DEFAULT NULL,
  `IN23` datetime DEFAULT NULL,
  `IN24` datetime DEFAULT NULL,
  `IN25` datetime DEFAULT NULL,
  `IN26` datetime DEFAULT NULL,
  `IN27` datetime DEFAULT NULL,
  `IN28` datetime DEFAULT NULL,
  `IN29` datetime DEFAULT NULL,
  `IN30` datetime DEFAULT NULL,
  `IN31` datetime DEFAULT NULL,
  `IN2ND1` datetime DEFAULT NULL,
  `IN2ND2` datetime DEFAULT NULL,
  `IN2ND3` datetime DEFAULT NULL,
  `IN2ND4` datetime DEFAULT NULL,
  `IN2ND5` datetime DEFAULT NULL,
  `IN2ND6` datetime DEFAULT NULL,
  `IN2ND7` datetime DEFAULT NULL,
  `IN2ND8` datetime DEFAULT NULL,
  `IN2ND9` datetime DEFAULT NULL,
  `IN2ND10` datetime DEFAULT NULL,
  `IN2ND11` datetime DEFAULT NULL,
  `IN2ND12` datetime DEFAULT NULL,
  `IN2ND13` datetime DEFAULT NULL,
  `IN2ND14` datetime DEFAULT NULL,
  `IN2ND15` datetime DEFAULT NULL,
  `IN2ND16` datetime DEFAULT NULL,
  `IN2ND17` datetime DEFAULT NULL,
  `IN2ND18` datetime DEFAULT NULL,
  `IN2ND19` datetime DEFAULT NULL,
  `IN2ND20` datetime DEFAULT NULL,
  `IN2ND21` datetime DEFAULT NULL,
  `IN2ND22` datetime DEFAULT NULL,
  `IN2ND23` datetime DEFAULT NULL,
  `IN2ND24` datetime DEFAULT NULL,
  `IN2ND25` datetime DEFAULT NULL,
  `IN2ND26` datetime DEFAULT NULL,
  `IN2ND27` datetime DEFAULT NULL,
  `IN2ND28` datetime DEFAULT NULL,
  `IN2ND29` datetime DEFAULT NULL,
  `IN2ND30` datetime DEFAULT NULL,
  `IN2ND31` datetime DEFAULT NULL,
  `OUT1` datetime DEFAULT NULL,
  `OUT2` datetime DEFAULT NULL,
  `OUT3` datetime DEFAULT NULL,
  `OUT4` datetime DEFAULT NULL,
  `OUT5` datetime DEFAULT NULL,
  `OUT6` datetime DEFAULT NULL,
  `OUT7` datetime DEFAULT NULL,
  `OUT8` datetime DEFAULT NULL,
  `OUT9` datetime DEFAULT NULL,
  `OUT10` datetime DEFAULT NULL,
  `OUT11` datetime DEFAULT NULL,
  `OUT12` datetime DEFAULT NULL,
  `OUT13` datetime DEFAULT NULL,
  `OUT14` datetime DEFAULT NULL,
  `OUT15` datetime DEFAULT NULL,
  `OUT16` datetime DEFAULT NULL,
  `OUT17` datetime DEFAULT NULL,
  `OUT18` datetime DEFAULT NULL,
  `OUT19` datetime DEFAULT NULL,
  `OUT20` datetime DEFAULT NULL,
  `OUT21` datetime DEFAULT NULL,
  `OUT22` datetime DEFAULT NULL,
  `OUT23` datetime DEFAULT NULL,
  `OUT24` datetime DEFAULT NULL,
  `OUT25` datetime DEFAULT NULL,
  `OUT26` datetime DEFAULT NULL,
  `OUT27` datetime DEFAULT NULL,
  `OUT28` datetime DEFAULT NULL,
  `OUT29` datetime DEFAULT NULL,
  `OUT30` datetime DEFAULT NULL,
  `OUT31` datetime DEFAULT NULL,
  `OUT2ND1` datetime DEFAULT NULL,
  `OUT2ND2` datetime DEFAULT NULL,
  `OUT2ND3` datetime DEFAULT NULL,
  `OUT2ND4` datetime DEFAULT NULL,
  `OUT2ND5` datetime DEFAULT NULL,
  `OUT2ND6` datetime DEFAULT NULL,
  `OUT2ND7` datetime DEFAULT NULL,
  `OUT2ND8` datetime DEFAULT NULL,
  `OUT2ND9` datetime DEFAULT NULL,
  `OUT2ND10` datetime DEFAULT NULL,
  `OUT2ND11` datetime DEFAULT NULL,
  `OUT2ND12` datetime DEFAULT NULL,
  `OUT2ND13` datetime DEFAULT NULL,
  `OUT2ND14` datetime DEFAULT NULL,
  `OUT2ND15` datetime DEFAULT NULL,
  `OUT2ND16` datetime DEFAULT NULL,
  `OUT2ND17` datetime DEFAULT NULL,
  `OUT2ND18` datetime DEFAULT NULL,
  `OUT2ND19` datetime DEFAULT NULL,
  `OUT2ND20` datetime DEFAULT NULL,
  `OUT2ND21` datetime DEFAULT NULL,
  `OUT2ND22` datetime DEFAULT NULL,
  `OUT2ND23` datetime DEFAULT NULL,
  `OUT2ND24` datetime DEFAULT NULL,
  `OUT2ND25` datetime DEFAULT NULL,
  `OUT2ND26` datetime DEFAULT NULL,
  `OUT2ND27` datetime DEFAULT NULL,
  `OUT2ND28` datetime DEFAULT NULL,
  `OUT2ND29` datetime DEFAULT NULL,
  `OUT2ND30` datetime DEFAULT NULL,
  `OUT2ND31` datetime DEFAULT NULL,
  PRIMARY KEY (`PERIOD_ID`,`EMPLOYEE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_schedule_change` */

DROP TABLE IF EXISTS `hr_emp_schedule_change`;

CREATE TABLE `hr_emp_schedule_change` (
  `EMP_SCHEDULE_CHANGE_ID` bigint(20) NOT NULL,
  `DATETIME_OF_REQUEST` datetime DEFAULT NULL,
  `STATUS_DOC` int(8) DEFAULT NULL,
  `TYPE_OF_FORM` int(8) DEFAULT NULL COMMENT '0=CHANGE SCHDULE ( MANAGEMENT REQUEST )\n1=CHANGE OF / CHANGE SHIFT\n2=EARLY LEAVING FORM',
  `TYPE_OF_SCHEDULE` int(8) DEFAULT NULL,
  `APPLICANT_EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `EXCHANGE_EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `ORIGINAL_DATE` datetime DEFAULT NULL,
  `ORIGINAL_SCHEDULE_ID` bigint(20) DEFAULT NULL,
  `NEW_CHANGE_DATE` datetime DEFAULT NULL,
  `NEW_CHANGE_SCHEDULE_ID` bigint(20) DEFAULT NULL,
  `REASON` varchar(255) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `APPROVER_LEVEL1_ID` bigint(20) DEFAULT NULL,
  `APPROVER_LEVEL2_ID` bigint(20) DEFAULT NULL,
  `APPROVAL_DATE_LEVEL1` datetime DEFAULT NULL,
  `APPROVAL_DATE_LEVEL2` datetime DEFAULT NULL,
  `APPROVAL_DATE_APPLICANT` datetime DEFAULT NULL,
  `APPROVAL_DATE_EXCHANGE` datetime DEFAULT NULL,
  `CHECKED_BY_ID` bigint(20) DEFAULT NULL,
  `CHECKED_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`EMP_SCHEDULE_CHANGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_emp_schedule_history` */

DROP TABLE IF EXISTS `hr_emp_schedule_history`;

CREATE TABLE `hr_emp_schedule_history` (
  `EMP_SCHEDULE_HISTORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMP_SCHEDULE_ORG_ID` bigint(20) DEFAULT 0,
  `PERIOD_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `D1` bigint(20) DEFAULT 0,
  `D2` bigint(20) DEFAULT 0,
  `D3` bigint(20) DEFAULT 0,
  `D4` bigint(20) DEFAULT 0,
  `D5` bigint(20) DEFAULT 0,
  `D6` bigint(20) DEFAULT 0,
  `D7` bigint(20) DEFAULT 0,
  `D8` bigint(20) DEFAULT 0,
  `D9` bigint(20) DEFAULT 0,
  `D10` bigint(20) DEFAULT 0,
  `D11` bigint(20) DEFAULT 0,
  `D12` bigint(20) DEFAULT 0,
  `D13` bigint(20) DEFAULT 0,
  `D14` bigint(20) DEFAULT 0,
  `D15` bigint(20) DEFAULT 0,
  `D16` bigint(20) DEFAULT 0,
  `D17` bigint(20) DEFAULT 0,
  `D18` bigint(20) DEFAULT 0,
  `D19` bigint(20) DEFAULT 0,
  `D20` bigint(20) DEFAULT 0,
  `D21` bigint(20) DEFAULT 0,
  `D22` bigint(20) DEFAULT 0,
  `D23` bigint(20) DEFAULT 0,
  `D24` bigint(20) DEFAULT 0,
  `D25` bigint(20) DEFAULT 0,
  `D26` bigint(20) DEFAULT 0,
  `D27` bigint(20) DEFAULT 0,
  `D28` bigint(20) DEFAULT 0,
  `D29` bigint(20) DEFAULT 0,
  `D30` bigint(20) DEFAULT 0,
  `D31` bigint(20) DEFAULT 0,
  `D2ND1` bigint(20) DEFAULT 0,
  `D2ND2` bigint(20) DEFAULT 0,
  `D2ND3` bigint(20) DEFAULT 0,
  `D2ND4` bigint(20) DEFAULT 0,
  `D2ND5` bigint(20) DEFAULT 0,
  `D2ND6` bigint(20) DEFAULT 0,
  `D2ND7` bigint(20) DEFAULT 0,
  `D2ND8` bigint(20) DEFAULT 0,
  `D2ND9` bigint(20) DEFAULT 0,
  `D2ND10` bigint(20) DEFAULT 0,
  `D2ND11` bigint(20) DEFAULT 0,
  `D2ND12` bigint(20) DEFAULT 0,
  `D2ND13` bigint(20) DEFAULT 0,
  `D2ND14` bigint(20) DEFAULT 0,
  `D2ND15` bigint(20) DEFAULT 0,
  `D2ND16` bigint(20) DEFAULT 0,
  `D2ND17` bigint(20) DEFAULT 0,
  `D2ND18` bigint(20) DEFAULT 0,
  `D2ND19` bigint(20) DEFAULT 0,
  `D2ND20` bigint(20) DEFAULT 0,
  `D2ND21` bigint(20) DEFAULT 0,
  `D2ND22` bigint(20) DEFAULT 0,
  `D2ND23` bigint(20) DEFAULT 0,
  `D2ND24` bigint(20) DEFAULT 0,
  `D2ND25` bigint(20) DEFAULT 0,
  `D2ND26` bigint(20) DEFAULT 0,
  `D2ND27` bigint(20) DEFAULT 0,
  `D2ND28` bigint(20) DEFAULT 0,
  `D2ND29` bigint(20) DEFAULT 0,
  `D2ND30` bigint(20) DEFAULT 0,
  `D2ND31` bigint(20) DEFAULT 0,
  PRIMARY KEY (`EMP_SCHEDULE_HISTORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_talent_pool` */

DROP TABLE IF EXISTS `hr_emp_talent_pool`;

CREATE TABLE `hr_emp_talent_pool` (
  `EMP_TALENT_POOL_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `DATE_TALENT` date DEFAULT NULL,
  `STATUS_INFO` int(2) DEFAULT NULL,
  `MAIN_ID` bigint(25) DEFAULT NULL,
  `POSITION_TYPE_ID` bigint(25) DEFAULT NULL,
  `TOTAL_SCORE` double DEFAULT NULL,
  PRIMARY KEY (`EMP_TALENT_POOL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_emp_visit` */

DROP TABLE IF EXISTS `hr_emp_visit`;

CREATE TABLE `hr_emp_visit` (
  `EMP_VISIT_ID` bigint(20) NOT NULL DEFAULT 0,
  `VISIT_DATE` date DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `DIAGNOSE` varchar(64) DEFAULT NULL,
  `VISITED_BY` bigint(20) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`EMP_VISIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_employee` */

DROP TABLE IF EXISTS `hr_employee`;

CREATE TABLE `hr_employee` (
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `DIVISION_ID` bigint(20) DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) DEFAULT 0,
  `POSITION_ID` bigint(20) DEFAULT 0,
  `POSITION_LEVEL` varchar(100) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_NUM` varchar(20) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT 0,
  `LEVEL_ID` bigint(20) DEFAULT 0,
  `FULL_NAME` varchar(100) DEFAULT NULL,
  `ADDRESS` varchar(200) DEFAULT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `ADDRESS_PERMANENT` varchar(200) DEFAULT NULL,
  `phone_emergency` varchar(128) DEFAULT NULL,
  `HANDPHONE` varchar(128) DEFAULT NULL,
  `POSTAL_CODE` int(11) DEFAULT 0,
  `SEX` tinyint(2) DEFAULT 0,
  `BIRTH_PLACE` varchar(50) DEFAULT NULL,
  `BIRTH_DATE` date DEFAULT NULL,
  `PROBATION_UNTIL` date DEFAULT NULL,
  `RELIGION_ID` bigint(20) DEFAULT 0,
  `BLOOD_TYPE` char(2) DEFAULT NULL,
  `ASTEK_NUM` varchar(15) DEFAULT NULL,
  `ASTEK_DATE` date DEFAULT NULL,
  `MARITAL_ID` bigint(20) DEFAULT 0,
  `LOCKER_ID` bigint(20) DEFAULT 0,
  `COMMENCING_DATE` date DEFAULT NULL,
  `RESIGNED` int(11) DEFAULT 0,
  `RESIGNED_DATE` date DEFAULT NULL,
  `RESIGNED_REASON_ID` bigint(20) DEFAULT 0,
  `RESIGNED_DESC` text DEFAULT NULL,
  `BARCODE_NUMBER` varchar(20) DEFAULT NULL,
  `BASIC_SALARY` decimal(10,2) DEFAULT 0.00,
  `IS_ASSIGN_TO_ACCOUNTING` tinyint(2) DEFAULT 0,
  `EMP_PIN` varchar(20) DEFAULT NULL,
  `CURIER` varchar(40) DEFAULT NULL,
  `INDENT_CARD_NR` varchar(64) DEFAULT NULL,
  `INDENT_CARD_VALID_TO` datetime DEFAULT NULL,
  `TAX_REG_NR` varchar(128) DEFAULT NULL,
  `ADDRESS_FOR_TAX` varchar(128) DEFAULT NULL,
  `NATIONALITY_TYPE` int(4) DEFAULT 0,
  `EMAIL_ADDRESS` varchar(128) DEFAULT NULL,
  `CATEGORY_DATE` date DEFAULT NULL,
  `LEAVE_STATUS` int(4) DEFAULT 0,
  `RACE` bigint(64) NOT NULL DEFAULT 0,
  `ENTRY_DATE_DW` datetime DEFAULT NULL,
  `CONTRACT_DATE` datetime DEFAULT NULL,
  `PERMANENT_DATE` datetime DEFAULT NULL,
  `REFERENCE` varchar(100) DEFAULT NULL,
  `ISSUED_BY_KTP` varchar(100) DEFAULT NULL,
  `PARENT01` varchar(100) DEFAULT NULL,
  `PARENT02` varchar(100) DEFAULT NULL,
  `EMERGENCY_NAME` varchar(100) DEFAULT NULL,
  `SPECIAL_EMPLOYEE` tinyint(1) DEFAULT 0,
  `KECAMATAN1` varchar(200) DEFAULT NULL,
  `KABUPATEN1` varchar(200) DEFAULT NULL,
  `PROPINSI1` varchar(200) DEFAULT NULL,
  `TIME_IN_BOX_NO` bigint(20) DEFAULT 0,
  `KECAMATAN2` varchar(200) DEFAULT NULL,
  `KABUPATEN2` varchar(200) DEFAULT NULL,
  `PROPINSI2` varchar(200) DEFAULT NULL,
  `VEHICLE` varchar(255) DEFAULT NULL,
  `DATE_OF_BIRTH_KTP` datetime DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT 0,
  `EDUCATION_ID` bigint(20) DEFAULT 0,
  `FATHER` varchar(45) DEFAULT NULL,
  `MOTHER` varchar(45) DEFAULT NULL,
  `PARENTS_ADDRESS` varchar(100) DEFAULT NULL,
  `NAME_EMG` varchar(128) DEFAULT NULL,
  `PHONE_EMG` varchar(45) DEFAULT NULL,
  `ADDRESS_EMG` varchar(100) DEFAULT NULL,
  `HOD_EMPLOYEE_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_COUNTRY_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_PROVINCE_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_REGENCY_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_SUBREGENCY_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_PMNT_COUNTRY_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_PMNT_PROVINCE_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_PMNT_REGENCY_ID` bigint(20) unsigned DEFAULT 0,
  `ADDR_PMNT_SUBREGENCY_ID` bigint(20) unsigned DEFAULT 0,
  `ID_CARD_ISSUED_BY` varchar(100) DEFAULT NULL,
  `ID_CARD_BIRTH_DATE` date DEFAULT NULL,
  `EMAIL` varchar(64) DEFAULT NULL,
  `TAX_MARITAL_ID` bigint(20) DEFAULT 0,
  `NO_REKENING` varchar(60) DEFAULT NULL,
  `GRADE_LEVEL_ID` bigint(20) DEFAULT 0,
  `COUNT_IDX` int(80) DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `END_CONTRACT` date DEFAULT NULL,
  `WORK_ASSIGN_COMPANY_ID` bigint(20) DEFAULT NULL,
  `WORK_ASSIGN_DIVISION_ID` bigint(20) DEFAULT NULL,
  `WORK_ASSIGN_DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `WORK_ASSIGN_SECTION_ID` bigint(20) DEFAULT NULL,
  `WORK_ASSIGN_POSITION_ID` bigint(20) DEFAULT NULL,
  `ID_CARD_TYPE` varchar(15) DEFAULT NULL,
  `NPWP` varchar(30) DEFAULT NULL,
  `BPJS_NO` varchar(30) DEFAULT NULL,
  `BPJS_DATE` date DEFAULT NULL,
  `SHIO` varchar(25) DEFAULT NULL,
  `ELEMEN` varchar(30) DEFAULT NULL,
  `IQ` char(4) DEFAULT NULL,
  `EQ` char(4) DEFAULT NULL,
  `PROBATION_END_DATE` date DEFAULT NULL,
  `STATUS_PENSIUN_PROGRAM` int(1) DEFAULT NULL,
  `START_DATE_PENSIUN` date DEFAULT NULL,
  `PRESENCE_CHECK_PARAMETER` int(11) DEFAULT NULL,
  `MEDICAL_INFO` text DEFAULT NULL,
  `DANA_PENDIDIKAN` int(2) DEFAULT NULL,
  `PAYROLL_GROUP` bigint(20) DEFAULT NULL,
  `PROVIDER_ID` bigint(20) DEFAULT NULL,
  `MEMBER_OF_KESEHATAN` int(2) DEFAULT NULL,
  `MEMBER_OF_KETENAGAKERJAAN` int(2) DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `HISTORY_GROUP` int(2) DEFAULT NULL,
  `HISTORY_TYPE` int(2) DEFAULT NULL,
  `EMP_DOC_ID_GRADE` bigint(20) DEFAULT NULL,
  `SK_NOMOR` varchar(128) DEFAULT NULL,
  `SK_TANGGAL` date DEFAULT NULL,
  `NKK` varchar(64) DEFAULT NULL,
  `SK_NOMOR_GRADE` varchar(128) DEFAULT NULL,
  `SK_TANGGAL_GRADE` date DEFAULT NULL,
  `NAME_ON_CARD` varchar(50) DEFAULT NULL,
  `NATIONALITY_ID` bigint(20) DEFAULT NULL,
  `FIRST_CONTRACT_DATE` date DEFAULT NULL,
  `BPJS_TK_PENSIUN` bigint(20) DEFAULT NULL,
  `BPJS_TK_PENSIUN_DATE` date DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEE_ID`),
  UNIQUE KEY `BARCODE_NUMBER` (`BARCODE_NUMBER`),
  UNIQUE KEY `EMP_NUM_UNQ` (`EMPLOYEE_NUM`),
  KEY `FK_hr_employee_company` (`COMPANY_ID`),
  KEY `FK_hr_employee_division` (`DIVISION_ID`),
  KEY `FK_hr_employee_department` (`DEPARTMENT_ID`),
  KEY `FK_hr_employee_position` (`POSITION_ID`),
  KEY `FK_hr_employee_education` (`EDUCATION_ID`),
  KEY `FK_hr_employee_locker` (`LOCKER_ID`),
  KEY `FK_hr_employee_level` (`LEVEL_ID`),
  KEY `FK_hr_employee_category` (`EMP_CATEGORY_ID`),
  KEY `FK_hr_employee_marital` (`MARITAL_ID`),
  CONSTRAINT `FK_hr_employee_category` FOREIGN KEY (`EMP_CATEGORY_ID`) REFERENCES `hr_emp_category` (`EMP_CATEGORY_ID`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_employee_department` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `hr_department` (`DEPARTMENT_ID`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_employee_division` FOREIGN KEY (`DIVISION_ID`) REFERENCES `hr_division` (`DIVISION_ID`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_employee_level` FOREIGN KEY (`LEVEL_ID`) REFERENCES `hr_level` (`LEVEL_ID`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_employee_marital` FOREIGN KEY (`MARITAL_ID`) REFERENCES `hr_marital` (`MARITAL_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_employee_appraisal` */

DROP TABLE IF EXISTS `hr_employee_appraisal`;

CREATE TABLE `hr_employee_appraisal` (
  `EMPLOYEE_APPRAISAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `APPRAISOR_ID` bigint(20) DEFAULT NULL,
  `DATE_OF_APPRAISAL` date DEFAULT NULL,
  `LAST_APPRAISAL` date DEFAULT NULL,
  `TOTAL_SCORE` int(11) DEFAULT NULL,
  `TOTAL_CRITERIA` int(11) DEFAULT NULL,
  `SCORE_AVERAGE` decimal(6,2) DEFAULT NULL,
  `DATE_PERFORMANCE` date DEFAULT NULL,
  `TIME_PERFORMANCE` time DEFAULT NULL,
  `GROUP_RANK_ID` bigint(20) unsigned zerofill NOT NULL DEFAULT 00000000000000000000,
  PRIMARY KEY (`EMPLOYEE_APPRAISAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_entri_opname_sales` */

DROP TABLE IF EXISTS `hr_entri_opname_sales`;

CREATE TABLE `hr_entri_opname_sales` (
  `ENTRI_OPNAME_SALES_ID` bigint(20) NOT NULL DEFAULT 0,
  `JENIS_SO_ID` bigint(20) DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  `TYPE_OF_TOLERANCE` int(3) DEFAULT 0,
  `NET_SALES_PERIOD` double DEFAULT 0,
  `PROSENTASE_TOLERANCE` double DEFAULT 0,
  `BARANG_HILANG` double DEFAULT 0,
  `CREATE_FORM_LOCATION_OPNAME` varchar(200) DEFAULT NULL,
  `PLUS_MINUS_HITUNG` double DEFAULT 0,
  `STATUS_OPNAME` varchar(100) DEFAULT NULL,
  `DATE_FROM_PERIODE` date DEFAULT NULL,
  `DATE_TO_PERIODE` date DEFAULT NULL,
  PRIMARY KEY (`ENTRI_OPNAME_SALES_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_evaluation` */

DROP TABLE IF EXISTS `hr_evaluation`;

CREATE TABLE `hr_evaluation` (
  `EVALUATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `CODE` char(2) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `DESRIPTION` text DEFAULT NULL,
  `MAX_PERCENTAGE` decimal(6,2) NOT NULL DEFAULT 0.00,
  `EVAL_TYPE` bigint(20) DEFAULT 0,
  `MAX_POINT` int(11) DEFAULT 0,
  PRIMARY KEY (`EVALUATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_explanation_coverage` */

DROP TABLE IF EXISTS `hr_explanation_coverage`;

CREATE TABLE `hr_explanation_coverage` (
  `EXPLANATION_COVERAGE_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_RANK_ID` bigint(20) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `DEFINITION` text DEFAULT NULL,
  PRIMARY KEY (`EXPLANATION_COVERAGE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_extra_schedule_outlet` */

DROP TABLE IF EXISTS `hr_extra_schedule_outlet`;

CREATE TABLE `hr_extra_schedule_outlet` (
  `EXTRA_SCHEDULE_MAPPING_ID` bigint(20) NOT NULL DEFAULT 0,
  `REQUEST_DATE_EXTRA_SCHEDULE` datetime DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT 0,
  `DIVISION_ID` bigint(20) DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) DEFAULT 0,
  `SECTION_ID` bigint(20) DEFAULT 0,
  `COST_CENTER_ID` bigint(20) DEFAULT 0 COMMENT 'DIAMBIL DARI DEPARTMENT_ID',
  `EXTRA_SCHEDULE_ADJECTIVE` text DEFAULT NULL COMMENT 'NOTE SECARA UMUM',
  `EXTRA_SCHEDULE_NUMBER` varchar(300) DEFAULT NULL,
  `STATUS_DOCUMENT_FORM_EXTRA_SCHEDULE` int(2) DEFAULT 0,
  `REQUEST_EMPLOYEE_ID_APPOVALL_DOCUMENT` bigint(20) DEFAULT 0,
  `REQUEST_EMPLOYEE_ID_APPOVALL1_DOCUMENT` bigint(20) DEFAULT 0,
  `REQUEST_EMPLOYEE_ID_APPOVALL2_DOCUMENT` bigint(20) DEFAULT 0,
  `REQUEST_EMPLOYEE_ID_APPOVALL_DOCUMENT_DATE` datetime DEFAULT NULL,
  `REQUEST_EMPLOYEE_ID_APPOVALL1_DOCUMENT_DATE` datetime DEFAULT NULL,
  `REQUEST_EMPLOYEE_ID_APPOVALL2_DOCUMENT_DATE` date DEFAULT NULL,
  `COUNT_IDX` int(11) DEFAULT NULL,
  `FLAG_EMPLOYEE_SAVE` text DEFAULT NULL,
  PRIMARY KEY (`EXTRA_SCHEDULE_MAPPING_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_extra_schedule_outlet_detail` */

DROP TABLE IF EXISTS `hr_extra_schedule_outlet_detail`;

CREATE TABLE `hr_extra_schedule_outlet_detail` (
  `EXTRA_SCHEDULE_MAPPING_DETAIL_ID` bigint(20) NOT NULL DEFAULT 0,
  `EXTRA_SCHEDULE_MAPPING_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `START_DATE_PLAN` datetime DEFAULT NULL,
  `END_DATE_PLAN` datetime DEFAULT NULL,
  `START_DATE_REAL` datetime DEFAULT NULL,
  `END_DATE_REAL` datetime DEFAULT NULL,
  `REST_TIME_START` datetime DEFAULT NULL,
  `REST_TIME_HR` float DEFAULT NULL,
  `JOB_DESCH` text DEFAULT NULL,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  `STATUS_DOCUMENT` int(2) DEFAULT 0,
  PRIMARY KEY (`EXTRA_SCHEDULE_MAPPING_DETAIL_ID`),
  KEY `FK_hr_extra_schedule_outlet_detail` (`EXTRA_SCHEDULE_MAPPING_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_family_member` */

DROP TABLE IF EXISTS `hr_family_member`;

CREATE TABLE `hr_family_member` (
  `FAMILY_MEMBER_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `FULL_NAME` varchar(100) DEFAULT NULL,
  `RELATIONSHIP` bigint(20) NOT NULL DEFAULT 0,
  `BIRTH_DATE` date DEFAULT NULL,
  `job` varchar(100) DEFAULT NULL,
  `ADDRESS` varchar(200) DEFAULT NULL,
  `GUARANTEED` tinyint(2) NOT NULL DEFAULT 0,
  `IGNORE_DATE` tinyint(4) DEFAULT NULL,
  `IGNORE_BIRTH` tinyint(4) DEFAULT NULL,
  `RELIGION_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `SEX` tinyint(2) DEFAULT NULL,
  `CARD_ID` varchar(24) NOT NULL DEFAULT '0',
  `NO_TELP` bigint(20) DEFAULT NULL,
  `BPJS_NUM` varchar(40) DEFAULT NULL,
  `JOB_PLACE` varchar(40) DEFAULT NULL,
  `JOB_POSITION` varchar(40) DEFAULT NULL,
  `BIRTH_PLACE` varchar(255) DEFAULT '""',
  PRIMARY KEY (`FAMILY_MEMBER_ID`,`RELATIONSHIP`),
  KEY `FK_hr_family_member_employee` (`EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_family_relation` */

DROP TABLE IF EXISTS `hr_family_relation`;

CREATE TABLE `hr_family_relation` (
  `FAMILY_RELATION_ID` bigint(20) NOT NULL,
  `FAMILY_RELATION_TYPE` int(11) NOT NULL,
  `FAMILY_RELATION` varchar(20) NOT NULL,
  `SHOW_IN_CV` int(2) DEFAULT 0,
  PRIMARY KEY (`FAMILY_RELATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_finger_print` */

DROP TABLE IF EXISTS `hr_finger_print`;

CREATE TABLE `hr_finger_print` (
  `FINGER_FRINT_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_NUM` varchar(20) DEFAULT NULL,
  `FINGER_PRINT` int(11) DEFAULT NULL,
  PRIMARY KEY (`FINGER_FRINT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_grade_level` */

DROP TABLE IF EXISTS `hr_grade_level`;

CREATE TABLE `hr_grade_level` (
  `GRADE_LEVEL_ID` bigint(20) NOT NULL DEFAULT 0,
  `GRADE_CODE` varchar(30) DEFAULT NULL,
  `GRADE_RANK` int(2) DEFAULT 0,
  PRIMARY KEY (`GRADE_LEVEL_ID`),
  KEY `GRADE` (`GRADE_RANK`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_group_category` */

DROP TABLE IF EXISTS `hr_group_category`;

CREATE TABLE `hr_group_category` (
  `GROUP_CATEGORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_RANK_ID` bigint(20) DEFAULT NULL,
  `GROUP_NAME` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`GROUP_CATEGORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_group_priv` */

DROP TABLE IF EXISTS `hr_group_priv`;

CREATE TABLE `hr_group_priv` (
  `GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `PRIV_ID` bigint(20) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_group_rank` */

DROP TABLE IF EXISTS `hr_group_rank`;

CREATE TABLE `hr_group_rank` (
  `GROUP_RANK_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_NAME` varchar(20) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`GROUP_RANK_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_guest_handling` */

DROP TABLE IF EXISTS `hr_guest_handling`;

CREATE TABLE `hr_guest_handling` (
  `GUEST_CLINIC_ID` bigint(20) NOT NULL DEFAULT 0,
  `DATE` date DEFAULT NULL,
  `GUEST_NAME` varchar(64) DEFAULT NULL,
  `ROOM` varchar(10) DEFAULT NULL,
  `DIAGNOSIS` varchar(64) DEFAULT NULL,
  `TREATMENT` varchar(128) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`GUEST_CLINIC_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_hrd_information` */

DROP TABLE IF EXISTS `hr_hrd_information`;

CREATE TABLE `hr_hrd_information` (
  `INFORMATION_HRD_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAMA_INFORMATION` text DEFAULT NULL,
  `DATE_START` datetime DEFAULT NULL,
  `DATE_END` datetime DEFAULT NULL,
  PRIMARY KEY (`INFORMATION_HRD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_information` */

DROP TABLE IF EXISTS `hr_information`;

CREATE TABLE `hr_information` (
  `INFORMATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME_INFORMATION` text DEFAULT NULL,
  `DATE_START` date DEFAULT NULL,
  `DATE_END` date DEFAULT NULL,
  PRIMARY KEY (`INFORMATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_jenis_so` */

DROP TABLE IF EXISTS `hr_jenis_so`;

CREATE TABLE `hr_jenis_so` (
  `JENIS_SO_ID` bigint(20) NOT NULL,
  `NAMA_SO` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`JENIS_SO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kabupaten` */

DROP TABLE IF EXISTS `hr_kabupaten`;

CREATE TABLE `hr_kabupaten` (
  `ID_KAB` bigint(20) NOT NULL,
  `KD_KAB` varchar(10) DEFAULT NULL,
  `NAMA_KAB` varchar(64) NOT NULL,
  `ID_PROP` bigint(20) NOT NULL,
  PRIMARY KEY (`ID_KAB`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kadiv_mapping` */

DROP TABLE IF EXISTS `hr_kadiv_mapping`;

CREATE TABLE `hr_kadiv_mapping` (
  `KADIV_MAPPING_OUTLET_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `POSITION_ID` bigint(20) DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`KADIV_MAPPING_OUTLET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kecamatan` */

DROP TABLE IF EXISTS `hr_kecamatan`;

CREATE TABLE `hr_kecamatan` (
  `ID_KECAM` bigint(20) NOT NULL,
  `KD_KECAM` varchar(10) DEFAULT NULL,
  `NAMA_KECAM` varchar(64) NOT NULL,
  `ID_KAB` bigint(20) NOT NULL,
  PRIMARY KEY (`ID_KECAM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_koefision_position` */

DROP TABLE IF EXISTS `hr_koefision_position`;

CREATE TABLE `hr_koefision_position` (
  `KOEFISION_POSITION_ID` bigint(20) NOT NULL DEFAULT 0,
  `POSITION_ID` bigint(20) DEFAULT 0,
  `NILAI_KOEFISION_OUTLET` double DEFAULT 0,
  `NILAI_KOEFISION_DC` double DEFAULT 0,
  PRIMARY KEY (`KOEFISION_POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_achiev_score` */

DROP TABLE IF EXISTS `hr_kpi_achiev_score`;

CREATE TABLE `hr_kpi_achiev_score` (
  `KPI_ACHIEV_SCORE_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) NOT NULL,
  `ACHIEV_PCTG_MIN` float(4,0) NOT NULL,
  `ACHIEV_PCTG_MAX` float(4,0) NOT NULL,
  `ACHIEV_DURATION_MIN` float(4,0) NOT NULL,
  `ACHIEV_DURATION_MAX` float(4,0) NOT NULL,
  `SCORE` float(4,0) NOT NULL,
  `VALID_START` date NOT NULL,
  `VALID_END` date NOT NULL,
  PRIMARY KEY (`KPI_ACHIEV_SCORE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_company_target` */

DROP TABLE IF EXISTS `hr_kpi_company_target`;

CREATE TABLE `hr_kpi_company_target` (
  `KPI_COMPANY_TARGET_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `TARGET` double DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  `COMPETITOR_ID` bigint(20) DEFAULT NULL,
  `COMPETITOR_VALUE` float DEFAULT NULL,
  PRIMARY KEY (`KPI_COMPANY_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_department_target` */

DROP TABLE IF EXISTS `hr_kpi_department_target`;

CREATE TABLE `hr_kpi_department_target` (
  `KPI_DEPARTMENT_TARGET_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `TARGET` double DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  PRIMARY KEY (`KPI_DEPARTMENT_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_division_target` */

DROP TABLE IF EXISTS `hr_kpi_division_target`;

CREATE TABLE `hr_kpi_division_target` (
  `KPI_DIVISION_TARGET_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `TARGET` double DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  PRIMARY KEY (`KPI_DIVISION_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_employee_achiev` */

DROP TABLE IF EXISTS `hr_kpi_employee_achiev`;

CREATE TABLE `hr_kpi_employee_achiev` (
  `KPI_EMPLOYEE_ACHIEV_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `ENTRYDATE` datetime DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  `ACHIEV_DATE` datetime DEFAULT NULL,
  `ACHIEV_PROOF` text DEFAULT NULL,
  `ACHIEV_TYPE` int(2) DEFAULT 0,
  `APPROVAL_1` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_1` datetime DEFAULT NULL,
  `APPROVAL_2` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_2` datetime DEFAULT NULL,
  `APPROVAL_3` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_3` datetime DEFAULT NULL,
  `APPROVAL_4` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_4` datetime DEFAULT NULL,
  `APPROVAL_5` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_5` datetime DEFAULT NULL,
  `APPROVAL_6` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_6` datetime DEFAULT NULL,
  `STATUS` int(11) DEFAULT NULL,
  `TARGET_ID` bigint(25) DEFAULT NULL,
  `ACHIEV_NOTE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`KPI_EMPLOYEE_ACHIEV_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_employee_target` */

DROP TABLE IF EXISTS `hr_kpi_employee_target`;

CREATE TABLE `hr_kpi_employee_target` (
  `KPI_EMPLOYEE_TARGET_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `TARGET` double DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  `ACHIEV_DATE` datetime DEFAULT NULL,
  `ACHIEV_PROOF` text DEFAULT NULL,
  `KPI_TARGET_DETAIL_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`KPI_EMPLOYEE_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_group` */

DROP TABLE IF EXISTS `hr_kpi_group`;

CREATE TABLE `hr_kpi_group` (
  `KPI_GROUP_ID` bigint(20) NOT NULL,
  `KPI_TYPE_ID` bigint(20) NOT NULL,
  `GROUP_TITLE` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`KPI_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_list` */

DROP TABLE IF EXISTS `hr_kpi_list`;

CREATE TABLE `hr_kpi_list` (
  `KPI_LIST_ID` bigint(20) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `KPI_TITLE` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  `VALID_FROM` datetime DEFAULT NULL,
  `VALID_TO` datetime DEFAULT NULL,
  `VALUE_TYPE` varchar(64) DEFAULT NULL,
  `INPUT_TYPE` int(2) DEFAULT 0,
  `PARENT_ID` bigint(20) DEFAULT NULL,
  `KORELASI` int(2) DEFAULT 0,
  PRIMARY KEY (`KPI_LIST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_list_group` */

DROP TABLE IF EXISTS `hr_kpi_list_group`;

CREATE TABLE `hr_kpi_list_group` (
  `KPI_LIST_GROUP_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `KPI_GROUP_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`KPI_LIST_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_list_position` */

DROP TABLE IF EXISTS `hr_kpi_list_position`;

CREATE TABLE `hr_kpi_list_position` (
  `KPI_LIST_POSITION_ID` bigint(25) NOT NULL,
  `KPI_LIST_ID` bigint(25) DEFAULT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`KPI_LIST_POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_section_target` */

DROP TABLE IF EXISTS `hr_kpi_section_target`;

CREATE TABLE `hr_kpi_section_target` (
  `KPI_SECTION_TARGET_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `TARGET` double DEFAULT NULL,
  `ACHIEVEMENT` double DEFAULT NULL,
  PRIMARY KEY (`KPI_SECTION_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_kpi_target` */

DROP TABLE IF EXISTS `hr_kpi_target`;

CREATE TABLE `hr_kpi_target` (
  `KPI_TARGET_ID` bigint(25) NOT NULL,
  `CREATE_DATE` date DEFAULT NULL,
  `TITLE` varchar(255) DEFAULT NULL,
  `STATUS_DOC` int(2) DEFAULT 0,
  `COMPANY_ID` bigint(25) DEFAULT NULL,
  `DIVISION_ID` bigint(25) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(25) DEFAULT NULL,
  `SECTION_ID` bigint(25) DEFAULT NULL,
  `COUNT_IDX` int(2) DEFAULT 0,
  `APPROVAL_1` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_1` date DEFAULT NULL,
  `APPROVAL_2` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_2` date DEFAULT NULL,
  `APPROVAL_3` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_3` date DEFAULT NULL,
  `APPROVAL_4` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_4` date DEFAULT NULL,
  `APPROVAL_5` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_5` date DEFAULT NULL,
  `APPROVAL_6` bigint(25) DEFAULT NULL,
  `APPROVAL_DATE_6` date DEFAULT NULL,
  `AUTHOR_ID` bigint(25) DEFAULT NULL,
  `TAHUN` int(10) DEFAULT NULL,
  PRIMARY KEY (`KPI_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_target_detail` */

DROP TABLE IF EXISTS `hr_kpi_target_detail`;

CREATE TABLE `hr_kpi_target_detail` (
  `KPI_TARGET_DETAIL_ID` bigint(25) DEFAULT NULL,
  `KPI_TARGET_ID` bigint(25) DEFAULT NULL,
  `KPI_ID` bigint(25) DEFAULT NULL,
  `PERIOD` int(2) DEFAULT NULL,
  `DATE_FROM` date DEFAULT NULL,
  `DATE_TO` date DEFAULT NULL,
  `AMOUNT` double DEFAULT NULL,
  `KPI_GROUP_ID` bigint(25) DEFAULT NULL,
  `WEIGHT_VALUE` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_target_detail_employee` */

DROP TABLE IF EXISTS `hr_kpi_target_detail_employee`;

CREATE TABLE `hr_kpi_target_detail_employee` (
  `KPI_TARGET_DETAIL_EMPLOYEE_ID` bigint(25) NOT NULL,
  `KPI_TARGET_DETAIL_ID` bigint(25) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(25) DEFAULT NULL,
  `BOBOT` double DEFAULT NULL,
  PRIMARY KEY (`KPI_TARGET_DETAIL_EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_kpi_type` */

DROP TABLE IF EXISTS `hr_kpi_type`;

CREATE TABLE `hr_kpi_type` (
  `KPI_TYPE_ID` bigint(20) NOT NULL,
  `TYPE_NAME` varchar(256) DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`KPI_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_language` */

DROP TABLE IF EXISTS `hr_language`;

CREATE TABLE `hr_language` (
  `LANGUAGE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LANGUAGE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`LANGUAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave` */

DROP TABLE IF EXISTS `hr_leave`;

CREATE TABLE `hr_leave` (
  `LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `SUBMIT_DATE` date DEFAULT NULL,
  `LEAVE_FROM` date DEFAULT NULL,
  `LEAVE_TO` date DEFAULT NULL,
  `DURATION` int(11) DEFAULT NULL,
  `REASON` text DEFAULT NULL,
  `LONG_LEAVE` int(11) DEFAULT NULL,
  `ANNUAL_LEAVE` int(11) DEFAULT NULL,
  `LEAVE_WO_PAY` int(11) DEFAULT NULL,
  `MATERNITY_LEAVE` int(11) DEFAULT NULL,
  `DAY_OFF` int(11) DEFAULT NULL,
  `PUBLIC_HOLIDAY` int(11) DEFAULT NULL,
  `EXTRA_DAY_OFF` int(11) DEFAULT NULL,
  `SICK_LEAVE` int(11) DEFAULT NULL,
  `PERIOD_AL_FROM` int(11) DEFAULT NULL,
  `PERIOD_AL_TO` int(11) DEFAULT NULL,
  `AL_ENTITLEMENT` int(11) DEFAULT NULL,
  `AL_TAKEN` int(11) DEFAULT NULL,
  `AL_BALANCE` int(11) DEFAULT NULL,
  `PERIOD_LL_FROM` int(11) DEFAULT NULL,
  `PERIOD_LL_TO` int(11) DEFAULT NULL,
  `LL_ENTITLEMENT` int(11) DEFAULT NULL,
  `LL_TAKEN` int(11) DEFAULT NULL,
  `LL_BALANCE` int(11) DEFAULT NULL,
  `APR_SPV_DATE` date DEFAULT NULL,
  `APR_DEPTHEAD_DATE` date DEFAULT NULL,
  `APR_PMGR_DATE` date DEFAULT NULL,
  `LEAVE_TYPE` int(11) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_application` */

DROP TABLE IF EXISTS `hr_leave_application`;

CREATE TABLE `hr_leave_application` (
  `LEAVE_APPLICATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `SUBMISSION_DATE` date DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `LEAVE_REASON` text DEFAULT NULL,
  `DEP_HEAD_APPROVAL` bigint(20) DEFAULT NULL,
  `HR_MAN_APPROVAL` bigint(20) DEFAULT NULL,
  `DOC_STATUS` tinyint(4) DEFAULT NULL,
  `DEP_HEAD_APPROVE_DATE` date DEFAULT NULL,
  `TAKEN_DATE_FROM` date DEFAULT '0000-00-00',
  `HR_MAN_APPROVE_DATE` date DEFAULT NULL,
  `GM_APPROVAL` bigint(20) DEFAULT NULL,
  `GM_APPROVAL_DATE` date DEFAULT NULL,
  `TYPE_LEAVE` int(3) DEFAULT 0,
  `TYPE_FORM_LEAVE` int(3) DEFAULT 0 COMMENT 'TYPE FROM LEAVE : 0= ARTINYA ITU DI LEAVE FORM APP, 1 ARTINYA EXCUSE LEAVE',
  `REASON_ID` bigint(20) DEFAULT 0 COMMENT 'REASON ID',
  `LEAVE_APPLICATION_DIFFERENT_PERIOD` bigint(20) NOT NULL DEFAULT 0 COMMENT 'ini berguna untuk jika menggunakan beda periode, id yg di gunakan leave application',
  `AL_ALLOWANCE` char(2) DEFAULT NULL,
  `LL_ALLOWANCE` char(2) DEFAULT NULL,
  `APPROVAL_1` bigint(20) DEFAULT NULL,
  `APPROVAL_1_DATE` date DEFAULT NULL,
  `APPROVAL_2` bigint(20) DEFAULT NULL,
  `APPROVAL_2_DATE` date DEFAULT NULL,
  `APPROVAL_3` bigint(20) DEFAULT NULL,
  `APPROVAL_3_DATE` date DEFAULT NULL,
  `APPROVAL_4` bigint(20) DEFAULT NULL,
  `APPROVAL_4_DATE` date DEFAULT NULL,
  `APPROVAL_5` bigint(20) DEFAULT NULL,
  `APPROVAL_5_DATE` date DEFAULT NULL,
  `APPROVAL_6` bigint(20) DEFAULT NULL,
  `APPROVAL_6_DATE` date DEFAULT NULL,
  `TYPE_LEAVE_CATEGORY` int(2) DEFAULT NULL,
  `DIREKSI_APPROVAL` int(2) DEFAULT NULL,
  `REP_APPROVAL_1` bigint(20) DEFAULT NULL,
  `REP_APPROVAL_2` bigint(20) DEFAULT NULL,
  `REP_APPROVAL_3` bigint(20) DEFAULT NULL,
  `REP_APPROVAL_4` bigint(20) DEFAULT NULL,
  `REP_APPROVAL_5` bigint(20) DEFAULT NULL,
  `REP_APPROVAL_6` bigint(20) DEFAULT NULL,
  `PAY_SLIP_ID` bigint(20) DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`LEAVE_APPLICATION_ID`),
  KEY `LEAVE_CAT` (`TYPE_LEAVE_CATEGORY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_application_approved` */

DROP TABLE IF EXISTS `hr_leave_application_approved`;

CREATE TABLE `hr_leave_application_approved` (
  `leave_application_id` tinyint(4) NOT NULL,
  `doc_status` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_leave_application_detail` */

DROP TABLE IF EXISTS `hr_leave_application_detail`;

CREATE TABLE `hr_leave_application_detail` (
  `LEAVE_APPLICATION_DETAIL_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_APPLICATION_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_TYPE` tinyint(4) DEFAULT NULL,
  `TAKEN_DATE` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`LEAVE_APPLICATION_DETAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_application_end_date` */

DROP TABLE IF EXISTS `hr_leave_application_end_date`;

CREATE TABLE `hr_leave_application_end_date` (
  `al_stock_taken_id` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_leave_configuration_main` */

DROP TABLE IF EXISTS `hr_leave_configuration_main`;

CREATE TABLE `hr_leave_configuration_main` (
  `LEAVE_CONFIGURATION_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `PLUS_NOTE_APPROVALL` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_CONFIGURATION_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_configuration_main_departement` */

DROP TABLE IF EXISTS `hr_leave_configuration_main_departement`;

CREATE TABLE `hr_leave_configuration_main_departement` (
  `LEAVE_CONFIGURATION_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTEMENT_ID` bigint(20) DEFAULT 0,
  `SECTION_ID` bigint(20) DEFAULT 0,
  KEY `FK_hr_leave_configuration_main_departement` (`LEAVE_CONFIGURATION_MAIN_ID`),
  CONSTRAINT `FK_hr_leave_configuration_main_departement` FOREIGN KEY (`LEAVE_CONFIGURATION_MAIN_ID`) REFERENCES `hr_leave_configuration_main` (`LEAVE_CONFIGURATION_MAIN_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_configuration_main_departement_request_only` */

DROP TABLE IF EXISTS `hr_leave_configuration_main_departement_request_only`;

CREATE TABLE `hr_leave_configuration_main_departement_request_only` (
  `LEAVE_CONFIGURATION_MAIN_ID_REQUEST_ONLY` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTEMENT_ID` bigint(20) DEFAULT 0,
  `SECTION_ID` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_leave_configuration_main_position` */

DROP TABLE IF EXISTS `hr_leave_configuration_main_position`;

CREATE TABLE `hr_leave_configuration_main_position` (
  `LEAVE_CONFIGURATION_MAIN_ID` bigint(20) DEFAULT 0,
  `POSITION_MIN_ID` bigint(20) DEFAULT 0,
  `POSITION_MAX_ID` bigint(20) DEFAULT 0,
  KEY `FK_hr_leave_configuration_main_position` (`LEAVE_CONFIGURATION_MAIN_ID`),
  CONSTRAINT `FK_hr_leave_configuration_main_position` FOREIGN KEY (`LEAVE_CONFIGURATION_MAIN_ID`) REFERENCES `hr_leave_configuration_main` (`LEAVE_CONFIGURATION_MAIN_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_configuration_main_position_request_only` */

DROP TABLE IF EXISTS `hr_leave_configuration_main_position_request_only`;

CREATE TABLE `hr_leave_configuration_main_position_request_only` (
  `LEAVE_CONFIGURATION_MAIN_ID_REQUEST_ONLY` bigint(20) NOT NULL DEFAULT 0,
  `POSITION_MIN_ID` bigint(20) DEFAULT 0,
  `POSITION_MAX_ID` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_leave_configuration_main_request_only` */

DROP TABLE IF EXISTS `hr_leave_configuration_main_request_only`;

CREATE TABLE `hr_leave_configuration_main_request_only` (
  `LEAVE_CONFIGURATION_MAIN_ID_REQUEST_ONLY` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `PLUS_NOTE_APPROVALL` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_CONFIGURATION_MAIN_ID_REQUEST_ONLY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_leave_period` */

DROP TABLE IF EXISTS `hr_leave_period`;

CREATE TABLE `hr_leave_period` (
  `LEAVE_PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `STATUS` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_PERIOD_ID`),
  CONSTRAINT `FK_hr_leave_period` FOREIGN KEY (`LEAVE_PERIOD_ID`) REFERENCES `hr_leave_stock` (`LEAVE_STOCK_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_stock` */

DROP TABLE IF EXISTS `hr_leave_stock`;

CREATE TABLE `hr_leave_stock` (
  `LEAVE_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_PERIOD_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `AL_AMOUNT` int(11) DEFAULT NULL,
  `LL_AMOUNT` int(11) DEFAULT NULL,
  `DP_AMOUNT` int(11) DEFAULT NULL,
  `ADD_AL` int(11) DEFAULT NULL,
  `ADD_LL` int(11) DEFAULT NULL,
  `ADD_DP` int(11) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_STOCK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_stock_taken` */

DROP TABLE IF EXISTS `hr_leave_stock_taken`;

CREATE TABLE `hr_leave_stock_taken` (
  `LEAVE_STOCK_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_STOCK_ID` bigint(20) DEFAULT NULL,
  `IDX_LEAVE_TAKEN` tinyint(4) DEFAULT NULL,
  `EMP_SCHEDULE_ID` bigint(20) DEFAULT NULL,
  `IDX_DATE_SCHEDULE` tinyint(4) DEFAULT NULL,
  `LEAVE_TYPE` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`LEAVE_STOCK_TAKEN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_leave_target` */

DROP TABLE IF EXISTS `hr_leave_target`;

CREATE TABLE `hr_leave_target` (
  `LEAVE_TARGET_ID` bigint(20) NOT NULL DEFAULT 0,
  `DATE` date DEFAULT NULL,
  `NAME` varchar(30) DEFAULT NULL,
  `DP_TARGET` double DEFAULT NULL,
  `AL_TARGET` double DEFAULT NULL,
  `LL_TARGET` double DEFAULT NULL,
  PRIMARY KEY (`LEAVE_TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_level` */

DROP TABLE IF EXISTS `hr_level`;

CREATE TABLE `hr_level` (
  `LEVEL_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_RANK_ID` bigint(20) DEFAULT NULL,
  `LEVEL` varchar(40) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `MED_LEVEL_ID_EMPLOYEE` bigint(20) DEFAULT NULL,
  `MED_LEVEL_ID_FAMILY` bigint(20) DEFAULT NULL,
  `GRADE_LEVEL_ID` bigint(20) DEFAULT 0,
  `LEVEL_POINT` int(4) DEFAULT NULL,
  `CODE` varchar(10) DEFAULT '0',
  `LEVEL_RANK` int(10) DEFAULT NULL,
  `MAX_LEVEL_APPROVAL` bigint(20) DEFAULT NULL,
  `HR_APPROVAL` int(2) DEFAULT 0,
  `MAX_NUMBER_APPROVAL` int(2) DEFAULT 0,
  `MIN_GRADE` int(2) DEFAULT 0,
  `MAX_GRADE` int(2) DEFAULT 0,
  PRIMARY KEY (`LEVEL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_app` */

DROP TABLE IF EXISTS `hr_ll_app`;

CREATE TABLE `hr_ll_app` (
  `LL_APP_ID` bigint(20) NOT NULL DEFAULT 0,
  `SUBMISSION_DATE` date DEFAULT NULL,
  `APPROVAL_ID` bigint(20) DEFAULT NULL,
  `APPROVAL2_ID` bigint(20) DEFAULT NULL,
  `APPROVAL3_ID` bigint(20) DEFAULT NULL,
  `APPROVAL_DATE` date DEFAULT NULL,
  `APPROVAL2_DATE` date DEFAULT NULL,
  `APPROVAL3_DATE` date DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `BALANCE` float(15,8) DEFAULT NULL,
  `DOC_STATUS` int(11) DEFAULT 0,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `REQUEST_QTY` float(15,8) DEFAULT 0.00000000,
  `TAKEN_QTY` float(15,8) DEFAULT 0.00000000,
  PRIMARY KEY (`LL_APP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_expired` */

DROP TABLE IF EXISTS `hr_ll_stock_expired`;

CREATE TABLE `hr_ll_stock_expired` (
  `LL_STOCK_EXPIRED_ID` bigint(20) NOT NULL DEFAULT 0,
  `LL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `EXPIRED_DATE` date NOT NULL DEFAULT '0000-00-00',
  `EXPIRED_QTY` float(15,8) NOT NULL DEFAULT 0.00000000,
  `EXPIRED_LL` float(15,8) DEFAULT NULL,
  `EXPIRED_LAST` float(15,8) DEFAULT NULL,
  PRIMARY KEY (`LL_STOCK_EXPIRED_ID`),
  KEY `idx_hr_ll_stock_exp_stock_id` (`LL_STOCK_ID`),
  CONSTRAINT `FK_hr_ll_stock_expired_ll_stock_id` FOREIGN KEY (`LL_STOCK_ID`) REFERENCES `hr_ll_stock_management` (`LL_STOCK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_extended` */

DROP TABLE IF EXISTS `hr_ll_stock_extended`;

CREATE TABLE `hr_ll_stock_extended` (
  `LL_STOCK_EXTENDED_ID` bigint(20) NOT NULL,
  `EXTENDED_DATE` date DEFAULT NULL,
  `EXTENDED_QTY` float(15,8) DEFAULT NULL,
  `DECISION_DATE` date DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `EXTENDED_BY_PIC` varchar(60) DEFAULT NULL,
  `APPROVE_BY_PIC` varchar(60) DEFAULT NULL,
  `LL_STOCK_ID` bigint(20) NOT NULL,
  UNIQUE KEY `XPKhr_ll_stock_extended` (`LL_STOCK_EXTENDED_ID`),
  KEY `hr_ll_taken_stock_id` (`LL_STOCK_ID`),
  CONSTRAINT `FK_hr_ll_stock_extended_ll_stock_id` FOREIGN KEY (`LL_STOCK_ID`) REFERENCES `hr_ll_stock_management` (`LL_STOCK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_management` */

DROP TABLE IF EXISTS `hr_ll_stock_management`;

CREATE TABLE `hr_ll_stock_management` (
  `LL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `OWNING_DATE` date DEFAULT NULL,
  `LL_QTY` float(15,8) NOT NULL DEFAULT 0.00000000,
  `QTY_USED` float(15,8) DEFAULT NULL,
  `QTY_RESIDUE` float(15,8) DEFAULT NULL,
  `LL_STATUS` tinyint(4) NOT NULL DEFAULT 0,
  `ENTITLED` float(15,8) NOT NULL DEFAULT 0.00000000,
  `NOTE` text DEFAULT NULL,
  `EXP_DATE` date DEFAULT NULL,
  `OPENING_LL` float(15,8) DEFAULT NULL,
  `RECORD_DATE` date DEFAULT NULL,
  `ENTITLE_DATE` date DEFAULT NULL,
  `PREV_BALANCE` float(15,8) DEFAULT NULL,
  `ENTITLE_2` float(15,8) DEFAULT NULL,
  `EXP_DATE_2` date DEFAULT NULL,
  `ENTITLE_DATE_2` date DEFAULT NULL,
  `RECORD_DATE_2` date DEFAULT NULL,
  PRIMARY KEY (`LL_STOCK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_report` */

DROP TABLE IF EXISTS `hr_ll_stock_report`;

CREATE TABLE `hr_ll_stock_report` (
  `LL_STOCK_REPORT_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIODE_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `QTY_ENT1` float(15,8) DEFAULT NULL,
  `QTY_ENT2` float(15,8) DEFAULT NULL,
  `QTY_ENT3` float(15,8) DEFAULT NULL,
  `QTY_ENT4` float(15,8) DEFAULT NULL,
  `QTY_ENT5` float(15,8) DEFAULT NULL,
  `QTY_ENT6` float(15,8) DEFAULT NULL,
  `QTY_ENT7` float(15,8) DEFAULT NULL,
  `QTY_ENT8` float(15,8) DEFAULT NULL,
  `QTY_ENT9` float(15,8) DEFAULT NULL,
  `QTY_ENT10` float(15,8) DEFAULT NULL,
  `QTY_TOTAL_LL` float(15,8) DEFAULT NULL,
  `QTY_TAKEN_MTD` float(15,8) DEFAULT NULL,
  `QTY_TAKEN_YTD` float(15,8) DEFAULT NULL,
  PRIMARY KEY (`LL_STOCK_REPORT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_taken` */

DROP TABLE IF EXISTS `hr_ll_stock_taken`;

CREATE TABLE `hr_ll_stock_taken` (
  `LL_STOCK_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LL_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAKEN_DATE` datetime NOT NULL,
  `TAKEN_QTY` float(15,8) NOT NULL DEFAULT 0.00000000,
  `PAID_DATE` date DEFAULT NULL,
  `TAKEN_FROM_STATUS` int(11) DEFAULT NULL,
  `LEAVE_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `TAKEN_FINNISH_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`LL_STOCK_TAKEN_ID`),
  KEY `idx_hr_ll_stock_taken_hr_leave_app_id` (`LEAVE_APPLICATION_ID`),
  KEY `hr_ll_stock_taken_ll_stock_id` (`LL_STOCK_ID`),
  CONSTRAINT `FK_hr_ll_stock_taken_app_id` FOREIGN KEY (`LEAVE_APPLICATION_ID`) REFERENCES `hr_leave_application` (`LEAVE_APPLICATION_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_hr_ll_stock_taken_ll_stock_id` FOREIGN KEY (`LL_STOCK_ID`) REFERENCES `hr_ll_stock_management` (`LL_STOCK_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_stock_temp` */

DROP TABLE IF EXISTS `hr_ll_stock_temp`;

CREATE TABLE `hr_ll_stock_temp` (
  `PAYROLL` char(20) NOT NULL DEFAULT '',
  `NAME` char(64) NOT NULL DEFAULT '',
  `COMM_DATE` date NOT NULL DEFAULT '0000-00-00',
  `ENTITLE1` float(15,8) NOT NULL DEFAULT 0.00000000,
  `ENTITLE2` float(15,8) NOT NULL DEFAULT 0.00000000,
  `ENTITLE3` float(15,8) NOT NULL DEFAULT 0.00000000,
  `TAKEN_MTD` float(15,8) NOT NULL DEFAULT 0.00000000,
  `TAKEN_YTD` float(15,8) NOT NULL DEFAULT 0.00000000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ll_upload` */

DROP TABLE IF EXISTS `hr_ll_upload`;

CREATE TABLE `hr_ll_upload` (
  `LL_UPLOAD_ID` bigint(20) NOT NULL DEFAULT 0,
  `OPNAME_DATE` date NOT NULL DEFAULT '0000-00-00',
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LL_TAKEN_YEAR1` float(15,8) DEFAULT NULL,
  `LL_TAKEN_YEAR2` float(15,8) DEFAULT NULL,
  `LL_TAKEN_YEAR3` float(15,8) DEFAULT NULL,
  `LL_TAKEN_YEAR4` float(15,8) DEFAULT NULL,
  `LL_TAKEN_YEAR5` float(15,8) DEFAULT NULL,
  `DATA_STATUS` int(11) NOT NULL DEFAULT 0,
  `STOCK` float(15,8) DEFAULT 0.00000000,
  `NEW_LL` float(15,8) DEFAULT NULL,
  `LAST_PER_TO_CLEAR_LL` float(15,8) DEFAULT NULL,
  `LL_STOCK_ID` bigint(20) DEFAULT NULL,
  `LL_QTY` float(15,8) DEFAULT NULL,
  `NEW_LL_2` float(15,8) DEFAULT NULL,
  PRIMARY KEY (`LL_UPLOAD_ID`),
  KEY `idx_hr_ll_upload_stock_id` (`LL_STOCK_ID`),
  CONSTRAINT `FK_hr_ll_upload_ll_stock_Man_id` FOREIGN KEY (`LL_STOCK_ID`) REFERENCES `hr_ll_stock_management` (`LL_STOCK_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_locker` */

DROP TABLE IF EXISTS `hr_locker`;

CREATE TABLE `hr_locker` (
  `LOCKER_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `LOCKER_NUMBER` varchar(20) DEFAULT NULL,
  `KEY_NUMBER` varchar(20) DEFAULT NULL,
  `CONDITION_ID` bigint(20) DEFAULT NULL,
  `spare_key` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`LOCKER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_locker_condition` */

DROP TABLE IF EXISTS `hr_locker_condition`;

CREATE TABLE `hr_locker_condition` (
  `CONDITION_ID` bigint(20) NOT NULL DEFAULT 0,
  `CONDITION_NAME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`CONDITION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_locker_location` */

DROP TABLE IF EXISTS `hr_locker_location`;

CREATE TABLE `hr_locker_location` (
  `LOCATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOCATION` varchar(50) DEFAULT NULL,
  `SEX` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`LOCATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_locker_treatment` */

DROP TABLE IF EXISTS `hr_locker_treatment`;

CREATE TABLE `hr_locker_treatment` (
  `TREATMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `TREATMENT_DATE` date DEFAULT NULL,
  `TREATMENT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TREATMENT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_machine_transaction` */

DROP TABLE IF EXISTS `hr_machine_transaction`;

CREATE TABLE `hr_machine_transaction` (
  `TRANSACTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `CARD_ID` varchar(30) NOT NULL DEFAULT '',
  `DATE_TRANSACTION` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `MODE` varchar(5) NOT NULL DEFAULT '',
  `STATION` varchar(30) NOT NULL DEFAULT '',
  `POSTED` int(11) NOT NULL DEFAULT 0,
  `VERIFY` int(2) DEFAULT 0,
  `NOTE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TRANSACTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_managing_position` */

DROP TABLE IF EXISTS `hr_managing_position`;

CREATE TABLE `hr_managing_position` (
  `MNG_POSITION_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `TOP_POSITION_ID` bigint(20) NOT NULL,
  `TYPE_OF_TOP_LINK` int(2) NOT NULL,
  PRIMARY KEY (`MNG_POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_manning_det_periodic` */

DROP TABLE IF EXISTS `hr_manning_det_periodic`;

CREATE TABLE `hr_manning_det_periodic` (
  `emp_payroll` varchar(50) DEFAULT '',
  `emp_name` varchar(50) DEFAULT '',
  `n1` int(11) DEFAULT 0,
  `n2` int(11) DEFAULT 0,
  `n3` int(11) DEFAULT 0,
  `n4` int(11) DEFAULT 0,
  `n5` int(11) DEFAULT 0,
  `n6` int(11) DEFAULT 0,
  `n7` int(11) DEFAULT 0,
  `n8` int(11) DEFAULT 0,
  `n9` int(11) DEFAULT 0,
  `n10` int(11) DEFAULT 0,
  `n11` int(11) DEFAULT 0,
  `n12` int(11) DEFAULT 0,
  `n13` int(11) DEFAULT 0,
  `n14` int(11) DEFAULT 0,
  `n15` int(11) DEFAULT 0,
  `n16` int(11) DEFAULT 0,
  `n17` int(11) DEFAULT 0,
  `n18` int(11) DEFAULT 0,
  `n19` int(11) DEFAULT 0,
  `n20` int(11) DEFAULT 0,
  `n21` int(11) DEFAULT 0,
  `n22` int(11) DEFAULT 0,
  `n23` int(11) DEFAULT 0,
  `n24` int(11) DEFAULT 0,
  `n25` int(11) DEFAULT 0,
  `n26` int(11) DEFAULT 0,
  `n27` int(11) DEFAULT 0,
  `n28` int(11) DEFAULT 0,
  `n29` int(11) DEFAULT 0,
  `n30` int(11) DEFAULT 0,
  `n31` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_manning_summ_periodic` */

DROP TABLE IF EXISTS `hr_manning_summ_periodic`;

CREATE TABLE `hr_manning_summ_periodic` (
  `section` varchar(50) DEFAULT '',
  `n1` int(11) DEFAULT 0,
  `n2` int(11) DEFAULT 0,
  `n3` int(11) DEFAULT 0,
  `n4` int(11) DEFAULT 0,
  `n5` int(11) DEFAULT 0,
  `n6` int(11) DEFAULT 0,
  `n7` int(11) DEFAULT 0,
  `n8` int(11) DEFAULT 0,
  `n9` int(11) DEFAULT 0,
  `n10` int(11) DEFAULT 0,
  `n11` int(11) DEFAULT 0,
  `n12` int(11) DEFAULT 0,
  `n13` int(11) DEFAULT 0,
  `n14` int(11) DEFAULT 0,
  `n15` int(11) DEFAULT 0,
  `n16` int(11) DEFAULT 0,
  `n17` int(11) DEFAULT 0,
  `n18` int(11) DEFAULT 0,
  `n19` int(11) DEFAULT 0,
  `n20` int(11) DEFAULT 0,
  `n21` int(11) DEFAULT 0,
  `n22` int(11) DEFAULT 0,
  `n23` int(11) DEFAULT 0,
  `n24` int(11) DEFAULT 0,
  `n25` int(11) DEFAULT 0,
  `n26` int(11) DEFAULT 0,
  `n27` int(11) DEFAULT 0,
  `n28` int(11) DEFAULT 0,
  `n29` int(11) DEFAULT 0,
  `n30` int(11) DEFAULT 0,
  `n31` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_mapping_kadiv_detail` */

DROP TABLE IF EXISTS `hr_mapping_kadiv_detail`;

CREATE TABLE `hr_mapping_kadiv_detail` (
  `MAPPING_KADIV_MAIN_ID` bigint(20) DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  KEY `FK_hr_mapping_kadiv_detail` (`MAPPING_KADIV_MAIN_ID`),
  CONSTRAINT `FK_hr_mapping_kadiv_detail` FOREIGN KEY (`MAPPING_KADIV_MAIN_ID`) REFERENCES `hr_mapping_kadiv_main` (`MAPPING_KADIV_MAIN_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_mapping_kadiv_main` */

DROP TABLE IF EXISTS `hr_mapping_kadiv_main`;

CREATE TABLE `hr_mapping_kadiv_main` (
  `MAPPING_KADIV_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`MAPPING_KADIV_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_mapping_position` */

DROP TABLE IF EXISTS `hr_mapping_position`;

CREATE TABLE `hr_mapping_position` (
  `MAPPING_POSITION_ID` bigint(20) NOT NULL,
  `UP_POSITION_ID` bigint(20) DEFAULT NULL,
  `DOWN_POSITION_ID` bigint(20) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `TYPE_OF_LINK` int(2) DEFAULT NULL,
  `TEMPLATE_ID` bigint(20) DEFAULT NULL,
  `VERTICAL_LINE` int(4) NOT NULL DEFAULT 0,
  `DIVISION_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`MAPPING_POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_marital` */

DROP TABLE IF EXISTS `hr_marital`;

CREATE TABLE `hr_marital` (
  `MARITAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `MARITAL_STATUS` varchar(200) DEFAULT NULL,
  `MARITAL_CODE` varchar(5) DEFAULT NULL,
  `NUM_OF_CHILDREN` int(11) DEFAULT NULL,
  `MARITAL_STATUS_TAX` int(1) DEFAULT 0,
  PRIMARY KEY (`MARITAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_master_notification` */

DROP TABLE IF EXISTS `hr_master_notification`;

CREATE TABLE `hr_master_notification` (
  `NOTIFICATION_ID` bigint(25) DEFAULT NULL,
  `NOTIFICATION_TYPE` int(2) DEFAULT NULL,
  `NOTIFICATION_DAYS` int(2) DEFAULT NULL,
  `NOTIFICATION_STATUS` int(2) DEFAULT NULL,
  `SPECIAL_CASE` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_master_notification_user_mapping` */

DROP TABLE IF EXISTS `hr_master_notification_user_mapping`;

CREATE TABLE `hr_master_notification_user_mapping` (
  `NOTIFICATION_MAPPING_ID` bigint(25) DEFAULT NULL,
  `NOTIFICATION_ID` bigint(25) DEFAULT NULL,
  `USER_ID` bigint(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_meal_time` */

DROP TABLE IF EXISTS `hr_meal_time`;

CREATE TABLE `hr_meal_time` (
  `MEAL_TIME_ID` bigint(20) NOT NULL DEFAULT 0,
  `MEAL_TIME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`MEAL_TIME_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_budget` */

DROP TABLE IF EXISTS `hr_medical_budget`;

CREATE TABLE `hr_medical_budget` (
  `MEDICAL_LEVEL_ID` bigint(20) DEFAULT NULL,
  `MEDICAL_CASE_ID` bigint(20) DEFAULT NULL,
  `BUDGET` decimal(16,2) DEFAULT NULL,
  `USE_PERIOD` int(11) DEFAULT NULL,
  `USE_PAX` int(11) DEFAULT NULL,
  UNIQUE KEY `XPKhr_medical_budget` (`MEDICAL_LEVEL_ID`,`MEDICAL_CASE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_case` */

DROP TABLE IF EXISTS `hr_medical_case`;

CREATE TABLE `hr_medical_case` (
  `MEDICAL_CASE_ID` bigint(20) DEFAULT NULL,
  `SORT_NUMBER` int(11) DEFAULT NULL,
  `CASE_GROUP` varchar(64) DEFAULT NULL,
  `CASE_NAME` varchar(64) DEFAULT NULL,
  `MAX_USE` int(11) DEFAULT NULL,
  `MAX_USE_PERIOD` int(11) DEFAULT NULL,
  `MIN_TAKEN_BY` int(11) DEFAULT NULL,
  `MIN_TAKEN_BY_PERIOD` int(11) DEFAULT NULL,
  `CASE_LINK` varchar(32) DEFAULT NULL,
  `FORMULA` varchar(128) DEFAULT NULL,
  UNIQUE KEY `XPKhr_medical_case` (`MEDICAL_CASE_ID`),
  KEY `UNQ_med_case_name` (`CASE_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_expense_type` */

DROP TABLE IF EXISTS `hr_medical_expense_type`;

CREATE TABLE `hr_medical_expense_type` (
  `MEDICINE_EXPENSE_TYPE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TYPE` varchar(64) DEFAULT NULL,
  `SHOW_STATUS` int(1) DEFAULT NULL,
  PRIMARY KEY (`MEDICINE_EXPENSE_TYPE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_level` */

DROP TABLE IF EXISTS `hr_medical_level`;

CREATE TABLE `hr_medical_level` (
  `MEDICAL_LEVEL_ID` bigint(20) DEFAULT NULL,
  `MEDICAL_LEVEL_NAME` varchar(20) DEFAULT NULL,
  `MEDICAL_LEVEL_CLASS` varchar(20) DEFAULT NULL,
  `SORT_NUMBER` int(11) DEFAULT NULL,
  UNIQUE KEY `XPKhr_medical_level` (`MEDICAL_LEVEL_ID`),
  UNIQUE KEY `UNQ_med_level_name` (`MEDICAL_LEVEL_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_record` */

DROP TABLE IF EXISTS `hr_medical_record`;

CREATE TABLE `hr_medical_record` (
  `DISCOUNT_IN_PERCENT` decimal(6,2) DEFAULT NULL,
  `MEDICAL_RECORD_ID` bigint(20) NOT NULL DEFAULT 0,
  `FAMILY_MEMBER_ID` bigint(20) DEFAULT NULL,
  `DISEASE_TYPE_ID` bigint(20) DEFAULT NULL,
  `MEDICAL_TYPE_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `RECORD_DATE` date DEFAULT NULL,
  `AMOUNT` decimal(20,2) NOT NULL DEFAULT 0.00,
  `DISCOUNT_IN_RP` decimal(20,2) DEFAULT NULL,
  `TOTAL` decimal(30,2) NOT NULL,
  `MEDICAL_CASE_ID` bigint(20) DEFAULT NULL,
  `CASE_QUANTITY` decimal(10,2) NOT NULL DEFAULT 1.00,
  PRIMARY KEY (`MEDICAL_RECORD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medical_type` */

DROP TABLE IF EXISTS `hr_medical_type`;

CREATE TABLE `hr_medical_type` (
  `MEDICAL_TYPE_ID` bigint(20) NOT NULL DEFAULT 0,
  `MED_EXPENSE_TYPE_ID` bigint(20) DEFAULT NULL,
  `TYPE_CODE` varchar(20) DEFAULT NULL,
  `TYPE_NAME` varchar(50) DEFAULT NULL,
  `YEARLY_AMOUNT` decimal(20,2) DEFAULT 0.00,
  PRIMARY KEY (`MEDICAL_TYPE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medicine` */

DROP TABLE IF EXISTS `hr_medicine`;

CREATE TABLE `hr_medicine` (
  `MEDICINE_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(64) DEFAULT NULL,
  `UNIT_PRICE` decimal(20,2) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`MEDICINE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_medicine_consumption` */

DROP TABLE IF EXISTS `hr_medicine_consumption`;

CREATE TABLE `hr_medicine_consumption` (
  `MEDICINE_CONSUMPTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `MEDICINE_ID` bigint(20) DEFAULT NULL,
  `MONTH` date DEFAULT NULL,
  `LAST_MONTH` int(11) DEFAULT NULL,
  `PURCHASE_THIS_MONTH` int(11) DEFAULT NULL,
  `STOCK_THIS_MONTH` int(11) DEFAULT NULL,
  `CONSUMP_THIS_MONTH` int(11) DEFAULT NULL,
  `TOTAL_CONSUMP` decimal(40,2) DEFAULT NULL,
  `CLOSE_INVENTORY` int(11) DEFAULT NULL,
  `CLOSE_AMOUNT` decimal(40,2) DEFAULT NULL,
  PRIMARY KEY (`MEDICINE_CONSUMPTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_menu_item` */

DROP TABLE IF EXISTS `hr_menu_item`;

CREATE TABLE `hr_menu_item` (
  `MENU_ITEM_ID` bigint(20) NOT NULL DEFAULT 0,
  `ITEM_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`MENU_ITEM_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_menu_list` */

DROP TABLE IF EXISTS `hr_menu_list`;

CREATE TABLE `hr_menu_list` (
  `MENU_LIST_ID` bigint(20) NOT NULL DEFAULT 0,
  `MENU_ITEM_ID` bigint(20) DEFAULT NULL,
  `MENU_DATE` date DEFAULT NULL,
  `MENU_TIME` int(11) DEFAULT NULL,
  PRIMARY KEY (`MENU_LIST_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_message_emp` */

DROP TABLE IF EXISTS `hr_message_emp`;

CREATE TABLE `hr_message_emp` (
  `message_emp_id` bigint(20) NOT NULL,
  `message` text DEFAULT NULL,
  `message_date` date DEFAULT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `leave_application_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`message_emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_message_log` */

DROP TABLE IF EXISTS `hr_message_log`;

CREATE TABLE `hr_message_log` (
  `MESSAGE_LOG_ID` bigint(20) NOT NULL,
  `ENTITY_NAME` varchar(128) NOT NULL,
  `ENTITY_ID` bigint(20) NOT NULL,
  `USER_ID` bigint(20) NOT NULL,
  `LOG_ID` bigint(20) NOT NULL,
  `STATUS_LOG` int(2) NOT NULL,
  PRIMARY KEY (`MESSAGE_LOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_nationality` */

DROP TABLE IF EXISTS `hr_nationality`;

CREATE TABLE `hr_nationality` (
  `NATIONALITY_ID` bigint(20) NOT NULL,
  `NATIONALITY_CODE` varchar(10) NOT NULL,
  `NATIONALITY_NAME` varchar(50) DEFAULT NULL,
  `NATIONALITY_TYPE` int(5) DEFAULT NULL,
  PRIMARY KEY (`NATIONALITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_negara` */

DROP TABLE IF EXISTS `hr_negara`;

CREATE TABLE `hr_negara` (
  `ID_NEGARA` bigint(20) NOT NULL,
  `BENUA` varchar(32) DEFAULT NULL,
  `NAMA_NGR` varchar(64) NOT NULL,
  PRIMARY KEY (`ID_NEGARA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_notification_mapping_division` */

DROP TABLE IF EXISTS `hr_notification_mapping_division`;

CREATE TABLE `hr_notification_mapping_division` (
  `NOTIFICATION_MAPPING_DIVISION_ID` bigint(25) NOT NULL,
  `NOTIFICATION_ID` bigint(25) DEFAULT NULL,
  `DIVISION_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`NOTIFICATION_MAPPING_DIVISION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_org_map_department` */

DROP TABLE IF EXISTS `hr_org_map_department`;

CREATE TABLE `hr_org_map_department` (
  `ORG_MAP_DEPT_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `TEMPLATE_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`ORG_MAP_DEPT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_org_map_division` */

DROP TABLE IF EXISTS `hr_org_map_division`;

CREATE TABLE `hr_org_map_division` (
  `ORG_MAP_DIV_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `TEMPLATE_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`ORG_MAP_DIV_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_org_map_section` */

DROP TABLE IF EXISTS `hr_org_map_section`;

CREATE TABLE `hr_org_map_section` (
  `ORG_MAP_SECT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `TEMPLATE_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`ORG_MAP_SECT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ori_activity` */

DROP TABLE IF EXISTS `hr_ori_activity`;

CREATE TABLE `hr_ori_activity` (
  `ORI_ACTIVITY_ID` bigint(20) NOT NULL DEFAULT 0,
  `ORI_GROUP_ID` bigint(20) DEFAULT NULL,
  `ACTIVITY` text DEFAULT NULL,
  PRIMARY KEY (`ORI_ACTIVITY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ori_checklist` */

DROP TABLE IF EXISTS `hr_ori_checklist`;

CREATE TABLE `hr_ori_checklist` (
  `ORI_CHECKLIST_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `INTERVIEWER_ID` bigint(20) DEFAULT NULL,
  `SIGNATURE_DATE` date DEFAULT NULL,
  `INTERVIEW_DATE` date DEFAULT NULL,
  `SKILLS` text DEFAULT NULL,
  PRIMARY KEY (`ORI_CHECKLIST_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ori_checklist_activity` */

DROP TABLE IF EXISTS `hr_ori_checklist_activity`;

CREATE TABLE `hr_ori_checklist_activity` (
  `ORI_CHECKLIST_ACTIVITY_ID` bigint(20) NOT NULL DEFAULT 0,
  `ORI_CHECKLIST_ID` bigint(20) DEFAULT NULL,
  `ORI_ACTIVITY_ID` bigint(20) DEFAULT NULL,
  `DONE` tinyint(2) DEFAULT NULL,
  `ACTIVITY_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ORI_CHECKLIST_ACTIVITY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_ori_group` */

DROP TABLE IF EXISTS `hr_ori_group`;

CREATE TABLE `hr_ori_group` (
  `ORI_GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ORI_GROUP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_outsource_cost` */

DROP TABLE IF EXISTS `hr_outsource_cost`;

CREATE TABLE `hr_outsource_cost` (
  `OUTSOURCE_COST_ID` bigint(20) NOT NULL,
  `TITLE` varchar(128) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `CREATED_BY_ID` bigint(20) NOT NULL,
  `APPROVED_DATE` datetime DEFAULT NULL,
  `APPROVED_BY_ID` bigint(20) DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `STATUS_DOC` int(11) DEFAULT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `DATE_OF_PAYMENT` date DEFAULT NULL,
  `PERIOD_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`OUTSOURCE_COST_ID`),
  KEY `fk_hr_outsource_plan_pay_general1_idx` (`COMPANY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee1_idx` (`CREATED_BY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee2_idx` (`APPROVED_BY_ID`),
  KEY `fk_hr_outsource_eval_hr_division1_idx` (`DIVISION_ID`),
  KEY `fk_hr_outsource_eval_hr_department1_idx` (`DEPARTMENT_ID`),
  KEY `fk_hr_outsource_eval_hr_section1_idx` (`SECTION_ID`),
  KEY `fk_hr_outsource_cost_pay_period1_idx` (`PERIOD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsource_eval` */

DROP TABLE IF EXISTS `hr_outsource_eval`;

CREATE TABLE `hr_outsource_eval` (
  `OUTSOURCE_EVAL_ID` bigint(20) NOT NULL,
  `TITLE` varchar(128) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `CREATED_BY_ID` bigint(20) NOT NULL,
  `APPROVED_BY_DATE` datetime DEFAULT NULL,
  `APPROVED_BY_ID` bigint(20) DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `STATUS_DOC` int(11) DEFAULT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `DATE_OF_EVAL` date DEFAULT NULL,
  `PERIOD_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`OUTSOURCE_EVAL_ID`),
  KEY `fk_hr_outsource_plan_pay_general1_idx` (`COMPANY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee1_idx` (`CREATED_BY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee2_idx` (`APPROVED_BY_ID`),
  KEY `fk_hr_outsource_eval_hr_division1_idx` (`DIVISION_ID`),
  KEY `fk_hr_outsource_eval_hr_department1_idx` (`DEPARTMENT_ID`),
  KEY `fk_hr_outsource_eval_hr_section1_idx` (`SECTION_ID`),
  KEY `fk_hr_outsource_eval_hr_period1_idx` (`PERIOD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsource_plan` */

DROP TABLE IF EXISTS `hr_outsource_plan`;

CREATE TABLE `hr_outsource_plan` (
  `OUTSOURCE_PLAN_ID` bigint(20) NOT NULL,
  `PLAN_YEAR` int(11) NOT NULL,
  `TITLE` varchar(45) DEFAULT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `CREATED_BY_ID` bigint(20) NOT NULL,
  `APPROVED_DATE` datetime DEFAULT NULL,
  `APPROVED_BY_ID` bigint(20) DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `STATUS_DOC` int(11) DEFAULT NULL,
  `VALID_FROM` date DEFAULT NULL,
  `VALID_TO` date DEFAULT NULL,
  PRIMARY KEY (`OUTSOURCE_PLAN_ID`),
  KEY `fk_hr_outsource_plan_pay_general1_idx` (`COMPANY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee1_idx` (`CREATED_BY_ID`),
  KEY `fk_hr_outsource_plan_hr_employee2_idx` (`APPROVED_BY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsource_plan_detail` */

DROP TABLE IF EXISTS `hr_outsource_plan_detail`;

CREATE TABLE `hr_outsource_plan_detail` (
  `OUTSRC_PLAN_DETAIL_ID` bigint(20) NOT NULL,
  `OUTSOURCE_PLAN_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `COST_PER_PERSON` double DEFAULT NULL,
  `GENERAL_INFO` varchar(512) DEFAULT NULL,
  `TYPE_OF_CONTRACT` varchar(256) DEFAULT NULL,
  `CONTRACT_PERIOD` float DEFAULT NULL,
  `OBJECTIVES` varchar(512) DEFAULT NULL,
  `COST_N_BENEFIT_ANLYSIS` text DEFAULT NULL,
  `COST_TOTAL` double DEFAULT NULL,
  `RISK_ANALISYS` text DEFAULT NULL,
  `DESCRIPTION` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`OUTSRC_PLAN_DETAIL_ID`),
  KEY `fk_hr_outsource_plan_map_hr_outsource_plan1_idx` (`OUTSOURCE_PLAN_ID`),
  KEY `fk_hr_outsource_plan_detail_hr_position1_idx` (`POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_cost_master` */

DROP TABLE IF EXISTS `hr_outsrc_cost_master`;

CREATE TABLE `hr_outsrc_cost_master` (
  `OUTSRC_COST_ID` bigint(20) NOT NULL,
  `SHOW_INDEX` int(11) NOT NULL,
  `COST_CODE` varchar(45) NOT NULL,
  `COST_NAME` varchar(45) NOT NULL,
  `TYPE` int(11) NOT NULL COMMENT '0= show on plan an input cost\n1= show only on input cost not show on cost\n',
  `NOTE` varchar(255) DEFAULT NULL,
  `PARENT_OUTSRC_COST_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`OUTSRC_COST_ID`,`PARENT_OUTSRC_COST_ID`),
  KEY `fk_hr_outsrc_cost_master_hr_outsrc_cost_master1_idx` (`PARENT_OUTSRC_COST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_cost_prov` */

DROP TABLE IF EXISTS `hr_outsrc_cost_prov`;

CREATE TABLE `hr_outsrc_cost_prov` (
  `OUTSRC_COST_PROVIDER_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `PROVIDER_ID` bigint(20) NOT NULL,
  `NUMBER_OF_PERSON` int(11) DEFAULT NULL,
  `OUTSOURCE_COST_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`OUTSRC_COST_PROVIDER_ID`),
  KEY `fk_hr_outsrc_plan_provider_hr_position1_idx` (`POSITION_ID`),
  KEY `fk_hr_outsrc_plan_provider_contact_list1_idx` (`PROVIDER_ID`),
  KEY `fk_hr_outsrc_eval_provider_copy1_hr_outsource_cost1_idx` (`OUTSOURCE_COST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_cost_prov_detail` */

DROP TABLE IF EXISTS `hr_outsrc_cost_prov_detail`;

CREATE TABLE `hr_outsrc_cost_prov_detail` (
  `OUTSRC_COST_PROV_DETLD_ID` bigint(20) NOT NULL,
  `OUTSRC_COST_PROVIDER_ID` bigint(20) NOT NULL,
  `OUTSRC_COST_ID` bigint(20) NOT NULL,
  `COST_VAL` double DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`OUTSRC_COST_PROV_DETLD_ID`),
  KEY `fk_hr_outsrc_cost_prov_detail_hr_outsrc_cost_prov1_idx` (`OUTSRC_COST_PROVIDER_ID`),
  KEY `fk_hr_outsrc_cost_prov_detail_hr_outsrc_cost1_idx` (`OUTSRC_COST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_eval_provider` */

DROP TABLE IF EXISTS `hr_outsrc_eval_provider`;

CREATE TABLE `hr_outsrc_eval_provider` (
  `OUTSOURCE_EVAL_ID` bigint(20) NOT NULL,
  `OUTSRC_EVAL_PROVIDER_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `PROVIDER_ID` bigint(20) NOT NULL,
  `NUMBER_OF_PERSON` int(11) DEFAULT NULL,
  `EVAL_POINT` int(11) DEFAULT NULL,
  `JUSTIFICATION` varchar(512) DEFAULT NULL,
  `SUGGESTION` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`OUTSRC_EVAL_PROVIDER_ID`),
  KEY `fk_hr_outsrc_plan_provider_hr_position1_idx` (`POSITION_ID`),
  KEY `fk_hr_outsrc_plan_provider_contact_list1_idx` (`PROVIDER_ID`),
  KEY `fk_hr_outsrc_eval_provider_hr_outsource_eval1_idx` (`OUTSOURCE_EVAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_plan_cost` */

DROP TABLE IF EXISTS `hr_outsrc_plan_cost`;

CREATE TABLE `hr_outsrc_plan_cost` (
  `OUTSRC_PLAN_COST_ID` bigint(20) NOT NULL,
  `OUTSRC_PLAN_LOC_ID` bigint(20) NOT NULL,
  `OUTSRC_COST_ID` bigint(20) NOT NULL,
  `INCRS_TO_PREV_YEAR` float NOT NULL,
  `PLAN_AVRG_COST` float NOT NULL,
  PRIMARY KEY (`OUTSRC_PLAN_COST_ID`),
  KEY `fk_hr_outsrc_plan_cost_hr_outsrc_plan_loc1_idx` (`OUTSRC_PLAN_LOC_ID`),
  KEY `fk_hr_outsrc_plan_cost_hr_outsrc_cost1_idx` (`OUTSRC_COST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_outsrc_plan_loc` */

DROP TABLE IF EXISTS `hr_outsrc_plan_loc`;

CREATE TABLE `hr_outsrc_plan_loc` (
  `OUTSRC_PLAN_LOC_ID` bigint(20) NOT NULL,
  `OUTSOURCE_PLAN_ID` bigint(20) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `PREV_EXISTING` int(11) DEFAULT NULL,
  `NUMBER_TW1` int(11) NOT NULL,
  `NUMBER_TW2` int(11) NOT NULL,
  `NUMBER_TW3` int(11) NOT NULL,
  `NUMBER_TW4` int(11) NOT NULL,
  PRIMARY KEY (`OUTSRC_PLAN_LOC_ID`),
  KEY `fk_hr_outsrc_plan_loc_hr_outsource_plan1_idx` (`OUTSOURCE_PLAN_ID`),
  KEY `fk_hr_outsrc_plan_loc_pay_general1_idx` (`COMPANY_ID`),
  KEY `fk_hr_outsrc_plan_loc_hr_division1_idx` (`DIVISION_ID`),
  KEY `fk_hr_outsrc_plan_loc_hr_department1_idx` (`DEPARTMENT_ID`),
  KEY `fk_hr_outsrc_plan_loc_hr_section1_idx` (`SECTION_ID`),
  KEY `fk_hr_outsrc_plan_loc_hr_position1_idx` (`POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_overtime` */

DROP TABLE IF EXISTS `hr_overtime`;

CREATE TABLE `hr_overtime` (
  `OVERTIME_ID` bigint(20) NOT NULL,
  `REQ_DATE` datetime NOT NULL,
  `OV_NUMBER` varchar(64) NOT NULL,
  `OBJECTIVE` varchar(255) NOT NULL,
  `STATUS_DOC` int(8) NOT NULL,
  `CUSTOMER_TASK_ID` bigint(20) DEFAULT NULL,
  `LOGBOOK_ID` bigint(20) DEFAULT NULL,
  `REQ_ID` bigint(20) NOT NULL,
  `APPROVAL_ID` bigint(20) DEFAULT NULL,
  `ACK_ID` bigint(20) DEFAULT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `COUNT_IDX` int(12) unsigned NOT NULL AUTO_INCREMENT,
  `COST_DEP_ID` bigint(20) DEFAULT 0,
  `ALLOWANCE` int(12) DEFAULT 0,
  `TIME_REQ` datetime DEFAULT NULL,
  `TIME_APPROVAL` datetime DEFAULT NULL,
  `TIME_ACK` datetime DEFAULT NULL,
  `APPROVAL_1_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_1` datetime DEFAULT NULL,
  `APPROVAL_2_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_2` datetime DEFAULT NULL,
  `APPROVAL_3_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_3` datetime DEFAULT NULL,
  `APPROVAL_4_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_4` datetime DEFAULT NULL,
  `APPROVAL_5_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_5` datetime DEFAULT NULL,
  `APPROVAL_6_ID` bigint(20) DEFAULT NULL,
  `TIME_APPROVAL_6` datetime DEFAULT NULL,
  `OVERTIME_TYPE` int(2) DEFAULT NULL,
  PRIMARY KEY (`OVERTIME_ID`),
  UNIQUE KEY `COUNT_IDX` (`COUNT_IDX`),
  UNIQUE KEY `unq_ov_number` (`OV_NUMBER`)
) ENGINE=MyISAM AUTO_INCREMENT=54084 DEFAULT CHARSET=latin1;

/*Table structure for table `hr_overtime_detail` */

DROP TABLE IF EXISTS `hr_overtime_detail`;

CREATE TABLE `hr_overtime_detail` (
  `OVERTIME_DETAIL_ID` bigint(20) NOT NULL,
  `OVERTIME_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL,
  `JOBDESK` varchar(255) DEFAULT NULL,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `STATUS` int(8) NOT NULL,
  `PAID_BY` int(2) NOT NULL DEFAULT 0,
  `REAL_DATE_FROM` datetime DEFAULT NULL,
  `REAL_DATE_TO` datetime DEFAULT NULL,
  `PERIOD_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_NR_OVTM` varchar(32) DEFAULT NULL,
  `STD_WORK_SCHDL` varchar(20) DEFAULT NULL,
  `OVT_DURATION` double DEFAULT NULL,
  `OVT_DOC_NR` varchar(20) DEFAULT NULL,
  `PAY_SLIP_ID` bigint(20) DEFAULT NULL,
  `TOT_IDX` double DEFAULT NULL,
  `OVT_CODE` varchar(20) DEFAULT NULL,
  `ALLOWANCE` int(2) DEFAULT 0,
  `REST_TIME_HR` double DEFAULT NULL,
  `REST_TIME_START` datetime DEFAULT NULL,
  `dummy_date` datetime DEFAULT NULL,
  `FLAG_STATUS` int(2) DEFAULT 0 COMMENT 'memberikan suatu flag ,sistem apakah akan mengeset  Manual atau otomatis untuk start real OT dan end OT,0 = Automatis, 1=Manual',
  `LOCATION_ID` bigint(20) DEFAULT 0,
  `NORMAL_OVERTIME` int(2) DEFAULT NULL,
  `LATE_APPROVAL` int(2) DEFAULT NULL,
  `UPLOAD_FILE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`OVERTIME_DETAIL_ID`),
  UNIQUE KEY `UNQ_OV_DETAIL` (`OVERTIME_ID`,`EMPLOYEE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_pay_day` */

DROP TABLE IF EXISTS `hr_pay_day`;

CREATE TABLE `hr_pay_day` (
  `PAY_DAY_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT 0,
  `POSITION_ID` bigint(20) DEFAULT 0,
  `VALUE_PAY_DAY` double DEFAULT NULL,
  PRIMARY KEY (`PAY_DAY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_performance_evaluation` */

DROP TABLE IF EXISTS `hr_performance_evaluation`;

CREATE TABLE `hr_performance_evaluation` (
  `PERFORMANCE_APPRAISAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_APPRAISAL` bigint(20) DEFAULT NULL,
  `EVALUATION_ID` bigint(20) DEFAULT NULL,
  `CATEGORY_CRITERIA_ID` bigint(20) DEFAULT NULL,
  `JUSTIFICATION` text DEFAULT NULL,
  `EMP_COMMENT` text DEFAULT NULL,
  PRIMARY KEY (`PERFORMANCE_APPRAISAL_ID`),
  UNIQUE KEY `XPKHR_PERFORMANCE_APPRAISAL` (`PERFORMANCE_APPRAISAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_period` */

DROP TABLE IF EXISTS `hr_period`;

CREATE TABLE `hr_period` (
  `PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD` varchar(64) NOT NULL DEFAULT '',
  `START_DATE` date NOT NULL,
  `END_DATE` date NOT NULL,
  `WORK_DAYS` int(11) DEFAULT 25,
  `PAY_SLIP_DATE` date DEFAULT NULL,
  `MIN_REG_WAGE` double DEFAULT 0,
  `PAY_PROCESS` tinyint(4) DEFAULT 0,
  `PAY_PROC_BY` varchar(20) DEFAULT '0',
  `PAY_PROC_DATE` date DEFAULT NULL,
  `PAY_PROCESS_CLOSE` tinyint(4) DEFAULT 0,
  `PAY_PROC_BY_CLOSE` varchar(20) DEFAULT '-',
  `PAY_PROC_DATE_CLOSE` date DEFAULT NULL,
  `TAX_IS_PAID` int(4) DEFAULT 0,
  PRIMARY KEY (`PERIOD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_period_stock_opname` */

DROP TABLE IF EXISTS `hr_period_stock_opname`;

CREATE TABLE `hr_period_stock_opname` (
  `PERIOD_OPNAME_ID` bigint(20) NOT NULL,
  `NAME_PERIOD` varchar(30) DEFAULT NULL,
  `DATE_FROM` date DEFAULT NULL,
  `DATE_TO` date DEFAULT NULL,
  PRIMARY KEY (`PERIOD_OPNAME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_point_of_reprimand` */

DROP TABLE IF EXISTS `hr_point_of_reprimand`;

CREATE TABLE `hr_point_of_reprimand` (
  `REPRIMAND_ID` bigint(20) NOT NULL,
  `REPRIMAND_DESC` varchar(50) NOT NULL,
  `REPRIMAND_POINT` int(11) NOT NULL,
  `VALID_UNTIL` int(3) DEFAULT 0,
  `SATUAN_VALID_UNTIL` int(1) DEFAULT 0,
  `SHOW_IN_CV` int(1) DEFAULT 0,
  PRIMARY KEY (`REPRIMAND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_point_of_warning` */

DROP TABLE IF EXISTS `hr_point_of_warning`;

CREATE TABLE `hr_point_of_warning` (
  `WARN_ID` bigint(20) NOT NULL,
  `WARN_DESC` varchar(50) NOT NULL,
  `WARN_POINT` int(11) NOT NULL,
  `VALID_UNTIL` int(3) DEFAULT 0,
  `SATUAN_VALIL_UNTIL` int(1) DEFAULT 0,
  PRIMARY KEY (`WARN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_pos_assessment_req` */

DROP TABLE IF EXISTS `hr_pos_assessment_req`;

CREATE TABLE `hr_pos_assessment_req` (
  `POS_ASS_REQ_ID` bigint(25) NOT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  `ASSESSMENT_ID` bigint(25) DEFAULT NULL,
  `SCORE_REQ_MIN` double DEFAULT NULL,
  `SCORE_REQ_RECOMMENDED` double DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `RE_TRAIN_OR_SERTFC_REQ` int(2) DEFAULT NULL,
  `VALID_START` date DEFAULT NULL,
  `VALID_END` date DEFAULT NULL,
  PRIMARY KEY (`POS_ASS_REQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_pos_competency_req` */

DROP TABLE IF EXISTS `hr_pos_competency_req`;

CREATE TABLE `hr_pos_competency_req` (
  `POS_COMP_REQ_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `SCORE_REQ_MIN` double(4,0) DEFAULT NULL,
  `SCORE_REQ_RECOMMENDED` double(4,0) DEFAULT NULL,
  `COMPETENCY_LEVEL_ID_MIN` bigint(20) DEFAULT NULL,
  `COMPETENCY_LEVEL_ID_RECOMMENDED` bigint(20) DEFAULT NULL,
  `COMPETENCY_LEVEL_ID` bigint(20) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `RE_TRAIN_OR_SERTFC_REQ` int(4) NOT NULL,
  `VALID_START` date NOT NULL,
  `VALID_END` date NOT NULL,
  `LEVEL_DIVISION` int(2) DEFAULT 0,
  `LEVEL_DEPARTMENT` int(2) DEFAULT 0,
  `LEVEL_SECTION` int(2) DEFAULT 0,
  PRIMARY KEY (`POS_COMP_REQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_pos_education_req` */

DROP TABLE IF EXISTS `hr_pos_education_req`;

CREATE TABLE `hr_pos_education_req` (
  `POS_EDUCATION_REQ_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `DURATION_MIN` int(2) DEFAULT NULL,
  `DURATION_RECOMMENDED` int(2) DEFAULT NULL,
  `POINT_MIN` int(4) DEFAULT NULL,
  `POINT_RECOMMENDED` int(4) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  PRIMARY KEY (`POS_EDUCATION_REQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_pos_experience_req` */

DROP TABLE IF EXISTS `hr_pos_experience_req`;

CREATE TABLE `hr_pos_experience_req` (
  `POS_EXPERIENCE_REQ_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EXPERIENCE_ID` bigint(20) DEFAULT NULL,
  `DURATION_MIN` int(2) DEFAULT NULL,
  `DURATION_RECOMMENDED` int(2) DEFAULT NULL,
  `NOTE` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_pos_grade_req` */

DROP TABLE IF EXISTS `hr_pos_grade_req`;

CREATE TABLE `hr_pos_grade_req` (
  `POS_GRADE_REQ_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `MAX_GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `MIN_GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `NOTE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`POS_GRADE_REQ_ID`),
  KEY `fk_hr_pos_grade_req_hr_grade_level1_idx` (`MIN_GRADE_LEVEL_ID`),
  KEY `fk_hr_pos_grade_req_hr_grade_level2_idx` (`MAX_GRADE_LEVEL_ID`),
  KEY `fk_hr_pos_grade_req_hr_position1_idx` (`POSITION_ID`),
  CONSTRAINT `fk_hr_pos_grade_req_hr_grade_level1` FOREIGN KEY (`MIN_GRADE_LEVEL_ID`) REFERENCES `hr_grade_level` (`GRADE_LEVEL_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hr_pos_grade_req_hr_grade_level2` FOREIGN KEY (`MAX_GRADE_LEVEL_ID`) REFERENCES `hr_grade_level` (`GRADE_LEVEL_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hr_pos_grade_req_hr_position1` FOREIGN KEY (`POSITION_ID`) REFERENCES `hr_position` (`POSITION_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_pos_training_req` */

DROP TABLE IF EXISTS `hr_pos_training_req`;

CREATE TABLE `hr_pos_training_req` (
  `POS_TRAINING_REQ_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `DURATION_MIN` int(2) DEFAULT NULL,
  `DURATION_RECOMMENDED` int(2) DEFAULT NULL,
  `POINT_MIN` int(4) DEFAULT NULL,
  `POINT_RECOMMENDED` int(4) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  PRIMARY KEY (`POS_TRAINING_REQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position` */

DROP TABLE IF EXISTS `hr_position`;

CREATE TABLE `hr_position` (
  `POSITION_ID` bigint(20) NOT NULL DEFAULT 0,
  `POSITION` varchar(124) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `POSITION_LEVEL` int(11) DEFAULT NULL,
  `DISABLED_APP_UNDER_SUPERVISOR` int(11) DEFAULT NULL,
  `DISABLED_APP_DEPT_SCOPE` int(11) DEFAULT NULL,
  `DISABLED_APP_DIV_SCOPE` int(11) DEFAULT NULL,
  `ALL_DEPARTMENT` int(11) DEFAULT NULL,
  `DEDLINE_SCH_BEFORE` int(11) DEFAULT NULL,
  `DEDLINE_SCH_AFTER` int(11) DEFAULT NULL,
  `DEDLINE_SCH_LEAVE_BEFORE` int(11) DEFAULT NULL,
  `DEDLINE_SCH_LEAVE_AFTER` int(11) DEFAULT NULL,
  `HEAD_TITLE` int(11) NOT NULL DEFAULT 0,
  `POSITION_LEVEL_PAYROL` int(11) DEFAULT 0,
  `POSITION_KODE` text DEFAULT NULL,
  `FLAG_POSITION_SHOW_IN_PAYROLL_INPUT` int(2) DEFAULT 0 COMMENT 'memunculkan position yg diinginkan muncul di pay input',
  `AGE_MIN` int(3) DEFAULT NULL,
  `AGE_RECOMMENDED` int(3) DEFAULT NULL,
  `AGE_MAX` int(3) DEFAULT NULL,
  `LENGTH_OF_SERVICE_MIN` int(2) DEFAULT NULL,
  `LENGTH_OF_SERVICE_RECOMMENDED` int(2) DEFAULT NULL,
  `LENGTH_OF_EXPERIENCE_MIN` int(2) DEFAULT NULL,
  `LENGTH_OF_EXPERIENCE_RECOMMENDED` int(2) DEFAULT NULL,
  `VALID_STATUS` int(2) NOT NULL,
  `VALID_START` date DEFAULT NULL,
  `VALID_END` date DEFAULT NULL,
  `LEVEL_ID` bigint(20) NOT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `POSITION_GROUP_ID` bigint(20) DEFAULT NULL,
  `TENAGA_KERJA` int(2) DEFAULT NULL,
  `JENIS_JABATAN` int(2) DEFAULT NULL,
  `ALIAS` varchar(124) DEFAULT NULL,
  `POSITION_TYPE_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`POSITION_ID`),
  KEY `POSITION_TYPE` (`POSITION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_candidate` */

DROP TABLE IF EXISTS `hr_position_candidate`;

CREATE TABLE `hr_position_candidate` (
  `POS_CANDIDATE_ID` bigint(20) NOT NULL,
  `CANDIDATE_TYPE` int(1) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `TITLE` varchar(256) DEFAULT NULL,
  `OBJECTIVES` text DEFAULT NULL,
  `NUM_CANDIDATES` int(8) DEFAULT NULL,
  `DUE_DATE` date DEFAULT NULL,
  `REQUEST_BY` bigint(20) DEFAULT NULL,
  `DOC_STATUS` int(1) DEFAULT NULL,
  `COMPANY` text DEFAULT NULL,
  `DIVISION` text DEFAULT NULL,
  `DEPARTMENT` text DEFAULT NULL,
  `SECTION` text DEFAULT NULL,
  `SEARCH_DATE` date DEFAULT NULL,
  PRIMARY KEY (`POS_CANDIDATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_candidate_emp` */

DROP TABLE IF EXISTS `hr_position_candidate_emp`;

CREATE TABLE `hr_position_candidate_emp` (
  `POS_CANDIDATE_EMP_ID` bigint(20) NOT NULL,
  `POS_CANDIDATE_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `RANK` int(8) DEFAULT NULL,
  `SCORE` float(4,0) DEFAULT NULL,
  `SCORE_NEED` float(4,0) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `CANDIDATE_STATUS` int(1) DEFAULT NULL,
  PRIMARY KEY (`POS_CANDIDATE_EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_candidate_location` */

DROP TABLE IF EXISTS `hr_position_candidate_location`;

CREATE TABLE `hr_position_candidate_location` (
  `POS_CANDIDATE_LOCATION_ID` bigint(20) NOT NULL,
  `POS_CANDIDATE_ID` bigint(20) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `NUMBER_NEEDED` int(8) DEFAULT NULL,
  `DUE_DATE` date DEFAULT NULL,
  PRIMARY KEY (`POS_CANDIDATE_LOCATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_company` */

DROP TABLE IF EXISTS `hr_position_company`;

CREATE TABLE `hr_position_company` (
  `POSITION_COMPANY_ID` bigint(20) NOT NULL,
  `COMPANY_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`POSITION_COMPANY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_department` */

DROP TABLE IF EXISTS `hr_position_department`;

CREATE TABLE `hr_position_department` (
  `POSITION_DEPARTMENT_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`POSITION_DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_division` */

DROP TABLE IF EXISTS `hr_position_division`;

CREATE TABLE `hr_position_division` (
  `POSITION_DIVISION_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`POSITION_DIVISION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_group` */

DROP TABLE IF EXISTS `hr_position_group`;

CREATE TABLE `hr_position_group` (
  `POSITION_GROUP_ID` bigint(20) NOT NULL,
  `POSITION_GROUP_NAME` varchar(45) NOT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`POSITION_GROUP_ID`),
  UNIQUE KEY `POSITION_GROUP_NAME_UNIQUE` (`POSITION_GROUP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_kpi` */

DROP TABLE IF EXISTS `hr_position_kpi`;

CREATE TABLE `hr_position_kpi` (
  `POS_KPI_ID` bigint(20) NOT NULL,
  `KPI_MIN_ACHIEVMENT` decimal(10,4) NOT NULL COMMENT 'in %',
  `KPI_RECOMMEND_ACHIEV` decimal(10,4) NOT NULL COMMENT 'in %\n',
  `DURATION_MONTH` decimal(10,4) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  `KPI_LIST_ID` bigint(20) NOT NULL,
  `SCORE_MIN` float NOT NULL,
  `SCORE_RECOMMENDED` float NOT NULL,
  PRIMARY KEY (`POS_KPI_ID`),
  KEY `fk_hr_position_kpi_hr_position1_idx` (`POSITION_ID`),
  KEY `fk_hr_position_kpi_hr_kpi_list1_idx` (`KPI_LIST_ID`),
  CONSTRAINT `fk_hr_position_kpi_hr_kpi_list1` FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hr_position_kpi_hr_position1` FOREIGN KEY (`POSITION_ID`) REFERENCES `hr_position` (`POSITION_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_level` */

DROP TABLE IF EXISTS `hr_position_level`;

CREATE TABLE `hr_position_level` (
  `POSITION_LEVEL_ID` bigint(20) DEFAULT NULL,
  `lEVEL_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_position_section` */

DROP TABLE IF EXISTS `hr_position_section`;

CREATE TABLE `hr_position_section` (
  `POSITION_SECTION_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `POSITION_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`POSITION_SECTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_type` */

DROP TABLE IF EXISTS `hr_position_type`;

CREATE TABLE `hr_position_type` (
  `POSITION_TYPE_ID` bigint(25) NOT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`POSITION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_position_type_mapping` */

DROP TABLE IF EXISTS `hr_position_type_mapping`;

CREATE TABLE `hr_position_type_mapping` (
  `POSITION_TYPE_MAPPING_ID` bigint(25) NOT NULL,
  `LEVEL_ID` bigint(25) DEFAULT NULL,
  `POSITION_TYPE_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`POSITION_TYPE_MAPPING_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_power_character_color` */

DROP TABLE IF EXISTS `hr_power_character_color`;

CREATE TABLE `hr_power_character_color` (
  `POWER_CHARACTER_COLOR_ID` bigint(25) NOT NULL,
  `COLOR_NAME` varchar(255) DEFAULT NULL,
  `COLOR_HEX` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`POWER_CHARACTER_COLOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_presence` */

DROP TABLE IF EXISTS `hr_presence`;

CREATE TABLE `hr_presence` (
  `PRESENCE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `PRESENCE_DATETIME` datetime DEFAULT NULL,
  `STATUS` tinyint(4) DEFAULT NULL,
  `ANALYZED` tinyint(4) DEFAULT NULL,
  `TRANSFERRED` tinyint(4) DEFAULT NULL,
  `NUM_OF_PRESENCE` int(11) DEFAULT 1,
  `SCHEDULE_DATETIME` datetime DEFAULT NULL COMMENT 'Tanggal dan Waktu jadwal kerja atau cuti',
  `SCHEDULE_TYPE` int(11) DEFAULT 0 COMMENT '0=none ; 1=normal schedule; 2=AL; 3=LL 4=DP 5=SUL ',
  `OID_SCHEDULE_LEAVE` bigint(20) DEFAULT 0 COMMENT 'oid dari schedule symbol, oid detail dari leave',
  `PERIOD_ID` bigint(20) DEFAULT 0 COMMENT 'oid period dalam lingkup tanggal schedule atau leave',
  `MANUAL_PRESENCE` int(2) DEFAULT 0,
  PRIMARY KEY (`PRESENCE_ID`),
  UNIQUE KEY `unique_presence_time` (`EMPLOYEE_ID`,`PRESENCE_DATETIME`),
  KEY `IDX_HR_PRESNC_EMP` (`EMPLOYEE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_prev_leave` */

DROP TABLE IF EXISTS `hr_prev_leave`;

CREATE TABLE `hr_prev_leave` (
  `PREV_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `DP_LM` int(11) DEFAULT NULL,
  `DP_ADD` int(11) DEFAULT NULL,
  `DP_TAKEN` int(11) DEFAULT NULL,
  `DP_BAL` int(11) DEFAULT NULL,
  `AL_LM` int(11) DEFAULT NULL,
  `AL_ADD` int(11) DEFAULT NULL,
  `AL_TAKEN` int(11) DEFAULT NULL,
  `AL_BAL` int(11) DEFAULT NULL,
  `LL_LM` int(11) DEFAULT NULL,
  `LL_ADD` int(11) DEFAULT NULL,
  `LL_TAKEN` int(11) DEFAULT NULL,
  `LL_BAL` int(11) DEFAULT NULL,
  `MONTH` int(11) DEFAULT NULL,
  PRIMARY KEY (`PREV_LEAVE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_procen_absence` */

DROP TABLE IF EXISTS `hr_procen_absence`;

CREATE TABLE `hr_procen_absence` (
  `procen_presence_id` bigint(20) NOT NULL DEFAULT 0,
  `procen_presence` double DEFAULT 0,
  `absence_day` double DEFAULT 0,
  PRIMARY KEY (`procen_presence_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_propinsi` */

DROP TABLE IF EXISTS `hr_propinsi`;

CREATE TABLE `hr_propinsi` (
  `ID_PROP` bigint(20) NOT NULL,
  `KD_PROP` varchar(10) DEFAULT NULL,
  `NAMA_PROP` varchar(63) NOT NULL,
  `ID_NEGARA` bigint(20) NOT NULL,
  PRIMARY KEY (`ID_PROP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_public_holidays` */

DROP TABLE IF EXISTS `hr_public_holidays`;

CREATE TABLE `hr_public_holidays` (
  `public_holiday_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `holiday_date` date NOT NULL DEFAULT '1900-01-01',
  `holiday_desc` varchar(100) NOT NULL DEFAULT '',
  `holiday_status` bigint(20) unsigned NOT NULL DEFAULT 0,
  `holiday_date_to` date DEFAULT '1900-01-01',
  `day_len` int(8) DEFAULT 1,
  PRIMARY KEY (`public_holiday_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_public_leave` */

DROP TABLE IF EXISTS `hr_public_leave`;

CREATE TABLE `hr_public_leave` (
  `PUBLIC_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PUBLIC_HOLIDAY_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `DATE_FROM` datetime DEFAULT NULL,
  `DATE_TO` datetime DEFAULT NULL,
  `TYPE_LEAVE` bigint(20) DEFAULT 0,
  `EMPLOYEE_CATEGORY_ID` bigint(20) DEFAULT 0,
  `FLAG_SCHDEULE` int(3) DEFAULT 0 COMMENT 'jika user memilih 0= artinya schedulenya diambil di awal, bgtu sebaliknya',
  PRIMARY KEY (`PUBLIC_LEAVE_ID`),
  KEY `FK_hr_public_leave_1` (`PUBLIC_HOLIDAY_ID`),
  CONSTRAINT `FK_hr_public_leave_1` FOREIGN KEY (`PUBLIC_HOLIDAY_ID`) REFERENCES `hr_public_holidays` (`public_holiday_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_public_leave_detail` */

DROP TABLE IF EXISTS `hr_public_leave_detail`;

CREATE TABLE `hr_public_leave_detail` (
  `DETAIL_PUBLIC_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `TYPE_LEAVE` bigint(20) DEFAULT 0,
  `PUBLIC_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PUBLIC_HOLIDAY_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_APPLICATION_ID` bigint(20) DEFAULT 0,
  `DATE_FROM_DETAIL` date DEFAULT NULL,
  `DATE_TO_DETAIL` date DEFAULT NULL,
  PRIMARY KEY (`DETAIL_PUBLIC_LEAVE_ID`),
  KEY `FK_hr_public_leave_detail_1` (`PUBLIC_LEAVE_ID`),
  KEY `index_leave_application` (`LEAVE_APPLICATION_ID`),
  CONSTRAINT `FK_hr_public_leave_detail_1` FOREIGN KEY (`PUBLIC_LEAVE_ID`) REFERENCES `hr_public_leave` (`PUBLIC_LEAVE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_race` */

DROP TABLE IF EXISTS `hr_race`;

CREATE TABLE `hr_race` (
  `RACE_ID` bigint(20) NOT NULL DEFAULT 0,
  `RACE_NAME` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`RACE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_reason` */

DROP TABLE IF EXISTS `hr_reason`;

CREATE TABLE `hr_reason` (
  `reason_id` bigint(20) NOT NULL DEFAULT 0,
  `no` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(100) DEFAULT '',
  `description` varchar(100) DEFAULT '',
  `SCHEDULE_ID` bigint(20) DEFAULT 0,
  `REASON_CODE` varchar(20) NOT NULL DEFAULT '',
  `REASON_TIME` int(3) DEFAULT 0,
  `FLAG_IN_PAY_INPUT` int(2) DEFAULT 0,
  `NUMBER_OF_SHOW` int(2) DEFAULT 0,
  `COUNT_ABLE` int(2) DEFAULT NULL,
  PRIMARY KEY (`reason_id`),
  UNIQUE KEY `no` (`no`),
  UNIQUE KEY `REASON_CODE` (`REASON_CODE`),
  UNIQUE KEY `reason` (`reason`),
  KEY `indx` (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_rec_medical_expence` */

DROP TABLE IF EXISTS `hr_rec_medical_expence`;

CREATE TABLE `hr_rec_medical_expence` (
  `REC_MEDICAL_EXPENCE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIODE` date DEFAULT NULL,
  `MEDICINE_EXPENSE_TYPE_ID` bigint(20) DEFAULT NULL,
  `CODE` varchar(6) DEFAULT NULL,
  `DESCRIPTION` varchar(128) DEFAULT NULL,
  `AMOUNT` decimal(10,2) DEFAULT NULL,
  `DISCOUNT_IN_PERCENT` decimal(6,2) DEFAULT NULL,
  `DISCOUNT_IN_RP` decimal(6,2) DEFAULT NULL,
  `TOTAL` decimal(10,2) DEFAULT NULL,
  `PERSON` int(11) DEFAULT NULL,
  PRIMARY KEY (`REC_MEDICAL_EXPENCE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recognition` */

DROP TABLE IF EXISTS `hr_recognition`;

CREATE TABLE `hr_recognition` (
  `RECOGNITION_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `RECOG_DATE` date DEFAULT NULL,
  `POINT` int(11) DEFAULT NULL,
  PRIMARY KEY (`RECOGNITION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_answer_general` */

DROP TABLE IF EXISTS `hr_recr_answer_general`;

CREATE TABLE `hr_recr_answer_general` (
  `RECR_ANSWER` bigint(20) NOT NULL DEFAULT 0,
  `RECR_GENERAL_ID` bigint(20) DEFAULT NULL,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `ANSWER` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`RECR_ANSWER`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_answer_illness` */

DROP TABLE IF EXISTS `hr_recr_answer_illness`;

CREATE TABLE `hr_recr_answer_illness` (
  `RECR_ANSWER_ILLNESS_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_ILLNESS_ID` bigint(20) DEFAULT NULL,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `ANSWER` int(11) DEFAULT NULL,
  PRIMARY KEY (`RECR_ANSWER_ILLNESS_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_application` */

DROP TABLE IF EXISTS `hr_recr_application`;

CREATE TABLE `hr_recr_application` (
  `RECR_APPLICATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `POSITION` varchar(80) DEFAULT NULL,
  `OTHER_POSITION` varchar(80) DEFAULT NULL,
  `SALARY_EXP` int(11) DEFAULT NULL,
  `DATE_AVAILABLE` date DEFAULT NULL,
  `FULL_NAME` varchar(100) DEFAULT NULL,
  `SEX` tinyint(2) DEFAULT NULL,
  `BIRTH_PLACE` varchar(50) DEFAULT NULL,
  `BIRTH_DATE` date DEFAULT NULL,
  `RELIGION_ID` bigint(20) DEFAULT NULL,
  `ADDRESS` varchar(200) DEFAULT NULL,
  `CITY` varchar(50) DEFAULT NULL,
  `POSTAL_CODE` int(11) DEFAULT NULL,
  `PHONE` varchar(20) DEFAULT NULL,
  `ID_CARD_NUM` varchar(50) DEFAULT NULL,
  `ASTEK_NUM` varchar(20) DEFAULT NULL,
  `MARITAL_ID` bigint(20) DEFAULT NULL,
  `PASSPORT_NO` varchar(80) DEFAULT NULL,
  `ISSUE_PLACE` varchar(80) DEFAULT NULL,
  `VALID_UNTIL` date DEFAULT NULL,
  `HEIGHT` int(11) DEFAULT NULL,
  `WEIGHT` int(11) DEFAULT NULL,
  `BLOOD_TYPE` char(2) DEFAULT NULL,
  `DISTINGUISH_MARKS` varchar(100) DEFAULT NULL,
  `APPL_DATE` date DEFAULT NULL,
  `FATHER_NAME` varchar(80) DEFAULT NULL,
  `FATHER_AGE` int(11) DEFAULT NULL,
  `FATHER_OCCUPATION` varchar(100) DEFAULT NULL,
  `MOTHER_NAME` varchar(80) DEFAULT NULL,
  `MOTHER_AGE` int(11) DEFAULT NULL,
  `MOTHER_OCCUPATION` varchar(100) DEFAULT NULL,
  `FAMILY_ADDRESS` varchar(200) DEFAULT NULL,
  `FAMILY_CITY` varchar(50) DEFAULT NULL,
  `FAMILY_PHONE` varchar(20) DEFAULT NULL,
  `SPOUSE_NAME` varchar(80) DEFAULT NULL,
  `SPOUSE_BIRTH_DATE` date DEFAULT NULL,
  `SPOUSE_OCCUPATION` varchar(100) DEFAULT NULL,
  `CHILD1_NAME` varchar(80) DEFAULT NULL,
  `CHILD1_BIRTHDATE` date DEFAULT NULL,
  `CHILD1_SEX` int(11) DEFAULT NULL,
  `CHILD2_NAME` varchar(80) DEFAULT NULL,
  `CHILD2_BIRTHDATE` date DEFAULT NULL,
  `CHILD2_SEX` int(11) DEFAULT NULL,
  `CHILD3_NAME` varchar(80) DEFAULT NULL,
  `CHILD3_BIRTHDATE` date DEFAULT NULL,
  `CHILD3_SEX` int(11) DEFAULT NULL,
  `FNL_POSITION_ID` bigint(20) DEFAULT NULL,
  `FNL_DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `FNL_LEVEL_ID` bigint(20) DEFAULT NULL,
  `FNL_MEDICAL_SCHEME` varchar(120) DEFAULT NULL,
  `FNL_HOSPITALIZATION` varchar(120) DEFAULT NULL,
  `FNL_ASTEK_DEDUCTION` varchar(120) DEFAULT NULL,
  `FNL_BASIC_SALARY` varchar(120) DEFAULT NULL,
  `FNL_SERVICE_CHARGE` varchar(120) DEFAULT NULL,
  `FNL_ALLOWANCE` varchar(120) DEFAULT NULL,
  `FNL_ANNUAL_LEAVE` int(11) DEFAULT NULL,
  `FNL_OTHER_BENEFIT` varchar(120) DEFAULT NULL,
  `FNL_PRIVILEGE` varchar(120) DEFAULT NULL,
  `FNL_COMM_DATE` date DEFAULT NULL,
  `FNL_PROBATION` varchar(50) DEFAULT NULL,
  `CHILD4_NAME` varchar(80) DEFAULT NULL,
  `CHILD4_BIRTHDATE` date DEFAULT NULL,
  `CHILD5_NAME` varchar(80) DEFAULT NULL,
  `CHILD5_BIRTHDATE` date DEFAULT NULL,
  `CHILD6_NAME` varchar(80) DEFAULT NULL,
  `CHILD6_BIRTHDATE` date DEFAULT NULL,
  `CHILD7_NAME` varchar(80) DEFAULT NULL,
  `CHILD7_BIRTHDATE` date DEFAULT NULL,
  `CHILD7_SEX` int(11) DEFAULT NULL,
  `CHILD6_SEX` int(11) DEFAULT NULL,
  `CHILD5_SEX` int(11) DEFAULT NULL,
  `CHILD4_SEX` int(11) DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(50) DEFAULT NULL,
  `REFERENCE` varchar(50) DEFAULT NULL,
  `NAME_EMG` varchar(50) DEFAULT NULL,
  `PHONE_EMG` varchar(50) DEFAULT NULL,
  `ADDRESS_EMG` varchar(50) DEFAULT NULL,
  `SKILL` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RECR_APPLICATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_comment` */

DROP TABLE IF EXISTS `hr_recr_comment`;

CREATE TABLE `hr_recr_comment` (
  `RECR_COMMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_INTERVIEWER_ID` bigint(20) DEFAULT NULL,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `COMMENT` text DEFAULT NULL,
  PRIMARY KEY (`RECR_COMMENT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_education` */

DROP TABLE IF EXISTS `hr_recr_education`;

CREATE TABLE `hr_recr_education` (
  `RECR_EDUCATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `STUDY` varchar(100) DEFAULT NULL,
  `DEGREE` varchar(80) DEFAULT NULL,
  `KATEGORI` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RECR_EDUCATION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_general` */

DROP TABLE IF EXISTS `hr_recr_general`;

CREATE TABLE `hr_recr_general` (
  `RECR_GENERAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `QUESTION` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`RECR_GENERAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_illness` */

DROP TABLE IF EXISTS `hr_recr_illness`;

CREATE TABLE `hr_recr_illness` (
  `RECR_ILLNESS_ID` bigint(20) NOT NULL DEFAULT 0,
  `ILLNESS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RECR_ILLNESS_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_interview_factor` */

DROP TABLE IF EXISTS `hr_recr_interview_factor`;

CREATE TABLE `hr_recr_interview_factor` (
  `RECR_INTERVIEW_FACTOR_ID` bigint(20) NOT NULL DEFAULT 0,
  `INTERVIEW_FACTOR` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RECR_INTERVIEW_FACTOR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_interview_point` */

DROP TABLE IF EXISTS `hr_recr_interview_point`;

CREATE TABLE `hr_recr_interview_point` (
  `RECR_INTERVIEW_POINT_ID` bigint(20) NOT NULL DEFAULT 0,
  `INTERVIEW_POINT` int(11) DEFAULT NULL,
  `INTERVIEW_MARK` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`RECR_INTERVIEW_POINT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_interview_result` */

DROP TABLE IF EXISTS `hr_recr_interview_result`;

CREATE TABLE `hr_recr_interview_result` (
  `RECR_INTERVIEW_RESULT_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_INTERVIEW_POINT_ID` bigint(20) DEFAULT NULL,
  `RECR_INTERVIEWER_FACTOR_ID` bigint(20) DEFAULT NULL,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RECR_INTERVIEW_RESULT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_interviewer` */

DROP TABLE IF EXISTS `hr_recr_interviewer`;

CREATE TABLE `hr_recr_interviewer` (
  `RECR_INTERVIEWER_ID` bigint(20) NOT NULL DEFAULT 0,
  `INTERVIEWER` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RECR_INTERVIEWER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_interviewer_factor` */

DROP TABLE IF EXISTS `hr_recr_interviewer_factor`;

CREATE TABLE `hr_recr_interviewer_factor` (
  `RECR_INTERVIEWER_FACTOR_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_INTERVIEW_FACTOR_ID` bigint(20) DEFAULT NULL,
  `RECR_INTERVIEWER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RECR_INTERVIEWER_FACTOR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_language` */

DROP TABLE IF EXISTS `hr_recr_language`;

CREATE TABLE `hr_recr_language` (
  `RECR_LANGUAGE_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `LANGUAGE_ID` bigint(20) DEFAULT NULL,
  `SPOKEN` int(11) DEFAULT NULL,
  `WRITTEN` int(11) DEFAULT NULL,
  `READING` int(11) DEFAULT NULL,
  PRIMARY KEY (`RECR_LANGUAGE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_references` */

DROP TABLE IF EXISTS `hr_recr_references`;

CREATE TABLE `hr_recr_references` (
  `RECR_REFERENCES_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `COMPANY` varchar(100) DEFAULT NULL,
  `POSITION` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`RECR_REFERENCES_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_recr_work_history` */

DROP TABLE IF EXISTS `hr_recr_work_history`;

CREATE TABLE `hr_recr_work_history` (
  `RECR_WORK_HISTORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `RECR_APPLICATION_ID` bigint(20) DEFAULT NULL,
  `POSITION` varchar(80) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `DUTIES` varchar(200) DEFAULT NULL,
  `COMM_SALARY` int(11) DEFAULT NULL,
  `LAST_SALARY` int(11) DEFAULT NULL,
  `COMPANY_NAME` varchar(100) DEFAULT NULL,
  `COMPANY_ADDRESS` varchar(200) DEFAULT NULL,
  `COMPANY_PHONE` varchar(20) DEFAULT NULL,
  `COMPANY_NATURE` varchar(80) DEFAULT NULL,
  `COMPANY_SPV` varchar(80) DEFAULT NULL,
  `LEAVE_REASON` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`RECR_WORK_HISTORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_religion` */

DROP TABLE IF EXISTS `hr_religion`;

CREATE TABLE `hr_religion` (
  `RELIGION_ID` bigint(20) NOT NULL DEFAULT 0,
  `RELIGION` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`RELIGION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_report_lkpbu_801` */

DROP TABLE IF EXISTS `hr_report_lkpbu_801`;

CREATE TABLE `hr_report_lkpbu_801` (
  `LKPBU_801_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `NO_SURAT_PELAPORAN` varchar(100) DEFAULT NULL,
  `TANGGAL_SURAT_PELAPORAN` varchar(100) DEFAULT NULL,
  `NO_SK` varchar(100) DEFAULT NULL,
  `TANGGAL_SK` varchar(100) DEFAULT NULL,
  `NO_SK_PEMBERHENTIAN` varchar(100) DEFAULT NULL,
  `TANGGAL_SK_PEMBERHENTIAN` varchar(100) DEFAULT NULL,
  `PERIOD_ID` bigint(25) DEFAULT NULL,
  `POSITION` varchar(100) DEFAULT NULL,
  `KETERANGAN` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`LKPBU_801_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_report_lkpbu_805` */

DROP TABLE IF EXISTS `hr_report_lkpbu_805`;

CREATE TABLE `hr_report_lkpbu_805` (
  `LKPBU_805_ID` bigint(20) NOT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `EDUCATION_ID` bigint(20) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  `LKPBU_805_YEAR_REALISASI` float DEFAULT NULL,
  `LKPBU_805_YEAR_PREDIKSI_1` float DEFAULT NULL,
  `LKPBU_805_YEAR_PREDIKSI_2` float DEFAULT NULL,
  `LKPBU_805_YEAR_PREDIKSI_3` float DEFAULT NULL,
  `LKPBU_805_YEAR_PREDIKSI_4` float DEFAULT NULL,
  `LKPBU_805_START_DATE` date DEFAULT NULL,
  `JENIS_PEKERJAAN` varchar(20) DEFAULT NULL,
  `JENIS_PENDIDIKAN` varchar(20) DEFAULT NULL,
  `STATUS_PEGAWAI` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`LKPBU_805_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_reprimand` */

DROP TABLE IF EXISTS `hr_reprimand`;

CREATE TABLE `hr_reprimand` (
  `REPRIMAND_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `NUMBER` int(11) DEFAULT NULL,
  `CHAPTER` varchar(100) DEFAULT NULL,
  `ARTICLE` varchar(100) DEFAULT NULL,
  `VERSE` varchar(100) DEFAULT NULL,
  `PAGE` varchar(100) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `REPRIMAND_DATE` date NOT NULL DEFAULT '0000-00-00',
  `VALID_UNTIL` date DEFAULT NULL,
  `REPRIMAND_LEVEL_ID` bigint(20) DEFAULT 0,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`REPRIMAND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_resigned_reason` */

DROP TABLE IF EXISTS `hr_resigned_reason`;

CREATE TABLE `hr_resigned_reason` (
  `RESIGNED_REASON_ID` bigint(20) NOT NULL DEFAULT 0,
  `RESIGNED_REASON` varchar(30) DEFAULT NULL,
  `RESIGNED_CODE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`RESIGNED_REASON_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_reward_punisment_detail` */

DROP TABLE IF EXISTS `hr_reward_punisment_detail`;

CREATE TABLE `hr_reward_punisment_detail` (
  `REWARD_PUNISMENT_DETAIL_ID` bigint(20) NOT NULL DEFAULT 0,
  `REWARD_PUNISMENT_MAIN_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `KOEFISIEN_POSITION_ID` bigint(20) DEFAULT 0,
  `WORKING_DAYS` int(100) DEFAULT 0,
  `TOTAL` double DEFAULT NULL,
  `BEBAN` double DEFAULT NULL,
  `TUNAI` double DEFAULT NULL,
  `LAMA_MASA_CICILAN` int(10) DEFAULT 0,
  `adjusment` char(4) DEFAULT NULL,
  PRIMARY KEY (`REWARD_PUNISMENT_DETAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_reward_punisment_main` */

DROP TABLE IF EXISTS `hr_reward_punisment_main`;

CREATE TABLE `hr_reward_punisment_main` (
  `REWARD_PUNISMENT_MAIN_ID` bigint(20) NOT NULL DEFAULT 0,
  `DETAIL_NBH_NO` varchar(300) DEFAULT NULL,
  `JENIS_SO_ID` bigint(20) DEFAULT 0,
  `LOCATION_ID` bigint(20) DEFAULT 0,
  `DATE_CREATE_DOC` datetime DEFAULT NULL,
  `STATUS_DOC` int(3) DEFAULT NULL,
  `APPROVAL_ONE` bigint(20) DEFAULT 0,
  `APPROVAL_TWO` bigint(20) DEFAULT 0,
  `APPROVAL_THREE` bigint(20) DEFAULT 0,
  `COUNT_IDX` int(200) DEFAULT NULL,
  `NET_SALES_PERIOD` double DEFAULT 0 COMMENT 'INI BERFUNGSI AGAR DI FORM DI TAMPILKAN',
  `BARANG_HILANG` double DEFAULT 0 COMMENT 'INI BERFUNGSI AGAR DI FORM DI TAMPILKAN',
  `STATUS_OPNAME` varchar(100) DEFAULT NULL COMMENT 'INI BERFUNGSI AGAR DI FORM DI TAMPILKAN APAKAH DIA REWARD ATAU PUNISMENT',
  `NILAI_STATUS_OPNAME` double DEFAULT 0 COMMENT 'NILAI DARI REWART ATAU PUNISMENT',
  `CREATE_FORM_MAIN` varchar(100) DEFAULT NULL,
  `START_DATE_PERIOD` date DEFAULT NULL,
  `END_DATE_PERIOD` date DEFAULT NULL,
  `ENTRI_OPNAME_SALES_ID` bigint(20) DEFAULT 0 COMMENT 'sebagai flag jika dia sudah di prosess',
  PRIMARY KEY (`REWARD_PUNISMENT_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_schedule_category` */

DROP TABLE IF EXISTS `hr_schedule_category`;

CREATE TABLE `hr_schedule_category` (
  `SCHEDULE_CATEGORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `CATEGORY_TYPE` int(11) DEFAULT 0,
  `CATEGORY` varchar(50) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`SCHEDULE_CATEGORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_schedule_symbol` */

DROP TABLE IF EXISTS `hr_schedule_symbol`;

CREATE TABLE `hr_schedule_symbol` (
  `SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `SCHEDULE_CATEGORY_ID` bigint(20) DEFAULT NULL,
  `SCHEDULE` varchar(64) DEFAULT NULL,
  `SYMBOL` varchar(10) DEFAULT NULL,
  `TIME_IN` time DEFAULT NULL,
  `TIME_OUT` time DEFAULT NULL,
  `MAX_ENTITLE` int(11) DEFAULT NULL,
  `PERIODE` int(11) DEFAULT NULL,
  `PERIODE_TYPE` int(11) DEFAULT NULL,
  `MIN_SERVICE` int(11) DEFAULT NULL,
  `BREAK_OUT` time DEFAULT NULL,
  `BREAK_IN` time DEFAULT NULL,
  `TRANSPORT_ALLOWANCE` int(1) DEFAULT NULL,
  `NIGHT_ALLOWANCE` int(1) DEFAULT NULL,
  `WORK_DAYS` int(1) DEFAULT NULL,
  `REPORT_TYPE` int(2) DEFAULT NULL,
  `SHOW_ON_USER_LEAVE` int(1) DEFAULT NULL,
  `SHOW_PRESENT_ON_WEEKEND` int(1) DEFAULT 0,
  `COUNT_ON_LEAVE` int(1) DEFAULT 0,
  `PERHITUNGAN_UANG_MAKAN` int(1) DEFAULT 0,
  `WORK_DURATION` double DEFAULT NULL,
  PRIMARY KEY (`SCHEDULE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_section` */

DROP TABLE IF EXISTS `hr_section`;

CREATE TABLE `hr_section` (
  `SECTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION` varchar(100) DEFAULT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `SECTION_LINK_TO` varchar(255) DEFAULT NULL,
  `VALID_STATUS` int(2) DEFAULT 1,
  `VALID_START` date DEFAULT NULL,
  `VALID_END` date DEFAULT NULL,
  `LEVEL` int(2) DEFAULT 0,
  PRIMARY KEY (`SECTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_service_conf` */

DROP TABLE IF EXISTS `hr_service_conf`;

CREATE TABLE `hr_service_conf` (
  `SERVICE_ID` bigint(20) NOT NULL DEFAULT 0,
  `SERVICE_TYPE` int(11) NOT NULL DEFAULT 0,
  `START_TIME` datetime DEFAULT NULL,
  `PERIODE` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`SERVICE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_special_achievement` */

DROP TABLE IF EXISTS `hr_special_achievement`;

CREATE TABLE `hr_special_achievement` (
  `SPECIAL_ACHIEVEMENT_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `TYPE_OF_AWARD` varchar(128) DEFAULT NULL,
  `PRESENTED_BY` varchar(64) DEFAULT NULL,
  `DATE` date DEFAULT NULL,
  PRIMARY KEY (`SPECIAL_ACHIEVEMENT_ID`),
  UNIQUE KEY `XPKHR_SPECIAL_ACHIEVEMENT` (`SPECIAL_ACHIEVEMENT_ID`),
  KEY `XIF175HR_SPECIAL_ACHIEVEMENT` (`EMPLOYEE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_special_leave` */

DROP TABLE IF EXISTS `hr_special_leave`;

CREATE TABLE `hr_special_leave` (
  `SPECIAL_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `REQUEST_DATE` date DEFAULT '0000-00-00',
  `UNPAID_LEAVE_REASON` text DEFAULT NULL,
  `OTHER_REMARKS` text DEFAULT NULL,
  `APPROVAL_ID` bigint(20) DEFAULT NULL,
  `APPROVAL2_ID` bigint(20) DEFAULT NULL,
  `APPROVAL3_ID` bigint(20) DEFAULT NULL,
  `APPROVAL_DATE` date DEFAULT NULL,
  `APPROVAL2_DATE` date DEFAULT NULL,
  `APPROVAL3_DATE` date DEFAULT NULL,
  PRIMARY KEY (`SPECIAL_LEAVE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_special_leave_stock` */

DROP TABLE IF EXISTS `hr_special_leave_stock`;

CREATE TABLE `hr_special_leave_stock` (
  `SPECIAL_LEAVE_STOCK_ID` bigint(20) NOT NULL DEFAULT 0,
  `SPECIAL_LEAVE_ID` bigint(20) DEFAULT NULL,
  `SYMBOL_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAKEN_DATE` date NOT NULL DEFAULT '0000-00-00',
  `TAKEN_QTY` tinyint(4) NOT NULL DEFAULT 0,
  `LEAVE_STATUS` int(11) DEFAULT 0,
  PRIMARY KEY (`SPECIAL_LEAVE_STOCK_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_special_leave_taken` */

DROP TABLE IF EXISTS `hr_special_leave_taken`;

CREATE TABLE `hr_special_leave_taken` (
  `SPECIAL_LEAVE_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAKEN_DATE` date NOT NULL DEFAULT '0000-00-00',
  `TAKEN_QTY` tinyint(4) NOT NULL DEFAULT 0,
  `PAID_DATE` date DEFAULT NULL,
  `SYMBOL_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`SPECIAL_LEAVE_TAKEN_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_special_unpaid_leave_taken` */

DROP TABLE IF EXISTS `hr_special_unpaid_leave_taken`;

CREATE TABLE `hr_special_unpaid_leave_taken` (
  `SPECIAL_UNPAID_LEAVE_TAKEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEAVE_APPLICATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `SCHEDULED_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) NOT NULL,
  `TAKEN_DATE` datetime DEFAULT NULL,
  `TAKEN_QTY` float(20,10) DEFAULT NULL,
  `TAKEN_STATUS` int(11) DEFAULT NULL,
  `TAKEN_FROM_STATUS` int(11) DEFAULT NULL,
  `TAKEN_FINNISH_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`SPECIAL_UNPAID_LEAVE_TAKEN_ID`),
  KEY `index_leave_application` (`LEAVE_APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_staff_requisition` */

DROP TABLE IF EXISTS `hr_staff_requisition`;

CREATE TABLE `hr_staff_requisition` (
  `STAFF_REQUISITION_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  `REQUISITION_TYPE` int(11) DEFAULT NULL,
  `NEEDED_MALE` int(11) DEFAULT NULL,
  `NEEDED_FEMALE` int(11) DEFAULT NULL,
  `EXP_COMM_DATE` date DEFAULT NULL,
  `TEMP_FOR` int(11) DEFAULT NULL,
  `APPROVED_BY` bigint(20) DEFAULT NULL,
  `APPROVED_DATE` date DEFAULT NULL,
  `ACKNOWLEDGED_BY` bigint(20) DEFAULT NULL,
  `ACKNOWLEDGED_DATE` date DEFAULT NULL,
  `REQUESTED_BY` bigint(20) DEFAULT NULL,
  `REQUESTED_DATE` date DEFAULT NULL,
  PRIMARY KEY (`STAFF_REQUISITION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_structure_position_access` */

DROP TABLE IF EXISTS `hr_structure_position_access`;

CREATE TABLE `hr_structure_position_access` (
  `STRUCTURE_POSITION_ACCESS_ID` bigint(25) NOT NULL,
  `STRUCTURE_TEMPLATE_ID` bigint(25) DEFAULT NULL,
  `POSITION_ID` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`STRUCTURE_POSITION_ACCESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_structure_template` */

DROP TABLE IF EXISTS `hr_structure_template`;

CREATE TABLE `hr_structure_template` (
  `TEMPLATE_ID` bigint(20) NOT NULL,
  `TEMPLATE_NAME` varchar(128) DEFAULT NULL,
  `TEMPLATE_DESC` text DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  PRIMARY KEY (`TEMPLATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_system_property` */

DROP TABLE IF EXISTS `hr_system_property`;

CREATE TABLE `hr_system_property` (
  `SYSPROP_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(64) NOT NULL DEFAULT '',
  `VALUEPROP` text DEFAULT NULL,
  `VALTYPE` varchar(16) DEFAULT NULL,
  `GROUPPROP` varchar(16) DEFAULT NULL,
  `DISTYPE` varchar(20) DEFAULT NULL,
  `NOTE` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`SYSPROP_ID`),
  UNIQUE KEY `XPKSYSTEM_PROPERTY` (`SYSPROP_ID`),
  UNIQUE KEY `XNAME_SYSTEM_PROPERTY` (`NAME`),
  UNIQUE KEY `Index_4` (`NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training` */

DROP TABLE IF EXISTS `hr_training`;

CREATE TABLE `hr_training` (
  `TRAINING_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(128) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `TYPE` bigint(20) DEFAULT 0,
  `CODE` varchar(2) DEFAULT NULL,
  `KODE_ANGGARAN` varchar(10) DEFAULT NULL,
  `MASA_BERLAKU` int(2) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_activity_actual` */

DROP TABLE IF EXISTS `hr_training_activity_actual`;

CREATE TABLE `hr_training_activity_actual` (
  `TRAINING_ACTIVITY_ACTUAL_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAINING_ACTIVITY_PLAN_ID` bigint(20) DEFAULT NULL,
  `DATE` date DEFAULT NULL,
  `START_TIME` time DEFAULT NULL,
  `END_TIME` time DEFAULT NULL,
  `ATENDEES` int(11) DEFAULT NULL,
  `VENUE` varchar(50) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT 0,
  `TRAINNER` varchar(100) DEFAULT NULL,
  `TRAINING_SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `ORGANIZER_ID` bigint(20) DEFAULT NULL,
  `TRAIN_END_DATE` date DEFAULT NULL,
  `TOTAL_HOUR` int(11) DEFAULT NULL,
  `TRAINING_TITLE` varchar(128) NOT NULL,
  `SERTIFIKAT_NAME` varchar(225) NOT NULL,
  `KODE_OJK` varchar(225) NOT NULL,
  PRIMARY KEY (`TRAINING_ACTIVITY_ACTUAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_activity_mapping` */

DROP TABLE IF EXISTS `hr_training_activity_mapping`;

CREATE TABLE `hr_training_activity_mapping` (
  `TRAINING_ACTIVITY_MAPPING_ID` bigint(20) NOT NULL,
  `TRAINING_ACTIVITY_PLAN_ID` bigint(20) NOT NULL,
  `TRAINING_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`TRAINING_ACTIVITY_MAPPING_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_activity_plan` */

DROP TABLE IF EXISTS `hr_training_activity_plan`;

CREATE TABLE `hr_training_activity_plan` (
  `TRAINING_ACTIVITY_PLAN_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `DATE` date DEFAULT NULL,
  `PROGRAM` varchar(100) DEFAULT NULL,
  `TRAINER` varchar(50) DEFAULT NULL,
  `PROGRAMS_PLAN` int(11) DEFAULT NULL,
  `TOT_HOURS_PLAN` int(11) DEFAULT NULL,
  `TRAINEES_PLAN` int(11) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `ORGANIZER_ID` bigint(20) DEFAULT NULL,
  `TRAINING_TITLE` varchar(128) NOT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `KODE_OJK` varchar(255) NOT NULL,
  PRIMARY KEY (`TRAINING_ACTIVITY_PLAN_ID`),
  UNIQUE KEY `XPKHR_TRAINING_ACTIVITY_PLAN` (`TRAINING_ACTIVITY_PLAN_ID`),
  KEY `XIF173HR_TRAINING_ACTIVITY_PLA` (`DEPARTMENT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_area` */

DROP TABLE IF EXISTS `hr_training_area`;

CREATE TABLE `hr_training_area` (
  `TRAINING_AREA_ID` bigint(20) NOT NULL,
  `AREA_NAME` varchar(128) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`TRAINING_AREA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_attendance_plan` */

DROP TABLE IF EXISTS `hr_training_attendance_plan`;

CREATE TABLE `hr_training_attendance_plan` (
  `TRAINING_ATTENDANCE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAINING_PLAN_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `DURATION` int(11) DEFAULT 0,
  `POINT` int(11) DEFAULT 0,
  `REMARK` varchar(255) NOT NULL,
  PRIMARY KEY (`TRAINING_ATTENDANCE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_budget` */

DROP TABLE IF EXISTS `hr_training_budget`;

CREATE TABLE `hr_training_budget` (
  `TRAINING_BUDGET_ID` bigint(20) NOT NULL,
  `TRAINING_BUDGET_YEAR` varchar(10) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `TRAINING_BUDGET_DURATION` float DEFAULT NULL,
  `TRAINING_BUDGET_FREQUENCY` float DEFAULT NULL,
  `TRAINING_BUDGET_BATCH` float DEFAULT NULL,
  `TRAINING_BUDGET_AMOUNT` float DEFAULT NULL,
  `TRAINING_BUDGET_COST_BATCH` float DEFAULT NULL,
  `TRAINING_BUDGET_TOTAL` float DEFAULT NULL,
  `TRAINING_LOCATION_TYPE_ID` bigint(20) DEFAULT NULL,
  `TRAINING_AREA_ID` bigint(20) DEFAULT NULL,
  `TRAINING_BUDGET_DESC` text DEFAULT NULL,
  PRIMARY KEY (`TRAINING_BUDGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_competency_mapping` */

DROP TABLE IF EXISTS `hr_training_competency_mapping`;

CREATE TABLE `hr_training_competency_mapping` (
  `TRAINING_COMPETENCY_MAPPING_ID` bigint(20) NOT NULL,
  `TRAINING_ACTIVITY_ACTUAL_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `SCORE` double(4,0) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_COMPETENCY_MAPPING_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_competency_mapping_detail` */

DROP TABLE IF EXISTS `hr_training_competency_mapping_detail`;

CREATE TABLE `hr_training_competency_mapping_detail` (
  `TRAINING_COMPETENCY_MAPPING_DETAIL_ID` bigint(20) NOT NULL,
  `TRAINING_ACTIVITY_ACTUAL_ID` bigint(20) DEFAULT NULL,
  `COMPETENCY_ID` bigint(20) DEFAULT NULL,
  `SCORE` double(4,0) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `TRAINING_ATTENDANCE_ID` bigint(20) DEFAULT NULL,
  `TRAINING_COMPETENCY_MAPPING_ID` bigint(20) DEFAULT NULL,
  `TRAINING_HISTORY_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_COMPETENCY_MAPPING_DETAIL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_dept` */

DROP TABLE IF EXISTS `hr_training_dept`;

CREATE TABLE `hr_training_dept` (
  `TRAINING_DEPT_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_DEPT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_file` */

DROP TABLE IF EXISTS `hr_training_file`;

CREATE TABLE `hr_training_file` (
  `TRAINING_FILE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAINING_ID` bigint(20) DEFAULT 0,
  `FILE_NAME` varchar(100) DEFAULT '',
  `ATTACH_FILE` mediumblob DEFAULT NULL,
  `TRAINING_TITLE` text DEFAULT NULL,
  PRIMARY KEY (`TRAINING_FILE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_history` */

DROP TABLE IF EXISTS `hr_training_history`;

CREATE TABLE `hr_training_history` (
  `TRAINING_HISTORY_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `TRAINING_PROGRAM` text DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `TRAINER` varchar(50) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `TRAINING_ID` bigint(20) DEFAULT NULL,
  `DURATION` int(11) DEFAULT NULL,
  `PRESENCE` int(11) DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `TRAINING_ACTIVITY_PLAN_ID` bigint(20) unsigned DEFAULT 0,
  `TRAINING_ACTIVITY_ACTUAL_ID` bigint(20) unsigned DEFAULT 0,
  `POINT` double(16,2) NOT NULL,
  `NOMOR_SK` varchar(64) NOT NULL,
  `TANGGAL_SK` datetime NOT NULL,
  `EMP_DOC_ID` bigint(20) NOT NULL,
  `TRAINING_TITLE` varchar(128) DEFAULT NULL,
  `PRE_TEST` double(16,2) DEFAULT NULL,
  `POST_TEST` double(16,2) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_HISTORY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_location_type` */

DROP TABLE IF EXISTS `hr_training_location_type`;

CREATE TABLE `hr_training_location_type` (
  `TRAINING_LOCATION_TYPE_ID` bigint(20) NOT NULL,
  `LOCATION_NAME` varchar(128) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`TRAINING_LOCATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_schedule` */

DROP TABLE IF EXISTS `hr_training_schedule`;

CREATE TABLE `hr_training_schedule` (
  `TRAINING_SCHEDULE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAINING_PLAN_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAIN_DATE` date DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `VENUE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TRAIN_END_DATE` date DEFAULT NULL,
  `TOTAL_HOUR` int(11) DEFAULT NULL,
  PRIMARY KEY (`TRAINING_SCHEDULE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_score` */

DROP TABLE IF EXISTS `hr_training_score`;

CREATE TABLE `hr_training_score` (
  `TRAINING_SCORE_ID` bigint(20) NOT NULL,
  `TRAINING_ID` bigint(20) NOT NULL,
  `POINT_MIN` float(4,0) NOT NULL,
  `POINT_MAX` float(4,0) NOT NULL,
  `DURATION_MIN` float(4,0) NOT NULL,
  `DURATION_MAX` float(4,0) NOT NULL,
  `FREQUENCY_MIN` float(4,0) NOT NULL,
  `FREQUENCY_MAX` float(4,0) NOT NULL,
  `SCORE` float(4,0) NOT NULL,
  `NOTE` text NOT NULL,
  `VALID_START` date NOT NULL,
  `VALID_END` date NOT NULL,
  PRIMARY KEY (`TRAINING_SCORE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_type` */

DROP TABLE IF EXISTS `hr_training_type`;

CREATE TABLE `hr_training_type` (
  `TYPE_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(30) NOT NULL DEFAULT '',
  `DESCRIPTION` text DEFAULT NULL,
  `CODE` varchar(10) DEFAULT '0',
  PRIMARY KEY (`TYPE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_training_venue` */

DROP TABLE IF EXISTS `hr_training_venue`;

CREATE TABLE `hr_training_venue` (
  `VENUE_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(50) NOT NULL DEFAULT '',
  `DESCRIPTION` text DEFAULT NULL,
  PRIMARY KEY (`VENUE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_user_group` */

DROP TABLE IF EXISTS `hr_user_group`;

CREATE TABLE `hr_user_group` (
  `USER_ID` bigint(20) NOT NULL DEFAULT 0,
  `GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`USER_ID`,`GROUP_ID`),
  UNIQUE KEY `XPKUSER_GROUP` (`USER_ID`,`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_view_al_stock_approved` */

DROP TABLE IF EXISTS `hr_view_al_stock_approved`;

CREATE TABLE `hr_view_al_stock_approved` (
  `al_stock_taken_id` bigint(20) DEFAULT NULL,
  `leave_application_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_view_al_taken_period` */

DROP TABLE IF EXISTS `hr_view_al_taken_period`;

CREATE TABLE `hr_view_al_taken_period` (
  `leave_application_id` tinyint(4) NOT NULL,
  `employee_id` tinyint(4) NOT NULL,
  `al_start_date` tinyint(4) NOT NULL,
  `al_end_date` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_app_closing` */

DROP TABLE IF EXISTS `hr_view_app_closing`;

CREATE TABLE `hr_view_app_closing` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `al_stock_id` tinyint(4) NOT NULL,
  `al_qty` tinyint(4) NOT NULL,
  `al_status` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_attendance` */

DROP TABLE IF EXISTS `hr_view_attendance`;

CREATE TABLE `hr_view_attendance` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `SCH_DATE` tinyint(4) NOT NULL,
  `SCH_DAYS` tinyint(4) NOT NULL,
  `SCH_ID` tinyint(4) NOT NULL,
  `IN_TIME` tinyint(4) NOT NULL,
  `OUT_TIME` tinyint(4) NOT NULL,
  `REASON_ID` tinyint(4) NOT NULL,
  `STATUS_IDX` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_dp` */

DROP TABLE IF EXISTS `hr_view_dp`;

CREATE TABLE `hr_view_dp` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `DP_QTY` tinyint(4) NOT NULL,
  `QTY_USED` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_dp_stock_aktif` */

DROP TABLE IF EXISTS `hr_view_dp_stock_aktif`;

CREATE TABLE `hr_view_dp_stock_aktif` (
  `DP_STOCK_ID` tinyint(4) NOT NULL,
  `LEAVE_PERIODE_ID` tinyint(4) NOT NULL,
  `DP_QTY` tinyint(4) NOT NULL,
  `OWNING_DATE` tinyint(4) NOT NULL,
  `EXPIRED_DATE` tinyint(4) NOT NULL,
  `EXCEPTION_FLAG` tinyint(4) NOT NULL,
  `EXPIRED_DATE_EXC` tinyint(4) NOT NULL,
  `DP_STATUS` tinyint(4) NOT NULL,
  `NOTE` tinyint(4) NOT NULL,
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `QTY_USED` tinyint(4) NOT NULL,
  `QTY_RESIDUE` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_dp_taken_period` */

DROP TABLE IF EXISTS `hr_view_dp_taken_period`;

CREATE TABLE `hr_view_dp_taken_period` (
  `leave_application_id` tinyint(4) NOT NULL,
  `employee_id` tinyint(4) NOT NULL,
  `dp_start_date` tinyint(4) NOT NULL,
  `dp_end_date` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_dp_upload_not_proces` */

DROP TABLE IF EXISTS `hr_view_dp_upload_not_proces`;

CREATE TABLE `hr_view_dp_upload_not_proces` (
  `DP_UPLOAD_ID` tinyint(4) NOT NULL,
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `OPNAME_DATE` tinyint(4) NOT NULL,
  `DP_AQ_DATE` tinyint(4) NOT NULL,
  `DP_NUMBER` tinyint(4) NOT NULL,
  `DATA_STATUS` tinyint(4) NOT NULL,
  `DP_STOCK_ID` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_emp_closing` */

DROP TABLE IF EXISTS `hr_view_emp_closing`;

CREATE TABLE `hr_view_emp_closing` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `EMPLOYEE_NUM` tinyint(4) NOT NULL,
  `DIVISION_ID` tinyint(4) NOT NULL,
  `FULL_NAME` tinyint(4) NOT NULL,
  `DEPARTMENT_ID` tinyint(4) NOT NULL,
  `POSITION_ID` tinyint(4) NOT NULL,
  `SECTION_ID` tinyint(4) NOT NULL,
  `EMP_CATEGORY_ID` tinyint(4) NOT NULL,
  `LEVEL_ID` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_leave_app_period` */

DROP TABLE IF EXISTS `hr_view_leave_app_period`;

CREATE TABLE `hr_view_leave_app_period` (
  `leave_application_id` tinyint(4) NOT NULL,
  `employee_id` tinyint(4) NOT NULL,
  `al_start_date` tinyint(4) NOT NULL,
  `al_end_date` tinyint(4) NOT NULL,
  `ll_start_date` tinyint(4) NOT NULL,
  `ll_end_date` tinyint(4) NOT NULL,
  `dp_start_date` tinyint(4) NOT NULL,
  `dp_end_date` tinyint(4) NOT NULL,
  `sp_start_date` tinyint(4) NOT NULL,
  `sp_end_date` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_ll_taken_period` */

DROP TABLE IF EXISTS `hr_view_ll_taken_period`;

CREATE TABLE `hr_view_ll_taken_period` (
  `leave_application_id` tinyint(4) NOT NULL,
  `employee_id` tinyint(4) NOT NULL,
  `ll_start_date` tinyint(4) NOT NULL,
  `ll_end_date` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_sp_taken_period` */

DROP TABLE IF EXISTS `hr_view_sp_taken_period`;

CREATE TABLE `hr_view_sp_taken_period` (
  `leave_application_id` tinyint(4) NOT NULL,
  `employee_id` tinyint(4) NOT NULL,
  `sp_start_date` tinyint(4) NOT NULL,
  `sp_end_date` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_sp_tkn` */

DROP TABLE IF EXISTS `hr_view_sp_tkn`;

CREATE TABLE `hr_view_sp_tkn` (
  `SPECIAL_UNPAID_LEAVE_TAKEN_ID` tinyint(4) NOT NULL,
  `LEAVE_APPLICATION_ID` tinyint(4) NOT NULL,
  `SCHEDULED_ID` tinyint(4) NOT NULL,
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `TAKEN_DATE` tinyint(4) NOT NULL,
  `TAKEN_QTY` tinyint(4) NOT NULL,
  `TAKEN_STATUS` tinyint(4) NOT NULL,
  `TAKEN_FROM_STATUS` tinyint(4) NOT NULL,
  `TAKEN_FINNISH_DATE` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_sp_to_be_tkn` */

DROP TABLE IF EXISTS `hr_view_sp_to_be_tkn`;

CREATE TABLE `hr_view_sp_to_be_tkn` (
  `SPECIAL_UNPAID_LEAVE_TAKEN_ID` tinyint(4) NOT NULL,
  `LEAVE_APPLICATION_ID` tinyint(4) NOT NULL,
  `SCHEDULED_ID` tinyint(4) NOT NULL,
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `TAKEN_DATE` tinyint(4) NOT NULL,
  `TAKEN_QTY` tinyint(4) NOT NULL,
  `TAKEN_STATUS` tinyint(4) NOT NULL,
  `TAKEN_FROM_STATUS` tinyint(4) NOT NULL,
  `TAKEN_FINNISH_DATE` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_special_leave` */

DROP TABLE IF EXISTS `hr_view_special_leave`;

CREATE TABLE `hr_view_special_leave` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `DOC_STATUS` tinyint(4) NOT NULL,
  `SCHEDULED_ID` tinyint(4) NOT NULL,
  `TAKEN_QTY` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_stock_al_aktif` */

DROP TABLE IF EXISTS `hr_view_stock_al_aktif`;

CREATE TABLE `hr_view_stock_al_aktif` (
  `AL_STOCK_ID` tinyint(4) NOT NULL,
  `LEAVE_PERIOD_ID` tinyint(4) NOT NULL,
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `OWNING_DATE` tinyint(4) NOT NULL,
  `OPENING` tinyint(4) NOT NULL,
  `PREV_BALANCE` tinyint(4) NOT NULL,
  `AL_QTY` tinyint(4) NOT NULL,
  `QTY_USED` tinyint(4) NOT NULL,
  `QTY_RESIDUE` tinyint(4) NOT NULL,
  `AL_STATUS` tinyint(4) NOT NULL,
  `NOTE` tinyint(4) NOT NULL,
  `ENTITLED` tinyint(4) NOT NULL,
  `RECORD_DATE` tinyint(4) NOT NULL,
  `ENTITLE_DATE` tinyint(4) NOT NULL,
  `COMMENCING_DATE_HAVE` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_sum_stock_expired` */

DROP TABLE IF EXISTS `hr_view_sum_stock_expired`;

CREATE TABLE `hr_view_sum_stock_expired` (
  `LL_STOCK_ID` tinyint(4) NOT NULL,
  `EXPD_QTY` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `hr_warning` */

DROP TABLE IF EXISTS `hr_warning`;

CREATE TABLE `hr_warning` (
  `WARNING_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `BREAK_FACT` text DEFAULT NULL,
  `BREAK_DATE` date DEFAULT NULL,
  `WARN_BY` varchar(50) DEFAULT NULL,
  `WARN_DATE` date DEFAULT NULL,
  `VALID_UNTIL` date DEFAULT NULL,
  `WARN_LEVEL_ID` bigint(20) DEFAULT 0,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`WARNING_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_warning_reprimand_ayat` */

DROP TABLE IF EXISTS `hr_warning_reprimand_ayat`;

CREATE TABLE `hr_warning_reprimand_ayat` (
  `AYAT_ID` bigint(20) NOT NULL,
  `AYAT_TITLE` varchar(128) DEFAULT NULL,
  `AYAT_DESCRIPTION` text DEFAULT NULL,
  `PASAL_ID` bigint(20) DEFAULT NULL,
  `AYAT_PAGE` int(10) DEFAULT NULL,
  PRIMARY KEY (`AYAT_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_warning_reprimand_bab` */

DROP TABLE IF EXISTS `hr_warning_reprimand_bab`;

CREATE TABLE `hr_warning_reprimand_bab` (
  `BAB_ID` bigint(20) NOT NULL,
  `BAB_TITLE` text DEFAULT NULL,
  PRIMARY KEY (`BAB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `hr_warning_reprimand_pasal` */

DROP TABLE IF EXISTS `hr_warning_reprimand_pasal`;

CREATE TABLE `hr_warning_reprimand_pasal` (
  `PASAL_ID` bigint(20) NOT NULL,
  `PASAL_TITLE` varchar(128) DEFAULT NULL,
  `BAB_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PASAL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `hr_work_history_now` */

DROP TABLE IF EXISTS `hr_work_history_now`;

CREATE TABLE `hr_work_history_now` (
  `WORK_HISTORY_NOW_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT 0,
  `COMPANY` varchar(100) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT` varchar(132) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `POSITION` varchar(132) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `SECTION` varchar(132) DEFAULT NULL,
  `WORK_FROM` date DEFAULT NULL,
  `WORK_TO` date DEFAULT NULL,
  `SALARY` decimal(11,2) DEFAULT 0.00,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `EMP_CATEGORY_ID` bigint(20) NOT NULL,
  `EMP_CATEGORY` varchar(50) NOT NULL,
  `STATUS` varchar(64) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DIVISION` varchar(132) DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `LEVEL` varchar(64) DEFAULT NULL,
  `LOCATION_ID` bigint(20) DEFAULT NULL,
  `LOCATION` varchar(150) DEFAULT NULL,
  `NOTE` text DEFAULT NULL,
  `PROVIDER_ID` bigint(20) DEFAULT NULL,
  `HISTORY_TYPE` int(2) DEFAULT NULL,
  `NOMOR_SK` varchar(64) DEFAULT NULL,
  `TANGGAL_SK` date DEFAULT NULL,
  `EMP_DOC_ID` bigint(20) DEFAULT NULL,
  `HISTORY_GROUP` int(2) DEFAULT NULL,
  `GRADE_LEVEL_ID` bigint(20) NOT NULL,
  `CONTRACT_FROM` date DEFAULT NULL,
  `CONTRACT_TO` date DEFAULT NULL,
  PRIMARY KEY (`WORK_HISTORY_NOW_ID`),
  KEY `EMPLOYEE_ID` (`EMPLOYEE_ID`,`WORK_TO`),
  KEY `WORK_FROM` (`WORK_FROM`,`WORK_TO`),
  KEY `HISTORY_GROUP` (`HISTORY_GROUP`),
  KEY `HISTORY_TYPE` (`HISTORY_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `hr_work_history_past` */

DROP TABLE IF EXISTS `hr_work_history_past`;

CREATE TABLE `hr_work_history_past` (
  `WORK_HISTORY_PAST_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `COMPANY_NAME` varchar(100) DEFAULT NULL,
  `START_DATE` int(11) DEFAULT NULL,
  `END_DATE` int(11) DEFAULT NULL,
  `POSITION` varchar(100) DEFAULT NULL,
  `MOVE_REASON` text DEFAULT NULL,
  `PROVIDER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`WORK_HISTORY_PAST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `karyawan` */

DROP TABLE IF EXISTS `karyawan`;

CREATE TABLE `karyawan` (
  `CardID` varchar(20) DEFAULT NULL,
  `Nama` varchar(200) DEFAULT NULL,
  `KodeDiv` varchar(10) DEFAULT NULL,
  `KodeSDiv` varchar(10) DEFAULT NULL,
  `Shift` tinyint(1) NOT NULL DEFAULT 0,
  `Status_Kerja` varchar(50) DEFAULT NULL,
  `Pin` varchar(50) DEFAULT NULL,
  `Tgl_Valid` datetime DEFAULT NULL,
  `Spv` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `CardID` (`CardID`),
  KEY `Tgl_Valid` (`Tgl_Valid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `list_email` */

DROP TABLE IF EXISTS `list_email`;

CREATE TABLE `list_email` (
  `Name` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `employee_num` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `location` */

DROP TABLE IF EXISTS `location`;

CREATE TABLE `location` (
  `LOCATION_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(192) DEFAULT NULL,
  `CONTACT_ID` double DEFAULT 0,
  `DESCRIPTION` blob DEFAULT NULL,
  `CODE` varchar(54) DEFAULT NULL,
  `ADDRESS` varchar(192) DEFAULT NULL,
  `TELEPHONE` varchar(45) DEFAULT NULL,
  `FAX` varchar(45) DEFAULT NULL,
  `PERSON` varchar(150) DEFAULT NULL,
  `EMAIL` varchar(120) DEFAULT NULL,
  `TYPE` tinyint(4) DEFAULT NULL,
  `WEBSITE` varchar(120) DEFAULT NULL,
  `LOC_INDEX` double DEFAULT 0,
  `PARENT_ID` double DEFAULT 0,
  `SERVICE_PERCENTAGE` double DEFAULT 0,
  `TAX_PERCENTAGE` double DEFAULT 0,
  `DEPARTMENT_ID` double DEFAULT 0,
  `USED_VALUE` double DEFAULT 0,
  `SERVICE_VALUE` double DEFAULT 0,
  `TAX_VALUE` double DEFAULT 0,
  `SERVICE_VALUE_USD` double DEFAULT 0,
  `TAX_VALUE_USD` double DEFAULT 0,
  `REPORT_GROUP` double DEFAULT 0,
  `TAX_SVC_DEFAULT` double DEFAULT 0,
  `PERSENTASE_DISTRIBUTION_PURCHASE_ORDER` double DEFAULT 0,
  `COMPANY_ID` bigint(20) DEFAULT 0,
  `COLOR_LOCATION` varchar(30) DEFAULT NULL,
  `SUB_REGENCY_ID` bigint(20) DEFAULT 0,
  PRIMARY KEY (`LOCATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `logger` */

DROP TABLE IF EXISTS `logger`;

CREATE TABLE `logger` (
  `DATE_CREATED` datetime DEFAULT NULL,
  `TIME_CREATED` datetime DEFAULT NULL,
  `TARGET1_NOTE` text DEFAULT NULL,
  `TARGET2_NOTE` text DEFAULT NULL,
  `TARGET3_NOTE` text DEFAULT NULL,
  `LOGGER_ID` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `outlet_start` */

DROP TABLE IF EXISTS `outlet_start`;

CREATE TABLE `outlet_start` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `DEP` text DEFAULT NULL,
  `DEP_NAME` text DEFAULT NULL,
  `LOCATION` text DEFAULT NULL,
  `LOC_NAME` text DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_additional` */

DROP TABLE IF EXISTS `pay_additional`;

CREATE TABLE `pay_additional` (
  `SUM_ADD_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD_ID` bigint(20) DEFAULT 0,
  `SUMMARY_NAME` varchar(100) DEFAULT '',
  `VALUE` double DEFAULT 0,
  PRIMARY KEY (`SUM_ADD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_banks` */

DROP TABLE IF EXISTS `pay_banks`;

CREATE TABLE `pay_banks` (
  `BANK_ID` bigint(20) NOT NULL DEFAULT 0,
  `BANK_NAME` varchar(64) NOT NULL DEFAULT '',
  `BRANCH` varchar(128) NOT NULL DEFAULT '',
  `ADDRESS` varchar(128) NOT NULL DEFAULT '',
  `SWIFT_CODE` varchar(20) DEFAULT NULL,
  `TEL` varchar(20) DEFAULT NULL,
  `FAX` varchar(20) DEFAULT NULL,
  UNIQUE KEY `XPKpay_banks` (`BANK_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_benefit_config` */

DROP TABLE IF EXISTS `pay_benefit_config`;

CREATE TABLE `pay_benefit_config` (
  `BENEFIT_CONFIG_ID` bigint(20) NOT NULL,
  `PERIOD_FROM` date DEFAULT NULL,
  `PERIOD_TO` date DEFAULT NULL,
  `CODE` varchar(8) CHARACTER SET latin1 DEFAULT NULL,
  `TITLE` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `DESCRIPTION` text CHARACTER SET latin1 DEFAULT NULL,
  `DISTRIBUTION_PART_1` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `DISTRIBUTION_PERCENT_1` int(3) DEFAULT NULL,
  `DISTRIBUTION_DESCRIPTION_1` text CHARACTER SET latin1 DEFAULT NULL,
  `DISTRIBUTION_TOTAL_1` int(1) DEFAULT NULL,
  `DISTRIBUTION_PART_2` varchar(128) CHARACTER SET latin1 DEFAULT NULL,
  `DISTRIBUTION_PERCENT_2` int(3) DEFAULT NULL,
  `DISTRIBUTION_DESCRIPTION_2` text CHARACTER SET latin1 DEFAULT NULL,
  `DISTRIBUTION_TOTAL_2` int(1) DEFAULT NULL,
  `EXCEPTION_NO_BY_CATEGORY` text CHARACTER SET latin1 DEFAULT NULL,
  `EXCEPTION_NO_BY_POSITION` text CHARACTER SET latin1 DEFAULT NULL,
  `EXCEPTION_NO_BY_PAYROLL` text CHARACTER SET latin1 DEFAULT NULL,
  `EXCEPTION_NO_BY_DIVISION` text CHARACTER SET latin1 DEFAULT NULL,
  `APPROVE_1_EMP_ID` bigint(20) DEFAULT NULL,
  `APPROVE_2_EMP_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`BENEFIT_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_benefit_config_deduction` */

DROP TABLE IF EXISTS `pay_benefit_config_deduction`;

CREATE TABLE `pay_benefit_config_deduction` (
  `DEDUCTION_ID` bigint(20) NOT NULL,
  `DEDUCTION_PERCENT` int(3) DEFAULT NULL,
  `DEDUCTION_DESCRIPTION` text CHARACTER SET latin1 DEFAULT NULL,
  `DEDUCTION_REFERENCE` bigint(20) DEFAULT NULL,
  `DEDUCTION_INDEX` int(2) DEFAULT NULL,
  `BENEFIT_CONFIG_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DEDUCTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_benefit_period` */

DROP TABLE IF EXISTS `pay_benefit_period`;

CREATE TABLE `pay_benefit_period` (
  `BENEFIT_PERIOD_ID` bigint(20) NOT NULL,
  `BENEFIT_CONFIG_ID` bigint(20) DEFAULT NULL,
  `PERIOD_FROM` date DEFAULT NULL,
  `PERIOD_TO` date DEFAULT NULL,
  `PERIOD_ID` bigint(20) DEFAULT NULL,
  `TOTAL_REVENUE` double(15,2) DEFAULT NULL,
  `PART_1_VALUE` double(15,2) DEFAULT NULL,
  `PART_1_TOTAL_DIVIDER` int(10) DEFAULT NULL,
  `PART_2_VALUE` double(15,2) DEFAULT NULL,
  `PART_2_TOTAL_DIVIDER` int(10) DEFAULT NULL,
  `APPROVE_1_EMP_ID` bigint(20) DEFAULT NULL,
  `APPROVE_1_DATE` date DEFAULT NULL,
  `APPROVE_2_EMP_ID` bigint(20) DEFAULT NULL,
  `APPROVE_2_DATE` date DEFAULT NULL,
  `CREATE_EMP_ID` bigint(20) DEFAULT NULL,
  `CREATE_EMP_DATE` date DEFAULT NULL,
  `DOC_STATUS` int(4) DEFAULT NULL,
  PRIMARY KEY (`BENEFIT_PERIOD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_benefit_period_deduction` */

DROP TABLE IF EXISTS `pay_benefit_period_deduction`;

CREATE TABLE `pay_benefit_period_deduction` (
  `BENEFIT_PERIOD_DEDUCTION_ID` bigint(20) NOT NULL,
  `DEDUCTION_ID` bigint(20) DEFAULT NULL,
  `DEDUCTION_RESULT` double(15,0) DEFAULT NULL,
  `BENEFIT_PERIOD_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`BENEFIT_PERIOD_DEDUCTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_benefit_period_emp` */

DROP TABLE IF EXISTS `pay_benefit_period_emp`;

CREATE TABLE `pay_benefit_period_emp` (
  `BENEFIT_PERIOD_EMP_ID` bigint(20) NOT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `AMOUNT_PART_1` double(15,2) DEFAULT NULL,
  `AMOUNT_PART_2` double(15,2) DEFAULT NULL,
  `LEVEL_CODE` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `LEVEL_POINT` int(4) DEFAULT NULL,
  `BENEFIT_PERIOD_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`BENEFIT_PERIOD_EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_benefit_period_history` */

DROP TABLE IF EXISTS `pay_benefit_period_history`;

CREATE TABLE `pay_benefit_period_history` (
  `BENEFIT_PERIOD_HISTORY_ID` bigint(20) NOT NULL,
  `BENEFIT_PERIOD_ID` bigint(20) NOT NULL,
  `BENEFIT_CONFIGURATION` varchar(128) CHARACTER SET latin1 NOT NULL,
  `PERIOD_FROM` varchar(64) CHARACTER SET latin1 NOT NULL,
  `PERIOD_TO` varchar(64) CHARACTER SET latin1 NOT NULL,
  `PAYROLL_PERIOD` varchar(16) CHARACTER SET latin1 NOT NULL,
  `TOTAL_REVENUE` double(15,2) NOT NULL,
  `DISTRIBUTION_VALUE` double(15,2) NOT NULL,
  `DISTRIBUTION_DESC_1` varchar(128) CHARACTER SET latin1 NOT NULL,
  `DISTRIBUTION_DESC_2` varchar(128) CHARACTER SET latin1 NOT NULL,
  `DISTRIBUTION_PERCENT_1` int(8) NOT NULL,
  `DISTRIBUTION_PERCENT_2` int(8) NOT NULL,
  `PART_1_TOTAL_DIVIDER` int(8) NOT NULL,
  `PART_2_TOTAL_DIVIDER` int(8) NOT NULL,
  `PART_1_VALUE` double(15,2) NOT NULL,
  `PART_2_VALUE` double(15,2) NOT NULL,
  `DOC_STATUS` varchar(16) CHARACTER SET latin1 NOT NULL,
  `APPROVE_1` varchar(128) CHARACTER SET latin1 NOT NULL,
  `APPROVE_2` varchar(128) CHARACTER SET latin1 NOT NULL,
  `CREATED_BY` varchar(128) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`BENEFIT_PERIOD_HISTORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_component` */

DROP TABLE IF EXISTS `pay_component`;

CREATE TABLE `pay_component` (
  `COMP_CODE` varchar(20) NOT NULL DEFAULT '',
  `COMP_TYPE` int(11) DEFAULT 0,
  `SORT_IDX` int(11) NOT NULL DEFAULT 0,
  `COMPONENT_ID` bigint(11) NOT NULL DEFAULT 0,
  `COMP_NAME` varchar(128) NOT NULL DEFAULT '',
  `YEAR_ACCUMLT` smallint(6) NOT NULL DEFAULT 0,
  `PAY_PERIOD` smallint(6) NOT NULL DEFAULT 0,
  `USED_IN_FORML` smallint(6) NOT NULL DEFAULT 0,
  `TAX_ITEM` int(11) DEFAULT NULL,
  `TYPE_TUNJANGAN` int(4) DEFAULT NULL,
  `PAYSLIP_GROUP_ID` bigint(20) DEFAULT NULL,
  `SHOW_PAYSLIP` int(2) DEFAULT 1 COMMENT '1= artinya yes,0= artinya no',
  `SHOW_IN_REPORTS` int(11) DEFAULT 0,
  `PROPORSIONAL_CALCULATE` int(2) DEFAULT 0,
  `TAX_RPT_GROUP` int(2) DEFAULT 0,
  `DECIMAL_FORMAT` int(2) DEFAULT 0,
  `SHOW_LOS_REPORT` int(2) DEFAULT 0,
  `SECOND_SLIP` int(2) DEFAULT 0,
  PRIMARY KEY (`COMP_CODE`),
  UNIQUE KEY `XPKpay_component` (`COMP_CODE`),
  KEY `IDX_PAY_COMP_CODE` (`COMP_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_component_coa_map` */

DROP TABLE IF EXISTS `pay_component_coa_map`;

CREATE TABLE `pay_component_coa_map` (
  `COMPONENT_COA_MAP_ID` bigint(20) NOT NULL,
  `FORMULA` varchar(255) NOT NULL,
  `GEN_ID` bigint(20) NOT NULL,
  `DIVISION_ID` bigint(20) NOT NULL,
  `DEPARTMENT_ID` bigint(20) NOT NULL,
  `SECTION_ID` bigint(20) NOT NULL,
  `ID_PERKIRAAN` bigint(20) NOT NULL,
  `NO_REKENING` varchar(64) DEFAULT NULL,
  `FORMULA_MIN` varchar(255) NOT NULL,
  PRIMARY KEY (`COMPONENT_COA_MAP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_component_in` */

DROP TABLE IF EXISTS `pay_component_in`;

CREATE TABLE `pay_component_in` (
  `comp_id` bigint(20) NOT NULL DEFAULT 0,
  `comp_code` varchar(100) DEFAULT '',
  `comp_name` varchar(100) DEFAULT '',
  PRIMARY KEY (`comp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_config_potongan` */

DROP TABLE IF EXISTS `pay_config_potongan`;

CREATE TABLE `pay_config_potongan` (
  `potongan_kredit_id` bigint(20) NOT NULL,
  `employee_id` bigint(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `component_id` bigint(20) DEFAULT NULL,
  `angsuran_perbulan` double DEFAULT NULL,
  `no_rekening` varchar(128) DEFAULT NULL,
  `valid_status` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`potongan_kredit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_deduction_history` */

DROP TABLE IF EXISTS `pay_deduction_history`;

CREATE TABLE `pay_deduction_history` (
  `DEDUCTION_HISTORY_ID` bigint(20) NOT NULL,
  `PERCEN` int(4) NOT NULL,
  `DESCRIPTION` text CHARACTER SET latin1 NOT NULL,
  `PERCEN_RESULT` double(16,2) NOT NULL,
  `DEDUCTION_RESULT` double(16,2) NOT NULL,
  `BENEFIT_PERIOD_HISTORY_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DEDUCTION_HISTORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_emp_level` */

DROP TABLE IF EXISTS `pay_emp_level`;

CREATE TABLE `pay_emp_level` (
  `EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `LEVEL_CODE` varchar(20) NOT NULL DEFAULT '',
  `START_DATE` date NOT NULL DEFAULT '0000-00-00',
  `BANK_ID` bigint(20) DEFAULT 0,
  `BANK_ACC_NR` varchar(20) DEFAULT NULL,
  `POS_FOR_TAX` varchar(20) DEFAULT NULL,
  `PAY_PER_BEGIN` int(11) DEFAULT NULL,
  `PAY_PER_END` int(11) DEFAULT NULL,
  `COMMENCING_ST` int(11) DEFAULT NULL,
  `PREV_INCOME` float DEFAULT NULL,
  `PREV_TAX_PAID` int(11) DEFAULT NULL,
  `PAY_EMP_LEVEL_ID` bigint(20) NOT NULL DEFAULT 0,
  `STATUS_DATA` int(4) DEFAULT NULL,
  `MEAL_ALLOWANCE` int(4) DEFAULT NULL,
  `OVT_IDX_TYPE` int(4) NOT NULL DEFAULT 0,
  `END_DATE` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`PAY_EMP_LEVEL_ID`),
  UNIQUE KEY `XPKpay_emp_level` (`EMPLOYEE_ID`,`LEVEL_CODE`,`START_DATE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_executives` */

DROP TABLE IF EXISTS `pay_executives`;

CREATE TABLE `pay_executives` (
  `EXECUTIVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAX_FORM` varchar(64) NOT NULL DEFAULT '',
  `EXECUTIVE_NAME` varchar(64) NOT NULL DEFAULT '',
  UNIQUE KEY `XPKpay_executives` (`EXECUTIVE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_general` */

DROP TABLE IF EXISTS `pay_general`;

CREATE TABLE `pay_general` (
  `GEN_ID` bigint(20) NOT NULL DEFAULT 0,
  `COMPANY` varchar(128) NOT NULL DEFAULT '',
  `COMP_ADDRESS` varchar(255) NOT NULL DEFAULT '',
  `CITY` varchar(64) NOT NULL DEFAULT '',
  `ZIP_CODE` varchar(20) NOT NULL DEFAULT '',
  `BUSSINESS_TYPE` varchar(64) NOT NULL DEFAULT '',
  `TAX_OFFICE` varchar(128) NOT NULL DEFAULT '',
  `REG_TAX_NR` varchar(20) NOT NULL DEFAULT '',
  `REG_TAX_BUS_NR` varchar(20) DEFAULT NULL,
  `REG_TAX_DATE` date NOT NULL DEFAULT '0000-00-00',
  `TEL` varchar(20) NOT NULL DEFAULT '',
  `FAX` varchar(20) DEFAULT NULL,
  `LEADER_NAME` varchar(20) DEFAULT NULL,
  `LEADER_POSITION` varchar(32) NOT NULL DEFAULT '',
  `TAX_REP_LOCATION` varchar(32) NOT NULL DEFAULT '',
  `TAX_YEAR` int(11) NOT NULL DEFAULT 0,
  `TAX_MONTH` tinyint(4) NOT NULL DEFAULT 0,
  `TAX_REP_DATE` int(11) NOT NULL DEFAULT 0,
  `TAX_PAID_PCT` double NOT NULL DEFAULT 0,
  `TAX_POS_COST_PCT` double NOT NULL DEFAULT 0,
  `TAX_POS_COST_MAX` float NOT NULL DEFAULT 0,
  `TAX_ROUND1000` smallint(6) NOT NULL DEFAULT 0,
  `TAX_CALC_MTD` smallint(6) NOT NULL DEFAULT 0,
  `NON_TAX_INCOME` float NOT NULL DEFAULT 0,
  `NON_TAX_WIFE` int(11) DEFAULT NULL,
  `NON_TAX_DEPNT` int(11) DEFAULT NULL,
  `TAX_FORM_SIGN_BY` smallint(6) NOT NULL DEFAULT 0,
  `LOCAL_CUR_CODE` varchar(20) DEFAULT NULL,
  `WORK_DAYS` int(4) DEFAULT NULL,
  `CODE_COMPANY` varchar(20) DEFAULT NULL,
  `COMPANY_PARENTS_ID` bigint(20) DEFAULT NULL,
  UNIQUE KEY `XPKpay_general` (`GEN_ID`),
  KEY `XIF1pay_general` (`LOCAL_CUR_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_input` */

DROP TABLE IF EXISTS `pay_input`;

CREATE TABLE `pay_input` (
  `PAY_INPUT_ID` bigint(20) NOT NULL DEFAULT 0,
  `PAY_SLIP_ID` bigint(20) DEFAULT 0,
  `PAY_INPUT_CODE` text DEFAULT NULL,
  `PAY_INPUT_VALUE` float DEFAULT 0,
  `PERIODE_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `DATE_ADJUMSENT` datetime DEFAULT NULL,
  PRIMARY KEY (`PAY_INPUT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_level_comp` */

DROP TABLE IF EXISTS `pay_level_comp`;

CREATE TABLE `pay_level_comp` (
  `LEVEL_CODE` varchar(20) NOT NULL DEFAULT '',
  `COMP_CODE` varchar(20) NOT NULL DEFAULT '',
  `FORMULA` text NOT NULL,
  `SORT_IDX` int(11) NOT NULL DEFAULT 0,
  `PAY_PERIOD` smallint(6) NOT NULL DEFAULT 0,
  `TAKE_HOME_PAY` int(11) NOT NULL DEFAULT 0,
  `COPY_DATA` smallint(6) NOT NULL DEFAULT 0,
  `COMPONENT_ID` bigint(20) DEFAULT NULL,
  `PAY_LEVEL_COM_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`PAY_LEVEL_COM_ID`),
  KEY `XIF2pay_level_comp` (`LEVEL_CODE`),
  KEY `XIF3pay_level_comp` (`COMP_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_ovt_empl_idx` */

DROP TABLE IF EXISTS `pay_ovt_empl_idx`;

CREATE TABLE `pay_ovt_empl_idx` (
  `OVT_IDX_ID` bigint(20) NOT NULL DEFAULT 0,
  `OVT_EMPLY_ID` bigint(20) NOT NULL DEFAULT 0,
  `VALUE_IDX` double NOT NULL DEFAULT 0,
  UNIQUE KEY `XPKpay_ovt_empl_idx` (`OVT_IDX_ID`,`OVT_EMPLY_ID`),
  KEY `XIF1pay_ovt_empl_idx` (`OVT_IDX_ID`),
  KEY `XIF2pay_ovt_empl_idx` (`OVT_EMPLY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_ovt_employee` */

DROP TABLE IF EXISTS `pay_ovt_employee`;

CREATE TABLE `pay_ovt_employee` (
  `OVT_EMPLY_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_NUM` varchar(20) NOT NULL DEFAULT '',
  `WORK_DATE` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `STD_WORK_SCHDL` varchar(20) DEFAULT NULL,
  `OVT_START` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `OVT_END` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `OVT_DURATION` double NOT NULL DEFAULT 0,
  `OVT_DOC_NR` varchar(20) DEFAULT NULL,
  `STATUS` int(11) NOT NULL DEFAULT 0,
  `PAY_SLIP_ID` bigint(20) DEFAULT NULL,
  `TOT_IDX` double DEFAULT NULL,
  `OVT_CODE` varchar(20) DEFAULT NULL,
  UNIQUE KEY `XPKpay_ovt_employee` (`OVT_EMPLY_ID`),
  KEY `XIF1pay_ovt_employee` (`PERIOD_ID`),
  KEY `XIF2pay_ovt_employee` (`PAY_SLIP_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_ovt_idx` */

DROP TABLE IF EXISTS `pay_ovt_idx`;

CREATE TABLE `pay_ovt_idx` (
  `OVT_IDX_ID` bigint(20) NOT NULL DEFAULT 0,
  `HOUR_FROM` double NOT NULL DEFAULT 0,
  `HOUR_TO` double NOT NULL DEFAULT 0,
  `OVT_IDX` double NOT NULL DEFAULT 0,
  `OVT_TYPE_CODE` varchar(20) DEFAULT NULL,
  UNIQUE KEY `XPKpay_ovt_idx` (`OVT_IDX_ID`),
  KEY `XIF1pay_ovt_idx` (`OVT_TYPE_CODE`),
  CONSTRAINT `FK_pay_ovt_idx` FOREIGN KEY (`OVT_TYPE_CODE`) REFERENCES `pay_ovt_type` (`OVT_TYPE_CODE`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_ovt_type` */

DROP TABLE IF EXISTS `pay_ovt_type`;

CREATE TABLE `pay_ovt_type` (
  `OVT_TYPE_CODE` varchar(20) NOT NULL DEFAULT '',
  `OVT_TYPE_ID` bigint(20) DEFAULT NULL,
  `TYPE_OF_DAY` int(11) NOT NULL DEFAULT 0,
  `DESCRIPTION` varchar(128) NOT NULL DEFAULT '',
  `STD_WORK_HOUR_BEGIN` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `STD_WORK_HOUR_END` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `OWRITE_BY_SCHDL` int(11) NOT NULL DEFAULT 0,
  `EMP_LEVEL_MIN` int(11) DEFAULT 0,
  `EMP_LEVEL_MAX` int(11) DEFAULT 0,
  `MASTER_LEVEL_ID_MIN` bigint(20) DEFAULT NULL,
  `MASTER_LEVEL_ID_MAX` bigint(20) DEFAULT NULL,
  UNIQUE KEY `XPKpay_ovt_type` (`OVT_TYPE_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_payslip_group` */

DROP TABLE IF EXISTS `pay_payslip_group`;

CREATE TABLE `pay_payslip_group` (
  `PAYSLIP_GROUP_ID` bigint(20) NOT NULL DEFAULT 0,
  `PAYSLIP_GROUP_NAME` varchar(30) DEFAULT NULL,
  `PAYSLIP_GROUP_DESC` varchar(50) DEFAULT NULL,
  `SHOW_ALL` int(2) DEFAULT 0,
  PRIMARY KEY (`PAYSLIP_GROUP_ID`),
  UNIQUE KEY `IdxNameUNQ` (`PAYSLIP_GROUP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_period` */

DROP TABLE IF EXISTS `pay_period`;

CREATE TABLE `pay_period` (
  `PERIOD_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD` varchar(64) NOT NULL DEFAULT '',
  `START_DATE` date NOT NULL DEFAULT '0000-00-00',
  `END_DATE` date NOT NULL DEFAULT '0000-00-00',
  `WORK_DAYS` int(11) DEFAULT 25,
  `PAY_SLIP_DATE` date DEFAULT '2008-01-01',
  `MIN_REG_WAGE` float DEFAULT 0 COMMENT 'UMR (UPAH MINIMUM REGIONAL)',
  `PAY_PROCESS` tinyint(4) DEFAULT 0,
  `PAY_PROC_BY` varchar(20) DEFAULT '0',
  `PAY_PROC_DATE` date DEFAULT '2008-01-01',
  `PAY_PROCESS_CLOSE` tinyint(4) DEFAULT 0,
  `PAY_PROC_BY_CLOSE` varchar(20) DEFAULT '-',
  `PAY_PROC_DATE_CLOSE` date DEFAULT '2008-01-01',
  `TAX_IS_PAID` int(4) DEFAULT 0,
  `FIRST_PERIOD_OF_THE_YEAR` int(2) DEFAULT 0,
  PRIMARY KEY (`PERIOD_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_sal_level` */

DROP TABLE IF EXISTS `pay_sal_level`;

CREATE TABLE `pay_sal_level` (
  `LEVEL_CODE` varchar(20) NOT NULL DEFAULT '',
  `SAL_LEVEL_ID` bigint(20) NOT NULL DEFAULT 0,
  `SORT_IDX` int(11) NOT NULL DEFAULT 0,
  `LEVEL_NAME` varchar(64) NOT NULL DEFAULT '',
  `AMOUNT_IS` smallint(6) DEFAULT NULL,
  `CUR_CODE` varchar(20) DEFAULT NULL,
  `SALARY_LEVEL_STATUS` int(2) DEFAULT 0,
  `LEVEL_ASSIGN` bigint(20) DEFAULT 0,
  `SALARY_LEVEL_NOTE` text DEFAULT NULL,
  UNIQUE KEY `XPKpay_sal_level` (`LEVEL_CODE`),
  KEY `XIF1pay_sal_level` (`CUR_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_simulation` */

DROP TABLE IF EXISTS `pay_simulation`;

CREATE TABLE `pay_simulation` (
  `PAY_SIMULATION_ID` bigint(20) NOT NULL,
  `TITLE` varchar(128) NOT NULL,
  `OBJECTIVES` varchar(512) DEFAULT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `CREATED_BY_ID` bigint(20) DEFAULT NULL,
  `REQUEST_DATE` datetime DEFAULT NULL,
  `REQUEST_BY_ID` bigint(20) DEFAULT NULL,
  `DUE_DATE` datetime DEFAULT NULL,
  `STATUS_DOC` int(11) DEFAULT NULL,
  `MAX_TOTAL_BUDGET` double DEFAULT NULL,
  `MAX_ADD_EMPL` int(11) DEFAULT NULL,
  `SOURCE_PAY_PERIOD_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PAY_SIMULATION_ID`),
  KEY `fk_pay_simulation_hr_employee1_idx` (`CREATED_BY_ID`),
  KEY `fk_pay_simulation_hr_employee2_idx` (`REQUEST_BY_ID`),
  KEY `fk_pay_simulation_pay_period1_idx` (`SOURCE_PAY_PERIOD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_simulation_filter` */

DROP TABLE IF EXISTS `pay_simulation_filter`;

CREATE TABLE `pay_simulation_filter` (
  `SIMULATION_FILTER_ID` bigint(20) NOT NULL,
  `PAY_SIMULATION_ID` bigint(20) NOT NULL,
  `FILTER_NAME` varchar(64) DEFAULT NULL,
  `FILTER_TYPE` int(11) DEFAULT NULL COMMENT '0=NUMBER BIGINT\n1=NUMBER DOUBLE\n2=TEXT/STRING\n3=DATE',
  `FILTER_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`SIMULATION_FILTER_ID`),
  KEY `fk_pay_simulation_filter_pay_simulation1_idx` (`PAY_SIMULATION_ID`),
  CONSTRAINT `fk_pay_simulation_filter_pay_simulation1` FOREIGN KEY (`PAY_SIMULATION_ID`) REFERENCES `pay_simulation` (`PAY_SIMULATION_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_simulation_struct` */

DROP TABLE IF EXISTS `pay_simulation_struct`;

CREATE TABLE `pay_simulation_struct` (
  `SIMULATION_STRUCT_ID` bigint(20) NOT NULL,
  `PAY_SIMULATION_ID` bigint(20) NOT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `SAL_LEVEL_ID` bigint(20) DEFAULT NULL,
  `LEVEL_CODE` varchar(20) DEFAULT NULL,
  `COMPONENT_ID` bigint(11) DEFAULT NULL,
  `COMP_CODE` varchar(20) DEFAULT NULL,
  `EMP_COUNT_IN_PRD` int(11) DEFAULT NULL,
  `SALARY_AMOUNT` double DEFAULT NULL,
  `NEW_EMP_ADD` int(11) DEFAULT NULL,
  `SALARY_AMOUNT_ADD` double DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SIMULATION_STRUCT_ID`),
  KEY `fk_pay_simulation_struct_pay_simulation1_idx` (`PAY_SIMULATION_ID`),
  KEY `fk_pay_simulation_struct_pay_general1_idx` (`COMPANY_ID`),
  KEY `fk_pay_simulation_struct_hr_division1_idx` (`DIVISION_ID`),
  KEY `fk_pay_simulation_struct_hr_department1_idx` (`DEPARTMENT_ID`),
  KEY `fk_pay_simulation_struct_hr_section1_idx` (`SECTION_ID`),
  KEY `fk_pay_simulation_struct_pay_sal_level1_idx` (`SAL_LEVEL_ID`,`LEVEL_CODE`),
  KEY `fk_pay_simulation_struct_pay_component1_idx` (`COMPONENT_ID`,`COMP_CODE`),
  CONSTRAINT `fk_pay_simulation_struct_pay_simulation1` FOREIGN KEY (`PAY_SIMULATION_ID`) REFERENCES `pay_simulation` (`PAY_SIMULATION_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_slip` */

DROP TABLE IF EXISTS `pay_slip`;

CREATE TABLE `pay_slip` (
  `PAY_SLIP_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERIOD_ID` bigint(20) DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `STATUS` int(11) NOT NULL DEFAULT 0,
  `PAID_STATUS` int(11) NOT NULL DEFAULT 0,
  `PAY_SLIP_DATE` date NOT NULL DEFAULT '0000-00-00',
  `DAY_PRESENT` double NOT NULL DEFAULT 0,
  `DAY_PAID_LV` double DEFAULT 0,
  `DAY_ABSENT` double DEFAULT 0,
  `DAY_UNPAID_LV` double DEFAULT 0,
  `DIVISION` varchar(100) DEFAULT NULL,
  `DEPARTMENT` varchar(100) DEFAULT NULL,
  `POSITION` varchar(100) DEFAULT NULL,
  `SECTION` varchar(100) DEFAULT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `COMMENC_DATE` date NOT NULL DEFAULT '0000-00-00',
  `PAYMENT_TYPE` bigint(20) NOT NULL DEFAULT 0,
  `BANK_ID` bigint(20) DEFAULT 0,
  `PAY_SLIP_TYPE` int(11) NOT NULL DEFAULT 0,
  `COMP_CODE` varchar(64) DEFAULT NULL,
  `DAY_LATE` double DEFAULT 0,
  `PROCENTASE_PRESENCE` double DEFAULT 0,
  `DAY_OFF_SCHEDULE` double DEFAULT 0,
  `TOTAL_DAY_OFF_OVERTIME` double DEFAULT 0,
  `INSENTIF` double DEFAULT 0,
  `DATE_OK_WITH_LEAVE` double DEFAULT 0,
  `OV_IDX_ADJUSTMENT` double DEFAULT 0,
  `PRIVATE_NOTE` text DEFAULT NULL,
  `MEAL_ALLOWANCE_MONEY` double DEFAULT 0,
  `MEAL_ALLOWANCE_MONEY_ADJUSMENT` double DEFAULT 0,
  `OVERTIME_IDX` double DEFAULT 0,
  `NOTE_ADMIN` varchar(100) DEFAULT NULL,
  `OV_IDX_PAID_SALARY_ADJUSMENT_DATE` datetime DEFAULT NULL COMMENT 'UNTUK DATE DARI ADJUMENT OVERTIME IDX PAID SALARY, TANGGAL INI AKAN LANGSUNG DI RUBAH TERUS, T JIKA ADA UPDATE',
  `OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE` datetime DEFAULT NULL COMMENT 'UNTUK DATE DARI ADJUMENT OVERTIME ALLOWANCE MONET, TANGGAL INI AKAN LANGSUNG DI RUBAH TERUS, T JIKA ADA UPDATE',
  `NIGHT_ALLOWANCE` int(2) DEFAULT NULL,
  `TRANSPORT_ALLOWANCE` int(2) DEFAULT NULL,
  `GRADE_CODE` varchar(30) DEFAULT NULL,
  UNIQUE KEY `XPKpay_slip` (`PAY_SLIP_ID`),
  KEY `XIF1pay_slip` (`PERIOD_ID`),
  KEY `XIF2pay_slip` (`EMPLOYEE_ID`),
  KEY `XIF3pay_slip` (`BANK_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_slip_comp` */

DROP TABLE IF EXISTS `pay_slip_comp`;

CREATE TABLE `pay_slip_comp` (
  `PAY_SLIP_ID` bigint(20) NOT NULL DEFAULT 0,
  `COMP_CODE` varchar(64) NOT NULL DEFAULT '',
  `COMP_VALUE` double DEFAULT 0,
  `PAY_SLIP_COMP_ID` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`PAY_SLIP_COMP_ID`),
  UNIQUE KEY `XPKpay_slip_comp` (`PAY_SLIP_ID`,`COMP_CODE`,`PAY_SLIP_COMP_ID`),
  KEY `XIF2pay_slip_comp` (`PAY_SLIP_ID`),
  KEY `XIF3pay_slip_comp` (`COMP_CODE`),
  KEY `IDX_PAY_SLIP_ID_COMP` (`PAY_SLIP_ID`,`COMP_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_slip_note` */

DROP TABLE IF EXISTS `pay_slip_note`;

CREATE TABLE `pay_slip_note` (
  `PAY_SLIP_NOTE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PAY_SLIP_NOTE_DATE` datetime DEFAULT NULL,
  `PAY_SLIP_NOTE_PERIODE` bigint(20) DEFAULT 0,
  `PAY_SLIP_ID` bigint(20) DEFAULT 0,
  `PAY_SLIP_EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `PAY_SLIP_NOTE` text DEFAULT NULL,
  PRIMARY KEY (`PAY_SLIP_NOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `pay_slip_param` */

DROP TABLE IF EXISTS `pay_slip_param`;

CREATE TABLE `pay_slip_param` (
  `PAY_SLIP_ID` bigint(20) NOT NULL,
  `PARAMETER_NAME` varchar(128) NOT NULL,
  `PARAMETER_VALUE` double(30,6) DEFAULT NULL,
  `NOTE` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`PAY_SLIP_ID`,`PARAMETER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pay_tax_item_code` */

DROP TABLE IF EXISTS `pay_tax_item_code`;

CREATE TABLE `pay_tax_item_code` (
  `TAX_ITEM_CODE` varchar(20) NOT NULL DEFAULT '',
  `TAX_CODE` varchar(20) NOT NULL DEFAULT '',
  `TAX_ITEM_CD_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAX_ITEM_NAME` varchar(64) NOT NULL DEFAULT '',
  UNIQUE KEY `XPKpay_tax_item_code` (`TAX_ITEM_CODE`,`TAX_CODE`),
  KEY `XIF1pay_tax_item_code` (`TAX_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_tax_tariff` */

DROP TABLE IF EXISTS `pay_tax_tariff`;

CREATE TABLE `pay_tax_tariff` (
  `TAX_TARIFF_ID` bigint(20) NOT NULL DEFAULT 0,
  `TAX_YEAR` int(11) NOT NULL DEFAULT 0,
  `LEVEL` varchar(20) NOT NULL DEFAULT '',
  `SALARY_MIN` float NOT NULL DEFAULT 0,
  `SALARY_MAX` int(11) NOT NULL DEFAULT 0,
  `TAX_TARIFF` double NOT NULL DEFAULT 0,
  UNIQUE KEY `XPKpay_tax_tariff` (`TAX_TARIFF_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_tax_type` */

DROP TABLE IF EXISTS `pay_tax_type`;

CREATE TABLE `pay_tax_type` (
  `TAX_CODE` varchar(20) NOT NULL DEFAULT '',
  `TAX_TYPE_ID` bigint(20) DEFAULT NULL,
  `TAX_TYPE` varchar(64) NOT NULL DEFAULT '',
  UNIQUE KEY `XPKpay_tax_type` (`TAX_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `pay_value_mapping` */

DROP TABLE IF EXISTS `pay_value_mapping`;

CREATE TABLE `pay_value_mapping` (
  `VALUE_MAPPING_ID` bigint(20) DEFAULT NULL,
  `COMP_CODE` varchar(30) DEFAULT NULL,
  `PARAMETER` varchar(400) DEFAULT NULL,
  `NUMBER_OF_MAPS` int(4) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `COMPANY_ID` bigint(20) DEFAULT NULL,
  `DIVISION_ID` bigint(20) DEFAULT NULL,
  `DEPARTMENT_ID` bigint(20) DEFAULT NULL,
  `SECTION_ID` bigint(20) DEFAULT NULL,
  `LEVEL_ID` bigint(20) DEFAULT NULL,
  `MARITAL_ID` bigint(20) DEFAULT NULL,
  `LENGTH_OF_SERVICE` float(10,2) DEFAULT NULL,
  `EMPLOYEE_CATEGORY` bigint(20) DEFAULT NULL,
  `POSITION_ID` bigint(20) DEFAULT NULL,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `ADDR_COUNTRY_ID` bigint(20) DEFAULT NULL,
  `ADDR_PROVINCE_ID` bigint(20) DEFAULT NULL,
  `ADDR_REGENCY_ID` bigint(20) DEFAULT NULL,
  `ADDR_SUBREGENCY_ID` bigint(20) DEFAULT NULL,
  `VALUE` double(30,6) DEFAULT NULL,
  `GRADE` bigint(20) DEFAULT NULL,
  `SEX` int(3) DEFAULT -1,
  `STATUS` int(2) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `payroll` */

DROP TABLE IF EXISTS `payroll`;

CREATE TABLE `payroll` (
  `PAYROOL_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT NULL,
  `PREPARED_BY` varchar(64) DEFAULT NULL,
  `WORKING_DAY` int(11) DEFAULT NULL,
  `WORKING_HOUR` int(11) DEFAULT NULL,
  `BASIC_SALARY` decimal(10,2) DEFAULT NULL,
  `STATUS` int(11) DEFAULT NULL,
  `EMPLOYEE_APPROVE` tinyint(4) DEFAULT NULL,
  `OPERATOR` varchar(64) DEFAULT NULL,
  `SPSI_DEDUCTION` decimal(10,2) DEFAULT NULL,
  `PPH_DEDUCTION` decimal(10,2) DEFAULT NULL,
  `TRANSPORT_ALLOWANCE` decimal(10,2) DEFAULT NULL,
  `SERVICE_ALLOWANCE` decimal(10,2) DEFAULT NULL,
  `MEAL_ALLOWANCE` decimal(10,2) DEFAULT NULL,
  `INCENTIVE_OVER_TIME` decimal(10,2) DEFAULT NULL,
  `JAMSOSTEK` decimal(10,2) DEFAULT NULL,
  `OTHER_DEDUCTION` decimal(10,2) DEFAULT NULL,
  `OTHER_INCOME` decimal(10,2) DEFAULT NULL,
  `INCOME_NOTE` text DEFAULT NULL,
  `DEDUCTION_NOTE` text DEFAULT NULL,
  PRIMARY KEY (`PAYROOL_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `payroll_allow_amount` */

DROP TABLE IF EXISTS `payroll_allow_amount`;

CREATE TABLE `payroll_allow_amount` (
  `PAYROLL_ALLOW_AMOUNT` bigint(20) NOT NULL DEFAULT 0,
  `LEVEL_ID` bigint(20) DEFAULT 0,
  `TYPE` int(11) DEFAULT NULL,
  `NAME` varchar(64) DEFAULT NULL,
  `AMOUNT` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`PAYROLL_ALLOW_AMOUNT`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `payroll_deduction` */

DROP TABLE IF EXISTS `payroll_deduction`;

CREATE TABLE `payroll_deduction` (
  `DEDUCTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `NAME` varchar(64) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `STATUS` int(11) DEFAULT NULL,
  `PPH_DEDUCTION` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`DEDUCTION_ID`),
  UNIQUE KEY `XPKPAYROOL_DEDUCTION` (`DEDUCTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `payroll_deduction_value` */

DROP TABLE IF EXISTS `payroll_deduction_value`;

CREATE TABLE `payroll_deduction_value` (
  `PAYROOL_ID` bigint(20) NOT NULL DEFAULT 0,
  `DEDUCTION_ID` bigint(20) NOT NULL DEFAULT 0,
  `PERCENTAGE` decimal(10,2) DEFAULT NULL,
  `AMOUNT` decimal(10,2) DEFAULT NULL,
  `VALUE_USED` int(11) DEFAULT NULL,
  PRIMARY KEY (`PAYROOL_ID`,`DEDUCTION_ID`),
  UNIQUE KEY `XPKPAYROOL_DEDUCTION_VALUE` (`PAYROOL_ID`,`DEDUCTION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `payroll_group` */

DROP TABLE IF EXISTS `payroll_group`;

CREATE TABLE `payroll_group` (
  `PAYROLL_GROUP_ID` bigint(20) NOT NULL,
  `PAYROLL_GROUP_NAME` varchar(100) DEFAULT NULL,
  `PAYROLL_GROUP_DESCRIPTION` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PAYROLL_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `sum_al_tb_taken_by_emp` */

DROP TABLE IF EXISTS `sum_al_tb_taken_by_emp`;

CREATE TABLE `sum_al_tb_taken_by_emp` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `AL_TB_TKN` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sum_dp_tb_taken_by_emp` */

DROP TABLE IF EXISTS `sum_dp_tb_taken_by_emp`;

CREATE TABLE `sum_dp_tb_taken_by_emp` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `DT_TB_TKN` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sum_ll_tb_taken_by_emp` */

DROP TABLE IF EXISTS `sum_ll_tb_taken_by_emp`;

CREATE TABLE `sum_ll_tb_taken_by_emp` (
  `EMPLOYEE_ID` tinyint(4) NOT NULL,
  `LL_TB_TKN` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `system_log` */

DROP TABLE IF EXISTS `system_log`;

CREATE TABLE `system_log` (
  `LOG_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOG_DATE` datetime DEFAULT '0000-00-00 00:00:00',
  `LOG_SYSMODE` varchar(100) DEFAULT NULL,
  `LOG_CATEGORY` int(11) DEFAULT 0,
  `LOG_NOTE` text DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `tb_company_picture` */

DROP TABLE IF EXISTS `tb_company_picture`;

CREATE TABLE `tb_company_picture` (
  `PICTURE_COMPANY_ID` bigint(20) NOT NULL,
  `NAMA_PICTURE` text COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`PICTURE_COMPANY_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `tb_detail_public_leave` */

DROP TABLE IF EXISTS `tb_detail_public_leave`;

CREATE TABLE `tb_detail_public_leave` (
  `DETAIL_PUBLIC_LEAVE` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_ID` bigint(20) DEFAULT 0,
  `TYPE_LEAVE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`DETAIL_PUBLIC_LEAVE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `tb_picture_background` */

DROP TABLE IF EXISTS `tb_picture_background`;

CREATE TABLE `tb_picture_background` (
  `PICTURE_BACKGROUND_ID` bigint(20) NOT NULL DEFAULT 0,
  `LOGIN_ID` bigint(20) DEFAULT 0,
  `NAMA_PICTURE` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `KETERANGAN_PICTURE` text COLLATE latin1_general_ci DEFAULT NULL,
  `PICTURE` text COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`PICTURE_BACKGROUND_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `tb_public_leave` */

DROP TABLE IF EXISTS `tb_public_leave`;

CREATE TABLE `tb_public_leave` (
  `PUBLIC_LEAVE_ID` bigint(20) NOT NULL DEFAULT 0,
  `PUBLIC_HOLIDAY_ID` bigint(20) DEFAULT 0,
  `DATE_FROM` datetime DEFAULT NULL,
  `DATE_TO` datetime DEFAULT NULL,
  `TYPE_LEAVE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`PUBLIC_LEAVE_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `tb_templatedinamis` */

DROP TABLE IF EXISTS `tb_templatedinamis`;

CREATE TABLE `tb_templatedinamis` (
  `TEMP_DINAMIS_ID` bigint(20) NOT NULL DEFAULT 0,
  `TEMP_VERSION_NO` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_COLOR` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_COLOR_HEADER` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_COLOR_CONTENT` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_BG_MENU` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_FONT_MENU` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_HOVER_MENU` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_NAVIGATION` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  `TEMP_LANGUAGE` bigint(20) DEFAULT NULL,
  `TEMP_COLOR_HEADER2` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `GARIS_HAEADER1` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `GARIS_HEADER2` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `GARIS_CONTENT` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `FOOTER_GARIS` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `FOOTER_BACKGROUND` varchar(30) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`TEMP_DINAMIS_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

/*Table structure for table `temp_data_list_custom_field` */

DROP TABLE IF EXISTS `temp_data_list_custom_field`;

CREATE TABLE `temp_data_list_custom_field` (
  `CUSTOM_FIELD_DATA_LIST_ID` bigint(20) NOT NULL,
  `DATA_LIST_CAPTION` varchar(128) NOT NULL,
  `DATA_LIST_VALUE` varchar(128) NOT NULL,
  `CUSTOM_FIELD_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`CUSTOM_FIELD_DATA_LIST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `transaction` */

DROP TABLE IF EXISTS `transaction`;

CREATE TABLE `transaction` (
  `CardID` varchar(10) DEFAULT NULL,
  `DateTrn` datetime DEFAULT NULL,
  `Posted` tinyint(3) unsigned DEFAULT NULL,
  `Station` char(2) DEFAULT NULL,
  `Mode` char(1) DEFAULT NULL,
  `HarismaSt` tinyint(3) unsigned DEFAULT NULL,
  KEY `TransactionCardID` (`CardID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `transfer_employee_outlet` */

DROP TABLE IF EXISTS `transfer_employee_outlet`;

CREATE TABLE `transfer_employee_outlet` (
  `TRANSFER_EMPLOYEE_ID` bigint(20) NOT NULL DEFAULT 0,
  `EMPLOYEE_NUM` varchar(30) DEFAULT NULL,
  `EMP_PIN` varchar(30) DEFAULT NULL,
  `EMPLOYEE_FULL_NAME` varchar(200) DEFAULT NULL,
  `STATUS_EMPLOYEE` int(3) DEFAULT 0 COMMENT '0=UNTUK AKTIV,1=NON_AKTIV,2=TRANSFER',
  `POSITION_ID` bigint(20) DEFAULT 0,
  `SCHEDULE_ID` bigint(20) DEFAULT 0,
  `DATE_CREATE_TRANSFER` datetime DEFAULT NULL,
  PRIMARY KEY (`TRANSFER_EMPLOYEE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `hr_view_emp_assessment` */

DROP TABLE IF EXISTS `hr_view_emp_assessment`;

/*!50001 DROP VIEW IF EXISTS `hr_view_emp_assessment` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_emp_assessment` */;

/*!50001 CREATE TABLE  `hr_view_emp_assessment`(
 `EMP_ASSESSMENT_ID` bigint(25) ,
 `EMPLOYEE_ID` bigint(25) ,
 `ASSESSMENT_ID` bigint(25) ,
 `SCORE` double ,
 `DATE_OF_ASSESSMENT` date ,
 `REMARK` varchar(255) ,
 `MAX_DATE_OF_ASSESSMENT` date 
)*/;

/*Table structure for table `hr_view_emp_assessment_max` */

DROP TABLE IF EXISTS `hr_view_emp_assessment_max`;

/*!50001 DROP VIEW IF EXISTS `hr_view_emp_assessment_max` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_emp_assessment_max` */;

/*!50001 CREATE TABLE  `hr_view_emp_assessment_max`(
 `employee_id` bigint(25) ,
 `ASSESSMENT_ID` bigint(25) ,
 `DATE_OF_ASSESSMENT` date 
)*/;

/*Table structure for table `hr_view_emp_competency` */

DROP TABLE IF EXISTS `hr_view_emp_competency`;

/*!50001 DROP VIEW IF EXISTS `hr_view_emp_competency` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_emp_competency` */;

/*!50001 CREATE TABLE  `hr_view_emp_competency`(
 `EMPLOYEE_COMP_ID` bigint(20) ,
 `EMPLOYEE_ID` bigint(20) ,
 `COMPETENCY_ID` bigint(20) ,
 `LEVEL_VALUE` float(4,2) ,
 `SPECIAL_ACHIEVEMENT` text ,
 `DATE_OF_ACHVMT` date ,
 `HISTORY` smallint(2) ,
 `PROVIDER_ID` bigint(20) ,
 `COMPETENCY_LEVEL_ID` bigint(20) ,
 `SCORE_VALUE` double(4,0) ,
 `MAX_DATE_OF_ACHVMT` date 
)*/;

/*Table structure for table `hr_view_emp_competency_max` */

DROP TABLE IF EXISTS `hr_view_emp_competency_max`;

/*!50001 DROP VIEW IF EXISTS `hr_view_emp_competency_max` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_emp_competency_max` */;

/*!50001 CREATE TABLE  `hr_view_emp_competency_max`(
 `employee_id` bigint(20) ,
 `COMPETENCY_ID` bigint(20) ,
 `DATE_OF_ACHVMT` date 
)*/;

/*Table structure for table `hr_view_max_emp_work_history` */

DROP TABLE IF EXISTS `hr_view_max_emp_work_history`;

/*!50001 DROP VIEW IF EXISTS `hr_view_max_emp_work_history` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_max_emp_work_history` */;

/*!50001 CREATE TABLE  `hr_view_max_emp_work_history`(
 `EMPLOYEE_ID` bigint(20) ,
 `MAX_HIS_WT` date 
)*/;

/*Table structure for table `hr_view_position_competency_list` */

DROP TABLE IF EXISTS `hr_view_position_competency_list`;

/*!50001 DROP VIEW IF EXISTS `hr_view_position_competency_list` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_position_competency_list` */;

/*!50001 CREATE TABLE  `hr_view_position_competency_list`(
 `POSITION_ID` bigint(20) ,
 `POSITION` varchar(124) ,
 `COMPETENCY_TYPE_ID` bigint(20) ,
 `TYPE_NAME` varchar(128) ,
 `COMPETENCY_GROUP_ID` bigint(20) ,
 `GROUP_NAME` varchar(128) ,
 `COMPETENCY_ID` bigint(20) ,
 `COMPETENCY_NAME` varchar(128) ,
 `COMPETENCY_LEVEL_ID` bigint(20) ,
 `LEVEL_DIVISION` int(2) ,
 `LEVEL_DEPARTMENT` int(2) ,
 `LEVEL_SECTION` int(2) ,
 `SCORE_REQ_MIN` double(4,0) ,
 `SCORE_REQ_RECOMMENDED` double(4,0) 
)*/;

/*Table structure for table `hr_view_work_history_now` */

DROP TABLE IF EXISTS `hr_view_work_history_now`;

/*!50001 DROP VIEW IF EXISTS `hr_view_work_history_now` */;
/*!50001 DROP TABLE IF EXISTS `hr_view_work_history_now` */;

/*!50001 CREATE TABLE  `hr_view_work_history_now`(
 `WORK_HISTORY_NOW_ID` bigint(20) ,
 `EMPLOYEE_ID` bigint(20) ,
 `COMPANY_ID` bigint(20) ,
 `DIVISION_ID` bigint(20) ,
 `DEPARTMENT_ID` bigint(20) ,
 `SECTION_ID` bigint(20) ,
 `EMP_CATEGORY_ID` bigint(20) ,
 `POSITION_ID` bigint(20) ,
 `LEVEL_ID` bigint(20) ,
 `WORK_FROM` date ,
 `WORK_TO` date ,
 `NOMOR_SK` varchar(128) ,
 `TANGGAL_SK` date ,
 `HISTORY_GROUP` int(11) ,
 `HISTORY_TYPE` int(11) ,
 `GRADE_LEVEL_ID` bigint(20) 
)*/;

/*Table structure for table `view_employee_edu_score` */

DROP TABLE IF EXISTS `view_employee_edu_score`;

/*!50001 DROP VIEW IF EXISTS `view_employee_edu_score` */;
/*!50001 DROP TABLE IF EXISTS `view_employee_edu_score` */;

/*!50001 CREATE TABLE  `view_employee_edu_score`(
 `EMPLOYEE_ID` bigint(20) ,
 `EDUCATION_ID` bigint(20) ,
 `EDUCATION` varchar(64) ,
 `EDULEVEL` int(10) ,
 `SCORE` float(4,0) ,
 `DRS` bigint(12) 
)*/;

/*Table structure for table `view_max_employee_edu_score` */

DROP TABLE IF EXISTS `view_max_employee_edu_score`;

/*!50001 DROP VIEW IF EXISTS `view_max_employee_edu_score` */;
/*!50001 DROP TABLE IF EXISTS `view_max_employee_edu_score` */;

/*!50001 CREATE TABLE  `view_max_employee_edu_score`(
 `EMPLOYEE_ID` bigint(20) ,
 `EDUCATION_ID` bigint(20) ,
 `EDUCATION` varchar(64) ,
 `MAXLEVEL` int(10) ,
 `SCORE` float(4,0) ,
 `DRS` bigint(12) 
)*/;

/*View structure for view hr_view_emp_assessment */

/*!50001 DROP TABLE IF EXISTS `hr_view_emp_assessment` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_emp_assessment` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hr_view_emp_assessment` AS select `hr_emp_assessment`.`EMP_ASSESSMENT_ID` AS `EMP_ASSESSMENT_ID`,`hr_emp_assessment`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`hr_emp_assessment`.`ASSESSMENT_ID` AS `ASSESSMENT_ID`,`hr_emp_assessment`.`SCORE` AS `SCORE`,`hr_emp_assessment`.`DATE_OF_ASSESSMENT` AS `DATE_OF_ASSESSMENT`,`hr_emp_assessment`.`REMARK` AS `REMARK`,max(`hr_emp_assessment`.`DATE_OF_ASSESSMENT`) AS `MAX_DATE_OF_ASSESSMENT` from (`hr_emp_assessment` join `hr_view_emp_assessment_max` `lastass` on(`hr_emp_assessment`.`EMPLOYEE_ID` = `lastass`.`employee_id` and `hr_emp_assessment`.`ASSESSMENT_ID` = `lastass`.`ASSESSMENT_ID` and `hr_emp_assessment`.`DATE_OF_ASSESSMENT` = `lastass`.`DATE_OF_ASSESSMENT`)) group by `hr_emp_assessment`.`EMPLOYEE_ID`,`hr_emp_assessment`.`ASSESSMENT_ID` */;

/*View structure for view hr_view_emp_assessment_max */

/*!50001 DROP TABLE IF EXISTS `hr_view_emp_assessment_max` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_emp_assessment_max` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hr_view_emp_assessment_max` AS select `hr_emp_assessment`.`EMPLOYEE_ID` AS `employee_id`,`hr_emp_assessment`.`ASSESSMENT_ID` AS `ASSESSMENT_ID`,max(`hr_emp_assessment`.`DATE_OF_ASSESSMENT`) AS `DATE_OF_ASSESSMENT` from `hr_emp_assessment` group by `hr_emp_assessment`.`EMPLOYEE_ID`,`hr_emp_assessment`.`ASSESSMENT_ID` */;

/*View structure for view hr_view_emp_competency */

/*!50001 DROP TABLE IF EXISTS `hr_view_emp_competency` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_emp_competency` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `hr_view_emp_competency` AS select `hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_COMP_ID` AS `EMPLOYEE_COMP_ID`,`hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_ID` AS `COMPETENCY_ID`,`hairisma_bpd`.`hr_emp_competency`.`LEVEL_VALUE` AS `LEVEL_VALUE`,`hairisma_bpd`.`hr_emp_competency`.`SPECIAL_ACHIEVEMENT` AS `SPECIAL_ACHIEVEMENT`,`hairisma_bpd`.`hr_emp_competency`.`DATE_OF_ACHVMT` AS `DATE_OF_ACHVMT`,`hairisma_bpd`.`hr_emp_competency`.`HISTORY` AS `HISTORY`,`hairisma_bpd`.`hr_emp_competency`.`PROVIDER_ID` AS `PROVIDER_ID`,`hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_LEVEL_ID` AS `COMPETENCY_LEVEL_ID`,`hairisma_bpd`.`hr_emp_competency`.`SCORE_VALUE` AS `SCORE_VALUE`,max(`hairisma_bpd`.`hr_emp_competency`.`DATE_OF_ACHVMT`) AS `MAX_DATE_OF_ACHVMT` from (`hr_emp_competency` join `hr_view_emp_competency_max` `lastcomp` on(`hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_ID` = `lastcomp`.`employee_id` and `hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_ID` = `lastcomp`.`COMPETENCY_ID` and `hairisma_bpd`.`hr_emp_competency`.`DATE_OF_ACHVMT` = `lastcomp`.`DATE_OF_ACHVMT`)) group by `hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_ID`,`hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_ID` */;

/*View structure for view hr_view_emp_competency_max */

/*!50001 DROP TABLE IF EXISTS `hr_view_emp_competency_max` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_emp_competency_max` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `hr_view_emp_competency_max` AS select `hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_ID` AS `employee_id`,`hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_ID` AS `COMPETENCY_ID`,max(`hairisma_bpd`.`hr_emp_competency`.`DATE_OF_ACHVMT`) AS `DATE_OF_ACHVMT` from `hr_emp_competency` group by `hairisma_bpd`.`hr_emp_competency`.`EMPLOYEE_ID`,`hairisma_bpd`.`hr_emp_competency`.`COMPETENCY_ID` */;

/*View structure for view hr_view_max_emp_work_history */

/*!50001 DROP TABLE IF EXISTS `hr_view_max_emp_work_history` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_max_emp_work_history` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `hr_view_max_emp_work_history` AS (select `hairisma_bpd`.`hr_work_history_now`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,max(`hairisma_bpd`.`hr_work_history_now`.`WORK_TO`) AS `MAX_HIS_WT` from `hr_work_history_now` where `hairisma_bpd`.`hr_work_history_now`.`HISTORY_GROUP` = 0 group by `hairisma_bpd`.`hr_work_history_now`.`EMPLOYEE_ID`) */;

/*View structure for view hr_view_position_competency_list */

/*!50001 DROP TABLE IF EXISTS `hr_view_position_competency_list` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_position_competency_list` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hr_view_position_competency_list` AS select `pos`.`POSITION_ID` AS `POSITION_ID`,`pos`.`POSITION` AS `POSITION`,`ty`.`COMPETENCY_TYPE_ID` AS `COMPETENCY_TYPE_ID`,`ty`.`TYPE_NAME` AS `TYPE_NAME`,`gr`.`COMPETENCY_GROUP_ID` AS `COMPETENCY_GROUP_ID`,`gr`.`GROUP_NAME` AS `GROUP_NAME`,`com`.`COMPETENCY_ID` AS `COMPETENCY_ID`,`com`.`COMPETENCY_NAME` AS `COMPETENCY_NAME`,`req`.`COMPETENCY_LEVEL_ID` AS `COMPETENCY_LEVEL_ID`,`req`.`LEVEL_DIVISION` AS `LEVEL_DIVISION`,`req`.`LEVEL_DEPARTMENT` AS `LEVEL_DEPARTMENT`,`req`.`LEVEL_SECTION` AS `LEVEL_SECTION`,`req`.`SCORE_REQ_MIN` AS `SCORE_REQ_MIN`,`req`.`SCORE_REQ_RECOMMENDED` AS `SCORE_REQ_RECOMMENDED` from ((((`hr_pos_competency_req` `req` join `hr_position` `pos` on(`req`.`POSITION_ID` = `pos`.`POSITION_ID`)) join `hr_competency` `com` on(`req`.`COMPETENCY_ID` = `com`.`COMPETENCY_ID`)) join `hr_competency_group` `gr` on(`com`.`COMPETENCY_GROUP_ID` = `gr`.`COMPETENCY_GROUP_ID`)) join `hr_competency_type` `ty` on(`com`.`COMPETENCY_TYPE_ID` = `ty`.`COMPETENCY_TYPE_ID`)) order by `pos`.`POSITION_ID`,`ty`.`COMPETENCY_TYPE_ID`,`gr`.`COMPETENCY_GROUP_ID`,`com`.`COMPETENCY_ID` */;

/*View structure for view hr_view_work_history_now */

/*!50001 DROP TABLE IF EXISTS `hr_view_work_history_now` */;
/*!50001 DROP VIEW IF EXISTS `hr_view_work_history_now` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `hr_view_work_history_now` AS (select `whn`.`WORK_HISTORY_NOW_ID` AS `WORK_HISTORY_NOW_ID`,`whn`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`whn`.`COMPANY_ID` AS `COMPANY_ID`,`whn`.`DIVISION_ID` AS `DIVISION_ID`,`whn`.`DEPARTMENT_ID` AS `DEPARTMENT_ID`,`whn`.`SECTION_ID` AS `SECTION_ID`,`whn`.`EMP_CATEGORY_ID` AS `EMP_CATEGORY_ID`,`whn`.`POSITION_ID` AS `POSITION_ID`,`whn`.`LEVEL_ID` AS `LEVEL_ID`,`whn`.`WORK_FROM` AS `WORK_FROM`,`whn`.`WORK_TO` AS `WORK_TO`,`whn`.`NOMOR_SK` AS `NOMOR_SK`,`whn`.`TANGGAL_SK` AS `TANGGAL_SK`,`whn`.`HISTORY_GROUP` AS `HISTORY_GROUP`,`whn`.`HISTORY_TYPE` AS `HISTORY_TYPE`,`whn`.`GRADE_LEVEL_ID` AS `GRADE_LEVEL_ID` from `hr_work_history_now` `whn` where `whn`.`HISTORY_GROUP` <> 1 and `whn`.`HISTORY_TYPE` in (0,1)) union (select 0 AS `WORK_HISTORY_NOW_ID`,`emp`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`emp`.`COMPANY_ID` AS `COMPANY_ID`,`emp`.`DIVISION_ID` AS `DIVISION_ID`,`emp`.`DEPARTMENT_ID` AS `DEPARTMENT_ID`,`emp`.`SECTION_ID` AS `SECTION_ID`,`emp`.`EMP_CATEGORY_ID` AS `EMP_CATEGORY_ID`,`emp`.`POSITION_ID` AS `POSITION_ID`,`emp`.`LEVEL_ID` AS `LEVEL_ID`,if((select max(`hairisma_bpd`.`hr_work_history_now`.`WORK_TO`) from `hr_work_history_now` where `hairisma_bpd`.`hr_work_history_now`.`EMPLOYEE_ID` = `emp`.`EMPLOYEE_ID` and `hairisma_bpd`.`hr_work_history_now`.`HISTORY_GROUP` <> 1 and `hairisma_bpd`.`hr_work_history_now`.`HISTORY_TYPE` in (0,1)) + interval 1 day is not null,(select max(`hairisma_bpd`.`hr_work_history_now`.`WORK_TO`) from `hr_work_history_now` where `hairisma_bpd`.`hr_work_history_now`.`EMPLOYEE_ID` = `emp`.`EMPLOYEE_ID` and `hairisma_bpd`.`hr_work_history_now`.`HISTORY_GROUP` <> 1 and `hairisma_bpd`.`hr_work_history_now`.`HISTORY_TYPE` in (0,1)) + interval 1 day,`emp`.`COMMENCING_DATE`) AS `WORK_FROM`,curdate() AS `WORK_TO`,`emp`.`SK_NOMOR` AS `NOMOR_SK`,`emp`.`SK_TANGGAL` AS `TANGGAL_SK`,`emp`.`HISTORY_GROUP` AS `HISTORY_GROUP`,`emp`.`HISTORY_TYPE` AS `HISTORY_TYPE`,`emp`.`GRADE_LEVEL_ID` AS `GRADE_LEVEL_ID` from `hr_employee` `emp`) */;

/*View structure for view view_employee_edu_score */

/*!50001 DROP TABLE IF EXISTS `view_employee_edu_score` */;
/*!50001 DROP VIEW IF EXISTS `view_employee_edu_score` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `view_employee_edu_score` AS (select `emp`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`emp`.`EDUCATION_ID` AS `EDUCATION_ID`,`edu`.`EDUCATION` AS `EDUCATION`,`edu`.`EDUCATION_LEVEL` AS `EDULEVEL`,`scr`.`SCORE` AS `SCORE`,`emp`.`END_DATE` - `emp`.`START_DATE` AS `DRS` from ((`hr_emp_education` `emp` join `hr_education` `edu` on(`edu`.`EDUCATION_ID` = `emp`.`EDUCATION_ID`)) join `hr_education_score` `scr` on(`scr`.`EDUCATION_ID` = `emp`.`EDUCATION_ID`)) where `scr`.`POINT_MIN` <= `emp`.`POINT` and `scr`.`POINT_MAX` >= `emp`.`POINT` group by `emp`.`EMPLOYEE_ID`,`emp`.`EDUCATION_ID`) */;

/*View structure for view view_max_employee_edu_score */

/*!50001 DROP TABLE IF EXISTS `view_max_employee_edu_score` */;
/*!50001 DROP VIEW IF EXISTS `view_max_employee_edu_score` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `view_max_employee_edu_score` AS (select `emp`.`EMPLOYEE_ID` AS `EMPLOYEE_ID`,`emp`.`EDUCATION_ID` AS `EDUCATION_ID`,`edu`.`EDUCATION` AS `EDUCATION`,max(`edu`.`EDUCATION_LEVEL`) AS `MAXLEVEL`,`scr`.`SCORE` AS `SCORE`,`emp`.`END_DATE` - `emp`.`START_DATE` AS `DRS` from ((`hr_emp_education` `emp` join `hr_education` `edu` on(`edu`.`EDUCATION_ID` = `emp`.`EDUCATION_ID`)) join `hr_education_score` `scr` on(`scr`.`EDUCATION_ID` = `emp`.`EDUCATION_ID`)) where `scr`.`POINT_MIN` <= `emp`.`POINT` and `scr`.`POINT_MAX` >= `emp`.`POINT` group by `emp`.`EMPLOYEE_ID`) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
