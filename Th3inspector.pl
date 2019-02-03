#!/usr/bin/perl

use if $^O eq "MSWin32", Win32::Console::ANSI;
use Data::Dumper;
use Getopt::Long;
use HTTP::Headers;
use HTTP::Request::Common qw( GET POST );
use HTTP::Request;
use HTTP::Response;
use IO::Select;
use IO::Socket::INET;
use IO::Socket;
use JSON qw( decode_json encode_json );
use LWP::Simple;
use LWP::UserAgent;
use Term::ANSIColor;
use URI::URL;

my $ua = LWP::UserAgent->new;
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

GetOptions(
    "h|help"          => \$help,
    "i|info=s"        => \$site1,
    "n|number=s"      => \$PhoneNumber,
    "mx|mailserver=s" => \$site2,
    "w|whois=s"       => \$site3,
    "l|location=s"    => \$site4,
    "c|cloudflare=s"  => \$site5,
    "a|age=s"         => \$site6,
    "ua|useragent=s"  => \$useragent,
    "p|port=s"        => \$target,
    "b|bin=s"         => \$bin,
    "s|subdomain=s"   => \$site8,
    "e|email=s"       => \$email,
    "cms|cms=s"       => \$site7,
);

if ($help)        { banner();help(); }
if ($site1)       { banner();Websiteinformation(); }
if ($PhoneNumber) { banner();Phonenumberinformation(); }
if ($site2)       { banner();FindIPaddressandemailserver(); }
if ($site3)       { banner();Domainwhoislookup(); }
if ($site4)       { banner();Findwebsitelocation(); }
if ($site5)       { banner();CloudFlare(); }
if ($site6)       { banner();DomainAgeChecker(); }
if ($useragent)   { banner();UserAgent(); }
if ($bin)         { banner();BIN(); }
if ($site8)       { banner();subdomain(); }
if ($email)       { banner();email(); }
if ($site7)       { banner();cms(); }
if ($target)      { banner();port(); }
unless ($help|$site1|$PhoneNumber|$site2|$site3|$site4|$site5|$site6|$useragent|$bin|$email|$site7|$site8|$target) { banner();menu(); }

##### Help #######
sub help {
    print item('1'),"Website Information ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -i example.com\n";
    print item('2'),"Phone Number Information ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -n xxxxxxx\n";
    print item('3'),"Find IP Address And E-mail Server ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -mx example.com\n";
    print item('4'),"Domain Whois Lookup ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -w example.com\n";
    print item('5'),"Find Website/IP Address Location ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -l example.com\n";
    print item('6'),"Bypass CloudFlare ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -c example.com\n";
    print item('7'),"Domain Age Checker ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -a example.com\n";
    print item('8'),"User Agent Info ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -ua Mozilla/5.0 xxxxxxxxxxxxxxxxxxxx\n";
    print item('9'),"Check Active Services On Resource";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -p 127.0.0.1\n";
    print item('10'),"Credit Card Bin Checker ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -b 123456\n";
    print item('11'),"Subdomain Scanner ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -s example.com\n";
    print item('12'),"E-mail Address Checker ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -e example@gmail.com\n";
    print item('13'),"Content Management System Checker ";
    print color('bold red'),"=> ";
    print color("bold white"),"perl Th3inspector.pl -cms example.com\n";
}

