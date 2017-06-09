Fedora 26 Boltron Server
========================

Boltron is a upcoming prototype of Fedora Modularity. A formal description is documented in `Changes/Modular Server Preview <https://fedoraproject.org/wiki/Changes/Modular_Server_Preview>`__ on the Fedora wiki. **This page is going to track the progress** of the release.


Modules in Boltron
------------------

The following is a list of modules that we have completed:

- `PHP <https://github.com/modularity-modules/php>`__
- `httpd <https://github.com/modularity-modules/httpd>`__
- `nginx <https://github.com/modularity-modules/nginx>`__
- `memcached <https://github.com/modularity-modules/memcached>`__
- `haproxy <https://github.com/modularity-modules/haproxy>`__
- `source-to-image <https://github.com/modularity-modules/source-to-image>`__
- `PERL <https://github.com/modularity-modules/perl>`__
- `dhcp-server <https://github.com/modularity-modules/dhcp-server>`__
- `postfix <https://github.com/modularity-modules/postfix>`__
- `container-runtime <https://github.com/modularity-modules/container-runtime>`__
- `MariaDB <https://github.com/modularity-modules/mariadb>`__
- `MongoDB <https://github.com/modularity-modules/mongodb>`__


For more information about individual modules - both completed and in progress - see our `Fedora Modularity: Modules GitHub space <https://github.com/modularity-modules>`__.

DNF prototype
-------------

If you want to try the DNF prototype or any of the modules above, please refer to the `DNF Modularity Prototype repository <https://github.com/container-images/dnf-modularity-prototype>`__ or get the image directly from Docker hub:

::

    $ docker pull jamesantill/flat-modules-dnf

Then start the container using this image with an interactive shell:

::

    $ docker run --rm -it jamesantill/flat-modules-dnf /bin/bash

You can list the available modules:

::

    $ dnf module list

And install some. All of the modules mentioned above should work. Please note that not all modules listed by the previous command will work at the moment.

::

    $ dnf install nodejs
