# Note: uses xinput (X11). May not work under Wayland.
INPUTID=$(@xinput@/bin/xinput list | grep ouchpad | sed -E 's/(.*)id=(.*)/\2/' | sed -E 's/(.*)\[(.*)/\1/')
if [ -f ".tpadlock" ]; then
  rm .tpadlock
  @xinput@/bin/xinput enable $INPUTID
else
  touch .tpadlock
  @xinput@/bin/xinput disable $INPUTID
fi
