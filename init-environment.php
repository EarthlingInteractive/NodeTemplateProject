<?php

// This file
// - Initializes autoloaders
// - Initializes some global functions
// - Creates and returns a new NodeTemplateProjectNS_Registry

require __DIR__.'/vendor/autoload.php';

define('NodeTemplateProjectNS_ROOT_DIR', __DIR__);

/** 'Emit HTML text' */
function eht( $text ) {
	echo htmlspecialchars($text);
}

function coalesce( &$v, $default=null ) {
	return isset( $v ) ? $v : $default;
}

function ezformat( $val, $indent='', $dindent='  ' ) {
	if( is_array($val) ) {
		if( empty($val) ) return 'array()';
		$str = "array(\n";
		foreach( $val as $k=>$v ) {
			$str .= $indent.$dindent.var_export($k,true).' => '.ezformat($v,"$indent$dindent",$dindent).",\n";
		}
		$str .= "$indent)";
		return $str;
	} else {
		return var_export($val,true);
	}
}

function ezecho() {
	if( !headers_sent() ) {
		header("HTTP/1.0 500 EZEchoing");
		header("Content-Type: text/plain");
	}
	foreach( func_get_args() as $v ) {
		echo ezformat($v), "\n";
	}
	foreach( debug_backtrace() as $frame ) {
		if( !isset($frame['file']) and !isset($frame['line']) ) continue;
		echo "------- ezecho at ", coalesce($frame['file']), ":", coalesce($frame['line']), "\n";
		return;
	}
}

function ezdie() {
	if( !headers_sent() ) {
		header("HTTP/1.0 500 EZDied");
		header("Content-Type: text/plain");
	}
	foreach( func_get_args() as $v ) {
		echo ezformat($v), "\n";
	}
	echo "------- stack trace -------\n";
	foreach( debug_backtrace() as $frame ) {
		if( !isset($frame['file']) and !isset($frame['line']) ) continue;
		echo "  from ", coalesce($frame['file']), ":", coalesce($frame['line']), "\n";
	}
	die();
}

function eit_get_request_content() {
	static $read;
	static $value;
	 
	if( !$read ) {
		$value = file_get_contents('php://input');
		$read = true;
	}
	return $value;
}

/**
 * In case other class loaders have failed,
 * try replacing _ with \ and vice-versa.
 * This way a library can use only one style or the other internally.
 */
function eit_autoload_converted( $className ) {
	static $converting;
	
	if( $converting ) return;
	
	$converting = true;
	{
		$bsClassName = str_replace('_', '\\', $className);
		$usClassName = str_replace('\\', '_', $className);
		if( $bsClassName != $className and class_exists($bsClassName, true) ) {
			class_alias($bsClassName, $className);
		} else if( $usClassName != $className and class_exists($usClassName, true) ) {
			class_alias($usClassName, $className);
		}
	}
	$converting = false;
}

spl_autoload_register('eit_autoload_converted');

// Make a global variable for cases where
// we don't control how the output of this script is used,
// e.g. PHPUnit tests.
$NodeTemplateProjectNS_Registry = new NodeTemplateProjectNS_Registry( __DIR__.'/config' );
return $NodeTemplateProjectNS_Registry;