##### Banner #######
sub banner {
    if ($^O =~ /MSWin32/) {system("mode con: cols=100 lines=29");system("cls"); }else { system("resize -s 28 87");system("clear"); }
    print "         ,;;;,     \n";
    print "        ;;;;;;;                   \n";
    print "     .- `\\, '/_      _____ _    ";
    print color('bold red'),"____";
    print color('reset');
    print "  _                      _            \n";
    print "   .'   \\  (`(_)    |_   _| |_ ";
    print color('bold red'),"|__ /";
    print color('reset');
    print " (_)_ _  ____ __  ___ __| |_ ___ _ _ \n";
    print "  / `-,. \\ \\_/        | | | ' \\ ";
    print color('bold red'),"|_ \\";
    print color('reset');
    print "\ | | ' \\(_-< '_ \\/ -_) _|  _/ _ \\ '_| \n";
    print "  \\  \\/ \\ `--`        |_| |_||_|";
    print color('bold red'),"___/";
    print color('reset');
    print " |_|_||_/__/ .__/\\___\\__|\\__\\___/_| ";
    print color('bold green'),"V 1.9\n";
    print color('reset');
    print "   \\  \\  \\                         \033[0;31m[\033[0;33m127.0.0.1\033[0;31m] \033[0;37m|_|\033[0;31m [\033[1;34m192.168.1.1\033[0;31m] \033[0;37m\n";
    print "    / /| |                            \033[0;31m[\033[0;37mCoded BY Mohamed Riahi\033[0;31m]\033[0;37m\n";
    print "   /_/ |_|      \n";
    print "  ( _\\ ( _\\    #:##       #:##\n";
    print "                     #:## \n\n";
}

##### Menu #######
sub menu {
    print item('01'),"Website Information\n";
    print item('02'),"Phone Number Information\n";
    print item('03'),"Find IP Address And E-mail Server\n";
    print item('04'),"Domain Whois Lookup\n";
    print item('05'),"Find Website/IP Address Location\n";
    print item('06'),"Bypass CloudFlare\n";
    print item('07'),"Domain Age Checker\n";
    print item('08'),"User Agent Info\n";
    print item('09'),"Check Active Services On Resource\n";
    print item('10'),"Credit Card Bin Checker\n";
    print item('11'),"Subdomain Scanner\n";
    print item('12'),"Check E-mail Address\n";
    print item('13'),"Content Management System Checker\n";
    print item('14'),"Update\n\n";
    print item('-'),"Choose : ";
    print color('reset');

    chomp($number=<STDIN>);

    if($number eq '01'){
        banner();
        print item(),"Enter Website : ";
        chomp($site1=<STDIN>);
        banner();
        Websiteinformation();
        enter();
    }if($number eq '02'){
        banner();
        print item(),"Enter Phone Number : +";
        chomp($PhoneNumber=<STDIN>);
        banner();
        Phonenumberinformation();
        enter();
    }if($number eq '03'){
        banner();
        print item(),"Enter Website : ";
        chomp($site2=<STDIN>);
        banner();
        FindIPaddressandemailserver();
        enter();
    }if($number eq '04'){
        banner();
        print item(),"Enter Website : ";
        chomp($site3=<STDIN>);
        banner();
        Domainwhoislookup();
        enter();
    }if($number eq '05'){
        banner();
        print item(),"Enter Website/IP : ";
        chomp($site4=<STDIN>);
        banner();
        Findwebsitelocation();
        enter();
    }if($number eq '06'){
        banner();
        print item(),"Enter Website : ";
        chomp($site5=<STDIN>);
        banner();
        CloudFlare();
        enter();
    }if($number eq '07'){
        banner();
        print item(),"Enter Website : ";
        chomp($site6=<STDIN>);
        banner();
        DomainAgeChecker();
        enter();
    }if($number eq '08'){
        banner();
        print item(),"Enter User Agent : ";
        chomp($useragent=<STDIN>);
        my $find = "/";
        my $replace = "%2F";

        $find = quotemeta $find;
        $useragent =~ s/$find/$replace/g;
        $useragent =~ s/ /+/g;
        banner();
        UserAgent();
        enter();
    }if($number eq '09'){
        banner();
        port();
        enter();
    }if($number eq '10'){
        banner();
        print item(),"Enter First 6 Digits Of A Credit Card Number : ";
        chomp($bin=<STDIN>);
        banner();
        BIN();
        enter();
    }if($number eq '11'){
        banner();
        print item(),"Enter website: ";
        chomp($site8=<STDIN>);
        banner();
        subdomain();
        enter();
    }if($number eq '12'){
        banner();
        print item(),"Enter E-mail : ";
        chomp($email=<STDIN>);
        banner();
        email();
        enter();
    }if($number eq '13'){
        banner();
        print item(),"Enter website: ";
        chomp($site7=<STDIN>);
        banner();
        cms();
        enter();
    }if($number eq '14'){
        update();
    }
}

