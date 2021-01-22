<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once 'utils/User.php';
include_once 'utils/Job.php';
// include_once 'utils/MROPTDATA.php';


$User = new UserService();


$d = json_decode(file_get_contents("php://input"));


$v=true;//=$User->checkMROPThash($d->email,$d->pwd);



if ($v){
    $UID=$d->uid;

    $a= new Job();
//    $m =new MROPTDATA();



    switch(strtolower($d->DelType)){

        case "job":
            $T=$a->getJOB($d->canc);
            
            if ($T[0]['status']=='pending'){
                $R=$a->deleteJOB($d->canc);
            }else{
                $a->backUPbadJOB($d->canc);
            }
            break;
            case "mroptimumdata":
             
    $T=$m->deleteUserData($UID,$d->id);
    return true;
            break;
        default:
            print_r(json_encode(array("response"=> "error")));    
            return false;
    }






    //echo $d->canc;
    print_r(json_encode(array("response"=> "ok")));    

}
else{
    print_r(json_encode(array("response"=> "unautorized")));    
}
?>
