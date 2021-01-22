<!-- Replace the "Read result" and "Update job status" part
in the python script of Computing Unit -->

<?php
include_once 'utils/functions.php';
include_once 'utils/Job.php';

echo "<pre>";
echo "in receiveResultFiles.php<br/>";
print_r($_REQUEST);
print_r($_FILES);

// TODO: we could move these settings to "conf.php" or even consider using environment variables for this.
$serviceAPI = "http://" . $_SERVER["HTTP_HOST"] . "/apps/MROPTIMUM/mroQ/serviceAPI.php";

$UID = $_REQUEST['UID'];
$JType = $_REQUEST['JType'];
$log = $_FILES['log'];
$result = $_FILES['result'];

$JID = $_REQUEST['JID'] ?? '';    // mode 2 user don't have the JID yet
$Mode = $_REQUEST['Mode'] ?? 1;    // if "Mode" is not specified, use 1

// If this job is sent back to Bluehost by a "mode 2 user",
// who's a "pro" user that only utilizes docker container of computing unit to run computation on their own machine,
// and wants to analyze the result on MROptimum Web GUI on Bluehost. 
// Then, insert a dummy job before sending the result back. 
// TODO: We might want a separate `mode2_JOBlist` table in the future.
if ($Mode == 2) {
  $Alias = $_REQUEST['Alias'] ?? 'dummy job for mode2';    // if "Alias" is not specified, use 'dummy job for mode2'
  $t = date("Y-m-d H:i:s");
  $a = new Job();

  switch (strtolower($JType)) {
    case "acm":
      $JID = $a->addACMJOB($UID, $t, 'Null: no $jop for dummy job', 'Null: no $d->ACM for dummy job', $Alias);
      break;
    case "pmr":
      $JID = $a->addPMRJOB($UID, $t, 'Null: no $jop for dummy job', 'Null: no $d->ACM for dummy job', $Alias);
      break;
    case "di":
      $JID = $a->addDIJOB($UID, $t, 'Null: no $jop for dummy job', $Alias);
      break;
    case "mr":
      $JID = $a->addMRJOB($UID, 'Null: no $d->images for dummy job', $t, 'Null: no $jop for dummy job', $Alias);
      break;
    default:
      $JID = false;
  }
  if ($JID) {
    print_r(json_encode(array(
      "response" => "ok",
      "message" => "insert dummy job into database SUCCEEDED.",
      "jid" => $JID
    )) . "\n");
  } else {
    $log = array(
      "type" => "error",
      "text" => "insert dummy job into database FAILED.",
      "time" => date("Y-m-d H:i:s")
    );
    die(json_encode($log));
  }
}

// Read the result and update job status accordingly
$log_decode = json_decode(file_get_contents($log['tmp_name']), true);
$V = false;
foreach ($log_decode as $log_item) {
  // print_r($log_item);

  // this is a bit different from the python script, but DItask might fail and also have 'stop' log
  if ($log_item['type'] == 'ko') {
    break;
  }

  if ($log_item['type'] == 'stop') {
    $V = true;
    $result_decode = json_decode(file_get_contents($result['tmp_name']), true);
  }
}

if ($V) {
  // myH.sendJOBResult
  $today = date("Y-m-d");
  $host = gethostname();
  $info = "{\"jobnumber\":\"${JID}\",\"date\":\"${today}\",\"host\":\"${host}\"}";
  $result_decode["info"] = json_decode($info, true);
  $data = array(
    "output" => $result_decode,
    "id" => $JID,
    "uid" => $UID,
    "InfoType" => "setresultjob",
    "JobType" => $JType
  );
  // print_r($data);
  $response = restfullAPIpost($serviceAPI, $data);
  print_r($response);
} else {
  // myH.failedJOB
  $response = restfullAPIpost($serviceAPI, array(
    "id" => $JID,
    "InfoType" => "failedjob"
  ));
  print_r($response);
}
// myH.sendLOG
$data = array(
  "output" => $log_decode,
  "id" => $JID,
  "uid" => $UID,
  "InfoType" => "setlog"
);
$response = restfullAPIpost($serviceAPI, $data);
print_r($response);
