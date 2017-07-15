#!/bin/sh

#gnome-terminal -x cat /dev/rfcomm0 & PIDSERTERM=$!
#gnome-terminal -x sudo rfcomm connect /dev/rfcomm0 34:81:F4:27:D7:71 8 &
#gnome-terminal -x cat /dev/rfcomm0
#wait $PIDSER
#wait $PIDSERTERM

$(gnome-terminal -x rfcomm connect /dev/rfcomm0 34:81:F4:27:D7:71 8 && sleep 1 && gnome-terminal -x cat /dev/rfcomm0 )




exit 0

$(gnome-terminal -x rfcomm connect /dev/rfcomm0 34:81:F4:27:D7:71 8 && sleep 1 & )
$(gnome-terminal -x cat /dev/rfcomm0 )

echo "starting terminal #1"
gnome-terminal -x rfcomm connect /dev/rfcomm0 34:81:F4:27:D7:71 8 &
echo "done"

sleep 1

echo "starting terminal #2"
gnome-terminal -x cat /dev/rfcomm0 &
echo "done"

exit 0
