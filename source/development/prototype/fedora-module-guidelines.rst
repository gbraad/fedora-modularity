Fedora Packaging Guidelines for Modules
=======================================

.. raw:: mediawiki

   {{DISPLAYTITLE:Fedora Packaging Guidelines for Modules}}

.. raw:: html

   <div style="float: right;" class="toclimit-2">

\_\_TOC\_\_

.. raw:: html

   </div>

Disclaimer
----------

Note that this document is just a draft. These aren't official, approved
Fedora guidelines.

Overview
--------

The goal of this document is to describe how to create valid module
files, document purposes of all the data fields in them, hint best
practices and demonstrate some examples.

Each module is defined by a single YAML file and comprises of a number
of key-value pairs describing the module's properties and components it
contains. Not everything needs to (or even should) be filled in by the
module packager; some of the fields get populated later during the
module build or distribution phase. The module file format is commonly
known as *modulemd*.

The original format specification can be found in the `modulemd
repository <https://pagure.io/modulemd>`__.

Required fields
---------------

Document header and the data section
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every modulemd file **MUST** contain a modulemd document header which
consists of the document type tag and the document format version, and a
data section holding the module data.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     (...)``

The version is an integer and denotes the version of the metadata format
the rest of the document is written in. As of now, only one officialy
released version of the format exists, **version 1**.

Module summary and description
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every module **MUST** include human-readable short summary and
description. Both should be written in US English.

| `` summary: An example module``
| `` description: >``
| ``     An example long description of an example module, written just``
| ``     to demonstrate the purpose of this field.``

The summary is a one sentence concise description of the module and
**SHOULD NOT** end in a period.

The description expands on this and **SHOULD** end in a period.
Description **SHOULD NOT** contain installation instructions or
configuration manuals.

Module licensing
~~~~~~~~~~~~~~~~

Every module **MUST** contain a license section and declare a list of
the module's licenses. Note these aren't the module's components'
licenses.

| `` license:``
| ``     module:``
| ``         - MIT``

Fedora content, such as SPEC files or patches not included upstream,
uses the MIT license by default, unless the component packager declares
otherwise. Therefore MIT might be a reasonable default for most module
authors as well.

See
`Fedora\_Packaging\_Guidelines\_for\_Modules#Module\_content\_licensing <Fedora_Packaging_Guidelines_for_Modules#Module_content_licensing>`__
to see how to declare components' licenses.

Optional fields
---------------

Module name, update stream and version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every module **SHOULD** define its name, update stream and version.

| `` name: example``
| `` stream: another-example``
| `` version: 20161109235500``

Note, however, that module packagers **SHOULD NOT** define these values
manually but rather expect the Module Build Service to do it for them,
using the module's dist-git repository name as the module name, the
dist-git repository branch name as the stream name and the particular
commit timestamp as the version. This simplifies module rebuilds and
moving modules between branches or repositories.

Packagers **MAY** override this behaviour by defining these fields
themselves. This behavior may change in the future.

There are currently no formal restrictions for the format of the
``name`` and ``stream`` properties. The ``version``, however, must be an
unsigned integer.

Module content licensing
~~~~~~~~~~~~~~~~~~~~~~~~

If the module includes some RPM or non-RPM content, the packager **MAY**
also define a list of content licenses.

| `` license:``
| ``     module:``
| ``         - MIT``
| ``     content:``
| ``         - GPL+``
| ``         - BSD``

Not every module includes packages and therefore doesn't necessarily
have to include this field.

Furthermore, the content licenses list should ideally be automatically
filled by module build tools rather than the module author.

Module dependencies
~~~~~~~~~~~~~~~~~~~

Modules **MAY** depend on other modules. These module relationships are
listed in the depepdencies section. Dependencies are expressed using
module names and their stream names.

| `` dependencies:``
| ``     buildrequires:``
| ``         generational-core: master``
| ``     requires:``
| ``         generational-core: master``

So far modulemd supports two kinds of dependencies:

