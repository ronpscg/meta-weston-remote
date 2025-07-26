FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://start-adbd.sh \
"

do_install:append() {
    # install -D -m0755 ${S}/wpapass ${D}/${sysconfdir}/wpapass
    if [ "${VIRTUAL-RUNTIME_init_manager}" != "systemd" ]; then
        install -D -m0755 ${UNPACKDIR}/start-adbd.sh ${D}/${sysconfdir}/init.d/start-adbd.sh
    else
        # The right way to do things is with install. Below is a demonstration of the fact that any shell command can work here
        mkdir ${D}/${sysconfdir}
        touch ${D}/${sysconfdir}/usb-debugging-enabled
    fi
}

FILES:${PN}-adbd:append = " ${sysconfdir}/init.d/start-adbd.sh"

FILES:${PN}-adbd:append:systemd = " /etc/usb-debugging-enabled"

pkg_postinst_ontarget:${PN}-adbd() {
    update-rc.d start-adbd.sh start 51 2 5 .
}
