Infrastructure
============

One part of the so-called “Factory 2.0”

The goal of this document is to describe a high level plan for what kinds of systems will need to be modified and introduced to Fedora Infrastructure to support building, maintaining, and shipping modular things.



.. rubric:: Background

We know from the originally nebulous discussions that led to the formation of a modularity initiative in Fedora that we were going to create a new framework for building and composing the distribution, one which could have negative side-effects on our existing efforts if we weren’t careful. “Modularity will be very powerful. It will give us enough power to shoot ourselves in the foot.” We’re talking about allowing the creation of combinations of components with independent lifecycles. There’s the possibility of a combinatorial explosion in there that we’ll need to contain. We’ll do that in part by vigorously limiting the number of supported modules with policy, to be taken up in another document, and by providing infrastructure automation to reduce the amount of manual work required.

Towards accomplishing the second goal, we set out to study existing workflows and hypothesize what non-automated modularity workflows would entail.

.. rubric:: TOC

.. toctree::
    :maxdepth: 1

    infrastructure/life-of-a-package-update
    infrastructure/life-of-a-module-update
    infrastructure/infra-services-proposal
    infrastructure/two-approaches-to-the-orchestrator
    infrastructure/open-questions-and-notes
