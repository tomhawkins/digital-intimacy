<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
<?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

// http://localhost/dev/student/thomashawkins/dumper/?screename=tom&location=bournemouth&followers=230&tweet=testing%20sketch
$dumper = new Dumper(); # content object and methods
$retrieval = new Retrieval(); # content object and methods

$userTimes = array(
  array("00:00:00 - 04:00:00", 'amityriot'),
  array("04:00:01 - 08:00:00"),
  array("08:00:01 - 12:00:00"),
  array("12:00:01 - 16:00:00"),
  array("16:00:01 - 20:00:00"),
  array("20:00:01 - 23:59:59")
);
// $times = $retrieval->get_post_times();
// //print_r($locations);
//
// for($i=0; $i<count($times); $i++){
// //    print($locations[$i]['intimacy_location']."\n");
//     $screenname = $retrieval->screenname_at_location($times[$i]['intimacy_location']);
// //    print_r($screenname);
//
//     for($ii=0; $ii<count($screenname); $ii++){
//         $everything[$times[$i]['intimacy_location']][$ii] = $screenname[$ii]['intimacy_screename'];
//     }
// }
//
// //         $encoded = json_encode($everything);
// // 		print_r($encoded);
 		return $userTimes;

?>
