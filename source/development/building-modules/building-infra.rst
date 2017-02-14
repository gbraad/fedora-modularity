Building modules in Fedora
==========================

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
