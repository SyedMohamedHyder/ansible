# ansible
Learn Ansible with me!

The images in this repo are available in syedhyder1362k registry in DockerHub.

```bash
docker pull syedhyder1362k/ansible:python3.10.13
docker pull syedhyder1362k/ansible:python3.10.13-alpine
```

The centos based ansible image is also available which can be used as follows.

```bash
docker run --name ansible -v /path/to/.ssh:/home/ansible/.ssh -v /path/to/ansible-data:/home/ansible syedhyder1362k/ansible-playbook:centos7 \<playbook-path\>
```

I have included a folder k8s/ansible where you can find all the manifests that serve as a good starting point with which you can play around with ansible.
I will probably at some point convert this to a helm chart. But I am leaving it as it is, so that people can understand the idea behind what is going on in the manifests.

You can just get the environment up and running by

```bash
kubectl apply -f k8s/ansible
```

In order to grab a shell in the controller, execute the following command

```bash
CONTROLLER=$(kubectl get pods --selector app.kubernetes.io/name=ansible-controller -o=jsonpath='{.items[*].metadata.name}')
kubectl exec -it $CONTROLLER -- /bin/bash
```

Once into the container, you can play around with it by running the ansible commands.

For scenarios, where you would need to debug the target pod, just replace the above selector with `app.kubernetes.io/name=ansible-target`
