# -*- mode: ruby -*-
# vi: set ft=ruby :

######################################################################
# WARNING: You will need the following plugin:
######################################################################
# vagrant plugin install vagrant-docker-compose
if Vagrant.plugins_enabled?
  unless Vagrant.has_plugin?('vagrant-docker-compose')
    puts 'Plugin missing.'
    system('vagrant plugin install vagrant-docker-compose')
    puts 'Dependencies installed, please try the command again.'
    exit
  end
end

######################################################################
# AWS EKS dev Environment
######################################################################
Vagrant.configure(2) do |config|
  # config.vm.box = "ubuntu/bionic64"
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.hostname = "kubernetes"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5000, host: 5000, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Mac users can comment this next line out but
  # Windows users need to change the permission of files and directories
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=755,fmode=644"]

  ############################################################
  # Configure Vagrant to use VirtualBox:
  ############################################################
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2

    # Fixes some DNS issues on some networks
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  ############################################################
  # Copy some host files to configure VM like the host
  ############################################################

  # Copy your .gitconfig file so that your git credentials are correct
  if File.exists?(File.expand_path("~/.gitconfig"))
    config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"
  end

  # Copy your ssh keys for github so that your git credentials work
  if File.exists?(File.expand_path("~/.ssh/id_rsa"))
    config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
  end
  if File.exists?(File.expand_path("~/.ssh/id_rsa.pub"))
    config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
  end

  # Copy your .vimrc file so that your VI editor looks right
  if File.exists?(File.expand_path("~/.vimrc"))
    config.vm.provision "file", source: "~/.vimrc", destination: "~/.vimrc"
  end

  # # Copy your IBM Cloud API Key if you have one
  # if File.exists?(File.expand_path("~/.bluemix/apiKey.json"))
  #   config.vm.provision "file", source: "~/.bluemix/apiKey.json", destination: "~/.bluemix/apiKey.json"
  # end

  ############################################################
  # Install common libraries
  ############################################################
  config.vm.provision "shell", inline: <<-SHELL
    # Update and install common packages
    apt-get update && sudo apt-get install -y unzip git tree wget jq gettext bash-completion moreutils
  SHELL

  ############################################################
  # Create a Python 3 environment for development work
  ############################################################
  config.vm.provision "shell", inline: <<-SHELL
    # Install
    apt-get update && apt-get install -y build-essential python3-dev python3-pip python3-venv apt-transport-https
    apt-get upgrade python3
    # Check versions to prove that everything is installed
    python3 --version
    # # Create a Python3 Virtual Environment and Activate it in .profile
    # sudo -H -u vagrant sh -c 'python3 -m venv ~/venv'
    # sudo -H -u vagrant sh -c 'echo ". ~/venv/bin/activate" >> ~/.profile'
    # sudo -H -u vagrant sh -c '. ~/venv/bin/activate && pip install -U pip && pip install wheel && cd /vagrant && pip install -r requirements.txt'
  SHELL

  ############################################################
  # Provision Docker with Vagrant before starting kubernetes
  ############################################################
  config.vm.provision "docker" do |d|
    d.pull_images "alpine"
    d.pull_images "python:3.8-slim"
    d.pull_images "redis:6-alpine"
    d.run "redis:6-alpine",
      args: "--restart=always -d --name redis -p 6379:6379 -v redis:/data"
  end

  ############################################################
  # Add Docker compose
  ############################################################
  config.vm.provision :docker_compose
  # config.vm.provision :docker_compose,
  #   yml: "/vagrant/docker-compose.yml",
  #   rebuild: true,
  #   run: "always"

  ############################################################
  # Create a Kubernetes Cluster
  ############################################################
  config.vm.provision "shell", inline: <<-SHELL

    # install Kubernetes CLI (kubectl)
    # curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    # chmod +x ./kubectl
    # mv ./kubectl /usr/local/bin/kubectl
    apt-get update && sudo apt-get install -y apt-transport-https gnupg2
    if test -f "/usr/bin/kubectl"; then
      echo "kubectl already installed."
    else 
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
      apt-get update
      apt-get install -y kubectl
      echo "alias kc=\"/usr/bin/kubectl\"" >> /home/vagrant/.bash_aliases
    fi

    # Enable kubectl bash_completion for user=vagrant
    kubectl completion bash >>  /home/vagrant/.bash_completion
    . /etc/profile.d/bash_completion.sh
    . /home/vagrant/.bash_completion

    # # install MicroK8s version of Kubernetes
    # snap install microk8s --classic
    # microk8s.status --wait-ready
    # microk8s.enable dns
    # microk8s.enable dashboard
    # microk8s.enable registry
    # microk8s.enable ingress

    # #snap alias microk8s.kubectl kubectl
    # usermod -a -G microk8s vagrant

    # # Create aliases for microk8s=mk and kubecl=kc
    # echo "alias mk='/snap/bin/microk8s'" >> /home/vagrant/.bash_aliases
    # #echo "alias kc='/snap/bin/kubectl'" >> /home/vagrant/.bash_aliases
    chown vagrant:vagrant /home/vagrant/.bash_aliases

    # # Set up Kubernetes context
    # sudo -H -u vagrant sh -c 'mkdir ~/.kube && microk8s.kubectl config view --raw > ~/.kube/config'
    # kubectl version --short  
    # microk8s.config > /home/vagrant/.kube/config
    # chown vagrant:vagrant /home/vagrant/.kube/config
    # chmod 600 /home/vagrant/.kube/config
  SHELL

  ######################################################################
  # Setup an AWS and Kubernetes environment
  ######################################################################
  config.vm.provision "shell", inline: <<-SHELL
    echo "\n************************************"
    echo " Installing AWS CLI..."
    echo "************************************\n"

    # Install AWS CLI
    apt-get update && sudo apt-get install -y glibc groff less  
    if test -f "./aws/install"; then
      echo "aws already installed."
    else 
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null
      unzip awscliv2.zip > /dev/null
      sudo ./aws/install
    fi
    aws --version

    # NOTE: set the AWS config here
    export AWS_PROFILE_PATH=/vagrant/cloudmr_AWS_admin.csv
    export AWS_KEY_ALIAS=cloudmrMode1
    export AWS_PROFILE=admin
    export AWS_REGION=us-east-2
    export AWS_ACCOUNT_ID=373619751787
    # config AWS environment as Provisioner
    sudo aws configure import --csv file://${AWS_PROFILE_PATH}
    aws configure set region $AWS_REGION --profile $AWS_PROFILE
    aws configure get ${AWS_PROFILE}.region

    # # setup ssh key, This will be used on the worker node instances to allow ssh access.
    # # TODO: This is probably still required for each environment? Maybe better do this manaully.
    # if test -f /home/vagrant/.ssh/id_rsa; then
    #   echo "ssh key already exist."
    # else 
    #   ssh-keygen -t rsa -N '' -f /home/vagrant/.ssh/id_rsa <<< y
    # fi
    # # aws ec2 import-key-pair --key-name "$UNIQNAME_EACH_ENV" --public-key-material file://~/.ssh/id_rsa.pub
    # # If you got an error similar to An error occurred (InvalidKey.Format) when calling the ImportKeyPair operation: Key is not in valid OpenSSH public key format then you can try this command instead:
    # aws ec2 import-key-pair --key-name "$UNIQNAME_EACH_ENV" --public-key-material fileb:///home/vagrant/.ssh/id_rsa.pub

    # Create a CMK for the EKS cluster to use when encrypting your Kubernetes secrets
    if test "$(aws kms describe-key --key-id alias/$AWS_KEY_ALIAS)"; then 
      echo "CMK key exist."
      aws kms describe-key --key-id alias/$AWS_KEY_ALIAS > key.json 
      if [ $(cat key.json | jq .[] | jq ."Enabled") = true ]; then 
        echo "CMK key is enabled." 
      else 
        echo "CMK key is not enabled. Create a new one." 
        aws kms create-alias --alias-name alias/${AWS_KEY_ALIAS}new --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)
        export AWS_KEY_ALIAS=${AWS_KEY_ALIAS}new
      fi
    else 
      echo "CMK key not found. Create a new one." 
      aws kms create-alias --alias-name alias/$AWS_KEY_ALIAS --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)
    fi
    export MASTER_ARN=$(aws kms describe-key --key-id alias/$AWS_KEY_ALIAS --query KeyMetadata.Arn --output text)

    # Install eksctl
    if test -f "/usr/local/bin"; then
      echo "eksctl key already installed."
    else 
      curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
      sudo mv -v /tmp/eksctl /usr/local/bin

      eksctl completion bash >> /home/vagrant/.bash_completion
      . /etc/profile.d/bash_completion.sh
      . /home/vagrant/.bash_completion
    fi
    eksctl version
    
    echo "\n"
    echo "\n************************************"
    echo " For the Kubernetes Dashboard use:"
    echo " kubectl proxy --address='0.0.0.0'"
    echo "************************************\n"

    # Check the packages 
    for command in kubectl aws eksctl jq envsubst 
      do
        which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
      done
      
    # config AWS environment as user=vagrant
    # TODO: refactor the AWS config with environment variable
    # https://stackoverflow.com/questions/40270391/shell-environment-variables-in-vagrant-files-are-only-passed-on-first-up
    sudo -H -u vagrant sh -c "aws configure import --csv file://${AWS_PROFILE_PATH}"
    echo "export AWS_PROFILE=$AWS_PROFILE" >> /home/vagrant/.bash_profile
    echo "export AWS_REGION=$AWS_REGION" >> /home/vagrant/.bash_profile
    sudo -H -u vagrant sh -c "aws configure set region $AWS_REGION --profile $AWS_PROFILE"
    sudo -H -u vagrant sh -c "aws configure get ${AWS_PROFILE}.region"
    echo "export MASTER_ARN=$MASTER_ARN" >> /home/vagrant/.bash_profile
    echo "export AWS_KEY_ALIAS=$AWS_KEY_ALIAS" >> /home/vagrant/.bash_profile
    echo "export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID" >> /home/vagrant/.bash_profile
    
    # set the AWS Load Balancer Controller version
    echo "export LBC_VERSION='v2.0.0'" >> /home/vagrant/.bash_profile
    sudo -H -u vagrant sh -c ". /home/vagrant/.bash_profile"

  SHELL

  # ######################################################################
  # # Setup an IBM Cloud and Kubernetes environment
  # ######################################################################
  # config.vm.provision "shell", inline: <<-SHELL
  #   echo "\n************************************"
  #   echo " Installing IBM Cloud CLI..."
  #   echo "************************************\n"
  #   # Install IBM Cloud CLI as Vagrant user
  #   sudo -H -u vagrant sh -c 'curl -sL http://ibm.biz/idt-installer | bash'
  #   sudo -H -u vagrant sh -c 'ibmcloud config --usage-stats-collect false'
  #   sudo -H -u vagrant sh -c "echo 'source <(kubectl completion bash)' >> ~/.bashrc"
  #   sudo -H -u vagrant sh -c "echo alias ic=/usr/local/bin/ibmcloud >> ~/.bash_aliases"
  #   echo "\n"
  #   echo "\n************************************"
  #   echo " For the Kubernetes Dashboard use:"
  #   echo " kubectl proxy --address='0.0.0.0'"
  #   echo "************************************\n"
  #   # Prove that plug-ins are installed as vagrant user
  #   sudo -H -u vagrant bash -c "bx plugin list"
  # SHELL

end
