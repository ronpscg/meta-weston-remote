FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://android-gadget-our-shiny-config \
"

do_install:append() {
    install -m 0755 ${UNPACKDIR}/android-gadget-our-shiny-config ${D}${bindir}
}

