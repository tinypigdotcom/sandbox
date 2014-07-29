#!/usr/bin/perl

use Modern::Perl '2014';

package My_Modern_Perl v1.1.0;
{

    use Carp;
    use Data::Dumper;
    use Hash::Util qw(lock_keys);
    use Test::More tests => 7;
    our $VAR1;

    my $persist_file = "$ENV{HOME}/.My_Modern_Perl";
    my $do_persist = 1;
    my @keys = qw(
      argv
      bar
      foo
      bar
    );

    sub new {
        my ($class) = @_;

        my $self = { };
        bless $self, $class;
        thaw(\$self);
        lock_keys( %$self, @keys );

        return $self;
    }

    sub run {
        my ($self,@argv) = @_;
        $self->{argv} = \@argv;

        $self->modern_perl_stuff();
        $self->message();
        $self->{foo} = 3;
        $self->{bar} = {name=>'baz'};
        $self->freeze();
        return 0; # return for entire script
    }

    sub modern_perl_stuff {
        my ($self) = @_;
        $self->array_by_index();
        $self->merge_two_hashes();
        $self->get_unique();
        $self->regex_K();
    }

    sub regex_K {
        my ($self) = @_;
        my $exclamation = 'This is a catastrophe!';
        $exclamation =~ s/cat\K\w+!/./;
        is($exclamation, 'This is a cat.', 'regex_K');
    }

    sub array_by_index {
        my ($self) = @_;

        my @fruits = qw(apples oranges bananas pears);
        my @output;
        while (my ($index,$value) = each @fruits) { #*
            push @output, "$index: $value";
        }
        is_deeply(\@output,
                  [ "0: apples",
                    "1: oranges",
                    "2: bananas",
                    "3: pears", ],
                    'array_each');
        local $" = ')('; my $output = "(@fruits)"; #*
        is($output, '(apples)(oranges)(bananas)(pears)', 'mjd_debug');
    }

    sub merge_two_hashes {
        my ($self) = @_;
        my %fruits = (
            grape => 7,
            watermelon => 9,
        );
        my %vegetables = (
            celery => 3,
            carrot => 5,
        );
        @vegetables{ keys %fruits } = values %fruits;
        is_deeply(
            \%vegetables,
            { grape => 7,
              watermelon => 9,
              celery => 3,
              carrot => 5,
            },
            'merge_two_hashes',
        );
    }

    sub get_unique {
        my ($self) = @_;
        my @list = qw(robots tigers monsters robots monsters cheetahs dogs);
        my %uniq;
        undef @uniq{ @list };
        @list = sort { $a cmp $b } keys %uniq;
        is_deeply(
            \@list,
            [ 'cheetahs', 'dogs', 'monsters', 'robots', 'tigers' ],
            'get_unique',
        );
    }

    sub message {
        my ($self) = @_;
        my $message = 'howdy';
        is($message, 'howdy', 'message');
    }

    sub thaw {
        return unless $do_persist;

        my ($self) = @_;

        my $ifh = IO::File->new($persist_file, '<');
        return if (!defined $ifh);

        my $contents = do { local $/; readline $ifh }; #*
        $ifh->close;

        ${$self} = eval $contents;
        if ( !defined $self ) {
            croak "failed eval of dump";
        }
        my %saved_args = %$$self;
        is_deeply(\%saved_args,
                  {
                    'argv' => [],
                    'bar' => {
                                'name' => 'baz'
                            },
                    'foo' => 3
                   },
         , 'persistance');

    }

    sub freeze {
        return unless $do_persist;

        my ($self) = @_;

        my $ofh = IO::File->new($persist_file, '>');
        croak "Failed to open output file: $!" if (!defined $ofh);

        print $ofh Dumper($self);
        $ofh->close;
    }

}

package main;

say My_Modern_Perl->VERSION();
my $app = My_Modern_Perl->new();
exit $app->run(@ARGV);



__END__
      # or
      use Test::More skip_all => $reason;
      # or
      use Test::More;   # see done_testing()

      BEGIN { use_ok( 'Some::Module' ); }
      require_ok( 'Some::Module' );

      # Various ways to say "ok"
      ok($got eq $expected, $test_name);

      is  ($got, $expected, $test_name);
      isnt($got, $expected, $test_name);

      # Rather than print STDERR "# here's what went wrong\n"
      diag("here's what went wrong");

      like  ($got, qr/expected/, $test_name);
      unlike($got, qr/expected/, $test_name);

      cmp_ok($got, '==', $expected, $test_name);

      is_deeply($got_complex_structure, $expected_complex_structure, $test_name);

      SKIP: {
          skip $why, $how_many unless $have_some_feature;

          ok( foo(),       $test_name );
          is( foo(42), 23, $test_name );
      };

      TODO: {
          local $TODO = $why;

          ok( foo(),       $test_name );
          is( foo(42), 23, $test_name );
      };

      can_ok($module, @methods);
      isa_ok($object, $class);

      pass($test_name);
      fail($test_name);

      BAIL_OUT($why);

      # UNIMPLEMENTED!!!
      my @status = Test::More::status;

