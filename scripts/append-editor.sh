#!/bin/sh
# Non-interactive stand-in for an editor: appends one line to the file lockbook edit hands it.
printf 'edited-by-script\n' >> "$1"
