Adding and building a module for Fedora
=======================================

This document describes the process of adding a new module to the Fedora
Modularity project, how to build it locally and how to build it in
Fedora infrastructure

Process and policy for how to add a module to Fedora
----------------------------------------------------

Adding a module repository is a manual process. At the moment the
preferred way is to create a ticket at
`https://pagure.io/fedora-infrastructure/issues <https://pagure.io/fedora-infrastructure/issues>`__
to add the new repository and give you write access. Make sure to
mention that you need a **'module**' repository and that it needs to be
on **stg**.fedoraproject.org, that's the staging environment. One
example path for a module git repository is
*https://admin.stg.fedoraproject.org/pkgdb/package/modules/vim*.

Later on this will be automated by MBS, the module build server, but
this is still being worked on.

Writing a new modulemd file
---------------------------

A modulemd file is a yaml file that contains the module metadata like
description, license and dependencies. The `sample
file <https://pagure.io/modulemd/raw/master/f/spec.yaml>`__ in the
upstream git repository of modulemd contains a complete documentation of
the required and optional yaml tags.

The Modularity team uses `a shorter modulemd
file <http://pkgs.stg.fedoraproject.org/cgit/modules/testmodule.git/tree/testmodule.yaml>`__
to test builds, but it can also be used as a base for new modules.
Another good example is
`base-runtime.yml <http://pkgs.stg.fedoraproject.org/cgit/modules/base-runtime.git/plain/base-runtime.yaml>`__

Lets use the vim modulemd as an example for this document. It is in the
/home/karsten/Modularity/modules/vim/ directory on my system.

::

    document: modulemd
    version: 1
    data:
        summary: The best text editor and IDE
        description: The classic, extensible text editor, the legend.
        license:
            module: [ MIT ]
        dependencies:
            buildrequires:
                base_runtime: master
            requires:
                base_runtime: master
        references:
            community: https://fedoraproject.org/wiki/Modularity
            documentation: https://fedoraproject.org/wiki/Fedora_Packaging_Guidelines_for_Modules
            tracker: https://taiga.fedorainfracloud.org/project/modularity
        profiles:
            default:
                rpms:
                    - vim-enhanced
                    - vim-common
                    - vim-filesystem
            minimal:
                rpms:
                    - vim-minimal
        api:
            rpms:
                - vim-common
        components:
            rpms:
                vim:
                    rationale: Provides API for this module
                    ref: f25
                    buildorder: 10
                generic-release:
                    rationale: build dependency
                    ref: f25
                perl-Carp:
                    rationale: build dependency
                    ref: f25
                gpm:
                    rationale: build dependency
                    ref: f25
                perl-Exporter:
                    rationale: build dependency
                    ref: f25


All dependencies of vim need to be listed under components/rpms, except
those that are already included in `Base
Runtime <https://raw.githubusercontent.com/asamalik/fake-base-runtime-module-image/master/packages/gen-core-binary-pkgs.txt>`__.
Here's how you can get the list of vim dependencies that are not in Base
Runtime:

::

    wget https://raw.githubusercontent.com/asamalik/fake-base-runtime-module-image/master/packages/gen-core-binary-pkgs.txt
    for i in `repoquery --requires --recursive --resolve --qf "%{SOURCERPM}\n" \
      vim-enhanced vim-minimal vim-common vim-filesystem \
      | sed -e "s/-[^-]*-[^-]*$//" | sort -n | uniq` ; do
      grep -wq $i gen-core-binary-pkgs.txt || echo $i
    done

verifying the syntax of the new modulemd file and bug fixing
------------------------------------------------------------

Once the modulemd file is finished, it is a good idea to check if there
any errors in the yaml syntax. The
`check\_modulemd <https://github.com/fedora-modularity/check_modulemd>`__
program checks modulemd files for errors. You need to install some
packages to use this:

-  python2-aexpect - dependency for python-avocado
-  python2-avocado - avocado testing framework
-  python2-modulemd - Module metadata manipulation library
-  python-enchant - spell checker library (needed only for
   check\_modulemd.py)
-  hunspell-en-US - English dictionary (needed only for
   check\_modulemd.py)

|
| Then run

::

    ./run-checkmmd.sh /home/karsten/Modularity/modules/vim/vim.yaml

and check the output for errors:

