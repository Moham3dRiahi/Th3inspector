#!/usr/bin/perl

use if $^O eq "MSWin32", Win32::Console::ANSI;
use Getopt::Long;
use HTTP::Request;
use LWP::UserAgent;
use IO::Select;
use HTTP::Headers;
use IO::Socket;
use HTTP::Response;
use Term::ANSIColor;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(GET);
use URI::URL;
use IO::Socket::INET;
use Data::Dumper;
use LWP::Simple;
use JSON qw( decode_json encode_json );

my $ua = LWP::UserAgent->new;
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

GetOptions(
    "h|help" => \$help,
    "i|info=s" => \$site1,
    "n|number=s" => \$PhoneNumber,
    "mx|mailserver=s" => \$site2,
    "w|whois=s" => \$site3,
    "l|location=s" => \$site4,
    "c|cloudflare=s" => \$site5,
    "a|age=s" => \$site6,
    "ua|useragent=s" => \$useragent,
    "p|port=s" => \$target,
    "b|bin=s" => \$bin,
    "s|subdomain=s" => \$site8,
    "e|email=s" => \$email,
    "cms|cms=s" => \$site7,
);

if ($help) { banner();help(); }
if ($site1) { banner();Websiteinformation(); }
if ($PhoneNumber) { banner();Phonenumberinformation(); }
if ($site2) { banner();FindIPaddressandemailserver(); }
if ($site3) { banner();Domainwhoislookup(); }
if ($site4) { banner();Findwebsitelocation(); }
if ($site5) { banner();CloudFlare(); }
if ($site6) { banner();DomainAgeChecker(); }
if ($useragent) { banner();UserAgent(); }
if ($bin) { banner();BIN(); }
if ($site8) { banner();subdomain(); }
if ($email) { banner();email(); }
if ($site7) { banner();cms(); }
if ($target) { banner();port(); }
unless ($help|$site1|$PhoneNumber|$site2|$site3|$site4|$site5|$site6|$useragent|$bin|$email|$site7|$site8|$target) { banner();menu(); }

########################## Help ############################
sub help {
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Website Information ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -i example.com\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Phone Number Information ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -n xxxxxxx\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Find IP Address And E-mail Server ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -mx example.com\n";
print color('bold red')," [";
print color('bold green'),"4";
print color('bold red'),"] ";
print color("bold white"),"Domain Whois Lookup ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -w example.com\n";
print color('bold red')," [";
print color('bold green'),"5";
print color('bold red'),"] ";
print color("bold white"),"Find Website/IP Address Location ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -l example.com\n";
print color('bold red')," [";
print color('bold green'),"6";
print color('bold red'),"] ";
print color("bold white"),"Bypass CloudFlare ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -c example.com\n";
print color('bold red')," [";
print color('bold green'),"7";
print color('bold red'),"] ";
print color("bold white"),"Domain Age Checker ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -a example.com\n";
print color('bold red')," [";
print color('bold green'),"8";
print color('bold red'),"] ";
print color("bold white"),"User Agent Info ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -ua Mozilla/5.0 xxxxxxxxxxxxxxxxxxxx\n";
print color('bold red')," [";
print color('bold green'),"9";
print color('bold red'),"] ";
print color("bold white"),"Check Active Services On Resource";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -p 127.0.0.1\n";
print color('bold red')," [";
print color('bold green'),"10";
print color('bold red'),"] ";
print color("bold white"),"Credit Card Bin Checker ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -b 123456\n";
print color('bold red')," [";
print color('bold green'),"11";
print color('bold red'),"] ";
print color("bold white"),"Subdomain Scanner ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -s example.com\n";
print color('bold red')," [";
print color('bold green'),"12";
print color('bold red'),"] ";
print color("bold white"),"E-mail Address Checker ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -e example@gmail.com\n";
print color('bold red')," [";
print color('bold green'),"13";
print color('bold red'),"] ";
print color("bold white"),"Content Management System Checker ";
print color('bold red'),"=> ";
print color("bold white"),"perl Th3inspector.pl -cms example.com\n";
}

