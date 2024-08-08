#!/bin/bash

update() {
  IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')
  IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
  source "$CONFIG_DIR/icons.sh"
  # airport cli is deprecated
  # INFO="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: '  '/ SSID: / {print $2}')"
  LABEL="$IP_ADDRESS"
  COLOR="$BACKGROUND_1"
  if [[ "$IS_VPN" != "" ]]; then
    COLOR=$CYAN
    ICON="$VPN"
    LABEL="VPN"
  elif [ -n "$IP_ADDRESS" ]; then
    ICON="$WIFI_CONNECTED"
    animate_close
  else
    ICON="$WIFI_DISCONNECTED"
    animate_close
  fi
  sketchybar --animate sin 10 --set $NAME icon="$ICON" label="$LABEL" background.color=$COLOR
  if [[ "$IS_VPN" != "" ]]; then
    animate_open
  fi
}

animate_open() {
  WIDTH=dynamic
  sketchybar --animate sin 10 --set $NAME label.width="$WIDTH"
}

animate() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"
  WIDTH=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi
  sketchybar --animate sin 10 --set $NAME label.width="$WIDTH"
}

animate_close() {
  WIDTH=0
  sketchybar --animate sin 10 --set $NAME label.width="$WIDTH"
}

click() {
  IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')
  if [ "$IS_VPN" = "" ]; then
    animate
  fi
}

case "$SENDER" in
"wifi_change")
  update
  ;;
"mouse.clicked")
  click
  ;;
esac
