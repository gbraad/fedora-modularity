Building containers in Fedora
=============================

Building a container image
--------------------------

There are two ways to build a Docker container image in Fedora
infrastructure:

#. **In production environment** -- the process starts by initiating a
   review request, as specified in `Container:Review_Process <https://fedoraproject.org/wiki/Container:Review_Process>`__.
#. **In staging environment** -- this is where we can bypass the review
   process and iterate more quickly; In order to use staging
   environment, we should request creation of dist-git repo and pkgdb
   entry via `Fedora Infra
   tracker <https://pagure.io/fedora-infrastructure/issues>`__.

If you want to clone your dist-git repository using ``fedpkg``, you need
to select correct namespace:

::

    $ fedpkg clone docker/$COMPONENT

or

::

    $ fedpkg clone modules/memcached

Once you are ready to submit a build, you need to push changes to a
remote and initiate a build

::

    $ fedpkg container-build

Inspecting registry
-------------------

At the time of writing this (Feb 2017), Fedora docker image registry
doesn't have any frontend. You can access API of registry to get a list
of available images:

::

    $ curl -s https://registry.fedoraproject.org/v2/_catalog | python -m json.tool
    {
        "repositories": [
            "cockpit",
            "f24/cockpit",
            "f25/cockpit",
            "f25/kube-apiserver",
            "f25/kubernetes-master",
            "f25/owncloud",
            "f26/cockpit",
            "fedora",
            "fedora/cockpit",
            "openshift/origin-pod"
        ]
    }

Thank you to `Adam Miller <User:maxamillion>`__ for providing info about
using Docker Layered Image Build System.
