<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once 'utils/User.php';
include_once 'utils/Job.php';


$User = new UserService();


$d = json_decode(file_get_contents("php://input"));

$data=array("username"=> $d->username,"password"=> $d->password,"InfoType"=>"isuser");

$out=restfullAPIpost("http://" . $_SERVER["HTTP_HOST"] ."/Q/serviceAPIbe.php",$data);



$UID=intval($out["uid"]);
if($UID!=null){
        switch(strtolower($d->jobtype)){
            case "di":

                $d->J->alias=$d->alias;
                $d->J->from="restAPI";
                $DIDATA=array("uid"=> $UID,"J"=>$d->J,"Alias"=>$d->alias,"JobType"=>$d->jobtype);
                $O=restfullAPIpost("http://" . $_SERVER["HTTP_HOST"] ."/apps/MROPTIMUM/mroQ/insertJob.php",$DIDATA);
                $query ="select ID from JOBlist where UID={$UID} and Alias='{$d->alias}' order by dateIN DESC LIMIT 1"; 
                $rs=QR($query);
       
                    print_r(json_encode(array("taskid"=>intval($rs["0"]["ID"]))));

                    return true;
        

}
}else{
    print_r(json_encode(array("taskid"=>null)));
    return false;
}

// $v=true; //$User->checkMROPThash($d->user,$d->pwd);






// if ($v){
//     $UID=$d->uid;
//     $t=date("Y-m-d H:i:s");
//     $a= new Job();    
//     switch(strtolower($d->JobType)){

//         case "acm":

//             $wftp=personalSPACEACMJson($UID,'ftp') . '/';
            
           
            
//             $jf='ACMOPT_'.uniqid().'.json';

//             writeArrayToDISKinJSON($d->J,$wftp,$jf);
            
//             $whttp=personalSPACEACMJson($UID,'http') .'/'.$jf;

//             $R=$a->addACMJOB($UID,$t,$whttp,$d->ACM,$d->Alias);
//             break;
//         case "di":

//             //write the opt file
//             $jf='DIOPT_'.uniqid().'.json';
//             $wftp=personalSPACEDIJson($UID,'ftp') . '/';
//             writeArrayToDISKinJSON($d->J,$wftp,$jf);
//             $whttp=personalSPACEDIJson($UID,'http') .'/'.$jf;
//             //insert in the database
//             $R=$a->addDIJOB($UID,$t,$whttp,$d->Alias);
//             break;
//         case "mr":
//             $wftp=personalSPACEMRJson($UID,'ftp') . '/';          
//             $jf='MROPT_'.uniqid().'.json';
//            writeArrayToDISKinJSON($d->J,$wftp,$jf);
//             $whttp=personalSPACEMRJson($UID,'http') .'/'.$jf;
//             $R=$a->addMRJOB($UID,$d->images,$t,$whttp,$d->Alias);
//             break;
//         case "pmr":

//             $wftp=personalSPACEPMRJson($UID,'ftp') . '/';
    
            
//             $jf='PMROPT_'.uniqid().'.json';
            
//              writeArrayToDISKinJSON($d->J,$wftp,$jf);
//             $whttp=personalSPACEPMRJson($UID,'http') .'/'.$jf;

//             $R=$a->addPMRJOB($UID,$t,$whttp,$d->ACM,$d->Alias);
//             break;

//         default:
//             $R=false;
//     }

//     if($R)
//     {
//         print_r(json_encode(array("response"=> "ok")));    
//     }else{
//         print_r(json_encode(array("response"=> "ko")));    
//     }


// }
// else{
//     print_r(json_encode(array("response"=> "unautorized")));    
// }
?>