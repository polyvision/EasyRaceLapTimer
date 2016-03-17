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
use Linux::IRPulses;
use Time::HiRes 'gettimeofday';


my $MODE2_PATH = '/usr/bin/mode2';
my $DEV = '/dev/lirc0';
my $BUZZER_PIN = 21;
my $BUZZER_ON_SEC = 1;
my $SATELLITE_MODE = 0;
my $WEB_HOST = 'http://localhost';
my $IGNORE_DUP_SEC = 5;
my $USE_OLD_PROTOCOL = 0;
my $HELP = 0;
Getopt::Long::GetOptions(
    'mode2=s' => \$MODE2_PATH,
    'dev=s' => \$DEV,
    'set_buzzer_pin=i' => \$BUZZER_PIN,
    'enable_satellite_mode' => \$SATELLITE_MODE,
    'set_web_host=s' => \$WEB_HOST,
    'ignore_dup_code_sec=i' => \$IGNORE_DUP_SEC,
    'use_old_protocol' => \$USE_OLD_PROTOCOL,
    'help' => \$HELP,
);

if( $HELP ) {
    usage();
    exit(0);
}

my $LAST_TOKEN = '';
my $LOOP;
my $PULSE;
my %SAW_CODE_AT;


sub usage
{
    say "Usage: ";
    say "    --mode2 /path/to/mode2      Path to mode2 program (from LIRC)";
    say "    --dev /dev/lirc0            Path to LIRC /dev entry";
    say "    --set_buzzer_pin 21         Set GPIO pin for buzzer";
    say "    --enable_satellite_mode     This is a satellite gate (NOT IMPLEMENTED)";
    say "    --set_web_host http://...   URL of web server for reporting results (NOT IMPLEMENTED)";
    say "    --ignore_dup_code_sec 5     Ignore duplicate codes sent within this many seconds";
    say "    --use_old_protocol          Use the transmitter protocol for v0.3 or older";
    return;
}

sub handle_incoming_code
{
    my ($io_async, $bufref, $eof) = @_;

    while( $$bufref =~ s/^(.*\n)//x ) {
        my $line = $1;
        chomp $line;
        $PULSE->handle_line( $line );
    }

    return 1;
}

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
        $one_bit_count += 1 if $bit;
        $id_check >>= 1;
    }

    my $is_odd = (($one_bit_count % 2) == 1) ? 1 : 0;
    if( $is_odd != $checksum ) {
        warn "Checksum for value $id_value was supposed to be $is_odd,"
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
        $LAST_TOKEN = $id_value;
        start_buzzer();
    }

    return;
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

    open( my $CODES_IN, '-|', $MODE2_PATH, '-d', $DEV )
        or die "Can't open $MODE2_PATH: $!\n";
    my $codes_stream = IO::Async::Stream->new(
        read_handle => $CODES_IN,
        on_read => \&handle_incoming_code,
    );
    my $stdin_stream = IO::Async::Stream->new(
        read_handle => \*STDIN,
        on_read => \&handle_incoming_command,
    );

    my @header = $USE_OLD_PROTOCOL
        ? ( pulse 300, space 300 )
        : ( pulse 1200, space 1200 );
    $PULSE = Linux::IRPulses->new({
        fh => $CODES_IN,
        header => \@header,
        zero => [ pulse_or_space 300 ],
        one => [ pulse_or_space 600 ],
        bit_count => 7,
        tolerance => 0.40,
        callback => \&code_callback,
    });

    print "> ";

    $LOOP->add( $_ ) for $codes_stream, $stdin_stream;
    $LOOP->run;

    close $CODES_IN;
}


__END__

=head1 ir_daemon.pl

Usage: 

    --mode2 /path/to/mode2      Path to mode2 program (from LIRC)
    --dev /dev/lirc0            Path to LIRC /dev entry
    --set_buzzer_pin 21         Set GPIO pin for buzzer
    --enable_satellite_mode     This is a satellite gate (NOT IMPLEMENTED)
    --set_web_host http://...   URL of web server for reporting results (NOT IMPLEMENTED)
    --ignore_dup_code_sec 5     Ignore duplicate codes sent within this many seconds
    --use_old_protocol          Use the transmitter protocol for v0.3 or older

=cut
