package App::Rad::Plugin::ValuePriority;

use warnings;
use strict;

=head1 NAME

App::Rad::Plugin::ValuePriority - The great new App::Rad::Plugin::ValuePriority!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub load {
   my $c = shift;
   $c->set_priority(qw/options config stash default_value/);
}

sub default_value {
   my $c     = shift;
   $c->{default_value}->{default_value} = {} unless exists $c->{default_value}->{default_value};
   $c->{default_value}->{default_value};
}

sub set_priority {
   my $c    = shift;
   my @prio = @_;
   my @nprio;
   die((join ", ", @nprio), " are not recognized.$/")
      if scalar (@nprio = grep {not m/^(?:options|config|stash|default_value)$/} @prio);
   $c->{default_value}->{priority} = [@prio];

}

sub get_priority {
   my $c = shift;
   $c->{default_value}->{priority};
}

sub to_stash {
   my $c = shift;
   for my $func (@{ $c->{default_value}->{priority} }) {
      my $turn = $c->$func;
      for my $key (keys %{ $c->$func }) {
         next if exists $c->stash->{$key} and defined $c->stash->{$key};
         $c->stash->{$key} = $turn->{$key} if exists $turn->{$key}
      }
   }
}

sub value {
   my $c    = shift;
   my $redo = shift;
   my $ret;
   if($redo or not exists $c->{default_value}->{"values"}) {
      for my $func (@{ $c->{default_value}->{priority} }) {
         my $turn = $c->$func;
         for my $key (keys %$turn) {
            next if exists $ret->{$key} and defined $c->stash->{$key};
            $ret->{$key} = $turn->{$key} if exists $turn->{$key};
         }
      }
   }
   $c->stash->{default_value}->{"values"} = $ret;
   $c->stash->{default_value}->{"values"};
}



42
