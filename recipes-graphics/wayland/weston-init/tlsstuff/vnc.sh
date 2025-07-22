#!/bin/sh
#
# This runs both RDP and VNC backends on the target. It works for Weston v14.0 but IIRC you would need to separate the backends
# in Weston v <= 12
#
# Imporant notes; You must have /dev and /dev/pts mounted for RDP (if you are doing it, e.g., inside a chroot environment)
#
: ${WESTON_USER=weston}
su -c "XDG_RUNTIME_DIR=/run/user/$(id -u $WESTON_USER) \
/usr/bin/weston \
-B rdp,vnc  \
--vnc-tls-cert=/etc/xdg/weston/tlsstuff/tls-cert.pem  \
--vnc-tls-key=/etc/xdg/weston/tlsstuff/tls-key.openssh  \
--rdp-tls-cert=/etc/xdg/weston/tlsstuff/tls-cert.pem  \
--rdp-tls-key=/etc/xdg/weston/tlsstuff/tls-key.openssh "  \
$WESTON_USER
