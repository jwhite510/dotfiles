#!/bin/bash

SESSION_NAME="session_$(date '+%s%N' | sha256sum | base64 | head -c 8 ; echo)"

# Start a new tmux session named "my_session"
tmux new-session -d -s $SESSION_NAME -n "0"

# Run a command in the newly created tmux window
tmux send-keys -t $SESSION_NAME:0 "cd ~/.nvimsessions/" C-m

tmux send-keys -t $SESSION_NAME:0 "ls -latr1" C-m

tmux send-keys -t $SESSION_NAME:0 "nvim -S "

# Attach to the tmux session
tmux attach-session -t $SESSION_NAME

