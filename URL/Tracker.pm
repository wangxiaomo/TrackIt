
package URL::Tracker;
use warnings;
use strict 'vars';
use vars qw/$AUTOLOAD/;

use Smart::Comments;
use Carp qw/carp croak/;

sub new {
    my $class = shift;
    my $param = shift || {};
    my $self  = {
        map { uc($_) => $param->{$_} } keys %$param
    };
    bless $self, $class;
}

sub AUTOLOAD {
    my $self  = shift;
    $AUTOLOAD =~ s/.*:://;
    $self->{uc($AUTOLOAD)} = shift if scalar @_;
    return $self->{uc($AUTOLOAD)};
}

sub fetch {
    my $self  = shift;
    croak "haven't set the url to fetch!"
        if not defined $self->{URL};
    print $self->{METHOD};
    print $self->{URL};
   
    use LWP::UserAgent;
    use HTTP::Request;
    my $ua    = LWP::UserAgent->new;
    my $req   = HTTP::Request->new(
            $self->{METHOD},
            $self->{URL},
    );
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
