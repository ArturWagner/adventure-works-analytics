<div align="center">

# 🏗️ Arquitetura Moderna de Dados

### AdventureWorks · Airflow · BigQuery · Looker Studio

Pipeline de dados híbrido **on-premises → nuvem**: orquestra o ETL do dataset
**AdventureWorks** (Microsoft) com **Apache Airflow** em Docker, carrega o data
warehouse no **Google BigQuery** e expõe dashboards interativos no **Looker Studio**.

<br>

![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Apache Airflow](https://img.shields.io/badge/Apache_Airflow-2.9.3-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)
![BigQuery](https://img.shields.io/badge/Google_BigQuery-669DF6?style=for-the-badge&logo=googlebigquery&logoColor=white)
![Looker Studio](https://img.shields.io/badge/Looker_Studio-4285F4?style=for-the-badge&logo=looker&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-2022-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

<sub>Engenharia de Software · **Artur Wagner**</sub>

</div>

---

## 📖 Sobre o projeto

Empresas com grandes volumes de dados transacionais enfrentam um desafio recorrente:
os dados ficam **presos em sistemas operacionais** — como um banco SQL Server — sem
estrutura analítica para extrair valor deles. Sem um pipeline, qualquer análise é
manual: exporta, trata em planilha, sem repetibilidade nem rastreabilidade.

Este projeto demonstra, com um dataset real, como uma **arquitetura moderna de dados**
resolve esse problema — automatizando **extração, transformação e carga (ETL)** e
disponibilizando os resultados em dashboards interativos na nuvem, com
**reprodutibilidade, idempotência e rastreabilidade** em cada etapa.

> O dataset **AdventureWorks** simula uma multinacional de vendas com dados de clientes,
> produtos, territórios, promoções e transações — um cenário realista para validar
> toda a arquitetura.

---

## 🏛️ Arquitetura

```
┌──────────────────────┐      ┌───────────────────────────┐      ┌─────────────────────┐
│   ON-PREMISES         │      │         CLOUD (GCP)       │      │    VISUALIZAÇÃO     │
│                       │      │                           │      │                     │
│  ┌────────────────┐   │ ETL  │   ┌───────────────────┐   │ views │  ┌───────────────┐  │
│  │  SQL Server    │───┼─────▶│   │  Google BigQuery  │───┼─────▶│  │ Looker Studio │  │
│  │  AdventureWorks│   │      │   │  (star schema)    │   │      │  │  Dashboards   │  │
│  └────────────────┘   │      │   │  13 tabelas       │   │      │  └───────────────┘  │
│         ▲             │      │   │  4 views          │   │      │                     │
│  ┌──────┴─────────┐   │      │   └───────────────────┘   │      └─────────────────────┘
│  │ Apache Airflow │   │      │                           │
│  │ (Docker Compose)│  │      └───────────────────────────┘
│  └────────────────┘   │
└──────────────────────┘
```

| Camada | Tecnologia | Papel |
|---|---|---|
| **Orquestração** | Apache Airflow + Docker Compose | Roda on-premises; `docker compose up` sobe o ambiente inteiro |
| **Extração** | SQL Server 2022 (em container) | Fonte transacional com o backup AdventureWorks |
| **Data Warehouse** | Google BigQuery | Serverless; armazena o modelo dimensional (star schema) |
| **Visualização** | Looker Studio | Conecta ao BigQuery via conector nativo; dashboards interativos |
| **Linguagens** | Python 3.11 · SQL | DAGs em Python; transformações e DDL em SQL |

---

## 🔄 O pipeline `adventureworks-etl`

A DAG executa em três fases sequenciais, com paralelismo interno e **carga idempotente**
(`WRITE_TRUNCATE` — truncate + insert):

```
load_dimensions  ──▶  load_facts  ──▶  create_bigquery_views
 (11 dims, paralelo)   (2 fatos, paralelo)   (4 views analíticas)
```

1. **`load_dimensions`** — extrai e carrega em **paralelo** as 11 dimensões do SQL Server para o BigQuery.
2. **`load_facts`** — após todas as dimensões, carrega as 2 tabelas de fato (particionadas por data).
3. **`create_bigquery_views`** — cria/atualiza as 4 views analíticas (`CREATE OR REPLACE VIEW`).

> 🔁 **Idempotência:** reexecutar a DAG com os mesmos dados produz exatamente o mesmo
> resultado no BigQuery, sem duplicação.

### Modelo dimensional (star schema)

<table>
<tr><td valign="top" width="50%">

**📊 Tabelas de fato (2)**
- `fact_internet_sales`
- `fact_reseller_sales`

**📈 Views analíticas (4)**
- `vw_vendas_por_categoria`
- `vw_vendas_por_regiao`
- `vw_evolucao_vendas`
- `vw_impacto_promocoes`

</td><td valign="top" width="50%">

**🧩 Dimensões (11)**
- `dim_date` · `dim_customer` · `dim_product`
- `dim_product_subcategory` · `dim_product_category`
- `dim_sales_territory` · `dim_geography`
- `dim_promotion` · `dim_currency`
- `dim_employee` · `dim_reseller`

</td></tr>
</table>

---

## 🚀 Como executar

### Pré-requisitos

- Docker + Docker Compose v2
- Backup `AdventureWorks2022.bak` na raiz do projeto
- Service account do GCP com acesso ao BigQuery

### Passo a passo

```bash
# 1. Clonar e entrar no projeto
git clone git@github.com:ArturWagner/adventure-works-analytics.git
cd adventure-works-analytics

# 2. Configurar variáveis de ambiente
cp .env.example .env
# Gere a Fernet key:
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
# Edite o .env e preencha FERNET_KEY, SECRET_KEY e MSSQL_SA_PASSWORD

# 3. Subir o ambiente
docker compose up -d

# 4. Acessar a UI do Airflow
open http://localhost:8080   # login: admin / admin
```

Na UI do Airflow, configure as **Connections**:

| Connection ID | Tipo | Aponta para |
|---|---|---|
| `mssql_adventureworks` | Microsoft SQL Server | container `sqlserver` |
| `google_cloud_default` | Google Cloud | service account JSON (BigQuery) |

Em seguida, ative e dispare a DAG **`adventureworks-etl`**.

> 🔐 **Credenciais nunca vão para o código.** Chaves GCP, senhas e tokens vivem apenas
> em variáveis de ambiente ou Airflow Connections. O `.env` e o JSON da service account
> **não são versionados**.

---

## 📂 Estrutura do repositório

```
.
├── dags/                  # DAGs Airflow (adventureworks_etl.py, config.py)
├── sql/
│   ├── schema/            # DDL das tabelas BigQuery (fato + dimensão)
│   ├── transforms/        # Queries de transformação (extração do SQL Server)
│   └── views/             # Views analíticas para o Looker Studio
├── scripts/               # entrypoint do SQL Server (restore do .bak)
├── tests/                 # Testes pytest (DAG, schema, views, docs)
├── docs/dashboards/       # Guia de setup do Looker Studio
├── docker-compose.yml     # Postgres + SQL Server + Airflow
├── Dockerfile             # Imagem Airflow + driver ODBC
└── requirements.txt       # Providers Airflow (mssql, google) + pyodbc
```

---

## ✅ Quality Gates

```bash
# Testes unitários
pytest tests/ -v

# Linter Python
ruff check dags/ sql/ tests/

# Validação do Docker Compose
docker compose config --quiet

# Integridade das DAGs (zero import errors)
python -c "from airflow.models import DagBag; db = DagBag('dags/'); assert not db.import_errors, db.import_errors"
```

---

## 👤 Autor

**Artur Wagner** — Engenharia de Software

<div align="center">
<sub>Da extração ao dashboard, com ferramentas open-source e serviços de nuvem.</sub>
</div>
