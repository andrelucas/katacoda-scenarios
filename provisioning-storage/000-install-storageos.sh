CLUSTER_ID=$(ssh root@host01 "storageos cluster create")

docker -H host01:2345 pull storageos/node:1.0.0

docker -H host02:2345 pull storageos/node:1.0.0

docker -H host03:2345 pull storageos/node:1.0.0

scp -p ~/.ssh/id_rsa root@host01:/root/.ssh
ssh root@host01 "echo [[HOST2_IP]] host02 >> /etc/hosts && echo [[HOST3_IP]] host03 >> /etc/hosts"

#curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/1.0.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
