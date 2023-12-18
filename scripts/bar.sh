#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/dwm/scripts/bar_themes/gruvbox

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$pink^^b$black^^c$black^^b$pink^ "
  printf "^c$pink^^b$grey^ $cpu_val^c$grey^^b$black^"
}

volume() {
  volume=$(echo $(amixer sget Master) | awk -F"[][]" '/Left:/ { print $2 }' | sed 's#%##')
  printf "^c$yellow^^b$black^^c$black^^b$yellow^󰋋 ^c$yellow^^b$grey^"
  printf " $volume"
  printf "^c$grey^^b$black^"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  printf "   ^c$green^^b$black^^c$black^^b$green^ ^c$green^^b$grey^"
  if [ "$updates" -eq "0" ]; then
    printf " Fully Updated"
  else
    printf " $updates updates"
  fi
  printf "^c$grey^^b$black^"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$orange^^b$black^^c$black^^b$orange^ "
  printf "^c$orange^^b$grey^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
  printf "^c$grey^^b$black^"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$green^^b$black^^c$black^^b$green^󰤨 ^d^%s" "^c$green^^b$grey^ Connected" ;;
  down) printf "^c$red^^b$black^^c$black^^b$red^󰤭 ^d^%s" "^c$red^^b$grey^ Disconnected" ;;
	esac
  printf "^c$grey^^b$black^"
}

clock() {
	printf "^c$blue^^b$black^^c$black^^b$blue^󱑆 ^c$blue^^b$grey^"
	printf "^c$blue^^b$grey^ $(date '+%H:%M')^c$grey^^b$black^"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(volume) $(cpu) $(mem) $(clock)"
done
