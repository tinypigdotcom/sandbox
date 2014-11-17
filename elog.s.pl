#!/usr/bin/perl
# <- my $code = <<'END_OF_CODE';

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Duration;
use File::Basename;
use Getopt::Long;
use IO::File;

#pre
my $yesterday; #->
my $backdate;  #->
#post

if ( $yesterday ) {
    $backdate = 1;
}

my $today = DateTime->now( time_zone => 'local' )->set_time_zone('floating')
  ->subtract( days => $backdate );
if ($backdate) {
    $today->set_hour(18);
    $today->set_minute(0);
    $today->set_second(0);
}

my $current_year    = $today->year;
my $current_month   = $today->month;
my $current_day     = $today->day;
my $current_hour    = $today->hour;
my $current_minutes = $today->minute;
my $current_seconds = $today->second;

my $file_path = '/cygdrive/c/TuSC/file';
opendir( my $dh, $file_path ) || die "can't opendir $file_path: $!";
my @files = grep { /^\wl/ && -f "$file_path/$_" } readdir($dh);
closedir $dh;

my $previous_work_item = 'deadbeef';

my $elog_file = "$ENV{HOME}/.tmp.elog";
my $ofh = IO::File->new( $elog_file, '>' );
die if ( !defined $ofh );

output("# Report for ", $today->strftime('%D'), "\n");
my $remove_line = "REMOVE THIS LINE TO COMMIT CHANGES";
output("$remove_line\n");

sub output {
    my $out_line = join( '', @_ );
    print $ofh $out_line;
    return;
}

sub file_to_datetime {
    my ($file)      = @_;
    my @field       = split /[_\.]/, $file;
    return (
        $field[2], # item_month
        $field[3], # item_day
        $field[1], # item_year
        $field[4], # item_hour
        $field[5], # item_minute
        $field[6], # item_second
    );
}

# wl_2014_09_09_14_21_26.txt
sub datetime_to_file {
    my ($item_month,
        $item_day,
        $item_year,
        $item_hour,
        $item_minute,
        $item_second) = @_;

        $item_year   //= $current_year;
        $item_month  //= $current_month;
        $item_day    //= $current_day;
        $item_hour   //= $current_hour;
        $item_minute //= $current_minutes;
        $item_second //= $current_seconds;

    my $basefile = sprintf("wl_%04d_%02d_%02d_%02d_%02d_%02d.txt",
        $item_year,
        $item_month,
        $item_day,
        $item_hour,
        $item_minute,
        $item_second,
    );
    return $basefile;
}

my @remove;
for my $file (@files) {
    my ($item_month,
        $item_day,
        $item_year,
        $item_hour,
        $item_minute,
        $item_second) = file_to_datetime($file);

    datetime_to_file ($item_month,
                      $item_day,
                      $item_year,
                      $item_hour,
                      $item_minute,
                      $item_second);

    my $full_path = "$file_path/$file";
    open IN, $full_path or die "Can't open file $file: $!";
    my $work_item = join( '', <IN> );
    close IN;

    $work_item =~ s/[\x0a\x0d]//msg;
    if (    $current_month == $item_month
        and $current_day == $item_day
        and $current_year == $item_year )
    {
        output("$item_hour:$item_minute:$item_second...$work_item\n");
        push @remove, $full_path;
    }
}

$ofh->close;

my $editor = $ENV{EDITOR} || 'vim';
system("$editor $elog_file");

sub write_entry {
    my ($file, $entry) = @_;
    my $full_path = "/cygdrive/c/TuSC/file/$file";
    my $ofh = IO::File->new($full_path, '>');
    die if (!defined $ofh);

    print $ofh "$entry\n";
    $ofh->close;
}

my $ifh = IO::File->new($elog_file, '<');
die if (!defined $ifh);

my @lines = <$ifh>;

for ( @lines ) {
    if ( /$remove_line/ ) {
        print "No change.\n";
        exit;
    }
}

my @failed;
foreach my $file ( @remove ) {
    unlink $file or push @failed, $file;
}
if ( @failed ) {
    warn 'Could not remove: ' . Dumper(\@failed);
}

for my $line ( @lines ) {
    next if $line =~ /^\s*#/;
    chomp $line;
    my ($time,$entry) = split /\.\.\./, $line;
    my @hms = split /:/, $time;
    my $file = datetime_to_file(undef, undef, undef, @hms);
    write_entry($file,$entry);
}
$ifh->close;

# <- END_OF_CODE
# <- my $init = <<'END_OF_INIT';
# <- my $yesterday = 0;
# <- my $backdate  = 0;
# <- END_OF_INIT

# <- $VAR1 = {
# <-     VERSION => '1.04',
# <-     purpose => 'edit work log',
# <-     CODE    => $code,
# <-     INIT    => $init,
# <-     options => [
# <-         {
# <-             long_switch => 'backdate=i',
# <-             short_desc  => 'backdate=#DAYS',
# <-             long_desc   => 'edit # days ago instead of today',
# <-         },
# <-         {
# <-             long_switch => 'yesterday',
# <-             short_desc  => 'yesterday',
# <-             long_desc   => "edit yesterday's data instead of today's",
# <-         },
# <-     ],
# <- };

