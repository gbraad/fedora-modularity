Coherency of branching
======================

There are many advantages to be had in a single, coherent view of the
branching structure for a given module.

Maintainers and customers alike have to deal with branches in multiple
places:

-  Internally we plan, develop and build content in bugzilla, dist-git
   and koji/brew, then release it through the errata tool. All of these
   tools share a common understanding of the various product branches
   (rhel-x.y etc.) and work flows naturally between them.
-  Customers consume products knowing which branch they are on; they
   have the option to choose between branches (RHEL 7.y with EUS options
   to stay on an extension of an old branch), and they report bugs and
   review errata corresponding to those branches

It also seems highly desirable to automate creation of branches,
especially when we consider a future with many more modules than we have
today, each with their own branches.

But the idea of a clean, consistent view of branching that is unified
end-to-end falls down in several places. Some of the difficulties
include:

**Utility side-branches:** Some of our tools have slight variants on the
main branch naming to support specific workflow requirements.

For example, in CI we can have staging branches alongside the production
release branches, and in brew we have scratch builds; these follow the
main product branching but are intended for developer use cases, rather
than automatically being candidates for product release.

We have candidate tags, beta tags and release tags in brew, indicating
packages on various different stages of the lifecycle from development
to release. Beta branches in general represent a special case here.

**Multiple views of branching:** There are several places where two
different parts of the release pipeline can treat branching different
from each other. Two important examples here include **minor version
branching** and **per-product views** of a component:

**Minor-version branching**: Our internal build pipeline considers (eg)
RHEL-7.0, 7.1 and 7.2 to be quite distinct branches. This is deliberate:
it allows us to work on development of the next minor release while
still releasing updates to the existing minor release. It also enables
us to maintain long-life support for older minor releases, and allows
EUS customers to subscribe to those long-life branches.

But this introduces an inconsistency between the development branching
model and the user consumption model for normal RHEL updates. The
developer model includes distinct discrete minor update branches; the
consumption model is a single ongoing stream of updates, consisting of
smaller z-stream fixes punctuated by less frequent, larger updates.

Note, we do not know if our desired branching will look like this in a
future modular RHEL. We may choose to simplify things here. But we need
to be at least prepared for such a branching model; indeed, some of the
models under consideration for future RHEL kernel branching may be even
more complex that what we have today, with separate branches for
different severity of erratas for a single release.

Note that ''not all modules will need or want this complexity.
''Flexibility is important here. We need to automate relatively simple
branching models for modules similar to SCLs that live as self-contained
bundles of content, as well as more complex branching structures to
enable future PM requirements.

**Per-product views** of branching: We have significant issues when two
different products share the same branching of the same components. A
classic example is the RHEL base release repackaged and shipped as
RHEV-H, part of the RHEV virtualisation product line. Much of the base
RHEL release is included with RHEV and is built as part of the RHEV-H
hypervisor build.

The problem occurs when a customer tries to report a bug against such a
shared package. If we have a bug in, say, kernel for RHEV-H, the
customer bug is typically filed in bugzilla against the RHEV-H product.
But the kernel is actually maintained inside RHEL, not RHEV.

So we need to manually clone the bug from RHEV to RHEL, then fix the bug
in RHEL, push it as a RHEL update, and finally duplicate the RHEL errata
to RHEV.

The underlying problem here is that a shared component like this has two
different views: a developer view which is based around maintaining the
single, shared internal build branch; and an external view which is
based around the multiple product-specific update streams in which the
component appears.

It seems difficult and complex to come up with a single common branching
model that reflects these two views. Different products legitimately
need to have different branching numbering and policies. We may simply
have to live with the developer and customer views of branching being
different.

But we still need to scale our processes when these two branching views
differ. A goal of modularity is to make it easier to share modules
flexibly between different products or applications, so this scenario is
only likely to become more common. Relying on manual effort to keep
tooling consistent across different product branches is unlikely to
scale; reconciling these two views may require either changes to our
tools, or automation to synchronise issues across shared branches.

**Branch fluidity:** Branching can vary over time depending on
subscription/entitlement and lifecycle. A good example here is the RHEL
y-stream release train. Internally, rhel-7.0, rhel-7.1 and rhel-7.2 are
all distinct branches in dist-git, brew and bugzilla. And yet a
customer’s update stream does ''not ''reflect this: when 7.2 is
released, a yum update of a 7.1 RHEL installation will automatically
download and install all new 7.2 content. So the “current branch” for a
standard RHEL subscription changes over time as y-stream updates occur.

Note that this only changes for the end-user. A developer still sees
7.0, 7.1 and 7.2 as distinct branches; it’s the update stream for
subscribers to that content that has to change when a new minor update
occurs.

Furthermore, the 7.1 branching itself changes over time. We use rhel-7.1
during 7.1 development. But once 7.1 is released, things change: the
devel branch in now 7.2; the 7.1 is still branch is now used for commits
queued for z-stream errata, but the brew tag moves to rhel-7.1-z and we
start using 7.1-Z flags in bugzilla.

And even after 7.2 is released, 7.1-z updates may still be available to
''some ''customers but not all, depending on whether we have an EUS
branch for 7.1 and whether the customer is entitled to EUS and has
chosen to enable it for a given system.

So even just for a single update stream—RHEL-7 latest—our definitions of
development, beta, scratch and errata branches, and the representations
of those in various different tools, are complex and dynamic. We need to
consider the concept of a **branching transition**, when an event occurs
that requires coordinated changes in the status, names, or flags for a
single ongoing version branch of a module. The alpha/beta/RC release or
initial public general release of a module, being superseded by a newer
version, entering update stream after release, or end-of-life could all
be possible transition events for a module.

**Naming policy:** Naming for existing branches is also flexible and
inconsistent today. The rhel-7.1 branch is a natural successor to
rhel-7.0: you update from one to the next seamlessly. Rhscl-2.2 added
new packages but did not obsolete anything in rhscl-2.1. Fedora does not
have x.y minor version numbers at all, and uses a completely different
name (rawhide) for ongoing development.

Such inconsistency is not a problem needing fixed: rather, it reflects
that different products and different modules can have fundamentally
different product needs. The naming needs to reflect those needs, not
constrain them. Naming policy is something that likely needs driven more
by PM requirements than by technical modularity implementation.
Flexibility here is paramount.

**Consistency of release:** Finally, we need to consider the granularity
of branches. The purpose of modularity is to allow us to release modules
independently from a single master release cadence. But do we really
want all modules to be released without any synchronisation or common
branching at all?

History suggests we do not. We currently have consolidated batch errata
across all of RHEL-7; RHEL itself, plus Extras (including all our
container support), follow this same schedule. We try to synchronise
feature development between container infrastructure and core RHEL.

In the future we likely have many completely-decoupled modules for
additional content outside the base RHEL runtime platform. But we may
still eventually decide that we want to have synchronised releases of
new content across different modules; this is very much how software
collections work today, where new SCL releases are still launched
together as a common RH-SCL version launch.

So while modules can have independent branches, we still need the
ability to drive a common branching structure across a set of modules
when that is needed for product release requirements. First-class
support for such a **consolidated release** is absolutely necessary; to
devolve the distribution into an unmanaged, completely-uncoordinated set
of independent modules is likely unsustainable for both engineering and
customer alike.
