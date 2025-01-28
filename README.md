## Prerequisites
- Have Docker and Docker Compose installed on your server: see <a href="https://docs.docker.com/engine/install/ubuntu/" target="_blank">https://docs.docker.com/engine/install/ubuntu/</a>

TL;DR; for ubuntu 24.04

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

# Install once
```
sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade
sudo useradd -s /bin/bash -d /home/onefinity -m -G sudo onefinity
echo 'onefinity ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/myOverrides

# Switch to the new user to continue the setup
sudo su onefinity
```



sudo docker run -v ${PWD}:/out -it mxpu mxpy wallet new --format pem --outfile /out/walletKey.pem
initial
  ./keygenerator  --num-keys 4 --no-split

