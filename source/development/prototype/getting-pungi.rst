Getting Pungi (Modularity Style)
================================

Getting Pungi (Modularity Style)
--------------------------------

Because Modularity is a work-in-progress, we don't commit code specific
to it to the main branches of projects, but keep them in separate
branches. To work with the modularized version of Pungi, this affects
the ``pungi`` and ``productmd`` projects (``modularity`` and
``modulemd`` are modularity-specific per se).

This document will describe two slightly different ways to get the code
from the right branches:

#. Downloading and running a script which will clone the necessary
   source repositories into a newly created subdirectory, and print out
   a sourcable shell snippet that sets up the environment to work with
   it.
#. Cloning the repositories manually, and making them available in a
   Python virtualenv.

The quick way: using a script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Download
   ````https://pagure.io/pungi-modularity/blob/master/f/checkout-modularity-into-pwd.sh`` <https://pagure.io/pungi-modularity/blob/master/f/checkout-modularity-into-pwd.sh>`__ <https://pagure.io/pungi-modularity/raw/master/f/checkout-modularity-into-pwd.sh>`__.
#. From a directory of your choice, execute this script. It will create
   a subdirectory ``modularity`` into which the 4 projects are cloned.
   It will also print out a shell snippet setting up the environment to
   work there, which should be saved as e.g. ``$HOME/.modularity.sh``.
#. Run ``source $HOME/.modularity.sh`` to set up the environment.

The slightly longer way: using a Python virtualenv
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Download the projects. Go to the place where the projects should be
   in your filesystem, we'll call it ``$WORKSPACE`` from here on, and
   execute this:
   ::

       git clone --branch modularity-prototype https://pagure.io/forks/lkocman/pungi.git pungi
       git clone --branch modularity https://github.com/lkocman/productmd.git productmd
       git clone https://pagure.io/pungi-modularity.git pungi-modularity
       git clone https://pagure.io/modulemd.git modulemd

   Alternatively, you can use SSH URLs, of course, if you have an
   account set up on these sites:

   ::

       git clone --branch modularity-prototype ssh://git@pagure.io/forks/lkocman/pungi.git pungi
       git clone --branch modularity ssh://git@github.com/lkocman/productmd.git productmd
       git clone ssh://git@pagure.io/pungi-modularity.git pungi-modularity
       git clone ssh://git@pagure.io/modulemd.git modulemd

   This is largely what the ``checkout-modularity-into-pwd.sh`` does,
   except that it creates a ``modularity`` subdirectory to hold the
   repositories.

#. Create the Python virtualenv. We'll use ``pungi-modularity`` as its
   name in this document:
   ::

       mkvirtualenv modularity

   The virtualenv will be activated immediately, later on you can switch
   it on and off using ``workon modularity`` and ``deactivate``.

#. *Optional:* Upgrade ``pip`` so it doesn't complain about the old
   version being installed all the time:
   ::

       pip install --upgrade pip

#. Install some Python packages which aren't available from
   `http://pypi.python.org <http://pypi.python.org>`__ into the system,
   using ``dnf`` or ``yum``:
   ::

       koji
       kobo-rpmlib
       python2-dnf
       yum
       rpm-python
       python-librepo
       python-libcomps
       python-hawkey

#. Symlink the Python packages installed in the previous step from the
   system into the virtualenv:
   ::

       cdvirtualenv
       cd lib/python2.7/site-packages
       ln -s /usr/lib/python2.7/site-packages/koji koji
       ln -s /usr/lib/python2.7/site-packages/kobo kobo
       ln -s /usr/lib/python2.7/site-packages/dnf dnf
       ln -s /usr/lib/python2.7/site-packages/rpmUtils rpmUtils
       ln -s /usr/lib64/python2.7/site-packages/rpm rpm
       ln -s /usr/lib64/python2.7/site-packages/librepo librepo
       ln -s /usr/lib64/python2.7/site-packages/libcomps libcomps
       ln -s /usr/lib64/python2.7/site-packages/hawkey hawkey

   If you use a 32bit system, the last four lines must be changed to:

   ::

       ln -s /usr/lib/python2.7/site-packages/rpm rpm
       ln -s /usr/lib/python2.7/site-packages/librepo librepo
       ln -s /usr/lib/python2.7/site-packages/libcomps libcomps
       ln -s /usr/lib/python2.7/site-packages/hawkey hawkey

#. Install Python dependencies needed by ``dnf``, ``koji`` and ``pungi``
   into the virtualenv:
   ::

       pip install iniparse lxml pygpgme pyliblzma pyOpenSSL python-krbV

#. Make the virtualenv use the checked out source of the projects (and
   install dependencies):
   ::

       cd "$WORKSPACE"
       for proj in modulemd productmd pungi; do
           (cd "$proj" && python setup.py develop)
       done

At this point, everything should be in set up to run the
``pungi/bin/pungi-*-prototype`` scripts. You'll need to download some
source and binary packages for them to work on, we mainly use the Server
edition of Fedora (currently the alphas and betas of version 24). Review
the ``pungi-modularity/example-*.sh`` scripts for command syntax.
