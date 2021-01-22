<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header('Content-Type: text/html; charset=utf-8');
// Import PHPMailer classes into the global namespace
// These must be at the top of your script, not inside a function
//use PHPMailer\PHPMailer\PHPMailer;
//use PHPMailer\PHPMailer\Exception;
//
////Load Composer's autoloader
//require 'utils/vendor/autoload.php';
//


// get database connection
include_once 'utils/User.php';
include_once 'utils/functions.php';

$User = new UserService();

$data = json_decode(file_get_contents("php://input"));


//echo $data->uid;

$O=$User->addUser($data->uid);

$url="http://".$_SERVER["HTTP_HOST"] .'/Q/serviceAPIbe.php';
$testdatajson = array('uid' => $data->uid,"InfoType"=>"defaultdataset","serverdirectorypath"=>"SHAREDDATA/MROPTIMUMTEST/");
//$testdatajson = array('uid' => $data->uid,"InfoType"=>"defaultdataset","serverdirectorypath"=>"Q/");

//add testdata
$P=restfullAPIpost($url,$testdatajson);





if($O){

    $arr=array("response"=>true);
  print_r(json_encode($arr,JSON_NUMERIC_CHECK));
        return true;
       

}else{
    $arr=array("response"=>false);
    print_r(json_encode($arr,JSON_NUMERIC_CHECK));
    return false;

}



?>
