<?php

include_once 'functions.php';


$remotefile = ($_FILES["file"]["tmp_name"]);

$file=basename($_FILES["file"]["name"]);


if(isset($_POST['w'])) 
{
    $w=$_POST['w'];
}else
{
    $w="/data/GARBAGE";
};
                        
putFTPFile($w,$file,$remotefile);
