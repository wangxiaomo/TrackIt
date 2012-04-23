
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
        REQUEST     =>  URL::Request->new($param)
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
        if not defined $self->{REQUEST}->{URL};
   
    use LWP::UserAgent;
    my $req   = $self->{REQUEST}->get_req();
    my $ua    = LWP::UserAgent->new;
    my $res   = $ua->request($req);
    if ($res->is_success) {
        return $res->content;
    } else {
        error($res->status_line);
    }
}

sub save_snapshot {
    my ($self, $file) = @_;
    my $res = $self->fetch;

    my $fh;open $fh,">",$file
        or error("cannot open $file!");
    print $fh $res;
    close $fh;
}

sub save {
    my ($self, $file) = @_;
    $self->save_snapshot($file);
}

sub error { croak "ERROR: ", shift, "\n" }

1;

package main;
my $tracker = URL::Tracker->new({x=>3, y=>4});
$tracker->method('GET');
$tracker->url('http://www.baidu.com');
$tracker->save('snapshot.html');
