#!/bin/bash
cd ~/Library/Mobile\ Documents/iCloud~com\~strongbox/Documents/kdbxs
git add --all
git commit -aS -m "chore: backup $(date +"%d-%m-%Y %H:%M:%S")"
git push
