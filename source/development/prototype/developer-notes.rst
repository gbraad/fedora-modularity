Developer Notes
===============

Abstract
--------

The purpose of this document is to describe systems and services used
for generic `Modularity <Modularity>`__ development, research and
possibly future infrastructure deployments, and is intended as a
reference guide for the involved engineers and the so-called
*doers-of-things*.

If you're new to Modularity, start with the following instead:

-  `Modularity <Modularity>`__
-  `Modularity/Getting\_involved <Modularity/Getting_involved>`__
-  `Modularity/Infra <Modularity/Infra>`__

Systems
-------

We use a number of systems for Modularity work. Some of those are
dedicated installations for our cause, some are generic and shared with
other Fedora initiatives. This section focuses on the former.

dev.fed-mod.org
~~~~~~~~~~~~~~~

The main and currently the only dedicated system we have.

This is an OpenStack instance running Fedora. In case the
``dev.fed-mod.org`` domain name no longer works, the IPv4 address is
``209.132.184.168``. We use a shared user account named ``fedora``. If
you need access, contact any of the current engineers and provide them
with your public SSH key.

Automatic COPR rebuilds
^^^^^^^^^^^^^^^^^^^^^^^

We run automatic `COPR
rebuilds <https://copr.fedorainfracloud.org/groups/g/modularity/coprs/>`__
of certain modularity projects (fm, modulemd and modulemd-resolver) with
a cron job every 15 minutes. Edit ``~fedora/rebuild_packages.sh`` to add
yours.

Automatic documentation rebuilds
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We also run automatic `readthedocs.org <http://readthedocs.org/>`__
documentation builds every 15 minutes for fm and modulemd with simple
cron jobs.

Metadata service
^^^^^^^^^^^^^^^^

The metadata-service is deployed on this system and handles all
``^/fm/(.+)`` HTTP requests. This API isn't really defined yet. Browse
the project's sources to see how it works.

Status reports and agile tools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our `Taiga status reports <http://www.fed-mod.org/taiga-report/>`__ are
also hosted on this sytem and regenerated every 15 minutes, again, with
a cron job.

Other agile tools such as the Modularity Bot or sprint-tools for
Trello/Taiga synchronization are also hosted here. See
``~fedora/fm-trello-taiga-sync``, ``~fedora/sprint_tools`` and the
various related cron jobs.

Webhosting in general
^^^^^^^^^^^^^^^^^^^^^

The host is running a generic httpd webserver. The configuration is kept
in ``/etc/httpd/conf.d/fm.conf`` and we use the default web root for our
stuff, ``/var/www/html``. For example, the experimental `modules
repository <http://fed-mod.org/dev/modules/>`__ is hosted there.

Feel free to use this for whatever you need. However, keep in mind the
available disk space on this machine is fairly limited.

Services
--------

The high-level purpose of the majority of the services listed below is
described in the `Modularity/Infra <Modularity/Infra>`__ document.

The input
^^^^^^^^^

Module input data consists of two main parts — the `module definition
file in the modulemd
format <https://fedoraproject.org/wiki/Fedora_Packaging_Guidelines_for_Modules>`__
and the components, such as RPMs (coincidentally the only format we
currently support but expect that to change at some point in the
future). In Fedora, both the modulemd files and the components' SPEC
files are stored in dist-git and the associated ACLs are stored in pkgdb
(Package Database).

We use namespaces to distinguish between modules and RPMs in those two
systems, aptly named ``modules`` and ``rpms``.

.. raw:: mediawiki

   {{admon/note|How To Build A Module In Staging|A more up to date workflow is [[Modularity/HowToBuildAModuleInStaging|available]]}}

dist-git
''''''''

For development and testing purposes we use the `staging dist-git
instance <http://pkgs.stg.fedoraproject.org/cgit>`__ which supports the
above mentioned namespaces. The recommended way to interact with
dist-git is using the ``fedpkg`` tool and configuring it to interact
with this instance.

Once you have installed fedpkg, edit ``/etc/rpkg/fedpkg.conf`` (or
wherever your ``fedpkg.conf`` is located) to change all occurrences of
the default ``pkgs.fedoraproject.org`` to
``pkgs.stg.fedoraproject.org``.

Here is an example:

Install pag via ``$ sudo dnf install -y pag``. Once you have done this,
download and set up the custom rpkg repo:

