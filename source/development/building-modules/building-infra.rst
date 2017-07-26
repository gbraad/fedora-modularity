Building modules in Fedora
==========================

When your module is ready to get added to Fedora, you need to have write
access to the module dist-git on pkgs.fedoraproject.org and you need
to have pushed all your changes to this module git repository. You can
build your by following method


module-build-service package
--------------------------------------

On **Fedora rawhide** and **Fedora 26**, just install it by:

::

    $ sudo dnf install module-build-service

On **Fedora 25**, just install the latest version
`https://koji.fedoraproject.org/koji/packageinfo?packageID=23564`:

::

    $ sudo dnf install <URL_to_noarch_package>

To build your modulemd, run a command:

::

    $ mbs-build submit -w

The command will submit build into infrastructure and watch the task, so you
are able to track results.
