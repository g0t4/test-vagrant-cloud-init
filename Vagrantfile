# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "wesdemos/ubuntu2404-arm"

  config.vm.box_check_update = false

  # docs:
  # - vagrant + cloud_init:
  #   config:   https://developer.hashicorp.com/vagrant/docs/cloud-init/configuration
  #   example:  https://developer.hashicorp.com/vagrant/docs/cloud-init/usage
  #   VirtualBox only?
  #   vagrant currently supports user_data type only (i.e. not vendor_data or meta_data)
  # - cloud-init examples: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
  #   - references: https://cloudinit.readthedocs.io/en/latest/reference/index.html

  # user_data part
  config.vm.cloud_init content_type: "text/cloud-config", path: "./parts/add-user.yaml"

  # script part
  config.vm.cloud_init content_type: "text/x-shellscript", path: "./parts/scripty.sh"

  # INLINE example (not preferred b/c no syntax highlighting, completion in nested code blocks - I wonder if any plugins support this within a ruby file heredoc?)
  # db.vm.cloud_init content_type: "text/cloud-config",
  # inline: <<-EOF
  #   #cloud-config
  #   package_update: true
  #   packages:
  #     - postgresql
  # EOF

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
