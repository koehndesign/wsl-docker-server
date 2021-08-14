#!/bin/bash
# install serverwp

cd ~

# set up docker repo
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install latest stable docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# install latest stable docker compose
compose_release() {
  curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep -Po '"tag_name": "\K.*?(?=")'
}
sudo curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

# manage docker as non root user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# allow docker to run without password
echo "$(whoami) ALL = (root) NOPASSWD: /usr/sbin/service docker *" | sudo tee /etc/sudoers.d/docker > /dev/null

# add WSL convenience scripts to user profile
cat << EOF >> .profile

# move to home directory since WSL drops into windows mount by default
cd ~

# start docker automatically since WSL doesn't support systemd
sudo service docker status || sudo service docker start

EOF

# start docker manually for the first time
sudo service docker start

echo "Install completed successfully!"
exit 0