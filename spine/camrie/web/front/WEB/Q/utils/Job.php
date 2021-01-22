<?php
// get database connection
include_once 'functions.php';


class Job
{


    public function addJob($u,$j,$t,$a)
    { //this function add a generic job and gies back it's id
        $query ="INSERT INTO JOBlist(UID, optionJsonFN,status,dateIN,Alias) VALUES ({$u},'{$j}','pending','{$t}','{$a}')"; 
        
        $rows=QR($query);
        $query ="select ID from JOBlist where UID={$u} and dateIN= '{$t}' and optionJsonFN ='{$j}' and Alias='{$a}'"; 
        $rs=QR($query);
        return $rs["0"]["ID"];
    }
    
    
     public function getJOB($id)
    {
        $query ="SELECT j.ID, j.Alias, j.status, j.dateIN from JOBlist as j WHERE j.ID='$id'";
         
        $rs=QR($query);

        return $rs;


    }


    
    public function getAllUserJob($id)
    {
               $query ="SELECT * from JOBlist WHERE UID='$id'";
        
        $rs=QR($query);
     
        return $rs;

    }
    
    
    
        public function backUPbadJOB($id)
    {
        $query ="insert into badJOBlist select * from JOBlist where ID={$id}";
        $rs=QR($query);
        return rs;


    }  





    public function deleteJOB($id)
    {
        $query ="delete from JOBlist where ID={$id}";
        $rs=QR($query);
    }  
    
    
     public function sendFeedback($id,$m,$t){
        $query="INSERT INTO feedback (dateIN,text,JID) VALUES ('{$t}','{$m}',{$id})";

         QR($query);
    }


    
   public function getJOBstate($x,$uid)
   {

       if ($uid!=-1){
           $query ="SELECT * FROM JOBlist as j WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
           $rs=QR($query);
       }else{
           $query ="SELECT * FROM JOBlist as j WHERE j.status='{$x}'";
           $rs=QR($query);
       }
       return $rs;  





   }

//    this function return the stack job for the CU
   public function getSingleJobFromStack()
   {
    //retrieve the stack
    $R=$this->getJOBstate('pending',-1);
    
    $O=$R[0]; 
    
    $tocalc=$O["ID"];
    //set the job status to queue    
    $this->SetJobToCalc(intval($tocalc));

    return $O;




   }

