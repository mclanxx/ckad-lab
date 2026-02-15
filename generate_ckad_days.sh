#!/bin/bash

set -e

create_day () {
DAY=$1
TITLE="$2"
TASKS="$3"
YAML="$4"

DIR=$(printf "day%02d" "$DAY")
mkdir -p $DIR

cat > $DIR/README.md <<EOF
# Gün $DAY – $TITLE

Süre: 60 dakika

## Görevler
$TASKS

## Gün Sonu
- kubectl get all
- kubectl describe gerekli objeler
- logs / exec testleri
EOF

cat > $DIR/example.yaml <<EOF
$YAML
EOF

cat > $DIR/commands.sh <<'EOF'
#!/bin/bash
kubectl get pods -A
kubectl describe pod
kubectl logs
kubectl exec -it -- sh
EOF

chmod +x $DIR/commands.sh
}

create_day 4 "Resource Requests & Limits" "
- Pod resource request/limit ekle
- OOMKilled test et
" "
apiVersion: v1
kind: Pod
metadata:
  name: resource-pod
spec:
  containers:
  - name: stress
    image: polinux/stress
    resources:
      requests:
        memory: \"64Mi\"
        cpu: \"250m\"
      limits:
        memory: \"128Mi\"
        cpu: \"500m\"
    command: [\"stress\"]
    args: [\"--vm\", \"1\", \"--vm-bytes\", \"200M\"]
"

create_day 5 "Deployment & Rollout" "
- Deployment oluştur
- scale
- rollout undo
" "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
"

create_day 6 "ConfigMap" "
- ConfigMap oluştur
- env ve volume olarak mount et
" "
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: prod
"

create_day 7 "Secret" "
- Secret oluştur
- Pod içine mount et
" "
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
stringData:
  password: secret123
"

create_day 8 "Downward API" "
- Pod metadata env olarak al
" "
apiVersion: v1
kind: Pod
metadata:
  name: downward
  labels:
    app: test
spec:
  containers:
  - name: c
    image: busybox
    command: [\"sh\",\"-c\",\"env && sleep 3600\"]
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
"

create_day 9 "PersistentVolume & PVC" "
- Static PV oluştur
- PVC bind kontrol
" "
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-test
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /mnt/data
"

create_day 10 "RWX Volume" "
- RWX PVC
- Çoklu pod mount
" "
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-rwx
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 200Mi
"

create_day 11 "Service" "
- ClusterIP
- NodePort
" "
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
"

create_day 12 "Liveness & Readiness" "
- health probe ekle
" "
apiVersion: v1
kind: Pod
metadata:
  name: probe
spec:
  containers:
  - name: nginx
    image: nginx
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 10
"

create_day 13 "Ingress" "
- ingress rule oluştur
" "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: web.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
"

create_day 14 "Job" "
- Tek seferlik job çalıştır
" "
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-job
spec:
  template:
    spec:
      containers:
      - name: hello
        image: busybox
        command: [\"echo\",\"Hello CKAD\"]
      restartPolicy: Never
"

create_day 15 "CronJob" "
- CronJob oluştur
" "
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-cron
spec:
  schedule: \"*/5 * * * *\"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            command: [\"date\"]
          restartPolicy: OnFailure
"

create_day 16 "Logs & Debug" "
- crash pod incele
" "
apiVersion: v1
kind: Pod
metadata:
  name: crash
spec:
  containers:
  - name: c
    image: busybox
    command: [\"false\"]
"

create_day 17 "CrashLoopBackOff" "
- CrashLoop pod çöz
" "
apiVersion: v1
kind: Pod
metadata:
  name: crashloop
spec:
  containers:
  - name: c
    image: busybox
    command: [\"sh\",\"-c\",\"exit 1\"]
"

create_day 18 "Sidecar Advanced" "
- sidecar log paylaşımı
" "
apiVersion: v1
kind: Pod
metadata:
  name: sidecar
spec:
  volumes:
  - name: shared
    emptyDir: {}
  containers:
  - name: app
    image: busybox
    command: [\"sh\",\"-c\",\"echo hello > /data/file && sleep 3600\"]
    volumeMounts:
    - name: shared
      mountPath: /data
  - name: sidecar
    image: busybox
    command: [\"sh\",\"-c\",\"tail -f /data/file\"]
    volumeMounts:
    - name: shared
      mountPath: /data
"

create_day 19 "Deployment Strategy" "
- RollingUpdate
- Rollback
" "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rollout
spec:
  strategy:
    type: RollingUpdate
  replicas: 2
  selector:
    matchLabels:
      app: roll
  template:
    metadata:
      labels:
        app: roll
    spec:
      containers:
      - name: nginx
        image: nginx
"

create_day 20 "Scaling" "
- scale deployment
" "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: scale
spec:
  replicas: 1
  selector:
    matchLabels:
      app: scale
  template:
    metadata:
      labels:
        app: scale
    spec:
      containers:
      - name: nginx
        image: nginx
"

create_day 21 "StatefulSet" "
- StatefulSet + PVC
" "
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: \"web\"
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx
"

create_day 22 "Headless Service" "
- clusterIP None
" "
apiVersion: v1
kind: Service
metadata:
  name: headless
spec:
  clusterIP: None
  selector:
    app: web
"

create_day 23 "DaemonSet" "
- Node başına pod
" "
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ds
spec:
  selector:
    matchLabels:
      app: ds
  template:
    metadata:
      labels:
        app: ds
    spec:
      containers:
      - name: nginx
        image: nginx
"

create_day 24 "Taints & Tolerations" "
- toleration ekle
" "
apiVersion: v1
kind: Pod
metadata:
  name: tolerate
spec:
  tolerations:
  - key: \"key\"
    operator: \"Exists\"
  containers:
  - name: nginx
    image: nginx
"

create_day 25 "Affinity" "
- node affinity
" "
apiVersion: v1
kind: Pod
metadata:
  name: affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: Exists
  containers:
  - name: nginx
    image: nginx
"

create_day 26 "NetworkPolicy" "
- default deny
" "
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
"

create_day 27 "Immutable ConfigMap" "
- immutable config
" "
apiVersion: v1
kind: ConfigMap
metadata:
  name: imm
immutable: true
data:
  key: value
"

create_day 28 "PVC Resize" "
- pvc resize test
" "
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: resize
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
"

create_day 29 "Mini CKAD Exam" "
- 5 senaryo
- süre: 90 dk
" "
# SENARYO DOSYASI – KENDİN YAZ
"

create_day 30 "FULL MOCK EXAM" "
- 8–10 senaryo
- süre: 2 saat
" "
# GERÇEK SINAV SİMÜLASYONU
"

echo "✅ CKAD 30 GÜN PAKETİ TAMAM!"