####### Website information #######
sub Websiteinformation {
    $url = "https://myip.ms/$site1";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/> (.*?) visitors per day </)
    {
        print item(),"Hosting Info for Website: $site1\n";
        print item(),"Visitors per day: $1 \n";

        if($response =~/> (.*?) visitors per day on (.*?)</){
            print item(),"Visitors per day: $1 \n";
        }
        $ip= (gethostbyname($site1))[4];
        my ($a,$b,$c,$d) = unpack('C4',$ip);
        $ip_address ="$a.$b.$c.$d";
        print item(),"IP Address: $ip_address\n";

        if($response =~/IPv6.png'><a href='\/info\/whois6\/(.*?)'>/)
        {
            $ipv6_address=$1;
            print item(),"Linked IPv6 Address: $ipv6_address\n";
        }
        if($response =~/IP Location: <\/td> <td class='vmiddle'><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/Internet_Usage_Statistics_(.*?).html'>(.*?)<\/a>/)
        {
            $Location=$1;
            print item(),"IP Location: $Location\n";
        }
        if($response =~/IP Reverse DNS (.*?)<\/b><\/div><div class='sval'>(.*?)<\/div>/)
        {
            $host=$2;
            print item(),"IP Reverse DNS (Host): $host\n";
        }
        if($response =~/Hosting Company: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerName=$1;
            print item(),"Hosting Company: $ownerName\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'>  <span class='cflag (.*?)'><\/span> <a href='\/view\/web_hosting\/(.*?)'>(.*?)<\/a>/)
        {
            $ownerip=$3;
            print item(),"Hosting Company IP Owner:  $ownerip\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerip=$1;
            print item(),"Hosting Company IP Owner:  $ownerip\n";
        }
        if($response =~/IP Range <b>(.*?) - (.*?)<\/b><br>have <b>(.*?)<\/b>/)
        {
            print item(),"Hosting IP Range: $1 - $2 ($3 ip) \n";
        }
        if($response =~/Hosting Address: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $address=$1;
            print item(),"Hosting Address: $address\n";
        }
        if($response =~/Owner Address: <\/td><td>(.*?)<\/td>/)
        {
            $addressowner=$1;
            print item(),"Owner Address: $addressowner\n";
        }
        if($response =~/Hosting Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $HostingCountry=$1;
            print item(),"Hosting Country: $HostingCountry\n";
        }
        if($response =~/Owner Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $OwnerCountry=$1;
            print item(),"Owner Country: $OwnerCountry\n";
        }
        if($response =~/Hosting Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $phone=$1;
            print item(),"Hosting Phone: $phone\n";
        }
        if($response =~/Owner Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $Ownerphone=$1;
            print item(),"Owner Phone: $Ownerphone\n";
        }
        if($response =~/Hosting Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/images\/tooltip.gif'><\/td><td><a href='\/(.*?)'>(.*?)<\/a><\/td>/)
        {
            $website=$1;
            print item(),"Hosting Website: $website\n";
        }
        if($response =~/Owner Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/(.*?)'><\/td><td><a href='\/(.*?)'>(.*?)<\/a>/)
        {
            $Ownerwebsite=$3;
            print item(),"Owner Website: $Ownerwebsite\n";
        }
        if($response =~/CIDR:<\/td><td> (.*?)<\/td><\/tr>/)
        {
            $CIDR=$1;
            print item(),"CIDR: $CIDR\n";
        }
        if($response =~/Owner CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Owner CIDR: $3/$4\n\n";
        }
        if($response =~/Hosting CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Hosting CIDR: $3/$4\n\n";
        }
        $url = "https://dns-api.org/NS/$site1";
        $request = $ua->get($url);
        $response = $request->content;
    }else {
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }
    my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS: $ns \n";
    }
}

### Phone number information ###########
sub Phonenumberinformation {

    $url = "https://pastebin.com/raw/egbm0eEk";
    $request = $ua->get($url);
    $api2 = $request->content;

    $url = "http://apilayer.net/api/validate?access_key=$api2&number=$PhoneNumber&country_code=&format=1";
    $request = $ua->get($url);
    $r = decode_json $request->content;

    if ( defined $r )
    {
        foreach my $k ( sort keys %{$r} )
        {
            print item(), ucfirst($k).' : '.$r->{$k}."\n" unless ( $r->{$k} eq '' );
        }
    
    } 
    else 
    {
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Phone Number Without +/00\n";
        print item('3'),"Check If Phone Number Exists\n";
        exit
    }
}
### Find IP address and email server ###########
sub FindIPaddressandemailserver {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0");
    my $url = "https://dns-api.org/MX/$site2";

    $request = $ua->get($url);
    $response = $request->content;
    if ($response =~ /error/){
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
        exit
    }
    print item(),"Domain name for MX records: $site2\n\n";
    my %seen;
   while($response =~m/"value": "(.*?)."/g)
    {
        $mx=$1;
        next if $seen{$mx}++;
        print item(),"MX: $mx \n";
    }
}
### Domain whois lookup ###########
sub Domainwhoislookup {
    $url = "https://pastebin.com/raw/YfHdX0jE";
    $request = $ua->get($url);
    $api4 = $request->content;
    $url = "http://www.whoisxmlapi.com//whoisserver/WhoisService?domainName=$site3&username=$api4&outputFormat=JSON";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);

    if (exists $responseObject->{'WhoisRecord'}->{'createdDate'}){
        print item(),"Whois lookup for : $site3 \n";
        print item(),'Created date: ',
        $responseObject->{'WhoisRecord'}->{'createdDate'},"\n";sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'expiresDate'}){
            print item(),'Expires date: ',
            $responseObject->{'WhoisRecord'}->{'expiresDate'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'contactEmail'}){
            print item(),'Contact email: ',
            $responseObject->{'WhoisRecord'}->{'contactEmail'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'name'}){
            print item(),'Registrant Name: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'name'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'}){
            print item(),'Registrant Organization: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'}){
            print item(),'Registrant Street: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'},"\n";} sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'city'}){
            print item(),'Registrant City: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'state'}){
            print item(),'Registrant State/Province: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'}){
            print item(),'Registrant Postal Code: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'country'}){
            print item(),'Registrant Country: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'email'}){
            print item(),'Registrant Email: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'}){
            print item(),'Registrant Phone: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'}){
            print item(),'Registrant Fax: ',
            $responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'}){
            print item(),'Admin Name: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'}){
            print item(),'Admin Organization: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'}){
            print item(),'Admin Street: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'}){
            print item(),'Admin City: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'}){
            print item(),'Admin State/Province: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'}){
            print item(),'Admin Postal Code: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'}){
            print item(),'Admin Country: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'}){
            print item(),'Admin Email: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'}){
            print item(),'Admin Phone: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'}){
            print item(),'Admin Fax: ',
            $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'}){
            print item(),'Tech Name: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'}){
            print item(),'Tech Organization: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'}){
            print item(),'Tech Street: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'}){
            print item(),'Tech City: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'}){
            print item(),'Tech State/Province: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'}){
            print item(),'Tech Postal Code: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'}){
            print item(),'Tech Country: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'}){
            print item(),'Tech Email: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'}){
            print item(),'Tech Phone: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'},"\n";}sleep(1);
        if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'}){
            print item(),'Tech Fax: ',
            $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'},"\n";}sleep(1);
    }else {
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }
}
### Find website location ###########
sub Findwebsitelocation {
    $ip= (gethostbyname($site4))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip ="$a.$b.$c.$d";

    $url = "https://ipapi.co/$ip/json/";
    $request = $ua->get($url);
    $r = decode_json $request->content;

    if ( defined $r )
    {
        print item(),"IP Address: $ip\n";
        print item(),"Country: ",              $r->{country}, "\n"                                             if ( defined $r->{country} );
        print item(),"Country name: ",         $r->{country_name}, "\n"                                        if ( defined $r->{country_name} );
        print item(),"City: ",                 $r->{city},"\n"                                                 if ( defined $r->{city} );
        print item(),"Region: ",               $r->{region},"\n"                                               if ( defined $r->{region} );
        print item(),"Region Code: ",          $r->{region_code},"\n"                                          if ( defined $r->{region_code} );
        print item(),"Continent Code: ",       $r->{continent_code},"\n"                                       if ( defined $r->{continent_code} );
        print item(),"Postal Code: ",          $r->{postal},"\n"                                               if ( defined $r->{postal} );
        print item(),"Latitude / Longitude: ", $r->{latitude}," / ", color("bold white"), $r->{longitude},"\n" if ( defined $r->{latitude} && defined $r->{longitude} );
        print item(),"Timezone: ",             $r->{timezone},"\n"                                             if ( defined $r->{timezone} );
        print item(),"Utc Offset: ",           $r->{utc_offset},"\n"                                           if ( defined $r->{utc_offset} );
        print item(),"Calling Code: ",         $r->{country_calling_code},"\n"                                 if ( defined $r->{country_calling_code} );
        print item(),"Currency: ",             $r->{currency},"\n"                                             if ( defined $r->{currency} );
        print item(),"Languages: ",            $r->{languages},"\n"                                            if ( defined $r->{languages} );
        print item(),"ASN: ",                  $r->{asn},"\n"                                                  if ( defined $r->{asn} );
        print item(),"ORG: ",                  $r->{org},"\n"                                                  if ( defined $r->{org} );
    }
    else
    {
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website/IP Working\n";
    }
}
### Bypass CloudFlare ###########
sub CloudFlare {
    my $ua = LWP::UserAgent->new;
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $ip= (gethostbyname($site5))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($ip_address =~ /[0-9]/){
        print item(),"CloudFlare IP: $ip_address\n\n";
    }

    $url = "https://dns-api.org/NS/$site5";
    $request = $ua->get($url);
    $response = $request->content;

my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS: $ns \n";
    }
    print color("bold white"),"\n";
    $url = "http://www.crimeflare.us/cgi-bin/cfsearch.cgi";
    $request = POST $url, [cfS => $site5];
    $response = $ua->request($request);
    $riahi = $response->content;

    if($riahi =~m/">(.*?)<\/a>&nbsp/g){
        print item(),"Real IP: $1\n";
        $ip=$1;
    }elsif($riahi =~m/not CloudFlare-user nameservers/g){
        print item(),"These Are Not CloudFlare-user Nameservers !!\n";
        print item(),"This Website Not Using CloudFlare Protection\n";
    }elsif($riahi =~m/No direct-connect IP address was found for this domain/g){
        print item(),"No Direct Connect IP Address Was Found For This Domain\n";
    }else{
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }

    $url = "http://ipinfo.io/$ip/json";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/hostname": "(.*?)"/g){
        print item(),"Hostname: $1\n";
    }if($response =~m/city": "(.*?)"/g){
        print item(),"City: $1\n";
    }if($response =~m/region": "(.*?)"/g){
        print item(),"Region: $1\n";
    }if($response =~m/country": "(.*?)"/g){
        print item(),"Country: $1\n";
    }if($response =~m/loc": "(.*?)"/g){
        print item(),"Location: $1\n";
    }if($response =~m/org": "(.*?)"/g){
        print item(),"Organization: $1\n";
    }
}



