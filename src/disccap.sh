#!/usr/bin/php
<?php

function getDiskUsage($disk) {
    return shell_exec("df -h $disk");
}

function stripFirstLine($string) {
    $lines = explode(PHP_EOL, $string);
    
    return $lines[1];
}

function prepareDataAsArray($string) {
    $result = array(
        'Size'     => '',
        'Used'     => '',
        'Avail'    => '',
        'Capacity' => '',
        'Mounted'  => ''
    );
    $parts    = explode(" ", $string);
    $position = 0;
    
    foreach ($parts as $index => $partial) {
        if (empty($partial)) {
            continue;
        }
        
        switch ($position) {
            case 1:
                $result['Size'] = $partial;
                break;
            case 2:
                $result['Used'] = $partial;
                break;
            case 3:
                $result['Avail'] = $partial;
                break;
            case 4:
                $result['Capacity'] = $partial;
                break;
            case 5:
                $result['Mounted'] = $partial;
                break;
        }
        
        $position++;
    }
    
    return $result;
}

function padCell($cell) {
    return str_pad($cell, 10, ' ');
}

$disks = array(
    '/',
    '/Volumes/Daten',
    '/Volumes/datengrab'
);
$output = "";

foreach ($disks as $index => $disk) {
    $usage = getDiskUsage($disk);
    $usage = stripFirstLine($usage);
    $usage = prepareDataAsArray($usage);
    
    if (0 === $index) {
        foreach (array_keys($usage) as $header) {
            $output .= padCell($header);
        }
        
        $output .= PHP_EOL;
    } else if (0 < $index) {
        $output .= PHP_EOL;
    }
    
    foreach ($usage as $value) {
        $output .= padCell($value);
    }
}

echo $output;