########################## Banner ############################
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

########################## Menu ############################
sub menu {
print color('bold red')," [";
print color('bold green'),"01";
print color('bold red'),"] ";
print color("bold white"),"Website Information\n";
print color('bold red')," [";
print color('bold green'),"02";
print color('bold red'),"] ";
print color("bold white"),"Phone Number Information\n";
print color('bold red')," [";
print color('bold green'),"03";
print color('bold red'),"] ";
print color("bold white"),"Find IP Address And E-mail Server\n";
print color('bold red')," [";
print color('bold green'),"04";
print color('bold red'),"] ";
print color("bold white"),"Domain Whois Lookup\n";
print color('bold red')," [";
print color('bold green'),"05";
print color('bold red'),"] ";
print color("bold white"),"Find Website/IP Address Location\n";
print color('bold red')," [";
print color('bold green'),"06";
print color('bold red'),"] ";
print color("bold white"),"Bypass CloudFlare\n";
print color('bold red')," [";
print color('bold green'),"07";
print color('bold red'),"] ";
print color("bold white"),"Domain Age Checker\n";
print color('bold red')," [";
print color('bold green'),"08";
print color('bold red'),"] ";
print color("bold white"),"User Agent Info\n";
print color('bold red')," [";
print color('bold green'),"09";
print color('bold red'),"] ";
print color("bold white"),"Check Active Services On Resource\n";
print color('bold red')," [";
print color('bold green'),"10";
print color('bold red'),"] ";
print color("bold white"),"Credit Card Bin Checker\n";
print color('bold red')," [";
print color('bold green'),"11";
print color('bold red'),"] ";
print color("bold white"),"Subdomain Scanner\n";
print color('bold red')," [";
print color('bold green'),"12";
print color('bold red'),"] ";
print color("bold white"),"Check E-mail Address\n";
print color('bold red')," [";
print color('bold green'),"13";
print color('bold red'),"] ";
print color("bold white"),"Content Management System Checker\n";
print color('bold red')," [";
print color('bold green'),"14";
print color('bold red'),"] ";
print color("bold white"),"Install & Update\n\n";
print color('bold red')," [";
print color('bold green'),"-";
print color('bold red'),"] ";
print color("bold white"),"Choose : ";
print color('reset');

$number=<STDIN>;
chomp $number;

if($number eq '01'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website : ";
$site1=<STDIN>;
chomp($site1);
banner();
Websiteinformation();
enter();
}if($number eq '02'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Phone Number : +";
$PhoneNumber=<STDIN>;
chomp($PhoneNumber);
banner();
Phonenumberinformation();
enter();
}if($number eq '03'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website : ";
$site2=<STDIN>;
chomp($site2);
banner();
FindIPaddressandemailserver();
enter();
}if($number eq '04'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website : ";
$site3=<STDIN>;
chomp($site3);
banner();
Domainwhoislookup();
enter();
}if($number eq '05'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website/IP : ";
$site4=<STDIN>;
chomp($site4);
banner();
Findwebsitelocation();
enter();
}if($number eq '06'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website : ";
$site5=<STDIN>;
chomp($site5);
banner();
CloudFlare();
enter();
}if($number eq '07'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website : ";
$site6=<STDIN>;
chomp($site6);
banner();
DomainAgeChecker();
enter();
}if($number eq '08'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter User Agent : ";
$useragent=<STDIN>;
chomp($useragent);
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
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter First 6 Digits Of A Credit Card Number : ";
$bin=<STDIN>;
chomp($bin);
banner();
BIN();
enter();
}if($number eq '11'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter website: ";
$site8=<STDIN>;
chomp($site8);
banner();
subdomain();
enter();
}if($number eq '12'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter E-mail : ";
$email=<STDIN>;
chomp($email);
banner();
email();
enter();
}if($number eq '13'){
banner();
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter website: ";
$site7=<STDIN>;
chomp($site7);
banner();
cms();
enter();
}if($number eq '14'){
update();
}
}

