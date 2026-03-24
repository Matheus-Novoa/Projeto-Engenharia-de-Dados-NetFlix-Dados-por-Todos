SELECT
  movie_id,
  title,
  genres,
  release_year,
  total_ratings,
  ROUND(avg_rating,2) AS avg_rating
FROM `gen-lang-client-0712416565.netflix_analytical.vw_movies_kpis`
WHERE total_ratings >= 20
AND avg_rating BETWEEN 0 AND 5
ORDER BY avg_rating DESC, total_ratings DESC
LIMIT 10