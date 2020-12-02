#!/usr/bin/env sh

# Get MAC addresses for keyboard and trackpad
KEYBOARD_ADDRESS=$(blueutil --paired | grep "Clay’s Magic Keyboard" | sed -En "s/^.*address: (([[:xdigit:]]{2}-){5})([[:xdigit:]]{2}).*$/\1\3/p")
TRACKPAD_ADDRESS=$(blueutil --paired | grep "Clay’s Magic Trackpad 2" | sed -En "s/^.*address: (([[:xdigit:]]{2}-){5})([[:xdigit:]]{2}).*$/\1\3/p")

# Check current connection statuses
DISPLAY_CONNECTED=$(system_profiler SPDisplaysDataType | grep -Fq "LG UltraFine"; echo $?)
KEYBOARD_CONNECTED=$(blueutil --is-connected "${KEYBOARD_ADDRESS}" | grep -Fq 1; echo $?)
TRACKPAD_CONNECTED=$(blueutil --is-connected "${TRACKPAD_ADDRESS}" | grep -Fq 1; echo $?)

# Sync connection status
if [ "${DISPLAY_CONNECTED}" -eq 0 ]; then
	# echo "LG UltraFine is connected."
	if [ "${KEYBOARD_CONNECTED}" -ne 0 ]; then
		echo "Connecting Clay’s Magic Keyboard."
		blueutil --connect "${KEYBOARD_ADDRESS}"
	fi
	if [ "${TRACKPAD_CONNECTED}" -ne 0 ]; then
		echo "Connecting Clay’s Magic Trackpad 2."
		blueutil --connect "${TRACKPAD_ADDRESS}"
	fi
else
	# echo "LG UltraFine is not connected."
	if [ "${KEYBOARD_CONNECTED}" -eq 0 ]; then
		echo "Disconnecting Clay’s Magic Keyboard."
		blueutil --disconnect "${KEYBOARD_ADDRESS}"
	fi
	if [ "${TRACKPAD_CONNECTED}" -eq 0 ]; then
		echo "Disconnecting Clay’s Magic Trackpad 2."
		blueutil --disconnect "${TRACKPAD_ADDRESS}"
	fi
fi

# Clear variables
unset KEYBOARD_ADDRESS
unset TRACKPAD_ADDRESS
unset DISPLAY_CONNECTED
unset KEYBOARD_CONNECTED
unset TRACKPAD_CONNECTED