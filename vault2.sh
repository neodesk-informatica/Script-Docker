#!/bin/bash

# Atualiza o sistema
echo "Atualizando o sistema..."
sudo apt-get update && sudo apt-get upgrade -y

# Instalar dependências
echo "Instalando dependências..."
sudo apt-get install -y curl gnupg2 lsb-release apt-transport-https

# Baixar o pacote Vaultwarden
echo "Baixando o Vaultwarden..."
curl -fsSL https://github.com/dani-garcia/vaultwarden/releases/download/v1.25.0/vaultwarden-server-v1.25.0-linux-x86_64.tar.gz -o vaultwarden.tar.gz

# Extrair o pacote
echo "Extraindo o pacote..."
tar -xzvf vaultwarden.tar.gz

# Mover os arquivos extraídos
echo "Movendo arquivos para o diretório adequado..."
sudo mv vaultwarden-server-v1.25.0-linux-x86_64 /opt/vaultwarden

# Configuração do systemd para iniciar o Vaultwarden como serviço
echo "Configurando o Vaultwarden como serviço..."
echo "[Unit]
Description=Vaultwarden
After=network.target

[Service]
ExecStart=/opt/vaultwarden/vaultwarden
WorkingDirectory=/opt/vaultwarden
User=nobody
Group=nogroup
Environment=DATABASE_URL=/opt/vaultwarden/db.sqlite3
Environment=ROCKET_PORT=80
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/vaultwarden.service

# Habilitar o serviço para iniciar automaticamente
echo "Habilitando o serviço Vaultwarden..."
sudo systemctl enable vaultwarden

# Iniciar o serviço
echo "Iniciando o serviço Vaultwarden..."
sudo systemctl start vaultwarden

# Verificar se o serviço está rodando
echo "Verificando o status do serviço..."
sudo systemctl status vaultwarden

# Configurar o token de administrador
echo "Configurando o token de administrador..."
sudo bash -c "echo -n 'admin_token' > /opt/vaultwarden/admin-token.txt"

# Configurar o email da Titan (supondo que você tenha as credenciais corretas)
# Aqui você pode definir as variáveis de configuração do Vaultwarden
echo "Configurando email da Titan..."
sudo bash -c "echo -e 'SMTP_HOST=smtp.titan.email\nSMTP_PORT=587\nSMTP_USER=seu-email@titan.email\nSMTP_PASSWORD=sua-senha\nSMTP_FROM=seu-email@titan.email' > /opt/vaultwarden/.env"

# Criação de um usuário administrador
echo "Criando usuário administrador..."
curl -X POST "http://localhost:80/api/accounts" \
  -H "Content-Type: application/json" \
  -d '{
        "email": "admin@titan.email",
        "password": "adminsenha",
        "is_admin": true
      }'

echo "Vaultwarden instalado e configurado com sucesso!"
