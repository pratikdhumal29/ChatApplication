use strict;
use Socket;
use Win32::GUI();
use feature 'state';
	
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

    my $text = defined($ARGV[0]) ? $ARGV[0] : "Hello, world";

    my $main = Win32::GUI::Window->new(
                -name => 'Main',
                -text => 'Server',
				-width => 500,
				-height => 500,
        );
    my $font = Win32::GUI::Font->new(
                -name => "Comic Sans MS", 
                -size => 24,
        );
   
	$main->AddButton(
		-name => "ButtonW1",
		-text => "Send",
		-pos  => [ 350, 380 ],
		#-ok  => 1,
	);
	
	
	$main->AddButton(
		-name => "ButtonW2",
		-text => "Receive",
		-pos  => [ 270, 380 ],
		#-ok  => 1,
	);
	
	my $tf = $main->AddTextfield(
        -name   => "chipfield",
        -left   => 40,
        -top    => 0,
        -width  => 100,
        -height => 20,
        -prompt => "You:",
    );
  
    $main->Show();
	my $new_socket;
	my $client_addr;
	if($client_addr = accept($new_socket, SOCKET)) {
   $new_socket->autoflush;
   my $name = gethostbyaddr($client_addr, AF_INET );
   print "Connection received from $name\n";
   #print $new_socket "Begin the chat\n";
	}

    Win32::GUI::Dialog();

    sub Main_Terminate {	
        -1;	
    }
	
		sub ButtonW1_Click {	
		   my $send = $main->chipfield->Text();
		   chomp $send;
		   print $new_socket "Server:$send\n";
		   
		   state $x =  50;
		   state $y =  35;
		   
		   $y = $y + 30; 
		   my $chipname = $send;
			my $label = $main->AddLabel(
					  -text => "Server:$chipname",
					  -pos => [ $x ,$y ],
					  -foreground => [0, 0, 0],		  
				);
			$main->chipfield->Text("");
			$main->Show();
		}
	
	sub ButtonW2_Click {
	my $recd;	
		   if ($recd = <$new_socket>) {
			   chomp $recd;
			   #print "$recd\n";
		   }
		   
	state $x =  50;
	state $y =  20;
	
	$y = $y + 30; 
    my $chipname = $recd;
	my $label = $main->AddLabel(
              -text => $chipname,
			  -pos => [ $x ,$y ],
              -foreground => [0, 0, 0],		  
        );
	$main->Show();
    #print "$chipname\n";
}
		


	
   