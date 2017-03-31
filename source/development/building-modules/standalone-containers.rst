Standalone containers
=====================


About
-----

Standalone containers enable you to use containers in a similar way as you use
traditional system services. The goal is to preserve muscle memory so you don't
have to learn new commands while still be able to work with containers.


Requirements
------------

- Only a single instance of a standalone container is supported to run on a host.
- Services are managed via systemd unit files.
- Containers are installed to a system.
- There is no dedicated network namespace.
- Configuration is stored in same locations on host as non-containerized service.
- Persistent data can be found in the same locations on host as for non-containerized service.
- Service presence, configuration and persistent data are tracked by RPM database.
- Application lifecycle is close to services deployed as RPMs.
- Some commands may need to be executed inside container (by doing exec).


Quick how-to
------------

We utilize atomic command to install a container image on a host.

In order to get files from container image to host, you should have this
directory structure inside your container image:

::

    /
    ├── exports
    │   ├── hostfs
    │   │   ├── etc
    │   │   │   ├──
    │   │   └── usr
    │   │       └──
    │   └── service.template

- **exports** directory is what atomic uses, it is in root of the container image
- **hostfs** is a tree of directories and files which will land on host, tracked by a generated RPM
- **service.template** is systemd unit file to start and stop the service, it can look like this:

::

    [Unit]
    Description="Standalone container version of NGINX webserver."

    [Service]
    ExecStartPre=/usr/bin/docker create -t -i -v /etc/nginx:/etc/nginx/:ro --net=host -v /usr/share/nginx:/usr/share/nginx/:ro --name nginx-container modularitycontainers/nginx
    ExecStart=/usr/bin/docker start -a nginx-container
    ExecStop=/usr/bin/docker stop nginx-container
    ExecStopPost=/usr/bin/docker rm -f nginx-container

    [Install]
    WantedBy=multi-user.target


Once the image is built, you can install it like this:

::

    $ atomic install --storage=docker --system-package=yes docker:modularitycontainers/nginx


There is no released version of atomic with this functionality, yet.


For more information, please see the blog post about `system containers
<http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/>`__.
Standalone containers use the same technology.
