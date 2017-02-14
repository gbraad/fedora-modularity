Building containers locally
===============================

When you have your module built, let's put it in a container, so we can
use it.

Architecture
------------

The final result of this guide is a container using a three-layer module
container architecture which clearly separates the system base image
(built out of a Base Runtime), the module itself (the one we are going
to build), and the final configuration.

Examples for each layer: `Layer
1 <https://github.com/asamalik/fake-gen-core-module-image>`__ \|
`Layer 2 <https://github.com/asamalik/fake-proftpd-module-image>`__
\| `Layer 3 <https://github.com/container-images/proftpd>`__

.. figure:: three-layer-arch.png
   :alt: three-layer-arch.png
   :width: 800px


Building
--------

Building Layer 2
^^^^^^^^^^^^^^^^

First, upload your RPM repository from the previous step somewhere
publicly accessible. I've used my `Fedorapeople to host my modular
packages <https://asamalik.fedorapeople.org/proftpd-module-repo/>`__.

Next step will be writing a Dockerfile to build a container image with
your module. This container will be representing the Layer 2 in the
three-layer architecture.

Since there is no official Base Runtime image, I have created `my own
Fake Base
Runtime <https://github.com/asamalik/fake-gen-core-module-image>`__
that you can use as your base image by specifying
"``FROM asamalik/fake-gen-core-module``".

You also need to write a repo file for your module - see the example
below - and add it to your container, so you can install the module in
it.

Basically, you need to prepare a repository similar to this example:

-  `The whole Layer 2
   repository <https://github.com/asamalik/fake-proftpd-module-image>`__

   -  `Dockerfile <https://github.com/asamalik/fake-proftpd-module-image/blob/master/Dockerfile>`__
   -  `repo
      file <https://github.com/asamalik/fake-proftpd-module-image/blob/master/files/proftpd-module.repo>`__

When you have your Layer 2 repository ready, use "``docker build .``" to
build the container image and "``docker tag username/imagename``" so you
(and maybe other people) can use it as a base for the final layer.

Building Layer 3
^^^^^^^^^^^^^^^^

The final layer will not install anything, it will just add
configuration and the RUN statement to make the image work. You need to
use your Layer 2 image as a base for this one.

An `example for the proftpd
container <https://github.com/container-images/proftpd>`__.

And again, when you have your Dockerfile ready, use "``docker build .``"
to build the container image.
