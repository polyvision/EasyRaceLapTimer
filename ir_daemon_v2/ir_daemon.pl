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
use Time::HiRes qw{ tv_interval gettimeofday };
use HiPi::Wiring qw( :wiring );


my $MODE2_PATH = '/usr/bin/mode2';
my $DEV = '/dev/lirc0';
my $READ_CODES_PATH = 'read_codes.pl';
my $BUZZER_PIN = 21;
my $BUZZER_ON_SEC = 1;
my $SATELLITE_MODE = 0;
my $WEB_HOST = 'http://localhost';
Getopt::Long::GetOptions(
    'mode2=s' => \$MODE2_PATH,
    'dev=s' => \$DEV,
    'read_codes_path=s' => \$READ_CODES_PATH,
    'set_buzzer_pin=i' => \$BUZZER_PIN,
    'enable_satellite_mode' => \$SATELLITE_MODE,
    'set_web_host=s' => \$WEB_HOST,
);

my $LAST_TOKEN = '';
my $BUZZER_START_TIME = 0;


sub loop
{
    my ($codes_in) = @_;

    my $continue = 1;
    while( $continue ) {
        if( is_data_available( $codes_in ) ) {
            my $line = <$codes_in>;
            chomp $line;
            say $line;
            set_last_token( $line );
            start_buzzer();
        }
        if( is_data_available( \*STDIN ) ) {
            my $line = <>;
            chomp $line;
            do_command( $line );
        }
        if( is_buzzer_time_up() ) {
            stop_buzzer();
        }
    }

    return;
}

sub do_command
{
    my ($cmd) = @_;

    if( $cmd eq 'START_NEW_RACE#' ) {
        $LAST_TOKEN = '';
    }
    elsif( $cmd eq 'RESET#' ) {
        $LAST_TOKEN = '';
    }
    elsif( my ($token, $ms) = $cmd =~ /\A LAP_TIME \s+ (\d+) \s+ (\d+) \# \z/x ) {
        $LAST_TOKEN = $token;
    }
    elsif( $cmd eq 'LAST_SCANNED_TOKEN#' ) {
        say $LAST_TOKEN;
    }

    return;
}

sub is_data_available
{
    my ($fh) = @_;
    # From http://www.perlmonks.org/?node_id=55249
    my $rfd = '';
    vec ($rfd, fileno($fh), 1) = 1;

    if( select ($rfd, undef, undef, 0) >= 0
        && vec($rfd, fileno($fh), 1)
    ) {
        return 1;
    }

    return 0;
}

sub set_last_token
{
    my ($cmd) = @_;
    if( my ($token, $ms) = $cmd =~ /\A LAP_TIME \s+ (\d+) \s+ (\d+) \# \z/x ) {
        $LAST_TOKEN = $token;
    }
    return;
}

sub is_buzzer_time_up
{
    my $elapsed = tv_interval( $BUZZER_START_TIME, [gettimeofday] );
    return ( $elapsed > $BUZZER_ON_SEC ) ? 1 : 0;
}

sub start_buzzer
{
    $BUZZER_START_TIME = [gettimeofday];
    HiPi::Wiring::digitalWrite( $BUZZER_PIN, 1 );
    return;
}

sub stop_buzzer
{
    HiPi::Wiring::digitalWrite( $BUZZER_PIN, 0 );
    return;
}


{
    HiPi::Wiring::wiringPiSetup();
    HiPi::Wiring::pinMode( $BUZZER_PIN, WPI_OUTPUT );

    open( my $CODES_IN, '-|', $READ_CODES_PATH, "--mode2=$MODE2_PATH", "--dev=$DEV" )
        or die "Can't open $READ_CODES_PATH: $!\n";
    loop( $CODES_IN );
    close $CODES_IN;
}
