#!/bin/sh

xrandr --output DP-4 --mode 1920x1080 --primary --rate 144 --output HDMI-0 --mode 2560x1440 --rate 60 --left-of DP-4
xset r rate 600 25 &
feh --bg-fill ~/Pictures/linux-retro_5120x2880.jpg &
picom &

# relaunch DWM if the binary changes, otherwise bail
csum=""
new_csum=$(sha1sum $(which dwm))
dash ~/.config/chadwm/scripts/bar.sh &
while true
do
    if [ "$csum" != "$new_csum" ]
    then
        csum=$new_csum
        dwm
    else
        exit 0
    fi
    new_csum=$(sha1sum $(which dwm))
    sleep 0.5
done
