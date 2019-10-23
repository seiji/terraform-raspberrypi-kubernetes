resource "null_resource" "this" {
  connection {
    type        = "ssh"
    user        = "${var.user}"
    password    = "${var.pass}"
    private_key = "${file(var.ssh_key_file)}"
    host        = "${var.host}"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    # connection
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo ${var.pub_key} >~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    echo 'pi:pi' | sudo chpasswd
    sudo sh -c 'echo -n "" > /etc/motd'
    sudo update-alternatives --set iptables /usr/sbin/iptables-legacy

    # host
    echo '127.0.1.1 ${var.hostname}' | sudo tee -a /etc/hosts
    sudo hostnamectl set-hostname ${var.hostname}

    echo 'interface eth0\nstatic ip_address=${var.static_ip_address}\nstatic routers=${var.static_routers}\nstatic domain_name_servers=${var.static_domain_name_servers}' | sudo tee -a /etc/dhcpcd.conf

    # date
    sudo timedatectl set-timezone ${var.timezone}
    sudo timedatectl set-ntp true

    # packages
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt --fix-broken install -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    sudo dphys-swapfile swapoff \
      && sudo dphys-swapfile uninstall \
      && sudo systemctl disable dphys-swapfile

    sudo systemctl disable bluetooth.service
    sudo systemctl disable hciuart.service
    sudo systemctl disable wpa_supplicant

    # Install Docker CE
    wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb \
      && wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb \
      && wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_18.09.7~3-0~debian-buster_armhf.deb \
      && sudo dpkg -i containerd.io_1.2.6-3_armhf.deb \
      && sudo dpkg -i docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb \
      && sudo dpkg -i docker-ce_18.09.7~3-0~debian-buster_armhf.deb \
      && sudo usermod pi -aG docker

    ## Setup daemon.
    cat <<'EOS' | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
  "max-size": "100m"
},
"storage-driver": "overlay2"
}
EOS
    sudo mkdir -p /etc/systemd/system/docker.service.d

    ## Restart docker.
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
      && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
      && sudo apt-get update -q \
      && sudo apt-get install -y kubelet kubeadm kubectl

    echo Add "cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1" to /boot/cmdline.txt
      #
    sudo shutdown -r +0
EOF
    ]
  }
}
