# A quick, hacky and working init installation file example. Not adding the dependencies, to make it triviall copiable for some other hacks

DESCRIPTION = "Hacky WiFi connect script for demo/testing"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://connect-to-wifi.sh \
            file://wpapass"

inherit update-rc.d

INITSCRIPT_NAME = "connect-to-wifi.sh"
INITSCRIPT_PARAMS = "start 990 5 2 . stop 20 0 1 6 ."

# S = "${WORKDIR}" is obsolete beginning sthead (v5.1)
S = "${UNPACKDIR}"
do_unpack[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"


do_install() {
    echo "PACKAGE name is ${PN}" # apears 
    bbnote "PN1=$PN PN=${PN} WORKDIR=${WORKDIR}, S=${S} foo=${FOO}"
    bbnote "$D"

    install -D -m0755 ${S}/wpapass ${D}/${sysconfdir}/wpapass
    if [ "${VIRTUAL-RUNTIME_init_manager}" != "systemd" ]; then
        install -D -m0755 ${S}/connect-to-wifi.sh ${D}/${sysconfdir}/init.d/connect-to-wifi.sh
    else
        echo "Warning: systemd is not supported by this example - but it is very easy to add it"
    fi
}

