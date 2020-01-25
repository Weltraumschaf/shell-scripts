#!/usr/bin/env bash

#
# tmux attach-session -t docker-session
# tmux kill-session -t docker-session

tmux new-session -d -s docker-session

tmux send 'cd /root/docker/locatord && ./start.sh | tee wohnungssuche.log' ENTER;
tmux split-window;
tmux send 'cd /root/docker/wohnungssuche && ./start.sh | tee wohnungssuche.log' ENTER;

tmux select-layout even-vertical
