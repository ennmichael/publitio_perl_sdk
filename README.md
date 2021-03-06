# Publitio-API

## INSTALLATION

To install this module:

    git clone https://github.com/ennmichael/publitio_perl_sdk
    cd publitio_perl_sdk/Publitio-API
    perl Makefile.PL
    make
    make install

You'll probably also have run the following before usage:

    cpan JSON # Install the JSON module
    cpan LWP # Install the LWP module

If running `make install` fails for you, try using `sudo`.

## EXAMPLE USAGE

    use Publitio::API;

    # 'xxx' should be your public key, 'yyy' should be the secret key
    my $publitio_api = Publitio::API->new('xxx', 'yyy');
    my $res = $publitio_api->call('/files/show/Am765xmB');

    print "$res->{title}\n";
    print "$res->{message}\n";

    # Passing query parameters to the API:
    $res = $publitio_api->call('/files/list', 'GET', { limit => 10 });

    print "$res->{limit}\n";
    print "$res->{files_total}\n";
    print "$res->{message}\n";

    # Uploading files or watermarks:
    $res = $publitio_api->upload_file('/home/johnc/Downloads/News.jpeg', { title => "My file title" });
    print "$res->{message}\n";
    $publitio_api->upload_watermark('/home/johnc/Downloads/News.jpeg', { name => "watmrk" });
    print "$res->{message}\n";

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Publitio::API

## LICENSE AND COPYRIGHT

Copyright (C) 2019 Enn Michael

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

