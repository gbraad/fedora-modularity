Standalone containers
=====================


About
-----

Standalone containers enable you to use containers in a similar way as you use
traditional system services. The goal is to preserve muscle memory so you don't
have to learn new commands while still being able to work with containers.


Requirements
------------

- Only a single instance of a standalone container is supported to run on a
  host (installation of the same container image twice won't be successful).
- Services are managed via systemd unit files.
- Containers are installed to a system.
- There is no dedicated network namespace.
- Configuration is stored in the same locations on the host as a
  non-containerized service.
- Persistent data can be found in the same locations on the host as for
  non-containerized service.
- Service presence, configuration and persistent data are tracked by the RPM
  database.
- Application lifecycle is close to services deployed as RPMs.
- Some commands may need to be executed inside the container since the
  service is not running directly on host.


Quick how-to
------------

We utilize the atomic command to install a container image on a host.

In order to get files from a container image to the host, you should have a
specific directory structure inside your container image. Here's an example
of nginx container image:

::

    /
    └── exports
        └── hostfs
            ├── etc
            │   └── nginx
            │       ├── conf.d
            │       ├── default.d
            │       ├── fastcgi.conf
            │       ├── fastcgi.conf.default
            │       ├── fastcgi_params
            │       ├── fastcgi_params.default
            │       ├── koi-utf
            │       ├── koi-win
            │       ├── mime.types
            │       ├── mime.types.default
            │       ├── nginx.conf
            │       ├── nginx.conf.default
            │       ├── scgi_params
            │       ├── scgi_params.default
            │       ├── uwsgi_params
            │       ├── uwsgi_params.default
            │       └── win-utf
            └── usr
                ├── lib
                │   └── systemd
                │       └── system
                │           └── nginx-container.service
                └── share
                    └── nginx
                        └── html
                            ├── 404.html
                            ├── 50x.html
                            ├── index.html
                            ├── nginx-logo.png
                            └── poweredby.png


- **exports** directory is what atomic uses, it is in a root of the container
  image
- **hostfs** is a tree of directories and files which will land on the host,
  tracked by a generated RPM
- a systemd unit :code:`nginx-container.service`, which controls the
  containerized nginx, is placed in
  :code:`/exports/hostfs/usr/lib/systemd/system`

Here's the mentioned :code:`nginx-container.service`:

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

    $ atomic install docker:modularitycontainers/nginx


There is no released version of atomic with this functionality, yet. The
version of atomic command built `in this copr repo
<https://copr.fedorainfracloud.org/coprs/ttomecek/atomic/>`__ contains the
functionality to install standalone container image.

Most of the principles of standalone containers are based on the model &
technology of system containers. If you would like to know more about system
containers read `the blog post
<http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/>`__.
