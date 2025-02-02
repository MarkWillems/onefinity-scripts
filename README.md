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
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

# Install once
```
sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade
```


## get scripts
```
cd /opt
git clone https://github.com/MarkWillems/onefinity-scripts.git 
git clone https://github.com/buidly/onefinity-testnet-validators /opt/onefinity-validator-src
cd onefinity-validator-src 
./download.sh
```

## build containers
```
cd /opt/onefinity-scripts/
chmod 755 script.sh
 ./script.sh build

```

## command
# generate wallet
 sudo docker run --volume $PWD:/out mxpy:latest mxpy wallet new --format pem --outfile /out/walletKey.pem

## setup keys
export PATH=$PATH:/opt/onefinity-validator-src/onefinity-utils/
keygenerator --num-keys=6 --key-type=validator --no-split
mv validatorKey.pem allValidatorsKeys.pem
cat allValidatorsKeys.pem | awk -F'[ -]*' '/BEGIN/{print $(NF-1)}' > BLS_KEYS.txt
sed -i -e 's/^/      "/g' -e 's/$/",/g' BLS_KEYS.txt
cat BLS_KEY.txt

cat allValidatorsKeys.pem | awk '/BEGIN/,/END/{if (/BEGIN/) {a++}; out="validatorKey-"a".pem"; print>out;}'


# run manually
sudo docker run -it --volume $PWD:/home/ubuntu/working-dir onefinity:testnet

# termui 
docker exec -it onefinity-validator-1 ./termui  --address localhost:9501


