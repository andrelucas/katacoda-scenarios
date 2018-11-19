Developers can request storage using persistent volume claims.

Create PersistentVolumeClaim and a Redis pod which references the `fast` StorageClass:

`kubectl create -f storageos-pvc.yaml`{{execute}}
`kubectl create -f redis-pod.yaml`{{execute}}

`
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: fast0001
  annotations:
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
`
Above is defintion for the PersistentVolumeClaim that you first created. Below
is the definition for the Redis pod that you created. The pod definition
references the PVC name in the spec.volumes section.

`
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: redis
    role: master
  name: test-storageos-redis-sc-pvc
spec:
  containers:
    - name: master
      image: kubernetes/redis:v1
      env:
        - name: MASTER
          value: "true"
      ports:
        - containerPort: 6379
      resources:
        limits:
          cpu: "0.1"
      volumeMounts:
        - mountPath: /redis-master-data
          name: redis-data
  volumes:
    - name: redis-data
      persistentVolumeClaim:
        claimName: fast0001
`

You should see a StorageOS persistent volume:

`kubectl describe pv`{{execute}}

Confirm StorageOS provisioned the volume on `node01`:

`storageos volume ls --format "table {{.Name}}\t{{.Size}}\t{{.Location}}"`{{execute}}
