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
