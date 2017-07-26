Module versioning and branching
===============================

The primary core principle of Modularity is that our content should be
released not as large, monolithic distribution releases, but in units of
smaller modules designed to be assembled in different combinations.

Closely related is a second core principle: we should be able to release
new major versions of these modules on their own schedules to serve
a component's requirements; they should not all be tied to the master cadence
of today’s major release cycles.

So, at a deep level, Modularity requires us to branch and version
modules independently of each other.

Yet we need to control this complexity: the engineering involved has to
be sustainable, and the combinations we offer to the user need to be
manageable. This is especially true as different tools represent
branches in different ways (eg. bugzilla represents branches as the
“version” field for a product, and also has version-specific flags;
koji has koji tags which act as branches, etc.)

This leads to some complex constraints, which we will explore in this
document.

Ultimately, we can identify many distinct variants on branching:
sometimes different parts of the release pipeline end up with multiple
different views of the underlying branches. Just consider Fedora fXX
branches: these either look like a continuous update stream to the end
user, or *some* of the branches end up having distinct lifespans.

So while a single consistent end-to-end branching model for any module
is possible in simple cases, it is unlikely to satisfy all the product
demands for complex release structures. This suggests an approach to
branching involving:

-  A centralised representation of the current branching at any point in
   time;
-  Retain separate branch definitions in our various tools such as
   bugzilla, koji, bodhi, etc, as we have today;
-  A flexible scripting approach to automating creation of new branches
   and key transitions on existing branches (dev to beta to release
   etc), to keep branches on the different tools synchronised.

This splits *mechanism* — the central branching repository and the branch
definitions in the different tools — from *policy* — the specific branches
and transitions actioned by the scripts.

It is important to remember that the mechanism needs to be flexible
enough to represent any potential desired branching structure; but this
does not mean that all modules have to have complex branching we can
still (and we should) adopt branching policy that is as simple as
possible for any given module.


.. rubric:: TOC

.. toctree::
    :maxdepth: 1

    versioning/terminology
    versioning/properties
    versioning/coherency
    versioning/managing
    versioning/constraints
