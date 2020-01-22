Clone the repo:
`git clone https://github.com/Klaudioz/do-kasten.git`

Move to the folder:
`cd do-kasten`

Build the container:
`docker build -t do-kasten .`

Run the container:
`docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten init_k10`

To clean the cluster use:
`docker run --rm -it --env DIGITALOCEAN_ACCESS_TOKEN=<your_token> do-kasten clean_k10`

Task description:

To start the process, a Digital Ocean account has already been created, and a kubernetes cluster has already been created called `claudio-canales`. To retrieve the DigitalOcean access token navigate to https://cloud.digitalocean.com/account/api/tokens and click "Generate New Token" under Personal Access Tokens. Instructions are below to retrieve the kubeconfig file, or navigate to https://cloud.digitalocean.com/kubernetes/clusters/68a831d4-c188-47c8-9381-e592eb340e6d?i=56c4be and click "Download Config File"

 

- Build a docker image, from a base of your choice (don't get caught up in optimization) that:

        contains the following programs/executables:

        doctl (https://github.com/digitalocean/doctl)

        helm (https://helm.sh/docs/intro/install/)

        kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/)

    contains an entrypoint script (in the language of your choice) that authorizes a digital ocean account in the container (container should start having already authorized to digital ocean) and sets up kubeconfig. The entrypoint should prep any following command with the digitalocean and kubernetes configurations. You should be able to interact with both the infrastructure (digitalocean) and kubernetes once the entrypoint is finished.

        `export DIGITALOCEAN_ACCESS_TOKEN=<Personal Access Token Goes Here>`

        `doctl auth init`

        `mkdir ~/.kube`

        `doctl kubernetes cluster kubeconfig show claudio-canales > ~/.kube/config` # outputs to stdout only available if a cluster exists

        `KUBECONFIG=~/.kube/config`

- Next create a script (in the language of your choice) add some automation to the container, which will install k10, and an application and take a snapshot based backup :-)

    This script should be called when the following command is run `docker run <image_name> init_k10`

    Initialize Helm (you can use 2 or 3 depending on your preference)

    The commands for either 2 or 3 are found here https://docs.kasten.io/install/install.html#prerequisites

    Install K10 into the cluster

    https://docs.kasten.io/install/install.html#installing-in-other-environments (instructions for helm 2 or 3)

    you'll need to add an annotation for K10 to properly work in Digital Ocean

    `kubectl annotate volumesnapshotclass do-block-storage k10.kasten.io/is-snapshot-class=true`

- Install MySQL into the cluster

    `helm install --name my-release stable/mysql`

    Implement a policy to backup mysql using k10

    This can be a yaml file you add to the docker image at build time

    https://docs.kasten.io/api/policies.html

    If you need help here - you can port-forward to the k10 gateway (https://docs.kasten.io/access/dashboard.html?highlight=gateway) and access the UI. From there you can create a policy manually, and there is a button that will show you the yaml it creates, extract that, and use it as part of the automation process

- Verify policy via dashboard (manually)

    Gain access to UI

    https://docs.kasten.io/access/dashboard.html?highlight=gateway

    the dashboard should show the executed backup job and the status of that job

- (optionally) create a command that resets the cluster, either by removing the entire cluster, or by removing the install software, and any resources associated to them. This may also help in the development process to replay different steps.