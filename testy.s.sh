#!/bin/bash
# <- my $code = <<'END_OF_CODE';

#if [ "$#" -lt 1 ]; then
#    do_short_usage
#fi

echo "OPT_BITCHIN={$OPT_BITCHIN}"
echo "OPT_FRIENDS={$OPT_FRIENDS}"
echo "OPT_FRIENDS_ARG={$OPT_FRIENDS_ARG}"
echo "OPT_AWESOME={$OPT_AWESOME}"
echo "OPT_AWESOME_ARG={$OPT_AWESOME_ARG}"
echo "Done."

# <- END_OF_CODE
# <- $VAR1 = {
# <-     VERSION => '0.0.1',
# <-     params  => '',
# <-     purpose => 'this script is not interesting',
# <-     example => '',
# <-     CODE    => $code,
# <-     target  => "$ENV{HOME}/bin/testy",
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
