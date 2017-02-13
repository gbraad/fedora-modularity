Properties of branches and update streams
=========================================

**ABI Compatibility:** Updates within a single update stream are likely
to maintain ABI backwards compatibility in most cases. Users should be
able to consume updates from an update stream without being concerned
about breaking applications that depend on that module. A major change
introducing an incompatible ABI would normally be expected to require a
new version branch.

But this is ultimately a policy decision: there is nothing technical to
stop ABI breakage within a version stream. For example, the current
RHEL-7 extras stream may break compatibility from time to time, and has
done so in the past in certain container platform packages. Our tools
should be able to detect incompatible ABI changes as far as possible,
but should not prevent them if we have an exceptional case where such a
change is desired.

(ABI compatibility here includes anything that may have a compatibility
on user or application compatibility, including for example semantics of
configuration files, library ABIs, command line option handling and
error codes, and so on.)

**Constraining the scope of ABI dependency:** As preserving ABI on
updates is a burden which imposes constraints on our maintenance of a
module within a single version branch, we would like the ability to
limit the parts of a module to which ABI stability applies. We currently
define which packages within a module form the **external ABI** of the
module: this is defined by the maintainer of a given module’s metadata.
Conversely, packages not declared as external are implicit internal
implementation details of the module.

Defining the external ABI as a set of packages will allow us to:

-  Rebase internal packages without constraint from ABI guarantees,
   removing overhead from the module maintenance burden over time;
-  Verify that layered modules or applications depend only on packages
   defined as external ABI, by checking rpm dependency chains

**Lifecycle:** Given that we define no formal policy on ABI
lifecycle—rather leaving this up to policy—it follows that there is no
strong requirement that version numbers of packages within a single
update stream have to follow any particular pattern. We can easily
rebase a package within an update stream, even adding new features, as
long as any claimed backwards compatibility is preserved.

We do need to be concerned about whether 3rd-party application
certification is expected to be preserved when such an application
depends on a module’s version branch containing rebased packages. This
is an important question, and we need to add tooling and policy around
it; but for now this is primarily a policy question, and beyond the
scope of this document. Different modules may have different appetite
for risk and rebases, and hence have different policy around
certification.

**Parallel Availability:** The update streams for different module
version branches must be able to coexist in our pipeline and released
content, without interfering with each other. If a given base system
install has both httpd-2.2 and httpd-2.4 available in different version
branches, then it is important that these remain independent.

The update streams must not interfere with each other. If httpd-2.2 is
installed, then updating it via yum or dnf should update it to the most
recent version in the httpd-2.2 update stream, and must not
automatically update it to 2.4. Any dependencies brought in by either
must also prevent such interference.

And yet if a certain package *does* support parallel installation of
different version branches at the same time (eg. RHSCLs), then the
separate installed versions at any time must each be updatable by their
own specific update stream.
