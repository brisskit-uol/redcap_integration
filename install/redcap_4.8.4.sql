-- ----------------------------------------- --
-- REDCap Installation SQL --
-- ----------------------------------------- --

--
-- Table structure for table 'redcap_actions'
--

CREATE TABLE redcap_actions (
  action_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(10) DEFAULT NULL,
  action_trigger enum('MANUAL','ENDOFSURVEY','SURVEYQUESTION') COLLATE utf8_unicode_ci DEFAULT NULL,
  action_response enum('NONE','EMAIL','STOPSURVEY','PROMPT') COLLATE utf8_unicode_ci DEFAULT NULL,
  custom_text text COLLATE utf8_unicode_ci,
  recipient_id int(5) DEFAULT NULL COMMENT 'FK user_information',
  PRIMARY KEY (action_id),
  KEY project_id (project_id),
  KEY recipient_id (recipient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_auth'
--

CREATE TABLE redcap_auth (
  username varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  temp_pwd int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_auth_history'
--

CREATE TABLE redcap_auth_history (
  username varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `timestamp` datetime DEFAULT NULL,
  KEY username (username),
  KEY username_password (username,`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores last 5 passwords';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_config'
--

CREATE TABLE redcap_config (
  field_name varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `value` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (field_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores global settings';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_dashboard_concept_codes'
--

CREATE TABLE redcap_dashboard_concept_codes (
  project_id int(5) NOT NULL DEFAULT '0',
  cui varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (project_id,cui),
  KEY cui (cui),
  KEY project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_dashboard_ip_location_cache'
--

CREATE TABLE redcap_dashboard_ip_location_cache (
  ip varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  latitude varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  longitude varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  city varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  region varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  country varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_data'
--

CREATE TABLE redcap_data (
  project_id int(5) NOT NULL DEFAULT '0',
  event_id int(10) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  field_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8_unicode_ci,
  KEY project_id (project_id),
  KEY event_id (event_id),
  KEY record_field (record,field_name),
  KEY project_field (project_id,field_name),
  KEY project_record (project_id,record),
  KEY proj_record_field (project_id,record,field_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_data_access_groups'
--

CREATE TABLE redcap_data_access_groups (
  group_id int(5) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  group_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (group_id),
  KEY project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_data_quality_changelog'
--

CREATE TABLE redcap_data_quality_changelog (
  com_id int(10) NOT NULL AUTO_INCREMENT,
  status_id int(10) DEFAULT NULL,
  user_id int(10) DEFAULT NULL,
  change_time datetime NOT NULL,
  `comment` text COLLATE utf8_unicode_ci COMMENT 'Only if comment was left',
  new_status int(2) DEFAULT NULL COMMENT 'Only if status changed',
  PRIMARY KEY (com_id),
  KEY user_id (user_id),
  KEY status_id (status_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_data_quality_rules'
--

CREATE TABLE redcap_data_quality_rules (
  rule_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(10) DEFAULT NULL,
  rule_order int(3) DEFAULT '1',
  rule_name text COLLATE utf8_unicode_ci,
  rule_logic text COLLATE utf8_unicode_ci,
  PRIMARY KEY (rule_id),
  KEY project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_data_quality_status'
--

CREATE TABLE redcap_data_quality_status (
  status_id int(10) NOT NULL AUTO_INCREMENT,
  rule_id int(10) DEFAULT NULL,
  pd_rule_id int(2) DEFAULT NULL COMMENT 'Name of pre-defined rules',
  project_id int(11) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  field_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Only used if field-level is required',
  `status` int(2) DEFAULT '0' COMMENT 'Current status of discrepancy',
  exclude int(1) NOT NULL DEFAULT '0' COMMENT 'Hide from results',
  PRIMARY KEY (status_id),
  UNIQUE KEY rule_record_event (rule_id,record,event_id),
  UNIQUE KEY pd_rule_proj_record_event_field (pd_rule_id,record,event_id,field_name,project_id),
  KEY rule_id (rule_id),
  KEY event_id (event_id),
  KEY pd_rule_id (pd_rule_id),
  KEY project_id (project_id),
  KEY pd_rule_proj_record_event (pd_rule_id,record,event_id,project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_docs'
--

CREATE TABLE redcap_docs (
  docs_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(5) NOT NULL DEFAULT '0',
  docs_date date DEFAULT NULL,
  docs_name text COLLATE utf8_unicode_ci,
  docs_size double DEFAULT NULL,
  docs_type text COLLATE utf8_unicode_ci,
  docs_file longblob,
  docs_comment text COLLATE utf8_unicode_ci,
  docs_rights text COLLATE utf8_unicode_ci,
  export_file int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (docs_id),
  KEY docs_name (docs_name(128)),
  KEY project_id (project_id),
  KEY project_id_export_file (project_id,export_file),
  KEY project_id_comment (project_id,docs_comment(128))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_docs_to_edocs'
--

CREATE TABLE redcap_docs_to_edocs (
  docs_id int(11) NOT NULL COMMENT 'PK redcap_docs',
  doc_id int(11) NOT NULL COMMENT 'PK redcap_edocs_metadata',
  PRIMARY KEY (docs_id,doc_id),
  KEY docs_id (docs_id),
  KEY doc_id (doc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_edocs_metadata'
--

CREATE TABLE redcap_edocs_metadata (
  doc_id int(10) NOT NULL AUTO_INCREMENT,
  stored_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'stored name',
  mime_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  doc_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  doc_size int(10) DEFAULT NULL,
  file_extension varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_id int(5) DEFAULT NULL,
  stored_date datetime DEFAULT NULL COMMENT 'stored date',
  delete_date datetime DEFAULT NULL COMMENT 'date deleted',
  date_deleted_server datetime DEFAULT NULL COMMENT 'When really deleted from server',
  PRIMARY KEY (doc_id),
  KEY project_id (project_id),
  KEY date_deleted (delete_date,date_deleted_server)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_esignatures'
--

CREATE TABLE redcap_esignatures (
  esign_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (esign_id),
  UNIQUE KEY proj_rec_event_form (project_id,record,event_id,form_name),
  KEY username (username),
  KEY proj_rec_event (project_id,record,event_id),
  KEY project_id (project_id),
  KEY event_id (event_id),
  KEY proj_rec (project_id,record)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_events_arms'
--

CREATE TABLE redcap_events_arms (
  arm_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(5) NOT NULL DEFAULT '0',
  arm_num int(2) NOT NULL DEFAULT '1',
  arm_name varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Arm 1',
  PRIMARY KEY (arm_id),
  UNIQUE KEY proj_arm_num (project_id,arm_num),
  KEY project_id (project_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_events_calendar'
--

CREATE TABLE redcap_events_calendar (
  cal_id int(10) NOT NULL AUTO_INCREMENT,
  record varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_id int(5) DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  baseline_date date DEFAULT NULL,
  group_id int(5) DEFAULT NULL,
  event_date date DEFAULT NULL,
  event_time varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'HH:MM',
  event_status int(2) DEFAULT NULL COMMENT 'NULL=Ad Hoc, 0=Due Date, 1=Scheduled, 2=Confirmed, 3=Cancelled, 4=No Show',
  note_type int(2) DEFAULT NULL,
  notes text COLLATE utf8_unicode_ci,
  extra_notes text COLLATE utf8_unicode_ci,
  PRIMARY KEY (cal_id),
  KEY project_date (project_id,event_date),
  KEY project_record (project_id,record),
  KEY project_id (project_id),
  KEY event_id (event_id),
  KEY group_id (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Calendar Data';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_events_forms'
--

CREATE TABLE redcap_events_forms (
  event_id int(10) NOT NULL DEFAULT '0',
  form_name varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  UNIQUE KEY event_form (event_id,form_name),
  KEY event_id (event_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_events_metadata'
--

CREATE TABLE redcap_events_metadata (
  event_id int(10) NOT NULL auto_increment,
  arm_id int(10) NOT NULL default '0' COMMENT 'FK for events_arms',
  day_offset float NOT NULL default '0' COMMENT 'Days from Start Date',
  offset_min float NOT NULL default '0',
  offset_max float NOT NULL default '0',
  descrip varchar(255) collate utf8_unicode_ci NOT NULL default 'Event 1' COMMENT 'Event Name',
  external_id varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (event_id),
  KEY arm_id (arm_id),
  KEY external_id (external_id),
  KEY arm_dayoffset_descrip (arm_id,day_offset,descrip),
  KEY day_offset (day_offset),
  KEY descrip (descrip)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_external_links'
--

CREATE TABLE redcap_external_links (
  ext_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(10) DEFAULT NULL,
  link_order int(5) NOT NULL DEFAULT '1',
  link_url text COLLATE utf8_unicode_ci,
  link_label text COLLATE utf8_unicode_ci,
  open_new_window int(10) NOT NULL DEFAULT '0',
  link_type enum('LINK','POST_AUTHKEY','REDCAP_PROJECT') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'LINK',
  user_access enum('ALL','DAG','SELECTED') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ALL',
  append_record_info int(1) NOT NULL DEFAULT '0' COMMENT 'Append record and event to URL',
  link_to_project_id int(10) DEFAULT NULL,
  PRIMARY KEY (ext_id),
  KEY project_id (project_id),
  KEY link_to_project_id (link_to_project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_external_links_dags'
--

CREATE TABLE redcap_external_links_dags (
  ext_id int(11) NOT NULL AUTO_INCREMENT,
  group_id int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (ext_id,group_id),
  KEY ext_id (ext_id),
  KEY group_id (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_external_links_users'
--

CREATE TABLE redcap_external_links_users (
  ext_id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (ext_id,username),
  KEY ext_id (ext_id),
  KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_library_map'
--

CREATE TABLE redcap_library_map (
  project_id int(5) NOT NULL DEFAULT '0',
  form_name varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '1 = Downloaded; 2 = Uploaded',
  library_id int(10) NOT NULL DEFAULT '0',
  upload_timestamp datetime DEFAULT NULL,
  acknowledgement text COLLATE utf8_unicode_ci,
  acknowledgement_cache datetime DEFAULT NULL,
  PRIMARY KEY (project_id,form_name,`type`,library_id),
  KEY project_id (project_id),
  KEY library_id (library_id),
  KEY form_name (form_name),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_locking_data'
--

CREATE TABLE redcap_locking_data (
  ld_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (ld_id),
  UNIQUE KEY proj_rec_event_form (project_id,record,event_id,form_name),
  KEY username (username),
  KEY proj_rec_event (project_id,record,event_id),
  KEY project_id (project_id),
  KEY event_id (event_id),
  KEY proj_rec (project_id,record)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_locking_labels'
--

CREATE TABLE redcap_locking_labels (
  ll_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(11) DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  label text COLLATE utf8_unicode_ci,
  display int(1) NOT NULL DEFAULT '1',
  display_esignature int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (ll_id),
  UNIQUE KEY project_form (project_id,form_name),
  KEY project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_log_event'
--

CREATE TABLE redcap_log_event (
  log_event_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(5) NOT NULL DEFAULT '0',
  ts bigint(14) DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  ip varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `page` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event` enum('UPDATE','INSERT','DELETE','SELECT','ERROR','LOGIN','LOGOUT','OTHER','DATA_EXPORT','DOC_UPLOAD','DOC_DELETE','MANAGE','LOCK_RECORD','ESIGNATURE') COLLATE utf8_unicode_ci DEFAULT NULL,
  object_type varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  sql_log mediumtext COLLATE utf8_unicode_ci,
  pk text COLLATE utf8_unicode_ci,
  event_id int(10) DEFAULT NULL,
  data_values text COLLATE utf8_unicode_ci,
  description text COLLATE utf8_unicode_ci,
  legacy int(1) NOT NULL DEFAULT '0',
  change_reason text COLLATE utf8_unicode_ci,
  PRIMARY KEY (log_event_id),
  KEY `user` (`user`),
  KEY project_id (project_id),
  KEY user_project (project_id,`user`),
  KEY pk (pk(64)),
  KEY object_type (object_type),
  KEY ts (ts),
  KEY `event` (`event`),
  KEY event_project (`event`,project_id),
  KEY description (description(128))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_log_view'
--

CREATE TABLE redcap_log_view (
  log_view_id int(11) NOT NULL AUTO_INCREMENT,
  ts timestamp NULL DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event` enum('LOGIN_SUCCESS','LOGIN_FAIL','LOGOUT','PAGE_VIEW') COLLATE utf8_unicode_ci DEFAULT NULL,
  ip varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  browser_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  browser_version varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  full_url text COLLATE utf8_unicode_ci,
  `page` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_id int(5) DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  record varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  miscellaneous text COLLATE utf8_unicode_ci,
  session_id varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (log_view_id),
  KEY `user` (`user`),
  KEY project_id (project_id),
  KEY ts (ts),
  KEY ip (ip),
  KEY `event` (`event`),
  KEY browser_name (browser_name),
  KEY browser_version (browser_version),
  KEY `page` (`page`),
  KEY session_id (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_metadata'
--

CREATE TABLE redcap_metadata (
  project_id int(5) NOT NULL DEFAULT '0',
  field_name varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  field_phi varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_menu_description varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  field_order float DEFAULT NULL,
  field_units varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_preceding_header mediumtext COLLATE utf8_unicode_ci,
  element_type varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_label mediumtext COLLATE utf8_unicode_ci,
  element_enum mediumtext COLLATE utf8_unicode_ci,
  element_note mediumtext COLLATE utf8_unicode_ci,
  element_validation_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_min varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_max varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_checktype varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  branching_logic text COLLATE utf8_unicode_ci,
  field_req int(1) NOT NULL DEFAULT '0',
  edoc_id int(10) DEFAULT NULL COMMENT 'image/file attachment',
  edoc_display_img int(1) NOT NULL DEFAULT '0',
  custom_alignment enum('LH','LV','RH','RV') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'RV = NULL = default',
  stop_actions text COLLATE utf8_unicode_ci,
  question_num varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (project_id,field_name),
  KEY project_id_form (project_id,form_name),
  KEY field_name (field_name),
  KEY project_id (project_id),
  KEY project_id_fieldorder (project_id,field_order),
  KEY edoc_id (edoc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_metadata_archive'
--

CREATE TABLE redcap_metadata_archive (
  project_id int(5) NOT NULL DEFAULT '0',
  field_name varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  field_phi varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_menu_description varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  field_order float DEFAULT NULL,
  field_units varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_preceding_header mediumtext COLLATE utf8_unicode_ci,
  element_type varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_label mediumtext COLLATE utf8_unicode_ci,
  element_enum mediumtext COLLATE utf8_unicode_ci,
  element_note mediumtext COLLATE utf8_unicode_ci,
  element_validation_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_min varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_max varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_checktype varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  branching_logic text COLLATE utf8_unicode_ci,
  field_req int(1) NOT NULL DEFAULT '0',
  edoc_id int(10) DEFAULT NULL COMMENT 'image/file attachment',
  edoc_display_img int(1) NOT NULL DEFAULT '0',
  custom_alignment enum('LH','LV','RH','RV') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'RV = NULL = default',
  stop_actions text COLLATE utf8_unicode_ci,
  question_num varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  pr_id int(10) DEFAULT NULL,
  UNIQUE KEY project_field_prid (project_id,field_name,pr_id),
  KEY project_id_form (project_id,form_name),
  KEY field_name (field_name),
  KEY project_id (project_id),
  KEY pr_id (pr_id),
  KEY edoc_id (edoc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_metadata_prod_revisions'
--

CREATE TABLE redcap_metadata_prod_revisions (
  pr_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(5) NOT NULL DEFAULT '0',
  ui_id_requester int(5) DEFAULT NULL,
  ui_id_approver int(5) DEFAULT NULL,
  ts_req_approval datetime DEFAULT NULL,
  ts_approved datetime DEFAULT NULL,
  PRIMARY KEY (pr_id),
  KEY project_id (project_id),
  KEY project_user (project_id,ui_id_requester),
  KEY project_approved (project_id,ts_approved),
  KEY ui_id_requester (ui_id_requester),
  KEY ui_id_approver (ui_id_approver)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_metadata_temp'
--

CREATE TABLE redcap_metadata_temp (
  project_id int(5) NOT NULL DEFAULT '0',
  field_name varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  field_phi varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  form_menu_description varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  field_order float DEFAULT NULL,
  field_units varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_preceding_header mediumtext COLLATE utf8_unicode_ci,
  element_type varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_label mediumtext COLLATE utf8_unicode_ci,
  element_enum mediumtext COLLATE utf8_unicode_ci,
  element_note mediumtext COLLATE utf8_unicode_ci,
  element_validation_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_min varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_max varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  element_validation_checktype varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  branching_logic text COLLATE utf8_unicode_ci,
  field_req int(1) NOT NULL DEFAULT '0',
  edoc_id int(10) DEFAULT NULL COMMENT 'image/file attachment',
  edoc_display_img int(1) NOT NULL DEFAULT '0',
  custom_alignment enum('LH','LV','RH','RV') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'RV = NULL = default',
  stop_actions text COLLATE utf8_unicode_ci,
  question_num varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (project_id,field_name),
  KEY project_id_form (project_id,form_name),
  KEY field_name (field_name),
  KEY project_id (project_id),
  KEY edoc_id (edoc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_migration_script'
--

CREATE TABLE redcap_migration_script (
  id int(5) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  script longblob,
  PRIMARY KEY (id),
  KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Holds SQL for migrating REDCap Survey surveys';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_page_hits'
--

CREATE TABLE redcap_page_hits (
  `date` date NOT NULL,
  page_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  page_hits float NOT NULL DEFAULT '1',
  UNIQUE KEY `date` (`date`,page_name),
  KEY date2 (`date`),
  KEY page_name (page_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_projects'
--

CREATE TABLE redcap_projects (
  project_id int(5) NOT NULL AUTO_INCREMENT,
  project_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  app_title text COLLATE utf8_unicode_ci,
  `status` int(1) NOT NULL DEFAULT '0',
  creation_time datetime DEFAULT NULL,
  production_time datetime DEFAULT NULL,
  inactive_time datetime DEFAULT NULL,
  created_by int(5) DEFAULT NULL COMMENT 'FK from User Info',
  draft_mode int(1) NOT NULL DEFAULT '0',
  surveys_enabled int(1) NOT NULL DEFAULT '0' COMMENT '0 = forms only, 1 = survey+forms, 2 = single survey only',
  repeatforms int(1) NOT NULL DEFAULT '0',
  scheduling int(1) NOT NULL DEFAULT '0',
  purpose int(2) DEFAULT NULL,
  purpose_other text COLLATE utf8_unicode_ci,
  show_which_records int(1) NOT NULL DEFAULT '0',
  __SALT__ varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Alphanumeric hash unique to each project',
  count_project int(1) NOT NULL DEFAULT '1',
  investigators text COLLATE utf8_unicode_ci,
  project_note text COLLATE utf8_unicode_ci,
  online_offline int(1) NOT NULL DEFAULT '1',
  auth_meth varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  double_data_entry int(1) NOT NULL DEFAULT '0',
  project_language varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'English',
  is_child_of varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  date_shift_max int(10) NOT NULL DEFAULT '364',
  institution text COLLATE utf8_unicode_ci,
  site_org_type text COLLATE utf8_unicode_ci,
  grant_cite text COLLATE utf8_unicode_ci,
  project_contact_name text COLLATE utf8_unicode_ci,
  project_contact_email text COLLATE utf8_unicode_ci,
  project_contact_prod_changes_name text COLLATE utf8_unicode_ci,
  project_contact_prod_changes_email text COLLATE utf8_unicode_ci,
  headerlogo text COLLATE utf8_unicode_ci,
  auto_inc_set int(1) NOT NULL DEFAULT '0',
  custom_data_entry_note text COLLATE utf8_unicode_ci,
  custom_index_page_note text COLLATE utf8_unicode_ci,
  order_id_by varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  custom_reports mediumtext COLLATE utf8_unicode_ci COMMENT 'Legacy report builder',
  report_builder mediumtext COLLATE utf8_unicode_ci,
  mobile_project int(1) NOT NULL DEFAULT '0',
  mobile_project_export_flag int(1) NOT NULL DEFAULT '1',
  disable_data_entry int(1) NOT NULL DEFAULT '0',
  google_translate_default varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  require_change_reason int(1) NOT NULL DEFAULT '0',
  dts_enabled int(1) NOT NULL DEFAULT '0',
  project_pi_firstname varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_pi_mi varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_pi_lastname varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_pi_email varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_pi_alias varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_pi_username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_irb_number varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  project_grant_number varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  history_widget_enabled int(1) NOT NULL DEFAULT '1',
  secondary_pk varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'field_name of seconary identifier',
  custom_record_label text COLLATE utf8_unicode_ci,
  display_project_logo_institution int(1) NOT NULL DEFAULT '1',
  imported_from_rs int(1) NOT NULL DEFAULT '0' COMMENT 'If imported from REDCap Survey',
  display_today_now_button int(1) NOT NULL DEFAULT '1',
  auto_variable_naming int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (project_id),
  UNIQUE KEY project_name (project_name),
  KEY created_by (created_by)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores project-level values';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_project_checklist'
--

CREATE TABLE redcap_project_checklist (
  list_id int(11) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (list_id),
  UNIQUE KEY project_name (project_id,`name`),
  KEY project_id (project_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_pubmed_articles'
--

CREATE TABLE redcap_pubmed_articles (
  article_id int(10) NOT NULL AUTO_INCREMENT,
  pmid int(10) DEFAULT NULL,
  title text COLLATE utf8_unicode_ci,
  pub_date date DEFAULT NULL,
  epub_date date DEFAULT NULL,
  PRIMARY KEY (article_id),
  UNIQUE KEY pmid (pmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='PubMed article info';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_pubmed_authors'
--

CREATE TABLE redcap_pubmed_authors (
  author_id int(10) NOT NULL AUTO_INCREMENT,
  article_id int(10) DEFAULT NULL,
  author varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'AU from PubMed',
  PRIMARY KEY (author_id),
  KEY article_id (article_id),
  KEY author (author)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='PubMed article authors';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_pubmed_match_pi'
--

CREATE TABLE redcap_pubmed_match_pi (
  mpi_id int(10) NOT NULL AUTO_INCREMENT,
  article_id int(10) DEFAULT NULL,
  project_pi varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'PI name from redcap_projects',
  article_pi_match int(1) DEFAULT NULL COMMENT 'Is this the PI''s article?',
  times_emailed int(3) NOT NULL DEFAULT '0',
  unique_hash varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (mpi_id),
  UNIQUE KEY unique_hash (unique_hash),
  KEY article_id (article_id),
  KEY project_pi (project_pi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Confirm if article belongs to PI';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_pubmed_match_project'
--

CREATE TABLE redcap_pubmed_match_project (
  mpr_id int(10) NOT NULL AUTO_INCREMENT,
  mpi_id int(10) DEFAULT NULL,
  project_id int(10) DEFAULT NULL,
  PRIMARY KEY (mpr_id),
  KEY project_id (project_id),
  KEY mpi_id (mpi_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Projects matched to article by the PI';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_pubmed_mesh_terms'
--

CREATE TABLE redcap_pubmed_mesh_terms (
  mesh_id int(10) NOT NULL AUTO_INCREMENT,
  article_id int(10) DEFAULT NULL,
  mesh_term varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (mesh_id),
  KEY article_id (article_id),
  KEY mesh_term (mesh_term)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_randomization'
--

CREATE TABLE redcap_randomization (
  rid int(10) NOT NULL AUTO_INCREMENT,
  project_id int(10) DEFAULT NULL,
  target_field varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  target_event int(10) DEFAULT NULL,
  source_field1 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event1 int(10) DEFAULT NULL,
  source_field2 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event2 int(10) DEFAULT NULL,
  source_field3 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event3 int(10) DEFAULT NULL,
  source_field4 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event4 int(10) DEFAULT NULL,
  source_field5 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event5 int(10) DEFAULT NULL,
  source_field6 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event6 int(10) DEFAULT NULL,
  source_field7 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event7 int(10) DEFAULT NULL,
  source_field8 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event8 int(10) DEFAULT NULL,
  source_field9 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event9 int(10) DEFAULT NULL,
  source_field10 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event10 int(10) DEFAULT NULL,
  source_field11 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event11 int(10) DEFAULT NULL,
  source_field12 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event12 int(10) DEFAULT NULL,
  source_field13 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event13 int(10) DEFAULT NULL,
  source_field14 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event14 int(10) DEFAULT NULL,
  source_field15 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  source_event15 int(10) DEFAULT NULL,
  PRIMARY KEY (rid),
  UNIQUE KEY project_id (project_id),
  KEY target_event (target_event),
  KEY source_event1 (source_event1),
  KEY source_event2 (source_event2),
  KEY source_event3 (source_event3),
  KEY source_event4 (source_event4),
  KEY source_event5 (source_event5),
  KEY source_event6 (source_event6),
  KEY source_event7 (source_event7),
  KEY source_event8 (source_event8),
  KEY source_event9 (source_event9),
  KEY source_event10 (source_event10),
  KEY source_event11 (source_event11),
  KEY source_event12 (source_event12),
  KEY source_event13 (source_event13),
  KEY source_event14 (source_event14),
  KEY source_event15 (source_event15)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_randomization_allocation'
--

CREATE TABLE redcap_randomization_allocation (
  aid int(10) NOT NULL AUTO_INCREMENT,
  rid int(10) NOT NULL DEFAULT '0',
  is_used int(1) NOT NULL DEFAULT '0' COMMENT 'Used by a record?',
  target_field varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field1 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field2 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field3 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field4 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field5 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field6 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field7 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field8 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field9 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field10 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field11 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field12 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field13 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field14 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  source_field15 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Data value',
  PRIMARY KEY (aid),
  KEY rid (rid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_sendit_docs'
--

CREATE TABLE redcap_sendit_docs (
  document_id int(11) NOT NULL AUTO_INCREMENT,
  doc_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  doc_orig_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  doc_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  doc_size int(11) DEFAULT NULL,
  send_confirmation int(1) NOT NULL DEFAULT '0',
  expire_date datetime DEFAULT NULL,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  location int(1) NOT NULL DEFAULT '0' COMMENT '1 = Home page; 2 = File Repository; 3 = Form',
  docs_id int(11) NOT NULL DEFAULT '0',
  date_added datetime DEFAULT NULL,
  date_deleted datetime DEFAULT NULL COMMENT 'When really deleted from server (only applicable for location=1)',
  PRIMARY KEY (document_id),
  KEY user_id (username),
  KEY docs_id_location (location,docs_id),
  KEY expire_location_deleted (expire_date,location,date_deleted),
  KEY date_added (date_added)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_sendit_recipients'
--

CREATE TABLE redcap_sendit_recipients (
  recipient_id int(11) NOT NULL AUTO_INCREMENT,
  email_address varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  sent_confirmation int(1) NOT NULL DEFAULT '0',
  download_date datetime DEFAULT NULL,
  download_count int(11) NOT NULL DEFAULT '0',
  document_id int(11) NOT NULL DEFAULT '0' COMMENT 'FK from redcap_sendit_docs',
  guid varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  pwd varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (recipient_id),
  KEY document_id (document_id),
  KEY email_address (email_address),
  KEY guid (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_sessions'
--

CREATE TABLE redcap_sessions (
  session_id varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  session_data text COLLATE utf8_unicode_ci,
  session_expiration timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores user authentication session data';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_standard'
--

CREATE TABLE redcap_standard (
  standard_id int(5) NOT NULL AUTO_INCREMENT,
  standard_name varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_version varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_desc varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (standard_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_standard_code'
--

CREATE TABLE redcap_standard_code (
  standard_code_id int(5) NOT NULL AUTO_INCREMENT,
  standard_code varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_code_desc varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_id int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (standard_code_id),
  KEY standard_id (standard_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_standard_map'
--

CREATE TABLE redcap_standard_map (
  standard_map_id int(5) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  field_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_code_id int(5) NOT NULL DEFAULT '0',
  data_conversion mediumtext COLLATE utf8_unicode_ci,
  data_conversion2 mediumtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (standard_map_id),
  KEY standard_code_id (standard_code_id),
  KEY project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_standard_map_audit'
--

CREATE TABLE redcap_standard_map_audit (
  audit_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(5) DEFAULT NULL,
  field_name varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  standard_code int(5) DEFAULT NULL,
  action_id int(10) DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (audit_id),
  KEY project_id (project_id),
  KEY action_id (action_id),
  KEY standard_code (standard_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_standard_map_audit_action'
--

CREATE TABLE redcap_standard_map_audit_action (
  id int(10) NOT NULL DEFAULT '0',
  `action` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys'
--

CREATE TABLE redcap_surveys (
  survey_id int(10) NOT NULL AUTO_INCREMENT,
  project_id int(10) DEFAULT NULL,
  form_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'NULL = assume first form',
  title text COLLATE utf8_unicode_ci COMMENT 'Survey title',
  instructions text COLLATE utf8_unicode_ci COMMENT 'Survey instructions',
  acknowledgement text COLLATE utf8_unicode_ci COMMENT 'Survey acknowledgement',
  question_by_section int(1) NOT NULL DEFAULT '0' COMMENT '0 = one-page survey',
  question_auto_numbering int(1) NOT NULL DEFAULT '1',
  survey_enabled int(1) NOT NULL DEFAULT '1',
  save_and_return int(1) NOT NULL DEFAULT '0',
  logo int(10) DEFAULT NULL COMMENT 'FK for redcap_edocs_metadata',
  hide_title int(1) NOT NULL DEFAULT '0',
  email_field varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Field name that stores participant email',
  view_results int(1) NOT NULL DEFAULT '0',
  min_responses_view_results int(5) NOT NULL DEFAULT '10',
  check_diversity_view_results int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (survey_id),
  UNIQUE KEY logo (logo),
  UNIQUE KEY project_form (project_id,form_name),
  KEY project_id (project_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table for survey data';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_banned_ips'
--

CREATE TABLE redcap_surveys_banned_ips (
  ip varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  time_of_ban timestamp NULL DEFAULT NULL,
  PRIMARY KEY (ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_emails'
--

CREATE TABLE redcap_surveys_emails (
  email_id int(10) NOT NULL AUTO_INCREMENT,
  survey_id int(10) DEFAULT NULL,
  email_subject text COLLATE utf8_unicode_ci,
  email_content text COLLATE utf8_unicode_ci,
  email_sender int(10) DEFAULT NULL COMMENT 'FK ui_id from redcap_user_information',
  email_sent datetime DEFAULT NULL,
  PRIMARY KEY (email_id),
  KEY survey_id (survey_id),
  KEY email_sender (email_sender)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Track emails sent out';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_emails_recipients'
--

CREATE TABLE redcap_surveys_emails_recipients (
  email_recip_id int(10) NOT NULL AUTO_INCREMENT,
  email_id int(10) DEFAULT NULL COMMENT 'FK redcap_surveys_emails',
  participant_id int(10) DEFAULT NULL COMMENT 'FK redcap_surveys_participants',
  PRIMARY KEY (email_recip_id),
  KEY emt_id (email_id),
  KEY participant_id (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Track email recipients';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_ip_cache'
--

CREATE TABLE redcap_surveys_ip_cache (
  ip_hash varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  KEY `timestamp` (`timestamp`),
  KEY ip_hash (ip_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_participants'
--

CREATE TABLE redcap_surveys_participants (
  participant_id int(10) NOT NULL AUTO_INCREMENT,
  survey_id int(10) DEFAULT NULL,
  event_id int(10) DEFAULT NULL,
  `hash` varchar(6) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
  legacy_hash varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Migrated from RS',
  participant_email varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'NULL if public survey',
  participant_identifier varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (participant_id),
  UNIQUE KEY `hash` (`hash`),
  UNIQUE KEY legacy_hash (legacy_hash),
  KEY survey_id (survey_id),
  KEY participant_email (participant_email),
  KEY survey_event_email (survey_id,event_id,participant_email),
  KEY event_id (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table for survey data';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_response'
--

CREATE TABLE redcap_surveys_response (
  response_id int(11) NOT NULL AUTO_INCREMENT,
  participant_id int(10) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  first_submit_time datetime DEFAULT NULL,
  completion_time datetime DEFAULT NULL,
  return_code varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  results_code varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (response_id),
  UNIQUE KEY participant_record (participant_id,record),
  KEY return_code (return_code),
  KEY participant_id (participant_id),
  KEY results_code (results_code),
  KEY first_submit_time (first_submit_time),
  KEY completion_time (completion_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_response_users'
--

CREATE TABLE redcap_surveys_response_users (
  response_id int(10) DEFAULT NULL,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY response_user (response_id,username),
  KEY response_id (response_id),
  KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_surveys_response_values'
--

CREATE TABLE redcap_surveys_response_values (
  response_id int(10) DEFAULT NULL,
  project_id int(5) NOT NULL DEFAULT '0',
  event_id int(10) DEFAULT NULL,
  record varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  field_name varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8_unicode_ci,
  KEY project_id (project_id),
  KEY event_id (event_id),
  KEY record_field (record,field_name),
  KEY project_field (project_id,field_name),
  KEY project_record (project_id,record),
  KEY proj_record_field (project_id,record,field_name),
  KEY response_id (response_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Storage for completed survey responses (archival purposes)';

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_user_information'
--

CREATE TABLE redcap_user_information (
  ui_id int(5) NOT NULL AUTO_INCREMENT,
  username varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  user_email varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  user_firstname varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  user_lastname varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  user_inst_id varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  super_user int(1) NOT NULL DEFAULT '0',
  user_firstvisit datetime DEFAULT NULL,
  user_firstactivity datetime DEFAULT NULL,
  user_lastactivity datetime DEFAULT NULL,
  user_suspended_time datetime DEFAULT NULL,
  allow_create_db int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (ui_id),
  UNIQUE KEY username (username)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_user_rights'
--

CREATE TABLE redcap_user_rights (
  project_id int(5) NOT NULL DEFAULT '0',
  username varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  expiration date DEFAULT NULL,
  group_id int(5) DEFAULT NULL,
  lock_record int(1) NOT NULL DEFAULT '0',
  lock_record_multiform int(1) NOT NULL DEFAULT '0',
  lock_record_customize int(1) NOT NULL DEFAULT '0',
  data_export_tool int(1) NOT NULL DEFAULT '1',
  data_import_tool int(1) NOT NULL DEFAULT '1',
  data_comparison_tool int(1) NOT NULL DEFAULT '1',
  data_logging int(1) NOT NULL DEFAULT '1',
  file_repository int(1) NOT NULL DEFAULT '1',
  double_data int(1) NOT NULL DEFAULT '0',
  user_rights int(1) NOT NULL DEFAULT '1',
  data_access_groups int(1) NOT NULL DEFAULT '1',
  graphical int(1) NOT NULL DEFAULT '1',
  reports int(1) NOT NULL DEFAULT '1',
  design int(1) NOT NULL DEFAULT '0',
  calendar int(1) NOT NULL DEFAULT '1',
  data_entry text COLLATE utf8_unicode_ci,
  api_token varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  api_export int(1) NOT NULL DEFAULT '0',
  api_import int(1) NOT NULL DEFAULT '0',
  record_create int(1) NOT NULL DEFAULT '1',
  record_rename int(1) NOT NULL DEFAULT '0',
  record_delete int(1) NOT NULL DEFAULT '0',
  dts int(1) NOT NULL DEFAULT '0' COMMENT 'DTS adjudication page',
  participants int(1) NOT NULL DEFAULT '1',
  data_quality_design int(1) NOT NULL DEFAULT '0',
  data_quality_execute int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (project_id,username),
  UNIQUE KEY api_token (api_token),
  KEY username (username),
  KEY project_id (project_id),
  KEY group_id (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_user_whitelist'
--

CREATE TABLE redcap_user_whitelist (
  username varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table 'redcap_validation_types'
--

CREATE TABLE redcap_validation_types (
  validation_name varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Unique name for Data Dictionary',
  validation_label varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Label in Online Designer',
  regex_js text COLLATE utf8_unicode_ci,
  regex_php text COLLATE utf8_unicode_ci,
  data_type varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  legacy_value varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  visible int(1) NOT NULL DEFAULT '1' COMMENT 'Show in Online Designer?',
  UNIQUE KEY validation_name (validation_name),
  KEY data_type (data_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `redcap_actions`
--
ALTER TABLE `redcap_actions`
  ADD CONSTRAINT redcap_actions_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_actions_ibfk_2 FOREIGN KEY (recipient_id) REFERENCES redcap_user_information (ui_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_dashboard_concept_codes`
--
ALTER TABLE `redcap_dashboard_concept_codes`
  ADD CONSTRAINT redcap_dashboard_concept_codes_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_data_access_groups`
--
ALTER TABLE `redcap_data_access_groups`
  ADD CONSTRAINT redcap_data_access_groups_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_data_quality_changelog`
--
ALTER TABLE `redcap_data_quality_changelog`
  ADD CONSTRAINT redcap_data_quality_changelog_ibfk_1 FOREIGN KEY (status_id) REFERENCES redcap_data_quality_status (status_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_data_quality_changelog_ibfk_2 FOREIGN KEY (user_id) REFERENCES redcap_user_information (ui_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_data_quality_rules`
--
ALTER TABLE `redcap_data_quality_rules`
  ADD CONSTRAINT redcap_data_quality_rules_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_data_quality_status`
--
ALTER TABLE `redcap_data_quality_status`
  ADD CONSTRAINT redcap_data_quality_status_ibfk_1 FOREIGN KEY (rule_id) REFERENCES redcap_data_quality_rules (rule_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_data_quality_status_ibfk_2 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_data_quality_status_ibfk_3 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_docs`
--
ALTER TABLE `redcap_docs`
  ADD CONSTRAINT redcap_docs_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_docs_to_edocs`
--
ALTER TABLE `redcap_docs_to_edocs`
  ADD CONSTRAINT redcap_docs_to_edocs_ibfk_2 FOREIGN KEY (doc_id) REFERENCES redcap_edocs_metadata (doc_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_docs_to_edocs_ibfk_1 FOREIGN KEY (docs_id) REFERENCES redcap_docs (docs_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_edocs_metadata`
--
ALTER TABLE `redcap_edocs_metadata`
  ADD CONSTRAINT redcap_edocs_metadata_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_esignatures`
--
ALTER TABLE `redcap_esignatures`
  ADD CONSTRAINT redcap_esignatures_ibfk_2 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_esignatures_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_events_arms`
--
ALTER TABLE `redcap_events_arms`
  ADD CONSTRAINT redcap_events_arms_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_events_calendar`
--
ALTER TABLE `redcap_events_calendar`
  ADD CONSTRAINT redcap_events_calendar_ibfk_3 FOREIGN KEY (group_id) REFERENCES redcap_data_access_groups (group_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_events_calendar_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_events_calendar_ibfk_2 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_events_forms`
--
ALTER TABLE `redcap_events_forms`
  ADD CONSTRAINT redcap_events_forms_ibfk_1 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_events_metadata`
--
ALTER TABLE `redcap_events_metadata`
  ADD CONSTRAINT redcap_events_metadata_ibfk_1 FOREIGN KEY (arm_id) REFERENCES redcap_events_arms (arm_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_external_links`
--
ALTER TABLE `redcap_external_links`
  ADD CONSTRAINT redcap_external_links_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_external_links_ibfk_2 FOREIGN KEY (link_to_project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_external_links_dags`
--
ALTER TABLE `redcap_external_links_dags`
  ADD CONSTRAINT redcap_external_links_dags_ibfk_2 FOREIGN KEY (group_id) REFERENCES redcap_data_access_groups (group_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_external_links_dags_ibfk_1 FOREIGN KEY (ext_id) REFERENCES redcap_external_links (ext_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_external_links_users`
--
ALTER TABLE `redcap_external_links_users`
  ADD CONSTRAINT redcap_external_links_users_ibfk_1 FOREIGN KEY (ext_id) REFERENCES redcap_external_links (ext_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_library_map`
--
ALTER TABLE `redcap_library_map`
  ADD CONSTRAINT redcap_library_map_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_locking_data`
--
ALTER TABLE `redcap_locking_data`
  ADD CONSTRAINT redcap_locking_data_ibfk_2 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_locking_data_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_locking_labels`
--
ALTER TABLE `redcap_locking_labels`
  ADD CONSTRAINT redcap_locking_labels_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_metadata`
--
ALTER TABLE `redcap_metadata`
  ADD CONSTRAINT redcap_metadata_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_ibfk_2 FOREIGN KEY (edoc_id) REFERENCES redcap_edocs_metadata (doc_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_metadata_archive`
--
ALTER TABLE `redcap_metadata_archive`
  ADD CONSTRAINT redcap_metadata_archive_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_archive_ibfk_3 FOREIGN KEY (pr_id) REFERENCES redcap_metadata_prod_revisions (pr_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_archive_ibfk_4 FOREIGN KEY (edoc_id) REFERENCES redcap_edocs_metadata (doc_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_metadata_prod_revisions`
--
ALTER TABLE `redcap_metadata_prod_revisions`
  ADD CONSTRAINT redcap_metadata_prod_revisions_ibfk_3 FOREIGN KEY (ui_id_approver) REFERENCES redcap_user_information (ui_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_prod_revisions_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_prod_revisions_ibfk_2 FOREIGN KEY (ui_id_requester) REFERENCES redcap_user_information (ui_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_metadata_temp`
--
ALTER TABLE `redcap_metadata_temp`
  ADD CONSTRAINT redcap_metadata_temp_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_metadata_temp_ibfk_2 FOREIGN KEY (edoc_id) REFERENCES redcap_edocs_metadata (doc_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_projects`
--
ALTER TABLE `redcap_projects`
  ADD CONSTRAINT redcap_projects_ibfk_1 FOREIGN KEY (created_by) REFERENCES redcap_user_information (ui_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_project_checklist`
--
ALTER TABLE `redcap_project_checklist`
  ADD CONSTRAINT redcap_project_checklist_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_pubmed_authors`
--
ALTER TABLE `redcap_pubmed_authors`
  ADD CONSTRAINT redcap_pubmed_authors_ibfk_1 FOREIGN KEY (article_id) REFERENCES redcap_pubmed_articles (article_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_pubmed_match_pi`
--
ALTER TABLE `redcap_pubmed_match_pi`
  ADD CONSTRAINT redcap_pubmed_match_pi_ibfk_1 FOREIGN KEY (article_id) REFERENCES redcap_pubmed_articles (article_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_pubmed_match_project`
--
ALTER TABLE `redcap_pubmed_match_project`
  ADD CONSTRAINT redcap_pubmed_match_project_ibfk_2 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_pubmed_match_project_ibfk_3 FOREIGN KEY (mpi_id) REFERENCES redcap_pubmed_match_pi (mpi_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_pubmed_mesh_terms`
--
ALTER TABLE `redcap_pubmed_mesh_terms`
  ADD CONSTRAINT redcap_pubmed_mesh_terms_ibfk_1 FOREIGN KEY (article_id) REFERENCES redcap_pubmed_articles (article_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_randomization`
--
ALTER TABLE `redcap_randomization`
  ADD CONSTRAINT redcap_randomization_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_2 FOREIGN KEY (source_event1) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_3 FOREIGN KEY (source_event2) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_4 FOREIGN KEY (source_event3) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_5 FOREIGN KEY (source_event4) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_6 FOREIGN KEY (source_event5) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_7 FOREIGN KEY (source_event6) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_8 FOREIGN KEY (source_event7) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_9 FOREIGN KEY (source_event8) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_10 FOREIGN KEY (source_event9) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_11 FOREIGN KEY (source_event10) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_12 FOREIGN KEY (source_event11) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_13 FOREIGN KEY (source_event12) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_14 FOREIGN KEY (source_event13) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_15 FOREIGN KEY (source_event14) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_16 FOREIGN KEY (source_event15) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_randomization_ibfk_17 FOREIGN KEY (target_event) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_randomization_allocation`
--
ALTER TABLE `redcap_randomization_allocation`
  ADD CONSTRAINT redcap_randomization_allocation_ibfk_1 FOREIGN KEY (rid) REFERENCES redcap_randomization (rid) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_sendit_recipients`
--
ALTER TABLE `redcap_sendit_recipients`
  ADD CONSTRAINT redcap_sendit_recipients_ibfk_1 FOREIGN KEY (document_id) REFERENCES redcap_sendit_docs (document_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_standard_code`
--
ALTER TABLE `redcap_standard_code`
  ADD CONSTRAINT redcap_standard_code_ibfk_1 FOREIGN KEY (standard_id) REFERENCES redcap_standard (standard_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_standard_map`
--
ALTER TABLE `redcap_standard_map`
  ADD CONSTRAINT redcap_standard_map_ibfk_2 FOREIGN KEY (standard_code_id) REFERENCES redcap_standard_code (standard_code_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_standard_map_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_standard_map_audit`
--
ALTER TABLE `redcap_standard_map_audit`
  ADD CONSTRAINT redcap_standard_map_audit_ibfk_5 FOREIGN KEY (standard_code) REFERENCES redcap_standard_code (standard_code_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_standard_map_audit_ibfk_2 FOREIGN KEY (action_id) REFERENCES redcap_standard_map_audit_action (id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_standard_map_audit_ibfk_4 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys`
--
ALTER TABLE `redcap_surveys`
  ADD CONSTRAINT redcap_surveys_ibfk_1 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_ibfk_2 FOREIGN KEY (logo) REFERENCES redcap_edocs_metadata (doc_id) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys_emails`
--
ALTER TABLE `redcap_surveys_emails`
  ADD CONSTRAINT redcap_surveys_emails_ibfk_1 FOREIGN KEY (survey_id) REFERENCES redcap_surveys (survey_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_emails_ibfk_2 FOREIGN KEY (email_sender) REFERENCES redcap_user_information (ui_id) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `redcap_surveys_emails_recipients`
--
ALTER TABLE `redcap_surveys_emails_recipients`
  ADD CONSTRAINT redcap_surveys_emails_recipients_ibfk_1 FOREIGN KEY (email_id) REFERENCES redcap_surveys_emails (email_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_emails_recipients_ibfk_2 FOREIGN KEY (participant_id) REFERENCES redcap_surveys_participants (participant_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys_participants`
--
ALTER TABLE `redcap_surveys_participants`
  ADD CONSTRAINT redcap_surveys_participants_ibfk_2 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_participants_ibfk_1 FOREIGN KEY (survey_id) REFERENCES redcap_surveys (survey_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys_response`
--
ALTER TABLE `redcap_surveys_response`
  ADD CONSTRAINT redcap_surveys_response_ibfk_1 FOREIGN KEY (participant_id) REFERENCES redcap_surveys_participants (participant_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys_response_users`
--
ALTER TABLE `redcap_surveys_response_users`
  ADD CONSTRAINT redcap_surveys_response_users_ibfk_1 FOREIGN KEY (response_id) REFERENCES redcap_surveys_response (response_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_surveys_response_values`
--
ALTER TABLE `redcap_surveys_response_values`
  ADD CONSTRAINT redcap_surveys_response_values_ibfk_1 FOREIGN KEY (response_id) REFERENCES redcap_surveys_response (response_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_response_values_ibfk_2 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_surveys_response_values_ibfk_3 FOREIGN KEY (event_id) REFERENCES redcap_events_metadata (event_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `redcap_user_rights`
--
ALTER TABLE `redcap_user_rights`
  ADD CONSTRAINT redcap_user_rights_ibfk_2 FOREIGN KEY (project_id) REFERENCES redcap_projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT redcap_user_rights_ibfk_3 FOREIGN KEY (group_id) REFERENCES redcap_data_access_groups (group_id) ON DELETE SET NULL ON UPDATE CASCADE;

  
ALTER TABLE  `redcap_external_links` ADD  `append_pid` INT( 1 ) NOT NULL DEFAULT  '0' 
	COMMENT  'Append project_id to URL' AFTER  `append_record_info`;
-- REDCAP INSTALLATION INITIAL DATA --

INSERT INTO redcap_user_information 
(username, user_email, user_firstname, user_lastname, super_user, user_firstvisit) VALUES
('site_admin', 'joe.user@project-redcap.org', 'Joe', 'User', 1, now());

INSERT INTO redcap_standard_map_audit_action (id, action) VALUES
(1, 'add mapped field'),
(2, 'modify mapped field'),
(3, 'remove mapped field');

INSERT INTO redcap_config (field_name, value) VALUES
('allow_create_db_default', '1'),
('api_enabled', '1'),
('auth_meth', 'none'),
('auth_meth_global', 'none'),
('auto_report_stats', '1'),
('auto_report_stats_last_sent', '2000-01-01'),
('autologout_timer', '30'),
('certify_text_create', ''),
('certify_text_prod', ''),
('cron_last_execution', ''),
('pubmed_matching_last_crawl', ''),
('homepage_custom_text', ''),
('doc_to_edoc_transfer_complete', '1'),
('dts_enabled_global', '0'),
('display_nonauth_projects', '1'),
('display_project_logo_institution', '0'),
('display_today_now_button', '1'),
('edoc_field_option_enabled', '1'),
('edoc_upload_max', ''),
('edoc_webdav_enabled', '0'),
('file_repository_upload_max', ''),
('file_repository_enabled', '1'),
('temp_files_last_delete', now()),
('edoc_path', ''),
('enable_edit_survey_response', '1'),
('enable_plotting', '2'),
('enable_plotting_survey_results', '1'),
('enable_projecttype_singlesurvey', '1'),
('enable_projecttype_forms', '1'),
('enable_projecttype_singlesurveyforms', '1'),
('enable_url_shortener', '1'),
('enable_user_whitelist', '0'),
('logout_fail_limit', '5'),
('logout_fail_window', '15'),
('footer_links', ''),
('footer_text', ''),
('google_translate_enabled', '0'),
('googlemap_key',''),
('grant_cite', ''),
('headerlogo', ''),
('homepage_contact', ''),
('homepage_contact_email', ''),
('homepage_grant_cite', ''),
('identifier_keywords', 'name, street, address, city, county, precinct, zip, postal, date, phone, fax, mail, ssn, social security, mrn, dob, dod, medical, record, id, age'),
('institution', ''),
('language_global','English'),
('login_autocomplete_disable', '0'),
('login_logo', ''),
('my_profile_enable_edit','1'),
('password_history_limit','0'),
('password_reset_duration','0'),
('project_contact_email', ''),
('project_contact_name', ''),
('project_contact_prod_changes_email', ''),
('project_contact_prod_changes_name', ''),
('project_language', 'English'),
('proxy_hostname', ''),
('pubmed_matching_enabled', '0'), 
('pubmed_matching_institution', 'Vanderbilt\nMeharry'),
('redcap_last_install_date', CURRENT_DATE),
('redcap_version', '4.0.0'),
('sendit_enabled', '1'),
('sendit_upload_max', ''),
('shared_library_enabled', '1'),
('shibboleth_logout', ''),
('shibboleth_username_field', 'none'),
('site_org_type', ''),
('superusers_only_create_project', '0'),
('superusers_only_move_to_prod', '1'),
('system_offline', '0');

INSERT INTO redcap_validation_types (validation_name, validation_label, regex_js, regex_php, data_type, legacy_value, visible) VALUES
('alpha_only', 'Letters only', '/^[a-z]+$/i', '/^[a-z]+$/i', 'text', NULL, 0),
('date_dmy', 'Date (D-M-Y)', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})$/', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})$/', 'date', NULL, 0),
('date_mdy', 'Date (M-D-Y)', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})$/', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})$/', 'date', NULL, 1),
('date_ymd', 'Date (Y-M-D)', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])$/', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])$/', 'date', 'date', 1),
('datetime_dmy', 'Datetime (D-M-Y H:M)', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', 'datetime', NULL, 0),
('datetime_mdy', 'Datetime (M-D-Y H:M)', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', 'datetime', NULL, 1),
('datetime_seconds_dmy', 'Datetime w/ seconds (D-M-Y H:M:S)', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', '/^(0[1-9]|[12][0-9]|3[01])([-\\/.])?(0[1-9]|1[012])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', 'datetime_seconds', NULL, 0),
('datetime_seconds_mdy', 'Datetime w/ seconds (M-D-Y H:M:S)', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', '/^(0[1-9]|1[012])([-\\/.])?(0[1-9]|[12][0-9]|3[01])\\2?(\\d{4})\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', 'datetime_seconds', NULL, 1),
('datetime_seconds_ymd', 'Datetime w/ seconds (Y-M-D H:M:S)', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$/', 'datetime_seconds', 'datetime_seconds', 1),
('datetime_ymd', 'Datetime (Y-M-D H:M)', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', '/^(\\d{4})([-\\/.])?(0[1-9]|1[012])\\2?(0[1-9]|[12][0-9]|3[01])\\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', 'datetime', 'datetime', 1),
('email', 'Email', '/^([_a-z0-9-'']+)(\\.[_a-z0-9-'']+)*@([a-z0-9-]+)(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$/i', '/^([_a-z0-9-'']+)(\\.[_a-z0-9-'']+)*@([a-z0-9-]+)(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$/i', 'email', NULL, 1),
('integer', 'Integer', '/^[-+]?\\b\\d+\\b$/', '/^[-+]?\\b\\d+\\b$/', 'integer', 'int', 1),
('mrn_10d', 'MRN (10 digits)', '/^\\d{10}$/', '/^\\d{10}$/', 'text', NULL, 0),
('number', 'Number', '/^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?$/', '/^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?$/', 'number', 'float', 1),
('number_1dp', 'Number (1 decimal place)', '/^-?\\d+\\.\\d$/', '/^-?\\d+\\.\\d$/', 'number_fixeddp', NULL, 0),
('number_2dp', 'Number (2 decimal places)', '/^-?\\d+\\.\\d{2}$/', '/^-?\\d+\\.\\d{2}$/', 'number_fixeddp', NULL, 0),
('number_3dp', 'Number (3 decimal places)', '/^-?\\d+\\.\\d{3}$/', '/^-?\\d+\\.\\d{3}$/', 'number_fixeddp', NULL, 0),
('number_4dp', 'Number (4 decimal places)', '/^-?\\d+\\.\\d{4}$/', '/^-?\\d+\\.\\d{4}$/', 'number_fixeddp', NULL, 0),
('phone', 'Phone (U.S.)', '/^(?:\\(?([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\)?)\\s*(?:[.-]\\s*)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$/', '/^(?:\\(?([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\)?)\\s*(?:[.-]\\s*)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$/', 'phone', NULL, 1),
('phone_australia', 'Phone (Australia)', '/^(\\(0[2-8]\\)|0[2-8])\\s*\\d{4}\\s*\\d{4}$/', '/^(\\(0[2-8]\\)|0[2-8])\\s*\\d{4}\\s*\\d{4}$/', 'phone', NULL, 0),
('postalcode_australia', 'Postal Code (Australia)', '/^\\d{4}$/', '/^\\d{4}$/', 'postal_code', NULL, 0),
('postalcode_canada', 'Postal Code (Canada)', '/^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1}\\s*\\d{1}[A-Z]{1}\\d{1}$/i', '/^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1}\\s*\\d{1}[A-Z]{1}\\d{1}$/i', 'postal_code', NULL, 0),
('ssn', 'Social Security Number (U.S.)', '/^\\d{3}-\\d\\d-\\d{4}$/', '/^\\d{3}-\\dd-\\d{4}$/', 'ssn', NULL, 0),
('time', 'Time (HH:MM)', '/^([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', '/^([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/', 'time', NULL, 1),
('time_mm_ss', 'Time (MM:SS)', '/^[0-5]\\d:[0-5]\\d$/', '/^[0-5]\\d:[0-5]\\d$/', 'time', NULL, 0),
('vmrn', 'Vanderbilt MRN', '/^[0-9]{4,9}$/', '/^[0-9]{4,9}$/', 'mrn', NULL, 0),
('zipcode', 'Zipcode (U.S.)', '/^\\d{5}(-\\d{4})?$/', '/^\\d{5}(-\\d{4})?$/', 'postal_code', NULL, 1);


-- Add custom site configuration values --
UPDATE redcap_config SET value = '' WHERE field_name = 'redcap_csrf_token';
UPDATE redcap_config SET value = '0' WHERE field_name = 'superusers_only_create_project';
UPDATE redcap_config SET value = '1' WHERE field_name = 'superusers_only_move_to_prod';
UPDATE redcap_config SET value = '0' WHERE field_name = 'auto_report_stats';
UPDATE redcap_config SET value = '0' WHERE field_name = 'enable_url_shortener';
UPDATE redcap_config SET value = 'Rob Taylor (343-9024)' WHERE field_name = 'homepage_contact';
UPDATE redcap_config SET value = 'email@yoursite.edu' WHERE field_name = 'homepage_contact_email';
UPDATE redcap_config SET value = 'Rob Taylor (343-9024)' WHERE field_name = 'project_contact_name';
UPDATE redcap_config SET value = 'email@yoursite.edu' WHERE field_name = 'project_contact_email';
UPDATE redcap_config SET value = 'Rob Taylor (343-9024)' WHERE field_name = 'project_contact_prod_changes_name';
UPDATE redcap_config SET value = 'email@yoursite.edu' WHERE field_name = 'project_contact_prod_changes_email';
UPDATE redcap_config SET value = 'Vanderbilt University' WHERE field_name = 'institution';
UPDATE redcap_config SET value = 'Vanderbilt Institute for Clinical and Translational Research' WHERE field_name = 'site_org_type';
UPDATE redcap_config SET value = '4.8.4' WHERE field_name = 'redcap_version';

-- SQL TO CREATE A REDCAP DEMO PROJECT --
set @project_title = 'Example Database';


-- Obtain default values --
set @institution = (select value from redcap_config where field_name = 'institution' limit 1);
set @site_org_type = (select value from redcap_config where field_name = 'site_org_type' limit 1);
set @grant_cite = (select value from redcap_config where field_name = 'grant_cite' limit 1);
set @project_contact_name = (select value from redcap_config where field_name = 'project_contact_name' limit 1);
set @project_contact_email = (select value from redcap_config where field_name = 'project_contact_email' limit 1);
set @project_contact_prod_changes_name = (select value from redcap_config where field_name = 'project_contact_prod_changes_name' limit 1);
set @project_contact_prod_changes_email = (select value from redcap_config where field_name = 'project_contact_prod_changes_email' limit 1);
set @headerlogo = (select value from redcap_config where field_name = 'headerlogo' limit 1);
-- Create project --
INSERT INTO `redcap_projects` 
(project_name, app_title, status, count_project, auth_meth, creation_time, production_time, institution, site_org_type, grant_cite, project_contact_name, project_contact_email, project_contact_prod_changes_name, project_contact_prod_changes_email, headerlogo, display_project_logo_institution) VALUES
(concat('redcap_demo_',LEFT(MD5(RAND()),6)), @project_title, 1, 0, 'none', now(), now(), @institution, @site_org_type, @grant_cite, @project_contact_name, @project_contact_email, @project_contact_prod_changes_name, @project_contact_prod_changes_email, @headerlogo, 0);
set @project_id = LAST_INSERT_ID();
-- User rights --
INSERT INTO `redcap_user_rights` (`project_id`, `username`, `expiration`, `group_id`, `lock_record`, `data_export_tool`, `data_import_tool`, `data_comparison_tool`, `data_logging`, `file_repository`, `double_data`, `user_rights`, `data_access_groups`, `graphical`, `reports`, `design`, `calendar`, `data_entry`, `data_quality_execute`) VALUES
(@project_id, 'site_admin', NULL, NULL, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, '[baseline_data,1][completion_data,1][demographics,1][month_1_data,1][month_2_data,1][month_3_data,1]', 1);
-- Create single arm --
INSERT INTO redcap_events_arms (project_id, arm_num, arm_name) VALUES (@project_id, 1, 'Arm 1');
set @arm_id = LAST_INSERT_ID();
-- Create single event --
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES (@arm_id, 0, 0, 0, 'Event 1');
set @event_id = LAST_INSERT_ID();
-- Insert into redcap_event_forms --
INSERT INTO redcap_events_forms (event_id, form_name) VALUES
(@event_id, 'baseline_data'),
(@event_id, 'completion_data'),
(@event_id, 'demographics'),
(@event_id, 'month_1_data'),
(@event_id, 'month_2_data'),
(@event_id, 'month_3_data');
-- Insert into redcap_metadata --

INSERT INTO redcap_metadata (project_id, field_name, field_phi, form_name, form_menu_description, field_order, field_units, element_preceding_header, element_type, element_label, element_enum, element_note, element_validation_type, element_validation_min, element_validation_max, element_validation_checktype, branching_logic, field_req, edoc_id, edoc_display_img, custom_alignment, stop_actions, question_num) VALUES
(@project_id, 'study_id', NULL, 'demographics', 'Demographics', 1, NULL, NULL, 'text', 'Study ID', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_enrolled', NULL, 'demographics', NULL, 2, NULL, 'Demographic Characteristics', 'text', 'Date subject signed consent', NULL, 'YYYY-MM-DD', 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'first_name', '1', 'demographics', NULL, 3, NULL, NULL, 'text', 'First Name', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'last_name', '1', 'demographics', NULL, 4, NULL, NULL, 'text', 'Last Name', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'address', '1', 'demographics', NULL, 5, NULL, 'Contact Information', 'textarea', 'Street, City, State, ZIP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'telephone_1', '1', 'demographics', NULL, 6, NULL, NULL, 'text', 'Phone number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'telephone_2', '1', 'demographics', NULL, 7, NULL, NULL, 'text', 'Second phone number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'email', '1', 'demographics', NULL, 8, NULL, NULL, 'text', 'E-mail', NULL, NULL, 'email', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'ethnicity', NULL, 'demographics', NULL, 9, NULL, 'Other information', 'radio', 'Ethnicity', '0, Hispanic or Latino \\n 1, NOT Hispanic or Latino \\n 2, Unknown / Not Reported', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'LH', NULL, NULL),
(@project_id, 'race', NULL, 'demographics', NULL, 10, NULL, NULL, 'radio', 'Race', '0, American Indian/Alaska Native \\n 1, Asian \\n 2, Native Hawaiian or Other Pacific Islander \\n 3, Black or African American \\n 4, White \\n 5, More Than One Race \\n 6, Unknown / Not Reported', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'sex', NULL, 'demographics', NULL, 11, NULL, NULL, 'radio', 'Gender', '0, Female \\n 1, Male', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, 'RH', NULL, NULL),
(@project_id, 'given_birth', NULL, 'demographics', NULL, 12, NULL, NULL, 'yesno', 'Has the patient given birth before?', NULL, NULL, NULL, NULL, NULL, NULL, '[sex] = "0"', 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'num_children', NULL, 'demographics', NULL, 13, NULL, NULL, 'text', 'How many times has the patient given birth?', NULL, NULL, 'int', '0', NULL, 'soft_typed', '[sex] = "0" and [given_birth] = "1"', 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'specify_mood', NULL, 'demographics', NULL, 14, NULL, NULL, 'slider', 'Specify the patient''s mood', 'Very sad | Indifferent | Very happy', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'patient_document', NULL, 'demographics', NULL, 15, NULL, NULL, 'file', 'Upload the patient''s consent form', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'meds', NULL, 'demographics', NULL, 16, NULL, NULL, 'checkbox', 'Is patient taking any of the following medications? (check all that apply)', '1, Lexapro \\n 2, Celexa \\n 3, Prozac \\n 4, Paxil \\n 5, Zoloft', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dob', '1', 'demographics', NULL, 17, NULL, NULL, 'text', 'Date of birth', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'age', NULL, 'demographics', NULL, 18, NULL, NULL, 'calc', 'Age (years)', 'rounddown(datediff([dob],''today'',''y''))', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'height', NULL, 'demographics', NULL, 19, 'cm', NULL, 'text', 'Height (cm)', NULL, NULL, 'float', '130', '215', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'weight', NULL, 'demographics', NULL, 20, 'kilograms', NULL, 'text', 'Weight (kilograms)', NULL, NULL, 'int', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'bmi', NULL, 'demographics', NULL, 21, 'kilograms', NULL, 'calc', 'BMI', 'round(([weight]*10000)/(([height])^(2)),1)', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'comments', NULL, 'demographics', NULL, 22, NULL, 'General Comments', 'textarea', 'Comments', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'demographics_complete', NULL, 'demographics', NULL, 23, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_visit_b', NULL, 'baseline_data', 'Baseline Data', 24, NULL, 'Baseline Measurements', 'text', 'Date of baseline visit', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_blood_b', NULL, 'baseline_data', NULL, 25, NULL, NULL, 'text', 'Date blood was drawn', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'alb_b', NULL, 'baseline_data', NULL, 26, 'g/dL', NULL, 'text', 'Serum Albumin (g/dL)', NULL, NULL, 'int', '3', '5', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_b', NULL, 'baseline_data', NULL, 27, 'mg/dL', NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', '10', '40', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_b', NULL, 'baseline_data', NULL, 28, 'mg/dL', NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', '0.5', '20', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_b', NULL, 'baseline_data', NULL, 29, 'g/kg/d', NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', '0.5', '2', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_b', NULL, 'baseline_data', NULL, 30, 'mg/dL', NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'transferrin_b', NULL, 'baseline_data', NULL, 31, 'mg/dL', NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'kt_v_b', NULL, 'baseline_data', NULL, 32, NULL, NULL, 'text', 'Kt/V', NULL, NULL, 'float', '0.9', '3', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'drywt_b', NULL, 'baseline_data', NULL, 33, 'kilograms', NULL, 'text', 'Dry weight (kilograms)', NULL, NULL, 'float', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma1_b', NULL, 'baseline_data', NULL, 34, NULL, NULL, 'select', 'Collected Plasma 1?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma2_b', NULL, 'baseline_data', NULL, 35, NULL, NULL, 'select', 'Collected Plasma 2?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma3_b', NULL, 'baseline_data', NULL, 36, NULL, NULL, 'select', 'Collected Plasma 3?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum1_b', NULL, 'baseline_data', NULL, 37, NULL, NULL, 'select', 'Collected Serum 1?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum2_b', NULL, 'baseline_data', NULL, 38, NULL, NULL, 'select', 'Collected Serum 2?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum3_b', NULL, 'baseline_data', NULL, 39, NULL, NULL, 'select', 'Collected Serum 3?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'sga_b', NULL, 'baseline_data', NULL, 40, NULL, NULL, 'text', 'Subject Global Assessment (score = 1-7)', NULL, NULL, 'float', '0.9', '7.1', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_supplement_dispensed', NULL, 'baseline_data', NULL, 41, NULL, NULL, 'text', 'Date patient begins supplement', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'baseline_data_complete', NULL, 'baseline_data', NULL, 42, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_visit_1', NULL, 'month_1_data', 'Month 1 Data', 43, NULL, 'Month 1', 'text', 'Date of Month 1 visit', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'alb_1', NULL, 'month_1_data', NULL, 44, 'g/dL', NULL, 'text', 'Serum Albumin (g/dL)', NULL, NULL, 'float', '3', '5', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_1', NULL, 'month_1_data', NULL, 45, 'mg/dL', NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', '10', '40', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_1', NULL, 'month_1_data', NULL, 46, 'mg/dL', NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', '0.5', '20', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_1', NULL, 'month_1_data', NULL, 47, 'g/kg/d', NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', '0.5', '2', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_1', NULL, 'month_1_data', NULL, 48, 'mg/dL', NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'transferrin_1', NULL, 'month_1_data', NULL, 49, 'mg/dL', NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'kt_v_1', NULL, 'month_1_data', NULL, 50, NULL, NULL, 'text', 'Kt/V', NULL, NULL, 'float', '0.9', '3', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'drywt_1', NULL, 'month_1_data', NULL, 51, 'kilograms', NULL, 'text', 'Dry weight (kilograms)', NULL, NULL, 'float', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'no_show_1', NULL, 'month_1_data', NULL, 52, NULL, NULL, 'text', 'Number of treatments missed', NULL, NULL, 'float', '0', '7', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'compliance_1', NULL, 'month_1_data', NULL, 53, NULL, NULL, 'select', 'How compliant was the patient in drinking the supplement?', '0, 100 percent \\n 1, 99-75 percent \\n 2, 74-50 percent \\n 3, 49-25 percent \\n 4, 0-24 percent', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'hospit_1', NULL, 'month_1_data', NULL, 54, NULL, 'Hospitalization Data', 'select', 'Was patient hospitalized since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_hosp_1', NULL, 'month_1_data', NULL, 55, NULL, NULL, 'select', 'What was the cause of hospitalization?', '1, Vascular access related events \\n 2, CVD events \\n 3, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'admission_date_1', NULL, 'month_1_data', NULL, 56, NULL, NULL, 'text', 'Date of hospital admission', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_date_1', NULL, 'month_1_data', NULL, 57, NULL, NULL, 'text', 'Date of hospital discharge', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_summary_1', NULL, 'month_1_data', NULL, 58, NULL, NULL, 'select', 'Discharge summary in patients binder?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'death_1', NULL, 'month_1_data', NULL, 59, NULL, 'Mortality Data', 'select', 'Has patient died since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_death_1', NULL, 'month_1_data', NULL, 60, NULL, NULL, 'text', 'Date of death', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_death_1', NULL, 'month_1_data', NULL, 61, NULL, NULL, 'select', 'What was the cause of death?', '1, All-cause \\n 2, Cardiovascular', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'month_1_data_complete', NULL, 'month_1_data', NULL, 62, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_visit_2', NULL, 'month_2_data', 'Month 2 Data', 63, NULL, 'Month 2', 'text', 'Date of Month 2 visit', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'alb_2', NULL, 'month_2_data', NULL, 64, 'g/dL', NULL, 'text', 'Serum Albumin (g/dL)', NULL, NULL, 'float', '3', '5', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_2', NULL, 'month_2_data', NULL, 65, 'mg/dL', NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', '10', '40', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_2', NULL, 'month_2_data', NULL, 66, 'mg/dL', NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', '0.5', '20', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_2', NULL, 'month_2_data', NULL, 67, 'g/kg/d', NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', '0.5', '2', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_2', NULL, 'month_2_data', NULL, 68, 'mg/dL', NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'transferrin_2', NULL, 'month_2_data', NULL, 69, 'mg/dL', NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'kt_v_2', NULL, 'month_2_data', NULL, 70, NULL, NULL, 'text', 'Kt/V', NULL, NULL, 'float', '0.9', '3', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'drywt_2', NULL, 'month_2_data', NULL, 71, 'kilograms', NULL, 'text', 'Dry weight (kilograms)', NULL, NULL, 'float', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'no_show_2', NULL, 'month_2_data', NULL, 72, NULL, NULL, 'text', 'Number of treatments missed', NULL, NULL, 'float', '0', '7', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'compliance_2', NULL, 'month_2_data', NULL, 73, NULL, NULL, 'select', 'How compliant was the patient in drinking the supplement?', '0, 100 percent \\n 1, 99-75 percent \\n 2, 74-50 percent \\n 3, 49-25 percent \\n 4, 0-24 percent', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'hospit_2', NULL, 'month_2_data', NULL, 74, NULL, 'Hospitalization Data', 'select', 'Was patient hospitalized since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_hosp_2', NULL, 'month_2_data', NULL, 75, NULL, NULL, 'select', 'What was the cause of hospitalization?', '1, Vascular access related events \\n 2, CVD events \\n 3, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'admission_date_2', NULL, 'month_2_data', NULL, 76, NULL, NULL, 'text', 'Date of hospital admission', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_date_2', NULL, 'month_2_data', NULL, 77, NULL, NULL, 'text', 'Date of hospital discharge', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_summary_2', NULL, 'month_2_data', NULL, 78, NULL, NULL, 'select', 'Discharge summary in patients binder?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'death_2', NULL, 'month_2_data', NULL, 79, NULL, 'Mortality Data', 'select', 'Has patient died since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_death_2', NULL, 'month_2_data', NULL, 80, NULL, NULL, 'text', 'Date of death', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_death_2', NULL, 'month_2_data', NULL, 81, NULL, NULL, 'select', 'What was the cause of death?', '1, All-cause \\n 2, Cardiovascular', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'month_2_data_complete', NULL, 'month_2_data', NULL, 82, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_visit_3', NULL, 'month_3_data', 'Month 3 Data', 83, NULL, 'Month 3', 'text', 'Date of Month 3 visit', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_blood_3', NULL, 'month_3_data', NULL, 84, NULL, NULL, 'text', 'Date blood was drawn', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'alb_3', NULL, 'month_3_data', NULL, 85, 'g/dL', NULL, 'text', 'Serum Albumin (g/dL)', NULL, NULL, 'float', '3', '5', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_3', NULL, 'month_3_data', NULL, 86, 'mg/dL', NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', '10', '40', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_3', NULL, 'month_3_data', NULL, 87, 'mg/dL', NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', '0.5', '20', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_3', NULL, 'month_3_data', NULL, 88, 'g/kg/d', NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', '0.5', '2', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_3', NULL, 'month_3_data', NULL, 89, 'mg/dL', NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'transferrin_3', NULL, 'month_3_data', NULL, 90, 'mg/dL', NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', '100', '300', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'kt_v_3', NULL, 'month_3_data', NULL, 91, NULL, NULL, 'text', 'Kt/V', NULL, NULL, 'float', '0.9', '3', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'drywt_3', NULL, 'month_3_data', NULL, 92, 'kilograms', NULL, 'text', 'Dry weight (kilograms)', NULL, NULL, 'float', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma1_3', NULL, 'month_3_data', NULL, 93, NULL, NULL, 'select', 'Collected Plasma 1?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma2_3', NULL, 'month_3_data', NULL, 94, NULL, NULL, 'select', 'Collected Plasma 2?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'plasma3_3', NULL, 'month_3_data', NULL, 95, NULL, NULL, 'select', 'Collected Plasma 3?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum1_3', NULL, 'month_3_data', NULL, 96, NULL, NULL, 'select', 'Collected Serum 1?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum2_3', NULL, 'month_3_data', NULL, 97, NULL, NULL, 'select', 'Collected Serum 2?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'serum3_3', NULL, 'month_3_data', NULL, 98, NULL, NULL, 'select', 'Collected Serum 3?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'sga_3', NULL, 'month_3_data', NULL, 99, NULL, NULL, 'text', 'Subject Global Assessment (score = 1-7)', NULL, NULL, 'float', '0.9', '7.1', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'no_show_3', NULL, 'month_3_data', NULL, 100, NULL, NULL, 'text', 'Number of treatments missed', NULL, NULL, 'float', '0', '7', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'compliance_3', NULL, 'month_3_data', NULL, 101, NULL, NULL, 'select', 'How compliant was the patient in drinking the supplement?', '0, 100 percent \\n 1, 99-75 percent \\n 2, 74-50 percent \\n 3, 49-25 percent \\n 4, 0-24 percent', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'hospit_3', NULL, 'month_3_data', NULL, 102, NULL, 'Hospitalization Data', 'select', 'Was patient hospitalized since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_hosp_3', NULL, 'month_3_data', NULL, 103, NULL, NULL, 'select', 'What was the cause of hospitalization?', '1, Vascular access related events \\n 2, CVD events \\n 3, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'admission_date_3', NULL, 'month_3_data', NULL, 104, NULL, NULL, 'text', 'Date of hospital admission', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_date_3', NULL, 'month_3_data', NULL, 105, NULL, NULL, 'text', 'Date of hospital discharge', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_summary_3', NULL, 'month_3_data', NULL, 106, NULL, NULL, 'select', 'Discharge summary in patients binder?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'death_3', NULL, 'month_3_data', NULL, 107, NULL, 'Mortality Data', 'select', 'Has patient died since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_death_3', NULL, 'month_3_data', NULL, 108, NULL, NULL, 'text', 'Date of death', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cause_death_3', NULL, 'month_3_data', NULL, 109, NULL, NULL, 'select', 'What was the cause of death?', '1, All-cause \\n 2, Cardiovascular', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'month_3_data_complete', NULL, 'month_3_data', NULL, 110, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'complete_study', NULL, 'completion_data', 'Completion Data', 111, NULL, 'Study Completion Information', 'select', 'Has patient completed study?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'withdraw_date', NULL, 'completion_data', NULL, 112, NULL, NULL, 'text', 'Put a date if patient withdrew study', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'withdraw_reason', NULL, 'completion_data', NULL, 113, NULL, NULL, 'select', 'Reason patient withdrew from study', '0, Non-compliance \\n 1, Did not wish to continue in study \\n 2, Could not tolerate the supplement \\n 3, Hospitalization \\n 4, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'complete_study_date', NULL, 'completion_data', NULL, 114, NULL, NULL, 'text', 'Date of study completion', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'study_comments', NULL, 'completion_data', NULL, 115, NULL, 'General Comments', 'textarea', 'Comments', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'completion_data_complete', NULL, 'completion_data', NULL, 116, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL);

-- SQL TO CREATE A REDCAP DEMO PROJECT --
set @project_title = 'Example Database (Longitudinal)';


-- Obtain default values --
set @institution = (select value from redcap_config where field_name = 'institution' limit 1);
set @site_org_type = (select value from redcap_config where field_name = 'site_org_type' limit 1);
set @grant_cite = (select value from redcap_config where field_name = 'grant_cite' limit 1);
set @project_contact_name = (select value from redcap_config where field_name = 'project_contact_name' limit 1);
set @project_contact_email = (select value from redcap_config where field_name = 'project_contact_email' limit 1);
set @project_contact_prod_changes_name = (select value from redcap_config where field_name = 'project_contact_prod_changes_name' limit 1);
set @project_contact_prod_changes_email = (select value from redcap_config where field_name = 'project_contact_prod_changes_email' limit 1);
set @headerlogo = (select value from redcap_config where field_name = 'headerlogo' limit 1);
-- Create project --
INSERT INTO `redcap_projects` 
(project_name, app_title, repeatforms, status, count_project, auth_meth, creation_time, production_time, institution, site_org_type, grant_cite, project_contact_name, project_contact_email, project_contact_prod_changes_name, project_contact_prod_changes_email, headerlogo, display_project_logo_institution) VALUES
(concat('redcap_demo_',LEFT(MD5(RAND()),6)), @project_title, 1, 1, 0, 'none', now(), now(), @institution, @site_org_type, @grant_cite, @project_contact_name, @project_contact_email, @project_contact_prod_changes_name, @project_contact_prod_changes_email, @headerlogo, 0);
set @project_id = LAST_INSERT_ID();
-- User rights --
INSERT INTO redcap_user_rights (project_id, username, expiration, group_id, lock_record, data_export_tool, data_import_tool, data_comparison_tool, data_logging, file_repository, double_data, user_rights, data_access_groups, graphical, reports, design, calendar, data_entry, `data_quality_execute`) VALUES
(@project_id, 'site_admin', NULL, NULL, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, '[demographics,1][contact_info,1][baseline_data,1][visit_lab_data,1][visit_blood_workup,1][visit_observed_behavior,1][completion_data,1][patient_morale_questionnaire,1][completion_project_questionnaire,1]', 1);
-- Create arms --
INSERT INTO redcap_events_arms (project_id, arm_num, arm_name) VALUES(@project_id, 1, 'Drug A');
set @arm_id1 = LAST_INSERT_ID();
INSERT INTO redcap_events_arms (project_id, arm_num, arm_name) VALUES(@project_id, 2, 'Drug B');
set @arm_id2 = LAST_INSERT_ID();
-- Create events --
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 0, 0, 0, 'Enrollment');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'baseline_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'contact_info');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'demographics');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 1, 0, 0, 'Dose 1');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 3, 0, 0, 'Visit 1');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 8, 0, 0, 'Dose 2');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 10, 0, 0, 'Visit 2');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 15, 0, 0, 'Dose 3');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 17, 0, 0, 'Visit 3');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id1, 30, 0, 0, 'Final visit');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'completion_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'completion_project_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 0, 0, 0, 'Enrollment');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'baseline_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'contact_info');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'demographics');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 5, 0, 0, 'Deadline to opt out of study');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'contact_info');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 7, 0, 0, 'First dose');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 10, 2, 2, 'First visit');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 13, 0, 0, 'Second dose');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 15, 2, 2, 'Second visit');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 20, 2, 2, 'Final visit');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'completion_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'completion_project_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'patient_morale_questionnaire');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_blood_workup');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_lab_data');
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'visit_observed_behavior');
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES(@arm_id2, 30, 0, 0, 'Deadline to return feedback');
set @event_id = LAST_INSERT_ID();
INSERT INTO redcap_events_forms (event_id, form_name) VALUES(@event_id, 'contact_info');
-- Insert into redcap_metadata --
INSERT INTO redcap_metadata (project_id, field_name, field_phi, form_name, form_menu_description, field_order, field_units, element_preceding_header, element_type, element_label, element_enum, element_note, element_validation_type, element_validation_min, element_validation_max, element_validation_checktype, branching_logic, field_req, edoc_id, edoc_display_img, custom_alignment, stop_actions, question_num) VALUES
(@project_id, 'study_id', NULL, 'demographics', 'Demographics', 1, NULL, NULL, 'text', 'Study ID', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_enrolled', NULL, 'demographics', NULL, 2, NULL, 'Demographic Characteristics', 'text', 'Date subject signed consent', NULL, 'YYYY-MM-DD', 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'first_name', '1', 'demographics', NULL, 3, NULL, NULL, 'text', 'First Name', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'last_name', '1', 'demographics', NULL, 4, NULL, NULL, 'text', 'Last Name', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'address', '1', 'demographics', NULL, 5, NULL, 'Contact Information', 'textarea', 'Street, City, State, ZIP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'telephone_1', '1', 'demographics', NULL, 6, NULL, NULL, 'text', 'Phone number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'telephone_2', '1', 'demographics', NULL, 7, NULL, NULL, 'text', 'Second phone number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'email', '1', 'demographics', NULL, 8, NULL, NULL, 'text', 'E-mail', NULL, NULL, 'email', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'ethnicity', NULL, 'demographics', NULL, 9, NULL, 'Other information', 'radio', 'Ethnicity', '0, Hispanic or Latino \\n 1, NOT Hispanic or Latino \\n 2, Unknown / Not Reported', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'LH', NULL, NULL),
(@project_id, 'race', NULL, 'demographics', NULL, 10, NULL, NULL, 'radio', 'Race', '0, American Indian/Alaska Native \\n 1, Asian \\n 2, Native Hawaiian or Other Pacific Islander \\n 3, Black or African American \\n 4, White \\n 5, More Than One Race \\n 6, Unknown / Not Reported', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'sex', NULL, 'demographics', NULL, 11, NULL, NULL, 'radio', 'Gender', '0, Female \\n 1, Male', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, 'RH', NULL, NULL),
(@project_id, 'given_birth', NULL, 'demographics', NULL, 12, NULL, NULL, 'yesno', 'Has the patient given birth before?', NULL, NULL, NULL, NULL, NULL, NULL, '[sex] = "0"', 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'num_children', NULL, 'demographics', NULL, 13, NULL, NULL, 'text', 'How many times has the patient given birth?', NULL, NULL, 'int', '0', NULL, 'soft_typed', '[sex] = "0" and [given_birth] = "1"', 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'specify_mood', NULL, 'demographics', NULL, 14, NULL, NULL, 'slider', 'Specify the patient''s mood', 'Very sad | Indifferent | Very happy', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'patient_document', NULL, 'demographics', NULL, 15, NULL, NULL, 'file', 'Upload the patient''s consent form', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'meds', NULL, 'demographics', NULL, 16, NULL, NULL, 'checkbox', 'Is patient taking any of the following medications? (check all that apply)', '1, Lexapro \\n 2, Celexa \\n 3, Prozac \\n 4, Paxil \\n 5, Zoloft', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dob', '1', 'demographics', NULL, 17, NULL, NULL, 'text', 'Date of birth', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'age', NULL, 'demographics', NULL, 18, NULL, NULL, 'calc', 'Age (years)', 'rounddown(datediff([dob],''today'',''y''))', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'height', NULL, 'demographics', NULL, 19, NULL, NULL, 'text', 'Height (cm)', NULL, NULL, 'float', '130', '215', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'weight', NULL, 'demographics', NULL, 20, NULL, NULL, 'text', 'Weight (kilograms)', NULL, NULL, 'int', '35', '200', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'bmi', NULL, 'demographics', NULL, 21, NULL, NULL, 'calc', 'BMI', 'round(([weight]*10000)/(([height])^(2)),1)', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'comments', NULL, 'demographics', NULL, 22, NULL, 'General Comments', 'textarea', 'Comments', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'demographics_complete', NULL, 'demographics', NULL, 23, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dialysis_unit_name', NULL, 'contact_info', 'Contact Info', 24, NULL, NULL, 'text', 'Emergency Contact Phone Number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dialysis_unit_phone', NULL, 'contact_info', NULL, 25, NULL, NULL, 'radio', 'Confirmed?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dialysis_schedule_days', NULL, 'contact_info', NULL, 26, NULL, NULL, 'text', 'Next of Kin Contact Name', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dialysis_schedule_time', NULL, 'contact_info', NULL, 27, NULL, NULL, 'textarea', 'Next of Kin Contact Address', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'etiology_esrd', NULL, 'contact_info', NULL, 28, NULL, NULL, 'text', 'Next of Kin Contact Phone Number', NULL, 'Include Area Code', 'phone', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'subject_comments', NULL, 'contact_info', NULL, 29, NULL, NULL, 'radio', 'Confirmed?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'contact_info_complete', NULL, 'contact_info', NULL, 30, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'height2', NULL, 'baseline_data', 'Baseline Data', 31, NULL, NULL, 'text', 'Height (cm)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'weight2', NULL, 'baseline_data', NULL, 32, NULL, NULL, 'text', 'Weight (kilograms)', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'bmi2', NULL, 'baseline_data', NULL, 33, NULL, NULL, 'calc', 'BMI', 'round(([weight2]*10000)/(([height2])^(2)),1)', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_b', NULL, 'baseline_data', NULL, 34, NULL, NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_b', NULL, 'baseline_data', NULL, 35, NULL, NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_b', NULL, 'baseline_data', NULL, 36, NULL, NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_b', NULL, 'baseline_data', NULL, 37, NULL, NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'transferrin_b', NULL, 'baseline_data', NULL, 38, NULL, NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'baseline_data_complete', NULL, 'baseline_data', NULL, 39, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vld1', NULL, 'visit_lab_data', 'Visit Lab Data', 40, NULL, NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vld2', NULL, 'visit_lab_data', NULL, 41, NULL, NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vld3', NULL, 'visit_lab_data', NULL, 42, NULL, NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vld4', NULL, 'visit_lab_data', NULL, 43, NULL, NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vld5', NULL, 'visit_lab_data', NULL, 44, NULL, NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'visit_lab_data_complete', NULL, 'visit_lab_data', NULL, 45, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'pmq1', NULL, 'patient_morale_questionnaire', 'Patient Morale Questionnaire', 46, NULL, NULL, 'select', 'On average, how many pills did you take each day last week?', '0, less than 5 \\n 1, 5-10 \\n 2, 6-15 \\n 3, over 15', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'pmq2', NULL, 'patient_morale_questionnaire', NULL, 47, NULL, NULL, 'select', 'Using the handout, which level of dependence do you feel you are currently at?', '0, 0 \\n 1, 1 \\n 2, 2 \\n 3, 3 \\n 4, 4 \\n 5, 5', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'pmq3', NULL, 'patient_morale_questionnaire', NULL, 48, NULL, NULL, 'radio', 'Would you be willing to discuss your experiences with a psychiatrist?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'pmq4', NULL, 'patient_morale_questionnaire', NULL, 49, NULL, NULL, 'select', 'How open are you to further testing?', '0, not open \\n 1, undecided \\n 2, very open', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'patient_morale_questionnaire_complete', NULL, 'patient_morale_questionnaire', NULL, 50, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw1', NULL, 'visit_blood_workup', 'Visit Blood Workup', 51, NULL, NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw2', NULL, 'visit_blood_workup', NULL, 52, NULL, NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw3', NULL, 'visit_blood_workup', NULL, 53, NULL, NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw4', NULL, 'visit_blood_workup', NULL, 54, NULL, NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw5', NULL, 'visit_blood_workup', NULL, 55, NULL, NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw6', NULL, 'visit_blood_workup', NULL, 56, NULL, NULL, 'radio', 'Blood draw shift?', '0. AM \\n 1, PM', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw7', NULL, 'visit_blood_workup', NULL, 57, NULL, NULL, 'radio', 'Blood draw by', '0, RN \\n 1, LPN \\n 2, nurse assistant \\n 3, doctor', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw8', NULL, 'visit_blood_workup', NULL, 58, NULL, NULL, 'select', 'Level of patient anxiety', '0, not anxious \\n 1, undecided \\n 2, very anxious', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vbw9', NULL, 'visit_blood_workup', NULL, 59, NULL, NULL, 'select', 'Patient scheduled for future draws?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'visit_blood_workup_complete', NULL, 'visit_blood_workup', NULL, 60, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob1', NULL, 'visit_observed_behavior', 'Visit Observed Behavior', 61, NULL, 'Was the patient...', 'radio', 'nervous?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob2', NULL, 'visit_observed_behavior', NULL, 62, NULL, NULL, 'radio', 'worried?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob3', NULL, 'visit_observed_behavior', NULL, 63, NULL, NULL, 'radio', 'scared?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob4', NULL, 'visit_observed_behavior', NULL, 64, NULL, NULL, 'radio', 'fidgety?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob5', NULL, 'visit_observed_behavior', NULL, 65, NULL, NULL, 'radio', 'crying?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob6', NULL, 'visit_observed_behavior', NULL, 66, NULL, NULL, 'radio', 'screaming?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob7', NULL, 'visit_observed_behavior', NULL, 67, NULL, NULL, 'textarea', 'other', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob8', NULL, 'visit_observed_behavior', NULL, 68, NULL, 'Were you...', 'radio', 'nervous?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob9', NULL, 'visit_observed_behavior', NULL, 69, NULL, NULL, 'radio', 'worried?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob10', NULL, 'visit_observed_behavior', NULL, 70, NULL, NULL, 'radio', 'scared?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob11', NULL, 'visit_observed_behavior', NULL, 71, NULL, NULL, 'radio', 'fidgety?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob12', NULL, 'visit_observed_behavior', NULL, 72, NULL, NULL, 'radio', 'crying?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob13', NULL, 'visit_observed_behavior', NULL, 73, NULL, NULL, 'radio', 'screaming?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'vob14', NULL, 'visit_observed_behavior', NULL, 74, NULL, NULL, 'textarea', 'other', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'visit_observed_behavior_complete', NULL, 'visit_observed_behavior', NULL, 75, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'study_comments', NULL, 'completion_data', 'Completion Data', 76, NULL, NULL, 'textarea', 'Comments', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'complete_study', NULL, 'completion_data', NULL, 77, NULL, NULL, 'select', 'Has patient completed study?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'withdraw_date', NULL, 'completion_data', NULL, 78, NULL, NULL, 'text', 'Put a date if patient withdrew study', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'date_visit_4', NULL, 'completion_data', NULL, 79, NULL, NULL, 'text', 'Date of last visit', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'alb_4', NULL, 'completion_data', NULL, 80, NULL, NULL, 'text', 'Serum Albumin (g/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'prealb_4', NULL, 'completion_data', NULL, 81, NULL, NULL, 'text', 'Serum Prealbumin (mg/dL)', NULL, NULL, 'float', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'creat_4', NULL, 'completion_data', NULL, 82, NULL, NULL, 'text', 'Creatinine (mg/dL)', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_date_4', NULL, 'completion_data', NULL, 83, NULL, NULL, 'text', 'Date of hospital discharge', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'discharge_summary_4', NULL, 'completion_data', NULL, 84, NULL, NULL, 'select', 'Discharge summary in patients binder?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'npcr_4', NULL, 'completion_data', NULL, 85, NULL, NULL, 'text', 'Normalized Protein Catabolic Rate (g/kg/d)', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'chol_4', NULL, 'completion_data', NULL, 86, NULL, NULL, 'text', 'Cholesterol (mg/dL)', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'withdraw_reason', NULL, 'completion_data', NULL, 87, NULL, NULL, 'select', 'Reason patient withdrew from study', '0, Non-compliance \\n 1, Did not wish to continue in study \\n 2, Could not tolerate the supplement \\n 3, Hospitalization \\n 4, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'completion_data_complete', NULL, 'completion_data', NULL, 88, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq1', NULL, 'completion_project_questionnaire', 'Completion Project Questionnaire', 89, NULL, NULL, 'text', 'Date of study completion', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq2', NULL, 'completion_project_questionnaire', NULL, 90, NULL, NULL, 'text', 'Transferrin (mg/dL)', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq3', NULL, 'completion_project_questionnaire', NULL, 91, NULL, NULL, 'text', 'Kt/V', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq4', NULL, 'completion_project_questionnaire', NULL, 92, NULL, NULL, 'text', 'Dry weight (kilograms)', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq5', NULL, 'completion_project_questionnaire', NULL, 93, NULL, NULL, 'text', 'Number of treatments missed', NULL, NULL, 'int', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq6', NULL, 'completion_project_questionnaire', NULL, 94, NULL, NULL, 'select', 'How compliant was the patient in drinking the supplement?', '0, 100 percent \\n 1, 99-75 percent \\n 2, 74-50 percent \\n 3, 49-25 percent \\n 4, 0-24 percent', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq7', NULL, 'completion_project_questionnaire', NULL, 95, NULL, NULL, 'select', 'Was patient hospitalized since last visit?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq8', NULL, 'completion_project_questionnaire', NULL, 96, NULL, NULL, 'select', 'What was the cause of hospitalization?', '1, Vascular access related events \\n 2, CVD events \\n 3, Other', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq9', NULL, 'completion_project_questionnaire', NULL, 97, NULL, NULL, 'text', 'Date of hospital admission', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq10', NULL, 'completion_project_questionnaire', NULL, 98, NULL, NULL, 'select', 'On average, how many pills did you take each day last week?', '0, less than 5 \\n 1, 5-10 \\n 2, 6-15 \\n 3, over 15', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq11', NULL, 'completion_project_questionnaire', NULL, 99, NULL, NULL, 'select', 'Using the handout, which level of dependence do you feel you are currently at?', '0, 0 \\n 1, 1 \\n 2, 2 \\n 3, 3 \\n 4, 4 \\n 5, 5', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq12', NULL, 'completion_project_questionnaire', NULL, 100, NULL, NULL, 'radio', 'Would you be willing to discuss your experiences with a psychiatrist?', '0, No \\n 1, Yes', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'cpq13', NULL, 'completion_project_questionnaire', NULL, 101, NULL, NULL, 'select', 'How open are you to further testing?', '0, not open \\n 1, undecided \\n 2, very open', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'completion_project_questionnaire_complete', NULL, 'completion_project_questionnaire', NULL, 102, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL);

-- SQL TO CREATE A REDCAP DEMO PROJECT --
set @project_title = 'Example Survey';
-- Obtain default values --
set @institution = (select value from redcap_config where field_name = 'institution' limit 1);
set @site_org_type = (select value from redcap_config where field_name = 'site_org_type' limit 1);
set @grant_cite = (select value from redcap_config where field_name = 'grant_cite' limit 1);
set @project_contact_name = (select value from redcap_config where field_name = 'project_contact_name' limit 1);
set @project_contact_email = (select value from redcap_config where field_name = 'project_contact_email' limit 1);
set @project_contact_prod_changes_name = (select value from redcap_config where field_name = 'project_contact_prod_changes_name' limit 1);
set @project_contact_prod_changes_email = (select value from redcap_config where field_name = 'project_contact_prod_changes_email' limit 1);
set @headerlogo = (select value from redcap_config where field_name = 'headerlogo' limit 1);
-- Create project --
INSERT INTO `redcap_projects` 
(project_name, app_title, status, count_project, auth_meth, creation_time, production_time, institution, site_org_type, grant_cite, project_contact_name, project_contact_email, project_contact_prod_changes_name, project_contact_prod_changes_email, headerlogo, surveys_enabled, auto_inc_set, display_project_logo_institution) VALUES
(concat('redcap_demo_',LEFT(MD5(RAND()),6)), @project_title, 1, 0, 'none', now(), now(), @institution, @site_org_type, @grant_cite, @project_contact_name, @project_contact_email, @project_contact_prod_changes_name, @project_contact_prod_changes_email, @headerlogo, 2, 1, 0);
set @project_id = LAST_INSERT_ID();
-- User rights --
INSERT INTO `redcap_user_rights` (`project_id`, `username`, `expiration`, `group_id`, `lock_record`, `data_export_tool`, `data_import_tool`, 
`data_comparison_tool`, `data_logging`, `file_repository`, `double_data`, `user_rights`, `data_access_groups`, `graphical`, `reports`, `design`, 
`calendar`, `data_entry`, `participants`, `data_quality_execute`) VALUES
(@project_id, 'site_admin', NULL, NULL, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, '[survey,1]', 0, 1);
-- Create single arm --
INSERT INTO redcap_events_arms (project_id, arm_num, arm_name) VALUES (@project_id, 1, 'Arm 1');
set @arm_id = LAST_INSERT_ID();
-- Create single event --
INSERT INTO redcap_events_metadata (arm_id, day_offset, offset_min, offset_max, descrip) VALUES (@arm_id, 0, 0, 0, 'Event 1');
set @event_id = LAST_INSERT_ID();
-- Insert into redcap_event_forms --
INSERT INTO redcap_events_forms (event_id, form_name) VALUES (@event_id, 'survey');
-- Insert into redcap_surveys
INSERT INTO redcap_surveys (project_id, form_name, title, instructions, acknowledgement, question_by_section, question_auto_numbering, survey_enabled, save_and_return, logo, hide_title, email_field) VALUES
(@project_id, 'survey', 'Example Survey', '<p style="margin-top: 10px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; font-family: Arial, Verdana, Helvetica, sans-serif; font-size: 12px; text-align: left; line-height: 1.5em; max-width: 700px; clear: both; padding: 0px;">These are your survey instructions that you would enter for your survey participants. You may put whatever text you like here, which may include information about the purpose of the survey, who is taking the survey, or how to take the survey.</p><br><p style="margin-top: 10px; margin-right: 0px; margin-bottom: 10px; margin-left: 0px; font-family: Arial, Verdana, Helvetica, sans-serif; font-size: 12px; text-align: left; line-height: 1.5em; max-width: 700px; clear: both; padding: 0px;">Surveys can use a single survey link for all respondents, which can be posted on a webpage or emailed out from your email application of choice.&nbsp;<strong>By default, all survey responses are collected anonymously</strong>&nbsp;(that is, unless your survey asks for name, email, or other identifying information).&nbsp;If you wish to track individuals who have taken your survey, you may upload a list of email addresses into a Participant List within REDCap, in which you can have REDCap send them an email invitation, which will track if they have taken the survey and when it was taken. This method still collects responses anonymously, but if you wish to identify an individual respondent\'s answers, you may do so by also providing an Identifier in your Participant List. Of course, in that case you may want to inform your respondents in your survey\'s instructions that their responses are not being collected anonymously and can thus be traced back to them.</p>', '<p><strong>Thank you for taking the survey.</strong></p><br><p>Have a nice day!</p>', 0, 0, 1, 1, NULL, 0, NULL);
-- Checklist
insert into redcap_project_checklist (project_id, name) values (@project_id, 'setup_survey');
-- Insert into redcap_metadata --
INSERT INTO redcap_metadata (project_id, field_name, field_phi, form_name, form_menu_description, field_order, field_units, element_preceding_header, element_type, element_label, element_enum, element_note, element_validation_type, element_validation_min, element_validation_max, element_validation_checktype, branching_logic, field_req, edoc_id, edoc_display_img, custom_alignment, stop_actions, question_num) VALUES
(@project_id, 'participant_id', NULL, 'survey', 'Survey', 1, NULL, NULL, 'text', 'Participant ID', NULL, NULL, NULL, NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'radio', NULL, 'survey', NULL, 2, NULL, 'Section 1 (This is a section header with descriptive text. It only provides informational text and is used to divide the survey into sections for organization. If the survey is set to be displayed as "one section per page", then these section headers will begin each new page of the survey.)', 'radio', 'You may create MULTIPLE CHOICE questions and set the answer choices for them. You can have as many answer choices as you need. This multiple choice question is rendered as RADIO buttons.', '1, Choice One \\n 2, Choice Two \\n 3, Choice Three \\n 4, Etc.', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'dropdown', NULL, 'survey', NULL, 3, NULL, NULL, 'select', 'You may also set multiple choice questions as DROP-DOWN MENUs.', '1, Choice One \\n 2, Choice Two \\n 3, Choice Three \\n 4, Etc.', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'textbox', NULL, 'survey', NULL, 4, NULL, NULL, 'text', 'This is a TEXT BOX, which allows respondents to enter a small amount of text. A Text Box can be validated, if needed, as a number, integer, phone number, email, or zipcode. If validated as a number or integer, you may also set the minimum and/or maximum allowable values.\n\nThis question has "number" validation set with a minimum of 1 and a maximum of 10. ', NULL, NULL, 'float', '1', '10', 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'ma', NULL, 'survey', NULL, 5, NULL, NULL, 'checkbox', 'This type of multiple choice question, known as CHECKBOXES, allows for more than one answer choice to be selected, whereas radio buttons and drop-downs only allow for one choice.', '1, Choice One \\n 2, Choice Two \\n 3, Choice Three \\n 4, Select as many as you like', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'yn', NULL, 'survey', NULL, 6, NULL, NULL, 'yesno', 'You can create YES-NO questions.<br><br>This question has vertical alignment of choices on the right.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'tf', NULL, 'survey', NULL, 7, NULL, NULL, 'truefalse', 'And you can also create TRUE-FALSE questions.<br><br>This question has horizontal alignment.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 'RH', NULL, NULL),
(@project_id, 'date', NULL, 'survey', NULL, 8, NULL, NULL, 'text', 'DATE questions are also an option. If you click the calendar icon on the right, a pop-up calendar will appear, thus allowing the respondent to easily select a date. Or it can be simply typed in.', NULL, NULL, 'date', NULL, NULL, 'soft_typed', NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'file', NULL, 'survey', NULL, 9, NULL, NULL, 'file', 'The FILE UPLOAD question type allows respondents to upload any type of document to the survey that you may afterward download and open when viewing your survey results.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'slider', NULL, 'survey', NULL, 10, NULL, NULL, 'slider', 'A SLIDER is a question type that allows the respondent to choose an answer along a continuum. The respondent''s answer is saved as an integer between 0 (far left) and 100 (far right) with a step of 1.', 'You can provide labels above the slider | Middle label | Right-hand label', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'descriptive', NULL, 'survey', NULL, 11, NULL, NULL, 'descriptive', 'You may also use DESCRIPTIVE TEXT to provide informational text within a survey section. ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'radio_branch', NULL, 'survey', NULL, 12, NULL, 'ADVANCED FEATURES: The questions below will illustrate how some advanced survey features are used.', 'radio', 'BRANCHING LOGIC: The question immediately following this one is using branching logic, which means that the question will stay hidden until defined criteria are specified.\n\nFor example, the following question has been set NOT to appear until the respondent selects the second option to the right.  ', '1, This option does nothing. \\n 2, Clicking this option will trigger the branching logic to reveal the next question. \\n 3, This option also does nothing.', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'hidden_branch', NULL, 'survey', NULL, 13, NULL, NULL, 'text', 'HIDDEN QUESTION: This question will only appear when you select the second option of the question immediately above.', NULL, NULL, NULL, 'undefined', 'undefined', 'soft_typed', '[radio_branch] = "2"', 0, NULL, 0, NULL, NULL, NULL),
(@project_id, 'stop_actions', NULL, 'survey', NULL, 14, NULL, NULL, 'checkbox', 'STOP ACTIONS may be used with any multiple choice question. Stop actions can be applied to any (or all) answer choices. When that answer choice is selected by a respondent, their survey responses are then saved, and the survey is immediately ended.\n\nThe third option to the right has a stop action.', '1, This option does nothing. \\n 2, This option also does nothing. \\n 3, Click here to trigger the stop action and end the survey.', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, '3', NULL),
(@project_id, 'comment_box', NULL, 'survey', NULL, 15, NULL, NULL, 'textarea', 'If you need the respondent to enter a large amount of text, you may use a NOTES BOX.<br><br>This question has also been set as a REQUIRED QUESTION, so the respondent cannot fully submit the survey until this question has been answered. ANY question type can be set to be required.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, 'LH', NULL, NULL),
(@project_id, 'survey_complete', NULL, 'survey', NULL, 16, NULL, 'Form Status', 'select', 'Complete?', '0, Incomplete \\n 1, Unverified \\n 2, Complete', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL);
