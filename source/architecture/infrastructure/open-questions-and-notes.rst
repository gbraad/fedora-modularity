Open Questions and Notes
======

Open Questions
--------------

As mentioned before, we have an open question about how to **uniquely
identify components** and modules. That’s outside the scope of this
document, but a decision there will have impact on what we need to
build.

Not mentioned so far - we need a way to **store, query, and view SLA and
EOL information for modules**. Bear in mind that the “EOL” information
for packages currently is tied to the distro-release for that package.
So, whenever F17 goes EOL, that’s when the branch for that package goes
EOL. One of the principal reasons for getting into this whole modularity
mess was to have independent lifecycles between modules; tying it only
to a distro release just won’t do.

One idea here is to keep the EOL information in the module’s yaml
metadata definition. If we go that route, we’re going to need to also
store a cache of that authoritative data somewhere so that it can be
queried by our other web services. We’ll need to build an interface to
the data for the compose side of the pipeline, so that people putting
together a release of the distro can be sure that none of the modules in
that release are going to go EOL before the distro release is supposed
to go EOL. We’ll need to build a separate interface to the data from the
packager side of the pipeline, so that people modifying modules can see
what the EOLs of things they depend on are, and what things what what
EOLs depend on their module.

Note that **bodhi** is notoriously absent from the above diagram. That's
because we haven't yet decided how module lifecycles are going to
related to the distro lifecycle. Once we have that figured out, we'll
have to circle back here and figure out how bodhi fits in (since it is
primarily about shipping updates to previous releases of the distro).

Lastly, we need to appreciate what kind of **load this could put on the
mirror network**. We’ll be creating many more repos. What kind of
overhead does that bring? Will we need to restructure the way mirrors
selectively pull content? Nothing fundamentally changes here. It is a
matter of quantity.

Notes
-----

It is useful to step back for a moment and think about some of the
really cool new systems we have, like Koschei and OSBS.

**Koschei** is a kind of continuous integration service. It monitors new
builds in koji and in response, tries to also rebuild packages that
depend on that package (as scratch buidls). In doing so, it attempts to
find situations where packages inadvertently fail to rebuild from
source, which is really useful. It has to suss out and maintain a
dependency graph to accomplish this. For rpms only, it looks somewhat
like the orchestrator tool in our diagram above (except less committed.
It does scratch builds, not real builds.)

**OSBS** is a build system that we use to build docker containers. We
run it as a kind of child of koji. It performs builds, and submits them
back for koji to store via koji’s Content Generator API. It is
particularly cool in that it automatically rebuilds containers that
depend on one another. For docker containers only, it looks somewhat
like the orchestrator tool in our diagram above (except less integrated
with our environment. It is buried behind koji.)

You can see that we’re all heading towards some of the same patterns in
our approach, but we lack a unified approach to modifying the pipeline
as a whole. That’s understandable.. It’s big and hard to change!
Furthermore, there’s likely a social explanation at root, with respect
to `Conway’s Law <https://en.wikipedia.org/wiki/Conway%27s_law>`__. We
have an opportunity here to change that.

If we can solve the dep-graph modelling, chain-rebuilding, and CI
problems generally in the pipeline, then we’ll be all the more situated
to easily adapt to the next wave of technological change.
