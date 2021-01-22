<?php
include_once 'conf.php';



function personalSpace($u,$TYPE){

    switch($TYPE){
        case "ftp":
            $l=getApplicationMainDataStorageFTP();
            break;

        case "http":

            $l=getApplicationMainDataStorageHttp();
            break;

        case "path":
            $l= getApplicationMainDataStoragePath();
            break;
    }

    $l= $l . "/{$u}";
    return $l;

}


function personalSpaceSettings($u,$TYPE){
    $l=personalSPACE($u,$TYPE) . "/settings" ;
    return $l;

}


function personalSpaceData($u,$TYPE){
    $l=personalSPACE($u,$TYPE) . "/data"  ;
    return $l;

}

function personalSpaceResults($u,$TYPE){
    $l=personalSPACE($u,$TYPE) . "/results"  ;
    return $l;

}



function parseStr($q)
{
    $con = connectTOserver();
    $q=mysqli_real_escape_string($con,$q);
    mysqli_close($con);
    return $q;
}


function messageFix($q)
{
    $new = str_replace(' ', '%20', $q);
    return $new;
}









function writeArrayToDISKinJSON($arr,$w,$fn){



//    switch(SERVERNAME())
//    {
//        case "cai2r.000webhostapp.com":
//
//            $w=str_replace("/public_html/apps/PSUDOMRI/", "../", $w);
//            break;
//    }



    $json = json_encode($arr);
    // write json to file
    if (file_put_contents($w . $fn, $json))
        return filesize ($w."/".$fn); 
    else 
        return false;


}



function QR($Q)
{

    $con = connectTOserver();
    $res = mysqli_query($con, $Q);
    mysqli_close($con);
    $rows = array();
    while($r = mysqli_fetch_assoc($res)) 
    {
        $rows[] = $r;
    }
    return $rows;

}






function createFTPDIR($Q)
{

    mkdir($Q, 0777,true);
    chmod($Q, 0777);

}

function popFile($x)
{


    if (is_file($x))
    {
        if (!unlink($x))
        {
            return false;
        }
        else
        {
            return true;
        }
    }


}

function putFTPFile($w,$file,$remotefile)
{
    $conn_id = connectTOFTP();



    ftp_chdir($conn_id,$w);

    if (ftp_put($conn_id, $file, $remotefile, FTP_BINARY)) {
        ftp_close($conn_id);  
        return true;
    } else {
        ftp_close($conn_id);  
        return false;
    }

}


function getFileExtension($filename)
{
    return pathinfo($filename, PATHINFO_EXTENSION);    
}



?>



