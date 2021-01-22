<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header('Content-Type: text/html; charset=utf-8');

include_once 'utils/User.php';


$User = new User();

$data = json_decode(file_get_contents("php://input"));


$O=$User->addUser($data->uid);





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
