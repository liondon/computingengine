<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

//include_once 'utils/MROPTDATA.php';
include_once 'utils/Job.php';
include_once 'utils/ROI.php';
include_once 'utils/conf.php';
include_once 'utils/functions.php';


$d = json_decode(file_get_contents("php://input"));


//$m= new MROPTDATA();
$J = new Job();

$t = date("Y-m-d H:i:s");



switch (strtolower($d->InfoType)) {
    case "userjobs":
        $UID = $d->uid;
        $R = $J->getAllUserJob($UID);
        print_r(json_encode($R, JSON_NUMERIC_CHECK));
        return true;

        break;

    case "addtestdata":
        $UID = $d->uid;
        $url = "http://" . $_SERVER["HTTP_HOST"] . '/Q/serviceAPIbe.php';
        $testdatajson = array('uid' => $UID, "InfoType" => "defaultdataset", "serverdirectorypath" => "SHAREDDATA/MROPTIMUMTEST/");
        $P = restfullAPIpost($url, $testdatajson);
        echo $P;


        return true;

        break;

    case "insertrois":
        $UID = $d->uid;

        $wftp = personalSPACE($UID, 'ftp') . '/';

        $jf = 'ROI' . uniqid() . '.json';

        writeArrayToDISKinJSON($d->roi, $wftp, $jf);

        $whttp = personalSPACE($UID, 'http') . '/' . $jf;


        $R = new ROI();
        $R->insertROI($d->jid, $t, $d->alias, $whttp);
        print_r(json_encode(array("response" =>  $whttp)));
        return true;
        break;




        //probably can cancel this
        // case "getidafterupload":

        //     $OUT=$m->getFileIDafterUpload($d->uid,$d->alias,$t);

        //     print_r(json_encode($OUT,JSON_NUMERIC_CHECK));
        //     return true;                                                  

        //     break;


    case "getsinglejob":


        switch (strtolower($d->JobType)) {
            case "acm":
                $R = $J->getACMJOBstate('pending', -1);

                break;
            case "di":

                $R = $J->getDIJOBstate('pending', -1);

                break;

            case "pmr":
                $R = $J->getPMRJOBstate('pending', -1);

                break;
            case "mr":
                $R = $J->getMRJOBstate('pending', -1);
                break;
            default:

                $R = [];
                return false;
        }



        $O = $R[0];
        $tocalc = $O["ID"];
        $J->SetJobToCalc(intval($tocalc));




        print_r(json_encode($O));      //        print_r(json_encode($O,JSON_PRETTY_PRINT));    
        return true;
        break;


    case "setresultjob":
        $UID = $d->uid;

        switch (strtolower($d->JobType)) {
            case "acm":
                $wftp = personalSPACEACM($UID, 'ftp') . '/';
                $jf = 'ACMRE_' . uniqid() . '.json';
                //                this is for the cloudmrserver
                $FS = writeArrayToDISKinJSON($d->output, $wftp, $jf);
                $whttp = personalSPACEACM($UID, 'http') . '/' . $jf;
                print_r(json_encode(array("out" => $whttp), JSON_PRETTY_PRINT));
                $R = $J->updateACMJob('ok', $d->id, $whttp, $t, $FS);
                break;

            case "di":
                $wftp = personalSPACEDI($UID, 'ftp') . '/';
                $jf = 'DIRE_' . uniqid() . '.json';
                // echo getcwd() . "\n";
                $FS = writeArrayToDISKinJSON($d->output, $wftp, $jf);
                $whttp = personalSPACEDI($UID, 'http') . '/' . $jf;
                $R = $J->updateDIJob('ok', $d->id, $whttp, $t, $FS);
                break;

            case "mr":
                $wftp = personalSPACEMR($UID, 'ftp') . '/';
                $jf = 'MRRE_' . uniqid() . '.json';
                $FS = writeArrayToDISKinJSON($d->output, $wftp, $jf);
                $whttp = personalSPACEMR($UID, 'http') . '/' . $jf;
                $R = $J->updateMRJob('ok', $d->id, $whttp, $t, $FS);
                break;

            case "pmr":
                $wftp = personalSPACEPMR($UID, 'ftp') . '/';
                $jf = 'PMRRE_' . uniqid() . '.json';
                $FS = writeArrayToDISKinJSON($d->output, $wftp, $jf);
                $whttp = personalSPACEPMR($UID, 'http') . '/' . $jf;
                $R = $J->updatePMRJob('ok', $d->id, $whttp, $t, $FS);
                break;

            default:
                $O = [];
                return false;
        }
        $O = true;
        return true;
        break;

    case  "setlog":
        $UID = $d->uid;
        $wftp = personalSPACE($UID, 'ftp') . '/';
        $jf = 'log_' . uniqid() . '.json';
        writeArrayToDISKinJSON($d->output, $wftp, $jf);
        $whttp = personalSPACE($UID, 'http') . '/' . $jf;
        $R = $J->insertJobLOG($d->id, $whttp);
        break;

    case "failedjob":
        $J->_updateJob('ko', $d->id, $t, 0);
        break;

    case "pendingjob":
        $J->_updateJob('pending', $d->id, $t, 0);
        break;

    case "userrois":
        $R = new ROI();

        $UID = $d->uid;

        $O = $R->getUserROIs($UID);

        break;
    case "deleteroi":
        $R = new ROI();

        $ID = $d->roiid;

        $R->deleteROI($ID);

        break;

    default:
        $O = [];
        return false;
}




print_r(json_encode($O, JSON_NUMERIC_CHECK));


return true;
