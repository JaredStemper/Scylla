# mux
tmuxinator automation pentesting template

## Get started / Installation

MAKE SURE TO RUN THIS **_ONLY_** AFTER MOUNTING NOMAD.
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
* The prefix key with default config is `Ctrl+b`
* Anytime a command is typed through the `prefix + :` command prompt, tab completion can be used if you don't recall the exact name of a command (e.g., `"kill-server"` can be found from tabbing `"kill"`) 
* `prefix + w`: view all panes, windows, and sessions. Use vim bindings or mouse to quickly switch (h j k l `+ enter`)
* Panes
  * `prefix + v`: split pane vertically
  * `prefix + s`: split pane horizontally
  * `prefix + ,`: rename pane
  * `prefix + enter`: cycle through all standard pane formatting (useful to quickly resize)
  * `prefix + {` or `prefix + }`: swap pane locations either right or left (useful in changing the pane you're focusing on without hiding the other pane) 
  * `prefix + z`: Zoom! used as a way to "fullscreen" a pane without saving that formatting. The active pane will fill the screen until you shift to another pane or press `prefix + z` again
  * `prefix + arrow key`: used to resize a pane slightly in the direction of the arrow key
  * `prefix  ctrl+arrow key` (two separate key strokes):  while holding the `ctrl` key, rapidly hitting the arrow key will more rapidly change the size of a pane
* Windows
  * `prefix + c`: new window
  * Use the `shift + arrow key` to move to other windows quickly
  * Use the mouse to click to other panes/windows and resize any panes
* Sessions
  * `prefix + (`: shift to next session (e.g., from initScan to unauth)
  * `prefix + )`: shift to prior session
  * `prefix + e`: set current session path to current pane path (useful if constantly in a different directory and wanting to open up new windows/panes in that new directory)
  * `prefix + d`: detach from current session. Now you will be back directly on the terminal and tmux will be running in the background
  * `tmux attach`: ran on the command line to re-attach to your most recent tmux session
  * `tmux kill-session`: kills the current session
* `tmux kill-server`: used to kill all tmux sessions
* Copy/Paste
  * Regular Clipboard
    * `shift + mouse` will highlight things you can use the classic ctrl+shift+c to copy/paste
  * Tmux Clipboard
    * Using your mouse to highlight text automatically copies whatever is highlighted to your Tmux clipboard
    * `prefix + [`: enter copy mode to more carefully copy items
      * Use vim key bindings to move cursor; use spacebar to start selection;
      * Use either `y` to copy and stay in copy mode (useful if in large text files) or `enter` to copy and exit copy mode
    * `prefix + ]`: paste the last item copied from copy mode
    * `prefix + =`: view all items copied in copy mode (useful to quickly paste various IPs/passphrases)
