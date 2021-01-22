<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");




include_once 'utils/Job.php';





$d = json_decode(file_get_contents("php://input"));


$v=true;//$User->checkMROPThash($d->email,$d->pwd);




if ($v){
   $UID=$d->uid;

    $a= new Job();
    //check if it is to delete or to take

        $a->backUPbadJOB($d->canc);
        $t=date("Y-m-d H:i:s");
        $a->sendFeedback($d->canc,$d->message,$t);
    
//echo $d->canc;
print_r(json_encode(array("response"=> "ok")));    
    
}
else{
    print_r(json_encode(array("response"=> "unautorized")));    
}
?>
