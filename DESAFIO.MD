
# Desafio DevOps: Visualiza 🚀

Bem-vindo ao Desafio da Visualiza\! Sua missão é construir uma aplicação Python a partir de um conjunto de requisitos, prepará-la para produção com as melhores práticas de containerização e, por fim, automatizar seu processo de integração contínua (CI).

Este desafio testa suas habilidades de ponta a ponta, desde a criação de uma API funcional até a automação de seu empacotamento.

## Índice

  * [Sobre a Aplicação que Você Irá Construir](https://www.google.com/search?q=%23sobre-a-aplica%C3%A7%C3%A3o-que-voc%C3%AA-ir%C3%A1-construir)
  * [Visão Geral do Desafio](https://www.google.com/search?q=%23vis%C3%A3o-geral-do-desafio)
  * [Fase 1: Construção e Execução da Aplicação Local](https://www.google.com/search?q=%23fase-1-constru%C3%A7%C3%A3o-e-execu%C3%A7%C3%A3o-da-aplica%C3%A7%C3%A3o-local)
  * [Fase 2: Containerização com Docker](https://www.google.com/search?q=%23fase-2-containeriza%C3%A7%C3%A3o-com-docker)
  * [Fase 3: Gerenciamento Local com Docker Compose](https://www.google.com/search?q=%23fase-3-gerenciamento-local-com-docker-compose)
  * [Fase 4: CI - Integração Contínua com GitHub Actions](https://www.google.com/search?q=%23fase-4-ci---integra%C3%A7%C3%A3o-cont%C3%ADnua-com-github-actions)
  * [O que será Avaliado?](https://www.google.com/search?q=%23o-que-ser%C3%A1-avaliado)
  * [Dicas e Recursos Úteis](https://www.google.com/search?q=%23dicas-e-recursos-%C3%BAteis)

## Sobre a Aplicação que Você Irá Construir

Sua primeira tarefa será criar um microserviço chamado **Visualiza**, utilizando **Python** e o framework **FastAPI**.

  * **Funcionalidade Principal:** A API deverá expor um endpoint que busca e retorna os metadados da "Imagem Astronômica do Dia" (APOD) da API pública da NASA.
  * **Endpoints Requeridos:**
      * `GET /apod`: Retorna os dados da imagem do dia.
      * `GET /health`: Um endpoint simples de health check.
      * `GET /`: Um endpoint raiz com uma mensagem de boas-vindas.

## Visão Geral do Desafio

O objetivo é executar um ciclo de desenvolvimento completo, passando por 4 estágios:

1.  **Construção da Aplicação:** Escrever o código da API em Python com base nas especificações.
2.  **Containerização:** Criar uma imagem Docker da aplicação.
3.  **Gerenciamento com Docker Compose:** Padronizar a execução do ambiente de desenvolvimento.
4.  **Automação com CI:** Criar um pipeline que automaticamente testa e publica a imagem Docker.

-----

## Fase 1: Construção e Execução da Aplicação Local

Antes de pensar em Docker, você deve construir e validar a aplicação em sua máquina.

### Pré-requisitos

  * [Python 3.9+](https://www.python.org/downloads/)

### Suas Tarefas

1.  **Crie a Estrutura do Projeto:**
    Organize seus arquivos na seguinte estrutura:

    ```
    visualiza-challenge/
    ├── .github/
    │   └── workflows/
    ├── src/
    │   ├── __init__.py      # Arquivo vazio para o módulo
    │   └── main.py          # Onde seu código FastAPI irá viver
    ├── .env
    ├── .gitignore
    ├── Dockerfile
    ├── docker-compose.yml
    ├── README.md
    └── requirements.txt
    ```

2.  **Desenvolva a Aplicação (`src/main.py`):**
    Crie uma aplicação FastAPI que atenda às seguintes **especificações**:

      * ✅ Utilize o framework `FastAPI`.
      * ✅ Use a biblioteca `python-dotenv` para carregar variáveis de ambiente de um arquivo `.env`.
      * ✅ Implemente um endpoint `GET /` que retorne um JSON simples como: `{"message": "Bem-vindo à Visualiza API!"}`.
      * ✅ Implemente um endpoint `GET /health` que retorne um JSON com `{"status": "ok"}` e status code 200.
      * ✅ Implemente um endpoint `GET /apod` que seja `async` e:
          * Utilize a biblioteca `httpx` para fazer uma requisição à API da NASA (`https://api.nasa.gov/planetary/apod`).
          * Leia uma variável de ambiente `NASA_API_KEY` e a envie como parâmetro na requisição.
          * Em caso de sucesso, retorne o JSON recebido da API da NASA.
          * **Implemente tratamento de erros:** Se a API da NASA retornar um erro (ex: 4xx, 5xx) ou se houver um erro de conexão, sua API deve retornar uma `HTTPException` do FastAPI com o status code e detalhes apropriados.

3.  **Liste as Dependências (`requirements.txt`):**
    Seu arquivo `requirements.txt` deve conter todas as bibliotecas necessárias para rodar a aplicação. Isso inclui, no mínimo, `fastapi`, `uvicorn`, `httpx` e `python-dotenv`.

4.  **Configure as Variáveis de Ambiente (`.env`):**
    Crie o arquivo `.env` e adicione sua chave da API da NASA. Você pode obter uma em [api.nasa.gov](https://api.nasa.gov/).

    ```ini
    NASA_API_KEY=SUA_CHAVE_API_AQUI
    ```

5.  **Instale e Valide sua Aplicação:**
    Execute os seguintes comandos no terminal para testar o código que você escreveu:

    ```bash
    # Crie e ative um ambiente virtual
    python -m venv .venv
    source .venv/bin/activate

    # Instale as dependências que você listou
    pip install -r requirements.txt

    # Execute a aplicação
    uvicorn src.main:app --reload
    ```

    Acesse [**http://localhost:8000/docs**](https://www.google.com/search?q=http://localhost:8000/docs) e teste todos os endpoints para garantir que eles se comportam conforme as especificações.

-----

## Fase 2: Containerização com Docker

Agora que sua aplicação funciona localmente, empacote-a em uma imagem Docker.

**✅ Requisitos:**

  * Crie um `Dockerfile` na raiz do projeto.
  * Utilize uma imagem base oficial e leve do Python (ex: `python:3.9-slim-bullseye`).
  * Aplique a técnica de **multi-stage build** para uma imagem final otimizada.
  * Garanta que a aplicação seja executada por um **usuário não-root** dentro do contêiner.
  * Otimize a ordem dos comandos para aproveitar o **cache de camadas** do Docker.

## Fase 3: Gerenciamento Local com Docker Compose

Use o Docker Compose para simplificar e padronizar a execução do seu contêiner.

**✅ Requisitos:**

  * Crie um arquivo `docker-compose.yml`.
  * Defina um único serviço, `api`, que será construído a partir do seu `Dockerfile`.
  * Mapeie a porta 8000 do contêiner para a porta 8000 da sua máquina.
  * Configure o serviço para carregar as variáveis de ambiente do arquivo `.env` automaticamente.
  * O comando `docker-compose up --build` deve ser suficiente para iniciar a aplicação.

## Fase 4: CI - Integração Contínua com GitHub Actions

Crie um pipeline para automatizar o build e o push da sua imagem Docker.

**✅ Requisitos:**

  * Crie um workflow em `.github/workflows/main.yml` que seja acionado a cada `push` na branch `main`.
  * O workflow deve:
    1.  Fazer o checkout do código.
    2.  Fazer login de forma segura em um registro de contêineres (**Docker Hub** ou **GitHub Container Registry**), usando *GitHub Secrets* para as credenciais.
    3.  Construir e fazer o push da imagem Docker para o registro, utilizando ao menos duas tags: `latest` e o identificador do commit (SHA).

## O que será Avaliado?

  * **Qualidade do Código Python:** A aplicação atende a todas as especificações? É bem estruturada e inclui tratamento de erros robusto?
  * **Qualidade do Código DevOps:** Clareza, eficiência e segurança do `Dockerfile`, `docker-compose.yml` e do workflow do GitHub Actions.
  * **Melhores Práticas:** Uso de multi-stage builds, usuários não-root, otimização de cache, gerenciamento de segredos, etc.
  * **Funcionalidade:** A solução final funciona de ponta a ponta como descrito?
  * **Documentação:** A clareza das suas mensagens de commit e comentários que você adicionar ao `README.md` para explicar suas decisões.

## Dicas e Recursos Úteis

  * **Documentação do FastAPI:** [https://fastapi.tiangolo.com/](https://fastapi.tiangolo.com/)
  * **Documentação do HTTPX:** [https://www.python-httpx.org/](https://www.python-httpx.org/)
  * **Melhores Práticas para Dockerfile:** [Docker Docs - Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
  * **Documentação do Docker Compose:** [Docker Docs - Compose overview](https://docs.docker.com/compose/)
  * **Documentação do GitHub Actions:** [GitHub Docs - Actions](https://docs.github.com/pt/actions)

Boa sorte\! ✨