use strict;
use Socket;

# use port 7890 as default
my $port = shift || 7890;
my $proto = getprotobyname('tcp');
my $server = "localhost";  # Host IP running the server

# create a socket, make it reusable
socket(SOCKET, PF_INET, SOCK_STREAM, $proto)
   or die "Can't open socket $!\n";
setsockopt(SOCKET, SOL_SOCKET, SO_REUSEADDR, 1)
   or die "Can't set socket option to SO_REUSEADDR $!\n";

# bind to a port, then listen
bind( SOCKET, pack_sockaddr_in($port, inet_aton($server)))
   or die "Can't bind to port $port! \n";

listen(SOCKET, 5) or die "listen: $!";
print "SERVER started on port $port\n";

# Accepting a connection
my $new_socket;
my $client_addr;
while ($client_addr = accept($new_socket, SOCKET)) {
   $new_socket->autoflush;
   my $name = gethostbyaddr($client_addr, AF_INET );
   print "Connection received from $name\n";
   print $new_socket "Begin the chat\n";
   while (my $recd = <$new_socket>) {
       chomp $recd;
       print "$recd\n";
	   my $send = <STDIN>;
	   chomp $send;
       print $new_socket "Server:$send\n";
   }   
   close $new_socket;
}