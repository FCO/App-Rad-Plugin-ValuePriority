use Test::More;

BEGIN{ use_ok("App::Rad", qw"ValuePriority"); }

can_ok("App::Rad", "run");

my $c = bless {}, App::Rad;

$c->_init;

can_ok($c, "load");
can_ok($c, "default_value");
can_ok($c, "set_priority");
can_ok($c, "get_priority");
can_ok($c, "to_stash");
can_ok($c, "value");

ok($c->load);

is_deeply($c->get_priority, [qw/options config stash default_value/]);
ok($c->set_priority(qw/config stash default_value options/));
is_deeply($c->get_priority, [qw/config stash default_value options/]);

done_testing;
