<?php
/*
	This class is designed to retrieve data from the application database
	so that it can be process e.g. formatted subsequently etc.
*/
class Retrieval {

	public function __construct(){
	# Constructor method
		$this->db = new MySQL(); # database object and methods for connecting and accessing database		
	}
	
	//+======================================================+
    

    
	public function get_sorted_dumps(){
        
		# this method is used to query the database to retrieve specific data
		$sql = "
        
        SELECT DISTINCT intimacy_location 
        
        FROM intimacy
        
			";
//		print($sql."\n"); # used for testing purposes only
		$result = $this->db->select($sql);
        
        $objTmp = (object) array('aFlat' => array());
array_walk_recursive($result, create_function('&$v, $k, &$t', '$t->aFlat[] = $v;'), $objTmp);

//return($objTmp->aFlat);
        
        //$array = json_decode(json_encode($objTmp), True);
        $locationlist = "'".implode("', '", $objTmp->aFlat)."'"; //makes format 'hi', 'there', 'everybody'

        //return $locationlist;
        
        $list = "

        SELECT 
                        intimacy_screename 
        FROM 
                        intimacy 
        WHERE 
                        intimacy_location
        IN 
                        ($locationlist);
        ";
            
        $userloc = $this->db->select($list);
        
//JSON encode for processing parser
//        $encoded = json_encode($userloc);
//		print_r($encoded);
		return $userloc;
	}
}
?>