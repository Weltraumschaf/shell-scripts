#!/usr/bin/perl

# http://stackoverflow.com/questions/5276253/create-a-silent-mp3-from-the-command-line
$seconds = $ARGV[0];
$file = $ARGV[1];
if ((!$seconds) || ($file eq "")) {
        die "Usage: silence seconds newfilename.wav\n";
}

open(OUT, ">/tmp/$$.dat");
print OUT "; SampleRate 8000\n";
$samples = $seconds * 8000;
for ($i = 0; ($i < $samples); $i++) {
        print OUT $i / 8000, "\t0\n";
}
close(OUT);

# Note: I threw away some arguments, which appear in the original
# script, and which did not worked (on OS X at least)
system("sox /tmp/$$.dat -c 2 -r 44100 -e signed-integer $file");
unlink("/tmp/$$.dat");