::

    $ cd /tmp
    $ pag clone karsten/rpkg
    $ cd rpkg/src

Next, set fpkg to point to stg/rida. To do this, add
``fedpkg-stage.conf`` to ``/tmp/rpkg`` and input the following content:

::

    [fedpkg]
    lookaside = http://pkgs.stg.fedoraproject.org/repo/pkgs
    lookasidehash = md5
    lookaside_cgi = https://pkgs.stg.fedoraproject.org/repo/pkgs/upload.cgi
    gitbaseurl = ssh://%(user)s@pkgs.stg.fedoraproject.org/%(module)s
    anongiturl = git://pkgs.stg.fedoraproject.org/%(module)s
    tracbaseurl = https://%(user)s:%(password)s@fedorahosted.org/rel-eng/login/xmlrpc
    branchre = f\d$|f\d\d$|el\d$|olpc\d$|master$
    kojiconfig = /etc/koji-stage.conf
    build_client = koji
    clone_config =
      bz.default-tracker bugzilla.redhat.com
      bz.default-product Fedora
      bz.default-version rawhide
      bz.default-component %(module)s
      sendemail.to %(module)s-owner@fedoraproject.org
    distgit_namespaced = True
    ridaurl = https://dev.fed-mod.org:5000/rida

Next, get the sources:

::

    $ fedpkg --config /etc/rpkg/fedpkg-stage.conf co modules/testmodule --anonymous

Here, ``--anonymous`` is used in case you are not a packager on stg
envt.

Now build:

::

    $ cd testmodule
    $ fedpkg --config /etc/rpkg/fedpkg-stage.conf module-build

Next, review the `BPO overview <http://dev.fed-mod.org/>`__, then check
`the logs <http://dev.fed-mod.org/modularity/logs/logs.txt>`__ (in case
that nothing happens). All repositories dumped by
`pungi-signed-repo <http://dev.fed-mod.org/modularity/repos/>`__

pkgdb
'''''

A `staging pkgdb
instance <https://admin.stg.fedoraproject.org/pkgdb/>`__ is also
available, storing the modules' ACL entries.

Contact people with the admin ACL privileges for the given module for
commit access. Contact User:Ralph if you need a new module pkgdb entry &
dist-git repository.

The message bus
^^^^^^^^^^^^^^^

We expect to use `fedmsg <http://www.fedmsg.com/en/latest/>`__
extensively for inter-component communication in all stages of module
build, testing and distribution.

However, since we don't do any of those things yet, there's not much to
say about this. Read the upstream documentation to see what Fedora
Messaging is about.

The module builder
^^^^^^^^^^^^^^^^^^

The module builder consists of three main components: the build
orchestrator, the koji build system and the pungi compose tool. The
basic, overly simplified idea of building modules is:

#. The client (e.g. the module packager) contacts the orchestrator and
   requests a build.
#. The orchestrator does all the heavy lifting -- prepares the buildroot
   as a koji target, clones and builds all the components in koji in the
   correct order, run CI checks for components and modules, tracks the
   build states and rebuilds all dependant modules, if required.
#. After every module build, the orchestrator notifies pungi which in
   turn creates module deliverables.

There are still many open questions regarding this process. We will
fine-tune the details on the go.

orchestrator
''''''''''''

The orchestrator is a service with a publicly available interface that
the clients can interact with, for example by issuing
``fedpkg module-build`` as a module packager, that *orchestrates* the
complete build of modules as noted above. Note the orchestrator doesn't
yet exist and although we don't have any specific design in mind, we
expect to have *something* ready in the near future.

The orchestrator will emit fedmsg messages to interact with other
infrastructure components. It will work with PDC to both store (via
pdc-updater) and retrieve module dependency graphs. It will also require
its own database to track module build states. The public interface will
*not* be an XMLRPC.

And the service will most likely be hosted on dev.fed-mod.org.

koji
''''

The module RPM content will be built in koji. The current idea is to use
koji tags and targets to represent modules and tag inheritance to define
buildroots for RPM components. The orchestrator needs to be able to
manage these.

We expect to use the `staging koji
instance <http://koji.stg.fedoraproject.org/koji/>`__ once we have a
usable and somewhat stable orchestrator. Until then, and to allow more
flexibility when developing against koji, we also have our own Fedora
24-based koji virtual machines you can play with. They're too large to
be shared on dev.fed-mod.org. Contact User:Psabata if you're interested
in getting them.

