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
use IO::Async::Loop;
use IO::Async::Stream;
use IO::Async::Timer::Countdown;
use Getopt::Long;
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
my $LOOP;


sub handle_incoming_code
{
    my ($io_async, $bufref, $eof) = @_;

    warn "Got buf: $$bufref\n";
    while( my ($line) = $$bufref =~ s/\A (.*?) \n//x ) {
        chomp $line;
        say $line;
        set_last_token( $line );
        start_buzzer();
    }

    return 1;
}

sub handle_incoming_command
{
    my ($io_async, $bufref, $eof) = @_;
    # TODO

    while( my ($line) = $$bufref =~ s/\A (.*?) \n//x ) {
        chomp $line;
        do_command( $line );
    }

    return 1;
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

    print "> ";
    return;
}

sub set_last_token
{
    my ($cmd) = @_;
    if( my ($token, $ms) = $cmd =~ /\A LAP_TIME \s+ (\d+) \s+ (\d+) \# \z/x ) {
        $LAST_TOKEN = $token;
    }
    return;
}

sub start_buzzer
{
    HiPi::Wiring::digitalWrite( $BUZZER_PIN, 1 );

    my $timer = IO::Async::Timer::Countdown->new(
        delay => $BUZZER_ON_SEC,
        on_expire => \&stop_buzzer,
    );
    $LOOP->add( $timer );

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

    $LOOP = IO::Async::Loop->new;

    open( my $CODES_IN, '-|', 'perl', $READ_CODES_PATH,
        "--mode2=$MODE2_PATH", "--dev=$DEV" )
        or die "Can't open $READ_CODES_PATH: $!\n";
    my $codes_stream = IO::Async::Stream->new(
        read_handle => $CODES_IN,
        on_read => \&handle_incoming_code,
    );
    my $stdin_stream = IO::Async::Stream->new(
        read_handle => \*STDIN,
        on_read => \&handle_incoming_command,
    );

    print "> ";

    $LOOP->add( $_ ) for $codes_stream, $stdin_stream;
    $LOOP->run;

    close $CODES_IN;
}
