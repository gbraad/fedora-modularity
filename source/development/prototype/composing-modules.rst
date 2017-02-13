Composing Modules with Pungi
============================

Composing Modules with Pungi
----------------------------

After you have downloaded `Pungi (Modularity
style) <Modularity/Development/Getting_Pungi_(Modularity_Style)>`__ and
`the necessary Fedora
packages/repositories <Modularity/Development/Getting_Fedora_Packages_for_Testing>`__,
you can compose a module. Unlike with the versions of pungi currently
used for composing Fedora, this process is split into separate steps
with our prototype, using several distinct scripts.

This document assumes that the checked out repositories are located in
``$WORKSPACE``, the local package repositories are in ``$REPOS`` and the
compose and intermediate data will be output into ``$COMPOSES``. You
need to activate the environment for running the pungi prototype, as the
case may be by either sourcing ``$HOME/.modularity.sh`` or, if you set
up a Python virtualenv, by running ``workon modularity``.

Gathering the component packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``pungi-gather-prototype`` script produces a manifest of the desired
packages and their dependencies, in our example for a core and shells.
For productive use, these packages would come e.g. from a specific koji
tag. You may want to add the local repository with the minimized
packages, but then you have to ensure that they are preferred over the
normal Fedora packages (see
`Modularity/Development/Getting\_Fedora\_Packages\_for\_Testing <Modularity/Development/Getting_Fedora_Packages_for_Testing>`__
for details).

::

    "$WORKSPACE"/pungi/bin/pungi-gather-prototype \
        --arch x86_64 --target-dir "$COMPOSES" \
        --config "$WORKSPACE"/pungi-modularity/pungi-inputs/core.yaml \
        --source-repo-from-path "$REPOS"/fedora-24-beta-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-beta-src
    "$WORKSPACE"/pungi/bin/pungi-gather-prototype \
        --arch x86_64 --target-dir "$COMPOSES" \
        --config "$WORKSPACE"/pungi-modularity/pungi-inputs/shells.yaml \
        --source-repo-from-path "$REPOS"/fedora-24-shells-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-shells-src \
        --source-repo-from-path "$REPOS"/fedora-24-beta-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-beta-src

The script will output the location where it wrote the manifest after it
is run. At this point the manifests should be in
``$COMPOSES/manifest-{core,shells}-$date-$hash.$serial`` where ``$date``
is the current date, ``$hash`` a hash of the configuration input file
and ``$serial`` a serial number which will be incremented if you run the
same invocation several times.

Creating repositories from the manifests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``pungi-createrepo-prototype`` script creates an installable
repository from the previously gathered manifests. You need to supply
the manifest directory locations from the previous step.

::

    "$WORKSPACE"/pungi/bin/pungi-createrepo-prototype \
        --arch x86_64 --target-dir "$COMPOSES" \
        --source-repo-from-path "$REPOS"/fedora-24-beta-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-beta-src \
        --static-content-manifest "$COMPOSES/manifest_core-x86_64-$date-$hash.$serial/" \
        --extra-file "$COMPOSES/manifest_core-x86_64-$date-$hash.$serial/fm-metadata.yaml"
    "$WORKSPACE"/pungi/bin/pungi-createrepo-prototype \
        --arch x86_64 --target-dir "$COMPOSES" \
        --source-repo-from-path "$REPOS"/fedora-24-shells-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-shells-src \
        --source-repo-from-path "$REPOS"/fedora-24-beta-x86_64 \
        --source-repo-from-path "$REPOS"/fedora-24-beta-src \
        --static-content-manifest "$COMPOSES/manifest_shells-x86_64-$date-$hash.$serial/" \
        --extra-file "$COMPOSES/manifest_shells-x86_64-$date-$hash.$serial/fm-metadata.yaml"

This may seem a bit roundabout since we started out with repositories,
but it will collect only the packages defined in the ``core.yaml`` and
``shells.yaml`` configuration files and their dependencies.

At this point, the repositories should be at
``$COMPOSES/repo_{core,shells}-x86_64-$date-$hash.$serial``

Composing the module
~~~~~~~~~~~~~~~~~~~~

The ``pungi-compose-prototype`` script composes the module metadata from
the variants file
``"$WORKSPACE"/pungi-modularity/pungi-inputs/variants-fm.xml`` and the
previously created repositories.

::

    "$WORKSPACE"/pungi/bin/pungi-compose-prototype \
        --release fedora-24 --arch x86_64 --target-dir "$COMPOSES" \
        --variants-file "$WORKSPACE"/pungi-modularity/pungi-inputs/variants-fm.xml

At this point the compose metadata directory should be at
``$COMPOSES/compose_fedora-24-$date.$serial``.
