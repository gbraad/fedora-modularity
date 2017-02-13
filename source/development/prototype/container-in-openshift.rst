How to deploy container into OpenShift with ease
================================================

This chapter describes how to easily generate working OpenShift template
and what are useful OpenShift commands.

OpenShift deployment possibilities
----------------------------------

OpenShift uses an abstraction called deployment to deploy applications.
A deployment could be basically explained as a load balancer for pods.

A pod is the smallest deployable unit in OpenShift which is composed of
one or more containers. These containers share an IP address and
volumes, are always deployed together on a single host, and are scaled
together as a single unit.

Scenario one Pod and two containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This scenario is useful once you would like to have two containers,
where one is opened to anyone and second one is used as “hidden”
database. Like Internal register with hidden database.

OpenShift linter command
------------------------

Once you wrote an OpenShift template, you would like to check it,
whether all fields are written properly. In order to verify the
template, **oc\_linter** or **oc lint** command would be welcome.

Really basic YAML checker is *yamllint *, but it does not check
OpenShift specific things.

I have already filed a RFE issue on GitHub `OpenShift Pull
Request <https://github.com/openshift/origin/issues/12404>`__.

How to generate working template for OpenShift
----------------------------------------------

We need the templates, in order to test our containers on OpenShift. We
should simplify a way, for template generation. I have already filed a
RFE on OpenShift GitHub here `GitHub
RFE <https://github.com/openshift/origin/issues/12402>`__ These set of
scripts, can help the users for testing their containers together with
OpenShift. I don’t know if it is proper way, but for testing proposes it
works.

Creating template with oc command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to create a working template with **oc** command only two steps
are needed.

-  Run command:

::

    oc new-app <docker_image_name>

-  Run command:

::

    oc export dc/service_name>

Can be taken from previous command. It is identical.

Creating template by our tool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prerequisites
^^^^^^^^^^^^^

-  Clone GitHub repository: `Petr Hracek
   modularity\_tools <https://github.com/phracek/modularity_tools>`__

   -  The tools will be moved soon into repository `Pagure
      modularity-tools <https://pagure.io/modularity/modularity-tools>`__

-  Switch into your container directory. The directory has to contain
   **Dockerfile** or like **Dockerfile.RHEL** and
   **`openshift.yml <https://github.com/container-images/container-image-template/blob/master/openshift-template.yml>`__**

   -  Both files are important for proper template generation.
   -  If **Dockerfile** contains *ENV*, *VOLUMES* or *EXPOSE*
      directives, they are add into OpenShift template.

-  Build your container image with **docker build ...** command. Do
   **NOT** use '\_' in the image name.

How to feed the template into OpenShift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  From
   `modularity\_tools <https://github.com/phracek/modularity_tools>`__
   repository, run command:

   -  **get\_oc\_registry** gets your OpenShift docker-repository IP
      address and stores it to file: **~/.config/openshift\_ip.ini**

-  In order to build OpenShift template from your container directory,
   run command:
   ::

       build_oc_template.py <IMAGE_NAME>

   -  In case of different Dockerfile name like **Dockerfile.RHEL** add
      the option **--dockerfile Dockerfile.RHEL**
   -  Template is stored in **/tmp//openshift-template.yml**

-  For tagging your built image into OpenShift internal docker registry,
   run command:
   ::

       tag_into_oc_registry <IMAGE_NAME>

   -  The command adds the image into OpenShift internal docker registry

-  For adding the template into OpenShift, run command:
   ::

       oc create -f /tmp/<template_dir>/openshift-template.yml

-  The last step for deploying the **template** names as *IMAGE\_NAME*
   is over OpenShift UI. By default,
   ::

       "My Project" -> "Add to project" -> Select your template names as "IMAGE_NAME" in "Browsed Catalog" -> deploy it.

-  For getting template from running pod/deploymentconfig/is, run
   command:
   ::

       oc export {pod/dc/is}/<pod_name>|dc_name|is_name> > output.yml

   -  Names are taken by commands
      ::

          oc get {pod|dc|is}

How to run container as a root under OpenShift
----------------------------------------------

Nowadays, OpenShift team provides a command, how to run container under
OpenShift with root privileges.

::

    oadm policy add-scc-tu-user anyuid system:serviceaccount:<namespace>:default

where namespace is project name. Default one is *myproject*.

The script
`add\_anyuid\_to\_project.sh <https://github.com/phracek/modularity_tools/blob/master/add_anyuid_to_project.sh>`__
does it automatically. Required argument is project name, like in our
case **myproject**.

General commands with examples for using OpenShift
--------------------------------------------------

All commands, in this section, should start with **sudo**.

-  To check whether OpenShift is running, run command:

::

    $ oc status

    In project My Project (myproject) on server https://10.200.136.26:8443
    dc/postfix-tls deploys istag/postfix-tls:latest
      deployment #1 deployed 42 minutes ago - 1 pod
    2 warnings identified, use 'oc status -v' to see details.

-  Command for displaying all resources
   pod\|deploymentconfigs\|imagestreams, run command:

::

    $ oc get <pod|dc|is>

    $ oc get pod
    NAME                  READY     STATUS    RESTARTS   AGE
    postfix-tls-1-kf0ud   1/1       Running   0          42m
    $ oc get dc
    NAME          REVISION   DESIRED   CURRENT   TRIGGERED BY
    postfix-tls   1          1         1         image(postfix-tls:latest)

