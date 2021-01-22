<!-- Use AWS-SDK to run the container instance with commands -->

<?php
// import aws-sdk
require_once __DIR__ . "/../../vendor/autoload.php";

use Aws\Ecs\EcsClient;
use Aws\Exception\AwsException;

/*
* @param string[] $fileUrls: an array of urls of input files ($fileName => $fileUrl)
* @param string $jop: the link of job options json file
* @param string $QSRVR: the link of the "Q server"
* @param string $JType: the job type -- acm, pmr, di, mr.
* @param string $JID: the job id.
* @param string $UID: the user id.
* @param object $AWSInfo: default or user's AWS info
*
* @return mixed[] the result of executing runTask on specified AWS cluster, could be failure or taskInfo
*/

function invokeContainer($fileUrls, $jop, $QSRVR, $JType, $JID, $UID, $AWSInfo)
{
  // TODO: we could move these settings to "conf.php" or even consider using environment variables for this.
  $receiveResultFilesAPI = "http://" . $_SERVER["HTTP_HOST"] . "/apps/MROPTIMUM/mroQ/receiveResultFiles.php";

  // basic settings for AWS, 
  $ecs = new Aws\Ecs\EcsClient([
    'version' => 'latest',    //required
    'region' => $AWSInfo->region,
    'credentials' => [
      'key'    => $AWSInfo->key,
      'secret' => $AWSInfo->secret,
    ],
  ]);
  $cluster = $AWSInfo->cluster;
  $taskDef = $AWSInfo->taskDef;
  $containerName = $AWSInfo->containerName;

  // variables for file path inside the container 
  // TODO: we could move these settings to "conf.php" or even consider using environment variables for this.
  $mcrLib = "/opt/mcr/v98";
  $acmShellScript = "/usr/src/app/ACMtaskComp/for_testing/run_ACMCompiledtask.sh";
  $pmrShellScript = "/usr/src/app/PMRtaskComp/for_testing/run_PMRtask.sh";
  $diShellScript = "/usr/src/app/DItaskComp/for_testing/run_DImat.sh";
  $mrShellScript = "/usr/src/app/MRtaskComp/for_testing/run_MRtask.sh";
  $resultFile = "Result.json";
  $logFile = "Log.json";

  // TODO: this is workaround for curl command in container to correctly execute
  $CMD = 'export LD_LIBRARY_PATH=/usr/local/lib';

  // Download arbitrary number of data files (usually 2 files, except for MR task)
  // e.g. curl --output $fileName http://cloudmrhub.com/RESOURCES/meas_MID01481_FID318481_gre_snrSIGNAL1.dat
  $fileNames = array();
  $CMD_download = '';
  foreach ($fileUrls as $fileName => $fileUrl) {
    $ext = strrchr($fileUrl, '.');
    $fileNames[$fileName] = "${fileName}${ext}";
    $CMD_download .= " && curl --output {$fileNames[$fileName]} ${fileUrl}";
  }
  $CMD .= $CMD_download;

  // 2. Execute the computation task
  $CMD_compute = "";
  switch (strtolower($JType)) {
    case "acm":
      $CMD_compute .= " && ${acmShellScript} ${mcrLib} {$fileNames['signal']} {$fileNames['noise']} ${jop} ${resultFile} ${logFile} ${QSRVR}";
      break;
    case "pmr":
      $CMD_compute .= " && ${pmrShellScript} ${mcrLib} {$fileNames['signal']} {$fileNames['noise']} ${jop} ${resultFile} ${logFile} ${QSRVR}";
      break;
    case "di":
      $CMD_compute .= " && ${diShellScript} ${mcrLib} {$fileNames['image0']} {$fileNames['image1']} ${resultFile} ${logFile}";
      break;
    case "mr":
      // send String like "{'file0.dat', 'file1.dat'}" as first argument to compiled MRtask MATLAB program.
      $files = "";
      foreach ($fileNames as $fileName) {
        $files .= ", '${fileName}'";
      }
      $files = "{" . substr($files, 2) . "}";
      print "${files}\n";

      $CMD_compute .= " && ${mrShellScript} ${mcrLib} \"${files}\" ${jop} ${resultFile} ${logFile} ${QSRVR}";
      break;
  }
  $CMD .= $CMD_compute;

  // 3. send the result back to receiveResultFiles.php
  // e.g. curl -F 'result=@Result.json' -F 'log=@Log.json' -F 'JID=10' -F 'UID=222' -F 'JType=acm' http://localhost:8888/apps/MROPTIMUM/mroQ/receiveResultFiles.php -k
  // TODO: "-k" is workaround for curl command in container to correctly execute without ssl certificate.
  $CMD .= " && touch ${resultFile} && curl -F 'result=@${resultFile}' -F 'log=@${logFile}' -F 'JID=${JID}' -F 'UID=${UID}' -F 'JType=${JType}' ${receiveResultFilesAPI} -k";

  print "${CMD}\n";
  $result = $ecs->runTask([
    // 'launchType' => 'EC2',    // we don't use this since we're using 'capacity provider' for auto-scaling
    'taskDefinition' => $taskDef,
    'cluster' => $cluster,
    'count' => 1,
    'overrides' => [
      'containerOverrides' => [
        [
          'name' => $containerName,
          'command' => ['/bin/bash', '-c', $CMD]
        ],
      ],
    ]
  ]);
  return $result;
};

// // for testing only:
// $files = array(
//   'signal' => 'http://cloudmrhub.com/SHAREDDATA/MROPTIMUMTEST/Signal_Data_Multislice.dat',
//   'noise' => 'http://cloudmrhub.com/SHAREDDATA/MROPTIMUMTEST/Noise_Data_Multislice.dat'
// );

// $files_di = array(
//   'image0' => 'http://cloudmrhub.com/SHAREDDATA/MROPTIMUMTEST/replica1.IMA',
//   'image1' => 'http://cloudmrhub.com/SHAREDDATA/MROPTIMUMTEST/replica2.IMA'
// );

// $jop_acm = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/147/ACM/J/ACMOPT_5d1d0afd204bd.json";
// $jop_pmr = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/147/PMR/J/PMROPT_5d1d0e23de333.json";
// $jop_mr = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/212/MR/J/MROPT_5f452fca92548.json";
// $QSRVR = "http://cloudmrhub.com/Q";
// $JType = "acm";
// $JID = "8";
// $UID = "222";
// invokeContainer($files_di, $jop_pmr, $QSRVR, $JType, $JID, $UID);
?>