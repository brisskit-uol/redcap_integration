<?php

//********************************************************************************************************************
// MYSQL DATABASE CONNECTION:
// Replace the values inside the single quotes below with the values for your MySQL configuration. 
// If not using the default port 3306, then append a colon and port number to the hostname (e.g. $hostname = 'example.com:3307';).

//$hostname 	= '192.168.2.106';
//$db 		= 'redcap';
//$username 	= 'redcap';
//$password 	= 'redcap';

// For greater security, you may instead want to place the database connection values in a separate file that is not 
// accessible via the web. To do this, uncomment the line below and set it as the path to your database connection file
// located elsewhere on your web server. The file included should contain all the variables from above.

include 'mysql_settings.php';


//********************************************************************************************************************
// SALT VARIABLE:
// Add a random value for the $salt variable below, preferably alpha-numeric with 8 characters or more. This value wll be 
// used for data de-identification hashing for data exports. Do NOT change this value once it has been initially set.

$salt = 'hfasjdflkasj';


//********************************************************************************************************************
// DATA TRANSFER SERVICES (DTS):
// If using REDCap DTS, uncomment the lines below and provide the database connection values for connecting to
// the MySQL database containing the DTS tables (even if the same as the values above).

// $dtsHostname 	= 'your_dts_host_name';
// $dtsDb 			= 'your_dts_db_name';
// $dtsUsername 	= 'your_dts_db_username';
// $dtsPassword 	= 'your_dts_db_password';
?>
