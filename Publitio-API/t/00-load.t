#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Publitio::API' ) || print "Bail out!\n";
}

diag( "Testing Publitio::API $Publitio::API::VERSION, Perl $], $^X" );
