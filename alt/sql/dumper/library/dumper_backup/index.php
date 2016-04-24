<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
<?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

// http://localhost/dev/student/thomashawkins/dumper/?screename=tom&location=bournemouth&followers=230&tweet=testing%20sketch
$dumper = new Dumper(); # content object and methods

if(@$_GET['screename'] != ''){
$dumper->dump_stuff($_GET['screename'], $_GET['location'], $_GET['followers'], $_GET['tweet'], $_GET['img']); #
}

$all_dumps = $dumper->get_dumps(); #
//print_r($all_dumps);


$all_sorted_dumps = $dumper->get_sorted_dumps($_GET['screename'], $_GET['location']); #
//print_r($all_sorted_dumps);
//header("location: http://localhost/dev/student/thomashawkins/dumper/?screename=hannah&location=bournemouth&followers=".$all_sorted_dumps[0]['followercount']."&tweet=testing%20sketch");
//header("location: http://folksonomy.co");
?>
