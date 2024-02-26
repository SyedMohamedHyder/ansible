# ansible
Learn Ansible with me!

The images in this repo are available in syedhyder1362k registry in DockerHub.
An automated workflow has been deployed, which will build and push the images whenever a tag is created. You can have a look at it to learn more about how to automate the process.

```bash
docker pull syedhyder1362k/ansible:python3.10.13
docker pull syedhyder1362k/ansible:python3.10.13-alpine
```

The centos based ansible image is also available which can be used as follows.

```bash
docker run --name ansible -v /path/to/.ssh:/home/ansible/.ssh -v /path/to/ansible-data:/home/ansible syedhyder1362k/ansible-playbook:python3.10.13-alpine <playbook-path>
```

I have included a folder k8s/ansible where you can find all the manifests that serve as a good starting point with which you can play around with ansible.
I will probably at some point convert this to a helm chart. But I am leaving it as it is, so that people can understand the idea behind what is going on in the manifests.

**NOTE**: Please update `shared-pv.yaml` with path to your shared folder. This folder will be mounted to the workplace inside the controller.
In my case it looks as follows.
```yaml
path: /C/Users/<path-to-ansible-repo>/shared
```

I already have included a dummy ansible.cfg and hosts file inside the shared directory which is a good starting place for you to play with.

**CAUTION**: Make necessary changes to the pvs and pvcs so that they work according to your environment.

You can just get the environment up and running by the following command.

```bash
kubectl apply -f k8s/ansible
```

In order to grab a shell in the controller, execute the following command

```bash
CONTROLLER=$(kubectl get pods --selector app.kubernetes.io/component=controller -o=jsonpath='{.items[*].metadata.name}')
kubectl exec -it $CONTROLLER -- /bin/bash
```

Once into the container, you can play around with it by running the ansible commands.

For scenarios, where you would need to debug the target pod, just replace the above selector with `app.kubernetes.io/component=controller`

**DEPRECATION WARNING**: ansible images based on centos7 have been marked as deprecated as they install very old versions of ansible thereby making them unsuitable to use with targets having latest versions of python.

### HELM CHART

I have included a helm chart that can quickly bring up the ansible playground for you. You will just have to play around with values.yaml.

**IMPORTANT**: The most important point to notice is in values.yaml, you will have to update the `workplace.path` with the path to your local workplace.
Your controller will behave based on the hosts, ansible.cfg and rest of the files there.

You can quickly get the playground up and running by the following commands.

```bash
helm repo add syed https://syedmohamedhyder.github.io/ansible/
helm install ansible syed/ansible --set 'workplace.path=<path-to-your-workplace>'
```
