#!/bin/sh

# Install aspell
ASPELL=$(which aspell)
if [ $? != 0 ]; then
  brew install aspell
fi

# Generate the custom dictionary.
aspell --lang=en create master /tmp/en-anas.pws < anas_wordlist.txt
cp /tmp/en-anas.pws /usr/local/lib/aspell*
