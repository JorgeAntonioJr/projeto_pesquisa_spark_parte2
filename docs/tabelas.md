# Tabelas Gerenciadas vs. Não Gerenciadas e Operações DML

## Gerenciamento de Tabelas no Spark

* **Tabelas Gerenciadas (Internas):**
  * O Spark gerencia tanto os dados quanto os metadados.
  * Criadas normalmente a partir de DataFrames.
  * O comando `DROP TABLE` deleta **tanto os dados quanto os metadados**.

* **Tabelas Não Gerenciadas (Externas):**
  * O Spark gerencia apenas os metadados. Os dados ficam em um local externo (como o MinIO).
  * O comando `DROP TABLE` deleta apenas os metadados, **preservando os dados originais**.

---

## Operações DML na Camada Bronze (Delta Lake)
Após salvar os dados no formato Delta Lake no bucket `bronze`, são realizadas as operações DML:

* **INSERT:** Inserção de novos registros nas tabelas Delta.
* **UPDATE:** Atualização de linhas existentes mantendo a consistência ACID.
* **DELETE:** Remoção de dados da camada Bronze.
* **HISTORY / Time Travel:** Consulta ao histórico de versões da tabela para rastreabilidade e auditoria.
