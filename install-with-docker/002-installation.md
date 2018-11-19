Now you can install the StorageOS node container on each host.

In the first terminal:

`docker run --name enable_lio --privileged --rm --cap-add=SYS_ADMIN -v /lib/modules:/lib/modules -v /sys:/sys:rshared storageos/init:0.1`{{execute T1}}

`docker run -d --name storageos -e HOSTNAME=host01 -e ADVERTISE_IP=[[HOST_IP]] -e JOIN=[[HOST_IP]] --net=host --pid=host --privileged --cap-add SYS_ADMIN --device /dev/fuse -v /var/lib/storageos:/var/lib/storageos:rshared -v /run/docker/plugins:/run/docker/plugins storageos/node:1.0.0 server `{{execute T1}}

Wait until the container reports that it is healthy:

`docker ps`{{execute T1}}

and confirm that StorageOS has started on the first node:

`storageos node ls`{{execute T1}}
