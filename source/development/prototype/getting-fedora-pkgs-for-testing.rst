Getting Fedora Packages for Testing
===================================

Getting Fedora Packages for Testing
-----------------------------------

In order to build modules, you need component packages from which to
build them, and it's better to have them locally available. This page
describes where to download a set of packages which we use to build
modules in tests.

Fedora 24 Beta
~~~~~~~~~~~~~~

As a base set of packages, we use the Beta of Fedora 24 at the moment.
Previously, we used the Alpha, but it shouldn't make much of a
difference unless you want to use the minimized packages below, then you
need to use the Alpha instead of the Beta, otherwise the non-minimized
packages may be preferred over the minimized ones because of their newer
NEVRA.

You can download whole trees recursively from:

-  x86\_64 binary packages:
   http://dl.fedoraproject.org/pub/fedora/linux/releases/test/24_Beta/Server/x86_64/os/
-  source packages:
   http://dl.fedoraproject.org/pub/fedora/linux/releases/test/24_Beta/Server/source/tree/

Using ``wget``, this would download them to the current directory in
appropriate subdirectories:

::

    wget -r --no-parent -P fedora-24-beta-x86_64 --no-host-directories \
        --cut-dirs 9 http://dl.fedoraproject.org/pub/fedora/linux/releases/test/24_Beta/Server/x86_64/os/
    wget -r --no-parent -P fedora-24-beta-src --no-host-directories \
        --cut-dirs 9 http://dl.fedoraproject.org/pub/fedora/linux/releases/test/24_Beta/Server/source/tree/

"Esoteric" Shells
~~~~~~~~~~~~~~~~~

As an additional set of packages, we use a couple of shells. They aren't
grouped together like that ordinarily, so we download the packages
directly from koji:

::

    for arch in x86_64 src; do
        d="fedora-24-shells-$arch"
        (mkdir -p "$d" && cd "$d" &&
          for shell in aesh bash dash fish ksh mksh mosh tcsh yash zsh; do
              _archspec="--arch $arch"
              if [ "$arch" != "src" ]; then
                  _archspec="$_archspec --arch noarch"
              fi
              koji download-build --latestfrom=f24 $_archspec "$shell"
          done)
    done

Afterwards, we need create the repository metadata:

::

    for d in fedora-24-shells-*; do
        createrepo "$d"
    done

Minimized packages repositories
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Yaakov Selkowitz <User:Yselkowitz>`__ hosts repositories with minimized
versions of some base packages on `fedorapeople.org
space <https://yselkowitz.fedorapeople.org>`__:

-  Fedora 24 (roughly Alpha):
   https://yselkowitz.fedorapeople.org/f24-minimization/
-  Rawhide: https://yselkowitz.fedorapeople.org/rawhide-minimization/

You can mirror them locally, e.g. using either or both of these
commands:

::

    wget -r --no-parent -P fedora-24-minimization --no-host-directories \
        --cut-dirs 1 https://yselkowitz.fedorapeople.org/f24-minimization/
    wget -r --no-parent -P rawhide-minimization --no-host-directories \
        --cut-dirs 1 https://yselkowitz.fedorapeople.org/rawhide-minimization/
