<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
    <?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

// http://localhost/dev/student/thomashawkins/dumper/?screename=tom&location=bournemouth&followers=230&tweet=testing%20sketch
$dumper = new Dumper(); # content object and methods
$retrieval = new Retrieval(); # content object and methods

$times = array  ("00:00:00 - 04:00:00"  => array (),
                 "04:00:01 - 08:00:00"  => array (),
                 "08:00:01 - 12:00:00"  => array (),
                 "12:00:01 - 16:00:00"  => array (),
                 "16:00:01 - 20:00:00"  => array (),
                 "20:00:01 - 23:59:59"  => array ()
                );

 $timeresult = $retrieval->get_post_times();
 //print_r($locations);


// for($i=0; $i<count($timeresult); $i++){
//     
//     if($retrieval->check_time("00:00:00", "04:00:00", $timeresult[4])){
//    $result = print "Range 1 ";
//} 
//
//else if($retrieval->check_time("04:00:01", "08:00:00", $timeresult[4])){
//    $result = print "Range 2 ";
//} 
//
//else if($retrieval->check_time("08:00:01", "12:00:00", $timeresult[4])){
//    $result = print "Range 3 ";
//} 
//
//else if($retrieval->check_time("12:00:01", "16:00:00", $timeresult[4])){
//    $result = print "Range 4 ";
//} 
//
//else if($retrieval->check_time("16:00:01", "20:00:00", $timeresult[4])){
//    $result = print "Range 5 ";
//} 
//
//else {
//    $result = print "Range 6 ";
//}
//
// }

print_r(array_values($timeresult));
//$result = $timeresult;

 //         $encoded = json_encode($everything);
 // 		print_r($encoded);
//        var_dump($result);
// 		return $result;

?>