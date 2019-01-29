use Publitio::API;

my $publitio = Publitio::API->new('ktuZkDrpfA3M7t3txAp0', 'RWnZpAdRa8olrNaDjsZp1Q5VbWgznwy8');
my $res = $publitio->call('files/list', 'GET', { limit => 2 });

print "$res->{success}\n";
print "$res->{files_count}\n";
print "$res->{files}[0]->{title}\n";
print "$res->{files}[1]->{title}\n";

