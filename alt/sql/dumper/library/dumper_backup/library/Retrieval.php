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
	public function get_sorted_dumps($location){
		# this method is used to query the database to retrieve specific data
		$sql = "
			SELECT
						*
			FROM 
						intimacy
			WHERE
						intimacy_location='".$location."'
			";
//		print($sql."\n"); # used for testing purposes only
		$result = $this->db->select($sql);
        $encoded = json_encode($result);
		print_r($encoded);
		return $encoded;
	}
}
?>