For this tutorial we will use the StorageOS CLI to explore the cluster. 

Startup the environment

`docker -H host01:2345 run --name enable_lio --privileged --rm --cap-add=SYS_ADMIN -v /lib/modules:/lib/modules -v /sys:/sys:rshared storageos/init:0.1`

`docker -H host02:2345 run --name enable_lio --privileged --rm --cap-add=SYS_ADMIN -v /lib/modules:/lib/modules -v /sys:/sys:rshared storageos/init:0.1`

`docker -H host03:2345 run --name enable_lio --privileged --rm --cap-add=SYS_ADMIN -v /lib/modules:/lib/modules -v /sys:/sys:rshared storageos/init:0.1`

`CLUSTER_ID=$(ssh root@host01 "storageos cluster create")`

`docker -H host01:2345 run -d --name storageos -e HOSTNAME=host01 -e ADVERTISE_IP=[[HOST_IP]] -e JOIN=$CLUSTER_ID --net=host --pid=host --privileged --cap-add SYS_ADMIN --device /dev/fuse -v /var/lib/storageos:/var/lib/storageos:rshared -v /run/docker/plugins:/run/docker/plugins -v /sys:/sys storageos/node:1.0.0 server`

`docker -H host02:2345 run -d --name storageos -e HOSTNAME=host02 -e ADVERTISE_IP=[[HOST2_IP]] -e JOIN=$CLUSTER_ID --net=host --pid=host --privileged --cap-add SYS_ADMIN --device /dev/fuse -v /var/lib/storageos:/var/lib/storageos:rshared -v /run/docker/plugins:/run/docker/plugins -v /sys:/sys storageos/node:1.0.0 server`

`docker -H host03:2345 run -d --name storageos -e HOSTNAME=host03 -e ADVERTISE_IP=[[HOST3_IP]] -e JOIN=$CLUSTER_ID --net=host --pid=host --privileged --cap-add SYS_ADMIN --device /dev/fuse -v /var/lib/storageos:/var/lib/storageos:rshared -v /run/docker/plugins:/run/docker/plugins -v /sys:/sys storageos/node:1.0.0 server`

`scp -p ~/.ssh/id_rsa root@host01:/root/.ssh`
`ssh root@host01 "echo [[HOST2_IP]] host02 >> /etc/hosts && echo [[HOST3_IP]] host03 >> /etc/hosts"`

Install the CLI

`curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/`{{execute}}

and set the environment variables so you can connect to the cluster:

`export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=[[HOST_IP]]`{{execute}}

Open terminals on the second and third hosts:

`ssh root@host02`{{execute T2}}
`ssh root@host03`{{execute T3}}

Use `docker ps`{{execute}} to check that the StorageOS container is running on all three nodes.

On start-up, StorageOS nodes communicate with each other to discover the overall
status of the cluster and establish consensus. Check out the nodes in this cluster:

`storageos node ls --format "table {{.Name}}\t{{.Address}}\t{{.Capacity}}"`{{execute}}
