killall electron
echo "Napping for $1 minutes"
sleep ${1}m && @mpv@/bin/mpv ~/.local/res/alarm.mp4
ferdium & disown
