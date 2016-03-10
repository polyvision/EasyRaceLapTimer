#!perl
# Copyright (c) 2016  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
use v5.14;
use warnings;
use Linux::IRPulses;
use Getopt::Long;
use Time::HiRes 'gettimeofday';


my $MODE2_PATH = '/usr/bin/mode2';
my $DEV = '/dev/lirc0';
my $IGNORE_DUP_SEC = 5;
Getopt::Long::GetOptions(
    'mode2=s' => \$MODE2_PATH,
    'dev=s' => \$DEV,
);

my %SAW_CODE_AT;


open( my $IN, '-|', $MODE2_PATH, '-d', $DEV ) or die "Can't open $MODE2_PATH: $!\n";

sub code_callback
{
    my ($args) = @_;
    my $code = $args->{code};
    my $checksum = $code & 1;
    my $id_value = 0x7F & ($code >> 1);

    my $one_bit_count = 0;
    my $id_check = $id_value;
    while( $id_check > 0 ) {
        my $bit = $id_check & 1;
        $one_bit_count++ if $bit;
        $id_check >>= 1;
    }

    my $is_even = (($one_bit_count % 2) == 0) ? 1 : 0;
    if( $is_even != $checksum ) {
        warn "Checksum for value $id_value was supposed to be $is_even,"
            . " but it's $checksum, ignoring\n";
        return;
    }

    my ($sec, $microsec) = gettimeofday();
    if( exists $SAW_CODE_AT{$id_value}
        && ($SAW_CODE_AT{$id_value} + $IGNORE_DUP_SEC > $sec) ) {
        warn "Ignoring duplicate code value, last seen at $SAW_CODE_AT{$id_value}"
            . " (now $sec, dup time $IGNORE_DUP_SEC)\n";
    }
    else {
        my $msec = do {
            my $msec = sprintf '%.0f', $microsec / 1000;
            ($sec * 1000) + $msec;
        };
        say "LAP_TIME $id_value $msec#";
        $SAW_CODE_AT{$id_value} = $sec;
    }

    return;
}


my $pulse = Linux::IRPulses->new({
    fh => $IN,
    header => [ pulse 300, space 300 ],
    zero => [ pulse_or_space 300 ],
    one => [ pulse_or_space 600 ],
    bit_count => 7,
    tolerance => 0.40,
    callback => \&code_callback,
});
warn "Reading codes . . . \n";
$pulse->run;

close $IN;
