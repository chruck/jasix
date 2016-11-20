jasix
=====

Linux distribution scripted and customized by me, Jas

Getting Started
---------------
Current method is using Knoppix as the host distro from which to bootstrap,
which is why `apt-get' is used to install software.  This is done by
downloading Knoppix, then using KVM to boot into Knoppix:

`wget -O - https://raw.githubusercontent.com/chruck/jasix/master/preBootstrapKnopKvm | sh`