   public function SetJobToCalc($id)
   {

       $query ="update JOBlist set status='calc' where ID={$id}";
       $rs=QR($query);

   }

    
        
//
//    public function addDIJOB($u,$s0,$s1,$t,$j,$al)
//    {
//        $JID=$this->_addJob($u,$j,$t,$al);
//
//        $query ="INSERT INTO dijob(JID,s0ID,s1ID) VALUES ({$JID},{$s0},{$s1})";
//        $rs=QR($query);
//
//        return true;
//
//
//
//
//    }
//    public function addMRJOB($u,$im,$t,$j,$al)
//    {
//
//
//        $JID=$this->_addJob($u,$j,$t,$al);
//
//
//        $query ="INSERT INTO mrjob(JID) VALUES ({$JID})";
//        $rs=QR($query);
//
//
//
//        $aa=json_decode($im,true);
//
//        for($x = 0; $x < count($aa); $x++) {
//
//            $query ="INSERT INTO mrstack(JID,mroptID) VALUES ({$JID},{$aa[$x]['ID']})";
//            $rs=QR($query);
//
//        }
//
//
//
//
//
//        return true;
//
//
//
//
//    }
//
//
//    public function getJOB($id)
//    {
//        $query ="SELECT j.ID, j.Alias, j.status, j.dateIN from JOBlist as j WHERE j.UID='$id'";
//
//        $rs=QR($query);
//
//        return $rs;
//
//
//    }
//
//
//
//
//
//    public function getJOBDONE($s,$id)
//    {   
//        $query ="select j.ID,j.Alias,j.UID,j.optionJsonFN,j.status,j.dateIN,j.dateOUT as dateOUT, a.results FROM JOBlist as j INNER JOIN acmjob as a ON j.ID = a.JID where  j.status='{$s}' and j.UID={$id} UNION select j2.ID,j2.Alias,j2.UID,j2.optionJsonFN,j2.status,j2.dateIN,j2.dateOUT as dateOUT,d.results FROM JOBlist as j2 INNER JOIN dijob as d ON j2.ID = d.JID where j2.status='{$s}' and j2.UID={$id} UNION select j3.ID,j3.Alias,j3.UID,j3.optionJsonFN,j3.status,j3.dateIN,j3.dateOUT as dateOUT, m.results FROM JOBlist as j3 INNER JOIN mrjob as m ON j3.ID = m.JID where j3.status='{$s}' and j3.UID={$id}
//        UNION select j4.ID,j4.Alias,j4.UID,j4.optionJsonFN,j4.status,j4.dateIN,j4.dateOUT as dateOUT, m.results FROM JOBlist as j4 INNER JOIN pmrjob as m ON j4.ID = m.JID where j4.status='{$s}' and j4.UID={$id} order by dateOUT";
//
//
//        $rs=QR($query);
//        
//
//        return $rs;
//    }
//
//
//
//
//
//
//    public function backUPbadJOB($id)
//    {
//        $query ="insert into badJOBlist select * from JOBlist where ID={$id}";
//        $rs=QR($query);
//
//        $query ="delete from JOBlist where ID={$id}";
//        $rs=QR($query);
//
//
//
//    }  
//
//
//
//
//
//    public function deleteJOB($id)
//    {
//        $query ="delete from JOBlist where ID={$id}";
//        $rs=QR($query);
//        $this->deleteACMJOB($id);
//        $this->deleteDIJOB($id);
//        $this->deleteMRJOB($id);
//
//
//    }   
//
//    private function deleteACMJOB($id)
//    {
//        $query ="delete from acmjob where JID={$id}";
//        $rs=QR($query);
//
//    }    
//
//    private function deleteDIJOB($id)
//    {
//        $query ="delete from dijob where JID={$id}";
//        $rs=QR($query);
//
//    }
//
//    private function deleteMRJOB($id)
//    {
//        $query ="delete from mrjob where ID={$id}";
//        $rs=QR($query);
//
//        return $rs;
//    }
//
//
//
//
//
//
//    public function addACMJOB($u,$s,$n,$t,$j,$ac,$al)
//    {
//        $JID=$this->_addJob($u,$j,$t,$al);
//
//        $query ="INSERT INTO acmjob(JID,signalID,noiseID,ACMID) VALUES ({$JID},{$s},{$n},{$ac})";
//        $rs=QR($query);
//
//        return true;
//
//
//
//
//    }
//    
//    
//    
//    
//    
//        public function addPMRJOB($u,$s,$n,$t,$j,$ac,$al)
//    {
//        $JID=$this->_addJob($u,$j,$t,$al);
//
//        $query ="INSERT INTO pmrjob(JID,signalID,noiseID,ACMID) VALUES ({$JID},{$s},{$n},{$ac})";
//        $rs=QR($query);
//          
//        return true;
//
//
//
//
//    }
//    
//    
//    
//
//
//    public function getACMJOBstate($x,$uid)
//    {
//
//        if ($uid!=-1){
//            $query ="SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
//            $rs=QR($query);
//        }else{
//            $query ="SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}'";
//            $rs=QR($query);
//        }
//        return $rs;  
//
//
//
//
//
//    }
//
//
//
//    public function getUserACMJob($uid)
//    {
//
//        $query ="SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN acmjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC" ;
//        $rs=QR($query);
//        return $rs;  
//
//
//
//    }
//
//
//    public function getUserDIJob($uid)
//    {
//
//        $query ="SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN dijob as a on j.ID = a.JID WHERE j.UID={$uid} order by j.dateIN DESC" ;
//        $rs=QR($query);
//        return $rs;  
//
//
//
//    }
//
//    public function getUserMRJob($uid)
//    {
//
//        $query ="SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN mrjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC" ;
//        $rs=QR($query);
//        return $rs;  
//
//
//
//    }
//    
//    
//        public function getUserPMRJob($uid)
//    {
//
//        $query ="SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN pmrjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC" ;
//        $rs=QR($query);
//        return $rs;  
//
//
//
//    }
//    
//
//
//    public function getACMJOBstate2($x,$uid)
//    {
//
//        if ($uid!=-1){
//            $query ="SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
//            $rs=QR($query);
//        }else{
//            $query ="SELECT ss.internalfilename as signalfilename ,ss.imagetypeID as sID, sn.internalfilename as noisefilename , sn.imagetypeID as nID, j.optionJsonFN as optionJsonFN ,j.ID as ID ,a.ACMID, acm.matlab, acm.ACMname, j.UID as UID FROM mroptdata AS ss INNER JOIN acmjob AS a ON ss.ID = a.signalID INNER JOIN mroptdata AS sn ON sn.ID = a.noiseID INNER JOIN JOBlist AS j ON j.ID = a.JID INNER JOIN acm on a.ACMID= acm.ID where j.status ='{$x}' and ss.status='ok' and sn.status='ok' order by j.dateIN DESC limit 1"; 
//            $rs=QR($query);
//
//        }
//        return $rs;  
//
//
//
//
//
//    }
//    
//    
//    
//    
//    
//        public function getPMRJOBstate($x,$uid)
//    {
//
//        if ($uid!=-1){
//            $query ="SELECT * FROM JOBlist as j inner JOIN pmrjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
//            $rs=QR($query);
//        }else{
//            $query ="SELECT ss.internalfilename as signalfilename ,ss.imagetypeID as sID, sn.internalfilename as noisefilename , sn.imagetypeID as nID, j.optionJsonFN as optionJsonFN ,j.ID as ID ,a.ACMID, acm.matlab, acm.ACMname, j.UID as UID FROM mroptdata AS ss INNER JOIN pmrjob AS a ON ss.ID = a.signalID INNER JOIN mroptdata AS sn ON sn.ID = a.noiseID INNER JOIN JOBlist AS j ON j.ID = a.JID INNER JOIN acm on a.ACMID= acm.ID where j.status ='{$x}' and ss.status='ok' and sn.status='ok' order by j.dateIN DESC limit 1"; 
//            $rs=QR($query);
//
//        }
//        return $rs;  
//
//
//
//
//
//    }
//    
//    
//    
//
//
//    public function getDIJOBstate($x,$uid)
//    {
//
//        if ($uid!=-1){
//            $query ="SELECT * FROM JOBlist as j inner JOIN dijob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
//            $rs=QR($query);
//        }else{
//            $query ="SELECT ss.internalfilename as im0,ss.imagetypeID as im0ID, sn.internalfilename as im1, 
//sn.imagetypeID as im1ID, j.optionJsonFN as optionJsonFN,j.ID as ID,j.UID as UID FROM mroptdata AS ss INNER JOIN dijob AS d ON ss.ID = d.s0ID INNER JOIN mroptdata AS sn ON sn.ID = d.s1ID INNER JOIN JOBlist AS j ON j.ID = d.JID  where j.status ='{$x}' and ss.status='ok' and sn.status='ok' order by j.dateIN DESC limit 1"; 
//            $rs=QR($query);
//
//        }
//
//
//        return $rs;  
//
//
//
//
//
//    }
//
//
//
//
//    public function getMRJOBstate($x,$uid)
//    {
//
//
//        if ($uid!=-1){
//            $query ="SELECT * FROM JOBlist as j inner JOIN mrjob as m on j.ID = m.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
//            $rs=QR($query);
//        }else{
//
//            $query="SELECT j.ID as ID FROM JOBlist as j inner join mrjob as mr on j.ID = mr.JID  where j.status ='pending' order by j.dateIN DESC limit 1";
//            $rs=QR($query);
//
//            $jid=$rs[0]['ID'];
//            $query ="SELECT j.UID as UID, j.ID as ID,m.status, m.internalfilename as im,m.imagetypeID as imID 
//FROM mroptdata AS m INNER JOIN mrstack AS mr ON mr.mroptID = m.ID INNER JOIN JOBlist as j on j.ID = mr.JID  where j.ID ={$jid}"; 
//            $rs=QR($query);
//
//        }
//
//
//        //        test if everything had already been converted
//
//        $crs=$rs;
//        for($x = 0; $x < count($crs); $x++) {
//
//            if($rs[$x]['status']=='ko'){
//                $rs=[];
//
//            }
//        }
//
//
//        return $rs;  
//
//
//
//
//
//    }
//
//
//
//
//
//    public function getPendingDIJob()
//    {
//
//
//        $query ="SELECT * FROM JOBlist as j inner JOIN dijob as d  on j.ID = d.JID WHERE j.status='pending'";
//        $rs=QR($query);
//
//        return $rs;
//
//
//
//
//    }
//
//
//    public function _updateJob($x,$id,$t,$FS)
//    {
//
//
//        $query ="update JOBlist set status='{$x}',dateOUT='{$t}',size={$FS} where ID={$id}";
//        $rs=QR($query);
//
//    }
//
//
//    public function updateACMJob($x,$id,$j,$t,$FS)
//    {
//
//        $this->_updateJob($x,$id,$t,$FS);
//        $query ="update acmjob set results='{$j}' where JID={$id}";
//        $rs=QR($query);
//
//    }
//    
//    
//        public function updatePMRJob($x,$id,$j,$t,$FS)
//    {
//
//        $this->_updateJob($x,$id,$t,$FS);
//        $query ="update pmrjob set results='{$j}' where JID={$id}";
//        $rs=QR($query);
//
//    }
//
//    public function updateDIJob($x,$id,$j,$t,$FS)
//    {
//
//        $this->_updateJob($x,$id,$t,$FS);
//        $query ="update dijob set results='{$j}' where JID={$id}";
//        echo $query;
//        $rs=QR($query);
//
//    }
//
//
//    public function updateMRJob($x,$id,$j,$t,$FS)
//    {
//
//        $this->_updateJob($x,$id,$t,$FS);
//        $query ="update mrjob set results='{$j}' where JID={$id}";
//        $rs=QR($query);
//
//    }
//
//
//
//    public function SetJobToCalc($id)
//    {
//
//        $query ="update JOBlist set status='calc' where ID={$id}";
//        $rs=QR($query);
//
//
//    }
//
//
//
//
//
//    public function getAllUserJob($id)
//    {
//               $query ="select j.ID,j.Alias,j.UID,j.optionJsonFN,j.status,j.dateIN,j.dateOUT as dateOUT, a.results FROM JOBlist as j INNER JOIN acmjob as a ON j.ID = a.JID where j.UID={$id} UNION select j2.ID,j2.Alias,j2.UID,j2.optionJsonFN,j2.status,j2.dateIN,j2.dateOUT as dateOUT,d.results FROM JOBlist as j2 INNER JOIN dijob as d ON j2.ID = d.JID where j2.UID={$id} UNION select j3.ID,j3.Alias,j3.UID,j3.optionJsonFN,j3.status,j3.dateIN,j3.dateOUT as dateOUT, m.results FROM JOBlist as j3 INNER JOIN mrjob as m ON j3.ID = m.JID where j3.UID={$id} UNION select j4.ID,j4.Alias,j4.UID,j4.optionJsonFN,j4.status,j4.dateIN,j4.dateOUT as dateOUT, m.results FROM JOBlist as j4 INNER JOIN pmrjob as m ON j4.ID = m.JID where j4.UID={$id} order by dateOUT";
//        $rs=QR($query);
//     
//        return $rs;
//
//    }
//
//
//
//    public function insertJobLOG($id,$w)
//    {
//      
//        $query ="update JOBlist set log='{$w}' where ID={$id}";
//        $rs=QR($query);
//
//    }






}
















?>