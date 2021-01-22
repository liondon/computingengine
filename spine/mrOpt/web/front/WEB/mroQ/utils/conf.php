<?php
function SERVERNAME()
{
    return "itp2020.cloudmrhub.com";
}

function SERVERFTP()
{
    return "ftp.cloudmrhub.com";
}

function FTPMAINDIRDATA()
{
    return $_SERVER["DOCUMENT_ROOT"] . "/apps/MROPTIMUM/APPDATA";
}

function HTTPMAINDIRDATA()
{
    return "http://" . SERVERNAME() . "/apps/MROPTIMUM/APPDATA";
}

function tmpserver()
{
    return $_SERVER["DOCUMENT_ROOT"] . "/apps/MROPTIMUM/APPDATA/tmp";
}

function BINFILE()
{
    return $_SERVER["DOCUMENT_ROOT"] . "/apps/MROPTIMUM/";
}

function MAILAPI()
{
    return "http://{$_SERVER['HTTP_HOST']}/Q/utils/Generalmailer_PHPMAIL.php?";
}

function SERVERURL()
{
    return "http://" . SERVERNAME();
}

function personalSPACE($u, $TYPE)
{
    if ($TYPE == 'ftp') {
        $l = FTPMAINDIRDATA();
    } elseif ($TYPE == 'http') {
        $l = HTTPMAINDIRDATA();
    }

    $l = $l . "/{$u}";
    return $l;
}

function connectTOserver()
{
    $servername = 'localhost';
    $username = 'cloudmrh_itp';
    $password = 'itp2020';
    $dbname = 'cloudmrh_itp_mroptimum';
    // $port = 8889;

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    return $conn;
}

function connectTOFTP()
{
    $ftp_server = SERVERFTP();
    $ftp_user = "itp2020@cloudmrhub.com";
    $ftp_pass = "itp2020#";

    // set up a connection or die
    $conn_id = ftp_connect($ftp_server) or die("Couldn't connect to $ftp_server");

    // try to login
    if (@ftp_login($conn_id, $ftp_user, $ftp_pass)) {
        print "FTP Log in succeed!";
    } else {
        print "FTP Log in failed!";
    }
    return $conn_id;
}
