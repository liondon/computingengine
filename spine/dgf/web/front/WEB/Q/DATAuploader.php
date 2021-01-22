<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");


header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: x-requested-with, Content-Type, origin, authorization, accept, client-security-token");
header('Content-Type: text/html; charset=utf-8');




include 'utils/User.php';

include 'utils/data.php';


//$User = new UserService();

$v=true;//$User->checkMROPThash($_POST["email"],$_POST["pwd"]);


if ($v){

    $UID=$_POST["uid"];
    
    $t=date("Y-m-d H:i:s");

    $remotefile = $_FILES["file"]["tmp_name"];

    $fileRealname=$_POST["alias"];

    $ext = pathinfo($fileRealname, PATHINFO_EXTENSION);

    $file=uniqid() . '.' . $ext;

    $w=personalSpaceData($UID,'ftp');

    //just for cloudmr
    $wftp=str_replace('/home3/cloudmrh/', '/',$w);

    $ftptrue =putFTPFile($wftp,$file,$remotefile);



    //        

    if($ftptrue){
        $a= new data();

        $dbf=$w . '/' . $file;

        $wh=personalSpaceData($UID,'http');
        $dbfh=$wh . '/' . $file;

        //        $a->addData($UID,$fileRealname,$dbf,$t,$_POST["IT"],$_FILES['file']['size']);
        $a->addData($UID,$fileRealname,$dbf,$t,$_POST["IT"],$_FILES['file']['size'],$dbfh);

        $OUT=$a->getDataInfo($UID,$dbf,$fileRealname,$t);

        echo json_encode($OUT,JSON_NUMERIC_CHECK);
        return true;
    }
}
else{
    return false;
}
?>