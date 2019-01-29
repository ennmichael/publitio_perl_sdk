use Publitio::API;

my $publitio = Publitio::API->new('ktuZkDrpfA3M7t3txAp0', 'RWnZpAdRa8olrNaDjsZp1Q5VbWgznwy8');
my $news = '/home/johnc/Downloads/News.jpeg';
my $res = $publitio->upload_file($news, { title => "Obscenity in the milk of thy fathers" });

print "$res->{success}\n";
print "$res->{message}\n";
print "$res->{title}";

