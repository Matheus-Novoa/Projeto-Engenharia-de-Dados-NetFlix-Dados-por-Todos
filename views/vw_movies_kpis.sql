SELECT
  r.movie_id,
  m.title,
  m.genres,
  m.release_year,
  COUNT(*) AS total_ratings,
  AVG(r.rating) AS avg_rating,
  STDDEV(r.rating) AS std_rating,
  MIN(r.rating_ts) AS first_activity_ts,
  MAX(r.rating_ts) AS last_activity_ts
FROM `gen-lang-client-0712416565.netflix_analytical.fact_ratings` r
LEFT JOIN `gen-lang-client-0712416565.netflix_analytical.dim_movies` m
ON m.movie_id = r.movie_id
GROUP BY 1,2,3,4