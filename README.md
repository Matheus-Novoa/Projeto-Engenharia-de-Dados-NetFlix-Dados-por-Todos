# Data Pipeline - MovieLens (Netflix Data)

Este repositório contém os scripts de engenharia de dados e modelagem analítica para o dataset MovieLens (ml_belief_2024), processado na **Google Cloud Platform (GCP)**.

## 1. Visão Geral

O objetivo deste pipeline é transformar dados brutos de avaliações de filmes em um modelo dimensional estruturado no **BigQuery**, facilitando a criação de dashboards de inteligência de negócios no **Metabase**.

### Arquitetura
1.  **Ingestão:** Dados brutos armazenados no GCS e carregados no BigQuery (`netflix_raw`).
2.  **Processamento:** Limpeza, tipagem e modelagem (Star Schema) no BigQuery (`netflix_analytical`).
3.  **Consumo:** Views otimizadas para leitura por ferramentas de BI.

---

## 2. Modelo de Dados (Schema)

O núcleo analítico segue um esquema estrela simplificado:

### Tabela Dimensão: `dim_movies`
Contém metadados dos filmes.
*   **Origem:** `netflix_raw.raw_movies`
*   **Transformações:** Extração de ano via Regex, conversão de IDs.
*   **Campos Principais:** `movie_id`, `title`, `genres`, `release_year`.

### Tabela Fato: `fact_ratings`
Contém os eventos de avaliação.
*   **Origem:** União de `raw_user_rating_history` e `raw_ratings_for_additional_users`.
*   **Transformações:** Unificação de formatos de timestamp (com e sem timezone), limpeza de strings 'NA', rastreamento de linhagem (`src`).
*   **Campos Principais:** `user_id`, `movie_id`, `rating`, `rating_ts`.

---

## 3. Dicionário de Views Analíticas

As views foram criadas para responder a perguntas de negócio específicas e alimentar gráficos no Metabase.

### Performance de Conteúdo

#### `vw_genre_performance`
*   **Descrição:** Analisa o desempenho por Gênero.
*   **Lógica:** Utiliza `CROSS JOIN UNNEST(SPLIT(genres, '|'))` para contabilizar filmes com múltiplos gêneros individualmente em cada categoria.
*   **Insights:** Identifica gêneros mais populares ou com melhores notas médias.

#### `vw_top_movies`
*   **Descrição:** Ranking dos "Top 10" filmes.
*   **Regra de Negócio:**
    *   Filtra filmes com menos de 20 avaliações para garantir relevância estatística.
    *   Ordena por Nota Média (Decrescente) e depois por Volume.
    *   Limita aos 10 primeiros resultados.

### Comportamento do Usuário

#### `vw_user_activity`
*   **Descrição:** Perfil de atividade dos usuários (User Profiling).
*   **Métricas:**
    *   `total_ratings`: Engajamento total.
    *   `avg_rating`: Tendência do usuário (Crítico vs. Generoso).
    *   `std_rating`: Variedade nas notas dadas.
    *   `first/last_activity_ts`: Ciclo de vida (Churn/Retenção).

### Análises Avançadas e Visuais

#### `vw_movies_kpis`
*   **Descrição:** View base enriquecida. Une a tabela fato com a dimensão de filmes e pré-calcula KPIs fundamentais (Min/Max datas, Contagens, Médias).
*   **Uso:** Serve como fonte de dados "limpa" para outras views (como `vw_top_movies`), evitando joins repetitivos.

#### `vw_scatter_popularity_vs_quality`
*   **Descrição:** Dataset preparado para Gráficos de Dispersão (Scatter Plots).
*   **Filtro:** `total_ratings >= 50` (foco apenas em filmes estabelecidos).
*   **Objetivo:** Correlacionar Popularidade (Eixo X) vs Qualidade (Eixo Y).

#### `vw_ratings_heatmap`
*   **Descrição:** Agregação temporal para Mapas de Calor.
*   **Estrutura:** Agrupamento por Ano e Mês.
*   **Objetivo:** Visualizar sazonalidade e tendências de volume de avaliações ao longo do tempo.

---

## 4. Notas Técnicas

*   **Tratamento de Erros:** Utilização extensiva de `SAFE_CAST` e `SAFE.PARSE_TIMESTAMP` para garantir que dados sujos resultem em `NULL` em vez de falhas no pipeline.
*   **Idempotência:** Scripts utilizam `CREATE OR REPLACE` para permitir reexecuções seguras.
*   **Timezones:** A lógica de timestamp suporta formatos mistos (`%Ez` e `%S`) encontrados nos dados brutos.

---

## 5. Como Executar

1.  Carregue os arquivos brutos no GCS.
2.  Crie as tabelas externas no dataset `netflix_raw`.
3.  Execute o script `tratamento_dados.sql` para criar as tabelas do modelo dimensional.
4.  Execute os scripts da pasta `views/` para criar a camada de visualização.
5.  Conecte o Metabase ao dataset `netflix_analytical`.