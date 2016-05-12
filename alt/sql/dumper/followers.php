<?php session_start(); # this is only necessary when the script requires a user to authenticate ?>
    <?php
#START----------------- initialises general global methods ------------------
require("perkinss/importClassLibrary.php");
#END------------------- initialises general global methods ------------------

$dumper = new Dumper(); # content object and methods
$retrieval = new Retrieval(); # content object and methods

$follower_range = $retrieval->get_user_followers($_GET['start'], $_GET['end']);

         $encoded = json_encode($follower_range);
 		print_r($encoded);
       var_dump($encoded);
		return $encoded;
?>