-  ``buildrequires`` for listing build dependencies of the module, i.e.
   modules that define the buildroot for building the module's
   components; this will typically be the ``generational-core`` module,
   at minimum
-  ``requires`` for listing runtime dependencies of the module, i.e.
   modules that need to be available on the target system for this
   module to work properly; this too will typically be the
   ``generational-core`` module, at minimum

Either or both of these sections may be omitted, if necessary.

Extensible module metadata block
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modules **MAY** also contain an extensible metadata block, a list of
vendor-defined key-value pairs.

| `` xmd:``
| ``     user-defined-key: 42``
| ``     another-user-defined-key:``
| ``         - the first value of the list``
| ``         - the second value of the list``

Module references
~~~~~~~~~~~~~~~~~

Modules **MAY** define links referencing various upstream resources,
such as community website, project documentation or upstream bug
tracker.

| `` references:``
| ``     community: ``\ ```http://www.example.com/`` <http://www.example.com/>`__
| ``     documentation: ``\ ```http://www.example.com/docs/1.23/`` <http://www.example.com/docs/1.23/>`__
| ``     tracker: ``\ ```http://www.example.com/bugs/`` <http://www.example.com/bugs/>`__

Module profiles
~~~~~~~~~~~~~~~

Install profile defines a list of packages to be installed when selected.
Whether the packages actually get installed depends on the user's
configuration. It is possible to define a profile that doesn't install any
packages.

List of special-purpose profiles:
- ``default`` - used unless any other profile was selected.
- ``container`` - packages meant to be installed inside container image artifact.
- ``minimal`` - minimal set of packages providing functionality of this module.
- ``buildroot`` - packages which should be installed into the buildroot of a
  module which depends on this module.
- ``srpm-buildroot`` - additional packages which should be installed during the
  buildSRPMfromSCM step in koji.

For more info see `example modulemd <https://pagure.io/modulemd/blob/master/f/spec.yaml>`__.


The *default* profile lists packages that would be installed unless the
user's configuration dictates otherwise.

In the case of RPM content, the profile package lists reference binary
RPM package names.

| `` profiles:``
| ``     default:``
| ``         rpms:``
| ``             - myapplication``
| ``             - myapplication-plugins``
| ``     minimal:``
| ``         description: An example minimal profile installing only the myapplication package.``
| ``         rpms:``
| ``             - myapplication``

If your profile requires some post-installation steps to be performed, the
prefered solution is to put the script into RPM as a post-install scriptlet.


Module API
~~~~~~~~~~

Module API are components, symbols, files or abstract features the
module explicitly declares to be its supported interface. Everything
else is considered an internal detail and shouldn't be relied on by any
other module.

Every module **SHOULD** define its public API.

| `` api:``
| ``     rpms:``
| ``         - mypackage``
| ``         - mylibrary``
| ``         - mylibrary-devel``

Currently the only supported type of API are binary RPM packages, that
is the list of RPMs that are guaranteed to a) be present in the module,
and b) not break their interfaces such as binaries their provide or
their ABI.

Module filters
~~~~~~~~~~~~~~

Module filters define lists of components or other content that should
not be part of the resulting, composed module deliverable. They can be
used to only ship a limited subset of generated RPM packages, for
instance.

| `` filter:``
| ``     rpms:``
| ``         - mypackage-plugins``

Currently the only supported type of filter are binary RPM packages.

Module components
~~~~~~~~~~~~~~~~~

Modules **MAY**, and most modules do contain a components section
defining the module's content.

| `` components:``
| ``     (...)``

RPM content
^^^^^^^^^^^

Module RPM content is defined in the ``rpms`` subsection of
``components`` and typically consists of one or more packages described
by their SRPM names and additional extra key-value pairs, some required
and some optional, associated with them.