### User Agent Info ###########
sub UserAgent {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $url = "https://pastebin.com/raw/pTXVQiuJ";
    $request = $ua->get($url);
    $api8 = $request->content;

    $url = "https://useragentapi.com/api/v4/json/$api8/$useragent";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/ua_type":"(.*?)"/g){
        print item(),"User Agent Type: $1\n";
        if($response =~m/os_name":"(.*?)"/g){
            print item(),"OS name: $1\n";
        }if($response =~m/os_version":"(.*?)"/g){
            print item(),"OS version: $1\n";
        }if($response =~m/browser_name":"(.*?)"/g){
            print item(),"Browser name: $1\n";
        }if($response =~m/browser_version":"(.*?)"/g){
            print item(),"Browser version: $1\n";
        }if($response =~m/engine_name":"(.*?)"/g){
            print item(),"Engine name: $1\n";
        }if($response =~m/engine_version":"(.*?)"/g){
            print item(),"Engine version: $1\n";
        }
    }else{
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Check If User Agent Exists\n";
    }
}

### Domain Age Checker ###########
sub DomainAgeChecker {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $url = "https://input.payapi.io/v1/api/fraud/domain/age/$site6";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/is (.*?) days (.*?) Date: (.*?)"/g){
        $days=$1;
        $created=$3;

        print item(),"Domain Name : $site6\n";
        print item(),"Domain Created on : $created\n";

        $url = "http://unitconverter.io/days/years/$days";
        $request = $ua->get($url);
        $response = $request->content;

        if($response =~m/<strong style="color:red"> = (.*?)<\/strong><\/p>/g){
            $age=$1;
            $age =~ s/  / /g;
            print item(),"Domain Age : $age\n";
        }
    }else{
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }
}
######################## Credit card BIN number Check ################################
sub BIN {
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $url = "https://lookup.binlist.net/$bin";
    $request = $ua->get($url);
    $response = decode_json $request->content;

    if ( defined $response )
    {
        print item(),"Credit card BIN number: $bin XX XXXX XXXX\n";
        print item(),"Credit card brand: ", $response->{scheme}, "\n"               if ( defined $response->{scheme} );
        print item(),"Type: ",              $response->{type}, "\n"                 if ( defined $response->{type} );
        print item(),"Bank: ",              $response->{bank}->{name}, "\n"         if ( defined $response->{bank}->{name} );
        print item(),"Bank URL: ",          $response->{bank}->{url}, "\n"          if ( defined $response->{bank}->{url} );
        print item(),"Bank Phone: ",        $response->{bank}->{phone}, "\n"        if ( defined $response->{bank}->{phone} );
        print item(),"Country Short: ",     $response->{country}->{alpha2}, "\n"    if ( defined $response->{country}->{alpha2} );
        print item(),"Country: ",           $response->{country}->{name}, "\n"      if ( defined $response->{country}->{name} );
        print item(),"Latitude: ",          $response->{country}->{latitude}, "\n"  if ( defined $response->{country}->{latitude} );
        print item(),"Longitude: ",         $response->{country}->{longitude}, "\n" if ( defined $response->{country}->{longitude} );
    }
    else
    {
        print item(),"There Is A Problem\n\n";
        print item(1),"Checking The Connection\n";
        print item(2),"Enter Only First 6 Digits Of A Credit Card Number\n";
    }
}
####### Subdomain Scanner #######
sub subdomain {
    $url = "https://www.pagesinventory.com/search/?s=$site8";
    $request = $ua->get($url);
    $response = $request->content;

    $ip= (gethostbyname($site8))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($response =~ /Search result for/){
        print item(),"Website: $site8\n";
        print item(),"IP: $ip_address\n\n";

        while($response =~ m/<td><a href=\"\/domain\/(.*?).html\">(.*?)<a href="\/ip\/(.*?).html">/g ) {

            print item(),"Subdomain: $1\n";
            print item('-'),"IP: $3\n\n";
            sleep(1);
        }
    }elsif($ip_address =~ /[0-9]/){
        if($response =~ /Nothing was found/){
            print item(),"Website: $site8\n";
            print item(),"IP: $ip_address\n\n";
            print item(),"No Subdomains Found For This Domain\n";
        }}else {
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }
}

