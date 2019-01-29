package Publitio::API;

use 5.006;
use strict;
use warnings;

use Digest::SHA qw(sha1_hex);
use LWP::UserAgent;
use URI;
use JSON;
use HTTP::Request::Common qw(POST);

=head1 NAME

Publitio::API - Perl SDK for https.//publit.io.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Read the docs at https://publit.io/docs/.

    use Publitio::API;

    # 'xxx' should be your public key, 'yyy' should be the secret key
    my $publitio_api = Publitio::API->new('ktuZkDrpfA3M7t3txAp0', 'RWnZpAdRa8olrNaDjsZp1Q5VbWgznwy8');
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

    $res = $publitio_api->call('/files/update/Am765xmB', 'PUT', { title => "No more news" });
    print "$res->{message}\n";

    $res = $publitio_api->call('/folders/create', 'POST', { name => 'Stfyx' });
    print "$res->{message}\n";

    $res = $publitio_api->call("/folders/delete/$res->{id}", 'DELETE');
    print "$res->{message}\n";

    $res = $publitio_api->upload_file('/home/johnc/Downloads/News.jpeg', { title => "My other title" });
    print "$res->{message}\n";

    $res = $publitio_api->call("/files/update/$res->{id}", 'PUT', { title => "My new title" });
    print "$res->{message}\n";

=head1 SUBROUTINES/METHODS

new
call
upload_file
upload_watermark

=head2 new

Create new instance of the API. First parameter is the API key, second is
the API secret. You can get those from your dashboard.

=cut

sub new {
    my $class = shift;

    my $key = shift;
    my $secret = shift;

    bless { key => $key, secret => $secret };
}

=head2 call

Make the REST API call. First parameter is the REST path, second is the request
method ('GET', 'POST', 'PUT', 'DELETE' - defaults to 'GET'), third is a hashref of
query parameters. If you need to upload a file or watermark,
use upload_file or upload_watermark.

=cut

sub call {
    my $self = shift;
    my $raw_uri = shift;
    my $method = shift || 'GET';
    my $params = shift;
    my $filename = shift;

    my $ua = LWP::UserAgent->new;
    my $res;

    if ($method eq 'POST MULTIPART') {
        $res = $ua->request($self->_post_multipart_request($raw_uri, $params, $filename));
    } else {
        $res = $ua->request($self->_usual_request($raw_uri, $method, $params));
    }

    die $res->status_line unless $res->is_success;

    JSON->new->decode($res->content);
}

sub _usual_request {
    my $self = shift;
    my $raw_uri = shift;
    my $method = shift;
    my $params = shift;

    HTTP::Request->new($method => $self->_uri($raw_uri, $params));
}

sub _post_multipart_request {
    my $self = shift;
    my $raw_uri = shift;
    my $params = shift;
    my $filename = shift;

    POST($self->_uri($raw_uri, $params),
        Content_Type => 'form-data',
        Content => [file => [$filename]],
    );
}

sub _uri {
    my $self = shift;
    my $raw_uri = shift;
    my $params = shift;

    if (substr($raw_uri, 0, 1) eq '/') {
        $raw_uri = substr($raw_uri, 1, length($raw_uri) - 1);
    }

    my $uri = URI->new("https://api.publit.io/v1/$raw_uri");
    $uri->query_form(%{$params}, $self->_signature($uri));

    print "$uri\n";

    $uri;
}

sub _signature {
    my $self = shift;
    my $uri = shift;

    my $nonce = $self->_nonce;
    my $timestamp = time;
    my $digest = $self->_signature_digest($nonce, $timestamp);

    return (
        api_key => $self->{key},
        api_timestamp => $timestamp,
        api_nonce => $nonce,
        api_signature => $digest,
    );
}

sub _signature_digest {
    my $self = shift;
    my $nonce = shift;
    my $timestamp = shift;

    sha1_hex("$timestamp$nonce$self->{secret}");
}

sub _nonce {
    int(rand(9_999_999)) + 10_000_000;
}

=head2 upload_file

Upload a local file. The first parameter is the filename, second parameter
is a hashref of query parameters.

=cut

sub upload_file {
    my $self = shift;
    my $filename = shift;
    my $params = shift;

    $self->call(
        'files/create',
        'POST MULTIPART',
        $params,
        $filename,
    );
}

sub _read_entire_file {
    my $filehandle = $_[1];
    my $result;
    $result .= $_ while (<$filehandle>);
    $result;
}

=head2 upload_watermark

Upload a watermark. The first parameter is the watermark filename and the second
parameter is a hashref of query parameters.

=cut

sub upload_watermark {
    my $self = shift;
    my $filename = shift;
    my $params = shift;

    $self->call(
        'watermarks/create',
        'POST MULTIPART',
        $params,
        $filename,
    );
}

=head1 AUTHOR

Enn Michael, C<< <enntheprogrammer at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-publitio-api at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Publitio-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Publitio::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Publitio-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Publitio-API>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Publitio-API>

=item * Search CPAN

L<https://metacpan.org/release/Publitio-API>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2019 Enn Michael.

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


=cut

1; # End of Publitio::API
