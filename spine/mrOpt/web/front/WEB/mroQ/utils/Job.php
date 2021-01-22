<?php
// get database connection
include_once 'functions.php';


class Job
{
    private function _addJob($u, $j, $t, $a)
    { //this function add a generic job and gies back it's id
        $query = "INSERT INTO JOBlist(UID, optionJsonFN,status,dateIN,Alias) VALUES ({$u},'{$j}','pending','{$t}','{$a}')";


        $rows = QR($query);

        $query = "select ID from JOBlist where UID={$u} and dateIN= '{$t}' and optionJsonFN ='{$j}' and Alias='{$a}'";

        $rs = QR($query);

        return $rs["0"]["ID"];
        //        




    }

    public function sendFeedback($id, $m, $t)
    {
        $query = "INSERT INTO feedback (dateIN,text,JID) VALUES ('{$t}','{$m}',{$id})";
        //  echo $query; 
        QR($query);
    }

    public function addDIJOB($u, $t, $j, $al)
    {
        $JID = $this->_addJob($u, $j, $t, $al);

        $query = "INSERT INTO dijob(JID) VALUES ({$JID})";
        $rs = QR($query);

        return $JID;
    }

    public function addMRJOB($u, $im, $t, $j, $al)
    {
        $JID = $this->_addJob($u, $j, $t, $al);

        $query = "INSERT INTO mrjob(JID) VALUES ({$JID})";
        $rs = QR($query);

        return $JID;
    }


    public function getJOB($id)
    {
        $query = "SELECT j.ID, j.Alias, j.status, j.dateIN from JOBlist as j WHERE j.UID='$id'";

        $rs = QR($query);

        return $rs;
    }

    public function getJobInfo($jid)
    {
        $query = "SELECT j.ID, j.Alias, j.UID, j.status, j.dateIN from JOBlist as j WHERE j.ID=$jid";
        $rs = QR($query);
        return $rs;
    }

    public function getJOBDONE($s, $id)
    {
        $query = "select j.size as size, j.ID,j.Alias,j.UID,j.optionJsonFN,j.status,j.dateIN,j.dateOUT as dateOUT, a.results FROM JOBlist as j INNER JOIN acmjob as a ON j.ID = a.JID where  j.status='{$s}' and j.UID={$id} UNION select  j2.size as size, j2.ID,j2.Alias,j2.UID,j2.optionJsonFN,j2.status,j2.dateIN,j2.dateOUT as dateOUT,d.results FROM JOBlist as j2 INNER JOIN dijob as d ON j2.ID = d.JID where j2.status='{$s}' and j2.UID={$id} UNION select j3.size as size,j3.ID,j3.Alias,j3.UID,j3.optionJsonFN,j3.status,j3.dateIN,j3.dateOUT as dateOUT, m.results FROM JOBlist as j3 INNER JOIN mrjob as m ON j3.ID = m.JID where j3.status='{$s}' and j3.UID={$id}
        UNION select j4.size as size, j4.ID,j4.Alias,j4.UID,j4.optionJsonFN,j4.status,j4.dateIN,j4.dateOUT as dateOUT, m.results FROM JOBlist as j4 INNER JOIN pmrjob as m ON j4.ID = m.JID where j4.status='{$s}' and j4.UID={$id} order by dateOUT";


        $rs = QR($query);


        return $rs;
    }






    public function backUPbadJOB($id)
    {
        $query = "insert into badJOBlist select * from JOBlist where ID={$id}";
        $rs = QR($query);

        $query = "delete from JOBlist where ID={$id}";
        $rs = QR($query);
    }





    public function deleteJOB($id)
    {
        $query = "delete from JOBlist where ID={$id}";
        $rs = QR($query);
        $this->deleteACMJOB($id);
        $this->deleteDIJOB($id);
        $this->deleteMRJOB($id);
    }

    private function deleteACMJOB($id)
    {
        $query = "delete from acmjob where JID={$id}";
        $rs = QR($query);
    }

    private function deleteDIJOB($id)
    {
        $query = "delete from dijob where JID={$id}";
        $rs = QR($query);
    }

    private function deleteMRJOB($id)
    {
        $query = "delete from mrjob where ID={$id}";
        $rs = QR($query);

        return $rs;
    }






    public function addACMJOB($u, $t, $j, $ac, $al)
    {
        $JID = $this->_addJob($u, $j, $t, $al);

        $query = "INSERT INTO acmjob(JID) VALUES ({$JID})";
        $rs = QR($query);

        return $JID;
    }





    public function addPMRJOB($u, $t, $j, $ac, $al)
    {
        $JID = $this->_addJob($u, $j, $t, $al);

        $query = "INSERT INTO pmrjob(JID) VALUES ({$JID})";
        $rs = QR($query);

        return $JID;
    }





    // public function getACMJOBstate($x,$uid)
    // {

    //     if ($uid!=-1){
    //         $query ="SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC" ;
    //         $rs=QR($query);
    //     }else{
    //         $query ="SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}'";
    //         $rs=QR($query);
    //     }
    //     return $rs;  





    // }



    public function getUserACMJob($uid)
    {

        $query = "SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN acmjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC";
        $rs = QR($query);
        return $rs;
    }


    public function getUserDIJob($uid)
    {

        $query = "SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN dijob as a on j.ID = a.JID WHERE j.UID={$uid} order by j.dateIN DESC";
        $rs = QR($query);
        return $rs;
    }

    public function getUserMRJob($uid)
    {

        $query = "SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN mrjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC";
        $rs = QR($query);
        return $rs;
    }


