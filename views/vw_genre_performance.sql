WITH exploded AS (
  SELECT
    r.rating,
    genre
  FROM `gen-lang-client-0712416565.netflix_analytical.fact_ratings` r
  JOIN `gen-lang-client-0712416565.netflix_analytical.dim_movies` m
  ON m.movie_id = r.movie_id
  CROSS JOIN UNNEST(SPLIT(COALESCE(m.genres, ''), '|')) AS genre
)
SELECT
  genre,
  COUNT(*) AS total_ratings,
  AVG(rating) AS avg_rating,
  STDDEV(rating) AS std_rating
FROM exploded
WHERE genre IS NOT NULL
AND genre != ''
AND genre != '(no genres listed)'
GROUP BY 1
ORDER BY total_ratings DESC, avg_rating DESC