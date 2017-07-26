Infrastructure
==============

Modularity will be built using the `Factory 2.0, documented on the Fedora
wiki <https://fedoraproject.org/wiki/Infrastructure/Factory2>`__.


Focus Documents
---------------

The Factory 2.0 team produces a confusing number of documents. The first
round was about the Problem Statements we were trying to solve. Let’s
retroactively call them Problem Documents. The `Focus Documents
<https://fedoraproject.org/wiki/Infrastructure/Factory2/Focus>`__ focus on
some system or some aspect of our solutions that cut across different
problems. The content here doesn’t fit cleanly in one problem statement
document, which is why we broke it out.

**The most important ones related to Modularity include**:

`Module Build Service (MBS)
<https://fedoraproject.org/wiki/Infrastructure/Factory2/Focus/MBS>`__ - A
service that orchestrates module builds in the Fedora infrastructure.

`Arbitrary Branching
<https://fedoraproject.org/wiki/Infrastructure/Factory2/Focus/ArbitraryBranching>`__ -
Support of version branches in dist-git which allows us to maintain multiple
versions of packages and modules.

`Freshmaker <https://fedoraproject.org/wiki/Infrastructure/Factory2/Focus/Freshmaker>`__ -
A service that will automatically rebuild artifacts (like module repositories
or container images) to make sure that everything is up to date.
