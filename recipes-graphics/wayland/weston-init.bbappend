FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILES:${PN}:append := " ${sysconfdir}/xdg/weston/tlsstuff"

# If you don't want to override weston.ini - comment out these two files
FILES:${PN} += "${sysconfdir}/xdg/weston/weston.ini"
CONFFILES:${PN} += "${sysconfdir}/xdg/weston/weston.ini"

# Set a password for the weston user, to keep trivial VNC clients happy as they require login
# There are several ways to generate the password. e.g.  $ openssl passwd -6 weston . If using that, one MUST escape every '$', i.e.  $ -->  \$
# (there should be 3 '$' -  first two encapsulate the algorithm, third at the end of the random salt (see $ man 3 crypt)
# Altenatively one could just -p 'weston' weston" - as in this case we care less about the security
USERADD_PARAM:${PN} = "--home /home/weston --shell /bin/sh --user-group -G video,input,render,seat,wayland \
        -p '\$6\$eKGkuPGa18qZJ1OO\$d1YksHtTZyIzeHXKgqhAkjUHrVMk1hpC.c2nfg1Ea1xH9WtrjLi2ZIlaegPfPaADuPLON/qm8ao4dGmarXAob.' \
        weston\
        "
# Skip QA Issue: weston-init: ... is owned by uid 1000, which is the same as the user running bitbake. This may be due to host contamination [host-user-contaminated]
# when installing or chown-ing
INSANE_SKIP:${PN} += " host-user-contaminated"


SRC_URI += " \
    file://tlsstuff/tls-cert.pem \
    file://tlsstuff/tls-key.openssh \
    file://tlsstuff/vnc.sh \
    file://weston.ini \
"

do_install:append() {
    install -d ${D}${sysconfdir}/xdg/weston/tlsstuff
    install -D -p -m0644 -o weston -g weston ${S}/tlsstuff/tls-cert.pem ${D}${sysconfdir}/xdg/weston/tlsstuff/tls-cert.pem
    install -D -p -m0600 -o weston -g weston ${S}/tlsstuff/tls-key.openssh ${D}${sysconfdir}/xdg/weston/tlsstuff/tls-key.openssh
    install -D -p -m0755 -o weston -g weston ${S}/tlsstuff/vnc.sh ${D}${sysconfdir}/xdg/weston/tlsstuff/vnc.sh

    # If you want to just have VNC support, just have RDP support, only run with the ctrl-alt-s sequence and not auto start screen sharing,
    # then either modify the file, or commend out the next line.
    install -D -p -m644 -o root -g root ${S}/weston.ini ${D}${sysconfdir}/xdg/weston/weston.ini
}