####### Port scanner #######
sub port {
    print item(),"Enter Website/IP : ";

    chop ($target = <stdin>);
    $| = 1;

    print "\n";
    print item(),"PORT  STATE   SERVICE\n";
    my %ports = (
         21   => 'FTP'
        ,22   => 'SSH'
        ,23   => 'Telnet'
        ,25   => 'SMTP'
        ,43   => 'Whois'
        ,53   => 'DNS'
        ,68   => 'DHCP'
        ,80   => 'HTTP'
        ,110  => 'POP3'
        ,115  => 'SFTP'
        ,119  => 'NNTP'
        ,123  => 'NTP'
        ,139  => 'NetBIOS'
        ,143  => 'IMAP'
        ,161  => 'SNMP'
        ,220  => 'IMAP3'
        ,389  => 'LDAP'
        ,443  => 'SSL'
        ,1521 => 'Oracle SQL'
        ,2049 => 'NFS'
        ,3306 => 'mySQL'
        ,5800 => 'VNC'
        ,8080 => 'HTTP'
    );
    foreach my $p ( sort {$a<=>$b} keys( %ports ) )
    {
        $socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => "$p" , Proto => 'tcp' , Timeout => 1);
        if( $socket ){
            print item(); printf("%4s  Open    %s\n", $p, $ports{$p});

        }else{
            print item(); printf("%4s  Closed  %s\n", $p, $ports{$p});
        }
    }
}

