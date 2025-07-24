FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://start-adbd.sh \
"
inherit update-rc.d

INITSCRIPT_NAME = "start-adbd.sh"
# We are not interested in stopping adb upon shutdown. We could, but I just added a quite hacky service so...
INITSCRIPT_PARAMS = "start 51 2 5 ."

do_install:append() {
    # install -D -m0755 ${S}/wpapass ${D}/${sysconfdir}/wpapass
    if [ "${VIRTUAL-RUNTIME_init_manager}" != "systemd" ]; then
        install -D -m0755 ${UNPACKDIR}/start-adbd.sh ${D}/${sysconfdir}/init.d/start-adbd.sh
    else
        echo "Warning: systemd is not supported by this example - but it is very easy to add it"
    fi
}

# The next line yields an error and commenting it out does work
# The error in the log says it cannot find the file but it is wrong
#ERROR: Postinstall scriptlets of ['android-tools'] have failed. If the intention is to defer them to first boot,
#then please place them into pkg_postinst_ontarget:${PN} ().
#Deferring to first boot via 'exit 1' is no longer supported.

#FILES:${PN}-adbd:append = " ${sysconfdir}/init.d/start-adbd.sh"


