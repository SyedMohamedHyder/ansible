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
