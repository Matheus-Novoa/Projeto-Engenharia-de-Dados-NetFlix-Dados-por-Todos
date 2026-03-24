SELECT
  EXTRACT(YEAR FROM rating_ts) AS year,
  EXTRACT(MONTH FROM rating_ts) AS month_number,
  FORMAT_TIMESTAMP('%b', rating_ts) AS month_name,
  COUNT(*) AS total_ratings
FROM `gen-lang-client-0712416565.netflix_analytical.fact_ratings`
GROUP BY year, month_number, month_name
ORDER BY year, month_number