::

    Running: avocado run ./check_modulemd.py --mux-inject 'run:modulemd:/home/karsten/Modularity/modules/vim/vim.yaml'
    JOB ID     : 51581372fec0086a50d9be947ea06873b33dd0e5
    JOB LOG    : /home/karsten/avocado/job-results/job-2017-01-19T11.28-5158137/job.log
    TESTS      : 11
     (01/11) ./check_modulemd.py:ModulemdTest.test_debugdump: PASS (0.16 s)
     (02/11) ./check_modulemd.py:ModulemdTest.test_api: PASS (0.15 s)
     (03/11) ./check_modulemd.py:ModulemdTest.test_components: PASS (0.16 s)
     (04/11) ./check_modulemd.py:ModulemdTest.test_dependencies: WARN (0.02 s)
     (05/11) ./check_modulemd.py:ModulemdTest.test_description: PASS (0.16 s)
     (06/11) ./check_modulemd.py:ModulemdTest.test_description_spelling: PASS (0.16 s)
     (07/11) ./check_modulemd.py:ModulemdTest.test_summary: PASS (0.16 s)
     (08/11) ./check_modulemd.py:ModulemdTest.test_summary_spelling: WARN (0.02 s)
     (09/11) ./check_modulemd.py:ModulemdTest.test_rationales: ERROR (0.04 s)
     (10/11) ./check_modulemd.py:ModulemdTest.test_rationales_spelling: PASS (0.16 s)
     (11/11) ./check_modulemd.py:ModulemdTest.test_component_availability: WARN (0.02 s)
    RESULTS    : PASS 7 | ERROR 1 | FAIL 0 | SKIP 0 | WARN 3 | INTERRUPT 0
    TESTS TIME : 1.20 s

So this isn't quite right yet, lets have a look at the logfile mentioned
in the output.

::

    grep -i error /home/karsten/avocado/job-results/job-2017-01-19T11.28-5158137
    ....
    TestError: Rationale for component RPM generic-release should end with a period: build dependency

It seems that rationales need to end with a period. Change all those
lines so that they look like this:

::

                vim:
                    rationale: Provides API for this module.
                    ref: f25
                    buildorder: 10
                generic-release:
                    rationale: build dependency.
                    ref: f25
                gpm:
                    rationale: build dependency.
                    ref: f25
                perl:
                    rationale: build dependency.
                    ref: f25
                perl-Carp:
                    rationale: build dependency.
                    ref: f25
                perl-Exporter:
                    rationale: build dependency.
                    ref: f25

Another run of check\_modulemd.py completes without errors.

Building the module locally
---------------------------

The build\_module script from the
`build-module <https://github.com/asamalik/build-module>`__ repository
on github makes local module builds really easy. It sets up the
environment and then builds a module and its components locally with
mock. One requirement is to have docker installed and running on your
system. It is also required that the name of the new modulemd file, the
repository name of that module and the name of the module itself match
in order to use the build\_module script. As build\_module builds the
latest commit in the master branch of the module git repository, changes
need to be checked into git, a push to upstream (dist-git) is not
required at this stage.

The basic usage of build\_module is

::

    ./build_module /home/karsten/Modularity/modules/vim/ /tmp/results

This will download a container with the `Module build
service <https://pagure.io/fm-orchestrator>`__ and rebuild the
dependencies that are listed in the modulemd file. This step can take
quite some time, depending on the module and how many components need to
be built.

When build\_module is done there will be a couple of rebuilt rpms in
/tmp/results/module-vim-master-\*/results/:

