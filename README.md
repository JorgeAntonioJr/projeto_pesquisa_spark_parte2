# Projeto Prático: Ingestão de Dados para Data Lake (Camada Bronze)

## 📌 Sobre o projeto

Este repositório implementa um pipeline de dados em Python + Spark para extrair dados de uma base MySQL local, exportá-los em CSV e carregá-los em um Data Lake local em formato Delta usando MinIO.

A arquitetura utiliza a camada bronze do modelo medalhão, com foco em tabelas de alunos, professores, disciplinas, turmas e notas.

## 🛠️ Stack tecnológica

- Python 3.11
- PySpark 3.4.2
- Delta Lake 2.4.0
- MinIO (S3 compatível)
- MySQL 8.4
- Poetry
- Jupyter Lab

## 🗂️ Estrutura do repositório

- `docker-compose.yaml`: sobe os serviços de MySQL e MinIO.
- `db/init.sql`: schema e dados iniciais do banco MySQL.
- `export/export_to_csv.ipynb`: conecta ao MySQL, lê as tabelas e gera arquivos CSV na pasta `export/data/`.
- `ingestion/csv_to_delta.ipynb`: lê os CSVs e grava os dados no bucket `datalake` em formato Delta no MinIO.
- `pyproject.toml`: dependências do projeto e configuração do Poetry.
- `docs/`: documentação do projeto.

## ✅ Requisitos

Antes de iniciar, confirme que você possui instalados:

- Docker + Docker Compose
- Python 3.11
- Poetry
- Jupyter Lab

## 🚀 Fluxo correto de execução

### 1) Subir a infraestrutura local

Na raiz do projeto, execute:

```bash
docker compose up -d
```

Isso inicia:

- MySQL em `localhost:3306`
- MinIO em `localhost:9000` (API S3)
- Console do MinIO em `http://localhost:9001`

Credenciais do ambiente local:

- MySQL:
  - usuário: `admin`
  - senha: `admin`
  - banco: `app_db`
- MinIO:
  - usuário: `minioadmin`
  - senha: `miniopass`

### 2) Configurar o ambiente virtual com Poetry

No diretório do projeto:

```bash
poetry env use python3.11
poetry install
```

> Importante: o projeto não é um pacote Python a ser instalado como biblioteca, então o Poetry precisa ser configurado para não tentar empacotar o projeto.

### 3) Abrir o Jupyter para executar os notebooks

```bash
poetry run jupyter lab
```

A partir do Jupyter, abra primeiro o notebook:

- `export/export_to_csv.ipynb`

Execute todas as células. Esse notebook:

- conecta no MySQL em `127.0.0.1:3306`
- lê as tabelas do banco `app_db`
- cria arquivos CSV na pasta `export/data/`

As tabelas exportadas incluem:

- `classes.csv`
- `grades.csv`
- `students.csv`
- `subjects.csv`
- `teacher.csv`

### 4) Ingerir os CSVs para o Data Lake no formato Delta

Depois de gerar os arquivos no diretório `export/data/`, abra o notebook:

- `ingestion/csv_to_delta.ipynb`

Execute todas as células. O notebook:

- cria a SparkSession com suporte a Delta Lake e ao S3/MinIO
- lê os arquivos CSV locais
- grava os dados em `s3a://datalake/bronze/`

O bucket de destino é `datalake` e a carga é feita em caminhos como:

- `s3a://datalake/bronze/students`
- `s3a://datalake/bronze/subjects`
- `s3a://datalake/bronze/classes`
- `s3a://datalake/bronze/grades`
- `s3a://datalake/bronze/teacher`

### 5) Verificando os dados no MinIO

Após a execução do notebook de ingestão, acesse:

- `http://localhost:9001`

Faça login com:

- usuário: `minioadmin`
- senha: `miniopass`

No console, verifique o bucket `datalake` e a estrutura em `bronze/`.

## 🧹 Reinicialização limpa

Para resetar o ambiente local:

```bash
docker compose down -v
```

Isso remove os volumes do MySQL e do MinIO e recria a base e os buckets na próxima execução.

## 📌 Observações importantes

- O projeto depende de duas etapas sequenciais: exportação do banco para CSV e ingestão para Delta no MinIO.
- O README anterior não mencionava essa etapa de exportação do MySQL, o que fazia o fluxo parecer incompleto.
- O notebook de ingestão espera que os arquivos CSV estejam em `export/data/` antes da execução.
- O bucket `datalake` é o destino final da camada bronze.