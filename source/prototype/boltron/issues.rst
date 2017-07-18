Known Issues
============

This page tracks the known issues in the Boltron release. If you find anything that is not here, you can submit it into the issue tracker.

Issue tracker
-------------

Apart from the `main modularity issue tracker <https://pagure.io/modularity/issues>`__, there are also issue trackers for the individual modules, available in the `Fedora Modularity: Modules GitHub space <https://github.com/modularity-modules>`__.

You can also use one of the feedback forms: :doc:`/prototype/boltron/feedback`.

List of known Issues
--------------

DNF doesn't show some modules as installed
..........................................

This is specificaly about the `base-runtime`, `shared-userspace`, and `dnf` modules. The packages from these modules are avilable, but the `dnf module list --installed` won't list them.

Microdnf doesn't support modules
................................

Microdnf is a lightweight version of dnf written it C, so it doesn't depend on Python. It supports only the basic commands like install. Right now, it doesn't support modules, so the full version of DNF needs to be used.

