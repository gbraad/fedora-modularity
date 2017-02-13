FAQ
===

How is this related to `Environment Modules <Packaging:EnvironmentModules>`__?
------------------------------------------------------------------------------

Environment Modules are a concept unrelated to the Modularity
initiative.

What is the concept of a module?
--------------------------------

-  A module can be thought of as a dotted line we draw around a set of
   components that we declare a “thing.” It makes sense to think of a
   module as unit of measure larger than a traditional RPM.
-  A module is a unit of delivery, that is always tested together and
   released together. That said, we would like to provide a
   short-circuiting mechanism for a sys-admin/ops person whereby they
   can knowingly "break" a module by applying a library update because
   the module is not being released in a timely manner.
-  A module as a whole has its own lifecycle that is independent of any
   other module. Maintainers may decide to release multiple modules
   together on a common release schedule, but it is always possible to
   release modules independently when desired.
-  A module may include different versions of components than other
   modules.
-  A module comes with associated metadata: this may include such things
   as lifecycle information (when does the module go end of life), who
   maintains it and to what support level, etc

What is a module in a practical sense?
--------------------------------------

We want to use this definition for the sake of prototyping and early
implementation. We may find this changes based on the prototypes. For
now, a module is:

-  A repository. Yeah, just a plain old RPM repository (for now). A
   module definition declares what RPMs it includes (both hard requires
   and optionally requires). All of these RPMs are included in the repo
   that “is” the module. A module may also specify in its definition
   that it depends on one or more other modules, but it may not specify
   any of the RPMs in that "remote" module.
-  A module has a unique name
-  A module can have multiple distinct versions, likely corresponding to
   distinct functionality or ABI versions; and multiple versions may be
   available at the same time.
-  Each version of a module has its own independent update stream
   associated with it. We avoid changing ABI or intentionally breaking
   forwards compatibility in any way within the update stream of a
   single version.
-  Has a well known set of non-runtime dependencies which are not
   available in the same "repo" as the module itself. While it seems
   like this could be easily supported in the "for now" case, having
   this requirement makes sure we don't paint ourselves into a corner.
-  A module has an API. In essence, the API is what "makes" the module.
   For example, if we had a "Web server" module, its "api" might be
   HTTP/2, we could provide that using httpd or nginx, and, next week,
   swap it, because the api is king, not the binaries inside. However,
   while we need to consider the API model, full support of this may not
   be necessary for the MVP.
-  Alluded to earlier, but, a module is \*not\* self-hosted. That
   doesn't mean Fedora doesn't know how to build it, or that the
   information and steps to build it aren't available, just that the
   consumer has to take some extra steps to find this information. We
   don't, necessarily, want to consider the build deps the same level of
   quality as the module itself. In the future, an “edition” or a “spin”
   would be composed of a set of modules (vs a set of RPMs).
-  Not directly installable and/or may be installers themselves. In
   other words, a module does not have to carry tooling to get itself to
   the end user.

OK, so what is modularity?
--------------------------

Modularity is an ongoing initiative in Fedora to resolve the issue of
divergent, occasionally conflicting lifecycles of different components
(modules).

What is a module’s lifecycle?
-----------------------------

A module as a whole has its own lifecycle independent of any other
module. Maintainers may decide to release multiple modules together on a
common release schedule, but it is always possible to release modules
independently when desired.

What are a module’s standard properties?
----------------------------------------

-  A module has a unique name.
-  Each version of a module has its own independent update stream
   associated with it. We avoid changing ABI or intentionally breaking
   forwards compatibility in any way within the update stream of a
   single version.
-  A module has a well known set of non-runtime dependencies which are
   not available in the same “repo” as the module itself. While it seems
   like this could be easily supported in the “for now” case, having
   this requirement makes sure we don't paint ourselves into a corner.
-  A module has an API. In essence, the API is what makes the module.
   For example, if we had a Web server module, its API might be HTTP/2.
   We could provide that using httpd or nginx, and, next week, swap it,
   because the API is king, not the binaries inside. However, while we
   need to consider the API model, full support of this may not be
   necessary for the
   `https://en.wikipedia.org/wiki/Minimum\_viable\_product
   MVP <https://en.wikipedia.org/wiki/Minimum_viable_product_MVP>`__.
-  A module comes with associated metadata such as lifecycle information
   (when does the module go end of life), who maintains it and to what
   support level, etc.
-  A module may include different versions of components than other
   modules.

Note: We still don't know what kind of API we're going to define. So far
we've only considered marking some of the provided binary packages as
the module's "external API". That way we know what to test on updates
and module consumers know what binary packages they can rely on. I'm not
sure modules are ever going to provide abstract APIs.

Why do we call it modularity?
-----------------------------

We are trying to use an agnostic term so as not to indicate the specific
nature of a module or a component. Modules can be big or small, low or
high-level, brand new or very mature. As a result, please try not to
ascribe too much meaning to the word module or component aside from
being a slightly prettier and shorter version of “chunk of some stuff.”

Why are we pursuing this goal?
------------------------------

Well, there a a lot of reasons but, I think, the simplest is to try to
disconnect the lifecycle of major components from each other so that
they can grow and change at the speed that is appropriate to the
component. Why does that matter? Well, that is a significantly more
complex conversation and somewhat beyond the scope of this document.

I heard there were videos?
--------------------------

Yes, videos are delivered at the completion of every sprint and posted
to a `Fedora Modularity
YouTube <https://www.youtube.com/channel/UC4O8G9SZwqtkIAuKcT8-JpQ>`__
channel.

Where can I find out more?
--------------------------

The best place to start is where you already are:
`Modularity <Modularity>`__

As the wiki evolves, categories and new content will be added. Make sure
not to miss the blog: https://communityblog.fedoraproject.org/

-  Blog posts tagged with “Modularity”
   https://communityblog.fedoraproject.org/tag/modularity/

-  `Infra <Modularity/Infra>`__ segment of the wiki

-  `Developer Notes <Modularity/Developer_Notes>`__ segment of the wiki

Category:Modularity Category:Modularization
