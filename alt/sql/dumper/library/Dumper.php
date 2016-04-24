<?php
/*
	This class is designed to retrieve data from the application database
	so that it can be process e.g. formatted subsequently etc.
*/
class Dumper {

	public function __construct(){
	# Constructor method
		$this->db = new MySQL(); # database object and methods for connecting and accessing database		
	}
	
	//+======================================================+
	public function dump_stuff($intimacy_screename, $intimacy_location, $intimacy_followercount, $intimacy_tweet, $intimacy_img){
		# this method is used to insert file data about a file being uploaded

		$sql = "
			INSERT INTO
						intimacy
						
						(
						intimacy.intimacy_id,
						intimacy.intimacy_screename,
						intimacy.intimacy_location,
						intimacy.intimacy_followercount,
						intimacy.intimacy_tweet,
                        intimacy.intimacy_img
						)
			VALUES
						(
						NULL,
						'".$intimacy_screename."',
						'".$intimacy_location."',
						".$intimacy_followercount.",
						'".$intimacy_tweet."',
                        '".$intimacy_img."'
						);";
			
//		print($sql."\n"); # used for testing purposes only
		$result = $this->db->insert($sql);
		return $result;
	}

	//+======================================================+
	public function get_dumps(){
		# this method is used to query the database to retrieve specific data
		$sql = "
			SELECT
						intimacy.intimacy_id,
						intimacy.intimacy_screename,
						intimacy.intimacy_location,
						intimacy.intimacy_followercount,
						intimacy.intimacy_tweet,
                        intimacy.intimacy_img
			FROM 
						intimacy
			ORDER BY
						intimacy.intimacy_screename ASC;
			";
//		print($sql."\n"); # used for testing purposes only
		$result = $this->db->select($sql);
//		print_r($result);
		return $result;
	}

	//+======================================================+
	public function get_sorted_dumps($screename, $location){
		# this method is used to query the database to retrieve specific data
		$sql = "
			SELECT
						intimacy.intimacy_id,
						intimacy.intimacy_screename,
						intimacy.intimacy_location,
						intimacy.intimacy_followercount,
						intimacy.intimacy_tweet,
                        intimacy.intimacy_img
			FROM 
						intimacy
			WHERE
						intimacy.intimacy_screename = '".$screename."' AND
						intimacy.intimacy_location = '".$location."';
			";
//		print($sql."\n"); # used for testing purposes only
		$result = $this->db->select($sql);
//		print_r($result);
		return $result;
	}
}
?>