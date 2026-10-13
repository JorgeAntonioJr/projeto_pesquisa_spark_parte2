# Pipeline Prático: MinIO, Landing Zone e Camada Bronze

## Escopo da Atividade Prática (Trabalho 2)
Este trabalho implementa o pipeline integrando um banco de dados relacional (ou não relacional) ao object storage **MinIO** com suporte a formato **Delta Lake**.

### Etapas de Implementação:

1. **Extração de Dados (Landing Zone):**
   * Extração de todas as tabelas do banco de dados escolhido.
   * Gravação dos dados no bucket **`landing-zone`** do MinIO.
   * Formato: **CSV** (para banco relacional) ou **JSON** (para não relacional).

2. **Ingestão e Conversão para a Camada Bronze (Delta Lake):**
   * Leitura dos arquivos brutos da `landing-zone` via Apache Spark.
   * Conversão e gravação no formato **Delta Lake** em um novo bucket no MinIO chamado **`bronze`**.

3. **Benefícios Técnicos:**
   * **Armazenamento Escalável:** O MinIO fornece armazenamento resiliente compatível com S3.
   * **Propriedades ACID:** O Delta Lake garante integridade transacional na camada Bronze.
   * **Rastreabilidade e Auditoria:** Possibilidade de auditar o histórico das transformações.
