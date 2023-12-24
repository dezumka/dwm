#!/bin/sh

xrandr --output DP-4 --mode 1920x1080 --primary --rate 144 --output HDMI-0 --mode 2560x1440 --rate 60 --left-of DP-4
xset r rate 660 25 &
feh --bg-fill ~/Pictures/gruvbox_astro.jpg
picom &

# relaunch DWM if the binary changes, otherwise bail
csum=""
new_csum=$(sha1sum $(which dwm))
dash ~/.config/dwm/scripts/bar.sh &
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
