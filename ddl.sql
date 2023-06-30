use $mysql_db;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `typologies` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(2000) NOT NULL,
  `description` text NOT NULL,
  `product` text,
  `technique` text,
  `location` text,
  `segment` text,
  `country` text,
  `predicate_offence` text,
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) NOT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `state` varchar(255) NOT NULL,
  `is_approved_for_anomaly_training` tinyint(1) DEFAULT '0',
  `is_approved_for_alert_training` tinyint(1) DEFAULT '0',
  `is_approved_for_anomaly_prediction` tinyint(1) DEFAULT NULL,
  `is_approved_for_alert_prediction` tinyint(1) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `rejection_reason` longtext,
  `theme` text,
  `financial_instrument` text,
  `industry` text,
  `source_id` VARCHAR(10) NOT NULL DEFAULT '8',
  `sub_segment` text,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `title` (`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS group_values(
	group_code INTEGER NOT NULL,
	value VARCHAR(255) NOT NULL,
	PRIMARY KEY(group_code, value)
);

CREATE TABLE IF NOT EXISTS form_keys(
	form_code INTEGER NOT NULL,
	key_code VARCHAR(255) NOT NULL,
	value_group_code INTEGER NOT NULL,
    data_type VARCHAR(255) NOT NULL,
	is_mandatory BOOLEAN NOT NULL,
	state INTEGER NOT NULL DEFAULT 0,
	is_edge_multiselect tinyint NULL DEFAULT 0,
    is_node_multiselect tinyint NULL DEFAULT 0,
	PRIMARY KEY(form_code, key_code)
);

CREATE TABLE IF NOT EXISTS nodes (
id	BIGINT NOT NULL AUTO_INCREMENT,
typology_id BIGINT NOT NULL,
name VARCHAR(255) NOT NULL,
node_type	INTEGER NOT NULL,
properties	TEXT,
ui_properties TEXT ,
specified_group_nodes VARCHAR(255),
specified_group_type VARCHAR(255),
PRIMARY KEY(id),
CONSTRAINT FK1_nodes FOREIGN KEY (typology_id) REFERENCES typologies(id),
CONSTRAINT CHK_node_type CHECK(node_type=0 OR node_type=1 OR node_type=2),
CONSTRAINT CHK_specified_group_type
	CHECK(specified_group_type=null OR specified_group_type='Or' OR specified_group_type='And')
);

CREATE TABLE IF NOT EXISTS edges(
id	BIGINT NOT NULL AUTO_INCREMENT,
typology_id BIGINT NOT NULL,
description VARCHAR(255),
ui_properties TEXT,
first_node_id  BIGINT NOT NULL,
second_node_id  BIGINT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT FK3_edges FOREIGN KEY (typology_id) REFERENCES typologies(id),
CONSTRAINT FK1_edges FOREIGN KEY (first_node_id) REFERENCES nodes(id),
CONSTRAINT FK2_edges FOREIGN KEY (second_node_id) REFERENCES nodes(id)
);

CREATE TABLE IF NOT EXISTS relationships(
id	BIGINT NOT NULL AUTO_INCREMENT,
typology_id BIGINT NOT NULL,
edge_id BIGINT NOT NULL,
relationship_type  INTEGER NOT NULL,
properties	TEXT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT FK1_relationships FOREIGN KEY (edge_id) REFERENCES edges(id),
CONSTRAINT FK2_relationships FOREIGN KEY (typology_id) REFERENCES typologies(id),
CONSTRAINT CHK_relationship_type CHECK(relationship_type=0 OR relationship_type=1)
);

CREATE TABLE IF NOT EXISTS notes(
id	BIGINT NOT NULL AUTO_INCREMENT,
typology_id BIGINT NOT NULL,
note TEXT NOT NULL,
created_time	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
PRIMARY KEY(id, typology_id),
CONSTRAINT FK1_notes FOREIGN KEY (typology_id) REFERENCES typologies(id)
);

CREATE TABLE `user_typology_mapping` (
  `user_name` varchar(255) NOT NULL COMMENT 'user who created the typology',
  `typology_id` bigint(20) NOT NULL COMMENT 'list of typologies',
  KEY `cases_typology_id_fk` (`typology_id`),
  CONSTRAINT `user_typology_id_fk` FOREIGN KEY (`typology_id`) REFERENCES `typologies` (`id`), UNIQUE KEY `user_typology_id_uk` (`user_name`, `typology_id`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
