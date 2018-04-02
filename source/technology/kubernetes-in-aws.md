---
layout: page
title: "Kubernetes in AWS"
comments: true
sharing: true
footer: true
---

* list element with functor item
{:toc}

# Installation

(RHEL Linux image was used)

__Master + Worker nodes__

```bash

# run these as root user for both master and worker nodes
sudo -i
yum update -y
yum-config-manager --enable rhui-REGION-rhel-server-extras
yum install -y docker
service docker start
usermod -a -G docker ec2-user

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
```

__Master node only__

```bash
kubeadm init --pod-network-cidr=10.244.0.0/16 # flannel based network
sysctl net.bridge.bridge-nf-call-iptables=1

# as non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
```

__Worker node only__

```bash
sudo -i
systemctl enable kubelet.service 
systemctl enable docker.service
kubeadm join 172.31.3.185:6443 --token 1zejl4.hn7dmiy3npccliju --discovery-token-ca-cert-hash sha256:497940d1662cf7aa0cd67386105cbd081a948762b56d7d7a5709e32f02deb54b
kubeadm join 172.31.3.185:6443 --token g04zmd.aov052plvhimserw --discovery-token-ca-cert-hash sha256:3cf3884745540b06c2fa526b756fe789255eab21e63cc3b3024f8a902a0f0115
```

# Usage

```bash
kubectl get nodes # from master: to view all worker nodes attached
kubeadm token list # from master: to view token to join worker nodes
```