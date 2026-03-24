SELECT
  movie_id,
  title,
  genres,
  release_year,
  total_ratings,
  avg_rating
FROM `gen-lang-client-0712416565.netflix_analytical.vw_movies_kpis`
WHERE total_ratings >= 50