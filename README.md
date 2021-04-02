# EdgeRouter-BATMAN-kernel-module
This repo contains pre-built kernel modules for the BATMAN routing protocoll for use with Ubiquitis EdgeOS on EdgeRouter devices.
It also contains a binary for `batctl` and an initialisation script for automatic configuration and starting of BATMAN at device start-up.

At the moment, these kernel modules only work for MediaTek-based devices (EdgeRouter ER-X/ER-X-SFP/EP-R6/ER-10X) and with firmware v2.0.9-hotfix.1.

A build script to reproduce the process and adapt it for other versions will be added after some clean-up.

# Installation
Copy the contents of /user-data to /config/user-data/batman-adv on your EdgeRouter.
Symlink `setup_batman.sh` from there to /config/scripts/post-config.d/setup\_batman.sh.

# Usage
Execute `setup_batman.sh` to bring up all configured BATMAN interfaces.
Configuration is done by creating a `batN.conf` file for each desired interface, with N being an integer.
An interface corresponding to the filename will be created.

# MISC info
BATMAN logs are accessible via dmesg. The start-up sequence logs to /var/log/user/batmano\_setup.log.

In addition to the batman-adv kernel module libcrc32c is also necessary. Both can be built from the GPL kernel sources provided by Ubiquiti (
https://www.ui.com/download/edgemax/edgepoint/ep-r6/edgerouter-er-xer-x-sfpep-r6er-10x-firmware-v209-hotfix1).

batctl has been taken from the Debian experimental repo (https://manpages.debian.org/experimental/batctl/batctl.8.en.html).

ALFRED is currently not included. It will also have to be built from source since the Debian version uses a newer GLIBC.
