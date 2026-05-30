# Painel de Análise de Dados — Looker Studio

Dashboard interativo conectado ao BigQuery (`unigran-tcc.adventureworks`),
exibindo KPIs de vendas do AdventureWorks em 4 painéis com filtros dinâmicos.

## Pré-requisitos

- Conta Google com acesso ao projeto `unigran-tcc` no BigQuery
- Views `vw_vendas_*` criadas no BigQuery (executar DAG `adventureworks-etl`)
- Acesso ao [Looker Studio](https://lookerstudio.google.com)

## 1. Criar Data Sources

Para cada uma das 4 views, criar uma fonte de dados no Looker Studio:

1. Abrir Looker Studio → **Criar** → **Fonte de dados**
2. Selecionar conector **BigQuery**
3. Projeto: `unigran-tcc` → Dataset: `adventureworks`
4. Repetir para cada view:
   - `vw_vendas_por_categoria`
   - `vw_vendas_por_regiao`
   - `vw_evolucao_vendas`
   - `vw_impacto_promocoes`

## 2. Criar Relatório

1. Looker Studio → **Criar** → **Relatório**
2. Adicionar a fonte `vw_vendas_por_categoria` como fonte principal
3. Nomear o relatório: **"AdventureWorks — Análise de Vendas"**
4. Configurar layout de grade 2×2 (4 blocos iguais)

## 3. Configurar Painéis

| Painel | Tipo | Fonte | Dimensão | Métrica |
|--------|------|-------|----------|---------|
| Vendas por Categoria | Gráfico de barras empilhadas | vw_vendas_por_categoria | category_name | sales_amount |
| Vendas por Região | Mapa geográfico | vw_vendas_por_regiao | country_region | sales_amount |
| Evolução de Vendas | Gráfico de linha | vw_evolucao_vendas | order_date | sales_amount |
| Impacto de Promoções | Gráfico de barras empilhadas | vw_impacto_promocoes | promotion_name | sales_amount |

## 4. Configurar Filtros

Adicionar 4 controles de filtro no header, todos aplicados globalmente:

1. **Data** — Controle de intervalo de datas, campo `order_date`
2. **Região** — Lista suspensa, campo `territory_region` (fonte: vw_vendas_por_regiao)
3. **Produto** — Lista suspensa, campo `category_name` (fonte: vw_vendas_por_categoria)
4. **Categoria** — Lista suspensa, campo `subcategory_name` (fonte: vw_vendas_por_categoria)

Configurar cada filtro para **"Aplicar a todos os dados do relatório"**.

## 5. Compartilhar

1. Relatório → **Compartilhar** → **Gerenciar acesso**
2. Definir como **"Qualquer pessoa com o link pode visualizar"**
3. Copiar o link e registrar abaixo

## Link do Relatório

> Preencher após publicação:

**[Painel AdventureWorks — Análise de Vendas](<URL_DO_RELATORIO>)**
