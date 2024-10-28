-- script by Edward Stoever for Mariadb Support
create schema if not exists BENCHMARK;
use BENCHMARK;

CREATE TABLE IF NOT EXISTS `PERSONS` (
  `pers_id` varchar(16) NOT NULL,
  `pers_first_name` varchar(100) DEFAULT NULL,
  `pers_middle_name` varchar(100) DEFAULT NULL,
  `pers_last_name` varchar(100) DEFAULT NULL,
  `pers_external_id_type` varchar(50) DEFAULT NULL,
  `pers_external_id_number` varchar(50) DEFAULT NULL,
  `pers_date_of_birth` date DEFAULT NULL,
  `pers_comment` varchar(256) DEFAULT NULL,
  `pers_created` datetime DEFAULT NULL,
  `pers_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`pers_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `STUDENTS` (
  `stud_pers_id` varchar(16) DEFAULT NULL,
  `stud_academic_field` varchar(100) DEFAULT NULL,
  `stud_last_day_of_study` date DEFAULT NULL,
  `stud_created` datetime DEFAULT NULL,
  `stud_updated` datetime DEFAULT NULL,
  KEY `fk_stud_pers` (`stud_pers_id`),
  CONSTRAINT `fk_stud_pers` FOREIGN KEY (`stud_pers_id`) REFERENCES `PERSONS` (`pers_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `PROFESSORS` (
  `prof_pers_id` varchar(16) DEFAULT NULL,
  `prof_principal_discipline` varchar(10) DEFAULT NULL,
  `prof_last_day_employed` date DEFAULT NULL,
  `prof_created` datetime DEFAULT NULL,
  `prof_updated` datetime DEFAULT NULL,
  KEY `fk_prof_pers` (`prof_pers_id`),
  CONSTRAINT `fk_prof_pers` FOREIGN KEY (`prof_pers_id`) REFERENCES `PERSONS` (`pers_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `LAST_RUN` (
  `run_count` int(11) DEFAULT NULL,
  `last_pers_id` varchar(200) DEFAULT NULL,
  `updated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
insert into LAST_RUN values (0,'x',now());

CREATE TABLE IF NOT EXISTS `MESSAGES` (
  `msg_sent` datetime DEFAULT NULL,
  `msg_sender` varchar(16) DEFAULT NULL,
  `msg_recipient` varchar(16) DEFAULT NULL,
  `msg_subject` varchar(100) DEFAULT NULL,
  `msg_text` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
 PARTITION BY RANGE (year(`msg_sent`))
SUBPARTITION BY HASH (month(`msg_sent`))
SUBPARTITIONS 2
(PARTITION `p2019` VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION `p2020` VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION `p2021` VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION `p2022` VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION `p2023` VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION `p2024` VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION `p2025` VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION `p2026` VALUES LESS THAN (2027) ENGINE = InnoDB,
 PARTITION `p2027` VALUES LESS THAN (2028) ENGINE = InnoDB,
 PARTITION `p2028` VALUES LESS THAN (2029) ENGINE = InnoDB,
 PARTITION `p2029` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);


CREATE TABLE IF NOT EXISTS `INSTANCE_DETAILS` (
  `hostname` varchar(100) DEFAULT NULL,
  `is_master` varchar(10) DEFAULT NULL,
  `is_slave` varchar(10) DEFAULT NULL,
  `is_galera` varchar(10) DEFAULT NULL,
  `binlog_format` varchar(20) DEFAULT NULL,
  `slave_parallel_threads` int(11) DEFAULT NULL,
  `slave_parallel_mode` varchar(20) DEFAULT NULL,
  `rpl_semi_sync_master_enabled` varchar(20) DEFAULT NULL,
  `rpl_semi_sync_slave_enabled` varchar(20) DEFAULT NULL,
  `master_timestamp` datetime DEFAULT NULL,
  `instance_timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
TRUNCATE TABLE `INSTANCE_DETAILS`;
select VARIABLE_VALUE into @DEFAULT_BINLOG_FORMAT from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='BINLOG_FORMAT';
set session binlog_format=STATEMENT;
INSERT INTO `INSTANCE_DETAILS`
WITH  INSTANCE_VARIABLES AS (
SELECT
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='HOSTNAME' limit 1) AS `HOSTNAME`,
(select if(VARIABLE_VALUE>0,'YES','NO') from information_schema.GLOBAL_STATUS where VARIABLE_NAME='SLAVES_CONNECTED' limit 1) AS `IS_MASTER`,
(select if(sum(VARIABLE_VALUE)>0,'YES','NO')  from information_schema.global_status where VARIABLE_NAME in ('SLAVE_RECEIVED_HEARTBEATS','RPL_SEMI_SYNC_SLAVE_SEND_ACK','SLAVES_RUNNING') limit 1) as `IS_SLAVE`,
(select if(VARIABLE_VALUE > 0,'YES','NO') AS IS_GALERA from information_schema.global_status where VARIABLE_NAME='WSREP_THREAD_COUNT' limit 1) AS `IS_GALERA`,
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='BINLOG_FORMAT' limit 1) AS `BINLOG_FORMAT`,
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='SLAVE_PARALLEL_THREADS' limit 1) AS `SLAVE_PARALLEL_THREADS`,
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='SLAVE_PARALLEL_MODE' limit 1) AS `SLAVE_PARALLEL_MODE`,
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='RPL_SEMI_SYNC_MASTER_ENABLED' limit 1) AS `RPL_SEMI_SYNC_MASTER_ENABLED`,
(select VARIABLE_VALUE from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME='RPL_SEMI_SYNC_SLAVE_ENABLED' limit 1) AS `RPL_SEMI_SYNC_SLAVE_ENABLED`,
(select now()) as `MASTER_TIMESTAMP`,
(select SYSDATE()) as `INSTANCE_TIMESTAMP`
) select * from INSTANCE_VARIABLES;
set session binlog_format=@DEFAULT_BINLOG_FORMAT;

CREATE TABLE IF NOT EXISTS `REPLICATION_PROGRESS` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(100) DEFAULT NULL,
  `master_timestamp` datetime DEFAULT NULL,
  `instance_timestamp` datetime DEFAULT NULL,
  `gtid_current_pos` varchar(200) DEFAULT NULL,
  `gtid_slave_pos` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
