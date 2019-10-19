#!/bin/sh
sudo kubeadm join 192.168.1.16:6443 --token mp2wvs.z4ziwyzj6x7t06d7 \
  --discovery-token-ca-cert-hash sha256:3e776296dc97e5645e9406fa93ac194fb89b38979b00afa9cf56ff10627c114b
