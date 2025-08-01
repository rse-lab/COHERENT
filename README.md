## COHERENT ##

This repository contains a bootable floppy of the [COHERENT](https://en.wikipedia.org/wiki/Coherent_(operating_system)) operating
system.

The floppy is intended for the [Bochs](https://bochs.sourceforge.io/) emulator. It contains a read-only
filesystem with a small set of commands. The /tmp directory is writeable
but will loose all contents on shutdown.

Commands are for example:

| cat | df | doscp | ed | ls | mount | pwd | vi |
| --- | -- | ----- | -- | -- | ----- | --- | -- |

<br>

> [!IMPORTANT]
> At startup enter the name of the kernel to be started: **coherent**.

![choose_kernel](https://github.com/user-attachments/assets/f3ede557-7fdc-498d-8a4d-1200f9d3055c)

> [!NOTE]
> The installation command "begin" is not part of the floppy.

![coherent_running](https://github.com/user-attachments/assets/66fa153e-ff98-4a53-9e10-47f90e51903a)

**Data exchange with host (Windows):**

(1) create a blank floppy image on the host system:
```
    bximage.exe -func=create -fd=1.44M -q floppy.img
```
(2) in COHERENT use both fdformat and dosformat:
```
    fdformat /dev/fva1
    dosformat b:
```
(3) copy data from COHERENT onto MSDOS floppy (or vice versa):
```
    echo "Hi there!" > /tmp/hello.txt
    doscp /tmp/hello.txt b:
```
(4) on host use something like the Perl scripts [dosdir.pl](floppy/dosdir.pl) and [doscp.pl](floppy/doscp.pl):
```
    dosdir.pl floppy.img
    doscp.pl floppy.img hello.txt
```

> [!NOTE]
> Data exchange currently is out of focus. On Linux there's something like [mtools](https://www.gnu.org/software/mtools/)...
