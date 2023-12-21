#!/bin/bash

networkup=(
    script="$PLUGIN_DIR/network.sh"
    update_freq=1
    padding_left=2
    padding_right=2
    background.border_width=0
    background.height=24
    icon=⇡
    icon.color=$YELLOW
    label.color=$YELLOW
)

networkdown=(
    script="$PLUGIN_DIR/network.sh"
    update_freq=4
    padding_left=8
    padding_right=2
    background.border_width=0
    background.height=24
    icon=⇣
    icon.color=$GREEN
    label.color=$GREEN
)


sketchybar --add item  network.up right                              \
           --set       network.up "${networkup[@]}"                    \
           --add item  network.down right                            \
           --set       network.down "${networkdown[@]}"                \