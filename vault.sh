#!/bin/bash

# Atualizando o sistema
echo "Atualizando o sistema..."
sudo apt update -y && sudo apt upgrade -y

# Instalando dependências
echo "Instalando dependências..."
sudo apt install -y curl sudo lsb-release apt-transport-https ca-certificates

# Instalando o Docker
echo "Instalando o Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalando o Docker Compose
echo "Instalando o Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Baixando e rodando o Vaultwarden com Docker
echo "Baixando o Vaultwarden com Docker..."
mkdir -p ~/vaultwarden
cd ~/vaultwarden

cat > docker-compose.yml <<EOL
version: "3"
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    volumes:
      - ./vw-data:/data
    ports:
      - 80:80
    environment:
      - ADMIN_TOKEN=admin.Vaultwarden-NeoDesk100
EOL

# Rodando o container
echo "Rodando o Vaultwarden..."
sudo docker-compose up -d

# Instruções finais
echo "Vaultwarden instalado e rodando com sucesso!"
echo "Para acessar a interface administrativa, use a URL: http://<IP_do_servidor>/admin"
echo "O token de administrador é: seu_token_de_admin_aqui"
echo "Se desejar configurar mais opções, edite o arquivo 'docker-compose.yml'"

