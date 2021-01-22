<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once 'utils/User.php';
include_once 'utils/Data.php';
include_once 'utils/Job.php';


$d = json_decode(file_get_contents("php://input"));



$t=date("Y-m-d H:i:s");


switch(strtolower($d->InfoType)){
            
        case "joblist":
        
        $UID=$d->uid;
        $Job= new Job();
        
        $R=$Job->getUserJobs($UID);
        print_r(json_encode($R,JSON_NUMERIC_CHECK ));
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
    case "setjob":

        $JO=new Job();   


        $wftp=personalSpaceSettings($d->uid,'ftp') . '/';

        $jf='DGF_'.uniqid().'.json';
        writeArrayToDISKinJSON($d->settings,$wftp,$jf);
        $whttp=personalSpaceSettings($d->uid,'http') .'/'.$jf;
        $R=$JO->addJob($d->uid,$whttp,$t,$d->Alias);

        print_r(json_encode($R,JSON_NUMERIC_CHECK));
        unset($JO); 
        return true;                                                  
        break;
case "getsinglejob":
        $J=new Job();   
        $R=$J->getJOBstate('pending',-1);
        $O=$R[0]; 
        $tocalc=$O["ID"];
        $J->SetJobToCalc(intval($tocalc));
        print_r(json_encode($O));      //
        return true;                                                  
        break;
        
        case "setresultjob":
        
        $UID=$d->uid;
        $J=new Job();  

                $wftp=personalSpaceResults($UID,'ftp') . '/';
                $jf='DGF_'. uniqid().'.json';
                


                $FS=writeArrayToDISKinJSON($d->output,$wftp,$jf);

                $whttp=personalSpaceResults($UID,'http') .'/'.$jf;

                $R=$J->updateJob('ok',$d->id,$whttp,$t,$FS);

                break;
        
        
        
        
    default:
        $O=[];
        return false;
}




print_r(json_encode($O,JSON_NUMERIC_CHECK));    


return true;




?>
