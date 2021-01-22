<?php
include_once 'utils/conf.php';






$d = json_decode(file_get_contents("php://input"));


header('Content-Type: application/dat');
header('Content-Disposition: attachment; filename=P.dat');
header('Pragma: no-cache');
    
//$myFile = tmpserver() . "/Q.dat";
$myFile = tmpserver() . "/" . $d->id;
readfile($myFile);

//unlink($myFile);
    








?>`