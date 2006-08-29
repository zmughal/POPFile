VPAT  �?   �a
ϳ�x4ut�C�`���?� |݀g����ˢ  �    PCarp;
use strict;
use vars qw(@ISA $VERSION $DEBUG $ERROR $GLOBAL_CONTEXT_ARGS);q  7��  �2  �}

sub import { foreach (@_) { @ISA=qw(IO::Socket::INET), next if /inet4/i;
			    @ISA=qw(IO::Socket::INET6), next if /inet6/i;
			    $DEBUG=$1 if /debug(\d)/; }�Y  �$self->configure_SSL($arg_hash) || return;

    return ($self->SUPER::configure($arg_hash)
	|| $self->error("@ISA configuration failed"))r2  ��  �
    my $socket = $self->SUPER::connect(@_)
	|| return $self->error("@ISA connect attempt failed");

    return $self->connect_SSL($socket) || $self->fatal_ssl_error;
}


sub connect_SSL {
    my ($self, $socket) = @_;
    my $arg_hash = ${*$self}{'_SSL_arguments'};
    ${*$self}{'_SSL_opened'}=1;

    my $fileno = ${*$self}{'_SSL_fileno'} = fileno($socket);
    return $self->error("Socket has no fileno") unless (defined $fileno);

    my $ctx = ${*$self}{'_SSL_ctx'};  # Reference to real context
    my $ssl = ${*$self}{'_SSL_object'} = Net::SSLeay::new($ctx->{context})
	|| return $self->error("SSL structure creation failed");

    Net::SSLeay::set_fd($ssl, $fileno)
	|| return $self->error("SSL filehandle association failed");

    D�"  �|| return $self->error("Failed to set SSL cipher list");

    my ($addr, $port) = @{$arg_hash}{'PeerAddr','PeerPort'};
    my $session = $ctx->session_cache($addr, $port);
    Net::SSLeay::set_session($ssl, $session) if ($session);

    while (Net::SSLeay::connect($ssl)<1) {
	$self->error("SSL connect attempt failed");
	if ($self->errstr =~ /SSL wants a (write|read) first!/) {
	    require IO::Select;
	    my $sel = new IO::Select($socket);
	    my ($timeout) = grep { defined $_ } (@{$arg_hash}{"Timeout","timeout","io_socket_timeout"});
	    next if (($1 eq 'write') ? $sel->can_write($timeout) : $sel->can_read($timeout));
	}
	return;
    }

    if ($ctx->has_session_cache && !$session) {
	$ctx->session_cache($addr, $port, Net::SSLeay::get1_session($ssl))F  �    my $arg_hash = ${*$self}{'_SSL_arguments'};

    my ($socket, $peer) = $self->SUPER::accept($class)
	or return $self->error("@ISA accept failed");

    $socket->accept_SSL(${*$self}{'_SSL_ctx'}, $arg_hash)
	|| return($self->error($ERROR) || $socket->fatal_ssl_error);

    return wantarray ? ($socket, $peer) : $socket;
}

sub accept_SSL {
    my ($socket, $ctx, $arg_hash) = @_;
    ${*$socket}{'_SSL_arguments'} = { %$arg_hash, SSL_server => 0 };
    ${*$socket}{'_SSL_ctx'} = $ctx;
    ${*$socket}{'_SSL_opened'} = 1;

    my $fileno = ${*$socket}{'_SSL_fileno'} = fileno($socket);
    return $socket->error("Socket has no fileno") unless (defined $fileno);

    my $ssl = ${*$socket}{'_SSL_object'} = Net::SSLeay::new($ctx->{context})
	|| return $socket->error("SSL structure creation failed");

    Net::SSLeay::set_fd($ssl, $fileno)
	|| return $socket->error("SSL filehandle association failed");

    D�"  b|| return $socket->error("Failed to set SSL cipher list");

    while (Net::SSLeay::accept($ssl)<1) {
	$socket->error("SSL accept attempt failed");
	if ($socket->errstr =~ /SSL wants a (write|read) first!/) {
	    require IO::Select;
	    my $sel = new IO::Select($socket);
	    my ($timeout) = grep { defined $_ } (@{$arg_hash}{"Timeout","timeout","io_socket_timeout"});
	    next if (($1 eq 'write') ? $sel->can_write($timeout) : $sel->can_read($timeout));
	}
	return;
    }

    tie *{$socket}, "IO::Socket::SSL::SSL_HANDLE", $socket;
    return $socket;
}


####### I/O subroutines ########################~�&  �
    my $data = $read_func->($ssl, $length);
    return $self->error("SSL read error") unless (defined($data) && length($data));

    my $buffer=\$_[2];
    $length = length($data);
    $$buffer ||= '';
    $offset ||= 0;
    if ($offset > �g(  Q$self->blocking ? \&Net::SSLeay::ssl_read_all :
			       \&Net::SSLeay::read, @_��)  j�*  
    my $buffer = \$_[1];�&+  �
    my $written = Net::SSLeay::ssl_write_all
	($ssl, \substr($$buffer, $offset, $length));

    return $self->error("SSL write error") if (!defined($written) or $written<0);k�-  A
    unless ($\ or $,) {
	foreach my $msg (@_) {
	    next unless defined $msg;
	    defined(Net::SSLeay::write($ssl, $msg))
		|| return $self->error("SSL print error");
	}
    } else {
	defined(Net::SSLeay::write($ssl, join(($, or ''), @_, ($\ or ''))))
	    || return $self->error("SSL print error");
    }
    return 1b�.  "return ${*$self}{'_SSL_fileno'} ||�T5  _j7  
    $arg_hash = ${*$socket}{'_SSL_arguments'};

    my $result = ($arg_hash->{'SSL_server'} 
		  ? $socket->accept_SSL (${*$socket}{'_SSL_ctx'}, $arg_hash)
		  : $socket->connect_SSL($socket));

    return $result ? $socket : (bless($socket, $original_class) && ());<  sub dump_peer_certificateM�@  #p>  �my $name = ($field eq "issuer" or $field eq "authority")
	? Net::SSLeay::X509_get_issuer_name($cert)
	: Net::SSLeay::X509_get_subject_name($cert);

    R?@  0    return Net::SSLeay::X509_NAME_oneline($name)��@  o�A  foreach ($error) {
	if (/ print / || / write / || / read / || / connect / || / accept /) {
	    my $ssl = ${*$self}{'_SSL_object'};
	    my $ssl_error = $ssl ? Net::SSLeay::get_error($ssl, -1) : 0;
	    if ($ssl_error == Net::SSLeay::ERROR_WANT_READ()) {
		$error.="\nSSL wants a read first!";
	    } elsif ($ssl_error == Net::SSLeay::ERROR_WANT_WRITE()) {
		$error.="\nSSL wants a write first!";
	    } else {
		$error.=Net::SSLeay::ERR_error_string
		    (Net::SSLeay::ERR_get_error());
	    }
	}
    }
    carp $error."\n".$self->get_ssleay_error() if $DEBUG;
    ${*$self}{'_SSL_last_err'} = $error if (ref($self));
    $ERROR = $errordE  #�G  �want_read {
    my $self = shift;
    return scalar($self->errstr() =~ /SSL wants a read first!/);
}

sub want_write {
    my $self = shift;
    return scalar($self->errstr() =~ /SSL wants a write first!/);
M
RI                  l
�S                  �^  'True Value'��e  �new IO::Socket::SSL("www.example.com:https");

    if (defined $client) {
        print $client "GET / HTTP/1.0\r\n\r\n";
        print <$client>;
        close $client;
    } else {
        warn "I encountered a problem: ",
        3g  D#�j  �,�  ݎ  T��  dNote that if start_SSL() fails in SSL negotiation, $socket will remain blessed in its original class�$��  � C��e��[   S����έ5�"@������?� |݀g�����5#  �    PCarp;
use strict;
use vars qw(@ISA $VERSION $DEBUG $ERROR $GLOBAL_CONTEXT_ARGS);q�  7�  ��  �}

sub import { foreach (@_) { @ISA=qw(IO::Socket::INET), next if /inet4/i;
			    @ISA=qw(IO::Socket::INET6), next if /inet6/i;
			    $DEBUG=$1 if /debug(\d)/; }��  �$self->configure_SSL($arg_hash) || return;

    return ($self->SUPER::configure($arg_hash)
	|| $self->error("@ISA configuration failed"))��  �key_file'  => $is_server ? 'certs/server-key.pem'  : 'certs/client-key.pem',
	 'SSL_cert_file' => $is_server ? 'certs/server-cert.pem' : 'certs/client-cert.pem'�  )	 'SSL_cipher_list' => 'ALL:!LOW:!EXP');
X3   new IO::Socket::SSL::SSL_Context`�  �b  &
    my $socket = $self->SUPER::connect(@_)
	|| return $self->error("@ISA connect attempt failed");

    return $self->connect_SSL($socket) || $self->fatal_ssl_error;
}


