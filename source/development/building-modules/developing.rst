Defining modules in modulemd
============================

To have your module build, you need to start with writing a `modulemd
<https://pagure.io/modulemd>`__ file which is a definition of your module
including the components, API, and all the information necessary to build your
module like specifying the build root and a build order for the packages.
Let’s have a look at an example Vim module:

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

Notice that there is no information about the name or version of the module.
That’s because the build system takes this information from the git
repository, from which the module is build:

* Git repository name == module name
* Git repository branch == module stream
* Commit timestamp == module version

All dependencies of vim need to be listed under components/rpms, except
those that are already included in `Base Runtime
<https://raw.githubusercontent.com/asamalik/fake-base-runtime-module-image/master/packages/gen-core-binary-pkgs.txt>`__.
Here's how you can get the list of vim dependencies that are not in Base
Runtime:

::

    wget https://raw.githubusercontent.com/asamalik/fake-base-runtime-module-image/master/packages/gen-core-binary-pkgs.txt
    for i in `repoquery --requires --recursive --resolve --qf "%{SOURCERPM}\n" \
      vim-enhanced vim-minimal vim-common vim-filesystem \
      | sed -e "s/-[^-]*-[^-]*$//" | sort -n | uniq` ; do
      grep -wq $i gen-core-binary-pkgs.txt || echo $i
    done

Check the syntax
----------------

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
