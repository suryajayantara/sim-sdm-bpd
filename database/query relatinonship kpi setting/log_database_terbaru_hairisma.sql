/*

note : 
  1. apababila terjadi error maka perlu melakukan backup tabel hr_kpi_target_detail lalu hapus datanya
  dan jalankan query tersebut. setelah itu import kembali data tabel yang sudah dibackup lalu tanda centang 
  abort error dihilangkan karena ada beberapa data tidak terimput karena ada data yang tidak memiliki relasi
  2. membuat relasi querynya lsng pada coding
  3.  gunakan set foreign key = 0 untuk menjalankan query diatas apabila tidak berjalan dan cara ini merupakan option
 	ke 2 dan digunakan saat benar-benar dibutuhkan dengan cepat berikut merupakan query :

 	SET FOREIGN_KEY_CHECKS = 0;

 	apabila sudah dijalankan query tersebut lalu jalankan query berikut untuk menyalakan fitur pengecekan foreign key :

 	SET FOREIGN_KEY_CHECKS = 1;
*/

/* Alter table in target */
ALTER TABLE `pay_general` 
	CHANGE `REG_TAX_DATE` `REG_TAX_DATE` date   NOT NULL after `REG_TAX_BUS_NR` , ENGINE=InnoDB; 


/* Create table in target */
CREATE TABLE `hr_ass_form_main_position`(
	`ASS_MAIN_FORM_POSITION_ID` bigint(20) NOT NULL  , 
	`ASS_FORM_MAIN_ID` bigint(20) NULL  , 
	`POSITION_ID` bigint(20) NULL  , 
	PRIMARY KEY (`ASS_MAIN_FORM_POSITION_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_achiev_score` 
	CHANGE `ACHIEV_DURATION_MIN` `ACHIEV_DURATION_MIN` float(4,0)   NULL after `ACHIEV_PCTG_MAX` , 
	CHANGE `ACHIEV_DURATION_MAX` `ACHIEV_DURATION_MAX` float(4,0)   NULL after `ACHIEV_DURATION_MIN` , 
	CHANGE `VALID_START` `VALID_START` date   NULL after `SCORE` , 
	CHANGE `VALID_END` `VALID_END` date   NULL after `VALID_START` ;

/* Create table in target */
CREATE TABLE `hr_kpi_distribution`(
	`KPI_DISTRIBUTION_ID` bigint(20) NOT NULL  , 
	`DISTRIBUTION` varchar(256) COLLATE utf8mb4_general_ci NULL  , 
	PRIMARY KEY (`KPI_DISTRIBUTION_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_group` 
	CHANGE `GROUP_TITLE` `GROUP_TITLE` varchar(512)  COLLATE utf8_general_ci NULL after `KPI_TYPE_ID` , 
	ADD COLUMN `NUMBER_INDEX` int(3)   NULL after `DESCRIPTION` ;

/* Create table in target */
CREATE TABLE `hr_kpi_group_division`(
	`KPI_GROUP_DIVISION_ID` bigint(20) NOT NULL  , 
	`KPI_GROUP_ID` bigint(20) NULL  , 
	`DIVISION_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_GROUP_DIVISION_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_group_position`(
	`KPI_GROUP_POSITION_ID` binary(20) NOT NULL  , 
	`KPI_GROUP_ID` bigint(20) NULL  , 
	`POSITION_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_GROUP_POSITION_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_list` 
	CHANGE `DESCRIPTION` `DESCRIPTION` text  COLLATE utf8_general_ci NULL after `KPI_TITLE` , 
	ADD COLUMN `RANGE_START` double   NULL after `KORELASI` , 
	ADD COLUMN `RANGE_END` double   NULL after `RANGE_START` , 
	ADD COLUMN `NUMBER_INDEX` int(3)   NULL after `RANGE_END` ;

/* Alter table in target */
ALTER TABLE `hr_kpi_list_group` 
	ADD KEY `FK_HR_KPI_GROUP_ID`(`KPI_GROUP_ID`) , 
	ADD KEY `FK_HR_KPI_LIST_ID`(`KPI_LIST_ID`) ;
ALTER TABLE `hr_kpi_list_group`
	ADD CONSTRAINT `FK_HR_KPI_GROUP_ID` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `FK_HR_KPI_LIST_ID` 
	FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE ;


/* Create table in target */
CREATE TABLE `hr_kpi_setting`(
	`KPI_SETTING_ID` bigint(20) NOT NULL  , 
	`VALID_DATE` date NULL  , 
	`STATUS` int(2) NULL  , 
	`START_DATE` date NULL  , 
	`COMPANY_ID` bigint(20) NULL  , 
	`TAHUN` bigint(10) NULL  , 
	PRIMARY KEY (`KPI_SETTING_ID`) , 
	KEY `FK_PAY_GENERAL_ID`(`COMPANY_ID`) , 
	CONSTRAINT `FK_PAY_GENERAL_ID` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';

baru sampai sini-------------------------------------------------<yang atas sudah>

/* Create table in target */
CREATE TABLE `hr_kpi_setting_company`(
	`KPI_SETTING_COMPANY_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NULL  , 
	`COMPANY_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_COMPANY_ID`) , 
	KEY `FK_KPI_SETTING`(`KPI_SETTING_ID`) , 
	KEY `FK_COMPANY`(`COMPANY_ID`) , 
	CONSTRAINT `FK_COMPANY` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_SETTING` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_group`(
	`KPI_SETTING_GROUP_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NULL  , 
	`KPI_GROUP_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_GROUP_ID`) , 
	KEY `FK_HR_KPI_SETTING`(`KPI_SETTING_ID`) , 
	KEY `FK_HR_KPI_GROUP`(`KPI_GROUP_ID`) , 
	CONSTRAINT `FK_HR_KPI_GROUP` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_HR_KPI_SETTING` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_list`(
	`KPI_SETTING_LIST_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NULL  , 
	`KPI_LIST_ID` bigint(20) NULL  , 
	`KPI_DISTRIBUTION_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_LIST_ID`) , 
	KEY `FK_KPI_SETTING_ID`(`KPI_SETTING_ID`) , 
	KEY `FK_KPI_LIST_ID`(`KPI_LIST_ID`) , 
	KEY `FK_KPI_DISTRIBUTION_ID`(`KPI_DISTRIBUTION_ID`) , 
	CONSTRAINT `FK_KPI_DISTRIBUTION_ID` 
	FOREIGN KEY (`KPI_DISTRIBUTION_ID`) REFERENCES `hr_kpi_distribution` (`KPI_DISTRIBUTION_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_LIST_ID` 
	FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_SETTING_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_position`(
	`KPI_SETTING_POSITION_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NULL  , 
	`POSITION_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_POSITION_ID`) , 
	KEY `FK_KPI_SETTING_POSITION_ID`(`KPI_SETTING_ID`) , 
	KEY `FK_POSITION_ID`(`POSITION_ID`) , 
	CONSTRAINT `FK_KPI_SETTING_POSITION_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON UPDATE CASCADE , 
	CONSTRAINT `FK_POSITION_ID` 
	FOREIGN KEY (`POSITION_ID`) REFERENCES `hr_position` (`POSITION_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_profile`(
	`KPI_SETTING_PROFILE_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NOT NULL  , 
	`POSITION_ID` bigint(20) NOT NULL  , 
	PRIMARY KEY (`KPI_SETTING_PROFILE_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_type`(
	`KPI_SETTING_TYPE_ID` bigint(20) NOT NULL  , 
	`KPI_SETTING_ID` bigint(20) NULL  , 
	`KPI_TYPE_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_TYPE_ID`) , 
	KEY `FK_KPI_SETTING_TYPE_ID`(`KPI_SETTING_ID`) , 
	CONSTRAINT `FK_KPI_SETTING_TYPE_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_target` 
	ADD COLUMN `POSITION_ID` bigint(25)   NULL after `TAHUN` ;

/* Alter table in target */
ALTER TABLE `hr_kpi_target_detail` 
	CHANGE `KPI_TARGET_DETAIL_ID` `KPI_TARGET_DETAIL_ID` bigint(25)   NOT NULL first , 
	ADD COLUMN `KPI_SETTING_LIST_ID` bigint(20)   NULL after `WEIGHT_VALUE` , 
	ADD KEY `FK_HR_KPI_GROUPID`(`KPI_GROUP_ID`) , 
	ADD KEY `FK_KPI_LIST`(`KPI_ID`) , 
	ADD KEY `FK_KPI_SETTING_LIST_ID`(`KPI_SETTING_LIST_ID`) , 
	ADD KEY `FK_KPI_TARGET_ID`(`KPI_TARGET_ID`) , 
	ADD PRIMARY KEY(`KPI_TARGET_DETAIL_ID`) ;
ALTER TABLE `hr_kpi_target_detail`
	ADD CONSTRAINT `FK_HR_KPI_GROUPID` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `FK_KPI_LIST` 
	FOREIGN KEY (`KPI_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `FK_KPI_SETTING_LIST_ID` 
	FOREIGN KEY (`KPI_SETTING_LIST_ID`) REFERENCES `hr_kpi_setting_list` (`KPI_SETTING_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `FK_KPI_TARGET_ID` 
	FOREIGN KEY (`KPI_TARGET_ID`) REFERENCES `hr_kpi_target` (`KPI_TARGET_ID`) ON DELETE CASCADE ON UPDATE CASCADE ;


/* Alter table in target */
ALTER TABLE `hr_kpi_target_detail_employee` 
	ADD KEY `FK_KPI_TARGET_DETAIL_ID`(`KPI_TARGET_DETAIL_ID`) ;
ALTER TABLE `hr_kpi_target_detail_employee`
	ADD CONSTRAINT `FK_KPI_TARGET_DETAIL_ID` 
	FOREIGN KEY (`KPI_TARGET_DETAIL_ID`) REFERENCES `hr_kpi_target_detail` (`KPI_TARGET_DETAIL_ID`) ON DELETE CASCADE ON UPDATE CASCADE ;


/* Alter table in target */
ALTER TABLE `hr_kpi_type` 
	ADD COLUMN `COMPANY` varchar(256)  COLLATE utf8_general_ci NULL after `DESCRIPTION` , 
	ADD COLUMN `NUMBER_INDEX` int(3)   NULL after `COMPANY` ;

/* Create table in target */
CREATE TABLE `hr_kpi_type_company`(
	`KPI_TYPE_COMPANY_ID` bigint(20) NOT NULL  , 
	`KPI_TYPE_ID` bigint(20) NULL  , 
	`COMPANY_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_TYPE_COMPANY_ID`) , 
	KEY `FK_KPITYPE_ID`(`KPI_TYPE_ID`) , 
	KEY `FK_COMPANY_ID`(`COMPANY_ID`) , 
	CONSTRAINT `FK_COMPANY_ID` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPITYPE_ID` 
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type` (`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_type_division`(
	`KPI_TYPE_DIVISION_ID` bigint(20) NOT NULL  , 
	`KPI_TYPE_ID` bigint(20) NOT NULL  , 
	`DIVISION_ID` bigint(20) NOT NULL  , 
	PRIMARY KEY (`KPI_TYPE_DIVISION_ID`) 
) ENGINE=InnoDB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_type_group`(
	`KPI_TYPE_GROUP_ID` bigint(20) NOT NULL  , 
	`KPI_TYPE_ID` bigint(20) NULL  , 
	`KPI_GROUP_ID` bigint(20) NULL  , 
	PRIMARY KEY (`KPI_TYPE_GROUP_ID`) , 
	KEY `FK_KPI_TYPE_ID`(`KPI_TYPE_ID`) , 
	KEY `FK_KPI_GROUP_ID`(`KPI_GROUP_ID`) , 
	CONSTRAINT `FK_KPI_GROUP_ID` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_TYPE_ID` 
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type` (`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';

ALTER TABLE `hr_kpi_setting_profile`  
  ADD CONSTRAINT `FK_HR_POSITION` FOREIGN KEY (`POSITION_ID`) REFERENCES `hr_position`(`POSITION_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `hr_kpi_setting_profile`  
  ADD FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES .`hr_kpi_setting`(`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

  ALTER TABLE `hr_kpi_setting_type`  
  ADD FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type`(`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

  ALTER TABLE `hr_kpi_setting_type`  
  ADD FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type`(`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

RENAME TABLE `hr_kpi_setting_profile` TO `hr_kpi_setting_position`;