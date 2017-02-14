Adding modules to Fedora
========================

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
