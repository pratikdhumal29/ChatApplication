use strict;
use Socket;
use Win32::GUI();
use feature 'state';
	
# use port 7890 as default
my $port = shift || 7890;
my $proto = getprotobyname('tcp');
my $server = "localhost";  # Host IP running the server

# create the socket, connect to the port	
socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "Can't create a socket $!\n";
connect( SOCKET, pack_sockaddr_in($port, inet_aton($server)))
   or die "Can't connect to port $port! \n";

    my $text = defined($ARGV[0]) ? $ARGV[0] : "Hello, world";

    my $main = Win32::GUI::Window->new(
                -name => 'Main',
                -text => 'Client',
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
	my $line;
	use IO::Handle;
	SOCKET->autoflush;
	
	Win32::GUI::Dialog();

    sub Main_Terminate {	
        -1;	
    }
	
		sub ButtonW1_Click {	
		   my $send = $main->chipfield->Text();
		   chomp $send;   
			print SOCKET "Client:$send\n";
		   
		   state $x =  50;
		   state $y =  20;
		   
		   $y = $y + 30; 
		   my $chipname = $send;
			my $label = $main->AddLabel(
					  -text => "Client:$chipname",
					  -pos => [ $x ,$y ],
					  -foreground => [0, 0, 0],		  
				);
			$main->chipfield->Text("");
			$main->Show();
		}
	
	sub ButtonW2_Click {
	my $line;
	if ($line = <SOCKET>) {
    chomp $line;
    #print "$line\n";					#Received from server
	}
	state $x =  50;
	state $y =  35;
	
	$y = $y + 30; 
    my $chipname = $line;
	my $label = $main->AddLabel(
              -text => $chipname,
			  -pos => [ $x ,$y ],
              -foreground => [0, 0, 0],		  
        );
	$main->Show();
    #print "$chipname\n";
}
		


	
   