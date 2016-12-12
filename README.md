jasix
=====

Linux distribution scripted and customized by me, Jas

Philosophy
----------
- Minimal host OS
- Minimal bootstrap/buildtools environment
- Build everything from source
- Have fun learning
- ?
- Prophet!

Getting Started
---------------
Current method is using Knoppix as the host distro from which to bootstrap,
which is why `apt-get` is used to install software.  This is done by
downloading Knoppix, then using KVM to boot into Knoppix:

`wget -O - https://raw.githubusercontent.com/chruck/jasix/master/preBootstrapKnopKvm | sh`

Current Methodology
-------------------
[x] Download ISO from another distro (__Knoppix__, __Gentoo__ stage 4)
[x] Create a __KVM__ VM
[x] Boot the VM into that another distro
[ ] Creating __btrfs__ filesystem
[ ] From source, install bootstrap/buildtools environment on that
    filesystem, starting with __busybox__
[ ] Bootstrap into that environment
[ ] Build everything else needed from source
