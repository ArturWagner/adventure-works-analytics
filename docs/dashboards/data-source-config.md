# Configuração das Fontes de Dados — BigQuery → Looker Studio

| View BigQuery | Painel | Dimensões | Métrica |
|---|---|---|---|
| `vw_vendas_por_categoria` | Vendas por Categoria | `category_name`, `subcategory_name` | `sales_amount` |
| `vw_vendas_por_regiao` | Vendas por Região | `country_region`, `territory_region` | `sales_amount` |
| `vw_evolucao_vendas` | Evolução de Vendas | `order_date`, `channel` | `sales_amount` |
| `vw_impacto_promocoes` | Impacto de Promoções | `promotion_name`, `category_name` | `sales_amount` |

## Filtros Globais

| Filtro | Campo | View de origem |
|---|---|---|
| Data | `order_date` | Todas as views |
| Região | `territory_region` | `vw_vendas_por_regiao` |
| Produto | `category_name` | `vw_vendas_por_categoria` |
| Categoria | `subcategory_name` | `vw_vendas_por_categoria` |

## Screenshot de Referência

`docs/dashboards/screenshot-painel-analise.png` — capturar manualmente após configurar o relatório.
Resolução mínima: 1280×720px. Deve mostrar os 4 painéis e os filtros no header.
