/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

/* Alter table in target */
ALTER TABLE `hr_section` ENGINE=INNODB; 

/* Alter table in target */
ALTER TABLE `pay_general` 
	CHANGE `REG_TAX_DATE` `REG_TAX_DATE` DATE   NOT NULL AFTER `REG_TAX_BUS_NR` , ENGINE=INNODB; 

/* Create table in target */
CREATE TABLE `hr_ass_form_main_position`(
	`ASS_MAIN_FORM_POSITION_ID` BIGINT(20) NOT NULL  , 
	`ASS_FORM_MAIN_ID` BIGINT(20) NULL  , 
	`POSITION_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`ASS_MAIN_FORM_POSITION_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_achiev_score` 
	CHANGE `ACHIEV_DURATION_MIN` `ACHIEV_DURATION_MIN` FLOAT(4,0)   NULL AFTER `ACHIEV_PCTG_MAX` , 
	CHANGE `ACHIEV_DURATION_MAX` `ACHIEV_DURATION_MAX` FLOAT(4,0)   NULL AFTER `ACHIEV_DURATION_MIN` , 
	CHANGE `VALID_START` `VALID_START` DATE   NULL AFTER `SCORE` , 
	CHANGE `VALID_END` `VALID_END` DATE   NULL AFTER `VALID_START` ;

/* Create table in target */
CREATE TABLE `hr_kpi_distribution`(
	`KPI_DISTRIBUTION_ID` BIGINT(20) NOT NULL  , 
	`DISTRIBUTION` VARCHAR(256) COLLATE utf8mb4_general_ci NULL  , 
	PRIMARY KEY (`KPI_DISTRIBUTION_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_group` 
	CHANGE `GROUP_TITLE` `GROUP_TITLE` VARCHAR(512)  COLLATE utf8_general_ci NULL AFTER `KPI_TYPE_ID` , 
	ADD COLUMN `NUMBER_INDEX` INT(3)   NULL AFTER `DESCRIPTION` , 
	ADD KEY `KPI_TYPE_ID`(`KPI_TYPE_ID`) ;
ALTER TABLE `hr_kpi_group`
	ADD CONSTRAINT `hr_kpi_group_ibfk_1` 
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hairisma_bpd`.`hr_kpi_type` (`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE ;


/* Create table in target */
CREATE TABLE `hr_kpi_group_division`(
	`KPI_GROUP_DIVISION_ID` BIGINT(20) NOT NULL  , 
	`KPI_GROUP_ID` BIGINT(20) NULL  , 
	`DIVISION_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_GROUP_DIVISION_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_group_position`(
	`KPI_GROUP_POSITION_ID` BINARY(20) NOT NULL  , 
	`KPI_GROUP_ID` BIGINT(20) NULL  , 
	`POSITION_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_GROUP_POSITION_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_list` 
	CHANGE `DESCRIPTION` `DESCRIPTION` TEXT  COLLATE utf8_general_ci NULL AFTER `KPI_TITLE` , 
	ADD COLUMN `RANGE_START` DOUBLE   NULL AFTER `KORELASI` , 
	ADD COLUMN `RANGE_END` DOUBLE   NULL AFTER `RANGE_START` , 
	ADD COLUMN `NUMBER_INDEX` INT(3)   NULL AFTER `RANGE_END` , 
	ADD KEY `hr_kpi_list_ibfk_1`(`COMPANY_ID`) ;
ALTER TABLE `hr_kpi_list`
	ADD CONSTRAINT `hr_kpi_list_ibfk_1` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ;


/* Alter table in target */
ALTER TABLE `hr_kpi_list_group` 
	ADD KEY `FK_HR_KPI_GROUP_ID`(`KPI_GROUP_ID`) , 
	ADD KEY `FK_HR_KPI_LIST_ID`(`KPI_LIST_ID`) ;
ALTER TABLE `hr_kpi_list_group`
	ADD CONSTRAINT `FK_HR_KPI_GROUP_ID` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `FK_HR_KPI_LIST_ID` 
	FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE ;


/* Alter table in target */
ALTER TABLE `hr_kpi_list_position` 
	ADD KEY `FK_KPI_LIST_POSITION_ID`(`KPI_LIST_ID`) ;
ALTER TABLE `hr_kpi_list_position`
	ADD CONSTRAINT `FK_KPI_LIST_POSITION_ID` 
	FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ;


/* Create table in target */
CREATE TABLE `hr_kpi_setting`(
	`KPI_SETTING_ID` BIGINT(20) NOT NULL  , 
	`VALID_DATE` DATE NULL  , 
	`STATUS` INT(2) NULL  , 
	`START_DATE` DATE NULL  , 
	`COMPANY_ID` BIGINT(20) NULL  , 
	`TAHUN` BIGINT(10) NULL  , 
	PRIMARY KEY (`KPI_SETTING_ID`) , 
	KEY `FK_PAY_GENERAL_ID`(`COMPANY_ID`) , 
	CONSTRAINT `FK_PAY_GENERAL_ID` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_company`(
	`KPI_SETTING_COMPANY_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NULL  , 
	`COMPANY_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_COMPANY_ID`) , 
	KEY `FK_KPI_SETTING`(`KPI_SETTING_ID`) , 
	KEY `FK_COMPANY`(`COMPANY_ID`) , 
	CONSTRAINT `FK_COMPANY` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_SETTING` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';

/* Create table in target */
CREATE TABLE `hr_kpi_setting_type`(
	`KPI_SETTING_TYPE_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NULL  , 
	`KPI_TYPE_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_TYPE_ID`) , 
	KEY `FK_KPI_SETTING_TYPE_ID`(`KPI_SETTING_ID`) ,
	KEY `FK_KPI_TYPE_ID`(`KPI_TYPE_ID`) , 
	CONSTRAINT `FK_KPI_SETTING_TYPE_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON UPDATE CASCADE , 
	CONSTRAINT `hr_kpi_setting_type_ibfk_1`  
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type`(`KPI_TYPE_ID`) ON UPDATE CASCADE

) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';

/* Create table in target */
CREATE TABLE `hr_kpi_setting_group`(
	`KPI_SETTING_GROUP_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NULL  , 
	`KPI_GROUP_ID` BIGINT(20) NULL  , 
	`KPI_SETTING_TYPE_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_GROUP_ID`) , 
	KEY `FK_HR_KPI_SETTING`(`KPI_SETTING_ID`) , 
	KEY `FK_HR_KPI_GROUP`(`KPI_GROUP_ID`) , 
	KEY `KPI_SETTING_TYPE_ID`(`KPI_SETTING_TYPE_ID`) , 
	CONSTRAINT `FK_HR_KPI_GROUP` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_HR_KPI_SETTING` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `hr_kpi_setting_group_ibfk_1` 
	FOREIGN KEY (`KPI_SETTING_TYPE_ID`) REFERENCES `hr_kpi_setting_type` (`KPI_SETTING_TYPE_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_list`(
	`KPI_SETTING_LIST_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NULL  , 
	`KPI_LIST_ID` BIGINT(20) NULL  , 
	`KPI_DISTRIBUTION_ID` BIGINT(20) NULL  , 
	`KPI_SETTING_GROUP_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_LIST_ID`) , 
	KEY `FK_KPI_SETTING_ID`(`KPI_SETTING_ID`) , 
	KEY `FK_KPI_LIST_ID`(`KPI_LIST_ID`) , 
	KEY `FK_KPI_DISTRIBUTION_ID`(`KPI_DISTRIBUTION_ID`) , 
	KEY `KPI_SETTING_GROUP_ID`(`KPI_SETTING_GROUP_ID`) , 
	CONSTRAINT `FK_KPI_DISTRIBUTION_ID` 
	FOREIGN KEY (`KPI_DISTRIBUTION_ID`) REFERENCES `hr_kpi_distribution` (`KPI_DISTRIBUTION_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_LIST_ID` 
	FOREIGN KEY (`KPI_LIST_ID`) REFERENCES `hr_kpi_list` (`KPI_LIST_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_SETTING_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `hr_kpi_setting_list_ibfk_1` 
	FOREIGN KEY (`KPI_SETTING_GROUP_ID`) REFERENCES `hr_kpi_setting_group` (`KPI_SETTING_GROUP_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_position`(
	`KPI_SETTING_POSITION_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NULL  , 
	`POSITION_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_SETTING_POSITION_ID`) , 
	KEY `FK_KPI_SETTING_POSITION_ID`(`KPI_SETTING_ID`) , 
	KEY `FK_POSITION_ID`(`POSITION_ID`) , 
	CONSTRAINT `FK_KPI_SETTING_POSITION_ID` 
	FOREIGN KEY (`KPI_SETTING_ID`) REFERENCES `hr_kpi_setting` (`KPI_SETTING_ID`) ON UPDATE CASCADE , 
	CONSTRAINT `FK_POSITION_ID` 
	FOREIGN KEY (`POSITION_ID`) REFERENCES `hr_position` (`POSITION_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_setting_profile`(
	`KPI_SETTING_PROFILE_ID` BIGINT(20) NOT NULL  , 
	`KPI_SETTING_ID` BIGINT(20) NOT NULL  , 
	`POSITION_ID` BIGINT(20) NOT NULL  , 
	PRIMARY KEY (`KPI_SETTING_PROFILE_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Alter table in target */
ALTER TABLE `hr_kpi_target` 
	ADD COLUMN `POSITION_ID` BIGINT(25)   NULL AFTER `TAHUN` , 
	ADD KEY `hr_kpi_target_ibfk_1`(`SECTION_ID`) ;
ALTER TABLE `hr_kpi_target`
	ADD CONSTRAINT `hr_kpi_target_ibfk_1` 
	FOREIGN KEY (`SECTION_ID`) REFERENCES `hr_section` (`SECTION_ID`) ;


/* Alter table in target */
ALTER TABLE `hr_kpi_target_detail` 
	CHANGE `KPI_TARGET_DETAIL_ID` `KPI_TARGET_DETAIL_ID` BIGINT(25)   NOT NULL FIRST , 
	ADD COLUMN `KPI_SETTING_LIST_ID` BIGINT(20)   NULL AFTER `WEIGHT_VALUE` , 
	ADD COLUMN `INDEX_PERIOD` INT(2)   NULL AFTER `KPI_SETTING_LIST_ID` , 
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
	ADD COLUMN `DATE_FROM` DATE   NULL AFTER `BOBOT` , 
	ADD COLUMN `DATE_TO` DATE   NULL AFTER `DATE_FROM` , 
	ADD KEY `EMPLOYEE_ID`(`EMPLOYEE_ID`) , 
	ADD KEY `FK_KPI_TARGET_DETAIL_ID`(`KPI_TARGET_DETAIL_ID`) ;
ALTER TABLE `hr_kpi_target_detail_employee`
	ADD CONSTRAINT `FK_KPI_TARGET_DETAIL_ID` 
	FOREIGN KEY (`KPI_TARGET_DETAIL_ID`) REFERENCES `hr_kpi_target_detail` (`KPI_TARGET_DETAIL_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `hr_kpi_target_detail_employee_ibfk_1` 
	FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee` (`EMPLOYEE_ID`) ;


/* Alter table in target */
ALTER TABLE `hr_kpi_type` 
	ADD COLUMN `COMPANY` VARCHAR(256)  COLLATE utf8_general_ci NULL AFTER `DESCRIPTION` , 
	ADD COLUMN `NUMBER_INDEX` INT(3)   NULL AFTER `COMPANY` ;

/* Create table in target */
CREATE TABLE `hr_kpi_type_company`(
	`KPI_TYPE_COMPANY_ID` BIGINT(20) NOT NULL  , 
	`KPI_TYPE_ID` BIGINT(20) NULL  , 
	`COMPANY_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_TYPE_COMPANY_ID`) , 
	KEY `FK_KPITYPE_ID`(`KPI_TYPE_ID`) , 
	KEY `FK_COMPANY_ID`(`COMPANY_ID`) , 
	CONSTRAINT `FK_COMPANY_ID` 
	FOREIGN KEY (`COMPANY_ID`) REFERENCES `pay_general` (`GEN_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPITYPE_ID` 
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type` (`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_type_division`(
	`KPI_TYPE_DIVISION_ID` BIGINT(20) NOT NULL  , 
	`KPI_TYPE_ID` BIGINT(20) NOT NULL  , 
	`DIVISION_ID` BIGINT(20) NOT NULL  , 
	PRIMARY KEY (`KPI_TYPE_DIVISION_ID`) 
) ENGINE=INNODB DEFAULT CHARSET='latin1' COLLATE='latin1_swedish_ci';


/* Create table in target */
CREATE TABLE `hr_kpi_type_group`(
	`KPI_TYPE_GROUP_ID` BIGINT(20) NOT NULL  , 
	`KPI_TYPE_ID` BIGINT(20) NULL  , 
	`KPI_GROUP_ID` BIGINT(20) NULL  , 
	PRIMARY KEY (`KPI_TYPE_GROUP_ID`) , 
	KEY `FK_KPI_TYPE_ID`(`KPI_TYPE_ID`) , 
	KEY `FK_KPI_GROUP_ID`(`KPI_GROUP_ID`) , 
	CONSTRAINT `FK_KPI_GROUP_ID` 
	FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group` (`KPI_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `FK_KPI_TYPE_ID` 
	FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type` (`KPI_TYPE_ID`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=INNODB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';

ALTER TABLE `hr_kpi_target_detail`  
  ADD FOREIGN KEY (`KPI_GROUP_ID`) REFERENCES `hr_kpi_group`(`KPI_GROUP_ID`);

ALTER TABLE `hr_kpi_target_detail`  
  ADD FOREIGN KEY (`KPI_ID`) REFERENCES `hr_kpi_list`(`KPI_LIST_ID`);

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

/* apabila hr kpi setting type error menambah relasi, maka jalankan query ini
ALTER TABLE `hr_kpi_setting_type`  
  ADD FOREIGN KEY (`KPI_TYPE_ID`) REFERENCES `hr_kpi_type`(`KPI_TYPE_ID`); */
  
ALTER TABLE `hr_kpi_target_detail`  
  ADD FOREIGN KEY (`KPI_TARGET_ID`) REFERENCES `hr_kpi_target`(`KPI_TARGET_ID`);
  
ALTER TABLE `hr_kpi_target_detail_employee`  
  ADD FOREIGN KEY (`KPI_TARGET_DETAIL_ID`) REFERENCES `hr_kpi_target_detail`(`KPI_TARGET_DETAIL_ID`);
  
ALTER TABLE `hr_kpi_target_detail_employee`  
  ADD FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `hr_employee`(`EMPLOYEE_ID`);
  
ALTER TABLE `hr_kpi_target_detail`  
  ADD FOREIGN KEY (`KPI_SETTING_LIST_ID`) REFERENCES `hr_kpi_setting_list`(`KPI_SETTING_LIST_ID`);


  

