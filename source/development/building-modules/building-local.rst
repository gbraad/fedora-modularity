Building modules locally
============================

To build a modulemd, you need to have the `Module Build Service <https://pagure.io/fm-orchestrator>`__ installed on your system.

On **Fedora rawhide** and **Fedora 26**, install it by:

::

    $ sudo dnf install module-build-service

On **Fedora 25**, install the latest version from `https://koji.fedoraproject.org/koji/packageinfo?packageID=23564`:

::

    $ sudo dnf install <URL_to_noarch_package>

To build your module, run a command similar to the following:

::

    $ sudo mbs-build local

An output will be a yum/dnf repository beneath the modulebuild directory in the
home of the user. Right now, using sudo, this will be root.
