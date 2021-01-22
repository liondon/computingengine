<?php

function getHost(){
    //    return "epmlcdcdvm01.nyumc.org";
//    return "http://cloudmrhub.com";
    return "192.168.56.2";
}


//every user will have a personal space made by
//    PID
//     settings
//         data
//         resutls
function getApplicationMainDataStoragePath()
{
    return "/var/www/WEB/apps/PSUDOMRI/APPDATA";
}

function getApplicationMainDataStorageFTP()
{
    return "/var/www/WEB/apps/PSUDOMRI/APPDATA";
}

function getApplicationMainDataStorageHttp()
{

    return "http://". getHost() ."/apps/PSUDOMRI/APPDATA";
    //    $ftp_server = "epmlcdcdvm01.nyumc.org";

}


function getTmpServer(){
    return "/data/tmp";

}



function getMailApi(){
    return "https://cai2r.000webhostapp.com/Generalmailer.php?";
}


function getApplicationMainHttp()
{

    return "http://". getHost() . "/apps/PSUDOMRI";
    //    $ftp_server = "epmlcdcdvm01.nyumc.org";

}






function connectTOserver()
{

    $servername = "localhost";
    $username = "cai2r";
    $password="cai2r";
    $dbname="psudomri";
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }//else{echo 'dioo';}

    return $conn;

}

function connectTOFTP(){

    $ftp_server = getHost();

    $ftp_user = "prova";
    $ftp_pass = "prova";

    // set up a connection or die
    $conn_id = ftp_connect($ftp_server) or die("Couldn't connect to $ftp_server"); 

    // try to login
    if (@ftp_login($conn_id, $ftp_user, $ftp_pass)) {

    }else{
    }
    return $conn_id;
}




?>
