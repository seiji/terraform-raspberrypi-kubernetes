#!/bin/sh
sudo kubeadm reset \
  && rm -Rf $HOME/.kube

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

kubectl get pods -n kube-system -o wide | grep flannel

kubectl get node
# running

# after workers joining
kubectl label node raspi02 node-role.kubernetes.io/worker=worker
kubectl label node raspi03 node-role.kubernetes.io/worker=worker

kubectl get node
# NAME      STATUS   ROLES    AGE     VERSION
# raspi01   Ready    master   37m     v1.16.2
# raspi02   Ready    worker   18m     v1.16.2
# raspi03   Ready    worker   3m51s   v1.16.2

kubectl get pods --all-namespaces
# NAMESPACE     NAME                              READY   STATUS    RESTARTS   AGE
# kube-system   coredns-5644d7b6d9-k2bkf          1/1     Running   0          40m
# kube-system   coredns-5644d7b6d9-nhxlb          1/1     Running   0          40m
# kube-system   etcd-raspi01                      1/1     Running   0          41m
# kube-system   kube-apiserver-raspi01            1/1     Running   0          41m
# kube-system   kube-controller-manager-raspi01   1/1     Running   3          41m
# kube-system   kube-flannel-ds-arm-5qrmj         1/1     Running   0          38m
# kube-system   kube-flannel-ds-arm-6vfmf         1/1     Running   1          22m
# kube-system   kube-flannel-ds-arm-ffzqd         1/1     Running   0          8m5s
# kube-system   kube-proxy-g5b2p                  1/1     Running   0          40m
# kube-system   kube-proxy-lvkpr                  1/1     Running   0          8m5s
# kube-system   kube-proxy-rdnzw                  1/1     Running   0          22m
# kube-system   kube-scheduler-raspi01            1/1     Running   3          40m
