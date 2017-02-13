Constructing a modular distribution
=========

The fundamental objective of the
`Modularity <https://fedoraproject.org/wiki/Modularity>`__ effort is to
break up the monolithic concept of a “distribution release” or
traditional Compose into something more fine-grained. We should be able
to release applications or stacks such as LAMP or ruby-on-rails on a
lifecycle that suits the application, rather than being dictated by the
distribution release schedule; and we should be able to compose releases
more flexibly from the various components available.

But modularity is unlikely to succeed if it requires both users and
maintainers to immediately and completely discard the existing concept
of Releases and Editions of Fedora. So in this document we look at how
to break the traditional distribution down into a modular construction,
while still preserving the ability to build the traditional releases.

This document does not try to explore how we should organise a
distribution release in detail. Exact lifecycles for kernel vs.
applications, for containers vs. baremetal etc. are beyond the scope
here; indeed, our objective is explicitly ''not ''to assume what we need
in a release, but rather to add flexibility so we can change release
objectives later on. If we want Fedora Server to have a longer lifecycle
than Workstation; or for Atomic to rebase docker more rapidly than
Server; or for a new python to be released outside the normal
distribution cycle; all these things may be possible if we have a more
flexible underlying release structure. The flexibility is the subject
here; planning the actual releases is a different topic.

But, ultimately we still need the well-defined concept of a **release**,
so that all the modules we are maintaining can still come together into
a well-tested, planned release on a known schedule. We also define and
justify a **static manifest** to assign packages to modules.

Once we have parts of the distribution on different release cycles, we
also have the issue of how to maintain different versions branching on
different criteria and different schedules. Branching and versioning is
relevant here, but is a complex topic in its own right and the topic of
a future document.

.. rubric:: TOC

.. toctree::
    :maxdepth: 1

    constructing/breaking-down
    constructing/compose-distribution
    constructing/back-together
