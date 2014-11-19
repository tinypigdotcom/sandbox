#!/bin/bash
# <- my $code = <<'END_OF_CODE';

if [ "$#" -lt 1 ]; then
    do_short_usage
fi

cd /www
b=-1
while read a
do
    let b=b+1
    file[b]=$a
done < <(find . -iname "*$**" )

let i=0
until [ "$i" -gt "$b" ]
do
    echo "$i ${file[$i]}"
    let i=i+1
done

echo
f
echo -n "f "
read key index

f $key ${file[$index]}
# <- END_OF_CODE
# <- my $init = <<'END_OF_INIT';
# <- OPT_yesterday=0;
# <- OPT_backdate=0;
# <- END_OF_INIT
# <- $VAR1 = {
# <-     VERSION => '0.0.6',
# <-     purpose => 'Search for a file and add it to the current "p" project.',
# <-     example => 'menu.h',
# <-     CODE    => $code,
# <-     INIT    => $init,
# <-     target  => "$ENV{HOME}/bin/af",
# <-     options => [
# <-         {
# <-             long_switch => 'bitchin',
# <-             short_desc  => 'bitchin',
# <-             long_desc   => 'specify if you are bitchin',
# <-         },
# <-         {
# <-             long_switch => 'friends:',
# <-             short_desc  => 'friends=#FRIENDS',
# <-             long_desc   => 'how many friends do you have?',
# <-         },
# <-         {
# <-             long_switch => 'awesome::',
# <-             short_desc  => 'awesome[=1-10]',
# <-             long_desc   => "awesome? if so, how much on 1-10 scale",
# <-         },
# <-     ],
# <- };
