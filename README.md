1. SANAL MAKİNE (LAB) KURULUMU
🔹 Seçenek (Önerilen – CKAD için ideal)

1 adet Ubuntu Server 22.04 VM + kubeadm cluster

Minimum Sistem Gereksinimleri

CPU: 2 vCPU

RAM: 4 GB (6 GB daha rahat)

Disk: 40 GB

OS: Ubuntu Server 22.04 LTS

🔹 VM Kurulum Adımları (Özet)
# Swap kapat
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Container runtime
apt update
apt install -y containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Kubernetes repo
apt install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/k8s.gpg
echo "deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/k8s.list

apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

Cluster Init
kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

Network Plugin
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
📅 2. 30 GÜNLÜK CKAD ÇALIŞMA PLANI (1 SAAT / GÜN)

Her gün:

⏱️ 10 dk: Hızlı tekrar

⏱️ 40 dk: Pratik (komut + YAML)

⏱️ 10 dk: “sınav refleksi” (time pressure)

🟢 GÜN 1–5: TEMEL POD & YAML HAKİMİYETİ
Gün 1

kubectl basics

imperative vs declarative

kubectl run nginx --image=nginx
kubectl get pods -o wide
kubectl delete pod nginx

Gün 2

Pod YAML yazma

labels / selectors

Gün 3

multi-container pod

sidecar log senaryosu

Gün 4

resource requests / limits

OOMKilled test

Gün 5 (Mini Exam)

Senaryo:

2 container’lı pod oluştur
biri log üretsin, diğeri tail etsin

🟡 GÜN 6–10: DEPLOYMENT – REPLICA – ROLLOUT
Gün 6

Deployment YAML

replicas

Gün 7

rollout / rollback

kubectl rollout undo deployment web

Gün 8

scaling

rollingUpdate strategy

Gün 9

env & config

args / command override

Gün 10 (Mini Exam)

Senaryo:

nginx deployment
3 replica
image update → rollback

🟠 GÜN 11–15: CONFIGMAP & SECRET (CKAD FAVORİ)
Gün 11

ConfigMap (env + volume)

Gün 12

Secret (base64, env, volume)

Gün 13

immutable config

update test

Gün 14

Downward API

Gün 15 (Mini Exam)

Senaryo:

ConfigMap ile app config ver
Secret ile password mount et

🔵 GÜN 16–20: STORAGE (PV / PVC / VOLUME)
Gün 16

emptyDir

hostPath

Gün 17

PV / PVC (static)

accessModes

Gün 18

volumeMount tricks

Gün 19

shared volume senaryosu

Gün 20 (Mini Exam)

Senaryo (CKAD benzeri):

RWX PV
PVC bind
Pod mount

(az önce yaptığın soru birebir 👍)

🔴 GÜN 21–25: NETWORK & PROBES
Gün 21

Service (ClusterIP)

Gün 22

NodePort

port-forward

Gün 23

readiness / liveness probe

Gün 24

ingress (basic)

Gün 25 (Mini Exam)

Senaryo:

probe ekle
servis expose et

🟣 GÜN 26–29: JOB – CRONJOB – TROUBLESHOOT
Gün 26

Job

restartPolicy

Gün 27

CronJob

Gün 28

logs

exec

describe ile hata bulma

Gün 29

crashloop debug

typo YAML fix

🏁 GÜN 30: FULL MOCK EXAM (🔥)

⏱️ 2 saatlik sınav simülasyonu

8–10 senaryo

YAML copy-paste

kubectl explain kullan

🧠 SINAV TAKTİKLERİ (ALTIN DEĞERİNDE)

✅ kubectl explain pod.spec.containers
✅ Alias:

alias k=kubectl
export do="--dry-run=client -o yaml"


✅ YAML üret:

k run nginx --image=nginx $do > pod.yaml

🗓️ CKAD – GÜN 1
🎯 Hedef

kubectl temel komutları + Pod oluşturma/silme + hız kazanma

🖨️ 1. GÜN – PRINTABLE CHECKLIST

📌 Bunu aynen yazdırabilirsin

☐ Cluster çalışıyor mu kontrol ettim
☐ kubectl get nodes çalışıyor
☐ kubectl context doğru
☐ İlk pod’u imperative olarak oluşturdum
☐ Pod listesini farklı formatlarda görüntüledim
☐ Pod detaylarını inceledim (describe)
☐ Pod loglarını aldım
☐ Pod içine exec ile girdim
☐ Pod’u sildim
☐ Dry-run ile YAML ürettim
☐ YAML dosyasından pod oluşturdum
☐ Süre tuttum (≤ 60 dk)
☐ Hata aldım mı? (evet → çözdüm)
☐ Gün sonunda tekrar yaptım

⏱️ 1. GÜN ZAMAN PLANI (1 SAAT)
Süre	Ne yapacaksın
10 dk	Hızlı tekrar / ortam kontrol
40 dk	Alıştırmalar
10 dk	Tekrar + refleks
🔁 1. ADIM – HIZLI TEKRAR (10 DK)
kubectl version --short
kubectl cluster-info
kubectl get nodes
kubectl get pods


