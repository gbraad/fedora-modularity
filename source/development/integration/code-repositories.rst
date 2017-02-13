Code Repositories
=================

This page contains list of code repositories of all Modularity related
projects with short description of each project. This page is updated
regularly, but to see the most actual list of projects, check Modularity
group on `Pagure <https://pagure.io/group/modularity>`__ or on
`GitHub <https://github.com/fedora-modularity>`__. Note that on these
pages, there can be also repositories for already abandoned projects.

Common libraries
----------------

This is list of common libraries we use across various Modularity
projects:

Modulemd
~~~~~~~~

Link: `https://pagure.io/fm-metadata <https://pagure.io/fm-metadata>`__

This repository contains the definition of metadata format (Modulemd)
used to describe every module. It also contains Python library used to
manipulate files in this format.

Modulemd-resolver
~~~~~~~~~~~~~~~~~

Link
`https://pagure.io/fm-modulemd-resolver <https://pagure.io/fm-modulemd-resolver>`__

This repository contains Python library which is used to resolve
dependencies between multiple Modulemd objects. It uses similar way as
yum/dnf uses to resolve dependencies between RPM packages.

Server side projects
--------------------

This is list of server side projects which runs on Modularity servers:

Orchestrator (aka Rida)
~~~~~~~~~~~~~~~~~~~~~~~

Link:
`https://pagure.io/fm-orchestrator <https://pagure.io/fm-orchestrator>`__

Orchestrator coordinates module builds. It accepts new build requests
from client tools, schedules and coordinates build of module and tracks
the module build status.

PDC fork
~~~~~~~~

Link:
`https://github.com/fedora-modularity/product-definition-center <https://github.com/fedora-modularity/product-definition-center>`__

This is Modularity aware fork of PDC (Product Definition Center). It is
used as server-side storage of built modules' metadata. Other server
side services uses it to get information about built modules.

PDC updater
~~~~~~~~~~~

Link:
`https://github.com/fedora-modularity/pdc-updater <https://github.com/fedora-modularity/pdc-updater>`__

PDC updater updates the Product Definition Center based on the fedmsg
messages.

Build Pipeline Overview (BPO)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link:
`https://github.com/asamalik/BPO <https://github.com/asamalik/BPO>`__

This is a web service providing a single UI for accessing information
about build states of modules.

Client side projects
--------------------

This is list of client side projects which are executed on client system
to work with modules:

Modularity DNF plugin
~~~~~~~~~~~~~~~~~~~~~

Link:
`https://pagure.io/fm-dnf-plugin <https://pagure.io/fm-dnf-plugin>`__

This repository contains "dnf module" plugin which is use to managing
modules on client systems. It can search for modules, enable them,
disable them, update them and so on.

Pyrpkg fork
~~~~~~~~~~~

Link:
`https://pagure.io/fork/karsten/rpkg.git <https://pagure.io/fork/karsten/rpkg.git>`__

This is Modularity aware fork of pyrpkg library. When installed, it
extends the fedpkg command with "module-build" subcommand.

Modules
-------

This is list of modules described in the Modulemd metadata format which
can be used as an examples of modules:

Base-runtime
~~~~~~~~~~~~

Link:
`https://pagure.io/base-runtime <https://pagure.io/base-runtime>`__

This repository contains module definitions for the so-called
base-runtime as well as other essential modules needed at both run- and
build-time. This set of modules should provide everything module
developers need to build their own.

FM Modules
~~~~~~~~~~

Link: `https://pagure.io/fm-modules <https://pagure.io/fm-modules>`__

Example of various modules like httpd or mariadb.
