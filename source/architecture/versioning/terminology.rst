Basic branching terminology
===========================

First, though, note that the very word “version” is overloaded here. It
can refer either to a completely separate branch of some module, or to a
single specific instance or compose of a module. To keep terminology
straight, we need to distinguish between:

-  A **version branch**: or more simply just a **branch**: a completely
   new, carefully planned version stream for a module. This might
   correspond to a major Fedora release, or a new Fedora SCL release.
   Creating a new branch should come with a new **release** target for
   the branch (or branches if we’re releasing multiple modules
   simultaneously.)

    A version branch **may** correspond to a new **major version** of
    the module, but there may be exceptions: for example, when we add
    specific features as a side-branch of an existing major version. The
    new branch may differ by SLA (eg. EUS branches off an existing RHEL
    version branch) or by feature (eg. the RHEV-H / RHOSP version of the
    RHEL virt stack, or an “f-stream” branch giving early access to a
    specific new feature planned to be released in a subsequent update
    to RHEL.

    Users must opt into a new version branch. By definition here,
    creating a new version branch **must** have no impact on users who
    have already enabled an existing branch of a module. If a user
    provisions a new environment and asks for the most recent version
    branch, then they may get the new version branch automatically; but
    no existing environments will transparently receive content for the
    new version branch.

-  A **point-in-time version** or **instance** representing a single
   compose of a module on a single version branch, built by and
   identifiable by the **compose ID** of the task used to compose the
   module within the build system.

    Such a point-in-time update may be just a scratch build, or may be
    internal-only and not released to the user. But once it is released,
    it forms a new **update** for that version branch of the module.
    Multiple released point-in-time updates therefore form an **update
    stream** over time for that branch.
