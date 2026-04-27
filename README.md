# 🧠 NeuroCare - Plataforma de Acompanhamento Neurológico

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

O **NeuroCare** é uma aplicação Full-Stack desenvolvida para facilitar a comunicação e o acompanhamento diário entre pacientes neurológicos e seus cuidadores. O sistema permite o gerenciamento de rotinas, acompanhamento de tarefas e garante que os cuidadores tenham visibilidade do bem-estar dos usuários.

## 📌 Funcionalidades Principais
O aplicativo possui interfaces e lógicas distintas dependendo do perfil autenticado:

* **Sistema de Perfis:** Login e registro segregados para **Usuários** (pacientes) e **Cuidadores**.
* **Painel do Usuário (`home_usuario_screen`):** Interface focada acessibilidade para visualização de tarefas diárias e rotinas.
* **Painel do Cuidador (`home_cuidador_screen`):** Área de gestão onde o cuidador pode monitorar o andamento das atividades e configurar rotinas.
* **Autenticação Segura:** Proteção de rotas e sessões integradas com a API.
* **API RESTful:** Back-end robusto que centraliza as regras de negócio, dados de usuários e listagem de rotinas.

## 🛠️ Arquitetura e Tecnologias
Este repositório contém tanto o aplicativo móvel quanto o servidor back-end:

**Front-end (Mobile):**
- **Framework:** Flutter
- **Linguagem:** Dart
- **Integração:** Consumo de API REST via `api_service.dart`.

**Back-end (API):**
- **Linguagem:** Python
- **Framework:** Microframework para construção de APIs (`app.py`, `rotinas.py`, `usuario_routes.py`).
- **Banco de Dados:** SQLite (`instance/neuroapp.db`).

## 🚀 Como executar o projeto localmente

Para rodar este projeto de forma completa, você precisará iniciar o Back-end e o Front-end em terminais separados.

### 1. Configurando o Back-end (Python)
1. Certifique-se de ter o Python instalado.
2. Navegue até a pasta raiz do projeto.
3. Crie um ambiente virtual (opcional, mas recomendado) e instale as dependências:
   ```bash
   pip install -r requirements.txt
   
( atualmente em desenvolvimento)

## 👤 Autor
**Luiz Henrique da Silva Pereira**
*Estudante de ADS - Uninassau | Desenvolvedor Full-Stack*

[![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/luiz-henrique-da-silva-pereira-574620398)
[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/luiz-rick)
[![Instagram](https://img.shields.io/badge/instagram-%23E4405F.svg?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/_rikjk_/)