############################ Website information ############################
sub Websiteinformation {
$url = "https://myip.ms/$site1";
$request = $ua->get($url);
$response = $request->content;

if($response =~/> (.*?) visitors per day </)
{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Info for Website: $site1\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Visitors per day: $1 \n";

if($response =~/> (.*?) visitors per day on (.*?)</){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Visitors per day: $1 \n";
}
$ip= (gethostbyname($site1))[4];
my ($a,$b,$c,$d) = unpack('C4',$ip);
$ip_address ="$a.$b.$c.$d";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP Address: $ip_address\n";

if($response =~/IPv6.png'><a href='\/info\/whois6\/(.*?)'>/)
{
$ipv6_address=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Linked IPv6 Address: $ipv6_address\n";
}
if($response =~/IP Location: <\/td> <td class='vmiddle'><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/Internet_Usage_Statistics_(.*?).html'>(.*?)<\/a>/)
{
$Location=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP Location: $Location\n";
}
if($response =~/IP Reverse DNS (.*?)<\/b><\/div><div class='sval'>(.*?)<\/div>/)
{
$host=$2;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP Reverse DNS (Host): $host\n";
}
if($response =~/Hosting Company: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
{
$ownerName=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Company: $ownerName\n";
}
if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'>  <span class='cflag (.*?)'><\/span> <a href='\/view\/web_hosting\/(.*?)'>(.*?)<\/a>/)
{
$ownerip=$3;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Company IP Owner:  $ownerip\n";
}
if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
{
$ownerip=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Company IP Owner:  $ownerip\n";
}
if($response =~/IP Range <b>(.*?) - (.*?)<\/b><br>have <b>(.*?)<\/b>/)
{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting IP Range: $1 - $2 ($3 ip) \n";
}
if($response =~/Hosting Address: <\/td><td>(.*?)<\/td><\/tr>/)
{
$address=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Address: $address\n";
}
if($response =~/Owner Address: <\/td><td>(.*?)<\/td>/)
{
$addressowner=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Owner Address: $addressowner\n";
}
if($response =~/Hosting Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
{
$HostingCountry=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Country: $HostingCountry\n";
}
if($response =~/Owner Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
{
$OwnerCountry=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Owner Country: $OwnerCountry\n";
}
if($response =~/Hosting Phone: <\/td><td>(.*?)<\/td><\/tr>/)
{
$phone=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Phone: $phone\n";
}
if($response =~/Owner Phone: <\/td><td>(.*?)<\/td><\/tr>/)
{
$Ownerphone=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Owner Phone: $Ownerphone\n";
}
if($response =~/Hosting Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/images\/tooltip.gif'><\/td><td><a href='\/(.*?)'>(.*?)<\/a><\/td>/)
{
$website=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting Website: $website\n";
}
if($response =~/Owner Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/(.*?)'><\/td><td><a href='\/(.*?)'>(.*?)<\/a>/)
{
$Ownerwebsite=$3;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Owner Website: $Ownerwebsite\n";
}
if($response =~/CIDR:<\/td><td> (.*?)<\/td><\/tr>/)
{
$CIDR=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"CIDR: $CIDR\n";
}
if($response =~/Owner CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Owner CIDR: $3/$4\n\n";
}
if($response =~/Hosting CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hosting CIDR: $3/$4\n\n";
}
$url = "https://dns-api.org/NS/$site1";
$request = $ua->get($url);
$response = $request->content;
}else {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}
my %seen;
while($response =~m/value":"(.*?)."/g)
{
$ns=$1;
next if $seen{$ns}++;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"NS: $ns \n";
}
}

######################## Phone number information ################################
sub Phonenumberinformation {

$url = "https://pastebin.com/raw/egbm0eEk";
$request = $ua->get($url);
$api2 = $request->content;

$url = "http://apilayer.net/api/validate?access_key=$api2&number=$PhoneNumber&country_code=&format=1";
$request = $ua->get($url);
$response = $request->content;
if($response =~/"valid":true/)
{
$valid=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Valid : ";
print color("bold green"),"true\n";

if($response =~/local_format":"(.*?)"/)
{
$localformat=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Local Format : $localformat\n";
}
if($response =~/international_format":"(.*?)"/)
{
$international_format=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"International Format : $international_format\n";
}
if($response =~/country_name":"(.*?)"/)
{
$country_name=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Country : $country_name\n";
}
if($response =~/location":"(.*?)"/)
{
$location=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Location : $location\n";
}
if($response =~/carrier":"(.*?)"/)
{
$carrier=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Carrier : $carrier\n";
}
if($response =~/line_type":"(.*?)"/)
{
$line_type=$1;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Line Type : $line_type\n";
}
}else {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Phone Number Without +/00\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Phone Number Exists\n";
exit
}
}
######################## Find IP address and email server ################################
sub FindIPaddressandemailserver {
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0");
my $url = "https://dns-api.org/MX/$site2";

$request = $ua->get($url);
$response = $request->content;
    if ($response =~ /error/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
exit
}
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Domain name for MX records: $site2\n\n";
my %seen;
while($response =~m/value":"(.*?) (.*?)."/g)
{
$mx=$2;
next if $seen{$mx}++;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"$mx -- priority $1\n";
}
}
######################## Domain whois lookup ################################
sub Domainwhoislookup {
$url = "https://pastebin.com/raw/YfHdX0jE";
$request = $ua->get($url);
$api4 = $request->content;
$url = "http://www.whoisxmlapi.com//whoisserver/WhoisService?domainName=$site3&username=$api4&outputFormat=JSON";
$request = $ua->get($url);
$response = $request->content;

my $responseObject = decode_json($response);
 
if (exists $responseObject->{'WhoisRecord'}->{'createdDate'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),"Whois lookup for : $site3 \n";     
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Created date: ',    
$responseObject->{'WhoisRecord'}->{'createdDate'},"\n";sleep(1);        
if (exists $responseObject->{'WhoisRecord'}->{'expiresDate'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";            
print color("bold white"),'Expires date: ',            
$responseObject->{'WhoisRecord'}->{'expiresDate'},"\n";}sleep(1);    
if (exists $responseObject->{'WhoisRecord'}->{'contactEmail'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Contact email: ',    
$responseObject->{'WhoisRecord'}->{'contactEmail'},"\n";}sleep(1);        
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'name'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Name: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'name'},"\n";} sleep(1);          
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Organization: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'organization'},"\n";} sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Street: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'street1'},"\n";} sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'city'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant City: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'city'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'state'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant State/Province: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'state'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Postal Code: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'postalCode'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'country'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Country: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'country'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'email'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Email: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'email'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Phone: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'telephone'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Registrant Fax: ',    
$responseObject->{'WhoisRecord'}->{'registrant'}->{'fax'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Name: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'name'},"\n";}sleep(1);           
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Organization: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'organization'},"\n";}sleep(1); 
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Street: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'street1'},"\n";}sleep(1); 
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin City: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'city'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin State/Province: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'state'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Postal Code: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'postalCode'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Country: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'country'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Email: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'email'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Phone: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'telephone'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Admin Fax: ',    
$responseObject->{'WhoisRecord'}->{'administrativeContact'}->{'fax'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Name: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'name'},"\n";}sleep(1);           
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Organization: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'organization'},"\n";}sleep(1); 
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Street: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'street1'},"\n";}sleep(1); 
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech City: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'city'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech State/Province: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'state'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Postal Code: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'postalCode'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Country: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'country'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Email: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'email'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Phone: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'telephone'},"\n";}sleep(1);
if (exists $responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'}){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),'Tech Fax: ',    
$responseObject->{'WhoisRecord'}->{'technicalContact'}->{'fax'},"\n";}sleep(1);
}else {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}
}
######################## Find website location ################################
sub Findwebsitelocation {
$ip= (gethostbyname($site4))[4];
my ($a,$b,$c,$d) = unpack('C4',$ip);
$ip ="$a.$b.$c.$d";

$url = "https://ipapi.co/$ip/json/";
$request = $ua->get($url);
$response = $request->content;

if($response =~/country_name": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP Address: $ip\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Country: $1\n";
if($response =~/city": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"City: $1\n";
}if($response =~/region": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Region: $1\n";
}if($response =~/region_code": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Region Code: $1\n";
}if($response =~/continent_code": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Continent Code: $1\n";
}if($response =~/postal": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Postal Code: $1\n";
}if($response =~/latitude": (.*?),/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Latitude / Longitude: $1, ";
}if($response =~/longitude": (.*?),/){
print color("bold white"),"$1\n";
}if($response =~/timezone": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Timezone: $1\n";
}if($response =~/utc_offset": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Utc Offset: $1\n";
}if($response =~/country_calling_code": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Calling Code: $1\n";
}if($response =~/currency": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Currency: $1\n";
}if($response =~/languages": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Languages: $1\n";
}if($response =~/asn": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"ASN: $1\n";
}if($response =~/org": "(.*?)"/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"ORG: $1\n";
}
}else {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website/IP Working\n";
}
}
######################## Bypass CloudFlare ################################
sub CloudFlare {
my $ua = LWP::UserAgent->new;
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

$ip= (gethostbyname($site5))[4];
my ($a,$b,$c,$d) = unpack('C4',$ip);
$ip_address ="$a.$b.$c.$d";
if($ip_address =~ /[0-9]/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"CloudFlare IP: $ip_address\n\n";
}

$url = "https://dns-api.org/NS/$site5";
$request = $ua->get($url);
$response = $request->content;

my %seen;
while($response =~m/value":"(.*?)."/g)
{
$ns=$1;
next if $seen{$ns}++;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"NS: $ns \n";
}
print color("bold white"),"\n";
$url = "http://www.crimeflare.us/cgi-bin/cfsearch.cgi";
$request = POST $url, [cfS => $site5];
$response = $ua->request($request);
$riahi = $response->content;

if($riahi =~m/">(.*?)<\/a>&nbsp/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Real IP: $1\n";
$ip=$1;
}elsif($riahi =~m/not CloudFlare-user nameservers/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"These Are Not CloudFlare-user Nameservers !!\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"This Website Not Using CloudFlare Protection\n";
}elsif($riahi =~m/No direct-connect IP address was found for this domain/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"No Direct Connect IP Address Was Found For This Domain\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}

$url = "http://ipinfo.io/$ip/json";
$request = $ua->get($url);
$response = $request->content;

if($response =~m/hostname": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Hostname: $1\n";
}if($response =~m/city": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"City: $1\n";
}if($response =~m/region": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Region: $1\n";
}if($response =~m/country": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Country: $1\n";
}if($response =~m/loc": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Location: $1\n";
}if($response =~m/org": "(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Organization: $1\n";
}
}



######################## User Agent Info ################################
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
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"User Agent Type: $1\n";
if($response =~m/os_name":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"OS name: $1\n";
}if($response =~m/os_version":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"OS version: $1\n";
}if($response =~m/browser_name":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Browser name: $1\n";
}if($response =~m/browser_version":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Browser version: $1\n";
}if($response =~m/engine_name":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Engine name: $1\n";
}if($response =~m/engine_version":"(.*?)"/g){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Engine version: $1\n";
}
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Check If User Agent Exists\n";
}
}

######################## Domain Age Checker ################################
sub DomainAgeChecker {
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

$url = "https://input.payapi.io/v1/api/fraud/domain/age/$site6";
$request = $ua->get($url);
$response = $request->content;

if($response =~m/is (.*?) days (.*?) Date: (.*?)"/g){
$days=$1;
$created=$3;

print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Domain Name : $site6\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Domain Created on : $created\n";

$url = "http://unitconverter.io/days/years/$days";
$request = $ua->get($url);
$response = $request->content;

if($response =~m/<strong style="color:red"> = (.*?)<\/strong><\/p>/g){
$age=$1;
$age =~ s/  / /g;
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Domain Age : $age\n";
}
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}

######################## Credit card BIN number Check ################################
sub BIN {
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

$url = "https://api.freebinchecker.com/bin/$bin";
$request = $ua->get($url);
$response = $request->content;

my $responseObject = decode_json($response);
 
if (exists $responseObject->{'card'}->{'brand'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Credit card BIN number: $bin XX XXXX XXXX\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Credit card brand: ',    
$responseObject->{'card'}->{'brand'},"\n";
if (exists $responseObject->{'card'}->{'type'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Type: ',    
$responseObject->{'card'}->{'type'},"\n";} 
if (exists $responseObject->{'card'}->{'category'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Category: ',    
$responseObject->{'card'}->{'category'},"\n";} 
if (exists $responseObject->{'card'}->{'sub-category'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Sub Category: ',    
$responseObject->{'card'}->{'sub-category'},"\n";}
if (exists $responseObject->{'issuer'}->{'name'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Bank: ',    
$responseObject->{'issuer'}->{'name'},"\n";}
if (exists $responseObject->{'issuer'}->{'url'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Bank URL: ',    
$responseObject->{'issuer'}->{'url'},"\n";}
if (exists $responseObject->{'issuer'}->{'tel'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Bank Phone: ',    
$responseObject->{'issuer'}->{'tel'},"\n";} 
if (exists $responseObject->{'country'}->{'name'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Country: ',    
$responseObject->{'country'}->{'name'},"\n";} 
if (exists $responseObject->{'country'}->{'alpha-2-code'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Country Short: ',    
$responseObject->{'country'}->{'alpha-2-code'},"\n";} 
if (exists $responseObject->{'country'}->{'latitude'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Latitude: ',    
$responseObject->{'country'}->{'latitude'},"\n";} 
if (exists $responseObject->{'country'}->{'longitude'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Longitude: ',    
$responseObject->{'country'}->{'longitude'},"\n";} 
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Only First 6 Digits Of A Credit Card Number\n";
}
}
############################ Subdomain Scanner ############################
sub subdomain {
$url = "https://www.pagesinventory.com/search/?s=$site8";
$request = $ua->get($url);
$response = $request->content;

$ip= (gethostbyname($site8))[4];
my ($a,$b,$c,$d) = unpack('C4',$ip);
$ip_address ="$a.$b.$c.$d";
if($response =~ /Search result for/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Website: $site8\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP: $ip_address\n\n";

while($response =~ m/<td><a href=\"\/domain\/(.*?).html\">(.*?)<a href="\/ip\/(.*?).html">/g ) {

print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Subdomain: $1\n";
print color('bold red')," [";
print color('bold green'),"-";
print color('bold red'),"] ";
print color("bold white"),"IP: $3\n\n";
sleep(1);
}
}elsif($ip_address =~ /[0-9]/){
if($response =~ /Nothing was found/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Website: $site8\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"IP: $ip_address\n\n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"No Subdomains Found For This Domain\n";
}}else {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}
}

############################ Port scanner ############################
sub port {
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Enter Website/IP : ";
 
chop ($target = <stdin>);
$| = 1;

print color('bold red'),"\n [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"PORT     STATE    SERVICE\n";
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '21' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"21       Open     FTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"21       Closed   FTP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '22' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"22       Open     SSH\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"22       Closed   SSH\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '23' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"23       Open     Telnet\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"23       Closed   Telnet\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '25' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"25       Open     STMP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"25       Closed   SMPT\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '43' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"43       Open     Whois\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"43       Closed   Whois\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '53' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"53       Open     DNS\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"53       Closed   DNS\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '68' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"68       Open     DHCP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"68       Closed   DHCP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '80' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"80       Open     HTTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"80       Closed   HTTP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '110' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"110      Open     POP3\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"110      Closed   POP3\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '115' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"115      Open     SFTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"115      Closed   SFTP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '119' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"119      Open     NNTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"119      Closed   NNTP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '123' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"123      Open     NTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"123      Closed   NTP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '139' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"139      Open     NetBIOS\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"139      Closed   NetBIOS\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '143' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"143      Open     IMAP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"143      Closed   IMAP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '161' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"161      Open     SNMP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"161      Closed   SNMP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '220' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"220      Open     IMAP3\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"220      Closed   IMAP3\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '389' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"389      Open     LDAP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"389      Closed   LDAP\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '443' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"443      Open     SSL\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"443      Closed   SSL\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '1521' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"1521     Open     Oracle SQL\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"1521     Closed   Oracle SQL\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '2049' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"2049     Open     NFS\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"2049     Closed   NFS\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '3306' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"3306     Open     mySQL\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"3306     Closed   mySQL\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '5800' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"5800     Open     VNC\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"5800     Closed   VNC\n";
}
$socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => '8080' , Proto => 'tcp' , Timeout => 1);
if( $socket ){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"8080     Open     HTTP\n";
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"8080     Closed   HTTP\n";
}
}

############################ Check e-mail address ############################
sub email {
$url = "https://api.2ip.me/email.txt?email=$email";
$request = $ua->get($url);
$response = $request->content;

if($response =~/true/)
{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"E-mail address : $email \n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Valid : ";
print color('bold green'),"YES\n";
print color('reset');
}elsif($response =~/false/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"E-mail address : $email \n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Valid : ";
print color('bold red'),"NO\n";
print color('reset');
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Check If E-mail Exists\n";
}
}

############################ Check Content Management System (CMS) ############################
sub cms {
$url = "https://pastebin.com/raw/CYaZrPFP";
$request = $ua->get($url);
$api12 = $request->content;

$url = "https://whatcms.org/APIEndpoint?key=$api12&url=$site7";
$request = $ua->get($url);
$response = $request->content;

my $responseObject = decode_json($response);
 
if($response =~/Success/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),"WebSite : $site7 \n";
if (exists $responseObject->{'result'}->{'name'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'CMS: ',    
$responseObject->{'result'}->{'name'},"\n";}   
if (exists $responseObject->{'result'}->{'version'}){ 
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),'Version: ',    
$responseObject->{'result'}->{'version'},"\n";}
}elsif($response =~/CMS Not Found/){
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";   
print color("bold white"),"WebSite : $site7 \n";
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";  
print color("bold white"),"CMS :"; 
print color("bold red")," Not Found\n";
print color('reset');
}else{
print color('bold red')," [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"There Is A Problem\n\n";
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Checking The Connection\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Enter Website Without HTTP/HTTPs\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Check If Website Working\n";
}
}
}

########################## Update ############################
sub update {
if ($^O =~ /MSWin32/) {
banner();
print color('bold red')," [";
print color('bold green'),"1";
print color('bold red'),"] ";
print color("bold white"),"Download Th3inspector\n";
print color('bold red')," [";
print color('bold green'),"2";
print color('bold red'),"] ";
print color("bold white"),"Extract Th3inspector into Desktop\n";
print color('bold red')," [";
print color('bold green'),"3";
print color('bold red'),"] ";
print color("bold white"),"Open CMD and type the following commands:\n";
print color('bold red')," [";
print color('bold green'),"4";
print color('bold red'),"] ";
print color("bold white"),"cd Desktop/Th3inspector-master/\n";
print color('bold red')," [";
print color('bold green'),"5";
print color('bold red'),"] ";
print color("bold white"),"perl Th3inspector.pl\n";
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
########################## Enter ############################
sub enter {
print color('bold red'),"\n [";
print color('bold green'),"+";
print color('bold red'),"] ";
print color("bold white"),"Press ";
print color('bold red'),"[";
print color("bold white"),"ENTER";
print color('bold red'),"] ";
print color("bold white"),"Key To Continue\n";

local( $| ) = ( 1 );

my $resp = <STDIN>;
banner();
menu();
} 
