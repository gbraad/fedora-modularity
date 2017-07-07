Managing this branching complexity
==================================

Given that the exact branching policy for a module is currently
inconsistent, needs to remain flexible, and changes
over time, how do we manage this? The question is especially significant
given that we are looking at significant changes to the way we divide
and release the distribution in the future; our future branching model
is currently completely unknown.

This suggests that we should not try to formalise a branching and naming
policy at all. But we **must** eventually have automation for the
creation of branches and for branch transitions, especially given that
release consistency may require us to coordinate new branches across
many modules simultaneously. And our tools still need consistent views
across this complex branching structure.

Separation of policy from representation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This suggests that we need:

-  A canonical definition of our modules and their branches at any point
   in time, including the way those branch names are represented in
   different tools:
-  Consistent use of that canonical branching structure within our
   tools, but with
-  Flexible, scripted events to drive changes in the branching.

We can do this by separating the central representation of branching
(eg. in PDC) from the mechanism used to define and update that
branching.

Changes in branching also need to be orchestrated: we should not define
a new branch and allow a developer to start building on that branch,
before the branch has been created in bugzilla, dist-git, koji etc.
There are many tools that could be used here: ansible is just one such
tool. The point here is to identify that as a separate concern.
Automation here is important if we want to be able to support
coordinated release branching across a set of modules.

For now, we are dealing with a relatively simple branching structure,
building simple modules out of the latest Fedora. We don’t *need*
complex branching policy right now. But separating out representation
from policy allows us to start with a simple branching structure
initially, and still lets us define, and script, more complex,
product-specific branching requirements later, while having those
consistently represented in a central database that our tools can refer
to and agree on.

Forking a new branch
~~~~~~~~~~~~~~~~~~~~

We have mentioned that creating a new branch for a module involves
branching multiple different tools: we need a branch for the module in
dist-git, new branches for its components, and corresponding branches in
bugzilla; we may need new tags in koji.

This implies that the branching for a module is (usually) the same thing
as the branching for all the component packages of that module.

But sometimes we will not want to branch *all* packages; we may want a
variant branch of a module which overrides just some of the packages,
and which otherwise inherits the content (''including new content)
''from its base branch.

There are many examples which would suit such a **inheriting branch.**
The f-stream model which allows early access to new features prior
to an update, is an example. Another might be the specialized version of
the virtualisation stack, which contains a version of kvm-qemu with
newer features but which otherwise follows Fedora. The model also
works for scratch or staging branches, where we can build and test
updates to an existing branch as needed to suit internal developer
needs.

This suggests that we want to include tooling support for inheriting such a
branch. Technically, this might involve creating new branches
for only a subset of the packages of a module; and recording the base
module from which we pull other packages during a module compose.

Converging branches
~~~~~~~~~~~~~~~~~~~

Just as important as forking a new branch is converging existing
branches. In an f-stream model, a new feature scheduled for the next release 
is made available in a prior release. The f-stream is the early-access branch; 
the intent is that when the next release occurs, it introduces that 
feature into the mainline stream, and the f-stream is no longer
needed: any component depending on that feature moves back off the
f-stream branch and onto the mainline.

Extending this to a modular build, we can imagine a component
needing a new feature within any module in our stack. If that module
does not plan the feature to be released in time, we can fork a specific
version of the module to serve the needs of the one component needing the
new feature; but if and when that feature is released in some mainline
version of the module, we want the ability to move the component
off the forked feature branch and back onto mainline.

There are likely to be many complexities here; the important point is to
imagine up-front that forking a new branch is only half the picture, it
will be useful to have tooling support for converging branches again
afterwards too.

Managing unsynchronised stacks of branches
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modules can depend in turn on other modules. We have defined a “stack”
as the entire tree of modules needed to satisfy dependencies for one
top-level module or application. But as we combine modules in this way,
not all those modules will have the same branches or lifecycle.

So when we have multiple, different, unsynchronised branching models for
different modules within a stack, how do we know exactly which branches
of which modules we need to combine together? We can agree that we need
to constrain this complexity, and define specific subsets of modules
which we will test and support together. The issue is where, and how, to
define this.

This is an issue we still need to solve. There two obvious places to
hold this structure: in the **release** that defines multiple modules
and their combined release schedules; or by defining specific branch
dependencies in each module’s own module metadata.

Both have pros and cons. Defining specific branch dependencies in a
module’s metadata helps by keeping more of the module’s defining
structure in one place. However, the downside is that it becomes
impossible to use that same metadata in multiple places without changing
it: eg. building a single module from the same module source on multiple
buildroots is impossible if the module source itself defines its
buildroot dependency.

So this is a topic for future consideration.
