#!/bin/bash

LOG_DIR="./tmuxLogs"
#LOG_DIR="/tmp/tmuxLogs"

# Create log directory if it doesn't exist
mkdir -p ${LOG_DIR}

# Loop through all tmux sessions
tmux list-sessions -F '#S' | while read -r session_id; do 
  # Set log file path
  log_file="${LOG_DIR}/${session_id}-$(date +%Y-%m-%d_%H-%M-%S).log"

  # Loop through windows in session
  tmux list-windows -t "${session_id}" -F '#W' | while read -r window_id; do 
    # Loop through panes in window
    tmux list-panes -t "${session_id}:${window_id}" -F '#P' | while read -r pane_id; do 
      echo "${session_id}:${window_id}.${pane_id}" | tee -a ${log_file}
      tmux capture-pane -t "${session_id}:${window_id}.${pane_id}" -p -S - >> ${log_file}
	  # -p prints to stdout; -S is where to begin capturing from (with '-' as a special command to get full history)
    done
  done
done

cd $LOG_DIR

