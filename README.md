# mux
tmuxinator automation pentesting template

## Get started / Installation

MAKE SURE TO RUN THIS ONLY AFTER MOUNTING NOMAD.
```bash
wget https://raw.githubusercontent.com/JaredStemper/mux/main/nomadConfig.sh -O /RSM/nomadConfig.sh
/bin/bash /RSM/nomadConfig.sh
```

## Overview of files

tmuxinator - where the magic happens. Full guide will be included in separate word doc. main thing to remember is order (init-scan, unauthd, misc, authd, local-admin)

nomadConfig.sh - script to pull and organize all the files for this project into the nomad automatically (intended to be ran after ensuring nomad mounting is complete).

prefillTest.py - python script that grabs text and places it onto the command line so that the user can choose to modify it or more carefully track it's runtime.

tmux.conf - the default tmux configurations are somewhat lacking. This helps bridge the gap and adds a lot of power to tmux usage. (highly recommended to read through and understand all capabilities).

tmuxSessionHistoryCapture.sh - script used to periodically log all data currently found in the tmux server. This is especially useful when finishing a project and needing the ability to review every command that was ran once a nomad is disconnected from the client network.

## Learning Tmux

classic guide is [tmuxcheatsheet.com](tmuxcheatsheet.com).


Strong recommendation to read through the provided configuration file and understand what the various lines do.

Pro tips:
* prefix key with provided config is `Ctrl+b`
* `prefix + ,` == rename pane
* `prefix + c` == new window
* `prefix + w` == view all sessions, windows, and panes. Use vim bindings or mouse to quickly switch
* use the mouse to click to other panes/windows
* `prefix + (` == shift to next session (e.g., from initScan to unauth)
* `prefix + )` == shift to prior session
* `prefix + [` == enter copy mode. Use vim key bindings to move cursor; use spacebar to start selection; use either `y` to copy and stay in copy mode or `enter` to copy and break out
* Copy mode can also be entered by highlighting text with the mouse like normal (note: this does not place the highlighted text into your MACHINE'S clipboard, but rather TMUX'S clipboard
* `prefix + ]` == paste the last item copied from copy mode
* `prefix + =` == view all items copied in copy mode (useful to quickly paste various IPs/passphrases)
* Use the `shift + arrow key` to move to other windows quickly
* `prefix + e` ==  set current session path to current pane path (useful if constantly in a different directory and wanting to open up new windows/panes in that new directory)
