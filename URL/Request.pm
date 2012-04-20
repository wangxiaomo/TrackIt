
package URL::Request;
use warnings;
use strict 'vars';
use vars qw/$AUTOLOAD/;
use Carp qw/carp croak/;

use HTTP::Request;

my $EXCEPTION = ">======== EXCEPTION CAUGHT HERE =========<\n";

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

sub get_req {
    my $self  = shift;
    croak $EXCEPTION, "URL Required!"
        if not defined $self->{URL};

    if (uc($self->{METHOD}) eq 'GET') {
        # METHOD: get
        return HTTP::Request->new(GET=>$self->{URL},  $self->{HEADER});
    } elsif (uc($self->{METHOD}) eq 'POST') {
        # METHOD: post
        return HTTP::Request->new(POST=>$self->{URL}, $self->{HEADER});
    } else {
        # METHOD error
        croak $EXCEPTION, "Request Method Error!";
    }
}

1;

__END__
package main;

use LWP::UserAgent;
my $request = URL::Request->new;
$request->url('htt://www.baxidu.com');
$request->method('get');
my $req = $request->get_req();
my $ua  = LWP::UserAgent->new;
my $res = $ua->request($req);
print $res->status_line, "\n";
