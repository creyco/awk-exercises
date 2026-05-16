#!/bin/bash
tmux send-keys -t openclaude Enter && sleep 8 && tmux capture-pane -t openclaude -p | head -150

# salir de tmux  Ctrl+b luego d