::

    cd /tmp/results/module-vim-master-*/results/
    find . -name "*.rpm"
    ./vim-8.0.206-1.fc25.src.rpm
    ./vim-debuginfo-8.0.206-1.fc25.x86_64.rpm
    ./vim-X11-8.0.206-1.fc25.x86_64.rpm
    ./vim-filesystem-8.0.206-1.fc25.x86_64.rpm
    ./vim-enhanced-8.0.206-1.fc25.x86_64.rpm
    ./vim-minimal-8.0.206-1.fc25.x86_64.rpm
    ./vim-common-8.0.206-1.fc25.x86_64.rpm
    ./perl-Carp-1.40-365.fc25.src.rpm
    ./perl-Carp-1.40-365.fc25.noarch.rpm
    ./generic-release-25-1.src.rpm
    ./generic-release-notes-25-1.noarch.rpm
    ./generic-release-25-1.noarch.rpm
    ./perl-5.24.1-381.fc25.src.rpm
    ./perl-debuginfo-5.24.1-381.fc25.x86_64.rpm
    ./perl-Time-Piece-1.31-381.fc25.x86_64.rpm
    ./perl-Test-1.28-381.fc25.noarch.rpm
    ./perl-SelfLoader-1.23-381.fc25.noarch.rpm
    ./perl-Pod-Html-1.22.01-381.fc25.noarch.rpm
    ./perl-open-1.10-381.fc25.noarch.rpm
    ./perl-Net-Ping-2.43-381.fc25.noarch.rpm
    ./perl-Module-Loaded-0.08-381.fc25.noarch.rpm
    ./perl-Memoize-1.03-381.fc25.noarch.rpm
    ./perl-Math-Complex-1.59-381.fc25.noarch.rpm
    ./perl-Math-BigRat-0.2608.02-381.fc25.noarch.rpm
    ./perl-Math-BigInt-FastCalc-0.40-381.fc25.x86_64.rpm
    ./perl-Locale-Maketext-Simple-0.21-381.fc25.noarch.rpm
    ./perl-libnetcfg-5.24.1-381.fc25.noarch.rpm
    ./perl-IO-Zlib-1.10-381.fc25.noarch.rpm
    ./perl-IO-1.36-381.fc25.x86_64.rpm
    ./perl-ExtUtils-Miniperl-1.05-381.fc25.noarch.rpm
    ./perl-ExtUtils-Embed-1.33-381.fc25.noarch.rpm
    ./perl-Errno-1.25-381.fc25.x86_64.rpm
    ./perl-Devel-SelfStubber-1.05-381.fc25.noarch.rpm
    ./perl-Devel-Peek-1.23-381.fc25.x86_64.rpm
    ./perl-bignum-0.42-381.fc25.noarch.rpm
    ./perl-Attribute-Handlers-0.99-381.fc25.noarch.rpm
    ./perl-core-5.24.1-381.fc25.x86_64.rpm
    ./perl-utils-5.24.1-381.fc25.noarch.rpm
    ./perl-tests-5.24.1-381.fc25.x86_64.rpm
    ./perl-macros-5.24.1-381.fc25.x86_64.rpm
    ./perl-devel-5.24.1-381.fc25.x86_64.rpm
    ./perl-libs-5.24.1-381.fc25.x86_64.rpm
    ./perl-5.24.1-381.fc25.x86_64.rpm
    ./perl-Exporter-5.72-366.fc25.src.rpm
    ./perl-Exporter-5.72-366.fc25.noarch.rpm
    ./gpm-1.20.7-9.fc25.src.rpm
    ./gpm-debuginfo-1.20.7-9.fc25.x86_64.rpm
    ./gpm-static-1.20.7-9.fc25.x86_64.rpm
    ./gpm-devel-1.20.7-9.fc25.x86_64.rpm
    ./gpm-libs-1.20.7-9.fc25.x86_64.rpm
    ./gpm-1.20.7-9.fc25.x86_64.rpm
    ./module-build-macros-0.1-1.module_vim_master_20170119134619.src.rpm
    ./module-build-macros-0.1-1.module_vim_master_20170119134619.noarch.rpm

These will now be put into a container.

Putting the packages into a container
-------------------------------------

For this step you'll need to create a rpm repository of the new
packages.

