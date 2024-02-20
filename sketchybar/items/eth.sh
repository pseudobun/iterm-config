#!/bin/bash

eth_icon=(
    popup.horizontal=on
    padding_right=6
    update_freq=900
    icon=$ETH
    label=?
    icon.font="$FONT:Regular:15.0"
    icon.color=$BLUE
    popup.align=right
    script="$PLUGIN_DIR/eth.sh"
)

eth_price=(
    drawing=off
    background.corner_radius=12
    padding_left=7
    padding_right=7
)

sketchybar --add event eth.update \
    --add item eth.icon right \
    --set eth.icon "${eth_icon[@]}" \
    \
    --add item eth.price popup.eth.icon \
    --set eth.price "${eth_price[@]}" \
    --subscribe eth.icon mouse.entered \
    mouse.exited \
    mouse.exited.global \
    eth.update
