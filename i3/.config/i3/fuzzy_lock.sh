#!/bin/bash

# Take a screenshot
scrot /tmp/screen.png

# Pixellate it 10x
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

# add lock icon
[[ -f $1  ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png

# pause  neteasy-cloud-music
#dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cloudmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause

# Lock screen with this image
i3lock -i /tmp/screen.png

# Delete image 
rm /tmp/screen.png

# Turn the screen off after a delay.
sleep 60
if [ $(pgrep -c i3lock) -ne 0 ]
  then
    xset dpms force off
fi

# resume neteasy-cloud-music
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cloudmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
