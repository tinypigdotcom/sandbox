Title: TEMPLATE_TITLE1
Author: David M. Bradford
css: table.css
Base Header Level:  2

The point of this article is to describe how to refactor lots of nested if-then code
Normal text with some `code`.

    print "a block of code";
    print "indent with spaces";

    use Data::Dumper;
    use Try::Tiny;

    sub perform_item_update {
    }

    sub complex_function {
        print "I am b.pl\n";
        my $input;
        my $option;
        my $user_admin_level;
        if ($input) {
            if ($option eq 'update_item') {
                if ($user_admin_level >= 1) {
                    my $error = '';
                    try {
                        perform_item_update();
                    } catch {
                        $error = $_;
                    };
                    if ($error) {
                        warn "Error $error occurred";
                    }
                    else {
                        print "Item successfully updated.\n";
                    }
                }
                else {
                    warn "Insufficient privileges!";
                }
            }
        }
        else {
            print "No input!\n";
        }
    }

    sub refactored_function {
        print "I am b.pl\n";
        my $processing_input;
        my $this_option_selected;
        my $has_permission;
        my $update_was_successful;
        if ($processing_input) {
            if ($this_option_selected) {
                if ($has_permission) {
                    if ($update_was_successful) {
                    }
                }
            }
        }
        else {
            print "No input!";
        }
    }

    sub main {
        my @argv = @_;
        print Dumper(\@argv);
        refactored_function();
        return;
    }

    my $rc = ( main(@ARGV) || 0 );

    exit $rc;

    #      try {
    #        die "foo";
    #      } catch {
    #        warn "caught error: $_"; # not $@
    #      };


   A       | Dang         | Table
  -------- | ------------ | -------------------------------------------
   1       | `formatted`  | whatever
   2       | `code`       | blah blah

This is a link [Nice Text](http://actual.uri.com)

A link to an image:

![](fix_lines.gif)

