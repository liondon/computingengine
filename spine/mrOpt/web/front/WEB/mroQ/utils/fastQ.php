<?php
error_reporting(0);

// Report simple running errors
error_reporting(E_ERROR | E_WARNING | E_PARSE);

// Reporting E_NOTICE can be good too (to report uninitialized
// variables or catch variable name misspellings ...)
error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);

// Report all errors except E_NOTICE
// This is the default value set in php.ini
error_reporting(E_ALL ^ E_NOTICE);

// Report all PHP errors (see changelog)
error_reporting(E_ALL);

// Report all PHP errors
error_reporting(-1);

// Same as error_reporting(E_ALL);
ini_set('error_reporting', E_ALL);

if (!isset($sql)) {
$sql = $_REQUEST["Q"];
}



/*
header('Access-Control-Allow-Origin: *');
*/


include 'functions.php';
    $conn = connectTOserver();

if (mysqli_query($conn, $sql)) {
//    echo "1";
} else {
   // echo "0" . mysqli_error($conn);
}

mysqli_close($conn);


    
?>
