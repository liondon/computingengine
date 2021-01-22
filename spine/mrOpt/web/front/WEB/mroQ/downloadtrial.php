<?php
include_once 'utils/conf.php';
header('Content-Type: application/dat');
header('Content-Disposition: attachment; filename=P.dat');
header('Pragma: no-cache');
    
$myFile = tmpserver() . "/Q.dat";
readfile($myFile);

unlink($myFile);
    








?>