#!/bin/sh
pgrep adbd && /usr/bin//android-gadget-cleanup
/usr/bin/android-gadget-setup
/usr/bin/android-gadget-our-shiny-config
echo "before gadget start: $(cat /sys/kernel/config/usb_gadget/adb/UDC)"
nohup adbd &
# Instead of this which sleeps 10 seconds
#/usr/bin/android-gadget-start
# Do this: (the file contents - without minimal sleep which seems to be working)
sleep 1
ls /sys/class/udc/ | head -n 1 | xargs echo -n > /sys/kernel/config/usb_gadget/adb/UDC
echo "Setting UDC $(ls /sys/class/udc/ | head -n 1) for USB ADB Gadget usage"
echo -e "\x1b[42;34mafter gadget start: $(cat /sys/kernel/config/usb_gadget/adb/UDC)\x1b[0m"

