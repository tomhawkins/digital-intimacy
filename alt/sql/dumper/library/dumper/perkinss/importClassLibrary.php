<?php
/**
 * dynamically imports object classes for use
 * 
 * @copyright Simon Perkins (http://simonperkins.co.uk)
 * @license MIT License
 */

$dir = "library/"; # directory of object classes

function strips_non_php_files($file_name) {
	# used to strip out non php files
	$suffix = substr(strrchr($file_name,'.'),1); # discovers suffix
	if(strtolower($suffix) == "php"){
		return $file_name; # only returns php files
	}
}

$scanned_directory = array_diff(scandir($dir), array('..', '.','.DS_Store')); # strip unwanted strings
while (list($key, $val) = each($scanned_directory)) {
	# cycles through all files in directory
	if(strips_non_php_files($val) != NULL){
		# requires all php files
		require($dir.$val);
	}
}
?>