Vagrant.configure("2") do |config|
  # ubuntu 22.04
  config.vm.box = "ubuntu/jammy64"
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network "private_network", ip: "192.168.56.40"
  config.vm.hostname = "development.local"
  config.vm.boot_timeout = 1200

  # Vagrant folder
  config.vm.synced_folder "../local.vagrant/", "/var/www/local.vagrant", owner: "www-data"

  # Other folders
  Dir[File.dirname(__FILE__) + '/synced-folders/*.rb'].each {|file| eval File.read(file) }

  config.vm.provider "virtualbox" do |v|
    v.name = "development.local"
    v.memory = "2048"
    v.check_guest_additions = true
  end

  config.vm.provision :shell, path: "bootstrap.sh"
end
