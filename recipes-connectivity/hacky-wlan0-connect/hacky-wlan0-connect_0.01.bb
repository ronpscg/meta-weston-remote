# A quick, hacky and working init installation file example. Not adding the dependencies, to make it triviall copiable for some other hacks
# Yocto Project course students: you should read everything carefully, ask questions, and experiment. 
#

DESCRIPTION = "Hacky WiFi connect script for demo/testing. Resembles quite well real life scenarios"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://connect-to-wifi.sh \
            file://wpapass \
"

inherit update-rc.d

INITSCRIPT_NAME = "connect-to-wifi.sh"
INITSCRIPT_PARAMS = "start 990 5 2 . stop 20 0 1 6 ."

# Yocto Project course:  S = "${WORKDIR}" is obsolete beginning sthead (v5.1)
S = "${UNPACKDIR}"

# Yocto Project course: after building at least once, uncomment the next line, and change your wpapass file. What do you think will happen? Why?
#do_unpack[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"


do_install() {
    if [ "${VIRTUAL-RUNTIME_init_manager}" != "systemd" ]; then
        install -D -m600 ${S}/wpapass ${D}/${sysconfdir}/wpapass
        install -D -m0755 ${S}/connect-to-wifi.sh ${D}/${sysconfdir}/init.d/connect-to-wifi.sh
    else
        bberror "You are not supposed to get to this clause given our override"
    fi
}


# There are more elegant ways to achieve this, left as an exercise
OVERRIDES:append = ":systemd"
# Note that this completely overrides SRC_URI from the top - so it is a different set. Both start empy either way on a recipe, so it doesn't matter if you += "..." or = "..."
SRC_URI:systemd += "file://wlan0.network file://wpapass"
do_install:systemd() {
        bbnote "Enabling wlan0 on your target. Can you do a better job? (you should. exercise) ${PN}"
        install -D -m644 ${S}/wlan0.network ${D}/${sysconfdir}/systemd/network/wlan0.network
        install -D -m600 ${S}/wpapass ${D}/${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
        ln -s ${systemd_unitdir}/system/wpa_supplicant@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
}

# Yocto Project course: add a bbnote to explain yourself why we don't need to specify the files we use in $FILES:${PN}
# e.g. FILES:${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service"
