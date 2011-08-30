#!/usr/bin/env php
<?php

function printUsage($bin) {
	echo "Usage: {$bin} file1.php [file2.php [...]]\n\n";
	echo "This tool scanns the given files for PHP classes and refelcts their public methods.\n\n";
}

function isPhpFile($filename) {
	return substr($filename, strrpos($filename, ".")) === ".php";
}

function findClassNames($file) {
	$tokens = token_get_all(file_get_contents($file));
	$classNames = array($file => array());
	$classKeyWordFound = false;

	foreach ($tokens as $token) {
		if (is_array($token)) {
			$literal = trim($token[1]);
		} else {
			$literal = trim($token);
		}

		if (empty($literal)) {
			continue;
		}

		if ("class" === $literal) {
			$classKeyWordFound = true;
			// next non whitespace tken is the class name
			continue;
		}

		if ($classKeyWordFound) {
			$classNames[$file][] = $literal;
			$classKeyWordFound = false;
		}
	}

	return $classNames;
}

function findPublicMethods($classes) {
	$methods = array();
	
	foreach ($classes as $file => $classnames) {
		require_once $file;
		$methods[$file] = array(); 
		
		foreach ($classnames as $classname) {
			$methods[$file][$classname] = reflectPublicMethods($classname);
		}
	}
	
	return $methods;
}

function reflectPublicMethods($classname) {
	$reflection		= new ReflectionClass(($classname));
	$methods		= $reflection->getMethods(ReflectionMethod::IS_PUBLIC);
	$methodNames	= array();
	
	foreach ($methods as $method) {
		/* @var $method ReflectionMethod */
		$methodNames[] = $method->getName();
	}
	
	return $methodNames;
}

function printOutput(array $methods) {
	foreach ($methods as $file => $classes) {
		$title = "File: {$file}:";
		echo "\n{$title}\n";
		echo str_repeat("-", strlen($title)) . "\n";
		
		foreach ($classes as $classname => $methodnames) {
			foreach ($methodnames as $methodname) {
				echo "{$classname}::{$methodname}()\n";
			}
			
			echo "\n";
		}
	}
}

function main(array $args = array()) {
	if (count($args) < 2) {
		printUsage(basename($args[0]));
		
		return 1;
	}
	
	$files = array_slice($args, 1);
	$classes = array();
	
	foreach ($files as $file) {
		if ( ! isPhpFile($file)) {
			echo "File {$file} is not a PHP file! Skipping.\n";
		}
		
		$classes = array_merge($classes, findClassNames($file));
	}
	
	$methods = findPublicMethods($classes);
	printOutput($methods);

	return 0;
}

exit(main($argv));