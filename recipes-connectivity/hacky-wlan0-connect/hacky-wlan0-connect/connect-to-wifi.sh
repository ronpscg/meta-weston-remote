#!/bin/sh
#
# This is hacky and we really only care about starting, but other than doing the formal init comments etc. (@see https://refspecs.linuxbase.org/LSB_3.0.0/LSB-PDA/LSB-PDA/initscrcomconv.html)
# let's do it more adequate for a simple rc.d init service
#
case "$1" in
  start)
	  wpa_supplicant -B -c /etc/wpapass -i wlan0
	  udhcpc -i wlan0 &
  ;;
  stop)
        echo "Disconnecting wifi"
        killall udhcpc
	killall wpa_supplicant
  ;;

  restart)
	$0 stop
        $0 start
  ;;

  *)
        echo "usage: $0 { start | stop | restart }"
  ;;
esac

exit 0

