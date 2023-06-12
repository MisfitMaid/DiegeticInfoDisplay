<?php

function nvgMoveTo($x, $y) {
	echo "[1, $x, $y],\n";
}
function nvgLineTo($x, $y) {
	echo "[2, $x, $y],\n";
}
function nvgStroke() {
	echo "[3, 0, 0]\n\n";
}
function nvgBeginPath() {
	echo "[0, 0, 0]\n";
}

function nvgBezierTo($a, $b, $c, $d, $e, $f) {
	echo "[4, $a, $b],\n";
	echo "[5, $c, $d],\n";
	echo "[6, $e, $f],\n";
}

nvgBeginPath();
nvgMoveTo(27.037331490232567, 1.083512555382774);
nvgLineTo(108.5439434147207, 1.083512555382774);
nvgStroke();

nvgBeginPath();
nvgMoveTo(96.8381227948055, 90.30971452358185);
nvgLineTo(107.59627978073443, 8.307021836938388);
nvgStroke();

nvgBeginPath();
nvgMoveTo(83.6894221567124, 190.53410507758426);
nvgLineTo(94.44757158358611, 108.5314142807046);
nvgStroke();

nvgBeginPath();
nvgMoveTo(1.0830982057712548, 198.91650014381867);
nvgLineTo(82.58971190663736, 198.91650014381867);
nvgStroke();

nvgBeginPath();
nvgMoveTo(2.182806755058859, 190.53410507758426);
nvgLineTo(12.940956257523126, 108.5314142807046);
nvgStroke();

nvgBeginPath();
nvgMoveTo(15.331510492364618, 90.30971452358185);
nvgLineTo(26.08966029719109, 8.307021836938388);
nvgStroke();
nvgBeginPath();
nvgMoveTo(14.060214602332616, 100.00000377952195);
nvgLineTo(95.56682955044283, 100.00000377952195);
nvgStroke();
nvgBeginPath();
nvgMoveTo(94.83327237584687, 198.91650014381867);
nvgLineTo(95.54875206990013, 192.27462667431513);
nvgStroke();
nvgBeginPath();
nvgMoveTo(106.30690149677383, 110.27193587743547);
nvgLineTo(107.0223849703547, 103.63006618745953);
nvgStroke();
nvgBeginPath();
nvgMoveTo(107.73786466440794, 96.988192717956);
nvgLineTo(108.45334435846118, 90.34632302798005);
nvgStroke();