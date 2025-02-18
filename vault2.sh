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
version: '3'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: always
    ports:
      - "80:80"
      - "3012:3012"
    volumes:
      - ./data:/data
    environment:
      - DOMAIN=https://vaultwarden.neodeskserver.com.br
      - SIGNUPS_ALLOWED=false
      - ADMIN_TOKEN=$(openssl rand -hex 32)
      - ADMIN_EMAIL=admin@neodeskinformatica.com.br
      - ADMIN_PASSWORD=M@ralhas95

EOL

# Rodando o container
echo "Rodando o Vaultwarden..."
sudo docker-compose up -d

# Criando o usuário administrador via API
echo "Criando usuário administrador..."

# Informações do novo usuário admin
USER_EMAIL="ian.maralhas@neodeskinformatica.com.br"
USER_PASSWORD="admin.Vaultwarden-NeoDesk100"

# URL do Vaultwarden (ajuste conforme necessário)
VAULTWARDEN_URL="https://vaultwarden.neodeskserver.com.br"

# Acessando a API para criar o usuário administrador
curl -X POST "$VAULTWARDEN_URL/api/accounts" \
  -H "Content-Type: application/json" \
  -d "{
        \"email\": \"$USER_EMAIL\",
        \"password\": \"$USER_PASSWORD\",
        \"is_admin\": true
      }"

# Instruções finais
echo "Vaultwarden instalado e rodando com sucesso!"
echo "Para acessar a interface administrativa, use a URL: http://<IP_do_servidor>/admin"
echo "O token de administrador é: admin.Vaultwarden-NeoDesk100"
echo "Se desejar configurar mais opções, edite o arquivo 'docker-compose.yml'"
