# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "debian/jessie64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 22, host: 2233

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "172.16.33.50"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

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

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
     #sudo echo "deb http://apt.include-once.org/ ./ #include-once.org" > /etc/apt/sources.list.d/xpm.list
     echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" | sudo tee /etc/apt/sources.list.d/jessie_backports.list
     #wget -q http://apt.include-once.org/public.gpg -O- | sudo apt-key add -
     sudo apt-get update
     sudo apt-get install -y ruby vim ruby-dev vim build-essential reprepro debian-builder dpkg-sig git
     sudo apt-get install -y python-pip python-dev libssl-dev qttools5-dev-tools openjdk-7-jdk qt5-default zlib1g-dev mercurial maven
     sudo gem install fpm
     gpg --allow-secret-key-import --import /vagrant/signing/7EE83BCF.asc
     #wget http://apt.include-once.org/xpm-1.3.3.6.gem -O /vagrant/xpm-1.3.3.6.gem
     #sudo gem install /vagrant/xpm-1.3.3.6.gem
     sudo pip install s3cmd
     sudo pip install html2text
     sudo apt-get install python-virtualenv
     sudo pip install virtualenv-tools
     sudo apt-get install openjdk-8-jdk
     sudo apt-get install cmake
     sudo apt-get install libffi-dev
     cp /vagrant/s3cfg ~/.s3cfg
     cat<<EOF >> ~/.profile
gpg-agent --daemon --enable-ssh-support \
--write-env-file "${HOME}/.gpg-agent-info"
if [ -f "${HOME}/.gpg-agent-info" ]; then
. "${HOME}/.gpg-agent-info"
export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export SSH_AGENT_PID
fi

GPG_TTY=$(tty)
export GPG_TTY
EOF
echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf  
# adding F-droidserver
sudo apt-get update
sudo apt-get install fdroidserver
sudo apt-get install openjdk-8-jdk lib32stdc++6 lib32gcc1 lib32z1 lib32ncurses5
sudo apt-get install gradle maven 
# android ndk and android sdk setup
# download sdk tools
# download platform tools and build tools
wget -q -O "/vagrant/google_tools/tools-linux.zip" https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
unzip /vagrant/google_tools/tools-linux.zip -d /vagrant/google_tools
rm -rf /vagrant/google_tools/tools-linux.zip
echo "PATH=\$PATH:/vagrant/google_tools/tools/:/vagrant/google_tools/tools/bin/
echo y | android update sdk --filter tools --no-ui --force -a
echo y | android update sdk --filter platform-tools --no-ui --force -a
echo y | android update sdk --filter build-tools-25.0.2 --no-ui --force -a
echo "PATH=\$PATH:/vagrant/google_tools/build-tools/25.0.2:/vagrant/google_tools/platform-tools/:/vagrant/google_tools/android-ndk/" >> ~/.bashrc
SHELL

  if Vagrant.has_plugin?("vagrant-cachier")
      # Configure cached packages to be shared between instances of the same base box.
      # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
      config.cache.scope = :box

      # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
      # NFS for shared folders. This is also very useful for vagrant-libvirt if you
      # want bi-directional sync
      config.cache.synced_folder_opts = {
        type: :nfs,
        # The nolock option can be useful for an NFSv3 client that wants to avoid the
        # NLM sideband protocol. Without this option, apt-get might hang if it tries
        # to lock files needed for /var/cache/* operations. All of this can be avoided
        # by using NFSv4 everywhere. Please note that the tcp option is not the default.
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    end


end
