<?php
include_once 'functions.php';


class User
{
    

    public function lincense($startDate)
    {
        return date('Y-m-d', strtotime('+5 year', strtotime($startDate)) );
    }

    public function addUser($CID)
    {

           if ($this->isUserAlreadyInDB($CID)){
            return false;
        }else{
           
            $t=date("Y-m-d");
    
            $l=$this->lincense($t);
            $query = "insert into users (CID,license) values  ({$CID},'{$l}')";
        
               
         
            $h=personalSpace($CID,'path');
               echo $h;
            createFTPDIR($h);

            $h=personalSpaceSettings($CID,'path');
            createFTPDIR($h);

            $h=personalSpaceResults($CID,'path');
            createFTPDIR($h);


            $h=personalSpaceData($CID,'path');
            createFTPDIR($h);


            return true;
        }


    }
    
        public function isUserAlreadyInDB($ID)
    {     
//        $query = "select count(*) as A from users where CID={$ID}";
//       
//   
//        $rows=QR($query);
//       
//        if ($rows[0]["A"]=="0"){
//            return false;
//        }else{
//            return true;            
//        }
            
            return false;



    }
    
};

   
//    public function isuseralreadyindb($ID)
//    {     
//        $query = "select count(*) as A from users where CID={$ID}";
//       
//   
//        $rows=QR($query);
//       
//        if ($rows[0]["A"]=="0"){
//            return false;
//        }else{
//            return true;            
//        }
//
//
//
//    }
//    
//    public function verifyUser()
//    { //TODO
//		return true;
//		}
//    
//    
//    public function getUserData($id){
//
//        if($this->verifyUser()){
//            $query = "select distinct m.filename, m.externalfilename, m.ID,IT.typename as filetype, m.dateIN, m.size, m.status from mroptdata as m inner join IT on m.imagetypeID = IT.ID where m.UID={$id}";
//            $r=QR($query);
//            return  $r;
//        }else{
//            return false;       
//        }
//    }
//    
//    public function getUserJobs($id){
//
//        if($this->verifyUser()){
//         
//         $R=new Job();
//         
//         
//           
//         return $R->getJOBDONE('ok',$id);;
//        }else{
//            return false;       
//        }
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
//
//}



?>
