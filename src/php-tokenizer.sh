#!/usr/bin/env php
<?php

class Token {
	private $text;
	private $type;
	private $line;

	public function  __construct($text, $type = null, $line = null) {
		$this->text = (string) $text;
		$this->type = (int) $type;
		$this->line = (int) $line;
	}

	public function text() { return $this->text; }
	public function type() { return $this->type; }
	public function line() { return $this->line; }
	public function name() { return token_name($this->type); }
	public function  __toString() {
		return "<'{$this->text}',{$this->type}>";
	}
}

class Lexer {
	const EOF = null;

	private $input;
	private $tokens;
	private $pos;
	
	public function  __construct($source) {
		$this->input = (string) $source;
	}

	private function isWhite($c) {
		return in_array($c, array(" ", "\n", "\r", "\t"));
	}

	private function tokenizeSource() {
		$this->tokens = array();
		$this->pos    = -1;
		$tokens       = token_get_all($this->input);

		foreach ($tokens as $token) {
			if (!is_array($token)) {
				if ($this->isWhite($token)) {
					continue;
				}
				$this->tokens[] = new Token($token);
			}
			else {
				$this->tokens[] = new Token($token[1], $token[0], $token[2]);
			}
		}
	}

	public function nextToken() {
		if (null === $this->tokens) {
			$this->tokenizeSource();
		}

		$this->pos++;

		if ($this->pos >= count($this->tokens)) {
			return self::EOF;
		}
		else {
			return $this->tokens[$this->pos];
		}
	}
}

//////////////////////////////

$script = basename($argv[0]);
$usage  = "Usage: {$script} file.php" . PHP_EOL . PHP_EOL;

if ($argc !== 2) {
	echo $usage;
	exit(1);
}

$src = $argv[1];

if (!is_readable($src)) {
	echo "{$src} is not readable!" . PHP_EOL;
	echo $usage;
	exit(1);
}

$fileContent = file_get_contents($src);

if (false === $fileContent) {
	echo "Can not read from {$src}!" . PHP_EOL . PHP_EOL;
	exit(1);
}

$lexer = new Lexer($fileContent);

do {
	$token = $lexer->nextToken();
	echo $token . PHP_EOL;
} while ($token !== Lexer::EOF);