sub connect_SSL {
    my ($self, $socket) = @_;
    my $arg_hash = ${*$self}{'_SSL_arguments'};
    ${*$self}{'_SSL_opened'}=1;

    my $fileno = ${*$self}{'_SSL_fileno'} = fileno($socket);
    return $self->error("Socket has no fileno") unless (defined $fileno);

    my $ctx = ${*$self}{'_SSL_ctx'};  # Reference to real context
    my $ssl = ${*$self}{'_SSL_object'} = Net::SSLeay::new($ctx->{context})
	|| return $self->error("SSL structure creation failed");

    Net::SSLeay::set_fd($ssl, $fileno)
	|| return $self->error("SSL filehandle association failed");

    Net::SSLeay::set_cipher_list($ssl, $arg_hash->{'SSL_cipher_list'})
	|| return $self->error("Failed to set SSL cipher list");

    my ($addr, $port) = @{$arg_hash}{'PeerAddr','PeerPort'};
    my $session = $ctx->session_cache($addr, $port);
    Net::SSLeay::set_session($ssl, $session) if ($session);

    while (Net::SSLeay::connect($ssl)<1) {
	$self->error("SSL connect attempt failed");
	if ($self->errstr =~ /SSL wants a (write|read) first!/) {
	    require IO::Select;
	    my $sel = new IO::Select($socket);
	    my ($timeout) = grep { defined $_ } (@{$arg_hash}{"Timeout","timeout","io_socket_timeout"});
	    next if (($1 eq 'write') ? $sel->can_write($timeout) : $sel->can_read($timeout));
	}
	return;
    }

    if ($ctx->has_session_cache && !$session) {
	$ctx->session_cache($addr, $port, Net::SSLeay::get1_session($ssl))  6    my $arg_hash = ${*$self}{'_SSL_arguments'};

    my ($socket, $peer) = $self->SUPER::accept($class)
	or return $self->error("@ISA accept failed");

    $socket->accept_SSL(${*$self}{'_SSL_ctx'}, $arg_hash)
	|| return($self->error($ERROR) || $socket->fatal_ssl_error);

    return wantarray ? ($socket, $peer) : $socket;
}

sub accept_SSL {
    my ($socket, $ctx, $arg_hash) = @_;
    ${*$socket}{'_SSL_arguments'} = { %$arg_hash, SSL_server => 0 };
    ${*$socket}{'_SSL_ctx'} = $ctx;
    ${*$socket}{'_SSL_opened'} = 1;

    my $fileno = ${*$socket}{'_SSL_fileno'} = fileno($socket);
    return $socket->error("Socket has no fileno") unless (defined $fileno);

    my $ssl = ${*$socket}{'_SSL_object'} = Net::SSLeay::new($ctx->{context})
	|| return $socket->error("SSL structure creation failed");

    Net::SSLeay::set_fd($ssl, $fileno)
	|| return $socket->error("SSL filehandle association failed");

    Net::SSLeay::set_cipher_list($ssl, $arg_hash->{'SSL_cipher_list'})
	|| return $socket->error("Failed to set SSL cipher list");

    while (Net::SSLeay::accept($ssl)<1) {
	$socket->error("SSL accept attempt failed");
	if ($socket->errstr =~ /SSL wants a (write|read) first!/) {
	    require IO::Select;
	    my $sel = new IO::Select($socket);
	    my ($timeout) = grep { defined $_ } (@{$arg_hash}{"Timeout","timeout","io_socket_timeout"});
	    next if (($1 eq 'write') ? $sel->can_write($timeout) : $sel->can_read($timeout));
	}
	return;
    }

    tie *{$socket}, "IO::Socket::SSL::SSL_HANDLE", $socket;
    return $socket;
}


####### I/O subroutines ########################~�'  �
    my $data = $read_func->($ssl, $length);
    return $self->error("SSL read error") unless (defined($data) && length($data));

    my $buffer=\$_[2];
    $length = length($data);
    $$buffer ||= '';
    $offset ||= 0;
    if ($offset > �)  Q$self->blocking ? \&Net::SSLeay::ssl_read_all :
			       \&Net::SSLeay::read, @_��+  �sub write {
    my ($self, undef, $length, $offset) = @_;
    my $ssl = $self->_get_ssl_object || return;

    my $buffer = \$_[1];�-  �
    my $written = Net::SSLeay::ssl_write_all
	($ssl, \substr($$buffer, $offset, $length));

    return $self->error("SSL write error") if (!defined($written) or $written<0);
    return $written;
}

sub printN�2  �unless ($\ or $,) {
	foreach my $msg (@_) {
	    next unless defined $msg;
	    defined(Net::SSLeay::write($ssl, $msg))
		|| return $self->error("SSL print error");
	}
    } else {
	defined(Net::SSLeay::write($ssl, join(($, or ''), @_, ($\ or ''))))
	    || return $self->error("SSL print error");
    }
    return 1;
}

