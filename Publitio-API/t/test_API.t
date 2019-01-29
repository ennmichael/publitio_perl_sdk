use strict;
use warnings;

use Test::More tests => 102;

BEGIN {
    require_ok('Publitio::API') || BAIL_OUT();
}

for (0..100) {
    my $nonce = Publitio::API->_nonce;
    ok(10_000_000 <= $nonce && $nonce <= 99_999_999, 'nonce is a 9-digit number');
}

