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
        GROUP BY intimacy_location


			";
		//print($sql."\n"); # used for testing purposes only
		$result = $this->db->select($sql);

        //return $result;

        $objTmp = (object) array('aFlat' => array());
array_walk_recursive($result, create_function('&$v, $k, &$t', '$t->aFlat[] = $v;'), $objTmp);

//return($objTmp->aFlat);
//
//        $array = json_decode(json_encode($objTmp), True);
//        $locationlist = "'".implode("', '", $objTmp->aFlat)."'"; //makes format 'hi', 'there', 'everybody'
//
//        return $locationlist;
//
//        $list = "
//
//        SELECT
//                        intimacy_screename
//        FROM
//                        intimacy
//        WHERE
//                        intimacy_location
//        IN
//                        ($locationlist);
//        ";
//
//        $userloc = $this->db->select($list);
//
//JSON encode for processing parser
        $encoded = json_encode($result);
		print_r($encoded);
		return $result;
	}


	public function get_locations(){

		# this method is used to query the database to retrieve specific data
		$sql = "

        SELECT DISTINCT intimacy_location

        FROM intimacy
        GROUP BY intimacy_location;";

     $result = $this->db->select($sql);
        return $result;
    }


    public function screenname_at_location($location){

		# this method is used to query the database to retrieve specific data
		$sql = "

        SELECT
                intimacy_screename
        FROM
                intimacy
        WHERE
                intimacy_location = '".$location."';";
 //   print($sql);
     $result = $this->db->select($sql);
        return $result;
    }

    public function get_post_times($start, $end){

		# this method is used to query the database to retrieve specific data
		$sql = "

        SELECT
                *
        FROM
                intimacy
        WHERE
                intimacy_time >= '".$start."' AND
                intimacy_time <= '".$end."'
        ORDER BY
                intimacy_time ASC;
                ";
 //   print($sql);
     $result = $this->db->select($sql);
        return $result;
    }
    
    public function get_user_followers($start, $end){

		# this method is used to query the database to retrieve specific data
		$sql = "

        SELECT
                *
        FROM
                intimacy
        WHERE
                intimacy_followercount >= '".$start."' AND
                intimacy_followercount <= '".$end."'
        ORDER BY
                intimacy_followercount ASC;
                ";
 //   print($sql);
     $result = $this->db->select($sql);
        return $result;
    }

    public function check_time($start_date, $end_date, $todays_date)
{

  $start_timestamp = strtotime($start_date);
  $end_timestamp = strtotime($end_date);
  $today_timestamp = strtotime($todays_date);

  return (($today_timestamp >= $start_timestamp) && ($today_timestamp <= $end_timestamp));

}

}
?>