| `` components:``
| ``     rpms:``
| ``         foo:``
| ``             rationale: The key component of this module.``
| ``             buildorder: 100``
| ``             repository: ``\ ```git://git.example.com/foo.git`` <git://git.example.com/foo.git>`__
| ``             ref: branch-tag-or-commit-hash``
| ``             cache: ``\ ```http://www.example.com/lookasidecache/`` <http://www.example.com/lookasidecache/>`__
| ``             arches:``
| ``                 - i686``
| ``                 - x86_64``
| ``             multilib:``
| ``                 - x86_64``
| ``         dependency-of-foo:``
| ``             rationale: Needed for foo.``
| ``             buildorder: 50``
| ``             repository: ``\ ```git://git.example.com/dependency-of-foo.git`` <git://git.example.com/dependency-of-foo.git>`__
| ``             ref: master``
| ``             cache: ``\ ```http://www.example.com/lookasidecache/`` <http://www.example.com/lookasidecache/>`__
| ``             arches: [ i686, x86_64 ]``
| ``             multilib: [ x86_64 ]``

The following key-value pairs extend the SRPM name:

-  ``rationale`` - every component **MUST** declare why it was added to
   the module; this is currently a free form string. It should end with
   a period.
-  ``buildorder`` - marks the component as a member of a specific build
   group; components are scheduled to be built in batches according to
   their buildorder tags, from the lowest to the highest; built
   components are tagged back into the buildroot before the next batch
   is built; several components can belong to the same build group by
   specifying the same buildorder value; build order within build groups
   is undefined; optional, integer, may be negative and defaults to zero
   if not specified.
-  ``repository`` - specifies git or other VCS repository to use as the
   component's source; in Fedora, dist-git is used and this option
   cannot be overridden.
-  ``ref`` - the ``repository`` reference (a branch or tag name or a
   commit hash) that should be built and included in this module;
   recommended. If not defined, the current HEAD or equivalent is used.
   ``ref`` is always populated by the exact commit hash used by the
   Module Build System during build.
-  ``cache`` - points to RPM lookaside cache; in Fedora this option
   cannot be overriden.
-  ``arches`` - a list of architectures this component should be built
   for; defaults to all available architectures.
-  ``multilib`` - a list of architectures where this component should be
   available as multilib, e.g. if ``x86_64`` is listed, x86\_64
   repositories will also include i686 builds. Defaults to no multilib.

Module content
^^^^^^^^^^^^^^

Modules may include other modules. This is similar to dependencies (both
build- and run-time) but differs in a few key points:

-  included modules are distributed with the parent module as one
   deliverable, no matter the format
-  included modules are built in the buildroot defined by the parent
   module, recursively

Dependencies and module inclusions can be freely combined. Deciding on
which is more fitting for your module varies from application to
application.

Module module-style content is defined in the modules subsection of
components and typically consists of one or more modules described by
their names and additional extra key-value pairs, some required and some
optional, associated with them.

| `` components:``
| ``     modules:``
| ``         my-favourite-module:``
| ``             rationale: An example of an included module.``
| ``             buildorder: 20``
| ``             repository: ``\ ```git://git.example.com/my-favourite-module.git`` <git://git.example.com/my-favourite-module.git>`__
| ``             ref: 12ab34cd5``

The following key-value pairs extend the module-style components:

-  ``rationale`` - see the description in the `RPM content
   section <#RPM_content>`__
-  ``buildorder`` - see the description in the `RPM content
   section <#RPM_content>`__
-  ``repository`` - see the description in the `RPM content
   section <#RPM_content>`__
-  ``ref`` - see the description in the `RPM content
   section <#RPM_content>`__

Other content
^^^^^^^^^^^^^

No other content is currently supported.

Examples
--------

Minimal module
~~~~~~~~~~~~~~

A minimal module distributed as *example-master-20161109172409*, stored
in the ``modules/example`` dist-git repository and its master branch,
built on November 9, 2016, at 17:24:09 UTC, containing no packages,
having no dependencies whatsoever and defining only the minimal set of
required metadata.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example summary``
| ``     description: And an example description.``
| ``     license:``
| ``         module:``
| ``             - MIT``

