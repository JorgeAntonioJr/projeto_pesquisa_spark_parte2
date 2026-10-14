# Projeto Prático: Ingestão de Dados para Data Lake (Camada Bronze)

## Visão geral

Este repositório implementa um pipeline de dados em Python + Spark para:

- extrair dados de um banco MySQL local
- exportá-los para CSV
- carregar os arquivos em um Data Lake local usando MinIO
- gravar os dados em formato Delta Lake na camada Bronze

A arquitetura segue o modelo medalhão, com foco em tabelas de alunos, professores, disciplinas, turmas e notas.

## Stack tecnológica

- Python 3.11
- PySpark 3.4.2
- Delta Lake 2.4.0
- MinIO (compatível com S3)
- MySQL 8.4
- Poetry
- Jupyter Lab

## Estrutura do repositório

- `docker-compose.yaml`: sobe os serviços de MySQL e MinIO
- `db/init.sql`: schema e dados iniciais do banco MySQL
- `export/export_to_csv.ipynb`: exporta as tabelas do MySQL para CSV
- `export/data/`: arquivos CSV exportados
- `ingestion/csv_to_delta.ipynb`: lê os CSVs e grava os dados em Delta no MinIO
- `ingestion/dml_delta.ipynb`: demonstra operações DML (`INSERT`, `UPDATE`, `DELETE`) em tabelas Delta
- `pyproject.toml`: dependências do projeto e configuração do Poetry
- `docs/`: documentação do projeto

## Requisitos

Antes de iniciar, confirme que você possui instalado:

- Docker + Docker Compose
- Python 3.11
- Poetry
- Jupyter Lab

## Fluxo correto de execução

### 1) Subir a infraestrutura local

Na raiz do projeto, execute:

```bash
docker compose up -d
```

Isso inicia:

- MySQL em `localhost:3306`
- MinIO em `localhost:9000`
- Console do MinIO em `http://localhost:9001`

Credenciais locais:

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

Se o `poetry.lock` estiver desatualizado, execute:

```bash
poetry lock
poetry install
```

### 3) Exportar os dados do MySQL para CSV

Abra o notebook:

- `export/export_to_csv.ipynb`

Execute todas as células. Esse notebook:

- conecta no MySQL em `127.0.0.1:3306`
- lê as tabelas do banco `app_db`
- gera os arquivos CSV em `export/data/`

Arquivos esperados:

- `classes.csv`
- `grades.csv`
- `students.csv`
- `subjects.csv`
- `teacher.csv`

### 4) Criar o bucket e carregar os dados para o Delta Lake

Depois de exportar os CSVs, abra o notebook:

- `ingestion/csv_to_delta.ipynb`

As configurações do notebook já usam:

- `MINIO_ENDPOINT = http://127.0.0.1:9000`
- `MINIO_ACCESS_KEY = minioadmin`
- `MINIO_SECRET_KEY = miniopass`
- bucket de destino: `datalake`

O notebook grava os dados em caminhos como:

- `s3a://datalake/bronze/students`
- `s3a://datalake/bronze/subjects`
- `s3a://datalake/bronze/classes`
- `s3a://datalake/bronze/grades`
- `s3a://datalake/bronze/teacher`

### 5) Demonstrar DML no Delta Lake

Abra o notebook:

- `ingestion/dml_delta.ipynb`

Esse notebook implementa as operações:

- `INSERT`
- `UPDATE`
- `DELETE`
- `history()` para auditoria do Delta Lake

A estrutura alvo é a tabela `students`, em:

```text
s3a://datalake/bronze/students
```

### 6) Verificar os dados no MinIO

Acesse o console do MinIO em:

- `http://localhost:9001`

Credenciais:

- usuário: `minioadmin`
- senha: `miniopass`

No console, verifique o bucket `datalake` e a estrutura da camada `bronze/`.

## Observações importantes

- O fluxo funciona em duas etapas sequenciais: exportação do MySQL para CSV e ingestão para Delta no MinIO.
- O bucket `datalake` precisa existir antes da gravação Delta.
- A versão do pacote Delta no Spark deve ser compatível com a versão do Spark usada no projeto.
- O pacote correto usado na sessão Spark é:

```python
io.delta:delta-core_2.12:2.4.0
```

e não o nome `delta-spark_2.12`, que gerava resolução de dependência incorreta.

## Reinicialização limpa

Para limpar tudo e recriar os volumes locais:

```bash
docker compose down -v
```

Isso remove o banco MySQL e os dados do MinIO.

## Troubleshooting

### Docker não sobe

Verifique se o daemon do Docker está funcionando e se o usuário tem permissão para acessá-lo.

### MinIO não responde

Confirme se o container do MinIO está em estado `Up`:

```bash
docker compose ps
```

### Erro de dependência do Delta

Se a sessão Spark falhar ao resolver o pacote do Delta, verifique se a configuração usa o artefato correto:

```python
"io.delta:delta-core_2.12:2.4.0"
```

### Bucket não encontrado

Antes de escrever em Delta, confirme que o bucket `datalake` foi criado no MinIO.

## Resultado esperado

Ao final do fluxo, o projeto deve:

- exportar os dados do MySQL para CSV
- carregar os dados no MinIO em formato Delta
- permitir operações DML na camada Bronze
- registrar o histórico de alterações no Delta Lake

Este repositório foi validado com a configuração acima em um ambiente local com Spark, Delta e MinIO funcionando corretamente.