<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once 'utils/User.php';
include_once 'utils/MROPTDATA.php';
include_once 'utils/Job.php';
include_once 'utils/ROI.php';

//$User = new UserService();
//$data= new MROPTDATA();
$Job = new Job();
$r = new ROI();

$d = json_decode(file_get_contents("php://input"));



//$v=$User->checkMROPThash($d->email,$d->pwd);

$v = true;


if ($v) {

    // $UID = $d->uid;
    $t = date("Y-m-d H:i:s");

    switch (strtolower($d->InfoType)) {
        case "getjobinfo":
            $JID = $d->jid;
            $R = $Job->getJobInfo($JID);
            break;

        case "roi":
            $JID = $d->jid;
            $R = $r->getJobROIs($JID);
            break;
        default:
            $R = false;
    }

    print_r(json_encode(array("response" => $R)));
} else {
    print_r(json_encode(array("response" => "unauthorized")));
}
