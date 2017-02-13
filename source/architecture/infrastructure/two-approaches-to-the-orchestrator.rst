Two Approaches to the Orchestrator
======


In the Modularity Group, we have two approaches to take in how the
orchestrator and koji relate to each other. They differ in which system
owns the code for finishing the build of a module.

Modules as first-class citizens in koji
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this approach, koji owns the code for building a module from
front-to-back.

A packager might execute the following:

::

        $ fedpkg module-build

Which would talk to koji over XMLRPC and schedule a module-build. That
module build would entail rebuilding \*all\* of the constituent RPMs
from source as subtasks, and it would in the end create a repo for them
with the built module metadata baked in.

When that build of the module completes, it would publish a message to
the bus which gets picked up by taskotron which would run any checks we
have defined for whole modules.

When those checks finish, they publish a message which gets picked up by
the orchestrator. In this approach, the orchestrator is \*very\* simple.
Its pseudocode looks like this:

::

        def on_event_from_taskotron(event):

            if not event.is_about_a_module:
                return

            if not event.check_passed_successfully:
                email_relevant_people("rebuild is stuck")
                return

            dependants = ask_PDC_for_dependants(events.module_that_just_got_built)
            for other_module in dependants:
                koji.schedule_rebuild_of(other_module)

And that's it. It listens to the bus only. There is no other way to talk
to the orchestrator. Users initiate the process by asking koji

Orchestrator as the owner of module-build
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this approach, modules are not first-class citizens in koji, and the
orchestrator owns more of the logic about how to build them.

A packager might execute the following:

::

        $ fedpkg module-build

Which would talk to the orchestrator over a REST api (which means it has
to be a webapp now). The orchestrator would pull down the yaml file and
start scheduling builds for all of those components individually in a
tag/target specifically for that module.

It has to keep track (in a database) of all the ones it has submitted so
that, as they finish and each get validated by taskotron, it can know if
they are now all done or not.

Once they are all done, it then has to build the repo (either itself, or
by scheduling another task in koji that would have to be modified
anyways to insert the built module metadata yaml).

Finally, it would have to publish a fedmsg message saying that it is
done.
