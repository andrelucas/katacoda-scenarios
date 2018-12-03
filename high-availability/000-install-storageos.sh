ssh root@host01 '/opt/enable-lio.sh'
ssh root@host02 '/opt/enable-lio.sh'
ssh root@host03 '/opt/enable-lio.sh'

CLUSTER_ID=$(ssh root@host01 "storageos cluster create")
IMAGE_ID=814fc6d-dev2918-eb3b8146

for n in 01 02 03; do
    case "$n" in
    01)
        ip=[[HOST_IP]]
        ;;
    02)
        ip=[[HOST2_IP]]
        ;;
    03)
        ip=[[HOST3_IP]]
        ;;
    *)
        echo "Unnknown host $h" >&2
        exit 1
        ;;
    esac
    docker "-H host$n":2345 run -d --name storageos \
        -e LOG_LEVEL=DEBUG\
        -e HOSTNAME="host$n" \
        -e ADVERTISE_IP="$ip" \
        -e JOIN="$CLUSTER_ID" \
        --net=host --pid=host --privileged --cap-add SYS_ADMIN \
        --device /dev/fuse \
        -v /sys:/sys \
        -v /var/lib/storageos:/var/lib/storageos:rshared \
        -v /run/docker/plugins:/run/docker/plugins \
        "soegarots/node:$IMAGE_ID"  server
done

scp -p ~/.ssh/id_rsa root@host01:/root/.ssh
ssh root@host01 "echo [[HOST2_IP]] host02 >> /etc/hosts && echo [[HOST3_IP]] host03 >> /etc/hosts"

ssh root@host01 "export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=[[HOST_IP]]"
ssh root@host02 "export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=[[HOST2_IP]]"
ssh root@host03 "export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=[[HOST3_IP]]"

ssh root@host01 "curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin"
ssh root@host02 "curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/"
ssh root@host03 "curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/"
