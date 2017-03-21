Adding modules to Fedora
========================

All modules should go through a formal review - the same way as packages do - before they can become part
of Fedora. As the Modularity project is still under development and there is no review process yet,
only members of the Modularity team can add new modules trough a temporary simplified process.

At the moment, the preferred way for both **production** and **staging** is to create a ticket at
`https://pagure.io/fedora-infrastructure/issues <https://pagure.io/fedora-infrastructure/issues>`__
to add the new repository and give you write access. Make sure to
mention that you need a **'module**' repository, and that you need it in production or staging.

The repositories will be available in the Fedora dist git - see the `httpd module <http://pkgs.fedoraproject.org/cgit/modules/httpd.git/>`__ as an example.
