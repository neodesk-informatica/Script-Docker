#!/bin/bash

# Atualiza o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências necessárias
echo "Instalando dependências..."
sudo apt install -y docker docker-compose curl

# Baixar a imagem do Vaultwarden (antes chamada Bitwarden_RS)
echo "Baixando e iniciando o Vaultwarden..."
mkdir -p ~/vaultwarden
cd ~/vaultwarden

# Criar o arquivo docker-compose.yml para o Vaultwarden
cat <<EOF > docker-compose.yml
version: '3'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      WEBSOCKET_ENABLED: "true"
      ADMIN_TOKEN: "YOUR_ADMIN_TOKEN"  # Token do admin a ser gerado
      SMTP_HOST: "smtp.titan.email"    # SMTP Titan
      SMTP_PORT: "587"
      SMTP_FROM: "youremail@titan.email"
      SMTP_USERNAME: "youremail@titan.email"
      SMTP_PASSWORD: "YOUR_TITAN_EMAIL_PASSWORD"
      SMTP_TLS: "true"
    volumes:
      - ./vw-data:/data
    ports:
      - 80:80
      - 443:443
    networks:
      - vaultwarden-net
networks:
  vaultwarden-net:
    driver: bridge
EOF

# Subir o Vaultwarden com Docker Compose
echo "Subindo o Vaultwarden com Docker Compose..."
sudo docker-compose up -d

# Criar token de administração
echo "Gerando o token de administração..."
ADMIN_TOKEN=$(openssl rand -base64 32)
sed -i "s/YOUR_ADMIN_TOKEN/$ADMIN_TOKEN/" ~/vaultwarden/docker-compose.yml

# Subir novamente após alterar o token de administração
echo "Subindo novamente o Vaultwarden após atualizar o token de admin..."
sudo docker-compose down
sudo docker-compose up -d

# Configurar o primeiro usuário admin via CLI
echo "Configurando o primeiro usuário admin..."
curl -X POST "http://localhost/api/admin" \
  -H "Content-Type: application/json" \
  -d '{
        "email": "admin@titan.email",
        "password": "YOUR_ADMIN_PASSWORD",
        "token": "'$ADMIN_TOKEN'"
      }'

echo "Vaultwarden configurado com sucesso!"

# Instrução de Acesso
echo "Acesse o Vaultwarden em http://<seu-ip-servidor>"
echo "Token de admin: $ADMIN_TOKEN"
