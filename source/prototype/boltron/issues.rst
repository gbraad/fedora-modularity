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

Microdnf and rpm-ostree don't support modules
................................

Besides `dnf`, there are two other package managers in Fedora.  Both `microdnf` and `rpm-ostree` use `libdnf`, which does not yet support modules.  If you're building a container, use the non-minimal image.  A future version of Atomic Host's  `rpm-ostree` package layering may support modules.

Update command is `dnf module update`, not `dnf update`
.......................................................

As Boltron won't get any updates, the update functionality wasn't the biggest priority. Even with this it has been fully implemented client-side in a 'dnf module update' command. The 'dnf update' command will work as expected in F27.
