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


### Another way of doing system update- not ncessary if we avoid specifying the files - or otherwise put adbd in another recipe.
### But this makes for a good construct of explaining some of the difficulties of working with complex packages using subpackages

#inherit update-rc.d

# Avoid ERROR: /home/ron/yocto/other-layers/meta-openembedded/meta-oe/recipes-devtools/android-tools/android-tools_5.1.1.r37.bb: /home/ron/yocto/other-layers/meta-openembedded/meta-oe/recipes-devtools/android-tools/android-tools_5.1.1.r37.bb inherits update-rc.d but doesn't set INITSCRIPT_NAME

#INITSCRIPT_NAME = ""
#INITSCRIPT_PARAMS = ""

#INITSCRIPT_NAME:${PN}-adbd = "start-adbd.sh"
# We are not interested in stopping adb upon shutdown. We could, but I just added a quite hacky service so...
#INITSCRIPT_PARAMS:${PN}-adbd = "start 51 2 5 ."

# The next line yields an error and commenting it out does work
# The error in the log says it cannot find the file but it is wrong
#ERROR: Postinstall scriptlets of ['android-tools'] have failed. If the intention is to defer them to first boot,
#then please place them into pkg_postinst_ontarget:${PN} ().
#Deferring to first boot via 'exit 1' is no longer supported.

FILES:${PN}-adbd:append = " ${sysconfdir}/init.d/start-adbd.sh"


# So this line fixes it
pkg_postinst_ontarget:${PN}-adbd() {
    update-rc.d start-adbd.sh start 51 2 5 .
}
