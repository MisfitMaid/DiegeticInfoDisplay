<?php
/*
 * Copyright (c) 2023 Keira Dueck <sylae@calref.net>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

$font = $argv[1] ?? false;
if (!$font) {
    die("Usage: php generate.php FONT");
}

$glyphmap = json_decode(file_get_contents("$font.json"), true);
$dom = new DOMDocument();
if (!$dom->loadXML(file_get_contents("$font.svg"))) {
    die("error loading $font.svg");
}

$viewbox = explode(" ", $dom->getElementsByTagName("svg")[0]->getAttribute("viewBox"));
$segments = [];

/** @var DOMElement $path */
foreach ($dom->getElementsByTagName("path") as $path) {
    $id = $path->getAttribute("id");
    $d = explode(" ", preg_replace("/\\s+/i", " ", str_replace("-", " -", $path->getAttribute("d"))));

    $segOps = [];
    $segOps[] = [0, 0, 0];

    $d = array_map(function ($v) {
        if (is_numeric($v)) {
            return (float)$v;
        }
        return $v;
    }, $d);

    $x = 0;
    $y = 0;
    $pc = null;
    while ($el = array_shift($d)) {
        switch ($el) {
            case "m":
                $pc = $el;
                $x += array_shift($d);
                $y += array_shift($d);
                $segOps[] = [1, $x, $y];
                break;
            case "M":
                $pc = $el;
                $x = array_shift($d);
                $y = array_shift($d);
                $segOps[] = [1, $x, $y];
                break;
            case "L":
                $pc = $el;
                $x = array_shift($d);
                $y = array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            case "l":
                $pc = $el;
                $x += array_shift($d);
                $y += array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            case "H":
                $pc = $el;
                $x = array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            case "h":
                $pc = $el;
                $x += array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            case "V":
                $pc = $el;
                $y = array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            case "v":
                $pc = $el;
                $y += array_shift($d);
                $segOps[] = [2, $x, $y];
                break;
            default:
                if (is_float($el)) {
                    // probably a repeat of the previous command...
                    switch ($pc) {
                        case "M":
                            array_unshift($d, $el);
                            array_unshift($d, "L");
                            break;
                        case "m":
                            array_unshift($d, $el);
                            array_unshift($d, "l");
                            break;
                        default:
                            array_unshift($d, $el);
                            array_unshift($d, $pc);
                    }
                } else {
                    die ("????? unknown command $el");
                }
        }
    }

    $segOps[] = [3, 0, 0];

    $segOps = array_map(function ($a) use ($viewbox) {
        return [
            $a[0],
            round($a[1] * 100 / $viewbox[2], 2),
            round($a[2] * 200 / $viewbox[3], 2),
        ];
    }, $segOps);
    $segments[$id] = $segOps;
}

$glyphs = [];

foreach ($glyphmap as $k => $v) {
    $glyphOps = [];
    foreach ($v as $seg) {
        if (!array_key_exists(mb_strtolower($seg), $segments)) {
            die ("unknown segment $seg");
        }

        $glyphOps = array_merge($glyphOps, $segments[mb_strtolower($seg)]);
    }
    $glyphs[$k] = $glyphOps;
}

$out = str_replace(
    ["\n            ", ",\n            ", "\n        ],"], // yes, this is stupid
    ["", ", ", "],"],
    json_encode($glyphs, JSON_PRETTY_PRINT));

file_put_contents("../../font.$font.json", $out);