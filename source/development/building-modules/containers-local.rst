Building containers locally
===============================

When you have your module built, let's put it in a container, so we can
use it. As an example, we will use the `perl image <https://github.com/container-images/perl/blob/master/Dockerfile>`__. 

RPM repository
--------------

First, upload your RPM repository from the previous step somewhere publicly accessible.

Dockerfile
----------

Next step will be writing a Dockerfile to build a container image with your module.

The Base Runtime image is currently only available from Docker Hub and you can use it as your base image by specifying ``FROM /baseruntime/baseruntime``.

You also need to write a repo file for your module and add it to your container, so you can install the module in it.
See the example of the repo file in `<https://github.com/container-images/perl/tree/master/repos>`__. 
The following snippet then shows how you copy the repo and install the files from it in your container:

::

  COPY repos/* /etc/yum.repos.d/
  # Perl and build tools install + user addition
  RUN BUILD_TOOlS="bsdtar \
    findutils \
    gcc \
    make \
    gettext \
    tar \
    wget \
    python " && \
  microdnf --nodocs --enablerepo perl install perl perl-devel && \
  microdnf --nodocs --enablerepo fedora install -y mod_perl cpan cpanminus httpd \
    $BUILD_TOOlS && \
	microdnf clean all
  RUN mkdir -p /opt/app-root/src/ && \
  useradd -u 1002 -r -g 0 -d /opt/app-root/src -s /sbin/nologin \
  -c "Default Application User" default && \
  chown -R 1002:0 /opt/app-root


Building the image
-------------------

When you have your repository and Dockerfile ready, use "``docker build .``" to
build the container image and "``docker tag username/imagename``" so to make it available for public to pull.
