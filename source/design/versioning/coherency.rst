Coherency of branching
======================

There are many advantages to be had in a single, coherent view of the
branching structure for a given module.

Maintainers and users alike have to deal with branches in multiple
places:

-  We plan, develop and build content in bugzilla, dist-git
   and koji, then release it through bodhi. All of these
   tools share a common understanding of the various product branches
   (fXX etc.) and work flows naturally between them.
-  Users consume products knowing which branch they are on; they
   have the option to choose between branches (F25 after F26 has 
   been released), and they report bugs and
   review CVEs corresponding to those branches

It also seems highly desirable to automate creation of branches,
especially when we consider a future with many more modules than we have
today, each with their own branches.

But the idea of a clean, consistent view of branching that is unified
end-to-end falls down in several places. Some of the difficulties
include:

**Utility side-branches:** Some of our tools have slight variants on the
main branch naming to support specific workflow requirements.

For example, in CI we can have staging branches alongside the production
release branches, and in koji we have scratch builds; these follow the
main branching but are intended for developer use cases, rather
than automatically being candidates for release.

We have candidate tags, beta tags and release tags in koji, indicating
packages on various different stages of the lifecycle from development
to release. Beta branches in general represent a special case here.

**Multiple views of branching:** There are several places where two
different parts of the release pipeline can treat branching differently
from each other. Two important examples here include **minor version
branching** and **per-edition views** of a component:

**Minor-version branching**: TBD

**Per-edition views** of branching: TBD

**Branch fluidity:** TBD

**Naming policy:** TBD

**Consistency of release:** Finally, we need to consider the granularity
of branches. The purpose of modularity is to allow us to release modules
independently from a single master release cadence. But do we really
want all modules to be released without any synchronisation or common
branching at all?

History suggests we do not. 

In the future we likely have many completely-decoupled modules for
additional content outside the base Fedora runtime platform. But we may
still eventually decide that we want to have synchronised releases of
new content across different modules.

So while modules can have independent branches, we still need the
ability to drive a common branching structure across a set of modules
when that is needed for product release requirements. First-class
support for such a **consolidated release** is absolutely necessary; to
devolve the distribution into an unmanaged, completely-uncoordinated set
of independent modules is likely unsustainable for both engineers,
maintainers, and users alike.
