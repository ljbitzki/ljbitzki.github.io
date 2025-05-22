#!/bin/bash

function instalar_dependencias() {
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove $pkg -y;
  done
  sudo apt-get update
  sudo apt-get install ca-certificates curl rsync git wget -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
  instalar_ambiente
}

function instalar_ambiente() {
mkdir -p "/tmp/experimento-sf"
cd "/tmp/experimento-sf" || exit 1
echo -e '\e[33mClonando repositório do Netbox\e[0m'
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd "netbox-docker"
tee docker-compose.override.yml <<EOF
services:
  netbox:
    ports:
      - 8080:8080
EOF
echo -e '\e[33mBaixando imagens do Netbox\e[0m'
docker compose pull
echo -e '\e[33mIniciando componentes do Netbox\e[0m'
docker compose up -d
echo -e '\e[33mParando banco de dados do Netbox e copiando modelo pronto\e[0m'
docker stop netbox-docker-postgres-1
wget "https://github.com/ljbitzki/ljbitzki.github.io/raw/refs/heads/master/netbox-postgresql.tar.gz" -O netbox-postgresql.tar.gz
tar xzf netbox-postgresql.tar.gz
sudo rsync -Crazp var/lib/docker/volumes/netbox-docker_netbox-postgres-data/ /var/lib/docker/volumes/netbox-docker_netbox-postgres-data/
echo -e '\e[33mParando Netbox\e[0m'
docker compose down
echo -e '\e[33mIniciando Netbox com banco preparado\e[0m'
docker compose up -d
while [ "$( docker ps -a | grep 'netbox-docker-netbox-1' | grep -c 'healthy' )" -ne "1" ]; do
  docker compose up -d
  sleep 2
done 
echo -e '\e[33mBaixando contêiner e iniciando solução\e[0m'
docker run -d --network netbox-docker_default --name=net2d ljbitzki/sbseg2025-sf:net2d
echo -e '\e[33mBaixando contêiner e iniciando servidor nginx\e[0m'
docker run --cap-add=NET_ADMIN -d --network netbox-docker_default --name=ubuntu-server ljbitzki/sbseg2025-sf:server
echo -e '\e[33mBaixando contêiner e iniciando cliente\e[0m'
docker run -d --network netbox-docker_default --name=ubuntu-client ljbitzki/sbseg2025-sf:client
echo -e '\e[33mBaixando contêiner e iniciando Grafana\e[0m'
docker run -d --network netbox-docker_default --name=grafana -p 3000:3000 ljbitzki/sbseg2025-sf:grafana
echo -e '\e[33mBaixando contêiner e iniciando atacante\e[0m'
docker run -d --network netbox-docker_default --name=ubuntu-rogue ljbitzki/sbseg2025-sf:rogue
echo -e '\e[36m******************\e[0m'
echo -e '\e[36mAmbiente iniciado!\e[0m'
echo -e '\e[36m******************\e[0m'
}

if [ "$( which git rsync wget curl docker | wc -l )" -lt 5 ]; then
  echo "Deseja instalar dependencias? (s/n)"
  read RESP1
  if [ "${RESP1}" == 's' ]; then
    instalar_dependencias
  else
    exit 1
  fi
fi

instalar_ambiente
