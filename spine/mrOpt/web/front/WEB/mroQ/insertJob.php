<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once 'utils/User.php';
include_once 'utils/Job.php';
include_once 'utils/invokeContainer.php';
include_once 'utils/functions.php';

// TODO: we could move these settings to "conf.php" or even consider using environment variables for this?
$cmserviceAPI = "http://" . $_SERVER["HTTP_HOST"] . "/Q/serviceAPI.php";
$serviceAPI = "http://" . $_SERVER["HTTP_HOST"] . "/apps/MROPTIMUM/mroQ/serviceAPI.php";
$QSRVR = "http://" . $_SERVER["HTTP_HOST"] . "/Q";

$User = new UserService();
$d = json_decode(file_get_contents("php://input"));
$v = true; //$User->checkMROPThash($d->email,$d->pwd);

if ($v) {
    $UID = $d->uid;
    $t = date("Y-m-d H:i:s");
    $a = new Job();
    $whttp = ''; // This is the $jop that we need to send into invokeContainer

    switch (strtolower($d->JobType)) {
            // NOTE: I modified each addJOB function to return JID
        case "acm":
            $wftp = personalSPACEACMJson($UID, 'ftp') . '/';
            $jf = 'ACMOPT_' . uniqid() . '.json';
            writeArrayToDISKinJSON($d->J, $wftp, $jf);
            $whttp = personalSPACEACMJson($UID, 'http') . '/' . $jf;
            $JID = $a->addACMJOB($UID, $t, $whttp, $d->ACM, $d->Alias);
            break;

        case "di":
            //write the opt file
            $jf = 'DIOPT_' . uniqid() . '.json';
            $wftp = personalSPACEDIJson($UID, 'ftp') . '/';
            writeArrayToDISKinJSON($d->J, $wftp, $jf);
            $whttp = personalSPACEDIJson($UID, 'http') . '/' . $jf;
            //insert in the database
            $JID = $a->addDIJOB($UID, $t, $whttp, $d->Alias);
            break;

        case "mr":
            $wftp = personalSPACEMRJson($UID, 'ftp') . '/';
            $jf = 'MROPT_' . uniqid() . '.json';
            writeArrayToDISKinJSON($d->J, $wftp, $jf);
            $whttp = personalSPACEMRJson($UID, 'http') . '/' . $jf;
            $JID = $a->addMRJOB($UID, $d->images, $t, $whttp, $d->Alias);
            break;

        case "pmr":
            $wftp = personalSPACEPMRJson($UID, 'ftp') . '/';
            $jf = 'PMROPT_' . uniqid() . '.json';
            writeArrayToDISKinJSON($d->J, $wftp, $jf);
            $whttp = personalSPACEPMRJson($UID, 'http') . '/' . $jf;
            $JID = $a->addPMRJOB($UID, $t, $whttp, $d->ACM, $d->Alias);
            break;

        default:
            $JID = false;
    }
    if ($JID) {
        print_r(json_encode(array(
            "response" => "ok",
            "message" => "insertJob into database SUCCEEDED.",
            "jid" => $JID
        )) . "\n");
    } else {
        // L = myH.logErrorEntry()
        $log = array(
            "type" => "error",
            "text" => "insertJob into database FAILED.",
            "time" => date("Y-m-d H:i:s")
        );
        die(json_encode($log) . "\n");
    }

    if (isset($d->requestFrom)) {
        if (strcmp($d->requestFrom, "brain") == 0) {
            // $response = array();
            
            header("Content-Type: application/json");
            $response = json_encode(array(
                'status' => "job Added",
                'jobId' => $JID
            ));
        }
    }

    $OPTION = json_decode(json_encode($d->J), true);
    // print_r($OPTION);

    // generate an array of $fileName => $fileId
    $fileIDs = array();
    switch (strtolower($d->JobType)) {
        case "acm":
        case "pmr":
            $fileIDs['signal'] = $OPTION['signaldata'];
            $fileIDs['noise'] = $OPTION['noisedata'];
            break;

        case "di":
            $fileIDs['image0'] = $OPTION['image0'];
            $fileIDs['image1'] = $OPTION['image1'];
            // For testing only:
            // $fileIDs['image0'] = null;
            // $fileIDs['image1'] = null;
            break;

        case "mr":
            $images = json_decode($OPTION["images"], true);
            foreach ($images as $i => $img) {
                $fileIDs["image${i}"] = $img["ID"];
            }
            break;
    }
    // print_r($fileIDs);

    // myH.downloadCmFile - getdatadownloadlink
    // generate an array of $fileName => $fileUrl
    $fileUrls = array();
    foreach ($fileIDs as $fileName => $fileId) {
        $data = array(
            "serviceType" => "getdatadownloadlink",
            "id" => $fileId
        );

        // if the file is not ready, sleep 60 seconds and try it again.
        // NOTE: this is different from the python script cuz the workflow is different now. 
        $fileUrl = '';
        do {
            $fileUrl = restfullAPIpost($cmserviceAPI, $data);
            if ($fileUrl === "pending") {
                // TODO: this might time out eventually, add proper error handling here.
                print_r("Pending: waiting for the data files to be ready...\n");
                sleep(60);
            }
        } while ($fileUrl === "pending");

        switch ($fileUrl) {
            case  "nofile":
                $log = array(
                    "type" => "error",
                    "text" => "image with ID: ${fileId} not found. Job(JID): ${JID} failed.",
                    "time" => date("Y-m-d H:i:s")
                );
                reportFailedJob($serviceAPI, $JID, $UID, $log);
                die();
                break;
            case "error":
            case "":
                $log = array(
                    "type" => "error",
                    "text" => "cannot get data download link.",
                    "time" => date("Y-m-d H:i:s")
                );
                reportFailedJob($serviceAPI, $JID, $UID, $log);
                die();
                break;
            default:
                $fileUrls[$fileName] = $fileUrl;
        }
    }
    // print_r($fileUrls);

    // invokeContainer($fileUrls, $jop, $QSRVR, $JType, $JID, $UID)
    // TODO: this is where we could read user's AWS info from the front-end
    // TODO: we could move default settings to "conf.php" or even use environment variables for this.
    // TODO: for credentials, see https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials.html
    $AWSInfo = $d->AWSInfo ?? (object) [
        'key' => 'AKIA3JMJLHQUAILPOQE6',
        'secret' => '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',
        'region' => 'us-east-1',
        'cluster' => 'MROpt',
        'taskDef' => 'mropt-cu:17',
        'containerName' => 'mropt-cu',
    ];
    $result = invokeContainer($fileUrls, $whttp, $QSRVR, $d->JobType, $JID, $UID, $AWSInfo);
    // print_r($result);
    if (empty($result['failures'])) {
        $arn = $result['tasks']['0']['taskArn'];
        $str = 'task/';
        $taskId = substr($arn, strpos($arn, $str) + strlen($str));
    } else {
        $log = array(
            "type" => "error",
            "text" => "cannot invoke container on AWS cluster.",
            "time" => date("Y-m-d H:i:s")
        );
        reportFailedJob($serviceAPI, $JID, $UID, $log);
        print_r(json_encode($result['failures']) . "\n");
        die();
    }

    // store `taskID`, `appName` ,`JID`, `getJobInfoAPI` at `AWStasks` table at CloudMR database
    // TODO: redesign the column of `AWStasks` table. We might want to move `getJobInfoAPI` to `applications` table?
    $response = restfullAPIpost($cmserviceAPI, array(
        "taskId" => $taskId,
        "appName" => "MROPTIMUM",
        "jid" => $JID,
        "getJobInfoAPI" => "http://" . $_SERVER["HTTP_HOST"] . "/apps/MROPTIMUM/mroQ/getJobInfo.php",
        "serviceType" => "addTask"
    ));
    // TODO: Add proper error handling
    print_r($response);
} else {
    print_r(json_encode(array("response" => "unauthorized")));
}
