Grooming Your Changes
=====================

Apart from :doc:`coding-style`,
there are some things that you should keep in mind regarding the changes
you submit. Normally you'd develop your changes in a private branch on
your fork of a repository and, when you're done, submit them as pull
requests ("PR") against a public branch of the repository. The following
guidelines concentrate on changes in this format, their goal is to
enable you to groom the commits forming your pull request so that
another person can review it without great effort, that the changes can
be integrated well with the existing code and can be easily debugged
later if necessary.

Pull Requests
-------------

Scope
~~~~~

One pull request should really be about implementing one feature or
solving one problem. For instance, when developing your changes you
might spot a bug in existing code and fix it. Mixing these changes with
your new feature make reviewing them more work because the person doing
it needs to assess if a chunk of your changes is related to the feature,
or the bug fix. Similarly, if the review of your feature drags out, the
bug fix might take that much longer before it's available to others. In
most cases you should therefore create separate pull requests for both
sets of changes.

As an exception to that, merely janitorial changes to the parts of the
code your pull request touches anyway—say, fixing trailing whitespace or
indentation, superficial changes that make the code you worked on better
to read or understand—are acceptable as long as you put these changes in
a commit or commits of their own, ideally put before your "real" changes
in the commit order. This makes it easier to cope with other PRs that
might fix the same things.

Describing your changes
~~~~~~~~~~~~~~~~~~~~~~~

The bigger the changes you submit are, the more important it is to give
the reviewer a high level summary of what it is they are reviewing. If a
pull request consists only of one commit, then its commit log should be
sufficient in most cases and the forges hosting our repositories (Pagure
and GitHub) use it as the default description text on submission. If it
is longer, you may need to condense the individual changes of your
commits, and maybe lose some comments about the problem you wanted to
solve and your approach. If you are unsure about parts of your changes,
this is also the place give the reviewer a heads-up.

Linear History and Rebasing
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The changes you submit for reviewing should be a linear string of
commits, please don't have merges in there. Therefore, in order to track
upstream changes while you are still developing in a private branch, you
should rebase it on top of the upstream branch you track. You can of
course do that manually, but it's easier to tell git to automatically
attempt to rebase your changes on top of the branch from which you pull
(replace ``$branchname`` with the actual name of your local branch):

``   git config branch.$branchname.rebase true``

You can also set this globally for any newly created branch (you'd have
to do the above for all existing branches, though):

``   git config --global branch.autosetuprebase always``

Set up this way, pulling from upstream will attempt to apply your
private commits in order on top of the new upstream ones, one after
another. If that fails at some point, e.g. because of conflicts, it'll
interrupt the rebasing process, so that you can resolve the issue, and
continue with ``git rebase --cont``. Alternatively, you could also
restore the previous state by running ``git rebase --abort``, e.g. to
assess the differences between your (unrebased) branch and upstream
before giving it a go again.

The Review
~~~~~~~~~~

When you've submitted your changes as a pull request, hopefully someone
will pick it up soon (if not, poke some people on IRC:
`#fedora-modularity on
Freenode <irc://irc.freenode.net/#fedora-modularity>`__) and give you
feedback in form of comments, questions or suggestions. The comment
section of a pull request isn't very suitable for longer discussions, so
you might switch to email, IRC or another medium to discuss a topic, and
then summarize in the PR. Consulting other contributors is encouraged,
if additional opinions are needed. The job of a reviewer is not just to
act as a gatekeeper for the project, but also to assist you in getting
your changes into an acceptable state. This can go as far as making
minor fixes on the fly rather than asking you to do it, or bringing the
stack of commits "into shape" before merging the pull request.

Individual commits
------------------

Commit Scope and Size
~~~~~~~~~~~~~~~~~~~~~

Like a pull request itself, a commit should also be about just one
thing. For example, you should split the implementation of a new class
from where existing code is converted to use it, as well as removing the
legacy code it replaces. The reverse also holds true—one concern should
be dealt with in one commit: if you discover bugs in a newly introduced
piece of code while you're still developing it, the buggy commit
introducing it and the fix should be rolled into one. This keeps the
number of broken commits down which e.g. makes it easier to use
``git bisect`` at a later point.

.. raw:: mediawiki

   {{admon/note|"Commit early, commit often."|It's much easier to merge smaller commits into larger ones if they belong together, rather than disassembling a commit that actually addresses more than one concern.}}

Commit Log Messages
~~~~~~~~~~~~~~~~~~~

The purpose of a commit log message is to briefly summarize the changes
in the commit, but it's also where background information should be put,
e.g. why some approach was used and not another.

Format
^^^^^^

A commit log should consist of a short summary line (<50 characters,
also called "title"), optionally followed by a blank line and a more
thorough description. The summary should tersely describe the objective
of the commit, while the description would go into detail about the
actual implementation.

Building a Commit
~~~~~~~~~~~~~~~~~

Often you'll want to pick only parts of your uncommitted changes, in
order to follow these guidelines, or to leave out debugging statements
which you don't want to submit. You can select the parts in your changes
you want to commit by using ``git add --patch`` which presents the
differences as hunks in unified diff format and lets you choose which
ones to add to the staging area and which to skip. After committing
these staged changes, you can repeat the process until all changes you
want to submit are taken care of. There are ways to separate a large
commit into smaller ones, but this approach is often more difficult one
of the two.

Tools
-----

-  Adding using patch mode: With ``git add --patch ...`` you can pick
   which changes you want to commit.
-  Interactive rebasing: Use ``git rebase -i ... @{u}`` to reorder your
   commits, reword their commit messages, merge or amend them. It's
   important to not do this to upstream commits, therefore ``@{u}``
   specifies the point where your branch split off from upstream.

.. raw:: mediawiki

   {{admon/important|If all else fails:|GIT remembers the history of revisions you had checked out in your repository, refer to the output of <code>git reflog</code> to find a "known good" one.}}

.. raw:: mediawiki

   {{admon/caution|Using <code>git reset</code>|You can use <code>git reset [--hard] $some_sha1_commit</code> to bring you back to a known good state. Be careful, though: using the <code>--hard</code> option will lose any changes made to files under the control of GIT.}}

See also
--------

-  The `Pro Git book <https://git-scm.com/book/en/v2/>`__

   -  The `"Rewriting
      History" <https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History>`__
      chapter for more detailed information about amending, interactive
      rebasing, and other advanced ways of screwing up your repository
      ;)

Category:Modularity
