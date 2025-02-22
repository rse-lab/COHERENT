# COHERENT

[Coherent](http://en.wikipedia.org/wiki/Coherent_(operating_system)) is 
a UNIX-like operating system that has been developed by the
[Mark Williams Company](https://en.wikipedia.org/wiki/Mark_Williams_Company)
between 1980 and 1995. In 2015 the source code of Coherent became open 
source.

This repository provides a bootable media with the Coherent 2.4.10
kernel that can be used with the [Bochs](https://bochs.sourceforge.io/) emulator.

![Image](https://github.com/user-attachments/assets/d71a43d9-5753-42f3-9667-c733549ac6c4)

You cannot use a Coherent harddisk in Bochs as its hardware emulation
is too bad.

### Coherent 4.2.10 boot disk

[boot.img](disk/boot.img) is a 1.44MB floppy disk that you can boot from A: in Bochs.
The disk mounts the file system read-only. One can write to /tmp which
is a RAM disk. So you can at least play around with e.g. /bin/sh and
/bin/ed. A vi clone is available, too.
