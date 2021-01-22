<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'utils/User.php';
include 'utils/ROI.php';




$d = json_decode(file_get_contents("php://input"));


$v=true;//=$User->checkMROPThash($d->email,$d->pwd);



if ($v){
    $JID=$d->jid;
    $a= new ROI();

    $R=$a->getJobROIs($JID);
    print_r(json_encode(array("response"=>$R)));    
 return true;   
}
else{
    print_r(json_encode(array("response"=> "unautorized")));    
    return false;
}
?>