::

    cd /tmp/results/module-vim-master-20170119120233/
    mkdir vim-module-repo
    cp results/*.rpm vim-module-repo
    cd vim-module-repo
    createrepo .

The /tmp/results/module-vim-master-20170119120233/vim-module-repo need
to uploaded somewhere public so that docker can access it. A good place
for that is the fedorapeople.org webspace that each Fedora developer
has.

::

    scp -r /tmp/results/module-vim-master-20170119120233/vim-module-repo karsten.fedorapeople.org:public_html/

You'll also need a dnf/yum configfile
(/home/karsten/Modularity/modules/vim/vimmodule.repo) that points at
this new repo:

::

    cat /home/karsten/Modularity/modules/vim/vimmodule.repo
    [vimmodule]
    name=VIM module
    failovermethod=priority
    baseurl=https://karsten.fedorapeople.org/vim-module-repo/
    enabled=1
    metadata_expire=7d
    gpgcheck=0
    skip_if_unavailable=True

Now put everything into a Dockerfile. We're using Adam Samalik's
fake-gen-core-module as there is no usable base-runtime module yet:

::

    cat /home/karsten/Modularity/modules/vim/Dockerfile
    FROM asamalik/fake-gen-core-module
    ADD vimmodule.repo /etc/yum.repos.d/vimmodule.repo
    RUN dnf -y update vim-minimal
    RUN dnf -y install vim-enhanced

Building the module in Fedora infrastructure using a local module-build-service instance
----------------------------------------------------------------------------------------

Filip Valder recorded a
`video <https://fedorapeople.org/groups/factory2/sprint-006/fivaldi-developers-instance.ogv>`__
that covers this part.

This step uses a local module-build-service and other components in
containers and passes results on to the Fedora staging infrastructure. A
checkout of the
`module-build-service <https://pagure.io/fm-orchestrator>`__ and an
installation of the *docker-compose* package are required. Change into
your local copy of this repository and run

::

    docker-compose down
    docker-compose up --build

This will start the module-build-service frontend and scheduler as well
as fedmsg and you'll see when messages about module builds are coming in
over the `Federated Message Bus <http://www.fedmsg.com/en/latest/>`__.
The local module-build-service will connect to product-definition-center
(PDC) on the modularity developer server modularity.fedorainfracloud.org
At the moment an account on modularity.fedorainfracloud.org is required
for this step as remote port forwarding needs to be established via ssh:

::

    cat ~/.ssh/config
    host MODULARITY-DEV
      Hostname modularity.fedorainfracloud.org
      user fedora
      RemoteForward 3007 127.0.0.1:5001

Some changes need to be made to the local module-build-service (aka
fm-orchestrator) git repository so that it allows to build from a git
repositoy on github:

::

    diff --git a/conf/config.py b/conf/config.py
    index 97eed6e..2ddb61b 100644
    --- a/conf/config.py
    +++ b/conf/config.py
    @@ -35,7 +35,7 @@ class BaseConfiguration(object):
         PDC_URL = 'http://modularity.fedorainfracloud.org:8080/rest_api/v1'
         PDC_INSECURE = True
         PDC_DEVELOP = True
    -    SCMURLS = ["git://pkgs.stg.fedoraproject.org/modules/"]
    +    SCMURLS = ["git://pkgs.stg.fedoraproject.org/modules/","https://github.com/KarstenHopp/"]

         # How often should we resort to polling, in seconds
         # Set to zero to disable polling
    diff --git a/contrib/submit-build.json b/contrib/submit-build.json
    index 0e312a5..e46bf8a 100644
    --- a/contrib/submit-build.json
    +++ b/contrib/submit-build.json
    @@ -1,3 +1,3 @@
     {
    -    "scmurl": "git://pkgs.stg.fedoraproject.org/modules/testmodule.git?#620ec77"
    +    "scmurl": "git://github.com/KarstenHopp/vim-module.git?#cdbc4bf"
     }

Now you need to get a kerberos ticket for the Fedora staging
environment. If you haven't already done so, add

::

    STG.FEDORAPREOJECT.ORG = {
      kdc = https://id.stg.fedoraproject.org/KdcProxy
    }

to the realms section of your /etc/krb5.conf file. Then point your web
browser at
`https://admin.stg.fedoraproject.org/accounts <https://admin.stg.fedoraproject.org/accounts>`__
and log in with your Fedora credentials so that the account will get
synced from the Fedora production environment. Run

::

    kinit karsten@STG.FEDORAPROJECT.ORG

(replace 'karsten' with your FAS account) and get a kerberos ticket. In
another window, ssh into modularity.fedorainfracloud.org to establish
required port forwarding.

Now you can run 'python submit-build.py' from within the
module-build-service git repo. You might need to login again at
id.stg.fedoraproject.org, just follow the instructions. Now the module
build will be submitted to the Fedora build servers. Log messages will
show the progress on your screen.

Building the module
-------------------

When your module is ready to get added to Fedora, you need to have write
access to the module dist-git on pkgs.stg.fedoraproject.org and you need
to have pushed all your changes to this module git repository. You can
build your module using two different methods:

-  A `special version of rpkg <https://pagure.io/fork/karsten/rpkg>`__
   with module-build support is required for this step. Change the
   working directory to your local copy of your module repo and simply
   run

::

     fedpkg module-build

-  The other method requires that you add the git URL of your latest
   module commit to the submit-build.json file in the
   module-build-server git repository and then run

::

    python submit-build.py

Building a container image
--------------------------

There are two ways to build a Docker container image in Fedora
infrastructure:

#. **In production environment** -- the process starts by initiating a
   review request, as specified in Container:Review_Process.
#. **In staging environment** -- this is where we can bypass the review
   process and iterate more quickly; In order to use staging
   environment, we should request creation of dist-git repo and pkgdb
   entry via `Fedora Infra
   tracker <https://pagure.io/fedora-infrastructure/issues>`__.

If you want to clone your dist-git repository using ``fedpkg``, you need
to select correct namespace:

::

    $ fedpkg clone docker/$COMPONENT

or

::

    $ fedpkg clone modules/memcached

Once you are ready to submit a build, you need to push changes to a
remote and initiate a build

::

    $ fedpkg container-build

Inspecting registry
-------------------

At the time of writing this (Feb 2017), Fedora docker image registry
doesn't have any frontend. You can access API of registry to get a list
of available images:

::

    $ curl -s https://registry.fedoraproject.org/v2/_catalog | python -m json.tool
    {
        "repositories": [
            "cockpit",
            "f24/cockpit",
            "f25/cockpit",
            "f25/kube-apiserver",
            "f25/kubernetes-master",
            "f25/owncloud",
            "f26/cockpit",
            "fedora",
            "fedora/cockpit",
            "openshift/origin-pod"
        ]
    }

Thank you to `Adam Miller <User:maxamillion>`__ for providing info about
using Docker Layered Image Build System.
