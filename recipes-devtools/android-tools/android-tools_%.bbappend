FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://start-adbd.sh \
"

do_install:append() {
    # install -D -m0755 ${S}/wpapass ${D}/${sysconfdir}/wpapass
    if [ "${VIRTUAL-RUNTIME_init_manager}" != "systemd" ]; then
        install -D -m0755 ${UNPACKDIR}/start-adbd.sh ${D}/${sysconfdir}/init.d/start-adbd.sh
    else
        echo "Warning: systemd is not supported by this example - but it is very easy to add it"
    fi
}

FILES:${PN}-adbd:append = " ${sysconfdir}/init.d/start-adbd.sh"

pkg_postinst_ontarget:${PN}-adbd() {
    update-rc.d start-adbd.sh start 51 2 5 .
}
