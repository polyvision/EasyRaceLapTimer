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
Getopt::Long::GetOptions(
    'mode2=s' => \$MODE2_PATH,
    'dev=s' => \$DEV,
);


open( my $IN, '-|', $MODE2_PATH, '-d ' . $DEV ) or die "Can't open $MODE2_PATH: $!\n";

sub code_callback
{
    my ($args) = @_;
    my $code = $args->{code};
    my $checksum = $code & 1;
    my $id_value = $code >> 1;

    my $one_bit_count = 0;
    my $id_check = $id_value;
    while( $id_check > 0 ) {
        my $bit = $id_check & 1;
        $one_bit_count++ if $bit;
        $id_check >>= 1;
    }

    if( $one_bit_count != $checksum ) {
        warn "Checksum for value $id_value was supposed to be $one_bit_count,"
            . " but it's $checksum, ignoring\n";
        return;
    }

    my $msec = do {
        my ($sec, $microsec) = gettimeofday();
        my $msec = sprintf '%.0f', $microsec / 1000;
        $sec *= 1000;
        $sec + $msec;
    };
    say "LAP_TIME $id_value $msec#";

    return;
}


my $pulse = Linux::IRPulses->new({
    fh => $IN,
    header => [ pulse 300, space 300 ],
    zero => [ pulse_or_space 300 ],
    one => [ pulse_or_space 600 ],
    bit_count => 7,
    callback => \&code_callback,
});
$pulse->run;

close $IN;
