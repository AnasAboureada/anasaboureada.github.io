#!/bin/sh

echo "[-] Removing the old dict"
rm -f /usr/local/lib/aspell-0.60/en-anas.pws

echo "[+] Creating new dict from anas_wordlist.txt"
aspell --lang=en create master /tmp/en-anas.pws < anas_wordlist.txt
cp /tmp/en-anas.pws /usr/local/lib/aspell*
