
package URL::Tracker;
use warnings;
use strict 'vars';
use vars qw/$AUTOLOAD/;

use Smart::Comments;
use Carp qw/carp croak/;

BEGIN { unshift @INC, '..' }

use URL::Request;

sub new {
    my $class = shift;
    my $param = shift || {};
    my $self  = {
        REQUEST     =>  URL::Request->new($param);
    };
    bless $self, $class;
}

sub AUTOLOAD {
    my $self  = shift;
    $AUTOLOAD =~ s/.*:://;
    $self->{REQUEST}->{uc($AUTOLOAD)} = shift if scalar @_;
    return $self->{REQUEST}->{uc($AUTOLOAD)};
}

sub fetch {
    my $self  = shift;
    croak "haven't set the url to fetch!"
        if not defined $self->{URL};
    print $self->{REQUEST}->{METHOD};
    print $self->{REQUEST}->{URL};
   
    use LWP::UserAgent;
    my $req   = $self->{REQUEST}->get_req();
    my $res   = $ua->request($req);
    if ($res->is_success) {
        use Data::Dumper;
        print Dumper($res);
    } else {
        error($res->status_line);
    }
}

sub error { print "ERROR: ", shift, "\n" }

1;

package main;
my $tracker = URL::Tracker->new({x=>3, y=>4});
$tracker->method('GET');
$tracker->url('http://www.baidu.com');
$tracker->fetch;

use Data::Dumper;
print Dumper($tracker);
