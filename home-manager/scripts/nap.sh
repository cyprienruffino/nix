# Kill the distractions, nap, sound the alarm, then bring everything back.
# pkill -f: match on full command line — electron/zoom wrappers rename their
# processes, so exact-name matching (killall) misses them.
pkill -f ferdium
pkill -f slack
pkill -f zoom
echo "Napping for $1 minutes"
sleep ${1}m && @mpv@/bin/mpv ~/.local/res/alarm.mp4
for app in ferdium slack zoom; do
  if command -v "$app" >/dev/null; then
    "$app" >/dev/null 2>&1 &
    disown
  fi
done
