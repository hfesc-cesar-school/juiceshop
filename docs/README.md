# Projeto SecureTasks — Jornada DevSecOps

## Resumo da Aplicação

Este projeto demonstra a implementação de práticas DevSecOps usando o **OWASP Juice Shop**, uma aplicação web intencionalmente vulnerável para treinamento em segurança. O repositório oferece uma solução completa que integra:

- **Desenvolvimento**: Build e testes automatizados da aplicação
- **Segurança**: Múltiplos scans de segurança (SAST, SCA, container scanning)
- **Operações**: Implantação em cluster Kubernetes local ou remoto
- **Automação**: Pipelines com GitHub Actions e comandos centralizados via justfile

A solução permite que desenvolvedores, profissionais de segurança e operações trabalhem de forma integrada, aplicando princípios "shift-left" para identificar vulnerabilidades no início do ciclo de desenvolvimento.

---

## ⚙ Pré-requisitos Detalhados

| Ferramenta | Versão mínima | Finalidade | Instruções de Instalação |
|------------|---------------|------------|--------------------------|
| **Docker Engine** | 20.10+ | Containers & ambiente para kind | [Instalação Docker](https://docs.docker.com/engine/install/) |
| **kind** | 0.27+ | Cluster Kubernetes local | [Instalação kind](https://kind.sigs.k8s.io/docs/user/quick-start/) |
| **just** | 1.25+ | Executor de comandos/receitas | [Instalação just](https://github.com/casey/just#installation) |
| **Node.js** | 18 LTS | Build & testes da aplicação | [Instalação Node.js](https://nodejs.org/en/download/) |
| **kubectl** | 1.29+ | Gerenciamento do cluster K8s | [Instalação kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) |
| **nektos/act** (opcional) | 0.2.60+ | Execução local de GitHub Actions | [Instalação act](https://github.com/nektos/act#installation) |

### Verificação do Ambiente

Para verificar se seu ambiente está corretamente configurado, execute:

```bash
# Verificar versões instaladas
docker --version
kind --version
just --version
node --version
kubectl version --client

# Configuração inicial do projeto
just setup
```

---

## 🚀 Tutorial: Usando o justfile

O arquivo `.justfile` centraliza todos os comandos necessários para trabalhar com o projeto. Abaixo estão as principais operações:

### 1. Criando e Gerenciando o Cluster Kubernetes Local

```bash
# Criar um novo cluster Kubernetes com 1 nó master e 2 workers
just deploy-kind-cluster

# Iniciar um cluster existente (após reiniciar o computador)
just start-kind-cluster

# Parar o cluster (sem excluí-lo)
just stop-kind-cluster

# Destruir completamente o cluster
just destroy-kind-cluster
```

### 2. Executando a Aplicação

```bash
# Construir e iniciar a aplicação em containers Docker
just start

# Parar a aplicação
just stop

# Construir apenas a imagem Docker
just build
```

### 3. Executando GitHub Actions Localmente

Se você não possui GitHub Pro (necessário para Actions em repositórios privados), pode executar os workflows localmente:

```bash
# Instalar o act (se ainda não instalou)
brew install act  # macOS
# ou
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash  # Linux

# Executar o workflow de CI completo localmente
act -j build-test
act -j security

# Executar workflows específicos de segurança
act -W .github/workflows/dependency-check.yml
act -W .github/workflows/retirejs.yml
```


## 📊 Entendendo os Workflows de CI/CD

O projeto utiliza três workflows principais no GitHub Actions:

1. **Build-Test-Security CI**: Compila o código, executa testes e realiza análises de segurança com CodeQL, npm audit e Trivy.

2. **OWASP Dependency-Check**: Analisa as dependências do projeto em busca de vulnerabilidades conhecidas.

3. **OWASP Retire.js**: Verifica bibliotecas JavaScript obsoletas com vulnerabilidades conhecidas.

Todos os relatórios de segurança são disponibilizados como artefatos nas execuções dos workflows, permitindo análise detalhada das vulnerabilidades encontradas.
