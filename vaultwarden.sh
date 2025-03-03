#!/bin/bash

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências
echo "Instalando Docker e Docker Compose..."
sudo apt install -y docker.io docker-compose

# Habilitar o Docker e iniciar o serviço
sudo systemctl enable docker
sudo systemctl start docker

# Instalar o Portainer
echo "Instalando o Portainer..."
sudo docker volume create portainer_data

# Criar e iniciar o container do Portainer
sudo docker run -d \
  -p 8000:8000 \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "Portainer instalado e rodando. Acesse via http://<SEU_IP>:9000"

# Instalar o Vaultwarden
echo "Instalando o Vaultwarden..."
sudo docker volume create vaultwarden_data

# Criar e iniciar o container do Vaultwarden com o admin token
sudo docker run -d \
  --name vaultwarden \
  --restart=always \
  -e WEBSOCKET_ENABLED=true \
  -e ADMIN_TOKEN=M@ralhas95 \
  -e ROCKET_PORT=8080 \
  -v vaultwarden_data:/data \
  -p 80:80 \
  vaultwarden/server:latest

echo "Vaultwarden instalado e rodando. Acesse via http://<SEU_IP>:80"

# Aguardar o container do Vaultwarden estar totalmente iniciado
echo "Aguardando o Vaultwarden iniciar completamente..."
sleep 10

# Criar o usuário admin no Vaultwarden (via API)
echo "Criando o usuário admin..."
curl -X POST "http://192.168.10.8:80/api/accounts/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ian.maralhas@neodeskinformatica.com.br",
    "password": "SZLADL Z3GDh",
    "admin": true
  }'

echo "Usuário admin criado com sucesso!"

# Finalizando a instalação
echo "Instalação completa! Acesse o Vaultwarden em http://<SEU_IP>:80"
echo "Portainer está disponível em http://<SEU_IP>:9000"
