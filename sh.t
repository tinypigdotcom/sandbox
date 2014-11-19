#!/bin/bash
# purpose: [< $purpose >]

VERSION=[< $VERSION >]
PROG=`basename $0`
ERR_EXIT=2

usage_top()   {
    echo "Usage: $PROG [< $params >]" >&2
}

short_usage() {
    usage_top
    echo "Try '$PROG --help' for more information." >&2
}

errout() {
    echo "$PROG: $*" >&2
    short_usage
    exit $ERR_EXIT
}

[< $sl=0;
unshift @options,
{
    long_switch => 'help',
    short_desc  => 'help',
    long_desc   => 'display this help text and exit',
    init        => '0',
    skip_case   => 1,
},
{
    long_switch => 'version',
    short_desc  => 'version',
    long_desc   => 'display version information and exit',
    init        => '0',
    skip_case   => 1,
};
for (@options) {
    my $len = length $_->{short_desc};
    $sl = $len if $len > $sl;
}
>]usage() {

    usage_top
    cat <<EOF_usage >&2
[< $purpose >]
Example: $PROG [< $example >]

[< for (@options) {
    my $ff = substr $_->{long_switch}, 0, 1;
    $_->{one_key} = $ff;
    $_->{varname} = $_->{long_switch};
    $_->{varname} =~ s/\W.*//; # turn backdate=i into backdate
    $OUT .= sprintf(" %3s, --%-${sl}s  $_->{long_desc}\n", "-$ff", $_->{short_desc});
} >]EOF_usage

}

do_short_usage() {
    short_usage
    exit $ERR_EXIT
}

version() {
   echo "$PROG $VERSION" >&2
}

[<
for (@options) {
    my $var = 'OPT_' . uc($_->{varname});
    $out .= "$var=$_->{init}\n";
}
'';
$single_keys='';
@long_opts=();
for (@options) {
    my $sk = $_->{long_switch};
    $sk =~ s/(\w)\w*(.*)/$1$2/;
    if ( $2 ) {
        $_->{has_arg}=1;
    }
    $single_keys .= $sk;
    push @long_opts, $_->{long_switch};
}
$long_opts = join ',', @long_opts;
'';
>]OPTS=`getopt -o [< $single_keys >] -l '[< $long_opts >]' -- "$@"`
if [ $? != 0 ]; then
    short_usage
    exit $ERR_EXIT
fi

eval set -- "$OPTS"

while [ $# -gt 0 ]
do
    case "$1" in
               -h) do_short_usage
                   ;;
           --help) usage
                   exit
                   ;;
   -v | --version) version
                   exit
                   ;;
[<
for (@options) {
    next if $_->{skip_case};
    my $var = 'OPT_' . uc($_->{varname});
    my $ext = '';
    if ( $_->{has_arg} ) {
        $ext = '; OPT_' . uc($_->{varname}) . '_ARG=$2; shift';
    }
    $OUT .= sprintf(" %17s $var=1$ext\n", "-$_->{one_key} | --$_->{varname})");
    $OUT .= "                   ;;\n";
}
>]               --) shift
                   break
                   ;;
                *) errout "Invalid option: $1"
                   ;;
    esac
    shift
done
[< $CODE >]
