<?php
include_once 'functions.php';

class ROI
{
//    public function updateROI($uid,$field, $v,$s)
//    {
//        if ($s){
//            $query = "update users  set {$field} = '{$v}' where ID={$id}";
//        }else{
//            $query = "update users  set {$field} = {$v} where ID={$id}";
//
//        }
//        $rows=QR($query);
//        return $rows;
//    }

    
    
        public function insertROI($jid,$t,$a,$fn)
    {
            $query="insert into ROIs(JID,Alias,dateModified,filename) values({$jid},'{$a}','{$t}','{$fn}')";
        $rows=QR($query);
    
    }
    
           public function getJobROIs($jid)
    {
            $query="select * from ROIs where jID={$jid}";
    
        $rows=QR($query);
               return $rows;
    
    }
    
    public function deleteROI($id)
    {
            $query="delete from ROIs where ID={$id}";

        $rows=QR($query);
               return $rows;
    
    }
    
    public function getUserROIs($uid)
    {
            $query="select ROIs.ID, ROIs.JID, ROIs.Alias,JOBlist.Alias as jobalias, ROIs.dateModified,ROIs.filename from ROIs inner join JOBlist on ROIs.JID = JOBlist.ID  where JOBlist.UID={$uid}";
    
        $rows=QR($query);
               return $rows;
    
    }
    
    public function getUserROIswithAlias($uid,$a)
    {
            $query="select ROIs.ID, ROIs.JID, ROIs.Alias,ROIs.dateModified,ROIs.filename from ROIs inner join JOBlist on ROIs.JID = JOBlist.ID  where JOBlist.UID={$uid} and ROIs.Alias LIKE '%{$a}%'";
    
        $rows=QR($query);
               return $rows;
    
    }

    
}


?>