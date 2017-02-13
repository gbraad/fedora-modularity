Building and naming modular things
=========

We have some basic terminology confusion around modules. Is a container
image the same thing as a module? Is a software collection a single
module, or a group of modules? We can often get away with being vague,
but for technical planning we need to be able to distinguish between all
these concepts.

I propose we use these terms:

-  **Package**. Essentially, the same thing as an rpm. In the future it
   might be non-rpm content but should fit the same role.
-  **Module.** A set of packages tested and released together as a
   distinct unit, complete with the metadata needed to manage it as a
   unit. May depend on other modules.
-  **Stack.** A complete tree of modules. A stack can be thought of as
   a top-level module, with the understanding that we’re implicitly
   including all of that module’s dependencies in the stack.
-  **Artifact** or **image**. An actual set of bits built out of
   modules, in a format intended to be distributed or deployed in some
   way.

Generally, these serve distinct purposes. A module is a building block;
a stack contains all the software for a complete solution; an artifact
is a concrete object containing a stack (or stacks) for distribution to
users.

We will also distinguish between:

-  A **Build** of a package: a process which involves compiling source
   code and creating a packaged output; and
-  A **Compose** of a module: a process which assembles pre-compiled
   packages into an organised module, but which includes no compilation
   step itself.


.. toctree::
    :maxdepth: 1

    building-naming/package
    building-naming/module
    building-naming/stack
    building-naming/artifact
    building-naming/fit-together