sub printf {
    my ($self,$format) = (shift,shift);
    local $\;
    return $self->print�%2  �return split (/^/, Net::SSLeay::ssl_read_all($ssl));
    }
    my $line = Net::SSLeay::ssl_read_until($ssl);
    return ($line ne '') ? $line : $self->error("SSL read error");cE;  "return ${*$self}{'_SSL_fileno'} ||X�?  
    $arg_hash = ${*$socket}{'_SSL_arguments'};

    my $result = ($arg_hash->{'SSL_server'} 
		  ? $socket->accept_SSL (${*$socket}{'_SSL_ctx'}, $arg_hash)
		  : $socket->connect_SSL($socket));

    return $result ? $socket : (bless($socket, $original_class) && ());{F  ��H  �my $name = ($field eq "issuer" or $field eq "authority")
	? Net::SSLeay::X509_get_issuer_name($cert)
	: Net::SSLeay::X509_get_subject_name($cert);

    R�J  0    return Net::SSLeay::X509_NAME_oneline($name)�\K  o0L  foreach ($error) {
	if (/ print / || / write / || / read / || / connect / || / accept /) {
	    my $ssl = ${*$self}{'_SSL_object'};
	    my $ssl_error = $ssl ? Net::SSLeay::get_error($ssl, -1) : 0;
	    if ($ssl_error == Net::SSLeay::ERROR_WANT_READ()) {
		$error.="\nSSL wants a read first!";
	    } elsif ($ssl_error == Net::SSLeay::ERROR_WANT_WRITE()) {
		$error.="\nSSL wants a write first!";
	    } else {
		$error.=Net::SSLeay::ERR_error_string
		    (Net::SSLeay::ERR_get_error());
	    }
	}
    }
    carp $error."\n".$self->get_ssleay_error() if $DEBUG;
    ${*$self}{'_SSL_last_err'} = $error if (ref($self));
    $ERROR = $errorg�O  Qsub sysread { &IO::Socket::SSL::read; }
sub syswrite { &IO::Socket::SSL::write; }��P  #�Q  �want_read {
    my $self = shift;
    return scalar($self->errstr() =~ /SSL wants a read first!/);
}

