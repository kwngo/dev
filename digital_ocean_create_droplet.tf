variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}



provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Default"
  public_key = "${file(var.pub_key)}"
}

resource "digitalocean_droplet" "dev" {
  image  = "ubuntu-14-04-x64"
  name   = "dev"
  region = "nyc3"
  size   = "1gb"
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
      "export PATH=$PATH:/usr/bin"
    ]
  }
}
