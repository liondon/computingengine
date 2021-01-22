<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");


// include_once 'utils/Data.php';
include_once 'utils/Job.php';
include_once 'utils/ROI.php';
include_once 'utils/conf.php';
include_once 'utils/functions.php';
include_once 'utils/User.php';
$d = json_decode(file_get_contents("php://input"));



$t=date("Y-m-d H:i:s");


switch(strtolower($d->InfoType)){
    case "getjobrois":
        $JID=$d->jid;
        $a= new ROI();
        $R=$a->getJobROIs($JID);
        print_r(json_encode(array("response"=>$R)));    
        return true;
        break;

    case "insertrois":
        $UID=$d->uid;

        $wftp=personalSPACE($UID,'ftp') . '/';

        $jf='ROI'.uniqid().'.json';

        writeArrayToDISKinJSON($d->roi,$wftp,$jf);

        $whttp=personalSPACE($UID,'http') .'/'.$jf;


        $R = new ROI();
        $R->insertROI($d->jid,$t,$d->alias,$whttp);
        print_r(json_encode(array("response"=>  $whttp)));
        return true;
        break;

    case "adduser":
        $USER= new User();
        $OUT=$USER->AddUser($d->CID);
        //will be true or false accordingly
        return $OUT;
        break;
    case "getidafterupload":

        $DATA=new Data();
        $OUT=$DATA->getFileIDafterUpload($d->UID,$d->alias,$t);
        print_r(json_encode($OUT,JSON_NUMERIC_CHECK));
        return true;                                                  

        break;
    case "setpsudojob":
        $JO=new Job();   


        $wftp=personalSpaceSettings($d->uid,'ftp') . '/';


        $jf='PSUDO_'.uniqid().'.json';

        writeArrayToDISKinJSON($d->settings,$wftp,$jf);

        $whttp=personalSpaceSettings($d->uid,'http') .'/'.$jf;


        $R=$JO->addJob($d->uid,$whttp,$t,$d->Alias);


        print_r(json_encode($R,JSON_NUMERIC_CHECK));
        unset($JO); 
        return true;                                                  
        break;
    case "getuserjob":
        $Job=new Job();   
        $R=$Job->getAllUserJob($d->UID);
        print_r(json_encode($R,JSON_NUMERIC_CHECK ));
        return true;
        break;

    case "deleteuserjob":
        $Job=new Job();

        $T=$Job->getJOB($d->jid);

        if ($T[0]['status']=='pending'){
            $R=$Job->deleteJOB($d->jid);
        }else{
            $Job->backUPbadJOB($d->jid);
            $R=$Job->deleteJOB($d->jid);
        }
        return true;
        break;
    case "setjobfeedback":
        $UID=$d->UID;
        $a= new Job();
        $a->backUPbadJOB($d->jid);
        $t=date("Y-m-d H:i:s");
        $a->sendFeedback($d->jid,$d->message,$t);

        return true;
    break;
    case "getsinglejob":
        echo "dio";
        $UID=$d->UID;
        $J= new Job();
        $O=$J->getSingleJobFromStack();
        print_r(json_encode($O));      //        print_r(json_encode($O,JSON_PRETTY_PRINT));    
        return true;
    break;
        case "setresultjob":
       
            $UID=$d->uid;
            $jobId=$d->id;
            $wftp=personalSpaceResults($UID,'ftp') . '/';
            $jf='RE_'. uniqid().'.json';
            //                this is for the cloudmrserver


            $FS=writeArrayToDISKinJSON($d->output,$wftp,$jf);

            $whttp=personalSpaceResults($UID,'http') .'/'.$jf;

            print_r(json_encode(array("out"=>$whttp),JSON_PRETTY_PRINT));

            // $R=$J->updateACMJob('ok',$d->id,$whttp,$t,$FS);
            $query ="update JOBlist set results='{$whttp}', status='ok' where ID={$jobId}";
          
            $rs=QR($query);




            return true;
        break;
    default:
        $O=[];
        return false;
}




print_r(json_encode($O,JSON_NUMERIC_CHECK));    


return true;




?>
