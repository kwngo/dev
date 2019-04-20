provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Default"
  public_key = "${file(var.pub_key)}"
}

resource "digitalocean_droplet" "dev" {
  image  = "docker-18-04"
  name   = "dev"
  region = "nyc3"
  size   = "1gb"
  ipv6 = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.fingerprint}"
  ]

  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "adduser --quiet --shell /bin/bash --home /home/kwngo -p $(openssl passwd -crypt testpass) kwngo",
      "usermod -aG docker kwngo",
      "echo 'kwngo:testpass'"
    ]
  }
}