-  For getting what services are available on OpenShift, run command:

::

    $ oc get svc

-  For showing details of a specific resource, PODs, services, etc., run
   command:

::

    oc describe pod|dc|is|svc <name>

    $ oc describe pod postfix-tls-1-kf0ud
    Name:            postfix-tls-1-kf0ud
    Namespace:        myproject
    Security Policy:    anyuid
    Node:            10.200.136.26/10.200.136.26
    Start Time:        Fri, 20 Jan 2017 12:55:41 +0100
    Labels:            deployment=postfix-tls-1
                deploymentconfig=postfix-tls
                name=postfix-tls
    Status:            Running
    IP:            172.17.0.3
    Controllers:        ReplicationController/postfix-tls-1
    Containers:
      postfix-tls:
        Container ID:    docker://6664727b761de3498eb863457aa4554820645b21dbea7e5b9a8a4d0382b22e7f
        Image:        postfix-tls
    [..snip..]
      43m        43m        1    {kubelet 10.200.136.26}    spec.containers{postfix-tls}    Normal        Created        Created container with docker id 6664727b761d
      43m        43m        1    {kubelet 10.200.136.26}    spec.containers{postfix-tls}    Normal        Started        Started container with docker id 6664727b761d

-  Command for restarting POD is:

::

    oc scale --replicas=0 dc/<name>

-  For deploying template, run command:

::

    oc deploy <deployment_name> --latest -n <project_name> # default is myproject

-  For creating new POD, run command:

::

    oc new-app <docker_image>

-  For switching into system:admin, run command:

::

    oc login -u system:admin

-  For switching to developer mode, run command (default password is
   developer):

::

    oc login -u developer

-  For modifying Security Content Constraints, switch to system:admin
   and run command:

::

    oc get scc | jq …. | oc replace -f -

Once it is done switch back to developer mode.

-  For getting Security Content Constraints, run command:

::

    oc get scc
    NAME               PRIV      CAPS      SELINUX     RUNASUSER          FSGROUP     SUPGROUP    PRIORITY   READONLYROOTFS   VOLUMES
    anyuid             false     []        MustRunAs   RunAsAny           RunAsAny    RunAsAny    10         false            [configMap downwardAPI emptyDir persistentVolumeClaim secret]
    [..snip..]
    privileged         true      []        RunAsAny    RunAsAny           RunAsAny    RunAsAny    <none>     false            [*]
    restricted         false     []        MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <none>     false            [configMap downwardAPI emptyDir persistentVolumeClaim secret]

-  How to get YAML file from specific ImageStream

::

    oc get -o yaml is/<name>

-  How to get YAML file from specific container

::

    oc get -o yaml dc/<name> # name is taken from oc get dc

-  For deleting deployment

::

    oc delete dc/<name> # name is taken from oc get dc

-  For using container as root, run command:

::

    oadm policy add-scc-tu-user anyuid system:serviceaccount:<namespace>:default

The command has now granted access for that namespace (only) to run pods
as the root UID. It is less secured than restricted but recommended if
you must run as root. It still does not allow privileged containers or
host namespaces (network, pid, ipc). It will only drop the mknod and
sys\_chroot caps (and not kill, setuid, setgid like restricted)

How to debug service from OpenShift point of view
-------------------------------------------------

This URL shows, how you are able to `debug a
service <https://docs.openshift.com/enterprise/3.1/admin_guide/sdn_troubleshooting.html#debugging-a-service>`__.
Basically it is a POD readiness issue. Therefore os get pod command and
the others mentioned below can help.

Running your service in OpenShift environment
---------------------------------------------

OpenShift brings some security restrictions which make it tough to “just
run” your containerized services. This means that your service may run
easily in a docker container, but it may not be trivial to deploy it in
an OpenShift environment. Here is a list of sample steps to start the
process of integration:

-  If your container expects some mounts and you would like to perform
   the mounting directly from host, here’s how to do it (by default this
   is forbidden):

   -  Login as system:admin
      ::

          $ oc login -u system:admin

   -  `Change restricted security context to allow host
      mounts. <https://docs.openshift.org/latest/admin_guide/manage_scc.html#use-the-hostpath-volume-plugin>`__
   -  Login back as developer
      ::

          $oc login -u developer

-  Here is `a simple, minimal pod
   spec <https://gist.github.com/TomasTomecek/70853c1de07da7f4bd0c1c42526e8aca>`__
   which takes your container image and runs bash inside so you can
   quickly iterate.
-  Run it.
   ::

       oc create -f ./pod.yml

-  Attach to shell within the container
   ::

       $ oc attach -t -i caching-dns-server

   -  And now you can directly run the service and see what’s happening

-  In case something goes wrong, here’s how to get more info:

::

    $ oc logs  caching-dns-server
    $ oc describe pod caching-dns-server

Links
-----

-  `Main OpenShift
   documentation <https://docs.openshift.org/latest/welcome/index.html>`__
-  `Introduction userns in Docker
   engine <https://success.docker.com/Datacenter/Apply/Introduction_to_User_Namespaces_in_Docker_Engine>`__
