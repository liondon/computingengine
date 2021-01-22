<?php
include_once 'conf.php';






function personalSPACEACM($u, $TYPE)
{
    $l = personalSPACE($u, $TYPE) . "/ACM";
    return $l;
}

function personalSPACEDI($u, $TYPE)
{
    $l = personalSPACE($u, $TYPE) . "/DI";
    return $l;
}

function personalSPACEMR($u, $TYPE)
{
    $l = personalSPACE($u, $TYPE) . "/MR";
    return $l;
}

function personalSPACEPMR($u, $TYPE)
{
    $l = personalSPACE($u, $TYPE) . "/PMR";
    return $l;
}


function personalSPACEACMJson($u, $TYPE)
{
    $l = personalSPACEACM($u, $TYPE) . "/J";
    return $l;
}

function personalSPACEDIJson($u, $TYPE)
{
    $l = personalSPACEDI($u, $TYPE) . "/J";
    return $l;
}

function personalSPACEMRJson($u, $TYPE)
{
    $l = personalSPACEMR($u, $TYPE) . "/J";
    return $l;
}

function personalSPACEPMRJson($u, $TYPE)
{
    $l = personalSPACEPMR($u, $TYPE) . "/J";
    return $l;
}


function personalSPACEData($u, $TYPE)
{
    $l = personalSPACE($u, $TYPE) . "/DATA";
    return $l;
}




function getmatlabpath()
{
    return BINFILE();
}




function parseStr($q)
{
    $con = connectTOserver();
    $q = mysqli_real_escape_string($con, $q);
    mysqli_close($con);
    return $q;
}


function messageFix($q)
{
    $new = str_replace(' ', '%20', $q);
    return $new;
}

function reportFailedJob($serviceAPI, $JID, $UID, $log)
{
    // myH.failedJOB(data["ID"])
    restfullAPIpost($serviceAPI, array(
        "id" => $JID,
        "InfoType" => "failedjob"
    ));
    // myH.sendLOG()
    restfullAPIpost($serviceAPI, array(
        "output" => $log,
        "id" => $JID,
        "uid" => $UID,
        "InfoType" => "setlog"
    ));
    print_r(json_encode($log) . "\n");
}









function writeArrayToFTPinJSON($arr, $w, $fn)
{
    $conn_id = connectTOFTP();
    ftp_chdir($conn_id, $w);


    $fp = fopen($fn, 'w');

    if ($fp) {
        fwrite($fp, json_encode($arr, JSON_PRETTY_PRINT));
        fwrite($fp, '23');
        if (ftp_fput($conn_id, $fn, $fp, FTP_ASCII)) {
            echo "Successfully uploaded $fn\n";
        } else {
            echo "There was a problem while uploading $fn\n";
        }

        fclose($fp);

        echo json_encode($arr, JSON_PRETTY_PRINT);

        echo ftp_pwd();

        ftp_close($conn_id);
        return true;
    } else {
        echo "problems writing";
        return false;
    }
}



function writeArrayToDISKinJSON($arr, $w, $fn)
{



    switch (SERVERNAME()) {
        case "cai2r.000webhostapp.com":

            $w = str_replace("/public_html/apps/MROPTIMUM/", "../", $w);
            break;
    }



    $json = json_encode($arr);
    // write json to file
    if (file_put_contents($w . $fn, $json))
        return filesize($w . "/" . $fn);
    else
        return false;
}


function ppp($arr, $w, $fn)
{

    //$current = file_get_contents($w . $fn);
    // Append a new person to the file
    $fn = $w . $fn;
    echo ($fn);
    $json = json_encode($arr);
    // Write the contents back to the file
    file_put_contents($fn, $json);
}





function QR($Q)
{

    $con = connectTOserver();
    $res = mysqli_query($con, $Q);
    mysqli_close($con);
    $rows = array();
    while ($r = mysqli_fetch_assoc($res)) {
        $rows[] = $r;
    }
    return $rows;
}






function createFTPDIR($Q)
{
    // add this for windows system to correctly execute "mkdir" command
    if (strtoupper(substr(PHP_uname('s'), 0, 3)) === 'WIN') {
        $Q = str_replace("/", "\\", $Q);
    }

    mkdir($Q, 0777, true);
    chmod($Q, 0777);
}

function popFile($x)
{


    if (is_file($x)) {
        if (!unlink($x)) {
            return false;
        } else {
            return true;
        }
    }
}

function putFTPFile($w, $file, $remotefile)
{
    $conn_id = connectTOFTP();



    ftp_chdir($conn_id, $w);

    if (ftp_put($conn_id, $file, $remotefile, FTP_BINARY)) {
        ftp_close($conn_id);
        return true;
    } else {
        ftp_close($conn_id);
        return false;
    }
}






function restfullAPIpost($url, $data)
{
    $ch = curl_init($url);

    $payload = json_encode($data);

    // Attach encoded JSON string to the POST fields
    curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);

    // Set the content type to application/json
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));

    // Return response instead of outputting
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    // Execute the POST request
    $result = curl_exec($ch);

    $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if (($status == 201) || ($status == 200)) {
    } else {
        die("Error: call to URL $url failed with status $status, response $result, curl_error " . curl_error($ch) . ", curl_errno " . curl_errno($ch));
    }


    // Close cURL resource
    curl_close($ch);
    return json_decode($result, true);
}

function restfullAPIpostv0($url, $data)
{

    // use key 'http' even if you send the request to https://...
    $options = array(
        'http' => array(
            'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
            'method'  => 'POST',
            // 'content' => http_build_query($data)
            'content' => json_encode($data)
        )
    );

    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    return $result;
}
