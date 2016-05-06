<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
<?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

// http://localhost/dev/student/thomashawkins/dumper/?screename=tom&location=bournemouth&followers=230&tweet=testing%20sketch
$dumper = new Dumper(); # content object and methods
$retrieval = new Retrieval(); # content object and methods

 $everything = array();
 $locations = $retrieval->get_locations();
 //print_r($locations);

 for($i=0; $i<count($locations); $i++){
 //    print($locations[$i]['intimacy_location']."\n");
     $screenname = $retrieval->screenname_at_location($locations[$i]['intimacy_location']);
 //    print_r($screenname);

     for($ii=0; $ii<count($screenname); $ii++){
         $everything[$locations[$i]['intimacy_location']][$ii] = $screenname[$ii]['intimacy_screename'];
     }
 }

//      $encoded = json_encode($everything);
//// 		print_r($encoded);
//// 		return $encoded;
        print_r($everything);
        return $everything;

?>