####### Check e-mail address #######
sub email {
    $url = "https://api.2ip.me/email.txt?email=$email";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/true/)
    {
        print item(),"E-mail address : $email \n";
        print item(),"Valid : ";
        print color('bold green'),"YES\n";
        print color('reset');
    }elsif($response =~/false/){
        print item(),"E-mail address : $email \n";
        print item(),"Valid : ";
        print color('bold red'),"NO\n";
        print color('reset');
    }else{
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Check If E-mail Exists\n";
    }
}

####### Check Content Management System (CMS) #######
sub cms {
    $url = "https://pastebin.com/raw/CYaZrPFP";
    $request = $ua->get($url);
    $api12 = $request->content;

    $url = "https://whatcms.org/APIEndpoint?key=$api12&url=$site7";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);

    if($response =~/Success/){
        print item(),"WebSite : $site7 \n";
        if (exists $responseObject->{'result'}->{'name'}){
            print item(),'CMS: ',
            $responseObject->{'result'}->{'name'},"\n";}
        if (exists $responseObject->{'result'}->{'version'}){
            print item(),'Version: ',
            $responseObject->{'result'}->{'version'},"\n";}
    }elsif($response =~/CMS Not Found/){
        print item(),"WebSite : $site7 \n";
        print item(),"CMS :";
        print color("bold red")," Not Found\n";
        print color('reset');
    }else{
        print item(),"There Is A Problem\n\n";
        print item('1'),"Checking The Connection\n";
        print item('2'),"Enter Website Without HTTP/HTTPs\n";
        print item('3'),"Check If Website Working\n";
    }
}


