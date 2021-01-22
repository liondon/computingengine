<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once 'functions.php';

$sql=$_REQUEST["Q"];

    $con = connectTOserver();

    if (!$con)
    {
        die('Could not connect: ' . mysqli_error($con));
    }





     
    $res = mysqli_query($con, $sql);

    $rows = array();
    while($r = mysqli_fetch_assoc($res)) 
    {
        $rows[] = $r;
    }

    
    echo json_encode($rows);

    // Free result set
    mysqli_free_result($res);

    mysqli_close($con);



?>
