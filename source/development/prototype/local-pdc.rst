Setting up PDC locally
======================

Setting up PDC locally for Modularity development
-------------------------------------------------

To develop tooling for Modularity and test it, we want to have a local
instance of PDC installed. The `upstream
documentation <https://github.com/product-definition-center/product-definition-center/blob/master/docs/source/development.rst>`__
describes a couple of ways of doing that, this document describes how it
can be done `using a Python
virtualenv <https://github.com/product-definition-center/product-definition-center/blob/master/docs/source/development.rst#option-2-start-it-on-virtualenv>`__,
with some notable differences:

-  The virtualenv won't have system-wide packages enabled. This is so
   that OS updates or upgrades have a reduced impact on the development
   environment, "reduced" because neither ``koji`` nor ``rpm`` Python
   modules lend themselves well to be installed into a virtualenv, so
   for the sake of simplicity we'll symlink the system-wide installed
   modules.
-  We'll use the ``modularity`` branch of ``productmd``, not the version
   that's `available on
   PyPI <https://pypi.python.org/pypi/productmd>`__.

Walkthrough
~~~~~~~~~~~

#. Install the necessary system-wide packages (if missing) using
   ``dnf``, ``yum`` or similar:
   ::

       koji
       python-virtualenvwrapper
       rpm-python

   If you just installed ``python-virtualenvwrapper``, you need to
   restart the shell for it to take effect, i.e. install the
   ``mkvirtualenv`` and other shell functions, or
   ``source /etc/profile.d/virtualenvwrapper.sh`` manually.

   The patternfly1 package is required by PDC but isn't part of the
   Fedora distribution. You'll need to add a copr repository with

   ::

       dnf copr enable patternfly/patternfly1

   before you can install it with

   ::

       dnf install patternfly1

   Some development packages of libraries are needed for the Python
   module dependencies to be installed as well. Here's the list of
   development packages needed on Fedora 23:

   ::

       cyrus-sasl-devel
       glibc-devel
       graphviz-devel
       keyutils-libs-devel
       krb5-devel
       libcom_err-devel
       libffi-devel
       libgcrypt-devel
       libgpg-error-devel
       libselinux-devel
       libxml2-devel
       libxslt-devel
       nspr-devel
       nss-devel
       nss-softokn-freebl-devel
       nss-util-devel
       openldap-devel
       openssl-devel
       pcre-devel
       python-devel
       xz-devel
       zlib-devel

#. Create a workspace directory where all the checked out code
   repositories live, if you haven't done so already. We'll refer to
   that as ``$WORKSPACE``.
#. Make a virtualenv ``modularity`` for PDC development. This is one
   point where we deviate from the upstream docs:
   ::

       mkvirtualenv modularity

   This activates the ``modularity`` virtualenv right away, leave it
   using the ``deactivate`` command, and activate it again with
   ``workon modularity`` later on.

#. *Optional:* Upgrade ``pip`` so it doesn't complain about the old
   version being installed all the time:
   ::

       pip install --upgrade pip

#. Make the ``modularity`` branch of ``productmd`` available in the
   virtualenv.

   #. Clone the repository into your workspace:
      ::

          cd "$WORKSPACE"
          git clone --branch modularity https://github.com/lkocman/productmd.git

   #. Make the virtualenv use the checked out source:
      ::

          cd productmd
          python setup.py develop

#. Symlink the ``koji`` and ``rpm`` Python packages from the system into
   the virtualenv:
   ::

       cdvirtualenv
       cd lib/python2.7/site-packages
       ln -s /usr/lib/python2.7/site-packages/koji koji
       ln -s /usr/lib64/python2.7/site-packages/rpm rpm

   If you use a 32bit system, the last line must be changed to:

   ::

       ln -s /usr/lib/python2.7/site-packages/rpm rpm

#. Install Python dependencies needed by ``koji`` into the virtualenv:
   ::

       pip install pyOpenSSL python-krbV

#. Get PDC and set it up.

   #. Clone the PDC repository into your workspace:
      ::

          cd "$WORKSPACE"
          git clone https://github.com/product-definition-center/product-definition-center.git

   #. Install the dependencies needed for PDC development:
      ::

          cd product-definition-center
          pip install -r requirements/devel.txt

   #. Create the database and schema inside, this command also would
      migrate the schema to a new version if subsequent changes in PDC
      make this necessary:
      ::

          ./manage.py migrate

   #. Create a superuser for PDC:
      ::

          ./manage.py createsuperuser

      This will ask you for a user name, email address and password.
      Going forward, we'll assume the user name is ``superuser``.

   #. Set up local configuration so testing doesn't require
      authentication etc. for what would be privileged operations in a
      productive environment.

      #. Copy the local configuration file from the template:
         ::

             cd pdc
             cp settings_local.py.dist settings_local.py

      #. Make some changes in ``settings_local.py``:

         #. Enable debugging, change this line:
            ::

                DEBUG = False

            to this one:

            ::

                DEBUG = True

         #. Don't restrict connecting to PDC (it listens on the loopback
            device only, anyway), comment out the ``ALLOWED_HOSTS``
            line:
            ::

                #ALLOWED_HOSTS = [...]

         #. Make unauthenticated access user the ``superuser`` account,
            forego permissions checking. Add these lines to the end of
            the file:
            ::

                # mock login for debugging
                DEBUG_USER = "superuser"

                DISABLE_RESOURCE_PERMISSION_CHECK = True

                del get_setting('REST_FRAMEWORK')['DEFAULT_PERMISSION_CLASSES']

   #. Start up the local PDC instance:
      ::

          cd "$WORKSPACE"/product-definition-center
          ./manage.py runserver

   #. Manually create the ``module`` Variant Type in the PDC interface.

      #. Go to `http://127.0.0.1:8000 <http://127.0.0.1:8000>`__ with
         your web browser, then go the administrative interface
         ``👤 superuser`` → ``PDC Administration interface``.
      #. Locate ``Release`` → ``Variant types``, click on ``+ Add``,
         enter ``module`` as the name, click on ``Save``.

At this point, PDC should be set up and ready for working with modules.
