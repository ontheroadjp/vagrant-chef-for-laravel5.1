VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "nrel/CentOS-6.7-x86_64"
    config.vm.box_url = "https://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.7-x86_64-v20151108.box"
  
    # config.vm.box = "bento/centos-6.7"

    host = RbConfig::CONFIG['host_os']
    
    case host
        when /darwin/ # mac
            cpus = `sysctl -n hw.ncpu`.to_i
        when /linux/
            cpus = `nproc`.to_i
        else
            cpus = 2
    end
    
    provision_script = <<-EOH
        yum install -y git
    EOH

    config.vm.provider "virtualbox" do |vb|
        #vb.customize ["modifyvm", :id, "--cpus", cups]
        vb.customize ["modifyvm", :id, "--cpus", 3]
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        #vb.gui = true
    end

    # VMs
    config.vm.define :original do | original |
        original.vm.hostname = "centos"
        original.vm.network :forwarded_port, guest: 80, host: 8080
    	original.vm.network :private_network, ip: "192.168.33.10"
        original.vm.provision :shell, :inline => provision_script
    end
    config.vm.define :chef do | chef |
        chef.vm.hostname = "chef"
        chef.vm.network :forwarded_port, guest: 80, host: 8081
    	chef.vm.network :forwarded_port, guest: 3306, host: 3306
    	chef.vm.network :private_network, ip: "192.168.33.11"
    	chef.vm.synced_folder "html", "/usr/local/apache2/htdocs"
        chef.vm.provision :shell, :inline => provision_script
    end
end
