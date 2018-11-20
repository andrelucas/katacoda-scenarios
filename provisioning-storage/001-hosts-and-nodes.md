For this tutorial we will use the StorageOS CLI to explore the cluster. 

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
