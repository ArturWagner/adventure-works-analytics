# Roteiro de Defesa — TCC: Arquitetura Moderna de Dados
**UNIGRAN 2025 · Artur Wagner · ~13 minutos**

---

## ABERTURA · 1 min

> "Olá, meu nome é **Artur Wagner**. Esse é meu TCC em Engenharia de Software pela UNIGRAN, com o tema **Arquitetura Moderna de Dados com Airflow, BigQuery e Looker Studio**."

---

## 1 · O PROBLEMA · 2,5 min

> "Empresas com grandes volumes de dados transacionais enfrentam um desafio recorrente: os dados ficam **presos em sistemas operacionais** — como um banco SQL Server — sem nenhuma estrutura analítica para extrair valor deles."

> "Sem um pipeline, qualquer análise é feita manualmente: exporta, trata em planilha, sem repetibilidade e sem rastreabilidade. Isso gera **inconsistências, retrabalho e decisões tomadas com dados desatualizados**."

> "A justificativa desse projeto é demonstrar, com um dataset real, como uma **arquitetura moderna de dados** resolve esse problema — automatizando a extração, transformação e carga dos dados (**ETL**) e disponibilizando os resultados em dashboards interativos na nuvem."

> "Usei o dataset **AdventureWorks** da Microsoft — simula uma empresa multinacional de vendas com dados de clientes, produtos, territórios, promoções e transações. Um cenário realista para validar toda a arquitetura."

---

## 2 · FERRAMENTAS UTILIZADAS · 2,5 min

> "A solução foi construída em **três camadas**:"

**Camada 1 — Orquestração on-premises**
> "**Apache Airflow** rodando localmente via **Docker Compose**. Reprodutibilidade total: `docker compose up` sobe o ambiente inteiro. O Airflow expõe uma interface web para monitorar cada execução."

**Camada 2 — Data Warehouse em nuvem**
> "Os dados transformados vão para o **Google BigQuery** — data warehouse serverless do GCP. Armazena as **13 tabelas** no modelo dimensional (**star schema**): 2 tabelas de fato e 11 dimensões, otimizadas para consultas analíticas."

**Camada 3 — Visualização**
> "O **Looker Studio** conecta diretamente ao BigQuery via conector nativo e transforma as views em **dashboards interativos**."

> "Stack: **Python 3.11** para as DAGs, **SQL** para transformações e DDL, **Docker** para o ambiente."

---

## 3 · CASOS DE USO · 2 min

> "Dois atores principais:"

- **Engenheiro de Dados** — opera o Airflow: configura conexões, monitora a DAG, reage a falhas
- **Analista de Dados** — opera o Looker Studio: consome dashboards, filtra por período e território, sem escrever SQL

> "O fluxo principal da DAG `adventureworks-etl`:"

1. **`load_dimensions`** — extrai e carrega em **paralelo** as 11 dimensões do SQL Server para o BigQuery
2. **`load_facts`** — após todas as dimensões, carrega as 2 tabelas de fato
3. **`create_bigquery_views`** — cria ou atualiza as 4 views analíticas para o Looker Studio

> "Critério de qualidade central: o pipeline é **idempotente** — reexecutar com os mesmos dados produz exatamente o mesmo resultado no BigQuery, sem duplicação."

---

## 4 · DEMONSTRAÇÃO · 4,5 min

### 4a · Airflow UI — localhost:8080 · ~1,5 min

- Abrir a DAG `adventureworks-etl`
- Mostrar o **grafo**: task groups `load_dimensions` → `load_facts` → `create_bigquery_views`
- Destacar as tasks em **paralelo** dentro de `load_dimensions`
- Clicar em uma execução bem-sucedida → abrir log de uma task
- Mostrar: linhas extraídas do SQL Server + confirmação de carga no BigQuery

### 4b · Google BigQuery · ~1 min

- Projeto `unigran-tcc` → dataset `adventureworks`
- Mostrar as 13 tabelas carregadas
- Destacar `fact_internet_sales` e `fact_reseller_sales` (**particionadas por data**)
- Mostrar as 4 views: `vw_vendas_por_categoria`, `vw_vendas_por_regiao`, `vw_evolucao_vendas`, `vw_impacto_promocoes`
- Executar um SELECT rápido em uma view

### 4c · Looker Studio · ~1,5 min

- Mostrar o dashboard conectado ao BigQuery
- Demonstrar **evolução de vendas** por canal (Internet vs Revendedores)
- Mostrar **vendas por categoria** de produto
- Aplicar um **filtro de período** para mostrar interatividade

---

## ENCERRAMENTO · 30 seg

> "O projeto demonstra que é possível construir uma arquitetura moderna de dados completa — **da extração ao dashboard** — com ferramentas open-source e serviços de nuvem, garantindo reprodutibilidade, idempotência e rastreabilidade em cada etapa. Obrigado."

---

## TEMPO · REFERÊNCIA RÁPIDA

| Bloco | Tema | Tempo |
|---|---|---|
| Abertura | Apresentação | 1 min |
| 1 | O Problema | 2,5 min |
| 2 | Ferramentas | 2,5 min |
| 3 | Casos de Uso | 2 min |
| 4 | Demonstração | 4,5 min |
| Encerramento | Agradecimento | 0,5 min |
| **Total** | | **~13 min** |

---

## CHECKLIST PRÉ-GRAVAÇÃO

- [ ] `docker compose up -d` — esperar Airflow saudável em localhost:8080
- [ ] Ter uma DAG run recente e bem-sucedida no histórico
- [ ] BigQuery aberto com tabelas e views visíveis
- [ ] Looker Studio aberto e dashboard carregado
- [ ] Testar áudio e compartilhamento de tela
- [ ] Cronometrar ensaio — manter entre 12–14 minutos