sub want_write {
    my $self = shift;
    return scalar($self->errstr() =~ /SSL wants a write first!/);
*yS  read   ѪX  write   ��Y  �,[  
��[                  ��^  ��`  :Net::SSLeay::CTX_use_PrivateKey_file
	    ($ctx, $arg_hash->{'SSL_key_file'}, $filetype)
	    || return IO::Socket::SSL->error("Failed to open Private Key");

	Net::SSLeay::CTX_use_certificate_chain_file
	    ($ctx, $arg_hash->{'SSL_cert_file'})
	    || return IO::Socket::SSL->error("Failed to open Certificate");}7k  "new IO::Socket::SSL::Session_Cacheb�n                  �;p  'True Value'�x  �new IO::Socket::SSL("www.example.com:https");

    if (defined $client) {
        print $client "GET / HTTP/1.0\r\n\r\n";
        print <$client>;
        close $client;
    } else {
        warn "I encountered a problem: ",
        _y  �|  �you do not care for the default list of ciphers ('ALL:!LOW:!EXP'), then look in
the OpenSSL documentation (L<http://www.openssl.org/docs/apps/ciphers.html#CIPHER_STRINGS>),
and specify a different set with this option�1�  ���  �҈  �This requires an unofficial patched version of Net::SSLeay to work; check
the patches directory, or download the altered version at L<http://www.fas.harvard.edu/~behrooz/Net_SSLeay.pm-1.26.tar.gz>.
I have contacted Sampo Kellom�ki about the patch, and he has assured me that it
will appear in the next official release, but that has (as of this writing) not
yet seen the light of CPAN.�̖  �̢  }�  T)�  V~�  original classW#�  new IO::Socket::SSL(...)��  ; have never shipped a module with a known bug, and IO::Socket::SSL is no
different.  If you feel that you have found a bug in the module and you are
using the latest versions of Net::SSLeay and OpenSSL, send an email immediately to
<behrooz at fas.harvard.edu> with a subject of 'IO::Socket::SSL Bug'.  Until very
recently, I did not receive any indication when a bug was submitted to the CPAN
request tracker, so e-mail is a much more reliable tool.  I am
I<not responsible> for problems in your code, so make sure that an example
actually works before sending it. It is merely acceptable if you send me a bug
report, it is better if you send a small chunk of code that points it out,
and it is best if you send a patch--if the patch is good, you might see a release the
next day on CPAN. Otherwise, it could take weeks . . .
th�  ��  =head1 COPYRIGHT�h�  � C��e��