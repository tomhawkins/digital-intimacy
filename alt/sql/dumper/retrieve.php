<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
<?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

// http://localhost/dev/student/thomashawkins/dumper/?screename=tom&location=bournemouth&followers=230&tweet=testing%20sketch
$retrieval = new Retrieval(); # content object and methods

$all_sorted_dumps = $retrieval->get_sorted_dumps(); #
print_r($all_sorted_dumps);

//header("location: http://localhost/dev/student/thomashawkins/dumper/?screename=hannah&location=bournemouth&followers=".$all_sorted_dumps[0]['followercount']."&tweet=testing%20sketch");
//header("location: http://folksonomy.co");
?>