    public function getUserPMRJob($uid)
    {

        $query = "SELECT j.ID,j.Alias,j.status,j.dateIN,j.dateOut,j.size, a.results FROM JOBlist as j inner JOIN pmrjob as a on j.ID = a.JID WHERE j.UID=$uid order by j.dateIN DESC";
        $rs = QR($query);
        return $rs;
    }



    public function getACMJOBstate($x, $uid)
    {

        if ($uid != -1) {
            $query = "SELECT * FROM JOBlist as j inner JOIN acmjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC";
            $rs = QR($query);
        } else {
            $query = "select j.optionJsonFN as optionJsonFN,j.ID as ID,j.UID as UID FROM JOBlist AS j INNER JOIN acmjob AS d ON j.ID = d.JID  where j.status ='{$x}' order by j.dateIN DESC limit 1";

            $rs = QR($query);
        }
        return $rs;
    }





    public function getPMRJOBstate($x, $uid)
    {

        if ($uid != -1) {
            $query = "SELECT * FROM JOBlist as j inner JOIN pmrjob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC";
            $rs = QR($query);
        } else {
            $query = "select j.optionJsonFN as optionJsonFN,j.ID as ID,j.UID as UID FROM JOBlist AS j INNER JOIN pmrjob AS d ON j.ID = d.JID  where j.status ='{$x}' order by j.dateIN DESC limit 1";
            $rs = QR($query);
        }
        return $rs;
    }






    public function getDIJOBstate($x, $uid)
    {

        if ($uid != -1) {
            $query = "SELECT * FROM JOBlist as j inner JOIN dijob as a  on j.ID = a.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC";
            $rs = QR($query);
        } else {
            $query = "select j.optionJsonFN as optionJsonFN,j.ID as ID,j.UID as UID FROM JOBlist AS j INNER JOIN dijob AS d ON j.ID = d.JID  where j.status ='{$x}' order by j.dateIN DESC limit 1";
            $rs = QR($query);
        }


        return $rs;
    }




    public function getMRJOBstate($x, $uid)
    {


        if ($uid != -1) {
            $query = "SELECT * FROM JOBlist as j inner JOIN mrjob as m on j.ID = m.JID WHERE j.status='{$x}' and j.UID=$uid order by j.dateIN DESC";
            $rs = QR($query);
        } else {

            $query = "select j.optionJsonFN as optionJsonFN,j.ID as ID,j.UID as UID FROM JOBlist AS j INNER JOIN mrjob AS d ON j.ID = d.JID  where j.status ='{$x}' order by j.dateIN DESC limit 1";
            $rs = QR($query);
        }


        return $rs;
    }





    public function getPendingDIJob()
    {


        $query = "SELECT * FROM JOBlist as j inner JOIN dijob as d  on j.ID = d.JID WHERE j.status='pending'";
        $rs = QR($query);

        return $rs;
    }


    public function _updateJob($x, $id, $t, $FS)
    {


        $query = "update JOBlist set status='{$x}',dateOUT='{$t}',size={$FS} where ID={$id}";
        $rs = QR($query);
    }


    public function updateACMJob($x, $id, $j, $t, $FS)
    {

        $this->_updateJob($x, $id, $t, $FS);
        $query = "update acmjob set results='{$j}' where JID={$id}";
        $rs = QR($query);
    }


    public function updatePMRJob($x, $id, $j, $t, $FS)
    {

        $this->_updateJob($x, $id, $t, $FS);
        $query = "update pmrjob set results='{$j}' where JID={$id}";
        $rs = QR($query);
    }

    public function updateDIJob($x, $id, $j, $t, $FS)
    {

        $this->_updateJob($x, $id, $t, $FS);
        $query = "update dijob set results='{$j}' where JID={$id}";
        echo $query;
        $rs = QR($query);
    }


    public function updateMRJob($x, $id, $j, $t, $FS)
    {

        $this->_updateJob($x, $id, $t, $FS);
        $query = "update mrjob set results='{$j}' where JID={$id}";
        $rs = QR($query);
    }



    public function SetJobToCalc($id)
    {

        $query = "update JOBlist set status='calc' where ID={$id}";
        $rs = QR($query);
    }





    public function getAllUserJob($id)
    {
        $query = "select j.size,j.ID,j.Alias,j.UID,j.optionJsonFN,j.status,j.dateIN,j.dateOUT as dateOUT, a.results FROM JOBlist as j INNER JOIN acmjob as a ON j.ID = a.JID where j.UID={$id} UNION select j2.size,j2.ID,j2.Alias,j2.UID,j2.optionJsonFN,j2.status,j2.dateIN,j2.dateOUT as dateOUT,d.results FROM JOBlist as j2 INNER JOIN dijob as d ON j2.ID = d.JID where j2.UID={$id} UNION select j3.size,j3.ID,j3.Alias,j3.UID,j3.optionJsonFN,j3.status,j3.dateIN,j3.dateOUT as dateOUT, m.results FROM JOBlist as j3 INNER JOIN mrjob as m ON j3.ID = m.JID where j3.UID={$id} UNION select j4.size,j4.ID,j4.Alias,j4.UID,j4.optionJsonFN,j4.status,j4.dateIN,j4.dateOUT as dateOUT, m.results FROM JOBlist as j4 INNER JOIN pmrjob as m ON j4.ID = m.JID where j4.UID={$id} order by dateOUT";

        $rs = QR($query);

        return $rs;
    }



    public function insertJobLOG($id, $w)
    {

        $query = "update JOBlist set log='{$w}' where ID={$id}";
        $rs = QR($query);
    }
}
















//    $t=date("Y-m-d H:i:s");
//
//$a = new Job();
//
//$a->addDIJOB(49,37,36,1,$t,'qui');
//
