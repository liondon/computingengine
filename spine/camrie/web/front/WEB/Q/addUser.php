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


$User = new User();

$data = json_decode(file_get_contents("php://input"));


$O=$User->addUser($data->uid);



//$url = 'http://cloudmrhub.com/apps/MROPTIMUM/mroQ/testdataForUser.php';
//$data = array('uid' => $data->uid);
//
//// use key 'http' even if you send the request to https://...
//$options = array(
//    'http' => array(
//        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
//        'method'  => 'POST',
//        'content' => http_build_query($data)
//    )
//);
//$context  = stream_context_create($options);
//$result = file_get_contents($url, false, $context);



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