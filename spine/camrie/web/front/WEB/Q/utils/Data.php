<?php
include_once 'functions.php';

class Data
{
    
    
    

    public function addData($UID,$realname,$fname,$date,$it,$s,$extname)
    {


        $query = "insert into data (UID,filename,internalfilename, dateIN,imagetypeID,size,externalfilename) values  ({$UID},'{$realname}','{$fname}','{$date}',{$it},{$s},'{$extname}')";

        QR($query);
        return true;

    }
    
    
        public function getDataInfo($UID,$date)
    {

        $query = "select * from data where UID='{$UID}' and dateIN='{$date}' ";

        $rows=QR($query);
        return $rows;

    }
    
        public function getFileIdFromExtension($ext){
        $query = "SELECT ID as EXT FROM IT WHERE extension='{$ext}'";
        $rows=QR($query);
        return $rows[0]["EXT"];

    }
    
    
    public function getFileIDafterUpload($id,$alias,$t)
    {
        
            $query = "SELECT externalfilename as LINK, ID as ID, DATEDIFF( CURRENT_TIMESTAMP, dateIN) as TIME FROM data WHERE (UID={$id}  and DATEDIFF( CURRENT_TIMESTAMP, dateIN)<1 and filename='{$alias}') order by dateIN DESC limit 1";
       
        $rows=QR($query);
       
       
            return $rows;

    }
    
    
    
    
    
    
}


//    public function getFileExtensions($ID){
//        $query = "SELECT Extension FROM ITextensions WHERE ITID={$ID}";
//        $rows=QR($query);
//        return $rows;
//
//    }
//
//
//

//
//
//
//    public function selectone($x)
//    {
//
//
//        $query = "SELECT * FROM data WHERE status='{$x}' limit 1";
//
//        $rows=QR($query);
//
//        return $rows;
//
//    }
//
//
//    public function addDataFTP($UID,$file,$aliasname,$date,$wftp,$FSIZE)
//    {
//
//
//
//        $t=date("Y-m-d H:i:s");
//
//        $ext=getFileExtension($aliasname);
//
//        $it=getFileIdFromExtension($ext);
//
//        $infilename=uniqid() . '.' . $ext;
//
//        $dbf=$wftp . '/' . $infilename;
//        $wftp=str_replace('/home3/cloudmrh/', '/',$wftp);
//
//
//        $wh=personalSpaceData($UID,'http');
//        $dbfh=$wh . '/' . $infilename;
//
//
//
//
//        if($this->_checkData($UID,$fname)){
//            if(putFTPFile($w,$infilename,$file)){
//
//                $this->ddData($UID,$aliasname,$dbf,$t,$it,$FS,$dbfh);
//
//                $OUT=$a->getDataInfo($UID,$dbf,$fileRealname,$t);
//
//
//                return $OUT;
//            }
//        }else {
//            return false;
//        }
//
//
//    }
//
//
//
//    public function deleteUserData($UID,$fid)
//    {//User id, hashed pwd, fid
//
//        $D=$this->getdataInfo($fid);
//        $f=$D[0]["internalfilename"];
//        $fn=$D[0]["filename"];
//
//
//        $nfid=intval($fid);
//
//
//        if(!empty($f)){
//            if(!$this->_checkData(intval($UID),$fn)){
//                //            if the data is on the DB
//                if(popFile($f)){
//                    $query = "delete from data where ID={$nfid}" ;
//                    $rows=QR($query);
//
//                    return true;
//                }else {
//
//                    return false;
//
//                }
//            }else{
//
//
//                return false;
//            }
//        }else{
//            return false;
//
//        }
//    }
//
//
//
//    public function getDataInfo($UID,$fname,$iname,$date)
//    {
//
//        $query = "select * from data where UID='{$UID}' and dateIN='{$date}' and internalfilename='{$fname}' and filename='{$iname}'";
//
//        $rows=QR($query);
//        return $rows;
//
//    }
//
//
//    public function getUserdata($UID)
//    {
//
//        $query = "select * from data where UID={$UID}";
//
//        $rows=QR($query);
//        return $rows;
//
//    }
//
//
//    private function _checkData($UID,$fname)
//    {
//        //        does the data NOT exist?
//        $query = "select count(*) as A from data where UID='{$UID}' and filename='{$fname}'";
//        $rows=QR($query);
//        if ($rows[0]["A"]>0){
//            return false;
//        }else{
//            return true;            
//        }
//
//    }
//
//    public function getdataInfo($id)
//    {
//
//        $query = "select * from data where ID={$id}";
//        $rows=QR($query);
//        return $rows;
//
//    }
//
//    public function updatefield($id,$field,$value)
//    {
//        if(is_string($value)){
//            $query = "update data set {$field}='{$value}' where ID={$id}";
//        }else{
//            $query = "update data set {$field}={$value} where ID={$id}";
//        }
//        $rows=QR($query);
//
//
//    }
//
//
//
//
//
//
//
//
//
//}


//$a= new data();
//
//
//$a->addData(49,'pp',date("Y-m-d H:i:s"),1);








?>