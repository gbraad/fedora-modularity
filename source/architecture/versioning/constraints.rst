Constraints on branching
========================

The above seems to say “branching is hard, let’s not assume what it
looks like but just store a flexible representation that we can adapt as
we need.”

That’s true to some extent… but there *are* concerns we can anticipate
that we need to handle in our branching structure. Having covered the
fundamental principle that branching policy needs to remain flexible,
let’s look at some of the issues we need to handle as we define that
policy.

Splitting a binary package build over multiple modules
------------------------------------------------------

This is something that is surprisingly common in RHEL. It happens
typically because we do not want to give the same level of support to
all sub-packages from a single upstream source.

Examples might be when we want to include a library to support our own
applications, but do not want to give it full support for end-users; we
might include the library itself in RHEL, but split out the ability to
develop against it (the include files, static libraries etc. that
typically land in a -devel binary rpm) into, say, Optional. Or we might
want to reserve certain functionality for specific products: eg.
providing only guest hardware devices in cloud images, without offering
hardware enablement with the full complement of kernel hardware drivers.

Can we do this naturally in a modular build chain? Clearly it breaks any
assumption that a module can be both compiled and composed in complete
independence from any other: if a package build ends up in multiple
modules, then the compile phase of building those modules is now linked.
We need to determine how important it is to support this.

But it is still quite possible to achieve, if the modules which are to
share binaries have matching branches. In that case, module composes can
always agree on which brew/koji branches [tags] to consume packages
from. So this may be fairly easy for modules which are part of a single
consolidated release, as defined above; it would be fair to restrict
this possibility to that case.

Building a module in multiple build roots
-----------------------------------------

Does a single module source branch result in a single composed binary
branch? Or do we build that same source multiple times against different
base distribution build roots?

Clearly, branching becomes enormously more complicated if we need to
support builds for multiple different build roots in a single branch.
The idea of a single coherent branching structure from git to release is
broken if we have multiple output branches from a single input branch.

But the entire point of ABI forwards compatibility is to avoid the need
to do this: to run a module on a set of major runtimes, it should in
theory be necessarily simply to build it on the oldest runtime in that
set. A module built on RHEL-6 should run on RHEL-7 or -8, as long as it
is using only dependencies with tier-1 API stability guarantees.

So before working through the complexities of commit-once,
compile-multiple-times, it will be important to determine to what extent
we can simply depend on ABI compatibility to ensure a module works
against multiple runtimes.
