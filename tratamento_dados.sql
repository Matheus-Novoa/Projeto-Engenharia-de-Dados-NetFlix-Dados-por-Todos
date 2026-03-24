CREATE OR REPLACE TABLE `gen-lang-client-0712416565.netflix_analytical.dim_movies` AS
SELECT
  SAFE_CAST(movieID AS INT64) AS movie_id,
  CAST(title AS STRING) AS title,
  CAST(genres AS STRING) AS genres,
  SAFE_CAST(REGEXP_EXTRACT(CAST(title AS STRING), r'\((\d{4})\)\s*$') AS INT64) AS release_year
FROM `gen-lang-client-0712416565.netflix_raw.raw_movies`;


CREATE OR REPLACE TABLE `gen-lang-client-0712416565.netflix_analytical.fact_ratings` AS
WITH all_ratings AS (

  SELECT
    SAFE_CAST(NULLIF(userId, '') AS INT64) AS user_id,
    SAFE_CAST(NULLIF(movieId, '') AS INT64) AS movie_id,

    SAFE_CAST(NULLIF(NULLIF(rating, 'NA'), '') AS FLOAT64) AS rating,

    COALESCE(
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S%Ez', tstamp),
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', tstamp)
    ) AS rating_ts,

    'user_rating_history' AS src
  
  FROM `gen-lang-client-0712416565.netflix_raw.raw_user_rating_history`

  UNION ALL

  SELECT
    SAFE_CAST(NULLIF(userId, '') AS INT64) AS user_id,
    SAFE_CAST(NULLIF(movieId, '') AS INT64) AS movie_id,

    SAFE_CAST(NULLIF(NULLIF(rating, 'NA'), '') AS FLOAT64) AS rating,

    COALESCE(
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S%Ez', tstamp),
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', tstamp)
    ) AS rating_ts,

    'ratings_for_additional_users' AS src
  
  FROM `gen-lang-client-0712416565.netflix_raw.raw_ratings_for_additional_users`
)

SELECT
  user_id,
  movie_id,
  rating,
  rating_ts,
  src
FROM all_ratings
WHERE user_id IS NOT NULL
  AND movie_id IS NOT NULL
  AND rating IS NOT NULL
  AND rating_ts IS NOT NULL;
  