Minimal module with RPM content
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Another flavour of the abovementioned module, containing one RPM package
with SRPM name *foo*. This module doesn't define any dependencies or
optional metadata.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example summary``
| ``     description: And an example description.``
| ``     license:``
| ``         module:``
| ``             - MIT``
| ``     components:``
| ``         rpms:``
| ``             foo:``
| ``                 rationale: An example RPM component.``

Minimal module with RPM content but with the -docs subpackage excluded
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yet another flavour of the minimal module, containing one RPM package
with SRPM name *foo*. A build of 'foo' creates binary packages
'foo-1.0-1' and the subpackage 'foo-doc-1.0-1'. Both would get included
in the module for any architecture if no filter were be used. This
module doesn't define any dependencies or optional metadata.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example summary``
| ``     description: And an example description.``
| ``     license:``
| ``         module:``
| ``             - MIT``
| ``     filter:``
| ``         rpms:``
| ``             - foo-docs``
| ``     components:``
| ``         rpms:``
| ``             foo:``
| ``                 rationale: An example RPM component.``

Minimal module with dependencies only (a variant of stack)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Another minimal module, containing no packages or any optional metadata
besides dependencies. Modules of this type are, together with modules
that include other modules, referred to as *stacks*.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example summary``
| ``     description: And an example description.``
| ``     license:``
| ``         module:``
| ``             - MIT``
| ``     dependencies:``
| ``         requires:``
| ``             generational-core: master``
| ``             a-framwork-module: and-its-stream``

Minimal module which includes another (another variant of stack)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yet another minimal module, containing no optional metadata besides a
single included module in the components section. Modules of this type
are, together with modules that only depend on other modules, referred
to as stacks.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example summary``
| ``     description: And an example description.``
| ``     license:``
| ``         module:``
| ``             - MIT``
| ``     content:``
| ``         modules:``
| ``             a-framework-module:``
| ``                 rationale: Bundled for various reasons.``

Common Fedora module
~~~~~~~~~~~~~~~~~~~~

A typical Fedora module defines all the mandatory metadata plus some
useful references, has build and runtime dependencies and contains one
or more packages built from specific refs in dist-git. It relies on the
Module Build Service to extract the name, stream and version properties
from the VCS data and to fill in the licensing information from the
included components and populate the ``data→license→content`` list.

| `` document: modulemd``
| `` version: 1``
| `` data:``
| ``     summary: An example of a common Fedora module``
| ``     description: This module demonstrates what most Fedora modules look like.``
| ``     license:``
| ``         module: [ MIT ]``
| ``     dependencies:``
| ``         buildrequires:``
| ``             generational-core: master``
| ``             extra-build-environment: master``
| ``         requires:``
| ``             generational-core: master``
| ``     references:``
| ``         community: ``\ ```http://www.example.com/common-package`` <http://www.example.com/common-package>`__
| ``         documentation: ``\ ```http://www.example.com/common-package/docs/5.67/`` <http://www.example.com/common-package/docs/5.67/>`__
| ``     profiles:``
| ``         default:``
| ``             rpms:``
| ``                 - common-package``
| ``                 - common-plugins``
| ``         development:``
| ``             rpms:``
| ``                 - common-package``
| ``                 - common-package-devel``
| ``                 - common-plugins``
| ``     api:``
| ``         rpms:``
| ``             - common-package``
| ``             - common-package-devel``
| ``             - common-plugins``
| ``     components:``
| ``         rpms:``
| ``             common-package:``
| ``                 rationale: The key component of this module.``
| ``                 ref: common-release-branch``
| ``             common-plugins:``
| ``                 rationale: Extensions for common-package.``
| ``                 buildorder: 1``
| ``                 ref: common-release-branch``

Complete module definition
~~~~~~~~~~~~~~~~~~~~~~~~~~

See `the modulemd
specification <https://pagure.io/modulemd/blob/master/f/spec.yaml>`__.

