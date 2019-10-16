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
      mkdir ~/.ssh
      chmod 700 ~/.ssh
      echo ${var.pub_key} >~/.ssh/authorized_keys
      chmod 600 ~/.ssh/authorized_keys
      echo 'pi:pi' | sudo chpasswd

      sudo sh -c 'echo -n "" > /etc/motd'

      sudo timedatectl set-timezone ${var.timezone}
      sudo timedatectl set-ntp true

      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt-get dist-upgrade -y
      sudo apt --fix-broken install -y
      sudo apt-get autoremove -y
      sudo apt-get autoclean

      sudo dphys-swapfile swapoff \
        && sudo dphys-swapfile uninstall \
        && sudo update-rc.d dphys-swapfile remove

      sudo systemctl disable bluetooth.service
      sudo systemctl disable hciuart.service

      curl -sSL get.docker.com | sh \
        && sudo usermod pi -aG docker

      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
        && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
        && sudo apt-get update -q \
        && sudo apt-get install -qy kubeadm

      echo Add "cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1" to /boot/cmdline.txt

      sudo shutdown -r +0
      EOF
    ]
  }
}