➡️ ÇIKTI GELİYORSA DEVAM
➡️ Gelmiyorsa .kube/config kontrol

🧪 2. ADIM – ALIŞTIRMALAR (40 DK)
🧩 Alıştırma 1 – Imperative Pod (5 dk)
kubectl run nginx-pod --image=nginx


Kontrol:

kubectl get pods


✔ STATUS: Running

🧩 Alıştırma 2 – Output Formatları (5 dk)
kubectl get pods -o wide
kubectl get pods -o yaml
kubectl get pods -o json


🎯 Amaç: YAML’a göz alışkanlığı

🧩 Alıştırma 3 – Pod Detayı & Log (5 dk)
kubectl describe pod nginx-pod
kubectl logs nginx-pod


❗ nginx logu boş olabilir → normal

🧩 Alıştırma 4 – Pod içine gir (5 dk)
kubectl exec -it nginx-pod -- sh


İçeride:

ls /
exit

🧩 Alıştırma 5 – Pod Sil (3 dk)
kubectl delete pod nginx-pod

🧩 Alıştırma 6 – Dry-run ile YAML üret (8 dk)
kubectl run test-pod \
  --image=busybox \
  --command -- sleep 3600 \
  --dry-run=client -o yaml > pod.yaml


Dosyayı aç:

cat pod.yaml


🎯 metadata / spec / containers gör

🧩 Alıştırma 7 – YAML’dan Pod oluştur (5 dk)
kubectl apply -f pod.yaml
kubectl get pods

🧩 Alıştırma 8 – Hız Testi (4 dk)

⏱️ Süre tut

kubectl delete pod test-pod
kubectl run test-pod --image=nginx
kubectl delete pod test-pod


🎯 ≤ 1.5 dk hedef

🔄 3. ADIM – GÜN SONU TEKRAR (10 DK)
🧠 KAFADAN SÖYLE

Pod oluşturma 2 yöntem?

Dry-run ne işe yarar?

logs / exec farkı?

✍️ EL YAZISI (çok önemli)

Bir kağıda yaz:

kubectl run
kubectl get pods
kubectl describe pod
kubectl logs
kubectl exec -it
kubectl delete pod
--dry-run=client -o yaml

🗓️ CKAD – GÜN 2
🎯 Hedef

Declarative YAML hâkimiyeti + labels & selectors + kubectl explain

🖨️ 2. GÜN – PRINTABLE CHECKLIST
☐ YAML ile Pod oluşturdum
☐ YAML yapısını ezbere yazabildim
☐ labels ekledim
☐ label selector ile pod filtreledim
☐ pod label’ını runtime’da değiştirdim
☐ kubectl explain kullandım
☐ YAML’da typo yaptım ve düzelttim
☐ pod delete + recreate yaptım
☐ Süre tuttum (≤ 60 dk)
☐ Gün sonu tekrar yaptım

⏱️ GÜN 2 – 1 SAATLİK PLAN
Süre	İçerik
10 dk	Gün 1 hızlı tekrar
40 dk	YAML + label pratik
10 dk	Tekrar + mini drill
🔁 1. ADIM – GÜN 1 TEKRAR (10 DK)
kubectl get pods
kubectl delete pod test-pod
kubectl run temp --image=nginx
kubectl delete pod temp


🎯 Refleks kontrolü

🧪 2. ADIM – ALIŞTIRMALAR (40 DK)
🧩 Alıştırma 1 – İlk Declarative Pod (8 dk)

pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
  - name: nginx
    image: nginx

kubectl apply -f pod.yaml
kubectl get pods

🧩 Alıştırma 2 – Labels ekle (6 dk)
metadata:
  name: web-pod
  labels:
    app: web
    tier: frontend

kubectl apply -f pod.yaml
kubectl get pods --show-labels

🧩 Alıştırma 3 – Label Selector (5 dk)
kubectl get pods -l app=web
kubectl get pods -l tier=frontend

🧩 Alıştırma 4 – Runtime Label Değiştir (5 dk)
kubectl label pod web-pod env=prod
kubectl label pod web-pod tier=backend --overwrite

kubectl get pods --show-labels

🧩 Alıştırma 5 – kubectl explain (6 dk)
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.containers
kubectl explain pod.spec.containers.image


🎯 YAML alanlarını ezberlemeden öğrenme

🧩 Alıştırma 6 – Bilerek Hata Yap (5 dk)

YAML’da şunu boz:

image: ngnix

kubectl apply -f pod.yaml
kubectl describe pod web-pod


🔍 ImagePullBackOff gör → düzelt

🧩 Alıştırma 7 – Delete & Recreate (5 dk)
kubectl delete pod web-pod
kubectl apply -f pod.yaml

🔄 3. ADIM – GÜN SONU TEKRAR (10 DK)
🧠 KAFADAN SAY

Declarative neden sınavda avantaj?

label vs annotation farkı?

selector ne işe yarar?

✍️ EZBERE YAZ
apiVersion:
kind:
metadata:
  name:
  labels:
spec:
  containers:
  - name:
    image:
