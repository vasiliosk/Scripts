#!/bin/bash

NAME="PS/2 Logitech Wheel Mouse"
STATUS=$(xinput list-props "$NAME" | grep -e "Device Enabled" | cut -c 23-60)
TPAD=$(xinput list | grep -e "$NAME" | cut -c 55-56)


#echo $NAME
#echo $STATUS
#echo $TPAD


if [ $STATUS = '1' ]; then
	xinput set-prop $TPAD "Device Enabled" 0
	printf "\n\t===\tTouchpad Disabled\t===\n\n"
else
	xinput set-prop $TPAD "Device Enabled" 1
	printf "\n\t===\tTouchpad Enabled\t===\n\n"
fi

exit