##### Update #######
sub update {
    if ($^O =~ /MSWin32/) {
        banner();
        print item('1'),"Download Th3inspector\n";
        print item('2'),"Extract Th3inspector into Desktop\n";
        print item('3'),"Open CMD and type the following commands:\n";
        print item('4'),"cd Desktop/Th3inspector-master/\n";
        print item('5'),"perl Th3inspector.pl\n";
    }else {
        $linux = "/usr/share/Th3inspector";
        $termux = "/data/data/com.termux/files/usr/share/Th3inspector";
        if (-d $linux){
            system("bash /usr/share/Th3inspector/update.sh");
        } elsif (-d $termux){
            system("chmod +x /data/data/com.termux/files/usr/share/Th3inspector/update.sh && bash /data/data/com.termux/files/usr/share/Th3inspector/update.sh");
        }
    }
}
##### Enter #######
sub enter {
    print "\n";
    print item(),"Press ";
    print color('bold red'),"[";
    print color("bold white"),"ENTER";
    print color('bold red'),"] ";
    print color("bold white"),"Key To Continue\n";

    local( $| ) = ( 1 );

    my $resp = <STDIN>;
    banner();
    menu();
}

### Item format ###
sub item
{
    my $n = shift // '+';
    return color('bold red')," ["
    , color('bold green'),"$n"
    , color('bold red'),"] "
    , color("bold white")
    ;
}
__END__