pungi
'''''

Once all the components in the module are built, the orchestrator will
signal pungi to create deliverables, such as RPM repositories or
container images, from the respective koji tags. pungi will also store
compose information in PDC (again, via pdc-updater), push the
deliverables to mirrors (either directly or via an update system) and
interact with various other currently nonexistent RCM tools.

We're considering putting all or most of this functionality directly
into koji.

The module knower
^^^^^^^^^^^^^^^^^

We would like to store certain practical bits about modules in PDC
(Product Definition Center) so that it can be easily viewed and queried
by both humans and other infrastructure tools. Specifically, we're
interested in two kinds of information:

#. Source inter-modular dependencies — useful for tracking what modules
   need to be rebuilt
#. Compose information — for listing contents of deliverables

The first use case requires a new data type to be created in PDC.

PDC
'''

There's a `staging PDC instance <https://pdc.stg.fedoraproject.org/>`__
available we hope to use later in the development cycle.

We might set up our own instance on dev.fed-mod.org, if necessary.

pdc-updater
'''''''''''

pdc-updater is a simple, stateless service that responds to fedmsg
events and populates the PDC database. It already exists but needs some
patching to support the new data type we require.

It is unclear whether a staging pdc-updater is available. We might as
well deploy our own on dev.fed-mod.org.

The compose magic
^^^^^^^^^^^^^^^^^

Once built, modules could be composed into products such as *Fedora
Workstation*, *Fedora Server* or maybe even anything the user defines
either for integration QA purposes or building custom-tailored system
images for and by the end users. See the
`Modularity/Infra <Modularity/Infra>`__ document for more information
about these concepts.

CaaS
''''

CaaS is not yet properly designed or implemented. Therefore we haven't
thought about deployment either.

Pixie dust
''''''''''

The same for the so-called *Pixie dust*.

The update system and distribution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both modules and module composes will need to be held by some
unspecified service before they get pushed to the master mirror. This is
necessary for two reasons:

#. Human testing — verifying the builds and composes work fine beyond
   the capabilities of our CI
#. Pushing mass rebuild results as one update — simply to avoid broken
   states on the end users' systems

This might be implemented by patching the current Fedora update system
and/or introducing yet another service/layer. We could use `the staging
bodhi instance <https://bodhi.stg.fedoraproject.org/>`__ for
development. Note we have no staging mirrors or systems capable of
serving this kind of content at the moment.

Miscellanous
^^^^^^^^^^^^

We also use a number of other systems and services.

pagure.io
'''''''''

All of our own code is hosted at `pagure.io <https://pagure.io/>`__.
Many of the projects grant commit access to the `@modularity
group <https://pagure.io/group/modularity>`__. If you'd like to a part
of it, just ask any of the current members to add you.

COPR
''''

There's a `@modularity project
space <https://copr.fedorainfracloud.org/groups/g/modularity/coprs/>`__
on COPR where we build & share our tools such as fm, modulemd or
modulemd-resolver. All `modularity-wg FAS group
members <https://admin.fedoraproject.org/accounts/group/members/modularity-wg/*>`__
should have permissions to create new projects there. Contact any
modularity-wg sponsor or administrator to join the group.

Jenkins
'''''''

We have `a number of Fedora Infra Jenkins
jobs <http://jenkins.fedorainfracloud.org/job/fm-modulemd/search/?q=fm>`__
set up for the CI of our tooling. Contact User:James if you'd like
something added there.

GitHub
''''''

In order to collect our changes and submit them as pull requests, we
have our own forks for some projects which are hosted on GitHub. For
grooming prior to submitting things upstream (e.g. reviewing and merging
pull requests from individual contributors against our forks),
contributors are added to the
```committers`` <https://github.com/orgs/fedora-modularity/teams/committers>`__
team in the
```fedora-modularity`` <https://github.com/fedora-modularity>`__
organization. Please ping `Nils Philippsen <mailto:nils@redhat.com>`__
(`github <https://github.com/nphilipp>`__) to get yourself added.

Our forks:

-  `Product Definition
   Center <https://github.com/fedora-modularity/product-definition-center>`__
   (`upstream <https://github.com/product-definition-center/product-definition-center>`__)
-  `pdc-updater <https://github.com/fedora-modularity/pdc-updater>`__
   (`upstream <https://github.com/fedora-infra/pdc-updater>`__)

Category:Modularity Category:Modularization
