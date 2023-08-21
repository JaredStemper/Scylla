# mux
tmuxinator pentesting template

tmuxinator - where the magic happens. Full guide will be included in separate word doc. main thing to remember is order (init-scan, unauthd, misc, authd, local-admin)

nomadConfig.sh - script to pull and organize all the files for this project into the nomad automatically (intended to be ran after ensuring nomad mounting is complete).

prefillTest.py - python script that grabs text and places it onto the command line so that the user can choose to modify it or more carefully track it's runtime.

tmux.conf - the default tmux configurations are somewhat lacking. This helps bridge the gap and adds a lot of power to tmux usage. (highly recommended to read through and understand all capabilities).

tmuxSessionHistoryCapture.sh - script used to periodically log all data currently found in the tmux server. This is especially useful when finishing a project and needing the ability to review every command that was ran once a nomad is disconnected from the client network.
