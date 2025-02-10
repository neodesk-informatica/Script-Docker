# Script de Instalação do Docker e Docker Compose no Ubuntu Server

Este repositório contém um script para instalar automaticamente o **Docker** e o **Docker Compose** em sistemas **Ubuntu Server**. O script é ideal para quem precisa configurar rapidamente o Docker em servidores Ubuntu sem complicação.

## Requisitos

- Sistema **Ubuntu Server** (versão 18.04 ou superior)
- Acesso a um terminal com permissões de superusuário (`sudo`)

## Funcionalidade

O script realiza as seguintes tarefas automaticamente:

- Instala o **Docker CE** (Community Edition)
- Instala o **Docker Compose**
- Adiciona o usuário atual ao grupo `docker` para permitir a execução de comandos Docker sem `sudo`
- Inicia e configura o Docker para ser executado automaticamente com o sistema

## Como Usar

### 1. Clonando o Repositório

Clone este repositório para o seu servidor Ubuntu:

```bash
git clone https://github.com/SEU_USUARIO/nome-do-repositorio.git
cd nome-do-repositorio

### 2. Tornando o Script Executável
chmod +x install-docker.sh

### 3. Executando o Script
sudo ./install-docker.sh

### 4. Verificando a Instalação
docker --version
docker-compose --version

### 5. Testando o Docker
docker run hello-world
