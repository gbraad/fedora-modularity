Building modules locally
============================

To build a modulemd, you need to have the `Module Build Service <https://pagure.io/fm-orchestrator>`__ installed on your system. There are two ways of achieving that:

1. Installing the `module-build-service package <https://bugzilla.redhat.com/show_bug.cgi?id=1404012>`__ with all its dependencies.
2. Using a `pre-built docker image and a helper script <https://github.com/asamalik/build-module>`__.

Both options provide the same result, so choose whichever you like better.

Option 1: module-build-service package
--------------------------------------

On **Fedora rawhide**, just install it by:

::

    $ sudo dnf install module-build-service

I have also created a `Module Build Service copr repo <https://copr.fedorainfracloud.org/coprs/asamalik/mbs/>`__ for Fedora 24 and Fedora 25:

::

    $ sudo dnf copr enable asamalik/mbs
    $ sudo dnf install module-build-service

To build your modulemd, run a command similar to the following:

::

    $ sudo mbs-manager build_module_locally file:////path/to/my-module?#master

An output will be a yum/dnf repository in the /tmp directory.

Option 2: docker image and a helper script
------------------------------------------

With this option you don’t need to install all the dependencies on your system, but it requires you to setenforce 0 before the build. :-(

You only need to clone the `asamalik/build-module repository on GitHub <https://github.com/asamalik/build-module>`__ and use the helper script as follows:

::

    $ build_module ./my-module ./results

An output will be a yum/dnf repository in the patch you have specified.
